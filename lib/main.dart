import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  if (kIsWeb) {
    // Web-specific error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      // Log errors for health checker detection
      print('Platform error: $error');
      return true; // prevent default
    };
  }

  runZonedGuarded(() => runApp(const WebsiteApp()), (error, stack) {
    // Log zone errors for health checker detection
    print('Zone error: $error');
  });
}

class WebsiteApp extends StatefulWidget {
  const WebsiteApp({super.key});

  @override
  State<WebsiteApp> createState() => _WebsiteAppState();
}

class _WebsiteAppState extends State<WebsiteApp> {
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDynamicTheme();
  }

  Future<void> _loadDynamicTheme() async {
    try {
      final data = await DataService.loadWebsiteData();
      final seedColor = AppTheme.getSeedColorForContent(
        data.domain,
        data.title,
        data.description,
      );
      
      setState(() {
        _lightTheme = _buildThemeWithSeed(seedColor, Brightness.light);
        _darkTheme = _buildThemeWithSeed(seedColor, Brightness.dark);
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to default theme
      setState(() {
        _lightTheme = AppTheme.lightTheme;
        _darkTheme = AppTheme.darkTheme;
        _isLoading = false;
      });
    }
  }

  ThemeData _buildThemeWithSeed(Color seedColor, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTheme.buildTextTheme(colorScheme),
      cardTheme: AppTheme.buildCardTheme(),
      appBarTheme: AppTheme.buildAppBarTheme(colorScheme),
      navigationBarTheme: AppTheme.buildNavigationBarTheme(colorScheme),
      navigationRailTheme: AppTheme.buildNavigationRailTheme(colorScheme),
      drawerTheme: AppTheme.buildDrawerTheme(colorScheme),
      listTileTheme: AppTheme.buildListTileTheme(colorScheme),
      chipTheme: AppTheme.buildChipTheme(colorScheme),
      buttonTheme: AppTheme.buildButtonTheme(colorScheme),
      elevatedButtonTheme: AppTheme.buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: AppTheme.buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: AppTheme.buildTextButtonTheme(colorScheme),
      inputDecorationTheme: AppTheme.buildInputDecorationTheme(colorScheme),
      pageTransitionsTheme: AppTheme.buildPageTransitionsTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'Modern Website App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Modern Website App',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme ?? AppTheme.lightTheme,
      darkTheme: _darkTheme ?? AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Design Rule #5: Motion = micro, not flashy
      builder: (context, child) {
        return MediaQuery(
          // Design Rule #8: Accessibility - textScaleFactor up to 1.3+
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3),
          ),
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}

