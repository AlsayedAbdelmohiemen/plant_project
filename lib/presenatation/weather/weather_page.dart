import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // localization import
import '../../business_logic/weather_cubit/weather_cubit.dart';
import '../../business_logic/weather_cubit/weather_state.dart';
import '../../constants/utils/weather_utils.dart';
import '../../data/model/weather_model.dart';
import 'weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(weatherService: WeatherService())..fetchWeather(),
      child: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is WeatherError) {
            return Scaffold(
              body: Center(child: Text(state.message, style: const TextStyle(color: Colors.white))),
            );
          } else if (state is WeatherLoaded) {
            WeatherModel weather = state.weather;
            final local = AppLocalizations.of(context)!;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              extendBodyBehindAppBar: true,
              body: Container(
                decoration: BoxDecoration(
                  gradient: getBackgroundGradient(weather.description),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),

                        // Localized country & city
                        Text(
                          weather.country,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          weather.city,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 10.h),

                        Flexible(
                          child: Image.asset(
                            getWeatherIconPath(weather.description),
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.cloud_off_outlined,
                                  size: 100.w, color: Colors.white70);
                            },
                          ),
                        ),

                        SizedBox(height: 10.h),

                        Text(
                          '${weather.temperature.round()}°',
                          style: TextStyle(
                            fontSize: 60.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(1, 2),
                              )
                            ],
                          ),
                        ),

                        Text(
                          weather.description,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                        local.maxTemp(weather.maxTemperature.round().toString()),

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                                local.minTemp(weather.minTemperature.round().toString()
                            ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: _buildInfoCard(
                                  context: context,
                                  icon: Icons.water_drop_outlined,
                                  title: local.humidity,
                                  value: '${weather.humidity}%',
                                  cardColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: _buildInfoCard(
                                  context: context,
                                  icon: Icons.thermostat_outlined,
                                  title: local.feelsLike,
                                  value: '${weather.feelsLike.toStringAsFixed(1)}°C',
                                  cardColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.blueGrey,
              body: Center(
                child: Text(
                  AppLocalizations.of(context)!.noData,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color cardColor,
  }) {
    return Container(
      width: 150.w,
      height: 150.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32.sp),
          SizedBox(height: 12.h),
          Text(
            title,
            textAlign: title.length > 10 ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
