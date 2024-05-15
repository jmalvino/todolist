import 'package:flutter/material.dart';
import 'package:lista_de_contas/models/todo.dart';
import 'package:lista_de_contas/repository/todo_forget_respository.dart';
import 'package:lista_de_contas/widgets/todo_list_item.dart';

class TodoListForgetPage extends StatefulWidget {
  const TodoListForgetPage({super.key});

  @override
  State<TodoListForgetPage> createState() => _TodoListForgetPageState();
}

class _TodoListForgetPageState extends State<TodoListForgetPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoForgetRepository todoRepository = TodoForgetRepository();
  List<Todo> todos = [];
  String categorie = "Recebimento";
  DateTime date = DateTime.now();

  Todo? deletedTodo;
  int? deletedTodoPos;
  bool? check;

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String data =
        "${date.day}/${date.month}/${date.year} - ${date.hour - 3}:${date.minute}:${date.second}";
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Lista de $categorie",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: todoController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                ),
                              ),
                              errorText: errorText,
                              labelText: "Adicionar na Lista",
                              labelStyle: const TextStyle(
                                backgroundColor: Colors.white,
                                color: Colors.purple,
                              ),
                              hintText: "Ex: Água, Energia..."),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O titu'
                                'lo não pode ser vasio!';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                            check: false,
                          );
                          todos.add(newTodo);
                          errorText = null;
                          todoController.text = "";
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        //fixedSize: Size(35, 60),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.6,
                child: ListView(
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                        onCheck: onCheck,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Você tem ${todos.length} pendencias!",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDeletedAll();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      //fixedSize: Size(35, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Icon(
                      Icons.warning_outlined,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCheck(Todo todo) {
    if (todo.check == true) {
      todo.check = false;
    } else {
      todo.check = true;
    }
    todoRepository.saveTodoList(todos);
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
    });

    //para limpar qualquer SnackBar atrasada
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${todo.title} removida com sucesso",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          backgroundColor: Colors.purple,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
              todoRepository.saveTodoList(todos);
            });
          },
        ),
      ),
    );
  }

  void showDeletedAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar todo?"),
        content: const Text("Tem certeza que quer remover todas as tarefas?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
              )),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: const Text(
              "Limpar Tudo",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
