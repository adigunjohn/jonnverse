import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class DialogService{
 void showAlertDialog(BuildContext context, {required String title, String? subtitle, Widget? child,List<Widget>? actions}){
   showDialog(context: context,
       builder: (_){
     return AlertDialog(
       title:  Text(
         title,
         style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
         overflow: TextOverflow.ellipsis,
       ),
       content: child ??  Text(
         '$subtitle',
         style: Theme.of(context).textTheme.bodySmall,
         maxLines: 6,
         overflow: TextOverflow.ellipsis,
       ),
       actions: actions,
       actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
     );
       }
   );
 }

 void showBottom(BuildContext context,{double? height, required String title, String? subtitle, required Widget child}){
   showModalBottomSheet(context: context, builder: (context){
     return SizedBox(
             height: height,
             width: screenWidth(context),
             child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       title,
                       style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                       overflow: TextOverflow.ellipsis,
                     ),
                     SizedBox(height: 5,),
                     Text(
                       '$subtitle',
                       style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 14),
                       overflow: TextOverflow.ellipsis,
                     ),
                     SizedBox(height: 20,),
                     child
                   ],
                 ),
               ),
             ),
           );
   });
 }

}