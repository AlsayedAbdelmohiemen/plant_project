import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../business_logic/bording_cubit/bording_cubit.dart';
import 'Onboarding_item.dart';

import 'custom_back_buttom.dart';
import 'custom_button.dart';
import 'onbording_screen.dart';


class OnboardingPageView extends StatelessWidget {
  final List<OnboardingItem> onboardingItems;
  static const String routeName = "onboarding";

  OnboardingPageView({required this.onboardingItems});

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    final local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, int>(
          builder: (context, currentIndex) {
            return Stack(
              children: [
                // The PageView for the onboarding content
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w), // Adjusted padding using .h and .w
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (currentIndex > 0) // Show Back on second (1) and third (2) pages
                            CustomBackButton(
                              onPressed: () {
                                // Go back to the previous page
                                if (currentIndex > 0) {
                                  _controller.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            )
                          else
                            SizedBox(width: 48.w), // Add space to align Skip on first page (no Back) using .w

                          if (currentIndex < 2) // Hide Skip on the third page
                            TextButton(
                              onPressed: () => context.read<OnboardingCubit>().skip(_controller),
                              child: Text(
                                local.skip,
                                style: TextStyle(
                                color:   Theme.of(context).primaryColor,
                                  fontSize: 16.sp, // Adjusted font size using .sp
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            SizedBox(width: 48.w), // Add space to keep layout aligned when Skip is hidden using .w
                        ],
                      ),
                    ),

                    // Onboarding content (image + text)
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (index) {
                          context.read<OnboardingCubit>().setCurrentIndex(index);
                        },
                        itemCount: onboardingItems.length,
                        itemBuilder: (context, index) {
                          return OnboardingScreen(item: onboardingItems[index]);
                        },
                      ),
                    ),
                  ],
                ),

                // Custom Next Button with progress and navigation
                Positioned(
                  bottom: 20.h, // Adjusted bottom position using .h
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CustomNextButton(
                      controller: _controller,
                      page: currentIndex,
                      totalPages: onboardingItems.length,
                      showAnimatedContainerCallBack: (bool show) {
                        // Define your custom logic here
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}