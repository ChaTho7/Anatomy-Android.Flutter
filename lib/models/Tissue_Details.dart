class TissueDetails {
  int id;
  String sort;
  String region;
  String name;
  String gender;
  String origin;

  TissueDetails(
      {this.id, this.name, this.region, this.sort, this.gender, this.origin});

  factory TissueDetails.fromJson(Map<String, dynamic> json) {
    return TissueDetails(
      id: json["id"],
      name: json["name"],
      region: json["region"],
      sort: json["sort"],
      gender: json["gender"],
      origin: json["origin"],
    );
  }

  Map toJson() {
    return {
      "name": name,
      "region": region,
      "sort": sort,
      "gender": gender,
      "origin": origin
    };
  }
}
