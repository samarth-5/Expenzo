import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenzo/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expenzo/screens/add_expense/blocs/create_expensebloc/create_expense_bloc.dart';
import 'package:expenzo/screens/add_expense/blocs/get_categorybloc/get_categories_bloc.dart';
import 'package:expenzo/screens/add_expense/views/add_expense.dart';
import 'package:expenzo/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expenzo/screens/home/views/main_screen.dart';
import 'package:expenzo/screens/stats/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int idx = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now it's safe to use Theme.of(context)
    selectedItem = Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state is GetExpensesSuccess) {
          return Scaffold(
            //appBar: AppBar(),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                onTap: (val) {
                  //print(val);
                  setState(() {
                    idx = val;
                  });
                },
                //selectedItemColor: Colors.red,
                //backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                      color: idx == 0 ? selectedItem : unselectedItem,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.graph_square_fill,
                      color: idx == 1 ? selectedItem : unselectedItem,
                    ),
                    label: 'Stats',
                  )
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async{
                Expense? newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute<Expense>(
                    builder: (BuildContext context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(FirebaseExpense()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetCategoriesBloc(FirebaseExpense())
                                ..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CreateExpenseBloc(FirebaseExpense()),
                        ),
                      ],
                      child: const AddExpense(),
                    ),
                  ),
                );
                if(newExpense != null)
                {
                  setState(() {
                    state.expenses.insert(0,newExpense);
                  });
                }
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                ),
                child: const Icon(CupertinoIcons.add),
              ),
            ),
            body: idx == 0 ? MainScreen(state.expenses) : const StatsScreen(),
          );
        }
        else{
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
      },
    );
  }
}
