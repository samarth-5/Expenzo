import 'package:expenzo/screens/add_expense/blocs/get_categorybloc/get_categories_bloc.dart';
import 'package:expenzo/screens/add_expense/views/category_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    dateController.text = DateFormat('dd/MM /yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Add Expenses",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: expenseController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.rupeeSign,
                            size: 16,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: categoryController,
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true,
                      onTap: () {},
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.list,
                          size: 16,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            var newCategory = await getCategoryCreation(context);
                            //print(newCategory);
                            setState(() {
                              state.categories.insert(0, newCategory);
                            });
                          },
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: 'Category',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: state.categories.length,
                          itemBuilder: (context, int i) {
                            return Card(
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/${state.categories[i].icon}.png',
                                  scale: 6,
                                ),
                                title: Text(state.categories[i].name),
                                tileColor: Color(state.categories[i].color),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: dateController,
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true,
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: selectDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (newDate != null) {
                          setState(() {
                            dateController.text =
                                DateFormat('dd/MM /yyyy').format(newDate);
                            selectDate = newDate;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.clock,
                          size: 16,
                          color: Colors.grey,
                        ),
                        hintText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
