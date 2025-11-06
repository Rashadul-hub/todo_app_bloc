/*
ISAR TO DO MODAL
Converts to do model into isar to do modal that we can store in our  isar db.
*/

import 'package:isar/isar.dart';
import 'package:todo_app_bloc_pattern/domain/model/todo.dart';

///To generate isar todo object Run : dart run build_runner build
part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;

  /// convert isar object -> pure TODO object to display in our app
  Todo toDomain(){
    return Todo(id: id, text: text, isCompleted: isCompleted);
  }

  /// convert pure TODO object -> isar object to store in isar db
  static TodoIsar fromDomain(Todo todo){
    return TodoIsar()
        ..id = todo.id
        ..text = todo.text
        ..isCompleted = todo.isCompleted;
  }


}




