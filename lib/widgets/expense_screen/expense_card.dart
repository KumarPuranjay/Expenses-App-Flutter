import 'package:expenses_app/constants/icons.dart';
import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  const ExpenseCard(this.expense,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context);
    return Dismissible(
      key: ValueKey(expense.id),
      onDismissed: (direction) {
        provider.deleteExpense(expense.id!, expense.category, expense.amount);
        // Using snackBar
        var snackBar = SnackBar(
            content: const Text('Note Deleted !!'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: (){
                provider.addExpense(expense);
              },
              textColor: Colors.white,
            )
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: ListTile(
        leading: Icon(icons[expense.category]),
        title: Text(expense.title),
        subtitle: Text(DateFormat('MMMM dd, yyyy').format(expense.date)),
        trailing: Text(NumberFormat.currency(locale: 'en_IN',symbol: 'Rs ').format(expense.amount)),
      ),
    );
  }
}
