import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';
import 'package:gerente_loja/validators/product_validator.dart';
import 'package:gerente_loja/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {
  
  final String categoryId;
  final DocumentSnapshot product;



  ProductScreen({this.categoryId, this.product}) ;
      

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator{

  final ProductBloc _productBloc;

  final _formkey = GlobalKey<FormState>();

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product):
          _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16
    );

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text("Criar Producto"),
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.remove),
            onPressed: (){},
          ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon:  Icon(Icons.save),
                onPressed: snapshot.data ? null : saveProduct,
              );
            }
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formkey,
            child: StreamBuilder<Map>(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Container();
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text
                      ("Imagens",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                    ),
                    ImagesWidget(
                      context:context,
                      initialValue: snapshot.data["images"],
                      onSaved: _productBloc.saveImages,
                      validator:validateImages,
                    ),
                    TextFormField(
                      initialValue:  snapshot.data["title"],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Titulo"),
                      onSaved: _productBloc.saveTitle,
                      validator: validateTitle,
                    ),
                    TextFormField(
                      initialValue:  snapshot.data["description"],
                      style: _fieldStyle,
                      maxLines: 6,
                      decoration: _buildDecoration("Descriçao"),
                      onSaved: _productBloc.saveDecription,
                      validator: validateDescription,
                    ),
                    TextFormField(
                      initialValue:  snapshot.data["price"]?.toStringAsFixed(2),
                      style: _fieldStyle,
                      decoration: _buildDecoration("Preco"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSaved: _productBloc.savePrice,
                      validator: validatePrice,
                    )
                  ],
                );
              }
            ),
          ),
           StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent,
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  void saveProduct()async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(content: Text("Salvando produto",style:TextStyle(color:Colors.white)),
        duration: Duration(minutes: 1),
        backgroundColor:Colors.redAccent ,
        )
      );
      bool success = await  _productBloc.saveProduct();

      _scaffoldkey.currentState.removeCurrentSnackBar();

      _scaffoldkey.currentState.showSnackBar(
           SnackBar(content: Text(success ? "Produto Salvo":"Erro ao salvar Produto" ,style:TextStyle(color:Colors.white)),
           backgroundColor:Colors.redAccent,
        )
      );
        

    }
  }
}