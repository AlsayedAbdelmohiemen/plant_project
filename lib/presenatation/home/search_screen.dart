import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic/cubit/plants_cubit.dart';
import '../plants_details/plants_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(local.searchPlants),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: local.searchHint,
                prefixIcon: const Icon(Icons.search, color: Color(0xFFBDBDBD)),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: Theme.of(context).canvasColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: Theme.of(context).canvasColor, width: 2.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PlantsCubit, PlantsState>(
              builder: (context, state) {
                if (state is PlantsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PlantsLoaded) {
                  final results = _searchQuery.isEmpty
                      ? state.plants
                      : state.plants.where((plant) {
                    return plant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        plant.scientificName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        plant.description.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (results.isEmpty) {
                    return Center(
                      child:Text(
                        _searchQuery.isEmpty
                            ? local.searchForPlants
                            : local.noResultsFound(_searchQuery),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                    );
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final plant = results[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            plant.image.secureUrl,
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          plant.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          plant.scientificName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PlantDetailsScreen(plant: plant)),
                          );
                        },
                      );
                    },
                  );
                } else if (state is PlantsError) {
                  return Center(child: Text(local.errorLoadingPlants));
                }
                return Center(child: Text(local.noPlantsAvailable));
              },
            ),
          ),
        ],
      ),
    );
  }
}
