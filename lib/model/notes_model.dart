import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModels extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  NotesModels({required this.title, required this.description});
}
