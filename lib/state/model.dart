class Model {
  final String product;
  final double price;
  int qty;

  Model(this.product, this.price, [this.qty = 1]);

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      map['product'],
      map['price'],
      map['qty'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'product': product, 'price': price, 'qty': qty};
  }
}
