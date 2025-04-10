

class CategoriesModels {
  String? id;
  String? userId;
  String? storeId;
  String? name;
  String? imageUrl;
  String? createdAt;

  CategoriesModels(
      {this.id,
      this.userId,
      this.storeId,
      this.name,
      this.imageUrl,
      this.createdAt});

  CategoriesModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    storeId = json['storeId'];
    name = json['name'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['storeId'] = this.storeId;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}