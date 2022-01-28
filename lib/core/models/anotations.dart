
class ModelAnnotations {

  int? id;
  String? title;
  String? description;
  bool status = true; // true - aberto, false - finalizado
  String? createdAt;
  String? updatedAt;

  ModelAnnotations({ this.id, this.title, this.description, required this.status, this.createdAt, this.updatedAt });

  ModelAnnotations.complete( this.id, this.title, this.description, this.status, this.createdAt, this.updatedAt );

  factory ModelAnnotations.fromJson(dynamic json) {
    return ModelAnnotations(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "description": description,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };

    return map;
  }

  @override
  String toString() => title!;
}