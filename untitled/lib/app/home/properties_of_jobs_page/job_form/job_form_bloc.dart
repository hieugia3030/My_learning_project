import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/app/home/properties_of_jobs_page/job_form/job_form_model.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';

import 'package:untitled/services/database.dart';

class JobFormBloc {
  JobFormBloc({@required this.database});

  final Database database;

  final StreamController<JobFormModel> _modelController =
      StreamController<JobFormModel>();

  Stream get modelStream => _modelController.stream;

  JobFormModel _model = JobFormModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submitToFirebase(String id) async {
    updateWith(
      isLoading: true,
      submitted: true,
    );
    try {
      await database.createAndEditJob(Job(
        id: id,
        name: _model.name,
        ratePerHour: int.parse(_model.ratePerHour),
      ));
      print("APP'S LOG: Submitted name: ${_model.name}, ratePerHour:${_model.ratePerHour}");
    } catch (e) {
      updateWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  void updateName(String name) => updateWith(name: name);

  void updateRatePerHour(String ratePerHour) =>
      updateWith(ratePerHour: ratePerHour);

  void updateWith({
    String name,
    String ratePerHour,
    bool submitted,
    bool isLoading,
    bool editNameCompleted,
    bool editRatePerHourCompleted,
    Job job,
  })  {
    _model = _model.copyWith(
      name: name,
      ratePerHour: ratePerHour,
      isLoading: isLoading,
      submitted: submitted,
      editNameCompleted:  editNameCompleted,
      editRatePerHourCompleted: editRatePerHourCompleted,
      job: job,
    );
     _modelController.add(_model);
  }
}
