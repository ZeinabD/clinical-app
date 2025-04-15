part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChaged extends AuthenticationEvent{
  final MyUser? myUser;
  const AuthenticationUserChaged(this.myUser);

  // @override
  // List<Object> get props => [myUser!];
}