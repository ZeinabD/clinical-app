import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async{
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'clinic_db.db');
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Secretary (
            secretaryId TEXT NOT NULL, 
            name TEXT NOT NULL, 
            email TEXT NOT NULL,
          )
        ''');

        await db.execute('''
          CREATE TABLE Doctor (
            doctorId TEXT NOT NULL, 
            name TEXT NOT NULL, 
            email TEXT NOT NULL,
            specialization TEXT NOT NULL,
            biographie TEXT NOT NULL,
            gender TEXT NOT NULL,
          )
        ''');

        await db.execute('''
          CREATE TABLE Patient (
            patientId TEXT NOT NULL, 
            name TEXT NOT NULL, 
            email TEXT NOT NULL,
            dateOfBirth TEXT NOT NULL,
            gender TEXT NOT NULL,
          )
        ''');

        await db.execute('''
          CREATE TABLE Clinic (
            clinicId TEXT NOT NULL, 
            name TEXT NOT NULL, 
            email TEXT NOT NULL,
            adress TEXT NOT NULL,
          )
        ''');

        await db.execute('''
          CREATE TABLE Appointment (
            appointmentId TEXT NOT NULL,
            doctorId TEXT NOT NULL, 
            patientId TEXT NOT NULL, 
            date TEXT NOT NULL, 
            time TEXT NOT NULL,
            status TEXT NOT NULL,
            price REAL NOT NULL,
          )
        ''');
      }
    );
    return database;
  }
}