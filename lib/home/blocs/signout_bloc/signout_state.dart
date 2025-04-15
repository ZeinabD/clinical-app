part of 'signout_bloc.dart';

sealed class SignoutState extends Equatable {
  const SignoutState();
  
  @override
  List<Object> get props => [];
}

final class SignoutInitial extends SignoutState {}

final class SignoutLoading extends SignoutState {}
final class SignoutSuccess extends SignoutState {}
final class SignoutFailure extends SignoutState {}
