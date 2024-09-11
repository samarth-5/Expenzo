import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_categorybloc_event.dart';
part 'get_categorybloc_state.dart';

class GetCategoryblocBloc extends Bloc<GetCategoryblocEvent, GetCategoryblocState> {
  GetCategoryblocBloc() : super(GetCategoryblocInitial()) {
    on<GetCategoryblocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
