import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';

import '../modules/archived_tasks/archived_tasks.dart';
import '../modules/done_tasks/done_tasks.dart';
import '../modules/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

  int currentIndex = 0;
  var list = const [NewTasks(), DoneTasks(), ArchivedTasks()];
  var title = ["NewTasks", "DoneTasks", "ArchivedTasks"];

  void changeNavIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }
}