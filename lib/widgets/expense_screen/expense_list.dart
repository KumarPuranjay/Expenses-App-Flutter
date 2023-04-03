import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/widgets/expense_screen/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
        builder: (_, db, __) {
          var expenseList = db.expenses;
          return expenseList.isNotEmpty ? ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
              ),
              itemCount: expenseList.length,
              itemBuilder: (context, index) => ExpenseCard(expenseList[index])
          ): const Center(child: Text('No expenses'));
        },
    );
  }
}
