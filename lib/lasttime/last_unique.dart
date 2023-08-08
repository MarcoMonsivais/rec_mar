import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_mar/global_fun.dart' as Functions;
import 'package:rec_mar/global.dart';

class LastDetailPage extends StatefulWidget {

  final String idReference;
  final String id;
  final colorsBack CB;
  final imagesBack IB;

  LastDetailPage(this.idReference,this.id, this.CB, this.IB);

  @override
  State<LastDetailPage> createState() => _LastDetailPageState();

}

class _LastDetailPageState extends State<LastDetailPage> {

  final TextEditingController _detail = TextEditingController();
  final TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [

            Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgrounds/back-1.jpg"),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      Text(
                        'Detalles',
                        style: Theme.of(context).textTheme.headline4,
                      ),

                      const Divider(height: 2.0, thickness: 2.0,),

                      Expanded( child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('rec_mar')
                                  .doc('listas')
                                  .collection('lastime')
                                  .doc(widget.idReference)
                                  .collection('details')
                                  .doc(widget.id)
                                  .get(),
                              builder: (context, snapshot) {

                                DocumentSnapshot ds = snapshot.data!;

                                if(snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Functions.itemGeneric(_date, 'Fecha', ds, 'date',1,18),
                                        Functions.itemGeneric(_detail, 'Descripción', ds, 'detail',1,18),

                                        GestureDetector(
                                          onTap: () async {
                                            await ds.reference
                                                .update({
                                              'date': ds['date'].toString().isEmpty
                                                  ? _date.text
                                                  :_date.text.isEmpty
                                                    ? ds['date']
                                                    : _date.text,
                                              'detail': ds['detail'].toString().isEmpty
                                                  ? _detail.text
                                                  : _detail.text.isEmpty
                                                    ? ds['detail']
                                                    : _detail.text,
                                            }).whenComplete(() {
                                              try {
                                                FocusScope.of(context).unfocus();
                                                _detail.clear();
                                                _date.clear();
                                                Functions.showMyDialog('Actualizado', context);
                                                setState(() {

                                                });
                                              } catch(onError){
                                                Functions.showMyDialog(onError, context);
                                              }
                                            }).onError((error, stackTrace){
                                              Functions.showMyDialog(error, context);
                                            });
                                          },
                                          child: Container(
                                            color: Colors.grey,
                                            height: 30,
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            child: const Center(child: Text('Aceptar', style: TextStyle(color: Colors.white),)),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }

                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(child: CircularProgressIndicator(),);
                                }

                                return const Center(child: Text('Sin datos'));

                              }
                          ),
                        ),
                      )

                    ],
                  )
              ),
            ),
          ],
        )
    );
  }

}