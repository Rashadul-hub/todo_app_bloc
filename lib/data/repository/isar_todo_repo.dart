/*
DATABASE REPO

This implements the TodoRepo and handles storing, retrieving, updating
Deleting in the isar database.

*/

import 'package:isar/isar.dart';
import 'package:todo_app_bloc_pattern/data/models/isar_todo.dart';
import 'package:todo_app_bloc_pattern/domain/repository/todo_repository.dart';

import '../../domain/model/todo.dart';

class IsarTodoRepo implements TodoRepo{
  final Isar db;
  IsarTodoRepo(this.db);

  //Get TODOS
  @override
  Future<List<Todo>> getTodos()async{
    // Fetch From DB 
    final todos = await db.todoIsars.where().findAll();
    
    //Return as a list of todos and give to domain layer 
    return todos.map((todoIsar) => todoIsar.toDomain()).toList();
  }

  //ADD TODOS
  @override
  Future<void> addTodo(Todo newTodo) {
    final todoIsar = TodoIsar.fromDomain(newTodo);
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  //Delete TODOS
  @override
  Future<void> deleteTodo(Todo todo)async{
     await db.writeTxn(() => db.todoIsars.delete(todo.id));
  }

  //Update TODOS
  @override
  Future<void> updateTodo(Todo newTodo) {
    final todoIsar = TodoIsar.fromDomain(newTodo);
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

}