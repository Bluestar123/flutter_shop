class CartInfoModel {
  String goodId;
  String goodName;
  int count;
  double price;
  String images;
  bool isCheck;

  CartInfoModel(
      {this.goodId, this.goodName, this.count, this.price, this.images,this.isCheck});

  CartInfoModel.fromJson(Map<String, dynamic> json) {
    goodId = json['goodId'];
    goodName = json['goodName'];
    count = json['count'];
    price = json['price'];
    images = json['images'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodId'] = this.goodId;
    data['goodName'] = this.goodName;
    data['count'] = this.count;
    data['price'] = this.price;
    data['images'] = this.images;
    data['isCheck'] = this.isCheck;
    return data;
  }
}