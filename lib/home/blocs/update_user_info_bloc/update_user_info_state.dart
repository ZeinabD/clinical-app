part of 'update_user_info_bloc.dart';

sealed class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();
  
  @override
  List<Object> get props => [];
}

final class UpdateUserInfoInitial extends UpdateUserInfoState {}
final class UpdateUserInfoLoading extends UpdateUserInfoState {}
final class UpdateUserInfoSuccess extends UpdateUserInfoState {}
final class UpdateUserInfoFailure extends UpdateUserInfoState {}
