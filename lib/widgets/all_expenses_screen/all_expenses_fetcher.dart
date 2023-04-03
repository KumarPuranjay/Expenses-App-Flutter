import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/screens/all_expenses_screen.dart';
import 'package:expenses_app/widgets/all_expenses_screen/all_expenses_list.dart';
import 'package:expenses_app/widgets/all_expenses_screen/all_expenses_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllExpensesFetcher extends StatefulWidget {
  const AllExpensesFetcher({Key? key}) : super(key: key);

  @override
  State<AllExpensesFetcher> createState() => _AllExpensesFetcherState();
}

class _AllExpensesFetcherState extends State<AllExpensesFetcher> {
  late Future _allExpensesList;

  Future getAllExpenses() async{
    final provider = Provider.of<DatabaseProvider>(context,listen:false);
    return provider.fetchAllExpenses();
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = getAllExpenses();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allExpensesList,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }
            else{
              return Column(
                children: const [
                  AllExpensesSearch(),
                  Expanded(child: AllExpensesList()),
                ],
              );
            }
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        },
    );
  }
}
