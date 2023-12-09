import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/todo-model.dart';
import 'package:todo_list/todo_cubit.dart';
void main() {
  runApp(
    BlocProvider<TodoCubit>(
      create: (context) => TodoCubit(),
      child: TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<TodoCubit>(
        create: (context) => TodoCubit(),
        child: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            if (state is TodoLoaded) {
              final todos = state.todos;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) {
                        context.read<TodoCubit>().toggleTodoStatus(todo.id);
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context.read<TodoCubit>().removeTodoById(todo.id);
                      },
                    ),
                  );
                },
              );
            }

          return Center(
          child: CircularProgressIndicator(),
    );
  },
  ),
  floatingActionButton: FloatingActionButton(
  child: Icon(Icons.add),
  onPressed: () {
  _showAddTodoDialog(context);
  },
  ),
  );
}

void _showAddTodoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      String todoTitle = '';
      return AlertDialog(
        title: Text('Add Todo'),
        content: TextField(
          onChanged: (value) {
            todoTitle = value;
          },
          decoration: InputDecoration(hintText: 'Todo Title'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (todoTitle.isNotEmpty) {
                final todo = Todo(
                  id: DateTime.now().toString(),
                  title: todoTitle,
                );
                context.read<TodoCubit>().addTodo(todo);
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}
}