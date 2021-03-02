import 'file:///C:/Users/davic/Desktop/workSpaceFlutter/refactor_dog_app/lib/presentation/pages/splash/splash_screen.dart';
import 'package:dog_app/presentation/app_themes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DoggoApp",
      theme: AppThemes.appTheme,
      home: SplashScreen(),
    );
  }
}
