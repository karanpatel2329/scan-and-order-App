import 'package:flutter/cupertino.dart';

import 'item.dart';

class Cart extends ChangeNotifier{
  final List<Item> items = [];

  void add(Item item) {
    items.add(item);
    items.removeWhere((newItem) =>newItem.itemId == item.itemId);
    items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }


  List<Item> getList(){
    return items;
    }
  double getTotal(){
    double ans =0.0;
    for (var i in items){
      ans+=i.itemPrice*i.itemQuantity;
    }
    return ans;
  }

  void remove(Item item) {
    items.removeWhere((newItem) =>newItem.itemId == item.itemId);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
  void removeAll() {
    items.clear();
    //items.removeWhere((newItem) =>newItem.itemId == item.itemId);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

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
