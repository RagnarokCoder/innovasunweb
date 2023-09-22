// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/correos/backend/get_correo.dart';
import 'package:innovasun/screens/ventas/backend/modal_gasto.dart';
import 'package:innovasun/screens/ventas/components/card_ventas.dart';
import 'package:innovasun/screens/ventas/components/carrito.dart';
import 'package:innovasun/widgets/buscador.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart' as badges;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';

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

String productSelect = "";

Map<dynamic, dynamic> carrito = {};

GlobalKey<ScaffoldState> _ventasKey = GlobalKey<ScaffoldState>();

class _VentasState extends State<Ventas> {
  @override
  void initState() {
    getAllCorreos();
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
                            width: size.width * .5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: size.width * 0.3,
                                    height: size.height * .07,
                                    child: BuscadorText(
                                      lista: const [],
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
                            width: size.width * 0.5,
                            height: size.height * .1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                normalButton("Gastos en caja", colorOrangLiU,
                                    colorOrangLiU, size, () {
                                  modalGasto(size, context, widget.usuario);
                                }, setState, context, LineIcons.wallet),
                                normalButton(
                                    "Buscar QR",
                                    colorOrangLiU,
                                    colorOrangLiU,
                                    size,
                                    () {},
                                    setState,
                                    context,
                                    LineIcons.qrcode),
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
                          );
                        },
                      );
          }),
    );
  }
}
