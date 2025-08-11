import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drop_down_event.dart';
part 'drop_down_state.dart';

class DropDownBloc extends Bloc<DropDownEvent, BlocDropDownState> {
  DropDownBloc() : super(DropDownInitial()) {
    on<DropDownEvent>((event, emit) {
      if (event is DropDownLoadEvent) {
        _changeValue(event, emit);
      } else if (event is DropDownValueChangedEvent) {
        _changeValue(event, emit);
      }
    });
  }
  void _changeValue(event, emit) {
    emit(DropDownLoaded(selectedValue: event.selectedValue));
  }
}
