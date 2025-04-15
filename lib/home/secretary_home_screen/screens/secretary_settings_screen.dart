import 'package:clinical/components/textfield.dart';
import 'package:clinical/home/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:clinical/home/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:clinical/models/doctor.dart';
import 'package:clinical/models/secretary.dart';
import 'package:doctor_repository/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecretarySettingsScreen extends StatefulWidget {
  final String secretaryId;
  const SecretarySettingsScreen({required this.secretaryId, super.key});

  @override
  State<SecretarySettingsScreen> createState() => _SecretarySettingsScreenState();
}

class _SecretarySettingsScreenState extends State<SecretarySettingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<String>? _doctorsId;

  Future<List<String>?> _showDoctorsDialog() async {
    List<Doctor>? allDoctors = await FirebaseDoctorRepo().getAllDoctors() ?? [];
    Map<String, bool> selectedDoctors = {for(var doctor in allDoctors) doctor.uid: false};

    return showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: const Text('Select Doctors'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: allDoctors.map((doc){
                    return CheckboxListTile(
                      title: Text(doc.name),
                      subtitle: Text(doc.specialization),
                      value: selectedDoctors[doc.uid], 
                      onChanged: (bool? value){
                        setState((){
                          selectedDoctors[doc.uid] = value ?? false;
                        });
                      });
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(context);
                  }, 
                  child: const Text('Cancel')),
                
                TextButton(
                  onPressed: (){
                    if(selectedDoctors.isNotEmpty){
                      List<String> selectedDoctorsIds = selectedDoctors.entries 
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                      Navigator.of(context).pop(selectedDoctorsIds);
                    }
                  }, 
                  child: const Text('Confirm'))
              ],
            );
          });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
      ),
      body: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
        builder: (context, state){
          if(state is UpdateUserInfoLoading){
            return const CircularProgressIndicator();
          }else if(state is UpdateUserInfoFailure){
            return const Center(child: Text('Error Updating Your Info'));
          }else if(state is UpdateUserInfoSuccess){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<MyUserBloc, MyUserState>(
                builder: (context, state) {
                  if(state.status == MyUserStatus.loading){
                    return const CircularProgressIndicator();
                  }else if(state.status == MyUserStatus.failure){
                    return const Center(child: Text('Error fetching your info'));
                  }else if(state.status == MyUserStatus.success){
                    return Column(
                      children: [
                        MyTextfield(
                          controller: emailController, 
                          hintText: state.user!.email, 
                          prefixIcon: Icons.mail,
                        ),
                        MyTextfield(
                          controller: nameController, 
                          hintText: state.user!.name, 
                          prefixIcon: Icons.person_2_rounded,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            readOnly: true,
                            onTap: () async {
                              _doctorsId = await _showDoctorsDialog(); 
                            },
                            decoration: InputDecoration(
                              hintText: 'Select Doctors',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15),
                                child: FaIcon(
                                  Icons.medical_services,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 35),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 2)
                              )
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: kToolbarHeight,
                          child: TextButton(
                            onPressed: (){
                              Secretary updatedSecretary = state.user as Secretary;
                              updatedSecretary.name = nameController.text;
                              updatedSecretary.email = emailController.text;
                              updatedSecretary.doctorsId = _doctorsId ?? [];

                              context.read<UpdateUserInfoBloc>().add(UpdateUserInfo(updatedSecretary));
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
                  }else{return Container(color: Colors.red);}
                }
              ),
            );
          }else{return Container(color: Colors.red);}
        }
      ),
    );
  }
}