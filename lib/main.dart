import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/screens/all_expenses_screen.dart';
import 'package:expenses_app/screens/category_screen.dart';
import 'package:expenses_app/screens/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: CategoryScreen.name,
      routes: {
        CategoryScreen.name: (_) => const CategoryScreen(),
        ExpenseScreen.name: (_) => const ExpenseScreen(),
        AllExpensesScreen.name: (_) => const AllExpensesScreen()
      },
    );
  }
}
