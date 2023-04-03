
import 'package:expenses_app/constants/icons.dart';
import 'package:expenses_app/models/database_provider.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {

  final _title = TextEditingController();
  final _amount = TextEditingController();

  DateTime? _date;
  void _pickDate() async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now()
    );
    if(pickedDate != null){
      setState(() {
        _date = pickedDate;
      });
    }
  }

  String _initialData = 'Others';

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<DatabaseProvider>(context,listen: false);

    return Container(
      height: MediaQuery.of(context).size.height*0.7,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // title
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title of Expense',
              ),
              controller: _title,
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Amount of Expense'
              ),
              controller: _amount,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(child: Text(_date != null ? DateFormat('MMMM dd, yyyy').format(_date!) : 'Select date')),
                IconButton(
                    onPressed: () => _pickDate(),
                    icon: const Icon(Icons.calendar_month)
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Category'),
                DropdownButton(
                  items: icons.keys
                      .map(
                          (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e))
                  ).toList(),
                  value: _initialData,
                  onChanged: (value) {
                    setState(() {
                      _initialData = value!;
                    });
                    },
                )
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
                onPressed: (){
                  if(_title.text != '' && _amount.text != ''){
                    final expense = Expense(
                        id: null,
                        title: _title.text,
                        amount: double.parse(_amount.text),
                        date: _date == null ? DateTime.now():_date!,
                        category: _initialData
                    );
                    provider.addExpense(expense);
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.add) ,
                label: const Text('Add Expense'),
            )
          ],
        ),
      ),
    );
  }
}

