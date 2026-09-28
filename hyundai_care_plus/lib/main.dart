import 'package:flutter/material.dart';

import 'screens/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const HyundaiCarePlus());
}

class HyundaiCarePlus extends StatelessWidget {
  const HyundaiCarePlus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hyundai Care+',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002C5F),
        ),

        scaffoldBackgroundColor:
            const Color(0xFF020817),

        appBarTheme:
            const AppBarTheme(
          backgroundColor:
              Color(0xFF002C5F),
          foregroundColor:
              Colors.white,
          elevation: 0,
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide:
                BorderSide(
              color:
                  Colors.grey.shade300,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide:
                const BorderSide(
              color:
                  Color(0xFF0D6EFD),
              width: 2,
            ),
          ),
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF002C5F),
            foregroundColor:
                Colors.white,
            minimumSize:
                const Size(
              double.infinity,
              52,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // =====================================================
      // STARTUP
      // =====================================================

      home: const LoadingScreen(),
    );
  }
}