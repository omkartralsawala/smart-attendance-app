// import 'package:flutter/material.dart';

// // import '../../screens/restaurants/restaurant_register.dart';
// import '../../widgets/Validators/validators.dart';
// // import '../../widgets/buttons/submit_button.dart';
// import '../../models/user.dart';

// class UserForm extends StatelessWidget with Validators {
//   final UserModel user;
//   UserForm({this.user});

//   // void submit(BuildContext context) async {
//   //   Navigator.of(context).pushReplacement(new MaterialPageRoute(
//   //     builder: (context) => AddRestaurantScreen(user: user),
//   //   ));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final theme = Theme.of(context).textTheme;
//     return new Form(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: new Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: new Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             SizedBox(height: 0.09 * height),
//             Text("Welcome to Edith Display!", style: theme.headline1),
//             SizedBox(height: 0.09 * height),
//             Text("Let's get you started!", style: theme.bodyText1),
//             SizedBox(height: 0.09 * height),
//             Text(
//               "Let's continue to add your first restaurant!",
//               style: theme.bodyText1,
//             ),
//             SizedBox(height: 0.09 * height),
//             // new SubmitButton(
//             //   text: 'Continue',
//             //   onPressed: () => submit(context),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
