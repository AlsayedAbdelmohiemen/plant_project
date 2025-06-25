import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic/cubit/plants_cubit.dart';
import '../../data/model/plants.dart';
import '../plants_details/plants_details.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> _addedPlants = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlants();
  }

  Future<void> _loadFavoritePlants() async {
    final prefs = await SharedPreferences.getInstance();
    final plantListString = prefs.getString('myPlants');
    if (plantListString != null) {
      final plantList = List<Map<String, dynamic>>.from(jsonDecode(plantListString));
      setState(() {
        _addedPlants.addAll(plantList.map((p) => p['name'] as String));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisSpacing = 8.w;
    final totalHorizontalPadding = 16.w;
    final usableWidth = screenWidth - totalHorizontalPadding - crossAxisSpacing;
    final itemWidth = usableWidth / 2;
    final itemHeight = 260.h;
    final aspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: BlocBuilder<PlantsCubit, PlantsState>(
        builder: (context, state) {
          if (state is PlantsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlantsLoaded) {
            final filteredPlants = state.plants.where((plant) {
              return plant.category?.toLowerCase() == widget.categoryName.toLowerCase();
            }).toList();

            if (filteredPlants.isEmpty) {
              return Center(
                child: Text(
                  local.noPlantsInCategory,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(8.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: aspectRatio,
              ),
              itemCount: filteredPlants.length,
              itemBuilder: (context, index) {
                final plant = filteredPlants[index];
                final isFavorite = _addedPlants.contains(plant.name);

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailsScreen(plant: plant),
                    ),
                  ),
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
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _truncateText(plant.description, 30),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlantDetailsScreen(plant: plant),
                                      ),
                                    ),
                                    child: Text(
                                      local.seeMore,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _addPlantToMyPlants(plant, context, local),
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
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
            );

          } else if (state is PlantsError) {
            return Center(child: Text("${local.errorLoadingPlants}: ${state.message}"));
          }

          return Center(child: Text(local.noPlantsAvailable));
        },
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length <= maxLength ? text : "${text.substring(0, maxLength)}...";
  }

  Future<void> _addPlantToMyPlants(
      PlantsDetail plant, BuildContext context, AppLocalizations local) async {
    final prefs = await SharedPreferences.getInstance();
    final plantListString = prefs.getString('myPlants');
    List<PlantsDetail> myPlants = [];

    if (plantListString != null) {
      final plantList = List<Map<String, dynamic>>.from(jsonDecode(plantListString));
      myPlants = plantList.map((json) => PlantsDetail.fromJson(json)).toList();
    }

    final bool alreadyExists = myPlants.any((p) => p.name == plant.name);

    if (!alreadyExists) {
      myPlants.add(plant);
      await prefs.setString('myPlants', jsonEncode(myPlants.map((p) => p.toJson()).toList()));
      setState(() {
        _addedPlants.add(plant.name);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(local.addedToMyPlants(plant.name)),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(local.alreadyInMyPlants(plant.name)),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
