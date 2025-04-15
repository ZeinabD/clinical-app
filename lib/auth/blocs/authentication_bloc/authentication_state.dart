part of 'authentication_bloc.dart';

enum AuthenticationStatus{ unknown, authenticated, unauthenticated}

class AuthenticationState extends Equatable {
  final MyUser? myUser;
  final AuthenticationStatus status;

  const AuthenticationState._({
    this.myUser,
    this.status = AuthenticationStatus.unknown,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(MyUser? user) : this._(myUser: user, status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);
  
  @override
  List<Object?> get props => [myUser, status];
}