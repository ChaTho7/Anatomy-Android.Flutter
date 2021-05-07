class TissueImage {
  int id;
  int tissueId;
  String imagePath;
  String date;
  String image;
  String guid;

  TissueImage(
      {this.id,
      this.tissueId,
      this.imagePath,
      this.date,
      this.image,
      this.guid});

  factory TissueImage.fromJson(Map<String, dynamic> json) {
    return TissueImage(
        id: json["id"],
        tissueId: json["tissueId"],
        imagePath: json["imagePath"],
        date: json["date"],
        image: json["image"],
        guid: json["guid"]);
  }

  Map toJson() {
    return {
      "tissueId": tissueId,
      "imagePath": imagePath,
      "date": date,
      "image": image,
      "guid": guid
    };
  }
}
