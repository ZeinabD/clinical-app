import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'signout_event.dart';
part 'signout_state.dart';

class SignoutBloc extends Bloc<SignoutEvent, SignoutState> {
  final UserRepo userRepo;

  SignoutBloc(this.userRepo) : super(SignoutInitial()) {
    on<SignoutEvent>((event, emit) {
      emit(SignoutLoading());
      try{
        userRepo.signout();
        emit(SignoutSuccess());
      }catch(e){
        emit(SignoutFailure());
      }
    });
  }
}
