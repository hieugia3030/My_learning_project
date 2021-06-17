import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job_form_model.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';
import 'package:untitled/common_widgets/platform_alert_dialog.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
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
      await database.setJob(Job(
        id: id,
        name: _model.name,
        ratePerHour: int.parse(_model.ratePerHour),
      ));
      print(
          "APP'S LOG: Submitted name: ${_model.name}, ratePerHour:${_model.ratePerHour}");
    } catch (e) {
      updateWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> submit({
    @required BuildContext context,
    @required JobFormModel model,
    @required FocusNode nameFocusNode,
    @required FocusNode ratePerHourFocusNode,
    @required Job job,
  }) async {
    updateWith(editRatePerHourCompleted: true);
    updateWith(editNameCompleted: true);
    try {
      if (model.canSave) {
        await confirmSubmit(
          context: context,
          model: model,
          job: job,
        );
      }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Error',
        exception: e,
      ).show(context);
    }
  }

  Future<void> confirmSubmit(
      {@required BuildContext context,
      @required JobFormModel model,
      @required Job job}) async {
    final jobs = await database.jobsStream().first;
    final allNames = jobs.map((job) => job.name).toList();
    if (job != null) {
      allNames.remove(job.name);
    }
    if (allNames.contains(model.name)) {
      final didRequestSure = await PlatformAlertDialog(
        title: 'Tên đã được sử dụng',
        content:
            'Một công việc khác sẽ được tạo với tên trùng lặp này. Bạn có chắc chắn không?',
        defaultActionText: 'Có',
        cancelText: 'Không',
      ).show(context);
      if (didRequestSure == true) {
        await _addOrEditNewJobToFirestore(
          context: context,
          job: job,
        );
      }
    } else {
      await _addOrEditNewJobToFirestore(
        context: context,
        job: job,
      );
    }
  }

  Future<void> _addOrEditNewJobToFirestore(
      {@required BuildContext context, @required Job job}) async {
    final id = job?.id ?? documentIdFromCurrentDate();
    await submitToFirebase(id);
    Navigator.of(context, rootNavigator: false).pop();
  }

  void focusOnEmptyField(
      {@required BuildContext context,
      @required JobFormModel model,
      @required FocusNode nameFocusNode,
      @required FocusNode ratePerHourFocusNode}) {
    if (model.nameErrorText == null) {
      focusOn(context, nameFocusNode);
    } else {
      focusOn(context, ratePerHourFocusNode);
    }
  }

  void focusOn(BuildContext context, FocusNode aFocusNode) {
    FocusScope.of(context).requestFocus(aFocusNode);
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
  }) {
    _model = _model.copyWith(
      name: name,
      ratePerHour: ratePerHour,
      isLoading: isLoading,
      submitted: submitted,
      editNameCompleted: editNameCompleted,
      editRatePerHourCompleted: editRatePerHourCompleted,
      job: job,
    );
    _modelController.add(_model);
  }
}
