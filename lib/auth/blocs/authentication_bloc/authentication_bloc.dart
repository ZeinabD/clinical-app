import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinical/models/my_user.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final StreamSubscription<MyUser?> _userSubscription;
  final UserRepo userRepo;

  AuthenticationBloc({
    required this.userRepo
  }) : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepo.user.listen((user){
      add(AuthenticationUserChaged(user));
    });

    on<AuthenticationUserChaged>((event, emit) {
      if(event.myUser != null){
        emit(AuthenticationState.authenticated(event.myUser));
      }else{
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }

  @override
  Future<void> close(){
    _userSubscription.cancel();
    return super.close();
  }
}
