import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'generic_unique.dart';

class GenericPage extends StatefulWidget {

  final String id;

  GenericPage(this.id);

  @override
  State<GenericPage> createState() => _GenericPageState();

}

class _GenericPageState extends State<GenericPage> {

  late String category = 'varios';

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
                        image: AssetImage("assets/backgrounds/back-5.jpg"),
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

                      Flexible(
                        flex: 2,
                        child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('rec_mar')
                                .doc('listas')
                                .collection('category')
                                .doc(widget.id)
                                .collection('items').orderBy('date', descending: true)
                                .get(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              switch(snapshot.connectionState){
                                case ConnectionState.done:
                                  return Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {

                                          DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                          String desc = '';

                                          try{
                                            desc = ds['name'] + ' - ' + ds['description'];
                                          } catch(onError){
                                            desc = ds['name'];
                                          }

                                          if(desc.contains('http')){
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
                                                  onTap: () => _copy(context, ds),),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                              child: SizedBox(
                                                child: Dismissible(
                                                  key: UniqueKey(),
                                                  background: Container(color: Colors.red),
                                                  onDismissed: (direction) => _Confirmation(ds.id),
                                                  child: Card(
                                                    child: ListTile(
                                                      onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => GenericUniquePage(ds.reference))),
                                                      title: Text(
                                                        desc,
                                                        overflow: TextOverflow.visible
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              )
                                            );
                                          }

                                        }),
                                    ),
                                  );
                                default:
                                  return const Center(child: CircularProgressIndicator());
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

  _copy(context, ds){

    final snackBar = SnackBar(
      content: Text('Copiado...'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );

    Clipboard.setData(ClipboardData(text: ds['name']))
        .then((value) { //only if ->
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

  }
  

  //functions
  Future<void> _Confirmation(elementId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                          .doc(widget.id)
                          .collection(category)
                          .doc(elementId)
                          .delete().whenComplete(() {
                        Navigator.of(context).pop();
                        setState(() {

                        });
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