class Item{
  int itemId;
  String itemName;
  int itemQuantity;
  double itemPrice;
  Item({required this.itemId,required this.itemName,required this.itemPrice,required this.itemQuantity});


  // factory Cart.fromJson(Map<String, dynamic> jsonData) {
  //   return Cart(
  //     itemId: jsonData['itemId'],
  //     itemName: jsonData['itemName'],
  //     itemQuantity: jsonData['itemQuantity'],
  //     itemPrice: jsonData['itemPrice'],
  //
  //   );
  // }
  //
  // static Map<String, dynamic> toMap(Cart cart) => {
  //   'itemId': cart.itemId,
  //   'itemName': cart.itemName,
  //   'itemQuantity': cart.itemQuantity,
  //   'itemPrice': cart.itemPrice,
  // };

  // static String encode(List<Cart> carts) => json.encode(
  //       carts.map<Map<String, dynamic>>((cart) => Cart.toMap(cart))
  //       .toList(),
  // );
  //
  // static List<Cart> decode(String carts) =>
  //     (json.decode(carts) as List<dynamic>)
  //         .map<Cart>((item) => Cart.fromJson(item))
  //         .toList();

}
