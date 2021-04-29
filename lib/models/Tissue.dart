class Tissue {
  int id;
  int sortId;
  int regionId;
  String name;
  String gender;

  Tissue({this.id, this.name, this.regionId, this.sortId, this.gender});

  factory Tissue.fromJson(Map<String, dynamic> json) {
    return Tissue(
      id: json["id"],
      name: json["name"],
      regionId: json["regionId"],
      sortId: json["sortId"],
      gender: json["gender"],
    );
  }

  Map toJson() {
    return {
      "name": name,
      "regionId": regionId,
      "sortId": sortId,
      "gender": gender
    };
  }

  Map toJsonWithId() {
    return {
      "id": id,
      "name": name,
      "regionId": regionId,
      "sortId": sortId,
      "gender": gender
    };
  }
}
