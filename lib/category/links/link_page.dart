import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec_mar/global_fun.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LinkPage extends StatefulWidget {

  final String id;

  LinkPage(this.id);

  @override
  State<LinkPage> createState() => _LinkPageState();

}

class _LinkPageState extends State<LinkPage> {

  String category = 'varios';
  int subcategory = 0;
  String subcategoryName = '';

  bool _allItems = true;
  bool recent = true;

  List<String> typeList = [];

  final typeController = DropdownEditingController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [

            Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgrounds/back-7.jpg"),
                        fit: BoxFit.cover))
            ),

            Center(
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.89,
                  width: MediaQuery.of(context).size.width * 0.88,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0,),

                      GestureDetector(
                        onTap: () async {

                          // FirebaseFirestore.instance
                          //   .collection('rec_mar')
                          //   .doc('listas')
                          //   .collection('category')
                          //   .doc(widget.id)
                          //   .collection(category).get().then((items) {
                          //     for(var item in items.docs){
                          //       print(item.id);
                          //       item.reference.update({
                          //         'count': 0
                          //       });
                          //     }
                          //     print('DONE');
                          //   });

                        },
                        child: Text(
                          'Detalles',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),

                      const Divider(height: 2.0, thickness: 2.0,),

                      const SizedBox(height: 10.0,),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  category = 'varios';
                                  subcategory = 0;
                                  subcategoryName = 'Videos';
                                });
                              },
                              child: Text(
                                'Categoría: $category\nSearch: $subcategoryName',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  recent = !recent;
                                });
                              },
                              child: Text(
                                'Más recientes\n$recent',
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 10,left: 25, right: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            const Text('Categoria',
                              style: TextStyle(fontSize: 16),),

                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width ,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            category = 'ph';
                                          });
                                        },
                                        child: Container(
                                          width: 65,
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: const Center(child: Text('PH', style: TextStyle(color: Colors.black),))
                                        ,),),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            category = 'varios';
                                          });
                                        },
                                        child: Container(
                                          width: 65,
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: const Center(child: Text('Varios', style: TextStyle(color: Colors.black),))
                                          ,),),
                                      GestureDetector(
                                        onTap: (){
                                          
                                          TextEditingController _controll = TextEditingController();

                                          Clipboard.getData(Clipboard.kTextPlain).then((value) async {
                                            Alert(
                                              context: context,
                                              title: "AGREGAR",
                                              desc: value!.text,
                                              content: TextFormField(
                                                controller: _controll,
                                                keyboardType: TextInputType.number,
                                              ),
                                              buttons: [
                                                DialogButton(
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('rec_mar')
                                                          .doc('listas')
                                                          .collection('category')
                                                          .doc('link')
                                                          .collection('ph')
                                                          .add({
                                                        'date': DateTime.now().toString(),
                                                        'name': value.text,
                                                        'subcategory': _controll.text
                                                      }).whenComplete(() {
                                                        Navigator.of(context).pop();
                                                        setState(() {

                                                        });
                                                      });
                                                  },
                                                  width: 120,
                                                )
                                              ],
                                            ).show();
                                          }).onError((error, stackTrace) {
                                            print('errno');
                                          });

                                        },
                                        child: Container(
                                          width: 50,
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: const Center(child: Icon(Icons.add, color: Colors.black, size: 18,))
                                          ,),),
                                  ],),
                                ),
                              )

                            ),),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 10,left: 25, right: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            const Text('Tipo',
                              style: TextStyle(fontSize: 16),),

                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width ,
                                  child: Row(
                                    children: [

                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            subcategory = 0;
                                            subcategoryName = 'Videos';
                                            _allItems = false;
                                          });
                                        },
                                        child: Container(
                                          width: 65,
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: const Center(child: Text('VIDEO', style: TextStyle(color: Colors.black),))
                                        ,),),
                                      
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            subcategory = 1;
                                            subcategoryName = 'Comics';
                                            _allItems = false;
                                          });
                                        },
                                        child: Container(
                                          width: 85,
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: const Center(child: Text('COMICS', style: TextStyle(color: Colors.black),))
                                          ,),),
                                  

                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            subcategory = 0;
                                            subcategoryName = 'Videos';
                                            _allItems = true;
                                          });
                                        },
                                        child: Container(
                                          width: 65,
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: const Center(child: Text('ALL', style: TextStyle(color: Colors.black),))
                                        ,),),
                                      
                                  ],),
                                ),
                              )

                            ),),
                          ],
                        ),
                      ),

                      Flexible(
                        flex: 2,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: _getStream(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              switch(snapshot.connectionState){
                                case ConnectionState.active:
                                  return Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {

                                        DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                          child: Dismissible(
                                            key: UniqueKey(),
                                            background: Container(color: Colors.red),
                                            onDismissed: (direction) => _Confirmation(ds.id),
                                            child: AnyLinkPreview(
                                              link: ds['name'],
                                              displayDirection: UIDirection.uiDirectionHorizontal,
                                              showMultimedia: true,
                                              bodyMaxLines: 5,
                                              bodyTextOverflow: TextOverflow.ellipsis,
                                              titleStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                              bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                              errorBody: 'Show my custom error body',
                                              errorTitle: 'Show my custom error title',
                                              errorWidget: Container(
                                                color: Colors.grey[300],
                                                padding: const EdgeInsets.all(8),
                                                child: Text(
                                                  ds['name'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red
                                                  ),
                                                ),
                                              ),
                                              errorImage: "https://google.com/",
                                              cache: const Duration(days: 7),
                                              backgroundColor: Colors.grey[300],
                                              borderRadius: 12,
                                              removeElevation: false,
                                              boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
                                              onTap: () => _copy(context, ds, ds['count'])),
                                          ),
                                        );
                                      
                                    }),
                                  );
                                default:
                                  return const Text('Cargando');
                              }
                            }
                        ),
                      ),

                    ],
                  )
              ),
            ),
          ],
        )
    );
  }

  _getStream(){

    if(_allItems){
      return FirebaseFirestore.instance
        .collection('rec_mar')
        .doc('listas')
        .collection('category')
        .doc(widget.id)
        .collection(category)
        .orderBy('date', descending: recent)
        .snapshots();
    } else {
      return FirebaseFirestore.instance
        .collection('rec_mar')
        .doc('listas')
        .collection('category')
        .doc(widget.id)
        .collection(category)
        .where('subcategory', isEqualTo: subcategory)
        .orderBy('date', descending: recent)
        .snapshots();
    }

  }

  _copy(context,DocumentSnapshot ds, count){

    print(ds.id);
    print(count);

    final snackBar = SnackBar(
      content: const Text('Copiado maquinola...'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );

    Clipboard.setData(ClipboardData(text: ds['name']))
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));

    ds.reference.update({'count': count + 1});

  }
  
  Future<void> _Confirmation(elementId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseas eliminar?'),
          actions: <Widget>[
            SizedBox(child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // setState(() {

                      // });
                    },
                  ),


                  TextButton(
                      child: Text('Aceptar'),
                      onPressed: () {

                        FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('category')
                            .doc(widget.id)
                            .collection(category)
                            .doc(elementId)
                            .delete().whenComplete(() {
                              Navigator.of(context).pop();
                              // setState(() {

                              // });
                            } );

                      }
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}