import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/icons.dart';
import '../../models/expense.dart';

class AllExpenseCard extends StatelessWidget {
  final Expense expense;
  const AllExpenseCard(this.expense,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icons[expense.category]),
      title: Text(expense.title),
      subtitle: Text(DateFormat('MMMM dd, yyyy').format(expense.date)),
      trailing: Text(NumberFormat.currency(locale: 'en_IN',symbol: 'Rs ').format(expense.amount)),
    );;
  }
}

