// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison
import 'dart:async';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/correos/backend/get_correo.dart';
import 'package:innovasun/screens/ventas/backend/get_ventas.dart';
import 'package:innovasun/screens/ventas/backend/modal_gasto.dart';
import 'package:innovasun/screens/ventas/components/card_venta.dart';
import 'package:innovasun/screens/ventas/components/card_ventas.dart';
import 'package:innovasun/screens/ventas/components/carrito.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart' as badges;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';
import '../home/components/bottom_menu.dart';

class Ventas extends StatefulWidget {
  final String usuario;
  const Ventas({Key? key, required this.usuario}) : super(key: key);

  @override
  _VentasState createState() => _VentasState();
}

bool isFilter = false;
bool isOpenC = false;
bool isLoadingVentas = false;
bool isLoadingGasto = false;
bool isVentas = false;

String productSelect = "";
String scannedValue = '';

Map<dynamic, dynamic> carrito = {};
TextEditingController buscador = TextEditingController();

List<String> ventas = [];

GlobalKey<ScaffoldState> _ventasKey = GlobalKey<ScaffoldState>();

StreamController<QuerySnapshot> _streamController =
    StreamController<QuerySnapshot>.broadcast();

class _VentasState extends State<Ventas> {
  bool isSelectedQR = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool isScanning = true;
  BuildContext? modalContext;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData != null) {
        setState(() {
          scannedValue = scanData.code!;
          isSelectedQR = true;
          debugPrint(scannedValue);
        });
      }
      if (modalContext != null) {
        Navigator.of(context).pop();
        modalContext = null;
      }
      debugPrint(scanData.code!);
    });
  }

  void _startScanning(BuildContext context) {
    setState(() {
      isScanning = true;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        modalContext = context;
        return SizedBox(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: (p0) {
                  _onQRViewCreated(p0);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.of(modalContext!).pop();
                        modalContext = null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllCorreos();
    getProductosVentas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isOpenC == true) {
      _ventasKey.currentState?.openEndDrawer();
    }
    return Scaffold(
        key: _ventasKey,
        endDrawer: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: Responsive.isDesktop(context)
                    ? size.width * 0.3
                    : size.width * 0.9),
            child: Carrito(
              size: size,
              usuario: widget.usuario,
              setter: setState,
              doc: "id",
            )),
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
                                  ? size.width * .8
                                  : size.width * .5,
                              child: Row(
                                mainAxisAlignment: Responsive.isMobile(context)
                                    ? MainAxisAlignment.spaceAround
                                    : MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Responsive.isMobile(context)
                                        ? size.width * 0.5
                                        : size.width * 0.3,
                                    height: size.height * .07,
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorwhite,
                                    ),
                                    child: TextField(
                                      controller: buscador,
                                      onChanged: (value) {
                                        setState(() {
                                          filterData(value.toUpperCase());
                                        });
                                      },
                                      style: styleSecondary(12, colorBlack),
                                      keyboardType: TextInputType.name,
                                      cursorColor: colorBlack,
                                      decoration: InputDecoration(
                                        fillColor: colorLightGray,
                                        hintText: "producto",
                                        hintStyle:
                                            styleSecondary(12, colorBlack),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: buscador.text.isNotEmpty
                                                    ? 2
                                                    : 1,
                                                color: buscador.text.isNotEmpty
                                                    ? colorGrey
                                                    : colorwhite),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2, color: colorBlack),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  badges.Badge(
                                    onTap: () {
                                      setState(() {
                                        isOpenC = true;
                                      });
                                    },
                                    badgeContent: Text(
                                      carrito.isEmpty
                                          ? "0"
                                          : carrito.length.toString(),
                                      style: styleSecondary(10, Colors.white),
                                    ),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(1),
                                      onPressed: () {
                                        setState(() {
                                          isOpenC = true;
                                        });
                                      },
                                      icon: Icon(
                                        LineIcons.shoppingCart,
                                        color: colorOrange,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(
                              width: Responsive.isMobile(context)
                                  ? size.width * 0.8
                                  : size.width * 0.6,
                              height: Responsive.isMobile(context)
                                  ? size.height * 0.07
                                  : size.height * .1,
                              child: Responsive.isMobile(context)
                                  ? ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        normalButton(
                                            "Caja Chica",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          //modal
                                        }, setState, context, LineIcons.box),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        normalButton(
                                            "Gastos en caja",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          modalGasto(
                                              size, context, widget.usuario);
                                        }, setState, context, LineIcons.wallet),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        normalButton("Buscar QR", colorOrangLiU,
                                            colorOrangLiU, size, () {
                                          _startScanning(context);
                                        }, setState, context, LineIcons.qrcode),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        normalButton(
                                            "Limpiar filtros",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            scannedValue = "";
                                            productSelect = "";
                                          });
                                        }, setState, context, LineIcons.qrcode),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        normalButton(
                                            "Caja Chica",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          modalCaja(size, context,
                                              widget.usuario, setState);
                                        }, setState, context, LineIcons.box),
                                        normalButton(
                                            "Lista de Ventas",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isVentas = !isVentas;
                                          });
                                        }, setState, context, LineIcons.wallet),
                                        normalButton(
                                            "Gastos en caja",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          modalGasto(
                                              size, context, widget.usuario);
                                        }, setState, context, LineIcons.wallet),
                                        normalButton("Buscar QR", colorOrangLiU,
                                            colorOrangLiU, size, () {
                                          _startScanning(context);
                                        }, setState, context, LineIcons.qrcode),
                                        normalButton(
                                            "Limpiar filtros",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            scannedValue = "";
                                            productSelect = "";
                                          });
                                        }, setState, context, LineIcons.qrcode),
                                      ],
                                    ),
                            )),
                  const SizedBox()
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              isVentas == true ? getListaVentas(size) : getListaInventario(size)
            ],
          ),
        ),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 2,
                  )
                : const SizedBox());
  }

  void filterData(String searchTerm) {
    FirebaseFirestore.instance
        .collection("inventario")
        .where("nombre", isGreaterThanOrEqualTo: searchTerm)
        .where("nombre", isLessThan: '${searchTerm}z')
        .snapshots()
        .listen((data) {
      _streamController.add(data);
    });
  }

  Widget getListaVentas(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("ventas")
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
                return CardListVenta(
                  setter: setState,
                  doc: doc,
                  usuario: widget.usuario,
                );
              },
            );
          }),
    );
  }

  Widget getListaInventario(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: scannedValue != ''
              ? FirebaseFirestore.instance
                  .collection("inventario")
                  .where("uuid", isEqualTo: scannedValue)
                  .snapshots()
              : buscador.text.isNotEmpty
                  ? _streamController.stream
                  : FirebaseFirestore.instance
                      .collection("inventario")
                      .limit(25)
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
            return Responsive.isDesktop(context)
                ? GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data!.docs[index];
                      return CardVentas(
                        setter: setState,
                        size: size,
                        doc: doc,
                        usuario: widget.usuario,
                        tipo: false,
                      );
                    },
                  )
                : Responsive.isTablet(context)
                    ? GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot doc =
                              snapshot.data!.docs[index];
                          return CardVentas(
                            setter: setState,
                            size: size,
                            doc: doc,
                            usuario: widget.usuario,
                            tipo: false,
                          );
                        },
                      )
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot doc =
                              snapshot.data!.docs[index];
                          return CardVentas(
                            setter: setState,
                            size: size,
                            doc: doc,
                            usuario: widget.usuario,
                            tipo: false,
                          );
                        },
                      );
          }),
    );
  }
}
