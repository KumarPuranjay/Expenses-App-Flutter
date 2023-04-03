import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/widgets/all_expenses_screen/all_expenses_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllExpensesList extends StatelessWidget {
  const AllExpensesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, db, child) {
        var list = db.expenses;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: list.isNotEmpty ? ListView.builder(
            itemCount: list.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
            ),
            itemBuilder: (context, index) => AllExpenseCard(list[index])
          ): const Center(child: Text('No expenses'))
        );
      },
    );;
  }
}

