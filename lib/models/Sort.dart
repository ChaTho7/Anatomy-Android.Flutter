class Sort {
  int id;
  String name;
  String origin;

  Sort({this.id, this.name, this.origin});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
        id: json["id"],
        name: json["name"],
        origin: json["origin"]
    );
  }
}
