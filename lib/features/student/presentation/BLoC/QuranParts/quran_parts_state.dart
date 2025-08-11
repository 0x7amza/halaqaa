import 'package:equatable/equatable.dart';
import 'package:halaqaa/core/model/quran_part_model.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';

abstract class QuranPartsState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuranPartsInitial extends QuranPartsState {}

class QuranPartsLoading extends QuranPartsState {}

class QuranPartsLoaded extends QuranPartsState {
  final List<QuranPartModel> parts;
  final Student student;
  final int totalDays;
  final int overallProgress;
  final int completedJuz;

  QuranPartsLoaded({
    required this.parts,
    required this.student,
    required this.totalDays,
    required this.overallProgress,
    required this.completedJuz,
  });

  @override
  List<Object> get props => [
    parts,
    student,
    totalDays,
    overallProgress,
    completedJuz,
  ];
}

class QuranPartsError extends QuranPartsState {
  final String message;

  QuranPartsError({required this.message});

  @override
  List<Object> get props => [message];
}
