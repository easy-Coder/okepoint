import 'package:cloud_firestore/cloud_firestore.dart';

DateTime get timeStampNow => Timestamp.now().toDate();
int get utcTimeNow => timeStampNow.millisecondsSinceEpoch;
