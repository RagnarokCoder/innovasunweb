// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/inventario/backend/get_inventario.dart';
import 'package:innovasun/screens/inventario/components/card_inventario.dart';
import 'package:innovasun/widgets/buscador.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';
import 'backend/modal.dart';

class Inventario extends StatefulWidget {
  final String usuario;
  const Inventario({Key? key, required this.usuario}) : super(key: key);

  @override
  _InventarioState createState() => _InventarioState();
}

String productSelect = "";

bool isFilter = false;
bool isMayorPrecio = false;
bool isMayorCantidad = false;
bool isAgotado = false;

List<String> inventario = [];

class _InventarioState extends State<Inventario> {
  @override
  void initState() {
    getProductsI();
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
                              SizedBox(
                                  width: size.width * 0.3,
                                  height: size.height * .07,
                                  child: BuscadorText(
                                    lista: inventario,
                                    function: (String selectedValue) {
                                      setState(() {
                                        if (selectedValue == "") {
                                          productSelect = "";
                                        } else {
                                          productSelect = selectedValue;
                                        }
                                      });
                                    },
                                    titulo: "producto",
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              normalButton("Nuevo Producto", colorOrangLiU,
                                  colorOrangLiU, size, () {
                                modalInventario(
                                    size, context, false, widget.usuario, "");
                              }, setState, context, LineIcons.plus),
                            ],
                          )
                        : SizedBox(
                            width: size.width * 0.5,
                            height: size.height * .1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                                normalButton("Agotados", colorOrangLiU,
                                    colorOrangLiU, size, () {
                                  setState(() {
                                    isAgotado = !isAgotado;
                                  });
                                }, setState, context, LineIcons.batteryEmpty),
                                normalButton("Limpiar filtros", colorOrangLiU,
                                    colorOrangLiU, size, () {
                                  setState(() {
                                    isAgotado = false;
                                    isMayorCantidad = false;
                                    isMayorPrecio = false;
                                    productSelect = "";
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
    );
  }

  Widget getListaInventario(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: productSelect != ""
              ? FirebaseFirestore.instance
                  .collection("inventario")
                  .where("nombre", isEqualTo: productSelect)
                  .snapshots()
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
                              .where("cantidad", isLessThanOrEqualTo: 0)
                              .snapshots()
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
                      return CardInventario(
                        size: size,
                        doc: doc,
                        usuario: widget.usuario,
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
                          return CardInventario(
                            size: size,
                            doc: doc,
                            usuario: widget.usuario,
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
                          return CardInventario(
                            size: size,
                            doc: doc,
                            usuario: widget.usuario,
                          );
                        },
                      );
          }),
    );
  }
}
