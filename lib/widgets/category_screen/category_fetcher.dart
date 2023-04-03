import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/screens/all_expenses_screen.dart';
import 'package:expenses_app/widgets/category_screen/category_list.dart';
import 'package:expenses_app/widgets/category_screen/total_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryFetcher extends StatefulWidget {
  const CategoryFetcher({Key? key}) : super(key: key);

  @override
  State<CategoryFetcher> createState() => _CategoryFetcherState();
}

class _CategoryFetcherState extends State<CategoryFetcher> {
  late Future _categoryList;

  Future _getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    _categoryList = _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _categoryList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError){
              return Center(
                  child: Text(snapshot.error.toString())
              );
            }
            else{
              return Column(children: [
                const SizedBox(
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TotalChart(),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expenses',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      )),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AllExpensesScreen.name);
                          },
                          child: const Text('View All',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                  fontWeight: FontWeight.w500
                              ))
                      )
                    ],
                  ),
                ),
                const Expanded(child: CategoryList())
              ]);
            }
          }
          else {
            return const Center(
                child: CircularProgressIndicator()
            );
          }
        });
  }
}
