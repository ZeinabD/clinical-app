part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();
  
  @override
  List<Object> get props => [];
}

final class SignupInitialState extends SignupState {}

final class SignupLoadingState extends SignupState {}
final class SignupSuccessState extends SignupState {
  final MyUser myUser;

  const SignupSuccessState(this.myUser);

  @override   
  List<Object> get props => [myUser];
}
final class SignupFailureState extends SignupState {}
