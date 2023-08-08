import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_mar/global.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../global_fun.dart';

class DayDetail extends StatefulWidget {

  final String date;

  DayDetail(this.date);

  @override
  State<DayDetail> createState() => _DayDetailState();

}

class _DayDetailState extends State<DayDetail> {

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _desayunoController = TextEditingController(),
    _almuerzoController =  TextEditingController(),
    _comidaController = TextEditingController(),
    _meriendaController = TextEditingController(),
    _cenaController = TextEditingController(),
    _fumarController = TextEditingController(),
    _otroController = TextEditingController();

  late DocumentSnapshot ds;
  double letterSize = 18;
  late String day;
  String fecha = '';
  DateTime _selectedDay = DateTime.now(), _focusDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    day = widget.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            print(ds['desayuno']);
            await FirebaseFirestore.instance
                .collection('rec_mar')
                .doc('listas')
                .collection('dayToDay')
                .doc(day)
                .update({
              'desayuno': ds['desayuno'].toString().isEmpty
                  ? _desayunoController.text
                  : _desayunoController.text.isEmpty
                      ? ds['desayuno']
                      : _desayunoController.text,
              'almuerzo': ds['almuerzo'].toString().isEmpty
                  ? _almuerzoController.text
                  : _almuerzoController.text.isEmpty
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
                showMyDialog('Actualizado', context);
                setState(() {});
              } catch (onError) {
                showMyDialog(onError, context);
              }
            }).onError((error, stackTrace) {
              showMyDialog(error, context);
            });
          } catch (onError){
            print('FATAL ERROR: ' + onError.toString());
          }
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.save),
      ),
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
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  const SizedBox(height: 10.0,),

                  GestureDetector(
                    onTap:() => setState(() {}),
                    child: Text(
                      'Día',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),

                  const Divider(height: 2.0, thickness: 2.0,),

                  SizedBox(
                    height: 150,
                    width: 300,
                    child: TableCalendar(
                      calendarFormat: CalendarFormat.week,
                      locale: Localizations.localeOf(context).languageCode,
                      firstDay: DateTime.now().subtract(const Duration(days: 7)),
                      lastDay: DateTime.now().add(const Duration(days: 1)),
                      focusedDay: _focusDay,
                      calendarStyle: const CalendarStyle(
                        isTodayHighlighted: true,
                        outsideDaysVisible: false,
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {

                        setState(() {
                          _selectedDay = selectedDay;
                          _focusDay = focusedDay; // update `_focusedDay` here as well
                          day = selectedDay.toString().substring(0,DateTime.now().toString().indexOf(' '));
                          // fecha = DateFormat('EEEE d', Localizations.localeOf(context).languageCode).format(selectedDay);
                        });

                      },

                    ),
                  ),

                  Flexible(
                    flex: 2,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('dayToDay')
                            .doc(day)
                            .snapshots(),
                        builder: (context, snapshot) {

                          ds = snapshot.data!;

                          try {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [

                                    itemDiet('Desayuno', ds, 'desayuno', letterSize, _desayunoController),
                                    itemDiet('Almuerzo', ds, 'almuerzo', letterSize, _almuerzoController),
                                    itemDiet('Comida', ds, 'comida', letterSize, _comidaController),
                                    itemDiet('Merienda', ds, 'merienda', letterSize, _meriendaController),
                                    itemDiet('Cena', ds, 'cena', letterSize, _cenaController),

                                    itemDiet('Fumar', ds, 'fumar', letterSize, _fumarController),
                                    itemDiet('Otro', ds, 'otro', letterSize, _otroController),

                                  ],
                                ),
                              ),


                            );
                          } catch(onerr) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [

                                    itemDietError('Desayuno', '', letterSize, _desayunoController),
                                    itemDietError('Almuerzo', '', letterSize, _almuerzoController),
                                    itemDietError('Comida', '', letterSize, _comidaController),
                                    itemDietError('Merienda', '', letterSize, _meriendaController),
                                    itemDietError('Cena', '', letterSize, _cenaController),

                                    itemDietError('Fumar', '', letterSize, _fumarController),
                                    itemDietError('Otro', '', letterSize, _otroController),

                                    GestureDetector(
                                      onTap:() async {

                                        await FirebaseFirestore.instance
                                            .collection('rec_mar')
                                            .doc('listas')
                                            .collection('dayToDay')
                                            .doc(day)
                                            .set({
                                          'desayuno': _desayunoController.text,
                                          'almuerzo': _almuerzoController.text,
                                          'comida': _comidaController.text,
                                          'merienda': _meriendaController.text,
                                          'cena': _cenaController.text,
                                          'fumar': _fumarController.text,
                                          'otro': _otroController.text,
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
                                            showMyDialog('Actualizado', context);
                                            setState(() {});
                                          } catch (onError) {
                                            showMyDialog(onError, context);
                                          }
                                        });

                                      },
                                      child: Text(
                                        'CREAR',
                                        style: Theme.of(context).textTheme.headline4,
                                      ),
                                    ),

                                  ],
                                ),
                              ),


                            );
                          }

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