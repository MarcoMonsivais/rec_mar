import 'package:rec_mar/category/trabajo/trabajo_page.dart';
import 'package:rec_mar/global_fun.dart' as Functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrabajoUniquePage extends StatefulWidget {

  final DocumentReference reference;

  TrabajoUniquePage(this.reference,);

  @override
  State<TrabajoUniquePage> createState() => _TrabajoUniquePageState();

}

class _TrabajoUniquePageState extends State<TrabajoUniquePage> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _description = TextEditingController();
  double letterSize = 18;

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
              child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Text(
                              'Detalles',
                              style: Theme.of(context).textTheme.headline4,
                            ),

                            GestureDetector(
                              onTap: () {
                                showMenu<String>(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(0.0, 0.0, -10.0, -25.0),
                                  items: [
                                    const PopupMenuItem<String>(
                                        child: Text('Eliminar'), value: 'Eliminar'),
                                    const PopupMenuDivider(),
                                    const PopupMenuItem<String>(
                                        child: Text('Cancelar'), value: '3'),
                                  ],
                                  elevation: 8.0,
                                ).then((value) {
                                  switch(value){
                                    case 'Eliminar':
                                      print(widget.reference.id);
                                      widget.reference.delete().whenComplete(() => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrabajoPage())));
                                      break;
                                  }

                                  // if(value == 'Reportar') {
                                  //   Alert(
                                  //       context: context,
                                  //       title: "REPORTAR",
                                  //       content: Column(
                                  //         children: const <Widget>[
                                  //
                                  //           TextField(
                                  //             decoration: InputDecoration(
                                  //               icon: Icon(Icons.person),
                                  //               labelText: 'Nombre',
                                  //             ),
                                  //           ),
                                  //           TextField(
                                  //             decoration: InputDecoration(
                                  //               icon: Icon(Icons.local_fire_department),
                                  //               labelText: 'Severidad',
                                  //             ),
                                  //           ),
                                  //           TextField(
                                  //             decoration: InputDecoration(
                                  //               icon: Icon(Icons.category),
                                  //               labelText: 'Departamento',
                                  //             ),
                                  //           ),
                                  //           TextField(
                                  //             decoration: InputDecoration(
                                  //               icon: Icon(Icons.date_range),
                                  //               labelText: 'Fecha hora',
                                  //             ),
                                  //           ),
                                  //           TextField(
                                  //             decoration: InputDecoration(
                                  //               icon: Icon(Icons.location_on),
                                  //               labelText: 'Ubicación',
                                  //             ),
                                  //           ),
                                  //           TextField(
                                  //             maxLines: 3,
                                  //             decoration: InputDecoration(
                                  //               labelText: 'Descripción',
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       buttons: [
                                  //         DialogButton(
                                  //           onPressed: () => Navigator.pop(context),
                                  //           child: const Text(
                                  //             "REPORTAR",
                                  //             style: TextStyle(color: Colors.white, fontSize: 20),
                                  //           ),
                                  //         )
                                  //       ]).show();
                                  // }
                                });
                              },
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 30,
                                  width: 25,
                                  child: Icon(Icons.dehaze)
                                ),
                              ),
                            ),

                          ],
                        ),

                        const Divider(height: 2.0, thickness: 2.0,),

                        Expanded( child:
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: FutureBuilder<DocumentSnapshot>(
                                future: widget.reference.get(),
                                builder: (context, snapshot) {

                                  DocumentSnapshot ds = snapshot.data!;

                                  if(snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 15, right: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Functions.itemGeneric(_name, 'Nombre', ds, 'name',1,18),
                                          Functions.itemGeneric(_date, 'Fecha', ds, 'date',1,18),
                                          Functions.itemGeneric(_description, 'Descripción', ds, 'description',1,18),
                                          Functions.itemGeneric(_code, 'Código', ds, 'code',5,18),
                                          GestureDetector(
                                            onTap: () async {
                                              await widget.reference
                                                  .update({
                                                'code': ds['code'].toString().isEmpty
                                                    ? _code.text
                                                    : _code.text.isEmpty
                                                      ? ds['code']
                                                      : _code.text,
                                                'date': ds['date'].toString().isEmpty
                                                    ? _date.text
                                                    :_date.text.isEmpty
                                                      ? ds['date']
                                                      : _date.text,
                                                'name': ds['name'].toString().isEmpty
                                                    ? _name.text
                                                    :_name.text.isEmpty
                                                      ? ds['name']
                                                      : _name.text,
                                                'description': ds['description'].toString().isEmpty
                                                    ? _description.text
                                                    : _description.text.isEmpty
                                                      ? ds['description']
                                                      : _description.text,
                                              }).whenComplete(() {
                                                try {
                                                  FocusScope.of(context).unfocus();
                                                  _description.clear();
                                                  _name.clear();
                                                  _date.clear();
                                                  _code.clear();
                                                  _showMyDialog('Actualizado');
                                                  setState(() {

                                                  });
                                                } catch(onError){
                                                  _showMyDialog(onError);
                                                }
                                              }).onError((error, stackTrace){
                                                _showMyDialog(error);
                                              });
                                            },
                                            child: Container(
                                              color: Colors.purpleAccent,
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
            ),
          ],
        )
    );
  }

  //Functions
  Future<void> _showMyDialog(string) async {
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

}