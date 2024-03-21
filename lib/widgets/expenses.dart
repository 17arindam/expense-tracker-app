import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/charts/chart.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'fluttercourse',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Movie',
        amount: 5.69,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars() ;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Expense deleted'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(onPressed: () {
        setState(() {
          _registeredExpenses.insert(expenseIndex, expense);
        });
      },label: 'Undo',),
    ));
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600 ?Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
              child: ExpensesList(
            expenses: _registeredExpenses,
            onRemoveExpense: _removeExpense,
          ))
        ],
      ) : Row(children: [
        Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(
              child: ExpensesList(
            expenses: _registeredExpenses,
            onRemoveExpense: _removeExpense,
          ))
      ],)
    );
  }
}
