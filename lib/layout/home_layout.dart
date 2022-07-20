import 'dart:async';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_2/modules/archive/archive.dart';
// import 'package:flutter_application_2/modules/done/done.dart';
// import 'package:flutter_application_2/modules/new_task/new_task.dart';
import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_application_2/shared/cubit/cubit.dart';
import 'package:flutter_application_2/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_application_2/shared/components/constants.dart';
import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  // int current = 0;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  // bool isBottomSheetShown = false;
  // IconData iconFab = Icons.edit;

  // List<Widget> screens = [
  //   NewTask(),
  //   DoneTask(),
  //   ArchiveTask(),
  // ];

  // List<String> titles = ['New Task', 'Done Task', 'Archive Task'];

  // late Database database;

  // @override
  // void initState() {
  //   super.initState();
  //   createDataBase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInserteDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldkey,
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.current],
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(cubit.iconFab),
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formkey.currentState!.validate()) {
                        cubit.insertToDataBase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text);
                        timeController.text = '';
                        titleController.text = '';
                        dateController.text = '';
                        // insertToDataBase(
                        //   title: titleController.text,
                        //   time: timeController.text,
                        //   date: dateController.text,
                        // ).then((value) {
                        //   getDataFromDatabase(database).then((value) {
                        //     print('getData is sucessfuly');
                        // Navigator.pop(context);
                        // cubit.changeBottomSheetState(
                        //     isShow: false, icon: Icons.edit);
                        //     // setState(() {
                        //     //   isBottomSheetShown = false;
                        //     //   iconFab = Icons.edit;

                        //     //   tasks = value;
                        //     //   print(tasks);
                        //     // });
                        //   });
                        // }
                        // .catchError((error) {
                        //   print('error: ${error.toString()}');
                        //   return Completer<Never>().future;
                        // }
                        //);
                      }
                    } else {
                      scaffoldkey.currentState
                          ?.showBottomSheet((context) => Container(
                                color: Colors.grey[300],
                                padding: EdgeInsets.all(20.0),
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormFaild(
                                        controller: titleController,
                                        label: 'Title Task',
                                        prefix: Icons.title,
                                        type: TextInputType.text,
                                        validated: (String? value) {
                                          if (value!.isEmpty) {
                                            return ('title must not is Empty!');
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          print(value);
                                        },
                                        onSubmitted: (value) {
                                          print(value);
                                        },
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      defaultFormFaild(
                                          controller: timeController,
                                          label: 'Task Time',
                                          prefix: Icons.watch_later_outlined,
                                          type: TextInputType.datetime,
                                          validated: (String? value) {
                                            if (value!.isEmpty) {
                                              return ('time must not is Empty!');
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            print(value);
                                          },
                                          onSubmitted: (value) {
                                            print(value);
                                          },
                                          onTap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString();
                                              print(timeController.text);
                                            }).catchError((error) {
                                              print(
                                                  'error is: ${error.toString()}');
                                            });
                                          }),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      defaultFormFaild(
                                          controller: dateController,
                                          label: 'Task Date',
                                          prefix: Icons.calendar_today,
                                          type: TextInputType.datetime,
                                          validated: (String? value) {
                                            if (value!.isEmpty) {
                                              return ('Date must not is Empty!');
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            print(value);
                                          },
                                          onSubmitted: (value) {
                                            print(value);
                                          },
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2024-07-02'),
                                            ).then((value) {
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value!);
                                            }).catchError((error) {
                                              print(
                                                  'error is: ${error.toString()}');
                                              return Completer<Never>().future;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ))
                          .closed
                          .then((value) {
                        cubit.changeBottomSheetState(
                            isShow: false, icon: Icons.edit);

                        // isBottomSheetShown = false;
                        //   setState(() {
                        //     iconFab = Icons.edit;
                        //   });
                        // });
                      });
                      cubit.changeBottomSheetState(
                          isShow: true, icon: Icons.add);
                      //isBottomSheetShown = true;
                      // setState(() {
                      //   iconFab = Icons.add;
                      // });
                    }

                    // insertToDataBase();
                    // try {
                    //   var name = await getName();
                    //   print(name);
                    //   print('nana kh');
                    //   throw ('find an exception');
                    // } catch (error) {
                    //   print('error: ${error.toString()}');
                    // }
                    // getName().then((value) {
                    //   print(value);
                    //   print('nana kh');
                    //   throw ('find an exception');
                    // }).catchError((error) {
                    //   print('error: ${error.toString()}');
                    //   return Completer<Never>().future;
                    // });
                  }),
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Task',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive),
                    label: 'Archive',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.current,
                onTap: (index) {
                  cubit.changeIndex(index);
                  // setState(() {
                  //   current = index;
                  // });
                },
              ),
              body: BuildCondition(
                condition: true,
                builder: (context) => cubit.screens[cubit.current],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ));
        },
      ),
    );
  }

  // void createDataBase() async {
  //   // ignore: unused_local_variable
  //   database = await openDatabase(
  //     'todo.db',
  //     version: 1,
  //     onCreate: (database, version) {
  //       print('database is created');
  //       database
  //           .execute(
  //               'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , time TEXT , date TEXT , statues TEXT )')
  //           .then((value) {
  //         print('table is created');
  //       }).catchError((error) {
  //         print('error is ${error.toString()}');
  //         return Completer<Never>().future;
  //       });
  //     },
  //     onOpen: (databse) {
  //       print('database is opend');
  //       // getDataFromDatabase(database).then((value) {
  //       //   // tasks = value;
  //       //   // print(tasks);
  //       // });
  //     },
  //   );
  // }

  // Future<void> insertToDataBase({
  //   required String title,
  //   required String time,
  //   required String date,
  // }) async {
  //   return await database.transaction((txn) {
  //     return txn
  //         .rawInsert(
  //             'INSERT INTO tasks(title,time,date,statues) VALUES("$title","$time","$date","new")')
  //         .then((value) {
  //       print('$value inserting sucessfully');
  //     }).catchError((error) {
  //       print('error is ${error.toString()} ');
  //       return Completer<Never>().future;
  //     });
  //   });
  // }

  // Future<String> getName() async {
  //   return 'nazeera alkhoury';
  // }

  // Future getDataFromDatabase(database) async {
  //   List<Map> tasks = await database.rawQuery('SELECT * FROM tasks');
  //   print(tasks);}
}

// Future<List<Map>> getDataFromDatabase(database) async {
//   return await database.rawQuery('SELECT* FROM tasks');
// }
