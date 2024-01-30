import 'package:dartz/dartz.dart';
import 'package:voxxie/model/reminder/Reminder.model.dart';

abstract class IReminderService {
  Future<Either<String, Unit>> setReminder(ReminderModel model);
  Future<Either<String, List>> getUserReminder();
  Future<Either<String, Unit>> deleteReminder(String docID);
}
