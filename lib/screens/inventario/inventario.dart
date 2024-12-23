// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/inventario/backend/get_inventario.dart';
import 'package:innovasun/screens/inventario/components/card_inventario.dart';
import 'package:innovasun/screens/inventario/pdf/inventario_pdf.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';
import '../../constants/styles/style_principal.dart';
import '../home/components/bottom_menu.dart';
import 'backend/modal.dart';

class Inventario extends StatefulWidget {
  final String usuario;
  final String select;
  const Inventario({Key? key, required this.usuario, required this.select})
      : super(key: key);

  @override
  _InventarioState createState() => _InventarioState();
}

bool isFilter = false;
bool isMayorPrecio = false;
bool isMayorCantidad = false;
bool isAgotado = false;

List<String> inventario = [];
Map<dynamic, dynamic> inventarioAll = {};

TextEditingController buscador = TextEditingController();

int index = 0;
String categoria = "Bodega";

StreamController<QuerySnapshot> _streamController =
    StreamController<QuerySnapshot>.broadcast();

class _InventarioState extends State<Inventario> {
  @override
  void initState() {
    getProductsI();
    buscador.clear();
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
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                filters(size),
                                Container(
                                  width: Responsive.isMobile(context)
                                      ? size.width * 0.5
                                      : size.width * 0.3,
                                  height: size.height * .07,
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
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
                                      hintStyle: styleSecondary(12, colorBlack),
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
                                widget.select == "bodega"
                                    ? const SizedBox()
                                    : normalButton("Nuevo Producto",
                                        colorOrangLiU, colorOrangLiU, size, () {
                                        modalInventario(size, context, false,
                                            widget.usuario, "");
                                      }, setState, context, LineIcons.plus),
                              ],
                            )
                          : SizedBox(
                              width: Responsive.isMobile(context)
                                  ? size.width * 0.8
                                  : size.width * 0.65,
                              height: Responsive.isMobile(context)
                                  ? size.height * 0.07
                                  : size.height * .1,
                              child: Responsive.isMobile(context)
                                  ? ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        normalButton(
                                            "Reporte Inventario",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          generateInventoryPdf(setState);
                                        }, setState, context,
                                            LineIcons.pdfFile),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        normalButton(
                                            isMayorPrecio == false
                                                ? "Mayor Precio"
                                                : "Menor Precio",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isMayorPrecio = !isMayorPrecio;
                                          });
                                        },
                                            setState,
                                            context,
                                            isMayorPrecio == false
                                                ? LineIcons.arrowUp
                                                : LineIcons.arrowDown),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        normalButton(
                                            isMayorCantidad == false
                                                ? "Mayor Cantidad"
                                                : "Menor Cantidad",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isMayorCantidad = !isMayorCantidad;
                                          });
                                        },
                                            setState,
                                            context,
                                            isMayorCantidad == false
                                                ? LineIcons.arrowUp
                                                : LineIcons.arrowDown),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        normalButton("ABC", colorOrangLiU,
                                            colorOrangLiU, size, () {
                                          setState(() {
                                            isAgotado = !isAgotado;
                                          });
                                        }, setState, context,
                                            LineIcons.batteryEmpty),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        normalButton(
                                            "Limpiar filtros",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isAgotado = false;
                                            isMayorCantidad = false;
                                            isMayorPrecio = false;
                                          });
                                        }, setState, context, LineIcons.broom),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        normalButton(
                                            "Reporte Inventario",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          generateInventoryPdf(setState);
                                        }, setState, context,
                                            LineIcons.pdfFile),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        normalButton(
                                            isMayorPrecio == false
                                                ? "Mayor Precio"
                                                : "Menor Precio",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isMayorPrecio = !isMayorPrecio;
                                          });
                                        },
                                            setState,
                                            context,
                                            isMayorPrecio == false
                                                ? LineIcons.arrowUp
                                                : LineIcons.arrowDown),
                                        normalButton(
                                            isMayorCantidad == false
                                                ? "Mayor Cantidad"
                                                : "Menor Cantidad",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isMayorCantidad = !isMayorCantidad;
                                          });
                                        },
                                            setState,
                                            context,
                                            isMayorCantidad == false
                                                ? LineIcons.arrowUp
                                                : LineIcons.arrowDown),
                                        normalButton("ABC", colorOrangLiU,
                                            colorOrangLiU, size, () {
                                          setState(() {
                                            isAgotado = !isAgotado;
                                          });
                                        }, setState, context,
                                            LineIcons.batteryEmpty),
                                        normalButton(
                                            "Limpiar filtros",
                                            colorOrangLiU,
                                            colorOrangLiU,
                                            size, () {
                                          setState(() {
                                            isAgotado = false;
                                            isMayorCantidad = false;
                                            isMayorPrecio = false;
                                          });
                                        }, setState, context, LineIcons.broom),
                                      ],
                                    ),
                            )),
                  const SizedBox()
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              getListaInventario(size)
            ],
          ),
        ),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 3,
                  )
                : const SizedBox());
  }

  Widget filters(Size size) {
    return SizedBox(
      height: size.height * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                index = 0;
                categoria = "Bodega";
              });
            },
            child: Container(
              width: Responsive.isDesktop(context)
                  ? size.width * 0.05
                  : size.width * 0.15,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      topLeft: Radius.circular(50)),
                  color: index == 0 ? colorOrangLiU : Colors.white),
              child: Center(
                child: Text(
                  "Bodega",
                  style: styleSecondary(
                      12, index == 0 ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 1;
                categoria = "Tienda";
              });
            },
            child: Container(
              width: Responsive.isDesktop(context)
                  ? size.width * 0.05
                  : size.width * 0.15,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: index == 1 ? colorOrangLiU : Colors.white),
              child: Center(
                child: Text(
                  "Tienda",
                  style: styleSecondary(
                      12, index == 1 ? Colors.white : Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
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

  Widget getListaInventario(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: buscador.text.isNotEmpty
              ? _streamController.stream
              : isMayorPrecio == true
                  ? FirebaseFirestore.instance
                      .collection("inventario")
                      .orderBy("venta", descending: isMayorPrecio)
                      .snapshots()
                  : isMayorCantidad == true
                      ? FirebaseFirestore.instance
                          .collection("inventario")
                          .orderBy("cantidad", descending: isMayorCantidad)
                          .snapshots()
                      : isAgotado == true
                          ? FirebaseFirestore.instance
                              .collection("inventario")
                              .orderBy("nombre", descending: false)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("inventario")
                              .where("categoria", isEqualTo: categoria)
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
                      return CardInventario(
                          size: size,
                          doc: doc,
                          usuario: widget.usuario,
                          select: widget.select);
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
                          return CardInventario(
                              size: size,
                              doc: doc,
                              usuario: widget.usuario,
                              select: widget.select);
                        },
                      )
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot doc =
                              snapshot.data!.docs[index];
                          return CardInventario(
                              size: size,
                              doc: doc,
                              usuario: widget.usuario,
                              select: widget.select);
                        },
                      );
          }),
    );
  }
}
