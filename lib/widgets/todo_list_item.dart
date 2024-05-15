import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_contas/models/todo.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({super.key, required this.todo , required this.onDelete, required this.onCheck});

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) onCheck;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onCheck(widget.todo);
        });
      },
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
            motion:
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.check_circle_outline,color: Colors.white),
                ),
                onTap: (){
                  // final slideable = Slidable.of(context)!;
                  setState(() {
                  widget.onCheck(widget.todo);
                  // Slidable.of(context)?.closing;
                  });
                },
              ),
            ),
          children: [
            Container(),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion:
          Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: const Icon(Icons.delete,color: Colors.white),
              ),
              onTap: (){
                widget.onDelete(widget.todo);

              },
            ),
          ),
          children: [
            Container(),
          ],
        ),

        child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:widget.todo.check == true ? Colors.green : Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.todo.title,
                        style:const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy - HH:mm').format(widget.todo.dateTime),
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
