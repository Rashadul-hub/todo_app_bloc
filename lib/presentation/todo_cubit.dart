import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc_pattern/domain/model/todo.dart';
import 'package:todo_app_bloc_pattern/domain/repository/todo_repository.dart';

class TodoCubit extends Cubit<List<Todo>>{

  /// Reference todos Repository
  final TodoRepo todoRepo;

  TodoCubit(this.todoRepo) : super([]){
    loadTodos();
  }

  /// L O A D
  Future<void> loadTodos() async{
    // fetch list of todos from repo
    final todoList = await todoRepo.getTodos();

    // emit the fetched list as the new state
    emit(todoList);
  }

  /// A D D
  Future<void> addTodo(String text) async{

    // create a new todos with unique Id
    final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        text: text
    );

    // save the new todos to repository
    await todoRepo.addTodo(newTodo);

    // re-load 
    loadTodos();
  }

  /// D E L E T E
  Future<void> deleteTodo(Todo todo) async{
    // delete the provided todos from repository
    await todoRepo.deleteTodo(todo);
    // re-load
    loadTodos();

  }


  /// T O G G L E
  Future<void> toggleCompletion(Todo todo) async{
    // Toggle the completion status of provided todos
    final updatedTodo = todo.toggleCompletion();

    //update the todos in repository with new completion status
    await todoRepo.updateTodo(updatedTodo);

    // re-load
    loadTodos();
  }
}