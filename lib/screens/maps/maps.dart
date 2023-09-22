// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:line_icons/line_icons.dart';

import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';
import '../../constants/styles/style_principal.dart';

class MapsW extends StatefulWidget {
  final Size size;
  const MapsW({Key? key, required this.size}) : super(key: key);

  @override
  _MapsWState createState() => _MapsWState();
}

Set<Marker> _markers = {};

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(23.0621922, -103.2110212),
  zoom: 3,
);

bool isFilter = false;

class _MapsWState extends State<MapsW> {
  @override
  void initState() {
    _createMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            width: size.width * 0.5,
                            height: size.height * .12,
                            child: DatePicker(
                              DateTime.now(),
                              initialSelectedDate: DateTime.now(),
                              selectionColor: colorOrangLiU,
                              selectedTextColor: Colors.white,
                              onDateChange: (date) {
                                // New date selected
                                setState(() {});
                              },
                            ),
                          )
                        : SizedBox(
                            width: size.width * 0.5,
                            height: size.height * .1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                normalButton(
                                    "Generar Reporte",
                                    colorOrangLiU,
                                    colorOrangLiU,
                                    widget.size,
                                    () {},
                                    setState,
                                    context,
                                    LineIcons.barChart),
                                normalButton(
                                    "Rango de Fechas",
                                    colorOrangLiU,
                                    colorOrangLiU,
                                    widget.size,
                                    () {},
                                    setState,
                                    context,
                                    LineIcons.calendar),
                                normalButton(
                                    "Contrato",
                                    colorOrangLiU,
                                    colorOrangLiU,
                                    widget.size,
                                    () {},
                                    setState,
                                    context,
                                    LineIcons.scroll),
                              ],
                            ),
                          )),
                const SizedBox()
              ],
            ),
            SizedBox(
              height: size.height * 0.78,
              width: size.width,
              child: GoogleMap(
                mapType: MapType.satellite,
                mapToolbarEnabled: false,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _createMarkers() async {
    double latitue = 20.144401;
    double longitu = -101.1871435;
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId("proyecto"),
        position: LatLng(latitue, longitu),
        onTap: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext bc) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: Responsive.isDesktop(context) ? 500 : 150,
                  color: Colors.transparent,
                  child: Padding(
                    padding: Responsive.isDesktop(context)
                        ? const EdgeInsets.fromLTRB(350, 0, 350, 0)
                        : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
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
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("Instalación",
                                  style: stylePrincipalBold(18, colorBlack)),
                              Text("Detalles de la instalación",
                                  style: stylePrincipalBold(11, colorGrey)),
                            ],
                          ),
                          SizedBox(
                            width: widget.size.width * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: genericButtonV(
                                      "Descargar Archivo",
                                      colorOrangLiU,
                                      colorOrangLiU,
                                      widget.size,
                                      () {},
                                      setState,
                                      context),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: genericButtonV(
                                      "Descargar Materiales",
                                      colorOrangLiU,
                                      colorOrangLiU,
                                      widget.size,
                                      () {},
                                      setState,
                                      context),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );

    setState(() {});
  }
}
