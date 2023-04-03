import 'package:expenses_app/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../screens/expense_screen.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory expenseCategory;

  const CategoryCard(this.expenseCategory,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.of(context).pushNamed(
          ExpenseScreen.name,
          arguments: expenseCategory.title // for expenses screen
        );
      },
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(expenseCategory.iconData),
      ),
      title: Text(expenseCategory.title),
      subtitle: Text('entries : ${expenseCategory.entries}'),
      trailing: Text(NumberFormat.currency(locale: 'en_IN',symbol: 'Rs ').format(expenseCategory.totalAmount)),
    );
  }
}
