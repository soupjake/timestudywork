import 'package:flutter/material.dart';
import 'package:timestudyapp/app.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

void main() async {
  // Load ViewModel before running the app
  await StudyViewModel.load();
  runApp(TimeStudyApp());
}