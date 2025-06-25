import 'dart:convert';
import 'package:final2/presenatation/my_plants/plant_api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final2/data/model/plants.dart';
import '../plants_details/plants_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPlant extends StatefulWidget {
  final List<PlantsDetail> plants;

  const MyPlant({super.key, required this.plants});

  @override
  State<MyPlant> createState() => _MyPlantState();
}

class _MyPlantState extends State<MyPlant> {
  List<PlantsDetail> myPlants = [];
  Map<String, bool> expandedStates = {};
  final ApiServicess _apiService = ApiServicess(); // Create ApiService instance

  @override
  void initState() {
    super.initState();
    _initializePlants();
  }

  Future<void> _initializePlants() async {
    await _loadPlants();
    // Sync with backend if needed
    try {
      final backendPlants = await _apiService.getMyPlants();
      setState(() {
        myPlants = backendPlants;
        for (final plant in myPlants) {
          expandedStates[plant.name] = false;
        }
      });
      await _savePlants();
    } catch (e) {
      // Fallback to local storage if API fails
      for (final plant in widget.plants) {
        if (!myPlants.any((p) => p.name == plant.name)) {
          _addPlant(plant, showSnackbar: false, syncWithBackend: false);
        }
      }
    }
  }

  Future<void> _savePlants() async {
    final prefs = await SharedPreferences.getInstance();
    final plantList = myPlants.map((plant) => plant.toJson()).toList();
    await prefs.setString('myPlants', jsonEncode(plantList));
  }

  Future<void> _loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final plantListString = prefs.getString('myPlants');
    if (plantListString != null) {
      final plantList = List<Map<String, dynamic>>.from(jsonDecode(plantListString));
      setState(() {
        myPlants = plantList.map((json) => PlantsDetail.fromJson(json)).toList();
        for (final plant in myPlants) {
          expandedStates[plant.name] = false;
        }
      });
    }
  }

  Future<void> _addPlant(PlantsDetail plant, {bool showSnackbar = true, bool syncWithBackend = true}) async {
    bool alreadyExists = myPlants.any((p) => p.name == plant.name);

    if (!alreadyExists) {
      try {
        if (syncWithBackend) {
          await _apiService.addMyPlant(plant.id);
        }
        setState(() {
          myPlants.add(plant);
          expandedStates[plant.name] = false;
        });
        await _savePlants();
        if (showSnackbar) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${plant.name} added to My Plants'),
              duration: Duration(seconds: 2),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      } catch (e) {
        if (showSnackbar) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add plant: ${e.toString()}'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (showSnackbar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${plant.name} is already in My Plants'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removePlant(PlantsDetail plant) async {
    try {
      await _apiService.deleteMyPlant(plant.id);
      setState(() {
        myPlants.remove(plant);
        expandedStates.remove(plant.name);
      });
      await _savePlants();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${plant.name} removed from My Plants'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove plant: ${e.toString()}'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(local.myPlants),
        elevation: 0,
      ),
      body: myPlants.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              local.noPlantsAdded,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: myPlants.length,
        itemBuilder: (context, index) {
          final plant = myPlants[index];
          final isExpanded = expandedStates[plant.name] ?? false;

          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    _removePlant(plant);
                  },
                  backgroundColor: Colors.red,
                  borderRadius: BorderRadius.circular(18.r),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: local.delete,
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailsScreen(plant: plant),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              plant.image.secureUrl,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plant.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  isExpanded
                                      ? plant.description
                                      : _truncateText(plant.description, 50),
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 8.h),
                                if (plant.description.length > 50)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        expandedStates[plant.name] = !isExpanded;
                                      });
                                    },
                                    child: Text(
                                      isExpanded ? local.seeLess : local.seeMore,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _addPlant(plant);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}