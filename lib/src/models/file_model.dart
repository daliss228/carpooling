import 'dart:convert';

List<FileModel> fileModelFromJson(String str) => List<FileModel>.from(json.decode(str).map((x) => FileModel.fromJson(x)));

class FileModel {
  FileModel({
    this.files,
    this.folderName,
  });

  List<String> files;
  String folderName;

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
    files: List<String>.from(json["files"].map((x) => x)),
    folderName: json["folderName"],
  );

}
