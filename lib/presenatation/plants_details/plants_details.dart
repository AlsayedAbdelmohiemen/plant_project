import 'package:flutter/material.dart';
import 'package:final2/data/model/plants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic/theme_cubit/theme_cubit.dart';
import '../my_plants/my_plants.dart';
import '../my_plants/plant_api_service.dart';

class PlantDetailsScreen extends StatefulWidget {
  final PlantsDetail plant;

  const PlantDetailsScreen({super.key, required this.plant});

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  bool _isExpanded = false;
  bool _isAddingToMyPlant = false;
  final ApiServicess _apiService = ApiServicess(); // Create ApiServicess instance

  Future<void> _addToMyPlant(BuildContext context, AppLocalizations local) async {
    setState(() {
      _isAddingToMyPlant = true;
    });

    try {
      // Add to backend
      await _apiService.addMyPlant(widget.plant.id);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(local.addedToMyPlants(widget.plant.name)),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      // Navigate to MyPlant screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPlant(plants: [widget.plant]),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${local.failedToAddPlant}: ${e.toString()}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAddingToMyPlant = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(local.plantDetails),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(widget.plant),
            _buildDescriptionSection(widget.plant, local),
            _buildKeyInformationSection(widget.plant, local),
            _buildActionButton(local),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(PlantsDetail plant) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            plant.image.secureUrl,
            height: 200.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                plant.name,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              plant.scientificName,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(PlantsDetail plant, AppLocalizations local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          local.description,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          _isExpanded ? plant.description : _truncateText(plant.description, 50),
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        if (plant.description.length > 50)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? local.seeLess : local.seeMore,
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}...";
  }

  Widget _buildKeyInformationSection(PlantsDetail plant, AppLocalizations local) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          local.keyInformation,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: _buildKeyInfoCard(
                  label: _getLabel(index, local),
                  value: _getValue(index),
                  iconPath: _getIconPath(index, isDarkMode),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKeyInfoCard({
    required String label,
    required String value,
    required String iconPath,
  }) {
    return Card(
      color: Theme.of(context).canvasColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 32.w, height: 32.h, fit: BoxFit.contain),
            SizedBox(height: 8.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getLabel(int index, AppLocalizations local) {
    switch (index) {
      case 0: return local.watering;
      case 1: return local.soilType;
      case 2: return local.origin;
      case 3: return local.temperature;
      default: return "";
    }
  }

  String _getValue(int index) {
    switch (index) {
      case 0: return widget.plant.wateringFrequency;
      case 1: return widget.plant.soilType;
      case 2: return widget.plant.origin;
      case 3: return "${widget.plant.temperatureRange.min} - ${widget.plant.temperatureRange.max}°C";
      default: return "";
    }
  }

  String _getIconPath(int index, bool isDarkMode) {
    switch (index) {
      case 0:
        return isDarkMode
            ? 'assets/images/carbon_humidity (1)dark.png'
            : 'assets/images/carbon_humidity.png';
      case 1:
        return isDarkMode
            ? 'assets/images/sustainable-agriculture.png'
            : 'assets/images/sustainable-agriculture (1)dark.png';
      case 2:
        return isDarkMode
            ? 'assets/images/simple-icons_origin ()dark.png'
            : 'assets/images/simple-icons_origin.png';
      case 3:
        return isDarkMode
            ? 'assets/images/solar_temperature-outline ()dark.png'
            : 'assets/images/solar_temperature-outline.png';
      default:
        return '';
    }
  }

  Widget _buildActionButton(AppLocalizations local) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: ElevatedButton(
          onPressed: _isAddingToMyPlant ? null : () => _addToMyPlant(context, local),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
          child: _isAddingToMyPlant
              ? SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: Colors.white,
            ),
          )
              : Text(
            local.addToMyPlant,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      ),
    );
  }

}
