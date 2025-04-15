class Prescription {
  String prescriptionId;
  String doctorId;
  String appointmentId;
  String medications;
  String instructions;

  Prescription({
    required this.prescriptionId,
    required this.appointmentId,
    required this.doctorId,
    required this.medications,
    required this.instructions,
  });

  static final empty = Prescription(prescriptionId: '', appointmentId: '', doctorId: '', medications: '', instructions: '');

  Map<String, dynamic> toMap(){
    return {
      'prescriptionId': prescriptionId,
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'medications': medications,
      'instructions': instructions,
    };
  }

  static Prescription fromMap(Map<String, dynamic> map){
    return Prescription(
      prescriptionId: map['prescriptionId'], 
      appointmentId: map['appointmentId'], 
      doctorId: map['doctorId'], 
      medications: map['medications'], 
      instructions: map['instructions']);
  }
}
