import 'package:clinical/models/my_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepo userRepo;

  SignupBloc(this.userRepo) : super(SignupInitialState()) {
    on<SignupRequired>((event, emit) async {
      emit(SignupLoadingState());
      try{
        final MyUser myUser = await userRepo.signup(event.myUser, event.password);
        emit(SignupSuccessState(myUser));
      }catch(e){
        emit(SignupFailureState());
      }
    });
  }
}
