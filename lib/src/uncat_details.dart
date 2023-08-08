import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_mar/global.dart';
import 'package:rec_mar/global.dart' as Globals;
import 'homepage.dart';
import 'package:rec_mar/global_fun.dart' as Functions;

class DetailsPage extends StatefulWidget {

  final String id;
  final colorsBack CB;
  final imagesBack IB;

  DetailsPage(this.id, this.CB, this.IB);

  @override
  State<DetailsPage> createState() => _DetailsPageState();

}

class _DetailsPageState extends State<DetailsPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late DocumentSnapshot dsFinal;
  final typeController = DropdownEditingController<String>();
  List<String> typeList = [];

  double letterSize = 18;
  String category = '';

  @override
  void initState() {
    // TODO: implement initState
    _getTypeList();
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.IB.fondoImage!),
                  fit: BoxFit.cover))
            ),

            Center(
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: widget.CB.fondoColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40.0))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        const SizedBox(height: 10.0,),

                        Text(
                          'Detalles',
                          style: Theme.of(context).textTheme.headline4,
                        ),

                        const Divider(height: 2.0, thickness: 2.0,),

                        FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('rec_mar')
                                .doc('listas')
                                .collection('uncat')
                                .doc(widget.id)
                                .get(),
                            builder: (context, snapshot) {

                              DocumentSnapshot ds = snapshot.data!;
                              dsFinal = ds;

                              return Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                      Functions.itemGeneric(_nameController, 'Descripción', ds, 'name',1,18),
                                      Functions.itemGeneric(_dateController, 'Fecha', ds, 'date',1,18),

                                      GestureDetector(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('rec_mar')
                                              .doc('listas')
                                              .collection('uncat')
                                              .doc(widget.id)
                                              .update({
                                            'name': ds['name'].toString().isEmpty
                                                ? _nameController.text
                                                : _nameController.text.isEmpty
                                                  ? ds['name']
                                                  : _nameController.text,
                                            'date': ds['date'].toString().isEmpty
                                                ? _dateController.text
                                                :_dateController.text.isEmpty
                                                  ? ds['date']
                                                  : _dateController.text,
                                          }).whenComplete(() {
                                            try {
                                              FocusScope.of(context).unfocus();
                                              _nameController.clear();
                                              _dateController.clear();
                                              Functions.showMyDialog('Actualizado', context);
                                              setState(() {

                                              });

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MomePage(
                                                              Globals.colorsBack(),
                                                              Globals
                                                                  .imagesBack())));

                                            } catch(onError){
                                              Functions.showMyDialog(onError, context);
                                            }
                                          }).onError((error, stackTrace){
                                            Functions.showMyDialog(error, context);
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          color: Colors.purpleAccent,
                                          child: const Center(child: Text('Actualizar', style: TextStyle(color: Colors.white),)),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              );

                            }
                        ),

                        Container(
                          height: 80,
                          padding: const EdgeInsets.only(left: 25, right: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text('Asignar',
                                style: TextStyle(fontSize: 16),),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                                child: TextDropdownFormField(
                                  controller: typeController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                  dropdownHeight: 95,
                                  options: typeList,
                                  onChanged: (dynamic str) {

                                    switch(str){
                                      case 'trabajo':
                                        TextEditingController _name = TextEditingController();

                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  Text('Agrega el nombre'),
                                                  TextFormField(
                                                    controller: _name,
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                SizedBox(child:
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      TextButton(
                                                        child: Text('Cancelar'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          setState(() {

                                                          });
                                                        },
                                                      ),

                                                      TextButton(
                                                          child: Text('Aceptar'),
                                                          onPressed: () {

                                                            FirebaseFirestore.instance
                                                                .collection('rec_mar')
                                                                .doc('listas')
                                                                .collection('category')
                                                                .doc('trabajo')
                                                                .collection('items')
                                                                .doc(_name.text).collection('pendientes').add({
                                                              'code': '',
                                                              'date': dsFinal['date'],
                                                              'description': dsFinal['name'],
                                                              'name': 'Sin nombre'
                                                            }).whenComplete(() async {

                                                              await FirebaseFirestore.instance
                                                                  .collection('rec_mar')
                                                                  .doc('listas')
                                                                  .collection('uncat')
                                                                  .doc(widget.id)
                                                                  .delete().whenComplete((){

                                                                _name.clear();
                                                                Navigator.of(context).pop();

                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => MomePage(widget.CB, widget.IB)));
                                                              });


                                                            });

                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        break;
                                      case 'infoPersonal':

                                        TextEditingController _name = TextEditingController();

                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  Text('Agrega el nombre'),
                                                  TextFormField(
                                                    controller: _name,
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                SizedBox(child:
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [

                                                    TextButton(
                                                      child: Text('Cancelar'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        setState(() {

                                                        });
                                                      },
                                                    ),

                                                    TextButton(
                                                        child: Text('Aceptar'),
                                                        onPressed: () {

                                                          FirebaseFirestore.instance
                                                              .collection('rec_mar')
                                                              .doc('listas')
                                                              .collection('category')
                                                              .doc('infoPersonal')
                                                              .collection('items').add({
                                                            'date': dsFinal['date'],
                                                            'description': dsFinal['name'],
                                                            'name': _nameController.text
                                                          }).whenComplete(() async {

                                                            await FirebaseFirestore.instance
                                                                .collection('rec_mar')
                                                                .doc('listas')
                                                                .collection('uncat')
                                                                .doc(widget.id)
                                                                .delete().whenComplete((){

                                                              _name.clear();
                                                              Navigator.of(context).pop();

                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MomePage(widget.CB, widget.IB)));
                                                            });


                                                          });

                                                        }
                                                    ),
                                                  ],
                                                ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        break;
                                      default:
                                        FirebaseFirestore.instance
                                            .collection('rec_mar')
                                            .doc('listas')
                                            .collection('category')
                                            .doc(str)
                                            .collection('items')
                                            .doc(dsFinal.id)
                                            .set({
                                          'name': dsFinal['name'],
                                          'date': dsFinal['date']
                                        }).whenComplete(() async {
                                          await FirebaseFirestore.instance
                                              .collection('rec_mar')
                                              .doc('listas')
                                              .collection('uncat')
                                              .doc(widget.id)
                                              .delete();

                                          Functions.showMyDialog('Actualizado', context);

                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MomePage(widget.CB, widget.IB)));

                                        });
                                    }

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

                      ],
                    ),
                  )
              ),
            ),
          ],
        )
    );
  }

}