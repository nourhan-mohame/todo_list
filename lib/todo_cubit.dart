import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/todo-model.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  void addTodo(Todo todo) {
    final currentState = state;
    if (currentState is TodoLoaded) {
      final updatedTodos = List<Todo>.from(currentState.todos)..add(todo);
      emit(TodoLoaded(updatedTodos));
    }
  }

  void toggleTodoStatus(String todoId) {
    final currentState = state;
    if (currentState is TodoLoaded) {
      final updatedTodos = currentState.todos.map((todo) {
        if (todo.id == todoId) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();
      emit(TodoLoaded(updatedTodos));
    }
  }

  void removeTodoById(String todoId) {
    final currentState = state;
    if (currentState is TodoLoaded) {
      final updatedTodos =
      currentState.todos.where((todo) => todo.id != todoId).toList();
      emit(TodoLoaded(updatedTodos));
    }
  }
}