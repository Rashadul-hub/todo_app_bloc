import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app_bloc_pattern/data/models/isar_todo.dart';
import 'package:todo_app_bloc_pattern/data/repository/isar_todo_repo.dart';
import 'package:todo_app_bloc_pattern/domain/repository/todo_repository.dart';
import 'package:todo_app_bloc_pattern/presentation/todo_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  /// Get Directory Path for storing data
  final dir = await getApplicationDocumentsDirectory();
  
  /// Open Isar Database
  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);

  /// Initialize the Repository with Isar Database
  final isarTodoRepo = IsarTodoRepo(isar);

  /// Run The App
  runApp(MyApp(todoRepo: isarTodoRepo));
}

class MyApp extends StatelessWidget {
  /// Database Injection through the App
  final TodoRepo todoRepo;

  const MyApp({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home:  TodoPage(todoRepo: todoRepo),
    );
  }
}

