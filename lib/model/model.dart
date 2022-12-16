class DataModel {
  String? title;
  bool? isTrusted;
  int? type;
  String? description;
  String? thumbnailUrl;
  String? entityId;
  int? referenceCount;

  DataModel(
      {this.title,
      this.isTrusted,
      this.type,
      this.description,
      this.thumbnailUrl,
      this.entityId,
      this.referenceCount});

  DataModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isTrusted = json['isTrusted'];
    type = json['type'];
    description = json['description'];
    thumbnailUrl = json['thumbnailUrl'];
    entityId = json['entityId'];
    referenceCount = json['referenceCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['isTrusted'] = isTrusted;
    data['type'] = type;
    data['description'] = description;
    data['thumbnailUrl'] = thumbnailUrl;
    data['entityId'] = entityId;
    data['referenceCount'] = referenceCount;
    return data;
  }
}
