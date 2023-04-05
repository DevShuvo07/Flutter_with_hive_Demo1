
import 'package:flutter_hive/models/notes_models.dart';
import 'package:hive/hive.dart';

class Boxes{

  static Box<NotesModels> getData() => Hive.box<NotesModels>('Notes');

}