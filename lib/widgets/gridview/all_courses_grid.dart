import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/widgets/card/course_card.dart';

class AllCoursesGrid extends StatelessWidget {
  final UserModel user;

  const AllCoursesGrid({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Course>>(
        stream: database.streamCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<Course>? data = snapshot.data;
              return data!.isNotEmpty
                  ? GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      children: data
                          .map(
                            (e) => CourseCard(
                              course: e,
                              user: user,
                              onTap: user.userType == 'Faculty'
                                  ? null
                                  : () => database.updateUser(e, user),
                            ),
                          )
                          .toList())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            '''Dont see your course? 
                                  \nWhy not create One?''',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    );
            } else
              return Center(
                child: Text('Snapshot has no data'),
              );
          } else if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return Center(
              child: Text('Check internet connection'),
            );
        });
  }
}
