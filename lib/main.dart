import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivedbproject/home_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'model/notes_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var diractory = await getApplicationDocumentsDirectory();
  Hive.init(diractory.path);
  Hive.registerAdapter(NotesModelsAdapter());
  await Hive.openBox<NotesModels>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
