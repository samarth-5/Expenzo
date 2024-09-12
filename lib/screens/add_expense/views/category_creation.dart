import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenzo/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoryIcons = [
    'entertairment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel',
  ];

  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;

      String iconSelected = '';
      Color categoryColor = Colors.white;

      TextEditingController categoryNameController = TextEditingController();
      TextEditingController categoryIconController = TextEditingController();
      TextEditingController categoryColorController = TextEditingController();
      bool isLoading = false;
      Category category = Category.empty;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(
                    ctx,category
                  );
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: AlertDialog(
                title: const Text('Create a Category'),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: categoryNameController,
                        textAlignVertical: TextAlignVertical.center,
                        //readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: Colors.white,
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: categoryIconController,
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(
                            CupertinoIcons.chevron_down,
                            size: 12,
                          ),
                          hintText: 'Icon',
                          border: OutlineInputBorder(
                            borderRadius: isExpanded
                                ? BorderRadius.circular(10)
                                : BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      isExpanded
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                  ),
                                  itemCount: myCategoryIcons.length,
                                  itemBuilder: (context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          iconSelected = myCategoryIcons[i];
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: iconSelected ==
                                                    myCategoryIcons[i]
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/${myCategoryIcons[i]}.png',
                                            ),
                                            //scale: 20,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: categoryColorController,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx2) {
                              //categoryColor=Colors.blue;

                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                      pickerColor: categoryColor,
                                      onColorChanged: (val) {
                                        setState(() {
                                          categoryColor = val;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx2);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Save Color',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: categoryColor,
                          hintText: 'Color',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    category.categoryId = const Uuid().v1();
                                    category.name = categoryNameController.text;
                                    category.icon = iconSelected;
                                    category.color = categoryColor.value;
                                  });
                                  //Create category object and pop

                                  context
                                      .read<CreateCategoryBloc>()
                                      .add(CreateCategory(category));
                                  //Navigator.pop(context);
                                },
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
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
