import 'package:equatable/equatable.dart';

abstract class QuranPartsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadQuranParts extends QuranPartsEvent {
  final String studentId;

  LoadQuranParts({required this.studentId});

  @override
  List<Object> get props => [studentId];
}
