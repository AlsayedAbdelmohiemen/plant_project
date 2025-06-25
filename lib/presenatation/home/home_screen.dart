import 'dart:convert';
import 'package:final2/presenatation/home/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic/cubit/plants_cubit.dart';
import '../../data/model/category.dart';
import '../../data/model/plants.dart';
import '../category_screen/category_screen.dart';
import '../my_plants/plant_api_service.dart';
import '../plants_details/plants_details.dart';
import '../weather/weather_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _addedPlants = [];
  final ApiServicess _apiService = ApiServicess(); // Create ApiServicess instance

  @override
  void initState() {
    super.initState();
    context.read<PlantsCubit>().fetchPlants();
    _loadAddedPlants();
  }

  Future<void> _loadAddedPlants() async {
    try {
      final plants = await _apiService.getMyPlants();
      setState(() {
        _addedPlants = plants.map((plant) => plant.name).toList();
      });
    } catch (e) {
      // Fallback to local storage if API fails
      final prefs = await SharedPreferences.getInstance();
      final plantListString = prefs.getString('myPlants');
      if (plantListString != null) {
        final plantList = List<Map<String, dynamic>>.from(jsonDecode(plantListString));
        setState(() {
          _addedPlants = plantList.map((json) => PlantsDetail.fromJson(json).name).toList();
        });
      }
    }
  }

  Future<void> _addPlantToMyPlants(PlantsDetail plant, BuildContext context, AppLocalizations local) async {
    try {
      // Check if plant is already added
      if (_addedPlants.contains(plant.name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(local.alreadyInMyPlants(plant.name)),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Add to backend
      await _apiService.addMyPlant(plant.id);

      // Update local state
      setState(() {
        _addedPlants.add(plant.name);
      });

      // Also save to SharedPreferences as fallback
      final prefs = await SharedPreferences.getInstance();
      final plantListString = prefs.getString('myPlants');
      List<PlantsDetail> myPlants = [];

      if (plantListString != null) {
        final plantList = List<Map<String, dynamic>>.from(jsonDecode(plantListString));
        myPlants = plantList.map((json) => PlantsDetail.fromJson(json)).toList();
      }

      if (!myPlants.any((p) => p.name == plant.name)) {
        myPlants.add(plant);
        await prefs.setString('myPlants', jsonEncode(myPlants.map((p) => p.toJson()).toList()));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(local.addedToMyPlants(plant.name)),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${local.failedToAddPlant}: ${e.toString()}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: 36.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: local.searchHint,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _buildIconBtn(
                    context,
                    icon: Icons.cloud_outlined,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherPage())),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(local.categories,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            _buildCategorySelector(),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(local.featuredPlants,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: BlocBuilder<PlantsCubit, PlantsState>(
                builder: (context, state) {
                  if (state is PlantsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PlantsLoaded) {
                    return _buildPlantsGrid(context, state.plants, local);
                  } else if (state is PlantsError) {
                    return Center(child: Text("${local.errorLoadingPlants}: ${state.message}"));
                  }
                  return Center(child: Text(local.noPlantsAvailable));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBtn(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 24.w, color: Colors.grey[600]),
        padding: EdgeInsets.all(10.w),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SizedBox(
        height: 80.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryScreen(categoryName: category.name)),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).canvasColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        category.imageUrl,
                        width: 80.w,
                        height: 60.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Flexible(
                      child: Text(
                        category.name,
                        style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlantsGrid(BuildContext context, List<PlantsDetail> plants, AppLocalizations local) {
    final screenWidth = MediaQuery.of(context).size.width;
    final usableWidth = screenWidth - 16.w * 2 - 8.w;
    final itemWidth = usableWidth / 2;
    final itemHeight = 280.h;
    final aspectRatio = itemWidth / itemHeight;

    return Padding(
      padding: EdgeInsets.all(8.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: aspectRatio,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          final isFavorite = _addedPlants.contains(plant.name);

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailsScreen(plant: plant))),
            child: Card(
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    child: Image.network(
                      plant.image.secureUrl,
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _truncateText(plant.description, 30),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailsScreen(plant: plant))),
                              child: Text(
                                local.seeMore,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _addPlantToMyPlants(plant, context, local),
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                                size: 18.w,
                                color: isFavorite ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length <= maxLength ? text : "${text.substring(0, maxLength)}...";
  }
}
