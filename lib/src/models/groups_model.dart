class GroupModel {
  GroupModel({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };

  static List<GroupModel> userModelList(List data) => List<GroupModel>.from(data.map((x) => GroupModel.fromJson(x)));
}
