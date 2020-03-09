class Admin {
  String role, adminid, password, name, email, phone;

  Admin({
    this.role,
    this.adminid,
    this.password,
    this.name,
    this.email,
    this.phone,
  });
}

class Patient {
  String role,
      patientid,
      password,
      name,
      email,
      phone,
      address,
      healthyBackground,
      problem,
      patientRecord,
      dateAppointment;

  Patient({
    this.role,
    this.patientid,
    this.password,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.healthyBackground,
    this.problem,
    this.patientRecord,
    this.dateAppointment,
  });
}

class Psychiatrist {
  String role,
      psychiatristID,
      password,
      name,
      email,
      phone,
      qualification,
      language,
      availableTime,
      location;

  Psychiatrist(
      {this.role,
      this.psychiatristID,
      this.password,
      this.name,
      this.email,
      this.phone,
      this.qualification,
      this.language,
      this.availableTime,
      this.location});
}

class CurrentIndex {
  int index;
  CurrentIndex({this.index});
}
