import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;
  var list = [NewTasks(), DoneTasks(), ArchivedTasks()];
  var title = ["NewTasks", "DoneTasks", "ArchivedTasks"];
  late Database database;

  var isBottomSheetShown = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title[_currentIndex]),
      ),
      body: list[_currentIndex],
      floatingActionButton: FloatingActionButton(
        child: isBottomSheetShown==true?Icon(Icons.close):Icon(Icons.edit),
        onPressed: () {
          if(isBottomSheetShown){
            Navigator.pop(context);
            setState(() {
              isBottomSheetShown = false;
            });
          }else{
            scaffoldKey.currentState?.showBottomSheet((context) {
              return Container(
                width: double.infinity,
                height: 120,
                color: Colors.red,
              );
            });
            setState(() {
              isBottomSheetShown = true;
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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

  void insertToDatabase() {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status ) VALUES("first task","20-1-2021","15:24","new")')
          .then((value) => print('raw inserted at id: $value'))
          .catchError(
              (error) => print('error inserting raw: ${error.toString()}'));
    });
  }
}
