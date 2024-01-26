// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/screens/maps/backend/get_instalaciones.dart';
import 'package:innovasun/screens/maps/backend/modal_mapa.dart';
import 'package:innovasun/screens/maps/components/card_install.dart';
import 'package:innovasun/screens/maps/components/modal_fechas.dart';
import 'package:innovasun/screens/maps/components/modal_instalaciones.dart';
import 'package:innovasun/screens/maps/components/pick_contrato.dart';
import 'package:innovasun/screens/maps/pdf/materiales.dart';
import 'package:innovasun/screens/maps/pdf/sanfran.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';
import '../../constants/styles/style_principal.dart';
import '../home/components/bottom_menu.dart';

class MapsW extends StatefulWidget {
  final String usuario;
  const MapsW({Key? key, required this.usuario}) : super(key: key);

  @override
  _MapsWState createState() => _MapsWState();
}

Set<Marker> markers = {};

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(23.0621922, -103.2110212),
  zoom: 3,
);

bool isFilter = false;
bool isGestures = true;
bool isFecha = false;
bool isFechas = false;
bool isMateriales = false;
bool isInstalacion = false;
bool isNuevaI = false;

Map<dynamic, dynamic> instalaciones = {};
Map<dynamic, dynamic> rInstalaciones = {};

DateTime dateSelect = DateTime.now();
DateTime? rangoA, rangoB;

class _MapsWState extends State<MapsW> {
  @override
  void initState() {
    markers.clear();
    getInstalacionesMap(setState);

    super.initState();
  }

  Marker _createMarker(
      String id, Map<dynamic, dynamic> map, DateTime fecha, Size size) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(map['latitude'], map['longitude']),
      onTap: () {
        setState(() {
          isGestures = false;
        });
        openModal(id, size);
      },
    );
  }

  bool _isInRange(DateTime date, DateTime? startDate, DateTime? endDate) {
    return startDate != null &&
        endDate != null &&
        date.isAfter(startDate) &&
        date.isBefore(endDate);
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    isGestures = true;
    Size size = MediaQuery.of(context).size;
    if (instalaciones.isNotEmpty) {
      for (var i in instalaciones.keys) {
        if (instalaciones[i]['ubicacion'] != null) {
          Map<dynamic, dynamic> map = instalaciones[i]['ubicacion'];
          DateTime fecha = instalaciones[i]['fecha'].toDate();

          if (isFecha && _isSameDate(fecha, dateSelect)) {
            markers.add(_createMarker(i, map, fecha, size));
          } else if (_isInRange(fecha, rangoA, rangoB)) {
            markers.add(_createMarker(i, map, fecha, size));
          } else if (isFecha == false) {
            markers.add(_createMarker(i, map, fecha, size));
          }
        }
      }
    }

    debugPrint(markers.length.toString());
    return Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFilter = !isFilter;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Filtros",
                          style: TextStyle(
                            color: colorGrey,
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          LineIcons.expand,
                          color: colorGrey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  AnimatedSizeAndFade(
                      child: isFilter == false
                          ? SizedBox(
                              width: Responsive.isMobile(context)
                                  ? size.width * .7
                                  : size.width * 0.5,
                              height: size.height * .12,
                              child: DatePicker(
                                DateTime.now(),
                                initialSelectedDate: DateTime.now()
                                    .subtract(const Duration(days: 15)),
                                selectionColor: colorOrangLiU,
                                selectedTextColor: Colors.white,
                                onDateChange: (date) {
                                  setState(() {
                                    markers.clear();
                                    dateSelect = date;
                                    isFecha = true;
                                  });
                                },
                              ),
                            )
                          : SizedBox(
                              width: Responsive.isMobile(context)
                                  ? size.width * .8
                                  : size.width * 0.5,
                              height: size.height * .1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  normalButton("Reporte por Fechas",
                                      colorOrangLiU, colorOrangLiU, size, () {
                                    modalFech(size, context, widget.usuario);
                                  }, setState, context, LineIcons.listUl),
                                  /*buildCalendarDialogButton(
                                    context, setState, size, widget.usuario),*/
                                  normalButton("Lista Instalaciones",
                                      colorOrangLiU, colorOrangLiU, size, () {
                                    setState(() {
                                      isInstalacion = !isInstalacion;
                                    });
                                  }, setState, context, LineIcons.listUl),
                                  normalButton("Contrato", colorOrangLiU,
                                      colorOrangLiU, size, () {
                                    modalContrato(size, context, widget.usuario,
                                        setState);
                                  }, setState, context, LineIcons.scroll),
                                  Responsive.isMobile(context)
                                      ? const SizedBox()
                                      : normalButton(
                                          "Limpiar Filtros",
                                          colorOrangLiU,
                                          colorOrangLiU,
                                          size, () {
                                          setState(() {
                                            isFecha = false;
                                            dateSelect = DateTime.now();
                                          });
                                        }, setState, context, LineIcons.broom),
                                ],
                              ),
                            )),
                  Responsive.isMobile(context) || isInstalacion == false
                      ? const SizedBox()
                      : normalButton("Nueva instalación", colorOrangLiU,
                          colorOrangLiU, size, () {
                          setState(() {
                            isNuevaI = !isNuevaI;
                          });
                        }, setState, context, LineIcons.plus),
                ],
              ),
              isInstalacion == true
                  ? isNuevaI == true
                      ? ModalInstall(
                          docu: "",
                          usuario: widget.usuario,
                        )
                      : getListaInstalaciones(size)
                  : SizedBox(
                      height: size.height * 0.78,
                      width: size.width,
                      child: GoogleMap(
                        onTap: (argument) {
                          setState(() {
                            isGestures = !isGestures;
                          });
                        },
                        tiltGesturesEnabled: true,
                        mapType: MapType.hybrid,
                        zoomGesturesEnabled: isGestures,
                        initialCameraPosition: _kGooglePlex,
                        markers: markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    )
            ],
          ),
        ),
        floatingActionButton: Responsive.isMobile(context)
            ? normalButton(
                "Nueva instalación", colorOrangLiU, colorOrangLiU, size, () {
                modalInstal(size, context, false, widget.usuario, "");
              }, setState, context, LineIcons.plus)
            : const SizedBox(),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 1,
                  )
                : const SizedBox());
  }

  Widget getListaInstalaciones(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.78,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("instalaciones")
              .orderBy("fecha", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: colorOrangLiU, size: 20));
            }
            if (snapshot.data!.docs.isEmpty) {
              return const SizedBox();
            }
            int length = snapshot.data!.docs.length;
            return ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot doc = snapshot.data!.docs[index];
                return CardInstall(
                  setter: setState,
                  doc: doc,
                  usuario: widget.usuario,
                );
              },
            );
          }),
    );
  }

  openModal(var i, Size size) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return ModalInstalacion(
            i: i,
            size: size,
            setter: setState,
          );
        });
  }
}

