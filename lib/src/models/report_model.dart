class ReportModel {
  ReportModel({
    this.type,
    this.date,
    this.idUser,
    this.idRoute,
    this.idDriver,
    this.description,
  });

  int type;
  String date;
  String idUser;
  String idRoute;
  String idDriver;
  String description;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    type: json["type"] == null ? null : json["type"],
    date: json["date"] == null ? null : json["date"],
    idUser: json["id_user"] == null ? null : json["id_user"],
    idRoute: json["id_route"] == null ? null : json["id_route"],
    idDriver: json["id_driver"] == null ? null : json["id_driver"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "date": date == null ? null : date,
    "id_user": idUser == null ? null : idUser,
    "id_route": idRoute == null ? null : idRoute,
    "id_driver": idDriver == null ? null : idDriver,
    "description": description == null ? null : description,
  };
  
}
