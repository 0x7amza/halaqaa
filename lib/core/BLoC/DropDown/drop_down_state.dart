part of 'drop_down_bloc.dart';

sealed class BlocDropDownState extends Equatable {
  const BlocDropDownState();

  @override
  List<Object> get props => [];
}

final class DropDownInitial extends BlocDropDownState {}

final class DropDownLoaded extends BlocDropDownState {
  final String selectedValue;

  const DropDownLoaded({required this.selectedValue});

  @override
  List<Object> get props => [selectedValue];
}
