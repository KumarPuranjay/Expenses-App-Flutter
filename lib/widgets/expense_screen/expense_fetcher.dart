import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/widgets/expense_screen/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import 'expense_chart.dart';

class ExpenseFetcher extends StatefulWidget {
  final String category;
  const ExpenseFetcher(this.category,{Key? key}) : super(key: key);

  @override
  State<ExpenseFetcher> createState() => _ExpenseFetcherState();

}

class _ExpenseFetcherState extends State<ExpenseFetcher> {
  late Future<List<Expense>> _expenseList;

  Future<List<Expense>> getExpenseList() async{
    final provider = Provider.of<DatabaseProvider>(context,listen: false);
    return await provider.fetchExpenses(widget.category);
  }


  @override
  void initState() {
    super.initState();
    _expenseList = getExpenseList();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _expenseList,
        builder: (_,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }
            else{
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                child: Column(
                  children: [
                    SizedBox(height: 250,child: ExpenseChart(widget.category)),
                    const Expanded(child: ExpenseList()),
                  ],
                ),
              );
            }
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}

