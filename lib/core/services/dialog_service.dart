import 'package:flutter/material.dart';

class DialogService{

 void showAlertDialog(BuildContext context){
   showDialog(context: context,
       builder: (_){
     return AlertDialog(

     );
       }
   );
 }

}