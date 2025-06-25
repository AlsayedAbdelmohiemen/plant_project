import 'dart:io';
import 'package:final2/presenatation/settings/privacy_policy_page.dart';
import 'package:final2/presenatation/settings/security.dart';
import 'package:final2/presenatation/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic/image_cubit/image_profile_cubit.dart';
import '../../business_logic/image_cubit/image_profile_state.dart';
import '../../business_logic/profile_cubit/profile_cubit.dart';
import '../auth/Auth/Login/login.dart';
import '../auth/Auth/sharedPrefrence/shared_pref.dart';
import 'package:image/image.dart' as img;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isPickingImage = false;
  final int _maxFileSizeInBytes = 2 * 1024 * 1024; // 2MB

  Future<void> _logout(BuildContext context) async {
    final local = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(local.logout,style: Theme.of(context).textTheme.bodyMedium,),
          content: Text(local.areYouSureYouWantToLogout,style: Theme.of(context).textTheme.bodyMedium,),
          actions: <Widget>[
            TextButton(
              child: Text(local.no,style:TextStyle(color:Theme.of(context).primaryColor ) ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(local.yes,style:TextStyle(color:Theme.of(context).primaryColor ) ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await SharedPreference.clearAllData();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>  LoginPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  Future<File?> _compressImage(File imageFile) async {
    try {
      final image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return null;

      int quality = 80;
      final originalSize = await imageFile.length();
      if (originalSize > _maxFileSizeInBytes) {
        quality = ((_maxFileSizeInBytes / originalSize) * 100).round();
        if (quality < 10) quality = 10;
      }

      final compressedBytes = img.encodeJpg(image, quality: quality);
      final tempDir = await getTemporaryDirectory();
      final compressedFile = File('${tempDir.path}/compressed_image.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.profileSettings),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Card(
                color: theme.scaffoldBackgroundColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, profileState) {
                      if (profileState is ProfileLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              local.profile.toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                letterSpacing: 1.2,
                                fontSize: 12.sp,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                BlocBuilder<ProfileImageCubit, ProfileImageState>(
                                  builder: (context, imageState) {
                                    if (imageState is ProfileImageLoading) {
                                      return CircleAvatar(radius: 30.r, child: CircularProgressIndicator());
                                    } else if (imageState is ProfileImageFailure) {
                                      return CircleAvatar(
                                        radius: 30.r,
                                        backgroundColor: theme.colorScheme.errorContainer,
                                        child: Icon(Icons.error, color: theme.colorScheme.error, size: 24.w),
                                      );
                                    }

                                    return FutureBuilder<String?>(
                                      future: SharedPreference.getImagePath(),
                                      builder: (context, snapshot) {
                                        final localImagePath = snapshot.data;
                                        ImageProvider imageProvider;

                                        if (imageState is ProfileImageSuccess && imageState.image.secureUrl != null) {
                                          imageProvider = NetworkImage(imageState.image.secureUrl!);
                                        } else if (localImagePath != null && File(localImagePath).existsSync()) {
                                          imageProvider = FileImage(File(localImagePath));
                                        } else {
                                          imageProvider = const AssetImage('assets/images/Image_profile.jpg');
                                        }

                                        return CircleAvatar(
                                          radius: 30.r,
                                          backgroundColor: theme.colorScheme.primaryContainer,
                                          backgroundImage: imageProvider,
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profileState.profile.data?.userName ?? 'No Name',
                                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        profileState.profile.data?.email ?? 'No email',
                                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Account Section
              _buildSectionCard(
                context,
                title: local.account,
                children: [
                  _buildSettingItem(context,
                      icon: Icons.person_outline,
                      title: local.editProfile,
                      onTap: () => _pickImage(context)
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Preferences Section
              _buildSectionCard(
                context,
                title: local.preferences,
                children: [
                  _buildSettingItem(context,
                      icon: Icons.settings_outlined,
                      title: local.settings,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                      }
                  ),
                  _buildSettingItem(context,
                      icon: Icons.security_outlined,
                      title: local.security,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityPage()));
                      }
                  ),
                  _buildSettingItem(context,
                      icon: Icons.privacy_tip_outlined,
                      title: local.privacyPolicy,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()));
                      }
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Logout Card
              Card(
                color: theme.scaffoldBackgroundColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                child: _buildSettingItem(
                  context,
                  icon: Icons.logout,
                  title: local.logout,
                  isLogout: true,
                  onTap: () => _logout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.2,
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Icon(icon, color: theme.primaryColor, size: 24.w),
      title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.sp)),
      trailing: isLogout ? null : Icon(Icons.chevron_right, color: theme.primaryColor, size: 20.w),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final local = AppLocalizations.of(context)!;
    if (_isPickingImage) return;

    setState(() => _isPickingImage = true);
    try {
      final userId = context.read<ProfileCubit>().state is ProfileLoaded
          ? (context.read<ProfileCubit>().state as ProfileLoaded).profile.data?.iV?.toString()
          : null;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(local.userIdMissing, style: TextStyle(fontSize: 14.sp)),
        ));
        return;
      }

      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 80
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        final compressedImageFile = await _compressImage(imageFile);

        if (compressedImageFile != null) {
          await SharedPreference.saveImagePath(compressedImageFile.path);
          context.read<ProfileImageCubit>().updateProfileImage(compressedImageFile, userId);
        } else {
          context.read<ProfileImageCubit>().emit(ProfileImageFailure(local.imageCompressionFailed));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(local.imagePickFailed, style: TextStyle(fontSize: 14.sp)),
      ));
    } finally {
      setState(() => _isPickingImage = false);
    }
  }
}