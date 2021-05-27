import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/buttons/submit_button.dart';
import 'package:smart_attendance_app/widgets/text_fields/custom_text_field.dart';

class FacultyCreateCourseScreen extends StatefulWidget {
  final UserModel userModel;

  const FacultyCreateCourseScreen({Key? key, required this.userModel})
      : super(key: key);
  @override
  _FacultyCreateCourseScreenState createState() =>
      _FacultyCreateCourseScreenState();
}

class _FacultyCreateCourseScreenState extends State<FacultyCreateCourseScreen> {
  bool _isLoading = false;
  late TimeOfDay startTime;
  late dynamic endTime;
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();

  final FocusNode _courseNameFocusNode = FocusNode();
  final FocusNode _courseCodeFocusNode = FocusNode();

  String get _name => _courseNameController.text;

  String get _code => _courseCodeController.text;

  @override
  void initState() {
    super.initState();
    startTime = TimeOfDay(hour: 8, minute: 0);
    endTime = TimeOfDay(hour: 8, minute: 45);
  }

  Future<void> _submitPressed() async {
    final Database database = Provider.of<Database>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      await database.createCourse(
        Course(
          name: _name,
          code: _code,
          lecturesHeld: 0,
          startTime: startTime.format(context).toString(),
          endTime: endTime.format(context).toString(),
          teacherId: widget.userModel.uid,
        ),
      );
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  void updateStartTime(TimeOfDay time) => setState(() => startTime = time);
  void updateEndTime(TimeOfDay time) => setState(() => endTime = time);

  Future<void> _showTimePicker(
    TimeOfDay timeOfDay,
    void Function(TimeOfDay) handler,
  ) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      helpText: "Select lecture start time",
    );
    if (time != null) {
      handler(time);
    }
  }

  Widget _timeBlock(TimeOfDay time, void Function(TimeOfDay) handler) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          time.format(context).toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () => _showTimePicker(time, handler),
        ),
      ],
    );
  }

  Padding paddingWidget(Widget child) => Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: constantAppBar(),
      body: new Container(
        padding: const EdgeInsets.all(10.0),
        child: !_isLoading
            ? new Column(
                children: [
                  paddingWidget(_buildNameField()),
                  paddingWidget(_buildCodeField()),
                  _timeBlock(startTime, (value) => updateStartTime(value)),
                  _timeBlock(endTime, (value) => updateEndTime(value)),
                  paddingWidget(SubmitButton(
                    text: "Submit",
                    color: Theme.of(context).primaryColor,
                    onPressed: _submitPressed,
                  ))
                ],
              )
            : new Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                ),
              ),
      ),
    );
  }

  void _onNameEdittingComplete() {
    final FocusNode newNode =
        _name.isNotEmpty ? _courseCodeFocusNode : _courseNameFocusNode;
    newNode.requestFocus();
  }

  CustomTextField _buildNameField() {
    return new CustomTextField(
      controller: _courseNameController,
      focusNode: _courseNameFocusNode,
      onChanged: (value) => setState(() {}),
      onEditingComplete: _onNameEdittingComplete,
      labelText: "Course Name",
    );
  }

  CustomTextField _buildCodeField() {
    return new CustomTextField(
      controller: _courseCodeController,
      focusNode: _courseCodeFocusNode,
      onChanged: (value) => mounted ? setState(() {}) : () {},
      onEditingComplete: _submitPressed,
      labelText: "Course Code",
    );
  }
}
