// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovasun/screens/maps/backend/get_inst.dart';
import 'package:innovasun/screens/maps/backend/subir_instalacion.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/buttons/generic_button.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/inputs/text_input.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

class ModalInstall extends StatefulWidget {
  final String usuario;
  final String docu;
  const ModalInstall({Key? key, required this.usuario, required this.docu})
      : super(key: key);

  @override
  _ModalInstallState createState() => _ModalInstallState();
}

//controllers
TextEditingController clienteController = TextEditingController();
TextEditingController estadoController = TextEditingController();
TextEditingController folioController = TextEditingController();
TextEditingController nombreController = TextEditingController();
TextEditingController direccionController = TextEditingController();
TextEditingController comunidadController = TextEditingController();
TextEditingController numIntController = TextEditingController();
TextEditingController telefonoController = TextEditingController();
TextEditingController cantidadController = TextEditingController();
TextEditingController observController = TextEditingController();
TextEditingController latitud = TextEditingController();
TextEditingController longitud = TextEditingController();

bool isLoadingInst = false;

Map<dynamic, dynamic> getInst = {};
Map<dynamic, dynamic> listFiles = {};

Set<Marker> markers = {};

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(23.0621922, -103.2110212),
  zoom: 3,
);

class _ModalInstallState extends State<ModalInstall> {
  @override
  void initState() {
    clienteController.clear();
    estadoController.clear();
    folioController.clear();
    nombreController.clear();
    direccionController.clear();
    comunidadController.clear();
    numIntController.clear();
    telefonoController.clear();
    cantidadController.clear();
    observController.clear();
    latitud.clear();
    longitud.clear();
    if (widget.docu != "") {
      getEditInst(widget.docu, setState);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      height: size.height * 0.76,
      width: size.width * 0.5,
      child: ListView(
        children: [
          SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.docu != ""
                      ? "Editar Instalación"
                      : "Agregar Instalación",
                  style: styleSecondary(14, colorGrey),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Contrato", clienteController, setState),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Estado", estadoController, setState),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Folio", folioController, setState),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput("Nombre", "Nombre Completo",
                          nombreController, setState),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Dirección", direccionController, setState),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Comunidad", comunidadController, setState),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput("Nombre", "Número int/ext.",
                          numIntController, setState),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Teléfono", telefonoController, setState),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Cantidad", cantidadController, setState),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput("Nombre", "Observaciones",
                          observController, setState),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child:
                          genericInput("Nombre", "Latitud", latitud, setState),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: genericInput(
                          "Nombre", "Longitud", longitud, setState),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height * .45,
                  width: size.width * .5,
                  child: GoogleMap(
                    onTap: (argument) {
                      setState(() {
                        Map<dynamic, dynamic> coord = {
                          "latitude": argument.latitude,
                          "longitude": argument.longitude
                        };
                        latitud.text = argument.latitude.toString();
                        longitud.text = argument.longitude.toString();
                        markers.add(
                            _createMarker("id", coord, DateTime.now(), size));
                      });
                    },
                    tiltGesturesEnabled: true,
                    mapType: MapType.hybrid,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                        onTap: () {
                          uploadToStorage(setState);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: colorOrangLiU, width: 1)),
                          height: size.height * .2,
                          width: size.width * .15,
                          child: Center(
                            child: Icon(
                              LineIcons.retroCamera,
                              size: 20,
                              color: colorOrangLiU,
                            ),
                          ),
                        ),
                      ),
                      for (var i in listFiles.keys)
                        Container(
                          height: size.height * .2,
                          width: size.width * .15,
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colorGrey),
                              image: DecorationImage(
                                  image: MemoryImage(i), fit: BoxFit.cover)),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                listFiles.remove(i);
                              });
                            },
                            child: const Center(
                                child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                LineIcons.trash,
                                size: 15,
                                color: Colors.red,
                              ),
                            )),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        isLoadingInst == true
                            ? Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                    color: colorOrangLiU, size: 20))
                            : normalButton("Subir Instalación", colorOrangLiU,
                                colorOrangLiU, size, () {
                                setState(() {
                                  isLoadingInst = true;
                                });
                                subirInstalacion(size, context, setState,
                                    widget.usuario, widget.docu);
                              }, setState, context, LineIcons.plusCircle)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Marker _createMarker(
      String id, Map<dynamic, dynamic> map, DateTime fecha, Size size) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(map['latitude'], map['longitude']),
      onTap: () {},
    );
  }

  uploadToStorage(StateSetter setter) async {
    final ImagePicker picker = ImagePicker();

    var mediaData = await picker.getImage(source: ImageSource.gallery);

    List<int> bytes = await mediaData!.readAsBytes();
    listFiles.putIfAbsent(bytes, () => null);
    setter(() {});
  }
}
