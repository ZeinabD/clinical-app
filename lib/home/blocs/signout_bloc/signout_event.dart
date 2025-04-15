part of 'signout_bloc.dart';

sealed class SignoutEvent extends Equatable {
  const SignoutEvent();

  @override
  List<Object> get props => [];
}

class SignoutRequired extends SignoutEvent{
  const SignoutRequired();

  @override
  List<Object> get props => [];
}
