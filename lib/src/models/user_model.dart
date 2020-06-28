// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.uid,
        this.name = '',
        this.lastName = '',
        this.ci = '',
        this.email = '',
        this.photo,
        this.uidGroup,
    });

    String uid;
    String name;
    String lastName;
    String ci;
    String email;
    String photo;
    String uidGroup;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        lastName: json["lastName"],
        ci: json["ci"],
        email: json["email"],
        photo: json["photo"],
        uidGroup: json["uidGroup"],
    );

    Map<String, dynamic> toJson() => {
        //"uid": uid,
        "name": name,
        "lastName": lastName,
        "ci": ci,
        "email": email,
        "photo": photo,
        "uidGroup": uidGroup,
    };
}
