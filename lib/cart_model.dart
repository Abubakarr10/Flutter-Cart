class Cart{
  late final int? id;
  final String? productID;
  final String? productName;
  final int? initialPrice;
  final int? quantity;
  final int? productPrice;
  final String? unitTag;
  final String? image;

  Cart({
    required this.id,          required this.productID,
    required this.productName, required this.initialPrice,
    required this.quantity,    required this.productPrice,
    required this.unitTag,     required this.image
});
  Cart.fromMap(Map<dynamic,dynamic> res):
      id = res['id'],
        productID = res['productID'],
        productName = res['productName'],
        initialPrice = res['initialPrice'],
        quantity = res['quantity'],
        productPrice = res['productPrice'],
        unitTag = res['unitTag'],
        image = res['image'];

  Map<String, Object?> toMap(){
    return {
      'id' : id,
      'productID' : productID,
      'productName' : productName,
      'initialPrice' : initialPrice,
      'quantity' : quantity,
      'productPrice' : productPrice,
      'unitTag' : unitTag,
      'image' : image,
    };
  }
}