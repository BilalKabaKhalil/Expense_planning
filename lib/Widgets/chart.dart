import 'dart:convert';

import 'package:expense_planning/Widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart(this.recentTransaction);

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      var sumSpending = 0.0;

      recentTransaction.forEach((tx) {
        if (tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          sumSpending += tx.amount;
        }
      });
      return {
        'label': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': sumSpending,
      };
    });
  }

  double get _totalSpending {
    return recentTransaction.fold(
        0.0, (previousValue, element) => previousValue + element.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactionValues.reversed
              .map((e) => Expanded(
                child: ChartBar(
                      label: e['label'].toString(),
                      spindingAmount: e['amount'] as double,
                      spendingPctOfTotal: _totalSpending == 0.0
                          ? 0.0
                          : (e['amount'] as double) / _totalSpending,
                    ),
              ))
              .toList(),
        ),
      ),
    );
  }
}
