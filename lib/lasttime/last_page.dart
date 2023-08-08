import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_mar/global.dart';
import 'package:rec_mar/lasttime/last_unique.dart';

class LastTimePage extends StatefulWidget {

  final String id;
  final colorsBack CB;
  final imagesBack IB;

  LastTimePage(this.id, this.CB, this.IB);

  @override
  State<LastTimePage> createState() => _LastTimePageState();

}

class _LastTimePageState extends State<LastTimePage> {

  final TextEditingController _date = TextEditingController();
  final FocusNode fn = FocusNode();

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
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('rec_mar')
                              .doc('listas')
                              .collection('lastime')
                              .doc(widget.id).get(),
                          builder: (context, snapshot) {

                            if(snapshot.hasData){
                              return Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  GestureDetector(
                                    onTap: () => _date.text = snapshot.data!['date'],
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Última actualización: ' + snapshot.data!['name'],
                                        style: const TextStyle(fontSize: 18))
                                      ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('ID: ' + snapshot.data!.id,
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text('Count: ' + snapshot.data!['count'].toString(),
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _date,
                                    focusNode: fn,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      labelText: snapshot.data!['date'],
                                      labelStyle: const TextStyle(color: Colors.black),
                                      suffixIcon: IconButton(onPressed: () => _date.text = snapshot.data!['date'], icon: const Icon(Icons.update),)
                                    ),
                                    onEditingComplete: (){
                                      FirebaseFirestore.instance
                                          .collection('rec_mar')
                                          .doc('listas')
                                          .collection('lastime')
                                          .doc(widget.id).update({
                                        'date': _date.text
                                      }).whenComplete((){
                                        _date.clear();
                                        fn.unfocus();
                                        setState(() {

                                        });
                                      });
                                    },
                                  ),

                                ],
                              );
                            }

                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(child: CircularProgressIndicator(),);
                            }

                            return const Center(child: Text('Sin datos'));

                          }),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('rec_mar')
                                  .doc('listas')
                                  .collection('lastime')
                                  .doc(widget.id)
                                  .collection('details')
                                  .orderBy('date', descending: true)
                                  .get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                if(snapshot.hasData) {
                                  for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                                    return SingleChildScrollView(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                          return Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2,
                                                  top: 2,
                                                  left: 15,
                                                  right: 15),
                                              child: Dismissible(
                                                key: UniqueKey(),
                                                background:
                                                    Container(color: Colors.red),
                                                onDismissed: (direction) {
                                                  // _Confirmation(ds.id);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: ListTile(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LastDetailPage(
                                                                      widget.id,
                                                                      ds.id,
                                                                      widget.CB,
                                                                      widget.IB)));
                                                    },
                                                    title: Text(ds['detail'],
                                                        overflow:
                                                            TextOverflow.ellipsis),
                                                    subtitle: Row(
                                                      children: <Widget>[
                                                        const Icon(Icons.date_range,
                                                            color: Colors.black54,
                                                            size: 15),
                                                        const SizedBox(width: 5.0),
                                                        Text(ds['date'])
                                                      ],
                                                    ),
                                                    // trailing: Text('5'),
                                                  ),
                                                ),
                                              ));
                                        }),
                                    );
                                  }
                                }

                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(child: CircularProgressIndicator(),);
                                }

                                return const Center(child: Text('Sin datos'));

                              }
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          
          ],
        )
    );
  }

}