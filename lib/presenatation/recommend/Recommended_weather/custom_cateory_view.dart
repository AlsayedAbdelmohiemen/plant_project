import 'package:flutter/material.dart';
import '../../../data/model/plants.dart';
import '../../auth/constant..dart';
import '../../plants_details/plants_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomCategoryView extends StatelessWidget {
  final PlantsDetail plant; // Accept the entire plant object

  const CustomCategoryView({
    Key? key,
    required this.plant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color:Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
                bottom: Radius.circular(5)),
            child: Image.network(
              plant.image.secureUrl, // Use image from plant object
              width: double.infinity,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plant.name, // Use name from plant object
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      plant.description, // Use description from plant
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlantDetailsScreen(plant: plant), // Pass plant
                        ),
                      );
                    },
                    child: Text(
                      local.seeMore,
                      style: TextStyle(
                        fontSize: 12,
                        color: Constants.greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}