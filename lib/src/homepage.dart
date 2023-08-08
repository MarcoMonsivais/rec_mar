import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rec_mar/category/trabajo/trabajo_page.dart';
import 'package:rec_mar/category/links/link_page.dart';
import 'package:rec_mar/global_fun.dart' as Functions;
import 'package:rec_mar/lasttime/settings_page.dart';
import 'package:rec_mar/test/speech/speech_test.dart';
import 'package:rec_mar/test/speech/test_speech.dart';
import 'package:rec_mar/category/category_main.dart';
import 'package:rec_mar/test/speech/text_test.dart';
import 'package:rec_mar/dayToDay/day_detail.dart';
import 'package:rec_mar/lasttime/last_page.dart';
import 'package:rec_mar/src/uncat_details.dart';
import 'package:rec_mar/src/item_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec_mar/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'generic_details.dart';
import 'package:intl/intl.dart';

class MomePage extends StatefulWidget {

  final colorsBack CB;
  final imagesBack IB;

  MomePage(this.CB, this.IB);

  @override
  State<MomePage> createState() => _MomePageState();

}

class _MomePageState extends State<MomePage> {

  final PageController controllerPV = PageController(initialPage: 1);
  final TextEditingController _newMessage = TextEditingController();
  final TextEditingController _search = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  late FocusNode myFocusNode = FocusNode();
  late FocusNode searchNode = FocusNode();

  TextEditingController _desayunoController = TextEditingController();
  TextEditingController _almuerzoController = TextEditingController();
  TextEditingController _comidaController = TextEditingController();
  TextEditingController _meriendaController = TextEditingController();
  TextEditingController _cenaController = TextEditingController();
  TextEditingController _fumarController = TextEditingController();
  TextEditingController _otroController = TextEditingController();

  TextEditingController _nameAlarm = TextEditingController();
  TextEditingController _bodyAlarm = TextEditingController();
  TextEditingController _responseAlarm = TextEditingController();
  TextEditingController _schedueleAlarm = TextEditingController();

  late DocumentSnapshot ds;
  bool fumar = false;
  double letterSize = 18;
  late String date;
  late DateTime date2;

  Color currentContainerColor = Colors.amber;

  String op = '';

  bool _visible = false;
  bool desce = false;
  int page = 1;

  late String day;
  String fecha = '';
  DateTime _selectedDay = DateTime.now(), _focusDay = DateTime.now();
  String today = '';

  late DateTime mainDate;

