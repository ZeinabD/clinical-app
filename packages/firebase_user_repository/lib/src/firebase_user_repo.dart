import 'dart:math';
import 'package:clinical/models/doctor.dart';
import 'package:clinical/models/my_user.dart';
import 'package:clinical/models/secretary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../user_repository.dart';

class FirebaseUserRepo extends UserRepo{
  final secretariesCollection = FirebaseFirestore.instance.collection('secretary');
  final doctorsCollection = FirebaseFirestore.instance.collection('doctor');
  final FirebaseAuth _firebaseAuth;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<MyUser?> getMyUser(String uid) async {
    try{
      var doctorData = await doctorsCollection.doc(uid).get();
      if(doctorData.exists){
        return Doctor.fromMap(doctorData.data()!);
      }else{
        var secretaryData = await secretariesCollection.doc(uid).get();
        if(secretaryData.exists){
          return Secretary.fromMap(secretaryData.data()!);
        }else{
          return null;
        }
      }
    }catch(e){
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signin(String email, String password) async {
    try{
      _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<void> signout() async {
    try{
      _firebaseAuth.signOut();
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<MyUser> signup(MyUser user, String password) async {
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password);
      user.uid = userCredential.user!.uid;
      if(user is Doctor){
        doctorsCollection.doc(user.uid).set(user.toMap());
      }else if(user is Secretary){
        secretariesCollection.doc(user.uid).set(user.toMap());
      }
      return user;
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Stream<MyUser?> get user{
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if(firebaseUser == null){
        yield null;
      }else{
        var doctorData = await doctorsCollection.doc(firebaseUser.uid).get();
        if(doctorData.exists){
          yield Doctor.fromMap(doctorData.data()!);
        }else{
          var secretaryData = await secretariesCollection.doc(firebaseUser.uid).get();
          if(secretaryData.exists){
            yield Secretary.fromMap(secretaryData.data()!);
          }
        }
      }
    });
  }
  
  @override
  Future<void> updateUserInfo(MyUser updatedUser) async {
    try{
      if(updatedUser is Secretary){
        await secretariesCollection.doc(updatedUser.uid).update(updatedUser.toMap());
      }else if(updatedUser is Doctor){
        await doctorsCollection.doc(updatedUser.uid).update(updatedUser.toMap());
      }
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }
}