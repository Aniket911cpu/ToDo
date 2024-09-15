import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_service.dart';
import 'auth_service.dart';

class TodoPage extends StatelessWidget {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(labelText: 'New Todo'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Provider.of<TodoService>(context, listen: false).addTodo(_todoController.text);
                    _todoController.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoService>(
              builder: (context, todoService, _) {
                return StreamBuilder(
                  stream: todoService.todos,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return ListTile(
                          title: Text(doc['title']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              todoService.deleteTodo(doc.id);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}