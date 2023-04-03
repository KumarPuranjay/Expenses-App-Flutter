import 'package:expenses_app/models/database_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TotalChart extends StatefulWidget {
  const TotalChart({Key? key}) : super(key: key);

  @override
  State<TotalChart> createState() => _TotalChartState();
}

class _TotalChartState extends State<TotalChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var categoryList = db.categories;
        var total = db.calculateTotalExpenses();
        return Row(
          children: [
            Expanded(
                flex: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      child: Text('Total Expenses : ${NumberFormat.currency(locale: 'en_IN',symbol: 'Rs ').format(total)}',
                        textScaleFactor: 1.5,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    ...categoryList.map((e) =>
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                color: Colors.primaries[categoryList.indexOf(e)],
                              ),
                              const SizedBox(width: 5),
                              Text('${e.title} :${total == 0? '0%' : ' ${(e.totalAmount/total*100).toStringAsFixed(2)}%'}'),
                            ],
                          ),
                        ))
                  ],
                )
            ),
            Expanded(
                flex: 40,
                child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 20,
                      sections: total != 0 ? categoryList.map((e) =>
                          PieChartSectionData(
                            showTitle: false,
                            value: e.totalAmount,
                            color: Colors.primaries[categoryList.indexOf(e)]
                          )).toList()
                          :
                      categoryList.map((e) =>
                          PieChartSectionData(
                              showTitle: false,
                              color: Colors.primaries[categoryList.indexOf(e)]
                          )).toList()
                    )
                ))
          ],
        );
      },
    );
  }
}
