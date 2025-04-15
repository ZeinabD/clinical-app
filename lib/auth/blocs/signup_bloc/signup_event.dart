part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupRequired extends SignupEvent{
  final MyUser myUser;
  final String password;

  const SignupRequired(this.myUser, this.password);

  @override
  List<Object> get props => [myUser, password];
}