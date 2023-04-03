import 'package:expenses_app/widgets/expense_screen/expense_fetcher.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {

  // final String category;
  const ExpenseScreen({Key? key}) : super(key: key);
  static const name = '/expense_screen';

  @override
  Widget build(BuildContext context) {

    // getting category from category card
    final category = (ModalRoute.of(context)!.settings.arguments) as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Screen'),
        centerTitle: true
      ),
      body: ExpenseFetcher(category),
    );
  }
}
