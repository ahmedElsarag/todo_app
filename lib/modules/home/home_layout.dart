import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/widgets/components.dart';

import '../../widgets/constants.dart';


class HomeLayout extends StatelessWidget {
  Database database;

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var isBottomSheetShown = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  HomeLayout({Key key}) : super(key: key);

  // @override
  // void initState() {
  //   super.initState();
  //
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {

        },
        builder: (context,state){
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit.get(context).title[AppCubit.get(context).currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => AppCubit.get(context).list[AppCubit.get(context).currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              child: isBottomSheetShown == true
                  ? const Icon(Icons.close)
                  : const Icon(Icons.edit),
              onPressed: () {
                if (isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    insertToDatabase(titleController.text, timeController.text,
                        dateController.text)
                        .then((value) {
                      Navigator.pop(context);
                      // setState(() {
                      //   isBottomSheetShown = false;
                      // });
                    }).catchError((error) => print(error.toString()));
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) {
                    return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            top: 40, right: 20, left: 20, bottom: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                label: 'Title',
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  label: 'Task time',
                                  controller: timeController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  prefix: Icons.access_time,
                                  onTab: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) => timeController.text =
                                        value.format(context));
                                  }),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  label: 'Task date',
                                  controller: dateController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  prefix: Icons.calendar_today,
                                  onTab: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                        DateTime.parse('2025-05-01'))
                                        .then((value) => dateController.text =
                                        DateFormat.yMMMd().format(value));
                                  }),
                            ],
                          ),
                        ));
                  },
                      elevation: 15,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))))
                      ?.closed
                      ?.then((value) {
                    // setState(() {
                    //   isBottomSheetShown = false;
                    // });
                  });
                  // setState(() {
                  //   isBottomSheetShown = true;
                  // });
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeNavIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },

      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
        //at first it will check if todo.db exist
        'todo.db',
        version: 1,
        // if todo.db not exist it will call onCreate
        onCreate: (database, version) {
      print('database created');
      createTable(database);
    },
        //if todo.db exist it will ignore onCreate and call onOpen
        onOpen: (database) {
      print('database opened');
      getDataFromDatabase(database).then((value) {
        // setState(() {
        //   tasksList = value;
        // });
        print(tasksList);
      });
    });
  }

  void createTable(Database database) {
    var tasksTable =
        'CREATE TABLE Tasks(id  INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT)';
    database
        .execute(tasksTable)
        .then((value) => print('table created'))
        .catchError((error) => print(error.toString()));
  }

  Future insertToDatabase(String title, String time, String date) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted');
        getDataFromDatabase(database).then((value) {
          tasksList = value;
          print(tasksList);
        });
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    /// we will pass the database object from on open method as if we use general
    /// object we got error as general object is ready after all database process done

    return await database.rawQuery('SELECT * FROM Tasks');
  }
}
