import 'package:hive/hive.dart';
import 'package:hivedbproject/model/notes_model.dart';

class Boxes {
  static Box<NotesModels> getData() => Hive.box<NotesModels>('notes');
}
