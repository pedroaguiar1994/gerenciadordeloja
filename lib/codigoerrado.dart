
/* 
import 'package:flutter/material.dart';


class UserTile extends StatelessWidget {

  final Map<String , dynamic> user;

  UserTile(this.user);
  
  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(color:Colors.white);

     
  if(user.containersKey("monoy"))
    return ListTile(
      title: Text(
        user["name"],
        style: textStyle,
      ),
      subtitle: Text(
        user["email"],
        style: textStyle,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "Pedidos: ${user["orders"]}",
            style:textStyle,
          ),
          Text(
            "Gasto: R\$${user["money].toStringAsFixed(2)}",
            style:textStyle,
          )
        ],
      ),
    );
    else
      return Container
  }
}

 */