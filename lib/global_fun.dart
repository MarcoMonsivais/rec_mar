import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

itemGeneric(TextEditingController controller, String description, DocumentSnapshot ds, String dsDescription, int maxLines, double letterSize){
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () => controller.text = ds[dsDescription] + '',
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(description,
                style: TextStyle(fontSize: letterSize))),
      ),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: ds[dsDescription],
          labelStyle: const TextStyle(color: Colors.black),
        ),
      ),
    ],
  );
}

itemDietError(String description, String dsDescription, letterSize, TextEditingController controller){
  return Column(
    children: [
      const SizedBox(height: 20,),
      Align(
          alignment: Alignment.topLeft,
          child: Text(description, style: TextStyle(fontSize: letterSize * 0.8))),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: dsDescription,
          hintStyle: TextStyle(fontSize: letterSize * 1.5),
        ),
      ),
    ],
  );
}

itemDiet(String description, DocumentSnapshot ds, String dsDescription, letterSize, TextEditingController controller){
  return Column(
    children: [
      const SizedBox(height: 20,),
      Align(
          alignment: Alignment.topLeft,
          child: Text(description, style: TextStyle(fontSize: letterSize * 0.8))),
      // Align(
      //     alignment: Alignment.topLeft,
      //     child: Text(ds[dsDescription], style: TextStyle(fontSize: letterSize * 1.5))),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: ds[dsDescription],
          hintStyle: TextStyle(fontSize: letterSize * 1.5),
        ),
      ),
    ],
  );
}

// itemDiet(String header) {
//   return Card(
//     child: Column(
//       children: [
//         Text(DateFormat('EEEE dd').format(DateTime.parse(header))),
//         Expanded(
//           child: Wrap(
//             direction: Axis.vertical,
//             runSpacing: 50,
//             crossAxisAlignment: WrapCrossAlignment.start,
//             spacing: 20,
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 color: Colors.red,
//
//
//               )
//             ],
//           ),
//         ),
//
//       ],
//     ),
//   );
// }

Future<void> showMyDialog(string, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('App'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(string),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}