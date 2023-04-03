import 'package:expenses_app/models/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllExpensesSearch extends StatefulWidget {
  const AllExpensesSearch({Key? key}) : super(key: key);

  @override
  State<AllExpensesSearch> createState() => _AllExpensesSearchState();
}

class _AllExpensesSearchState extends State<AllExpensesSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: TextField(
        onChanged: (value) {
          provider.searchText = value;
        },
        decoration: const InputDecoration(
            icon: Icon(Icons.search),
            labelText: 'Search Expense'
        )
      )
    );
  }
}
