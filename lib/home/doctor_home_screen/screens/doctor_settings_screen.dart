import 'package:clinical/components/textfield.dart';
import 'package:clinical/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:clinical/home/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:clinical/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorSettingsScreen extends StatefulWidget {
  final String doctorId;
  const DoctorSettingsScreen({required this.doctorId, super.key});

  @override
  State<DoctorSettingsScreen> createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController biographieController = TextEditingController();
  TextEditingController clinicNameController = TextEditingController();

  @override
  void initState() {
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
      ),
      body: BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
        listener: (context, state){
          if(state is UpdateUserInfoLoading){
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 12),
                    Text('Updating profile...'),
                  ],
                ),
              ),
            );   
          }else if(state is UpdateUserInfoSuccess){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }else if(state is UpdateUserInfoFailure){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error Updating Profile'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<MyUserBloc, MyUserState>(
              builder: (context, state) {
                if(state.status == MyUserStatus.loading){
                  return const CircularProgressIndicator();
                }else if(state.status == MyUserStatus.failure){
                  return const Center(child: Text('Error fetching your info'));
                }else if(state.status == MyUserStatus.success){
                  Doctor updatedDoctor = state.user as Doctor;
                  return Column(
                    children: [
                      MyTextfield(
                        controller: emailController, 
                        hintText: updatedDoctor.email, 
                        prefixIcon: Icons.mail,
                      ),
                      MyTextfield(
                        controller: nameController, 
                        hintText: updatedDoctor.name, 
                        prefixIcon: Icons.person_2_rounded,
                      ),
                      MyTextfield(
                        controller: clinicNameController, 
                        hintText: updatedDoctor.clinicName, 
                        prefixIcon: Icons.person_2_rounded,
                      ),
                      MyTextfield(
                        controller: biographieController, 
                        hintText: updatedDoctor.biographie, 
                        prefixIcon: Icons.person_2_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: kToolbarHeight,
                        child: TextButton(
                          onPressed: (){
                            updatedDoctor.name = nameController.text;
                            updatedDoctor.email = emailController.text;
                            updatedDoctor.biographie = biographieController.text;
                            updatedDoctor.clinicName = clinicNameController.text;
                            context.read<UpdateUserInfoBloc>().add(UpdateUserInfo(updatedDoctor));
                          }, 
                          child:  const Text(
                            'Update Info', 
                            style: TextStyle(
                              fontSize: 30, 
                              color: Colors.white
                            ))),
                      )
                    ],
                  );
                }else{return Container(color: Colors.yellow);}
              }
            ),
          ),
      ),
    );
  }
}