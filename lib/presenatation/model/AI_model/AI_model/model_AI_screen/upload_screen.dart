import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../prediction_provider.dart';
import 'error_screen.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  static const String routeName = 'UploadScreen';
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _submit() async {
    if (_selectedImage == null) return;

    final provider = Provider.of<PredictionProvider>(context, listen: false);
    await provider.predictImage(_selectedImage!);

    if (provider.result != null) {
      // Success: Navigate to ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(imageFile: _selectedImage!),
        ),
      );
    } else {
      // Error: Navigate to ErrorScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ErrorScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<PredictionProvider>(context).isLoading;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(local.aiPlantChecker),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _selectedImage == null
                  ? buildUploadCard(local)
                  : Stack( // Wrap with Stack to overlay the remove button
                alignment: Alignment.topRight, // Align button to top right
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.file(
                      _selectedImage!,
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned( // Use Positioned for precise placement
                    top: 8.h, // Adjust spacing as needed
                    right: 8.w, // Adjust spacing as needed
                    child: InkWell( // Use InkWell for tap effect
                      onTap: _removeImage,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Semi-transparent background
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 138.h),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: const Color(0xFF335540)))
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: _submit, // Keep this disabled if no image is selected
                child: Text(
                  local.checkPlant,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadCard(AppLocalizations local) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color:  Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5.w,
                ),
              ),
              child: Icon(Icons.upload, size: 28.sp, color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 16.h),
            Text(
              local.upload,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              local.chooseImages,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9E9E9E),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              local.uploadFormats,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}