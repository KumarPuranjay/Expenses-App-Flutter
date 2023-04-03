import 'package:expenses_app/widgets/all_expenses_screen/all_expenses_fetcher.dart';
import 'package:flutter/material.dart';

class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({Key? key}) : super(key: key);

  static const name = '/all_expenses_screen';
  
  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Expenses Screen')),
      body: const AllExpensesFetcher(),
    );
  }
}
