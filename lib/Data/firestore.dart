import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('menuItem');

class Database {
  static Future<void> addItem({
  bool accept=false,
  bool reject=false,
    required String note,
    required String email,
    required double bill,
    required String order,
    required int orderNo,
    required Timestamp date,
  }) async {
    DocumentReference documentReferencer =_firestore.collection('orderRecieved').doc();


    Map<String, dynamic> data = <String, dynamic>{
      "note":note,
      "email":email,
      "bill": bill,
      "order": order,
      "orderNo":orderNo,
      "date":date,
      "accept":false,
      "reject":false,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String itemName,
    required int itemQuantity,
    required String docId,
    required double itemPrice
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "itemName": itemName,
      "itemQuantity": itemQuantity,
      "itemPrice":itemPrice,
      };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
    _mainCollection;

    return notesItemCollection.snapshots();
  }

  static Future<void> addUser({
    required String name,
    required String email,
    required String mobile,
    required String userId,
  }) async {
    DocumentReference documentReferencer =_firestore.collection('user').doc();


    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "email": email,
      "mobile":mobile,
      "userId":userId,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }
  static Stream<QuerySnapshot> getUserInfo(id) {
    print(id);
    CollectionReference notesItemCollection =
    _firestore.collection('user');

    return notesItemCollection.where("userId",isEqualTo: id).snapshots();
  }
  static Stream<QuerySnapshot> getOrderInfo(id) {
    print(id);
    CollectionReference notesItemCollection =
    _firestore.collection('orderRecieved');

    return notesItemCollection.where("orderNo",isEqualTo: id).snapshots();
  }

  static Future<void> updateUser({
    required String name,
    required String email,
    required String phone,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _firestore.collection('user').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "email": email,
      "phone":phone,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

}