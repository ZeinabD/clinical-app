import 'package:clinical/models/my_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  UserRepo userRepo;

  UpdateUserInfoBloc(this.userRepo) : super(UpdateUserInfoInitial()) {
    on<UpdateUserInfo>((event, emit) async {
      emit(UpdateUserInfoLoading());
      try{
        await userRepo.updateUserInfo(event.updatedUser);
        emit(UpdateUserInfoSuccess());
      }catch(e){
        emit(UpdateUserInfoFailure());
      }
    });
  }
}
