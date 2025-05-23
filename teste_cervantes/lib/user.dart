class User {
  int? codUser;
  String name;

  User({required this.codUser, required this.name});

  Map<String, dynamic> toMap(){
    return {
      'codUser': codUser,
      'name': name
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      codUser: map['codUser'],
      name: map['name']
    );
  }
  
}