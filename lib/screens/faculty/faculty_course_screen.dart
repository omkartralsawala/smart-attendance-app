import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_manager/nfc_manager.dart';
// import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/providers/database.dart';
import 'package:smart_attendance_app/widgets/appbar/appbar.dart';
import 'package:smart_attendance_app/widgets/ripple_animation.dart';

class FacultyCourseScreen extends StatefulWidget {
  final Course course;

  FacultyCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  _FacultyCourseScreenState createState() => _FacultyCourseScreenState();
}

class _FacultyCourseScreenState extends State<FacultyCourseScreen> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  dynamic tagData;
  final String today = DateTime.now().toString().split(" ")[0];
  final NfcManager _instance = NfcManager.instance;
  bool _isLoading = false;
  bool _sensorEnabled = false;
  bool _supportsNFC = false;

  void updateStartTime(TimeOfDay time) => setState(() => startTime = time);
  void updateEndTime(TimeOfDay time) => setState(() => endTime = time);

  bool get _timeUpdated =>
      startTime != returnTimeOfDay(widget.course.startTime) ||
      endTime != returnTimeOfDay(widget.course.endTime);

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

  TimeOfDay returnTimeOfDay(String dateString) {
    List<String> hm = dateString.split(" ")[0].split(":");
    return TimeOfDay(hour: int.parse(hm[0]), minute: int.parse(hm[1]));
  }

  Future<void> _submit() async {
    final Database database = Provider.of<Database>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      await database.updateCourse(
        widget.course.copyWith(
          startTime: startTime.format(context).toString(),
          endTime: endTime.format(context).toString(),
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

  @override
  void initState() {
    super.initState();
    setState(() {
      startTime = returnTimeOfDay(widget.course.startTime);
      endTime = returnTimeOfDay(widget.course.endTime);
    });

    NFC.isNDEFSupported.then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
  }

  void startNfcSession() async {
    print(await _instance.isAvailable());
    print(_supportsNFC);
    if (!_supportsNFC) {
      Fluttertoast.showToast(msg: "PNFC not supported");
    }

    bool supported = await NFC.isNDEFSupported;
    print(supported);
    NFC.readNDEF(
      once: true,
      alertMessage: "Hryyyyy",
      readerMode: NFCNormalReaderMode(),
    );
    _instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        tagData = tag.data;
      });
    });
  }

  void stopNfcSession() {
    _instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    print(today);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: constantAppBar(
        showBackButton: true,
        actionWidgets: [
          if (_timeUpdated)
            IconButton(
              onPressed: _submit,
              icon: Icon(Icons.done),
            )
        ],
      ),
      body: SafeArea(
        child: !_isLoading
            ? Column(
                children: [
                  rowElement(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Course Name",
                          style: theme.textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.course.name,
                          style: theme.textTheme.headline4,
                        ),
                      )
                    ],
                  ),
                  rowElement(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Course Code",
                          style: theme.textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.course.code,
                          style: theme.textTheme.headline4,
                        ),
                      )
                    ],
                  ),
                  rowElement(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showTimePicker(
                                startTime,
                                (value) => updateStartTime(value),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: theme.primaryColor,
                                child: Text(
                                  startTime.format(context).toString(),
                                  style: theme.textTheme.headline4!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Start",
                                style: theme.textTheme.bodyText1,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showTimePicker(
                                endTime,
                                (value) => updateEndTime(value),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: theme.primaryColor,
                                child: Text(
                                  endTime.format(context).toString(),
                                  style: theme.textTheme.headline4!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text("End"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: _sensorEnabled && tagData == null
                          ? RipplesAnimation()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Today's attendance length"),
                                // Spacer(),
                                SizedBox(height: 10),
                                Text(
                                  "Attendance",
                                  style: theme.textTheme.headline4,
                                ),
                                if (tagData != null) Text(tagData),
                              ],
                            ),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_sensorEnabled) {
            stopNfcSession();
          } else {
            startNfcSession();
          }
          setState(() => _sensorEnabled = !_sensorEnabled);
        },
        elevation: 9,
        tooltip: "Will start NFC attendance",
        label: Text("${_sensorEnabled ? "Stop" : "Start"} Attendance"),
        icon: Icon(Icons.people),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget rowElement(List<Widget> children) => Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    ));
