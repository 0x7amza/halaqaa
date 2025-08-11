part of 'drop_down_bloc.dart';

sealed class DropDownEvent extends Equatable {
  const DropDownEvent();

  @override
  List<Object> get props => [];
}

class DropDownLoadEvent extends DropDownEvent {
  final String selectedValue;

  const DropDownLoadEvent({required this.selectedValue});

  @override
  List<Object> get props => [selectedValue];
}

class DropDownValueChangedEvent extends DropDownEvent {
  final String selectedValue;
  const DropDownValueChangedEvent({required this.selectedValue});
  @override
  List<Object> get props => [selectedValue];
}
