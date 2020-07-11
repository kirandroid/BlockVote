class FirestoreUserResponse {
  final String firstName;
  final String gender;
  final String id;
  final String lastName;
  final String profilePicture;
  final List<dynamic> myElections;
  final List<dynamic> participatedElections;

  FirestoreUserResponse(
      {this.firstName,
      this.gender,
      this.id,
      this.lastName,
      this.profilePicture,
      this.myElections,
      this.participatedElections});

  FirestoreUserResponse.fromMap(Map data)
      : firstName = data["firstName"],
        lastName = data["lastName"],
        gender = data["gender"],
        id = data["id"],
        profilePicture = data["profilePicture"],
        myElections = data["myElections"],
        participatedElections = data["participatedElections"];

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'id': id,
        'profilePicture': profilePicture,
        'myElections': myElections,
        'participatedElections': participatedElections
      };
}
