import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/home/properties_of_jobs_page/job_form/job_form_bloc.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job_form_model.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';

import 'package:untitled/app/sign_in/validator.dart';
import 'package:untitled/services/database.dart';

class JobForm extends StatefulWidget {
  const JobForm(
      {Key key, @required this.database, @required this.bloc, this.job})
      : super(key: key);
  final JobFormBloc bloc;
  final Job job;
  final Database database;

  static Widget create(BuildContext context, {Job job, Database database}) {
    database == null
        ? database = Provider.of<Database>(context, listen: false)
        : database = database;
    return Provider(
      create: (context) => JobFormBloc(database: database),
      child: Consumer<JobFormBloc>(
        builder: (context, bloc, _) => JobForm(
          database: database,
          bloc: bloc,
          job: job,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _JobFormState createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> with EmailAndPasswordValidator {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ratePerHourController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.bloc.updateWith(
      job: widget.job,
    );
    if (widget.job != null) {
      _nameController.text = widget.job.name;
      _ratePerHourController.text = widget.job.ratePerHour.toString();
      widget.bloc.updateWith(
          name: widget.job.name,
          ratePerHour: widget.job.ratePerHour.toString());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _ratePerHourFocusNode.dispose();
    _ratePerHourController.dispose();
    super.dispose();
  }

  void _onEditingNameComplete(JobFormModel model) {
    widget.bloc.updateWith(editNameCompleted: true);
    FocusScope.of(context).requestFocus(_ratePerHourFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<JobFormModel>(
        stream: widget.bloc.modelStream,
        initialData: JobFormModel(),
        builder: (context, snapshot) {
          final JobFormModel model = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(model.titleText),
              centerTitle: true,
              actions: <Widget>[
                TextButton(
                  onPressed: model.isLoading
                      ? null
                      : () => widget.bloc.submit(
                          context: context,
                          model: model,
                          job: widget.job,
                          ratePerHourFocusNode: _ratePerHourFocusNode,
                          nameFocusNode: _nameFocusNode,),
                  child: Text(
                    'LƯU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () =>
                    model.canPop ? Navigator.of(context).pop() : null,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: _buildContent(model),
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.grey[200],
          );
        });
  }

  List<Widget> _buildContent(JobFormModel model) {
    return [
      _buildNameTextField(model),
      SizedBox(height: 8.0),
      _buildRatePerHourTextField(model),
      SizedBox(height: 8.0),
    ];
  }

  TextField _buildRatePerHourTextField(JobFormModel model) {
    return TextField(
      controller: _ratePerHourController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Độ quan trọng',
        hintText: '0',
        errorText: model.ratePerHourErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      focusNode: _ratePerHourFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => widget.bloc.submit(
          context: context,
          model: model,
          job: widget.job,
          ratePerHourFocusNode: _ratePerHourFocusNode,
          nameFocusNode: _nameFocusNode),
      onChanged: widget.bloc.updateRatePerHour,
    );
  }

  TextField _buildNameTextField(JobFormModel model) {
    return TextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        labelText: 'Tên công việc',
        hintText: 'Blogging',
        errorText: model.nameErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateName,
      onEditingComplete: () => _onEditingNameComplete(model),
    );
  }
}
