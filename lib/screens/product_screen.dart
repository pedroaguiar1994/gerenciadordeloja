import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';
import 'package:gerente_loja/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {
  
  final String categoryId;
  final DocumentSnapshot product;



  ProductScreen({this.categoryId, this.product}) ;
      

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductBloc _productBloc;

  final _formkey = GlobalKey<FormState>();

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
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text("Criar Producto"),
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.remove),
            onPressed: (){},
          ),
          IconButton(
            icon:  Icon(Icons.save),
            onPressed: (){},
          ),
        ],
      ),
      body: Form(
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
                  onSaved: (l){},
                  validator:(l){},
                ),
                TextFormField(
                  initialValue:  snapshot.data["title"],
                  style: _fieldStyle,
                  decoration: _buildDecoration("Titulo"),
                  onSaved: (t){},
                  validator: (t){},
                ),
                TextFormField(
                  initialValue:  snapshot.data["description"],
                  style: _fieldStyle,
                  maxLines: 6,
                  decoration: _buildDecoration("Descriçao"),
                  onSaved: (t){},
                  validator: (t){},
                ),
                TextFormField(
                  initialValue:  snapshot.data["price"]?.toStringAsFixed(2),
                  style: _fieldStyle,
                  decoration: _buildDecoration("Preco"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (t){},
                  validator: (t){},
                )
              ],
            );
          }
        ),
      ),
    );
  }
}