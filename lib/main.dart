import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd8_library_xxxx/home_page.dart';
import 'package:gd8_library_xxxx/test.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        Device.orientation == Orientation.portrait
            ? Container(
                // Widget for Portrait
                width: 100.w,
                height: 20.5.h,
              )
            : Container(
                // Widget for Landscape
                width: 100.w,
                height: 12.5.h,
              );
        Device.screenType == ScreenType.tablet
            ? Container(
                // Widget for Tablet
                width: 100.w,
                height: 20.5.h,
              )
            : Container(
                // Widget for Mobile
                width: 100.w,
                height: 12.5.h,
              );
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber).copyWith(
              secondary: Colors.amberAccent,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}
