import '../../../di/injecting.dart';
import '../repository/subject_repository.dart';

class GetMeanAverage{
  SubjectRepository _repository;

  GetMeanAverage(this._repository);

  Future<double> call()async {
    double sum = 0;
    var subjects = await _repository.getAllSubjects();


    subjects.forEach((element) {
      sum += element.average();
    });

    var avg = sum / subjects.length;
    if(avg.isNaN){
      return 0;
    }else{
      return avg;
    }
  }
}