import 'package:flutter/material.dart';

import '/models/course.dart';
import '/models/user.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final UserModel user;
  final Function()? onTap;

  const CourseCard(
      {Key? key, required this.course, required this.user, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 0.5 * size.width,
          height: 0.27 * size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Expanded(
                  child: Text(
                    course.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    course.code,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                _timeRowBlock(
                  Theme.of(context).primaryColor,
                  course.endTime.toString(),
                  'end',
                ),
                _timeRowBlock(
                  Theme.of(context).primaryColor,
                  course.startTime.toString(),
                  'start',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _timeRowBlock(Color color, String timeString, String displayString) {
  return Expanded(
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 50,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              timeString,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Text(
          displayString,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
