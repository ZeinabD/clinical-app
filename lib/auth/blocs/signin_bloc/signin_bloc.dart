import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final UserRepo userRepo;

  SigninBloc(this.userRepo) : super(SigninInitialState()) {
    on<SigninRequired>((event, emit) async {
      emit(SigninLoadingState());
      try{
        await userRepo.signin(event.email, event.password);
        emit(SigninSuccessState());
      }catch(e){
        emit(SigninFailureState());
      }
    });
  }
}
