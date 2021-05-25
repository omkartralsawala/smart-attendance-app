// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';

// import '../../widgets/Validators/validators.dart';
// import '../../widgets/buttons/submit_button.dart';
// import '../../widgets/dialog_box/platform_alert_dialog.dart';
// import '../../widgets/dialog_box/platform_exception_alert_dialog.dart';
// import '../../widgets/text_fields/custom_text_field.dart';
// import '../../models/device_model.dart';
// import '../../models/user.dart';
// import '../../services/api_path.dart';
// import '../../providers/database.dart';

// class DeviceRegistrationForm extends StatefulWidget with Validators {
//   final UserModel user;
//   DeviceRegistrationForm({this.user});
//   @override
//   _DeviceRegistrationFormState createState() => _DeviceRegistrationFormState();
// }

// class _DeviceRegistrationFormState extends State<DeviceRegistrationForm> {
//   final userRef = FirebaseFirestore.instance.collection('users');
//   final deviceRef = FirebaseFirestore.instance.collection('devices');
//   final TextEditingController _deviceIdentification = TextEditingController();
//   final FocusNode _deviceFocusNode = FocusNode();
//   final TextEditingController _deviceNameController = TextEditingController();
//   final FocusNode _deviceNameNode = FocusNode();
//   String get _device => _deviceIdentification.text;
//   String get _deviceName => _deviceNameController.text;
//   bool _submitted = false;
//   bool _isLoading = false;

//   void _showToast(String text) => Fluttertoast.showToast(msg: text);

//   void _deviceEditingComplete() {
//     final newFocus = widget.restaurantValidator.isValid(_device)
//         ? _deviceNameNode
//         : _deviceFocusNode;
//     FocusScope.of(context).requestFocus(newFocus);
//   }

//   void submit() async {
//     final restaurantRef = FirebaseFirestore.instance
//         .collection(ApiPath.restaurants(uid: widget.user.uid));
//     try {
//       final databse = Provider.of<FirestoreDatabase>(context, listen: false);
//       if (_deviceName != null) {
//         deviceRef.doc(_device).snapshots().listen((doc) {
//           if (doc.id != _device)
//             _showToast("Enter a valid device id");
//           else {
//             restaurantRef
//                 .doc(databse.getSelectedRestaurant(user: widget.user))
//                 .get()
//                 .then((snapshot) {
//               databse.createDevice(
//                 user: widget.user,
//                 device: Device(uniqueId: _device, deviceName: _deviceName),
//               );
//             });
//             Navigator.of(context).pop();
//           }
//         });
//       } else {
//         PlatformAlertDialog(
//           title: "Device Name Error!",
//           content: "Device Name cant be empty",
//           defaultActionText: "Okay",
//         ).show(context);
//       }
//     } catch (e) {
//       print(e.message);
//       PlatformExceptionALertDialog(
//         title: 'Registration failed',
//         exception: e,
//       ).show(context);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _deviceFocusNode.requestFocus();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final database = Provider.of<FirestoreDatabase>(context);
//     final Size size = MediaQuery.of(context).size;
//     bool submitEnabled =
//         widget.passwordVaidator.isValid(_device) && !_isLoading;
//     return Form(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: _isLoading ? MainAxisSize.max : MainAxisSize.min,
//             crossAxisAlignment: _isLoading
//                 ? CrossAxisAlignment.center
//                 : CrossAxisAlignment.stretch,
//             children: _isLoading
//                 ? <Widget>[
//                     CircularProgressIndicator(),
//                   ]
//                 : <Widget>[
//                     SizedBox(height: 0.05 * size.height),
//                     Text(
//                       "Add a device to \n${database.getSelectedRestaurant(user: widget.user)}",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline1
//                           .copyWith(color: Colors.white),
//                     ),
//                     SizedBox(height: 0.1 * size.height),
//                     _buildDeviceTextField(),
//                     SizedBox(height: 0.025 * size.height),
//                     _buildDeviceNameTextField(),
//                     SizedBox(height: 0.025 * size.height),
//                     SubmitButton(
//                       color: Theme.of(context).primaryColor,
//                       text: 'Submit',
//                       onPressed: submitEnabled ? submit : null,
//                     ),
//                   ],
//           ),
//         ),
//       ),
//     );
//   }

//   CustomTextField _buildDeviceTextField() {
//     bool showErrorText =
//         _submitted && !widget.validDeviceValidator.exists(_device);
//     return CustomTextField(
//       controller: _deviceIdentification,
//       focusNode: _deviceFocusNode,
//       labelText: 'Device Id',
//       hintText: "xxxx-xxxx-xxxx",
//       errorText: showErrorText ? widget.invalidDeviceIdError : null,
//       enabled: _isLoading == false,
//       inputAction: TextInputAction.next,
//       onChanged: (device) => _updateState(),
//       onEditingComplete: _deviceEditingComplete,
//     );
//   }

//   CustomTextField _buildDeviceNameTextField() {
//     bool showErrorText =
//         _submitted && !widget.validDeviceValidator.exists(_deviceName);
//     return CustomTextField(
//       controller: _deviceNameController,
//       focusNode: _deviceNameNode,
//       labelText: 'Device Name',
//       hintText: "Living Room",
//       errorText: showErrorText ? widget.invalidDeviceIdError : null,
//       enabled: _isLoading == false,
//       inputAction: TextInputAction.done,
//       onChanged: (device) => _updateState(),
//       onEditingComplete: submit,
//     );
//   }

//   _updateState() {
//     setState(() {});
//   }
// }
