part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SigninRequired extends SigninEvent{
  final String email, password;

  const SigninRequired(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}