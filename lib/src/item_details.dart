import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec_mar/src/homepage.dart';
import 'package:rec_mar/global.dart' as Globals;

class ItemDetails extends StatefulWidget {

  final String message;

  ItemDetails(this.message);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();

}

class _ItemDetailsState extends State<ItemDetails> {

  final TextEditingController _newMessage = TextEditingController();
  late FocusNode myFocusNode = FocusNode();
  String category = '', category2 = '';

  final typeController = DropdownEditingController<String>();
  List<String> typeList = [];

  final typeListController = DropdownEditingController<String>();
  List<String> typeList2 = [];

  @override
  void initState() {
    // TODO: implement initState
    _getTypeList();
    _newMessage.text = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [

            Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgrounds/back-2.jpg"),
                        fit: BoxFit.cover))
            ),

            Center(
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0,),

                      Text(
                        'Detalles',
                        style: Theme.of(context).textTheme.headline4,
                      ),

                      const Divider(height: 2.0, thickness: 2.0,),

                      const SizedBox(height: 10.0,),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          controller: _newMessage,
                          focusNode: myFocusNode,
                          autofocus: true,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          style: Theme.of(context).textTheme.headline6,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            contentPadding: EdgeInsets.only(left: 25, right: 15),
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10,left: 25, right: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text('Categoria',
                              style: TextStyle(fontSize: 16),),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                              child: TextDropdownFormField(
                                controller: typeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                dropdownHeight: 120,
                                options: typeList,
                                onChanged: (dynamic str) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    category = str.toString();
                                  });
                                },
                              ),
                            ),),
                          ],
                        ),
                      ),

                      _cons(),

                    ],
                  )
              ),
            ),
          ],
        )
    );
  }

  _cons() {
    switch (category){
      case 'frase':
        return Text(category);
      case 'link':

        _getList();

        return Column(children: [ Container(
          padding: const EdgeInsets.only(bottom: 10, top: 10,left: 25, right: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text('Guardar en',
                style: TextStyle(fontSize: 16),),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                child: TextDropdownFormField(
                  controller: typeListController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  dropdownHeight: 120,
                  options: typeList2,
                  onChanged: (dynamic str) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      category2 = str.toString();
                    });
                  },
                ),
              ),),
            ],
          ),
        ),

          GestureDetector(
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('rec_mar')
                  .doc('listas')
                  .collection('category')
                  .doc(typeController.value)
                  .collection(category2)
                  .add ( {
                'name': _newMessage.text,
                'date': DateTime.now ( ).toString ( ),
              }).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MomePage(Globals.colorsBack(), Globals.imagesBack()))));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
              ),
              padding: const EdgeInsets.only(bottom: 10, top: 10,left: 25, right: 15),
              child: const Center(child: Text('Aceptar', style: TextStyle(color: Colors.white),)),
            ),
          ),
        ]);
      case '':
        return Container();
      default:
        return Container();
    }
  }

  _getTypeList() async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    await _db.collection('rec_mar').doc('listas').collection('category').snapshots().forEach((element) {
      if(typeList.isEmpty) {
        for (var i = 0; i < element.docs.length; ++i) {
          DocumentSnapshot ds = element.docs[i];
          typeList.add ( ds.id );
        }
      }

    });

  }

  _getList() async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    await _db.collection('rec_mar').doc('listas').collection('category').doc('link').collection('list').snapshots().forEach((element) {
      if(typeList2.isEmpty) {
        for (var i = 0; i < element.docs.length; ++i) {
          DocumentSnapshot ds = element.docs[i];
          typeList2.add ( ds.id );
        }
      }

    });

  }

}