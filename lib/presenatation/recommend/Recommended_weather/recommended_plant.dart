import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/plants.dart';
import '../plant_api_service.dart';
import 'custom_cateory_view.dart';

class RecommendedPlant extends StatelessWidget {
  RecommendedPlant({super.key});

  Future<List<PlantsDetail>> fetchRecommendedPlants() async {
    final api = ApiServices();
    final suggestedIds = await api.getRecommendedPlantIds();
    final allPlants = await api.getAllPlants();
    return allPlants.where((plant) => suggestedIds.contains(plant.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          local.recommendedPlants, // 🔁 Localized title
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
      body: FutureBuilder<List<PlantsDetail>>(
        future: fetchRecommendedPlants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${local.error}: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(local.noRecommendedPlants));
          }

          final plants = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(10.w),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 10.h,
              ),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                return CustomCategoryView(plant: plants[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
