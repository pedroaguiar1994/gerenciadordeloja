import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductBloc extends BlocBase{
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  //final _uploadingImages = BehaviorSubject<Map>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}){
    if(product != null){
      unsavedData = Map.of(product.data);
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["sizes"] = List.of(product.data["sizes"]);
    }else {
      unsavedData= {
        "title": null, "description": null , "price": null, "images":[], "sizes":[]
      };
    }
    _dataController.add(unsavedData);
  }

  void saveTitle(String title){
    unsavedData["title"] = title;
  }
  void saveDecription(String description){
    unsavedData["description"] = description;
  }
  void savePrice(String price){
    unsavedData["price"] = double.parse(price);
  }
  void saveImages(List images){
    unsavedData["images"] = images;
  }
  Future<bool> saveProduct()async{
    _loadingController.add(true);
    try{
      if(product != null ){
        await _uploadingImages(product.documentID);
        await product.reference.updateData(unsavedData);
      }else{
        DocumentReference dr = await Firestore.instance.collection("products").document(categoryId).
          collection("items").add(Map.from(unsavedData)..remove("images"));
          await _uploadingImages(dr.documentID);
          await dr.updateData(unsavedData);
      }
      _loadingController.add(false);
      return true;
    }catch(e){
      _loadingController.add(false);
    return false;
    }
    
  }

  Future _uploadingImages(String productId) async{
    for(int i = 0; i < unsavedData["images"].length; i++){
      if(unsavedData["images"] is String  ) continue;

      StorageUploadTask uploadingTask = FirebaseStorage.instance.ref().child(categoryId).
      child(productId).child(DateTime.now().millisecondsSinceEpoch.toString()).
      putFile(unsavedData["images"][i]);

      StorageTaskSnapshot s = await uploadingTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
  }

}