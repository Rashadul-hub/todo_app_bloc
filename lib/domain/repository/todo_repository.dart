import 'package:todo_app_bloc_pattern/domain/model/todo.dart';

abstract class TodoRepo{
  /// Get List Of Todos
  Future<List<Todo>> getTodos();

  /// Add a new Todoo
  Future<void> addTodo(Todo newTodo);

  /// Update an existing Todoo
  Future<void> updateTodo(Todo newTodo);

  /// Delete a Todoo
  Future<void> deleteTodo(Todo newTodo);

}