class ModalInstalacion extends StatefulWidget {
  final String i;
  final Size size;
  final StateSetter setter;
  const ModalInstalacion(
      {Key? key, required this.i, required this.size, required this.setter})
      : super(key: key);

  @override
  _ModalInstalacionState createState() => _ModalInstalacionState();
}

class _ModalInstalacionState extends State<ModalInstalacion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> fotos = {};
    if (instalaciones[widget.i]['fotos'] != null) {
      fotos = instalaciones[widget.i]['fotos'];
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 800,
      color: Colors.transparent,
      child: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.fromLTRB(350, 0, 350, 0)
            : const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          height: widget.size.height * .8,
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width * 0.3
              : MediaQuery.of(context).size.width - 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "lib/assets/logo.png",
                    width: 100,
                  ),
                ],
              ),
              SizedBox(
                height: widget.size.height * 0.35,
                width: widget.size.width,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Text(instalaciones[widget.i]['cliente'],
                            style: stylePrincipalBold(18, colorBlack)),
                        Text(instalaciones[widget.i]['comunidad'],
                            style: stylePrincipalBold(11, colorGrey)),
                        Text(instalaciones[widget.i]['nombre'],
                            style: stylePrincipalBold(11, colorGrey)),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text("Fotos",
                        textAlign: TextAlign.center,
                        style: stylePrincipalBold(18, colorBlack)),
                    SizedBox(
                      height: widget.size.height * 0.25,
                      width: widget.size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var f in fotos.keys)
                            Container(
                              height: widget.size.height * 0.25,
                              width: Responsive.isMobile(context)
                                  ? widget.size.width * .4
                                  : widget.size.width * 0.2,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: colorGrey),
                                  image: DecorationImage(
                                      image: NetworkImage(fotos[f]),
                                      fit: BoxFit.cover)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text("Firma",
                        textAlign: TextAlign.center,
                        style: stylePrincipalBold(18, colorBlack)),
                    Container(
                      height: widget.size.height * 0.25,
                      width: widget.size.width * 0.2,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: colorGrey),
                          image: DecorationImage(
                              image: NetworkImage(
                                  instalaciones[widget.i]['firma'] ?? ""),
                              fit: BoxFit.contain)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Responsive.isMobile(context)
                    ? widget.size.width
                    : widget.size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context) ? 150 : 250,
                      child: genericButtonV("Descargar Archivo", colorOrangLiU,
                          colorOrangLiU, widget.size, () {
                        sanfrancisco(setState, widget.i);
                      }, setState, context),
                    ),
                    instalaciones[widget.i]['materiales'] == null
                        ? const SizedBox()
                        : SizedBox(
                            width: Responsive.isMobile(context) ? 150 : 250,
                            child: isMateriales == true
                                ? Center(
                                    child:
                                        LoadingAnimationWidget.discreteCircle(
                                            color: colorOrangLiU, size: 20),
                                  )
                                : genericButtonV(
                                    "Descargar Materiales",
                                    colorOrangLiU,
                                    colorOrangLiU,
                                    widget.size, () {
                                    setState(() {
                                      isMateriales = true;
                                    });
                                    generateMateriales(
                                        setState, instalaciones[widget.i]);
                                  }, setState, context),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
