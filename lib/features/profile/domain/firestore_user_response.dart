class FirestoreUserResponse {
  final String firstName;
  final String gender;
  final String id;
  final String lastName;
  final String profilePicture;

  FirestoreUserResponse(
      {this.firstName,
      this.gender,
      this.id,
      this.lastName,
      this.profilePicture});

  FirestoreUserResponse.fromMap(Map data)
      : firstName = data["firstName"],
        lastName = data["lastName"],
        gender = data["gender"],
        id = data["id"],
        profilePicture = data["profilePicture"];

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'id': id,
        'profilePicture': profilePicture
      };
}
