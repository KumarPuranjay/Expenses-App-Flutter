import 'package:flutter/material.dart';
import '../constants/icons.dart';

class ExpenseCategory {
  final String title;
  int entries = 0;
  double totalAmount = 0.0;
  final IconData iconData;

  ExpenseCategory({required this.title,
    required this.entries,
    required this.totalAmount,
    required this.iconData});

  Map<String, dynamic> toMap() =>
      {
        'title': title,
        'entries': entries,
        'totalAmount': totalAmount
      };

  factory ExpenseCategory.fromString(Map<String, dynamic> value) =>
      ExpenseCategory(title: value['title'],
          entries: value['entries'],
          totalAmount: double.parse(value['totalAmount']),
          iconData: icons[value['title']]!);
}
