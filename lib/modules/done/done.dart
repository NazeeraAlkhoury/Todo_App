import 'package:flutter/material.dart';
import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_application_2/shared/cubit/cubit.dart';
import 'package:flutter_application_2/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_application_2/shared/components/constants.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).donetasks;
          return tasksBuilder(tasks: tasks);
          // return ListView.separated(
          //   itemBuilder: (context, index) => tasksBuilder(tasks: tasks),
          //   separatorBuilder: (context, index) => Padding(
          //     padding: const EdgeInsetsDirectional.only(start: 20.0),
          //     child: Container(
          //       width: double.infinity,
          //       height: 1.0,
          //       color: Colors.grey,
          //     ),
          //   ),
          //   itemCount: tasks.length,
          // );
        });
  }
}
