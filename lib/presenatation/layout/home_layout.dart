import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../home/home_screen.dart';
import '../model/AI_model/AI_model/model_AI_screen/upload_screen.dart';
import '../my_plants/my_plants.dart';
import '../recommend/Recommended_weather/recommended_plant.dart';
import '../settings/settings.dart';

class HomeLayout extends StatefulWidget {
  static const String routeName = "home_layout";

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedIndex = 0;

  List<Widget> screenWidgets = [
    HomeScreen(),
    MyPlant(plants: []),
    UploadScreen(),
    RecommendedPlant(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavTheme = theme.bottomNavigationBarTheme;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      body: screenWidgets[selectedIndex],
      bottomNavigationBar: _buildBottomAppBar(context, bottomNavTheme, local),
    );
  }

  Widget _buildBottomAppBar(BuildContext context, BottomNavigationBarThemeData bottomNavTheme, AppLocalizations local) {
    return Container(
      height: 70.h,
      child: BottomAppBar(
        color: bottomNavTheme.backgroundColor,
        padding: EdgeInsets.zero,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          const StadiumBorder(),
        ),
        notchMargin: 8.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0, local.navHome, bottomNavTheme),
              _buildNavItemWithImage("assets/images/Vector.png", 1, local.navMyPlants, bottomNavTheme),
              _buildNavItemWithImage("assets/images/Group.png", 2, local.navServices, bottomNavTheme),
              _buildNavItemWithImage("assets/images/Union.png", 3, local.navRecommended, bottomNavTheme),
              _buildNavItem(Icons.settings, 4, local.navSettings, bottomNavTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label, BottomNavigationBarThemeData bottomNavTheme) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedIndex = index),
        child: SizedBox(
          height: 64.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? bottomNavTheme.selectedItemColor
                    : bottomNavTheme.unselectedItemColor,
                size: 25.w,
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? bottomNavTheme.selectedItemColor
                      : bottomNavTheme.unselectedItemColor,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemWithImage(String assetPath, int index, String label, BottomNavigationBarThemeData bottomNavTheme) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedIndex = index),
        child: SizedBox(
          height: 64.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(assetPath),
                color: isSelected
                    ? bottomNavTheme.selectedItemColor
                    : bottomNavTheme.unselectedItemColor,
                size: 30.w,
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? bottomNavTheme.selectedItemColor
                      : bottomNavTheme.unselectedItemColor,
                  fontSize: 9.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
