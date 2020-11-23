class ReportModel {
    ReportModel({
        this.description,
        this.idDriver,
        this.idRoute,
        this.idUser,
        this.type
    });

    String description;
    String idRoute;
    String idUser;
    String idDriver;
    int type;

    factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        description: json["description"] == null ? null : json["description"],
        idDriver: json["id_driver"] == null ? null : json["id_driver"],
        idRoute: json["id_route"] == null ? null : json["id_route"],
        idUser: json["id_user"] == null ? null : json["id_user"],
        type: json["type"] == null ? null : json["type"],
    );

    Map<String, dynamic> toJson() => {
        "description": description == null ? null : description,
        "id_driver": idDriver == null ? null : idDriver,
        "id_route": idRoute == null ? null : idRoute,
        "id_user": idUser == null ? null : idUser,
        "type": type == null ? null : type,
    };
}
