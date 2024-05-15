import 'package:flutter/material.dart';
import 'package:lista_de_contas/pages/todo_list_buy_page.dart';
import 'package:lista_de_contas/pages/todo_list_forget_page.dart';
import 'package:lista_de_contas/pages/todo_list_page.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  int currentInd = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(170, 100, 100, 100),
      body: Column(
        children:        [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                 TodoListBuyPage(),
                 TodoListPage(),
                 TodoListForgetPage(),
              ],
            ),
          ),
        ],          
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentInd,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined), label: "Pagamentos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money_outlined), label: "Recebimentos"),
        ],
        onTap: (index) {
          setState(() {
            currentInd = index;
            pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