  @override
  void initState() {
    // TODO: implement initState

    today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    FirebaseFirestore.instance
        .collection('rec_mar')
        .doc('listas')
        .collection('dayToDay').orderBy('date', descending: true)
        .get()
        .then((value) {
         if(value.docs.first.id!=DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' '))){
           FirebaseFirestore.instance
               .collection('rec_mar')
               .doc('listas')
               .collection('dayToDay')
               .doc(DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' ')))
               .set({
             'date': DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' ')),
             'desayuno': '',
             'almuerzo': '',
             'comida': '',
             'merienda': '',
             'cena': '',
             'otro': '',
             'fumar': '',
           }).then((value){
             date = DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' '));
             setState(() {
               date;
               date2;
             });
           });
         } else {
           date = value.docs.first.id;
           date2 = DateTime.parse(value.docs.first.id);
           setState(() {
             date;
             date2;
           });
         }
    });

    FirebaseFirestore.instance.collection('rec_mar/listas/phills').orderBy('date', descending: false).limitToLast(1).get().then((value) {
      mainDate = value.docs.last.data()['date'].toDate();
      setState(() {
        mainDate;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !_visible ? FloatingActionButton(
        backgroundColor: widget.CB.floatingColor,
        onPressed: () async {

          switch(controllerPV.page!.toInt()){
            case 0:

              if(!_visible){
                setState(() {
                  _visible = !_visible;
                });
              } else {
                if (_newMessage.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('rec_mar')
                      .doc('listas')
                      .collection('uncat')
                      .add({
                    'name': _newMessage.text,
                    'date': DateTime.now().toString(),
                  });

                  _newMessage.clear();
                }
              }

              break;
            case 1:
              // try {
              //   AwesomeNotifications().createNotification(
              //     content: NotificationContent(
              //       id: 10,
              //       channelKey: 'basic_channel',
              //       title: 'Hora de comer',
              //       body: 'Ayer comiste pollo',
              //       autoDismissible: false,
              //       hideLargeIconOnExpand: true,
              //     ),
              //     actionButtons: [
              //       NotificationActionButton(
              //           key: 'REPLY',
              //           label: '¿Qué comerás?',
              //           enabled: true,
              //           buttonType: ActionButtonType.InputField,
              //           icon: 'asset://assets/icon-app.png'
              //       )
              //     ],
              //   );
              // } catch(onError){
              //   print('Err: ' + onError.toString());
              // }
              break;
            case 2:
              break;
            case 3:
              await FirebaseFirestore.instance
                  .collection('rec_mar')
                  .doc('listas')
                  .collection('dayToDay')
                  .doc(date)
                  .update({
                'desayuno': ds['desayuno'].toString().isEmpty
                    ? _desayunoController.text
                    : _desayunoController.text.isEmpty
                    ? ds['desayuno']
                    : _desayunoController.text,
                'almuerzo': ds['almuerzo'].toString().isEmpty
                    ? _almuerzoController.text
                    :_almuerzoController.text.isEmpty
                    ? ds['almuerzo']
                    : _almuerzoController.text,
                'comida': ds['comida'].toString().isEmpty
                    ? _comidaController.text
                    : _comidaController.text.isEmpty
                    ? ds['comida']
                    : _comidaController.text,
                'merienda': ds['merienda'].toString().isEmpty
                    ? _meriendaController.text
                    : _meriendaController.text.isEmpty
                    ? ds['merienda']
                    : _meriendaController.text,
                'cena': ds['cena'].toString().isEmpty
                    ? _cenaController.text
                    : _cenaController.text.isEmpty
                    ? ds['cena']
                    : _cenaController.text,
                'fumar': ds['fumar'].toString().isEmpty
                    ? _fumarController.text
                    : _fumarController.text.isEmpty
                    ? ds['fumar']
                    : _fumarController.text,
                'otro': ds['otro'].toString().isEmpty
                    ? _otroController.text
                    : _otroController.text.isEmpty
                    ? ds['cena']
                    : _otroController.text,
              }).whenComplete(() {
                try {
                  FocusScope.of(context).unfocus();
                  _desayunoController.clear();
                  _almuerzoController.clear();
                  _comidaController.clear();
                  _meriendaController.clear();
                  _cenaController.clear();
                  _fumarController.clear();
                  _otroController.clear();
                  Functions.showMyDialog('Actualizado', context);
                  setState(() {

                  });
                } catch(onError){
                  Functions.showMyDialog(onError, context);
                }
              }).onError((error, stackTrace){
                Functions.showMyDialog(error, context);
              });
              break;
            default:
              controllerPV.jumpToPage(0);
              setState(() {
                _visible = !_visible;
              });
              break;
          }

        },
        child: const Icon(Icons.add),
      ): Container(),
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
              decoration: BoxDecoration(
                  color: widget.CB.fondoColor,
                  borderRadius: const BorderRadius.all(Radius.circular(40.0))
              ),
              child: PageView(
                controller: controllerPV,
                children: [
                  _lastTime(),
                  _add(),
                  _category(),
                  _dayToDay(),
                  _settings(),
                  // _pastillas()
                  // _diet()
                ],
              )
            ),
          ),

        ],
      )
    );
  }

  _lastTime(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        const SizedBox(height: 5.0,),

        SizedBox(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Actualizado'),
                  ));
                  setState(() {

                  });
                },
                child: Text(
                  'Última vez ' ,//+ DateTime.now().toString().substring(0,11),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingLastTimePage())),
                child: const Icon(Icons.settings, color: Colors.grey,),
              ),
            ],
          ),
        ),

        const Divider(height: 2.0, thickness: 2.0,),

        _visible ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: TextFormField(
            controller: _newMessage,
            focusNode: myFocusNode,
            autofocus: false,
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            style: Theme.of(context).textTheme.headline6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              contentPadding: const EdgeInsets.only(left: 25, right: 15),
              suffix: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                onPressed: () async {

                  _newMessage.clear();

                  setState(() {
                    _visible = !_visible;
                  });

                },
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.arrow_right_alt,
                  color: Colors.grey,
                ),
                onPressed: () async {

                  if(_newMessage.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('rec_mar')
                        .doc('listas')
                        .collection('lastime')
                        .add ( {
                      'name': _newMessage.text,
                      'count': 1,
                      'date': DateTime.now ( ).toString ( ),
                      'messageNotification': 'generic',
                      'emoji': 'xD',
                      'timeNotification': '20:30:00.123456'
                    } ).whenComplete(() {
                      setState(() {
                        _visible = !_visible;
                      });
                    });
                  }

                  _newMessage.clear ( );

                },
              ),
            ),
          ),
        ): 
        const SizedBox.shrink(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0, left: 5.0, right: 5.0),
            child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('rec_mar')
                    .doc('listas')
                    .collection('lastime')
                    .orderBy('date', descending: true)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.done:
                      return GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                            childAspectRatio: MediaQuery.of(context).size.width * 1.5 / (MediaQuery.of(context).size.height * 0.4),),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {

                            DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                            // if(DateTime.now().difference(DateTime.parse(ds['date'])).inDays >= 3 &&DateTime.now().difference(DateTime.parse(ds['date'])).inDays <= 15 ) {
                            //   AwesomeNotifications().createNotification(
                            //     schedule: NotificationCalendar.fromDate(date: DateTime.parse(today + ' ' + ds['timeNotification'])),
                            //     content: NotificationContent(
                            //       id: 5,
                            //       channelKey: 'basic_channel',
                            //       title: ds['name'],
                            //       body: ds['messageNotification'],
                            //       wakeUpScreen: true,
                            //       category: NotificationCategory.Reminder,
                            //       autoDismissible: false,
                            //       hideLargeIconOnExpand: true,
                            //     ),
                            //   ).whenComplete(() => print('Notificación creada para ' + ds['name']));
                            // }

                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    onLongPress: () => Navigator.push(context,MaterialPageRoute(builder: (context) => LastTimePage(ds.id,widget.CB,widget.IB))),
                                    onTap: () => _detalles(ds.id, ds['count']),
                                    title: Text(
                                      ds['name'],
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                        DateTime.now().difference(DateTime.parse(ds['date'])).inDays == 0
                                            ? 'Hace ' + DateTime.now().difference(DateTime.parse(ds['date'])).inHours.toString() + ' horas'
                                            // : DateTime.now().difference(DateTime.parse(ds['date'])).inHours <= 12
                                            //   ? 'Ayer'
                                              : DateTime.now().difference(DateTime.parse(ds['date'])).inDays == 1
                                                ? 'Ayer'
                                                : 'Hace ' + DateTime.now().difference(DateTime.parse(ds['date'])).inDays.toString() + ' días ',
                                        style: const TextStyle(
                                            fontSize: 13.0),
                                        textAlign: TextAlign.center),
                                  ),
                                )),
                            );

                          });
                    default:
                      return const Center(child: CircularProgressIndicator(),);  
                  } 
                }
            ),
          ),
        ),

      ],
    );
  }

  _add(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        const SizedBox(height: 10.0,),

        Text(
          'Agregar',
          style: Theme.of(context).textTheme.headline4,
        ),

        const Divider(height: 2.0, thickness: 2.0,),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [

              const SizedBox(height: 10,),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormField(
                  controller: _newMessage,
                  focusNode: myFocusNode,
                  autofocus: false,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.headline6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.only(left: 25, right: 15),
                    suffix: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.menu_open,
                            color: Colors.grey,
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(_newMessage.text))),
                        ),
                      ],
                    ),
                    // prefix: GestureDetector(onTap: () {
                    //     print('category');
                    //   },
                    //   child: Text('CT '),),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_right_alt,
                        color: Colors.grey,
                      ),
                      onPressed: () async {

                        if(_newMessage.text.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection('rec_mar')
                              .doc('listas')
                              .collection('uncat')
                              .add({
                            'name': _newMessage.text,
                            'date': DateTime.now().toString(),
                          });

                          _newMessage.clear();
                        }

                      },
                    ),
                    prefixIcon: GestureDetector(onTap: () =>
                      Clipboard.getData(Clipboard.kTextPlain).then((value){
                        setState(() {
                          _newMessage.text = value!.text!;
                        });//value is clipbarod data
                      }),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('PG'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.75,
              //   child: Row(
              //     children: [
              //
              //       Container(
              //         decoration: const BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))
              //         ),
              //         width: MediaQuery.of(context).size.width * 0.60,
              //         child: TextFormField(
              //           controller: _search,
              //           focusNode: searchNode,
              //           autofocus: false,
              //           cursorColor: Colors.black,
              //           keyboardType: TextInputType.multiline,
              //           style: Theme.of(context).textTheme.headline6,
              //           textCapitalization: TextCapitalization.sentences,
              //           decoration:  InputDecoration(
              //             focusedBorder: const  OutlineInputBorder(
              //               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
              //               borderSide: BorderSide(color: Colors.grey, width: 2.0),
              //             ),
              //             contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              //             hintText: 'Buscar',
              //             suffixIcon: IconButton(
              //               icon: const Icon(
              //                 Icons.arrow_right_alt,
              //                 color: Colors.grey,
              //               ),
              //               onPressed: () async {
              //
              //                 FocusScope.of(context).unfocus();
              //                 _search.clear();
              //
              //               },
              //             ),
              //           ),
              //         ),
              //       ),
              //
              //       IconButton(
              //         onPressed: (){
              //           setState(() {
              //             desce = !desce;
              //           });
              //         },
              //         icon: desce ? const Icon(Icons.arrow_upward_outlined) : const Icon(Icons.arrow_downward_outlined)),
              //
              //     ],
              //   ),
              // ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('uncat').orderBy('date', descending: desce)
                            .get(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.connectionState == ConnectionState.done) {
                            for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                            return SingleChildScrollView(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot<Object?>? ds =
                                        snapshot.data!.docs[index];

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
                                          onDismissed: (direction) => _Confirmation(ds.id),
                                          child: Card(
                                            elevation: 5,
                                            child: ListTile(
                                              onTap: () =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsPage(
                                                                ds.id,
                                                                widget.CB,
                                                                widget.IB))),
                                              title: Text(ds['name'],
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

                        return Center(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 250,
                              child: Image.network('https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/rec_mar%2Fimage%2FPinClipart.com_theater-mask-clipart_1668820.png?alt=media&token=eff6ee3b-5202-4a72-ac53-f9a7e465f1b9')),
                            const SizedBox(height: 20,),
                            const Text('Ah prro no tienes pendientes 8|\nAlgo estas haciendo mal :v')
                          ],
                        ),);
                      }
                    ),
                  ),
                )

            ],
          ),
        ),

      ],
    );
  }

  _category(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        const SizedBox(height: 10.0,),

        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryPage())),
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
                  .collection('category').where('status', isEqualTo: 'active')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                if(snapshot.connectionState == ConnectionState.done) {
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

                            return Center(
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 0,
                                        top: 10,
                                        left: 25,
                                        right: 15),
                                    child: Card(
                                      elevation: 5,
                                      child: ListTile(
                                        onTap: () {
                                          switch (ds.id) {
                                            case 'link':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LinkPage(ds.id)));
                                              break;
                                            case 'trabajo':
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TrabajoPage()));
                                              break;
                                            default:
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GenericPage(ds.id)));
                                              break;
                                          }
                                        },
                                        title: Text(ds.id,
                                            overflow: TextOverflow.ellipsis),
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
    );
  }

  _dayToDay(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        const SizedBox(height: 10.0,),

        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DayDetail(DateTime.now().toString().substring(0,DateTime.now().toString().indexOf(' '))))),
          child: Text(
            'Día a día',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),

        const Divider(height: 2.0, thickness: 2.0,),

        Flexible(
          flex: 2,
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('rec_mar')
                  .doc('listas')
                  .collection('dayToDay')
                  .doc(DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' ')))
                  .get(),
              builder: (context, snapshot) {

                if(snapshot.hasData) {
                  ds = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          Functions.itemGeneric(_desayunoController, 'Desayuno', ds, 'desayuno', 1,18),
                          Functions.itemGeneric(_almuerzoController, 'Almuerzo', ds, 'almuerzo', 1,18),
                          Functions.itemGeneric(_comidaController, 'Comida', ds, 'comida', 1,18),
                          Functions.itemGeneric(_meriendaController, 'Merienda', ds, 'merienda', 1,18),
                          Functions.itemGeneric(_cenaController, 'Cena', ds, 'cena', 1,18),
                          Functions.itemGeneric(_fumarController, 'Fumar', ds, 'fumar', 1,18),
                          Functions.itemGeneric(_otroController, 'Otro', ds, 'otro', 1,18),

                        ],
                      ),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator(),);
              }
          ),
        ),

      ],
    );
  }

  _settings(){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            'Configuración',
            style: Theme.of(context).textTheme.headline4,
          ),

          const Divider(height: 2.0, thickness: 2.0,),

          Card(
            child: ExpansionTile(
                textColor: Colors.black,
                iconColor: Colors.black,
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Colores'),
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){

                        setState(() {
                          op = 'fondo';
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(0),
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor:  widget.CB.fondoColor!,
                                  onColorChanged: changeColor,
                                  enableLabel: true,
                                  portraitOnly: false,
                                ),
                              ),
                            );
                          },
                        );

                      },
                      child: const Card(
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          title: Text('Fondo'),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){

                        setState(() {
                          op = 'letra';
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(0),
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor: widget.CB.letraColor!,
                                  onColorChanged: changeColor,
                                  enableLabel: true,
                                  portraitOnly: false,
                                ),
                              ),
                            );
                          },
                        );

                      },
                      child: const Card(
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          title: Text('Letra'),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){

                        op = 'card';

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(0),
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor: widget.CB.cardColor!,
                                  onColorChanged: changeColor,
                                  enableLabel: true,
                                  portraitOnly: false,
                                ),
                              ),
                            );
                          },
                        );

                      },
                      child: const Card(
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          title: Text('Card'),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){

                        op = 'floating';

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(0),
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor:  widget.CB.floatingColor!,
                                  onColorChanged: changeColor,
                                  enableLabel: true,
                                  portraitOnly: false,
                                ),
                              ),
                            );
                          },
                        );

                      },
                      child: const Card(
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          title: Text('Floating'),
                        ),
                      ),
                    ),
                  ),

                ]
            ),
          ),

          const Card(
            child: ExpansionTile(
                textColor: Colors.black,
                iconColor: Colors.black,
                leading: Icon(Icons.photo_album),
                title: Text('Imagen'),
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Grid')
                  ),

                ]
            ),
          ),

          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              iconColor: Colors.black,
              leading: const Icon(Icons.alarm_add),
              title: const Text('Notificaciones'),
              childrenPadding: const EdgeInsets.all(8.0),
              children: <Widget>[

                TextFormField(
                  controller: _nameAlarm,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),

                TextFormField(
                  controller: _bodyAlarm,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),

                TextFormField(
                  controller: _schedueleAlarm,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Horario',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),

                TextFormField(
                  controller: _responseAlarm,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de respuesta',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),

                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    try {
                      AwesomeNotifications().createNotification(
                        schedule: NotificationCalendar.fromDate(date: DateTime
                            .parse(_schedueleAlarm.text)),
                        content: NotificationContent(
                          id: 4,
                          channelKey: 'basic_channel',
                          title: _nameAlarm.text,
                          body: _bodyAlarm.text,
                          wakeUpScreen: true,
                          category: NotificationCategory.Message,
                          autoDismissible: false,
                          hideLargeIconOnExpand: true,
                        ),
                        actionButtons: [
                          NotificationActionButton(
                              key: 'REPLY',
                              label: _responseAlarm.text,
                              enabled: true,
                              buttonType: ActionButtonType.InputField,
                              icon: 'asset://assets/icon-app.png'
                          )
                        ],
                      ).whenComplete(() {
                        Functions.showMyDialog('Notificación creada', context);
                        //Clear
                        
                      });
                    } catch (onError){
                      Functions.showMyDialog('Error: ' + onError.toString(), context);
                    }

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 35,
                    color: Colors.purpleAccent,
                    child: const Center(child: Text('Guardar', style: TextStyle(color: Colors.white),))),
                ),

              ]
            ),
          ),

          Card(
            child: ExpansionTile(
                textColor: Colors.black,
                iconColor: Colors.black,
                leading: const Icon(Icons.engineering),
                title: const Text('Speech'),
                children: <Widget>[

                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SpeechTest())),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 35,
                          color: Colors.grey,
                          child: const Center(child: Text('Speech test'))))
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SpeechCustomTest())),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 35,
                            color: Colors.grey,
                            child: const Center(child: Text('Speech Custom'))))
                  ),

                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TextTest())),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 35,
                              color: Colors.grey,
                              child: const Center(child: Text('Text to speech'))))
                  ),

                ]
            ),
          ),

        ],
      ),
    );
  }

  // _diet(){
  //   return SingleChildScrollView(
  //       padding: const EdgeInsets.all(10.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //
  //           Text(
  //             'Dieta',
  //             style: Theme.of(context).textTheme.headline4,
  //           ),
  //
  //           const Divider(height: 2.0, thickness: 2.0,),
  //
  //           SizedBox(
  //             height: 150,
  //             width: 300,
  //             child: TableCalendar(
  //               calendarFormat: CalendarFormat.week,
  //               locale: Localizations.localeOf(context).languageCode,
  //               firstDay: getDate(date2.subtract(Duration(days: date2.weekday - 1))),
  //               lastDay: getDate(date2.add(Duration(days: DateTime.daysPerWeek - date2.weekday))),
  //               focusedDay: _focusDay,
  //               calendarStyle: const CalendarStyle(
  //                 isTodayHighlighted: true,
  //                 outsideDaysVisible: false,
  //               ),
  //               selectedDayPredicate: (day) {
  //                 return isSameDay(_selectedDay, day);
  //               },
  //               onDaySelected: (selectedDay, focusedDay) {
  //
  //                 setState(() {
  //                   _selectedDay = selectedDay;
  //                   _focusDay = focusedDay; // update `_focusedDay` here as well
  //                   day = selectedDay.toString().substring(0,DateTime.now().toString().indexOf(' '));
  //                   // fecha = DateFormat('EEEE d', Localizations.localeOf(context).languageCode).format(selectedDay);
  //                 });
  //
  //               },
  //
  //             ),
  //           ),
  //
  //           Functions.itemGeneric(_desayunoController, 'Desayuno', ds, 'desayuno', 1,18),
  //           Functions.itemGeneric(_almuerzoController, 'Almuerzo', ds, 'almuerzo', 1,18),
  //           Functions.itemGeneric(_comidaController, 'Comida', ds, 'comida', 1,18),
  //           Functions.itemGeneric(_meriendaController, 'Merienda', ds, 'merienda', 1,18),
  //           Functions.itemGeneric(_cenaController, 'Cena', ds, 'cena', 1,18),
  //           Functions.itemGeneric(_fumarController, 'Fumar', ds, 'fumar', 1,18),
  //           Functions.itemGeneric(_otroController, 'Otro', ds, 'otro', 1,18),
  //
  //
  //
  //         ]));
  // }

  _pastillas(){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            'Horario de pastillas',
            style: Theme.of(context).textTheme.headline4,
          ),

          const Divider(height: 2.0, thickness: 2.0,),

          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('rec_mar/listas/phills').orderBy('date', descending: false).limitToLast(2).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.active:
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 2,//snapshot.data!.size,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, item){
                      DocumentSnapshot ds = snapshot.data!.docs[item];
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 2.5, top: 2.5, left: 2.5, right: 2.5),
                          child: Card(
                            elevation: 5,
                            color: Colors.grey,
                            child: ListTile(
                              title: Text(
                                ds['name'],
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                DateFormat('dd MMMM yyyy, hh:mm a').format(ds['date'].toDate()).toString(),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.center
                              ),
                            ),
                          )));
                    }
                  );
                default:
                  return const Center(child: CircularProgressIndicator(),);
              }
            }
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 2.5, top: 2.5, left: 2.5, right: 2.5),
              child: Card(
                elevation: 5,
                color: Colors.green,
                child: ListTile(
                  onTap: () async {
                    await FirebaseFirestore.instance.collection('rec_mar/listas/phills').add({
                      'date': DateTime.now(),
                      'name': 'Pastilla'
                    }).whenComplete(() {
                        setState(() {
                          mainDate = DateTime.now();
                        });
                      }
                    );
                  },
                  title: const Text(
                    'Actual',
                    style: TextStyle(
                      color: Colors.white
                    ),
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    'Siguiente pastilla: ' + DateFormat('hh a').format(mainDate.add(const Duration(hours: 8))).toString(),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center
                  ),
                ),
              ))),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 4,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, item){
              return Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.5, top: 2.5, left: 2.5, right: 2.5),
                  child: Card(
                    elevation: 5,
                    color: Colors.grey,
                    child: ListTile(
                      title: const Text(
                        'Siguiente pastilla',
                        style: TextStyle(
                          color: Colors.white
                        ),
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy, hh:mm a').format(mainDate.add(Duration(hours: (item + 2)*8))).toString(),
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center
                      ),
                    ),
                  )));
            }
          ),

        ]
      )
    );
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

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
                            .collection('uncat')
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

  Future<void> _detalles(elementId, contador) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _detailController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _detailController.clear();
                      setState(() {

                      });
                    },
                  ),

                  // TextButton(
                  //   child: const Text('Detalles'),
                  //   onPressed: () {
                  //
                  //     Navigator.of(context).pop();
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => LastDetailsPage(elementId, widget.CB, widget.IB)));
                  //
                  //   },
                  // ),

                  TextButton(
                    child: const Text('Sin detalles'),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('rec_mar')
                          .doc('listas')
                          .collection('lastime')
                          .doc(elementId)
                          .update({
                        'date': DateTime.now()
                            .toString(),
                        'count': contador + 1
                      }).whenComplete((){
                        _detailController.clear();
                        Navigator.of(context).pop();
                        setState(() {

                        });
                      });
                    },
                  ),

                  TextButton(
                      child: const Text('Aceptar'),
                      onPressed: () async {

                        await FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('lastime')
                            .doc(elementId)
                            .update({
                          'date': DateTime.now()
                              .toString(),
                          'count': contador + 1
                        });

                        await FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('lastime')
                            .doc(elementId)
                            .collection('details')
                            .add({
                          'detail': _detailController.text,
                          'date': DateTime.now().toString()
                        }).whenComplete(() {
                          Navigator.of(context).pop();
                          _detailController.clear();
                          setState(() {

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
  }

  void changeColor(Color color) {

    switch(op){
      case 'fondo':
        FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('main')
            .collection('setting')
            .doc('colors').update({
          'fondo': color.toString().substring(8,color.toString().length - 1)
        }).whenComplete(() {
          Navigator.of(context).pop();
          setState(() {
            widget.CB.fondoColor = color;
          });
        });

        break;
      case 'floating':
        FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('main')
            .collection('setting')
            .doc('colors').update({
          'floating': color.toString().substring(8,color.toString().length - 1)
        }).whenComplete(() {
          Navigator.of(context).pop();
          setState(() {
            widget.CB.floatingColor = color;
          });
        });
        break;
      case 'card':
        FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('main')
            .collection('setting')
            .doc('colors').update({
          'card': color.toString().substring(8,color.toString().length - 1)
        }).whenComplete(() {
          Navigator.of(context).pop();
          setState(() {
            widget.CB.cardColor = color;
          });
        });
        break;
      case 'letra':
        FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('main')
            .collection('setting')
            .doc('colors').update({
          'letra': color.toString().substring(8,color.toString().length - 1)
        }).whenComplete(() {
          Navigator.of(context).pop();
          setState(() {
            widget.CB.letraColor = color;
          });
        });
        break;
    }

  }

  takePhill(){

  }

}

