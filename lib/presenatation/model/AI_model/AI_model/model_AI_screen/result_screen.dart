import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../prediction_provider.dart';
import 'upload_screen.dart';

class ResultScreen extends StatelessWidget {
  final File imageFile;

  const ResultScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<PredictionProvider>(context).result;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(local.diagnosisResult),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: result == null
          ? Center(child: Text(local.noDataFound))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            SizedBox(height: 18.h),
            _buildResultTitle(local),
            SizedBox(height: 18.h),
            _buildResultCard(context, result, local),
            SizedBox(height: 25.h),
            _buildActionButton(context, local),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.file(
        imageFile,
        height: 200.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildResultTitle(AppLocalizations local) {
    return Center(
      child: Text(
        local.result,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, dynamic result, AppLocalizations local) {
    return Card(
      color: Theme.of(context).canvasColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlantInfoRow(context, result, local),
            SizedBox(height: 16.h),
            const Divider(color: Colors.black12, thickness: 1),
            SizedBox(height: 16.h),
            _buildInfoSection(local.disease, result.disease),
            SizedBox(height: 16.h),
            const Divider(color: Colors.black12, thickness: 1),
            SizedBox(height: 16.h),
            _buildInfoSection(local.advice, result.treatment),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantInfoRow(BuildContext context, dynamic result, AppLocalizations local) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.plant,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                result.plant,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.confidence,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                result.confidence,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          content,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, AppLocalizations local) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          local.uploadNewImage,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
