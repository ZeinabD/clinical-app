import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

import '../../../models/my_user.dart';

part 'my_user_event.dart';
part 'my_user_state.dart';

class MyUserBloc extends Bloc<MyUserEvent, MyUserState> {
  UserRepo userRepo;
  MyUserBloc(this.userRepo) : super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      try{
        MyUser? user = await userRepo.getMyUser(event.userId);
        emit(MyUserState.success(user!));
      }catch(e){
        emit(const MyUserState.failure());
      }
    });
  }
}
