part of 'signin_bloc.dart';

sealed class SigninState extends Equatable {
  const SigninState();
  
  @override
  List<Object> get props => [];
}

final class SigninInitialState extends SigninState {}
final class SigninLoadingState extends SigninState {}
final class SigninSuccessState extends SigninState {}
final class SigninFailureState extends SigninState {}
