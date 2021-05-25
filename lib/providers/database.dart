import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/api_path.dart';

abstract class FirestoreDatabase {}

class Database implements FirestoreDatabase {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
}
