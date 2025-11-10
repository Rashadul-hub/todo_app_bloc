import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc_pattern/domain/repository/todo_repository.dart';
import 'package:todo_app_bloc_pattern/presentation/todo_cubit.dart';

import 'todo_view.dart';

class TodoPage extends StatelessWidget {
  final TodoRepo todoRepo;
  const TodoPage({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(context) => TodoCubit(todoRepo),
        child: TodoView());
  }
}
