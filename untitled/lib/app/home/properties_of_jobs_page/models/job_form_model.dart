import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';
import 'package:untitled/app/sign_in/validator.dart';



class JobFormModel with EmailAndPasswordValidator{
  JobFormModel(
      {
      this.isLoading = false ,
      this.ratePerHour = '',
      this.name = '',
        this.submitted = false,
        this.editNameCompleted = false,
        this.editRatePerHourCompleted = false,
        this.job,
      });

  final bool isLoading ;
  final String ratePerHour;
  final String name;
  final bool submitted;
  final bool editNameCompleted;
  final bool editRatePerHourCompleted;
  final Job job;



  String get titleText {
    return job == null ? 'Tạo mới công việc' : 'Chỉnh sửa công việc';
  }

  bool get canPop {
    return !isLoading;
  }

   bool get canSave{
    return emailValidator.isValid(name) && emailValidator.isValid(ratePerHour) && !isLoading;
   }

   String get nameErrorText{
    bool show = !emailValidator.isValid(name) &&  (submitted || editNameCompleted);
    return show ? "Không thể để trống tên" : null;
   }

   String get ratePerHourErrorText{
    bool show = !emailValidator.isValid(ratePerHour) &&  (submitted || editRatePerHourCompleted);
    return show ? "Không thể để trống vùng này" : null;
   }

   JobFormModel copyWith({
      bool submitted,
      bool isLoading,
      String ratePerHour,
      String name,
     bool editNameCompleted,
     bool editRatePerHourCompleted,
     Job job,
}){
    return JobFormModel(
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
      ratePerHour: ratePerHour ?? this.ratePerHour,
      name: name ?? this.name,
      editNameCompleted:  editNameCompleted ?? this.editNameCompleted,
      editRatePerHourCompleted: editRatePerHourCompleted ?? this.editRatePerHourCompleted,
      job: job ?? this.job,
    );
}
}