import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/shared/cubit/cubit.dart';

Widget defaultButton({
  double width: double.infinity,
  Color backgrond: Colors.blue,
  required Function function,
  required String text,
  double radius = 0.0,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(radius),
        color: backgrond,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          '${isUpperCase ? text.toUpperCase() : text}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormFaild({
  required TextEditingController controller,
  required String label,
  required IconData prefix,
  required TextInputType type,
  Function? onSubmitted,
  Function? onChanged,
  required Function validated,
  bool isObscure: false,
  IconData? suffix,
  Function? onSuffix,
  Function? onTap,
  //bool isSuffix = false,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefix,
          ),
          border: OutlineInputBorder(),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: () {
                    onSuffix!();
                  },
                  icon: Icon(
                    suffix,
                  ),
                )
              : null),
      keyboardType: type,
      onFieldSubmitted: (s) {
        onSubmitted!(s);
      },
      onChanged: (s) {
        onChanged!(s);
      },
      validator: (String? value) {
        return validated(value!);
      },
      obscureText: isObscure,

      onTap: () {
        onTap!();
      },
      // validator: (String? value) {
      //   if (value!.isEmpty) {
      //     return 'Email Adress must not be empty ';
      //   }
      //   return null;
      // },
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              child: Text(
                '${model['time']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  //  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            IconButton(
              color: Colors.black54,
              onPressed: () {
                AppCubit.get(context)
                    .updateDataBase(statues: 'Done', id: model['id']);
              },
              icon: Icon(Icons.check_box),
            ),
            SizedBox(
              width: 5.0,
            ),
            IconButton(
              color: Colors.grey,
              onPressed: () {
                AppCubit.get(context)
                    .updateDataBase(statues: 'Archived', id: model['id']);
              },
              icon: Icon(Icons.archive),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDataBase(id: model['id']);
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    BuildCondition(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey,
          ),
        ),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey,
              size: 100.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'No tasks yet, please Add some tasks',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
