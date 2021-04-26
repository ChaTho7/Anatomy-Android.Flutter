class Tissue {
  int id;
  String name;
  String sort;
  String region;
  String gender;

  Tissue.withId({
    this.id,
    this.name,
    this.sort,
    this.region,
    this.gender,
  }) {}

  Tissue({
    this.name,
    this.sort,
    this.region,
    this.gender,
  }) {}

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["sort"] = sort;
    map["region"] = region;
    map["gender"] = gender;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Tissue.fromObject(dynamic o) {
    this.id = int.tryParse(o["id"]);
    this.name = o["name"];
    this.sort = o["sort"];
    this.region = o["region"];
    this.gender = o["gender"];
  }
}
