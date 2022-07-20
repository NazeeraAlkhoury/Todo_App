import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/modules/archive/archive.dart';
import 'package:flutter_application_2/modules/done/done.dart';
import 'package:flutter_application_2/modules/new_task/new_task.dart';
import 'package:flutter_application_2/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);
  int current = 0;
  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchiveTask(),
  ];
  List<String> titles = ['New Task', 'Done Task', 'Archive Task'];

  bool isBottomSheetShown = false;
  IconData iconFab = Icons.edit;

  late Database database;

  //List<Map> tasks = [];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];

  void changeIndex(int index) {
    current = index;
    emit(AppChangeBottomNavigationBarState());
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    iconFab = icon;
    emit(AppChangefloatingActionButtonState());
  }

  void createDataBase() async {
    // ignore: unused_local_variable
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , time TEXT , date TEXT , statues TEXT )')
            .then((value) {
          print('table is created');
          emit(AppCreateDataBaseState());
        }).catchError((error) {
          print('error is ${error.toString()}');
          return Completer<Never>().future;
        });
      },
      onOpen: (databse) {
        print('database is opend');
        getDataFromDatabase(databse);
        // getDataFromDatabase(database).then((value) {
        //   // tasks = value;
        //   // print(tasks);
        // });
      },
    );
  }

  void insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,time,date,statues) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserting sucessfully');
        emit(AppInserteDataBaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error is ${error.toString()} ');
        return Completer<Never>().future;
        //return Future<Null>(() {});
      });
    });
    // return null;
  }

  void getDataFromDatabase(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];

    database.rawQuery('SELECT* FROM tasks').then((value) {
      print('getData is sucessfuly');
      // tasks = value;
      // print(tasks);
      value.forEach((element) {
        if (element['statues'] == 'new') {
          newtasks.add(element);
        } else if (element['statues'] == 'Done') {
          donetasks.add(element);
        } else
          archivetasks.add(element);
      });
      emit(AppGetDataBaseState());
    }).catchError((error) {
      print('error is ${error.toString()} ');
      return Completer<Never>().future;
    });
  }

  void updateDataBase({
    required String statues,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET statues = ? WHERE id = ?',
        ['$statues', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  // ignore: unused_element
  void deleteDataBase({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }
}
