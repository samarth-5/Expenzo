import 'package:expense_repository/expense_repository.dart';
import 'package:expenzo/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expenzo/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expenzo",
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
              surface:  Color.fromARGB(255, 223, 207, 207),
              onSurface: Colors.black,
              primary:  Color(0xFF00B2E7),
              secondary:  Color(0xFFE064F7),
              tertiary: Color(0xFFFF8D6C),
              outline: Colors.grey)),
      home: BlocProvider(
        create: (context) => GetExpensesBloc(
          FirebaseExpense()
        )..add(GetExpenses()),
        child: const HomeScreen(),
      ),
    );
  }
}
