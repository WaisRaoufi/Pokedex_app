
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_app/pages/home_page.dart';
import 'package:pokedex_app/services/database_service.dart';
import 'package:pokedex_app/services/http_service.dart';

void main() async {
  await _setupServices();
  runApp(ProviderScope(child: const MyApp()));
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeDex',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
        textTheme: GoogleFonts.quattrocentoSansTextTheme(),
      ),
      home: HomePage(),
    );
  }
}
