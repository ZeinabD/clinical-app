part of 'update_user_info_bloc.dart';

sealed class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserInfo extends UpdateUserInfoEvent {
  final MyUser updatedUser;

  const UpdateUserInfo(this.updatedUser);

  @override
  List<Object> get props => [updatedUser];
}
