import 'package:expenses_app/widgets/category_screen/category_fetcher.dart';
import 'package:expenses_app/widgets/expense_form.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  static const name = '/category_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Screen'),
        centerTitle: true
      ),
      body: const CategoryFetcher(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const ExpenseForm()
          );
        },
      ),
    );
  }
}
