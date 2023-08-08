import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_mar/src/generic_details.dart';

class CategoryPage extends StatefulWidget {

  @override
  State<CategoryPage> createState() => _CategoryPageState();

}

class _CategoryPageState extends State<CategoryPage> {

   List<bool> _switchValue = [];
   // bool _switchValue = false;

   @override
  void initState() {
    // TODO: implement initState
     FirebaseFirestore.instance
         .collection('rec_mar')
         .doc('listas')
         .collection('category')
         .snapshots().forEach((element) {
       if(_switchValue.isEmpty) {
         print(element.docs.length);
         for (var i = 0; i < element.docs.length; ++i) {
           DocumentSnapshot ds = element.docs[i];
           if(ds['status']=='active') {
            _switchValue.add(true);
          } else {
             _switchValue.add(false);
           }
        }
       }

     });
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
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.only(bottom: 15),
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    const SizedBox(height: 10.0,),

                    GestureDetector(
                      onTap: () => setState(() {}),
                      child: Text(
                        'Categoria',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),

                    const Divider(height: 2.0, thickness: 2.0,),

                    Flexible(
                      flex: 2,
                      child: FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('rec_mar')
                              .doc('listas')
                              .collection('category')
                              .get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(),);
                            }

                            if(snapshot.connectionState == ConnectionState.done) {
                              for (var i = 0; i < snapshot.data!.docs.length; ++i) {

                                return SingleChildScrollView(
                                  child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot<Object?>? ds =
                                        snapshot.data!.docs[index];

                                        return Center(
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10),
                                                child: Card(
                                                  elevation: 5,
                                                  child: ListTile(
                                                    onTap: () =>
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GenericPage(ds.id))),
                                                    title: Text(ds.id,
                                                        overflow: TextOverflow.ellipsis),
                                                    trailing: Switch(
                                                      value: _switchValue[index],
                                                      onChanged: (value) {
                                                        if(_switchValue[index]){
                                                          FirebaseFirestore.instance
                                                              .collection('rec_mar')
                                                              .doc('listas')
                                                              .collection('category').doc(ds.id).update({
                                                            'date': ds['date'],
                                                            'description': ds['description'],
                                                            'status': 'inactive'
                                                          });
                                                        } else {
                                                          FirebaseFirestore.instance
                                                              .collection('rec_mar')
                                                              .doc('listas')
                                                              .collection('category').doc(ds.id).update({
                                                            'date': ds['date'],
                                                            'description': ds['description'],
                                                            'status': 'active'
                                                          });
                                                        }
                                                        setState(() {
                                                          _switchValue[index] = value;
                                                        });
                                                      },
                                                    ),
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
                                                )));
                                      }),
                                );
                              }
                            }

                            return const Text('Cargando');
                          }
                      ),
                    ),
                  ],
                ),
            ),
          ),

        ],
      ),
    );
  }

}