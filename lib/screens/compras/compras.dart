// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/compras/backend/get_compras.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;
import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../constants/responsive/responsive.dart';
import '../correos/backend/get_correo.dart';
import '../home/components/bottom_menu.dart';
import '../inventario/backend/get_inventario.dart';
import '../ventas/components/card_ventas.dart';
import 'components/card_compras.dart';
import 'components/carrito.dart';

class Compras extends StatefulWidget {
  final String usuario;
  const Compras({Key? key, required this.usuario}) : super(key: key);

  @override
  _ComprasState createState() => _ComprasState();
}

String productSelect = "";

bool isFilter = false;
bool isMayorPrecio = false;
bool isAgotado = false;
bool isCompra = false;
bool isOpenCart = false;

dynamic totalC = 0;

DateTime? dateSelect;

Map<dynamic, dynamic> carritoCompras = {};

GlobalKey<ScaffoldState> _comprasKey = GlobalKey<ScaffoldState>();

class _ComprasState extends State<Compras> {
  @override
  void initState() {
    getAllCorreos();
    getProductsI();
    getAllCompras(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isOpenCart == true) {
      _comprasKey.currentState?.openEndDrawer();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _comprasKey,
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
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Responsive.isMobile(context) && isCompra == true
                                    ? const SizedBox()
                                    : SizedBox(
                                        width: Responsive.isMobile(context)
                                            ? size.width * 0.7
                                            : size.width * 0.5,
                                        height: size.height * .12,
                                        child: DatePicker(
                                          DateTime.now(),
                                          initialSelectedDate: DateTime.now()
                                              .subtract(
                                                  const Duration(days: 15)),
                                          selectionColor: colorOrangLiU,
                                          selectedTextColor: Colors.white,
                                          onDateChange: (date) {
                                            setState(() {
                                              dateSelect = date;
                                            });
                                          },
                                        ),
                                      ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Responsive.isMobile(context)
                                    ? const SizedBox()
                                    : normalButton("Nueva Compra",
                                        colorOrangLiU, colorOrangLiU, size, () {
                                        setState(() {
                                          isCompra = !isCompra;
                                        });
                                      }, setState, context, LineIcons.plus),
                                const SizedBox(
                                  width: 15,
                                ),
                                isCompra == false
                                    ? Responsive.isMobile(context)
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Text(
                                                "Total ",
                                                style: styleSecondary(
                                                    13, colorGrey),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "(\$${f.format(totalC)})",
                                                style: stylePrincipalBold(
                                                    14, colorBlack),
                                              )
                                            ],
                                          )
                                    : badges.Badge(
                                        onTap: () {
                                          setState(() {
                                            isOpenCart = true;
                                          });
                                        },
                                        badgeContent: Text(
                                          carritoCompras.isEmpty
                                              ? "0"
                                              : carritoCompras.length
                                                  .toString(),
                                          style:
                                              styleSecondary(10, Colors.white),
                                        ),
                                        child: IconButton(
                                          padding: const EdgeInsets.all(1),
                                          onPressed: () {
                                            setState(() {
                                              isOpenCart = true;
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
                                  normalButton("Limpiar filtros", colorOrangLiU,
                                      colorOrangLiU, size, () {
                                    setState(() {
                                      isAgotado = false;
                                      isMayorPrecio = false;
                                      productSelect = "";
                                      dateSelect = null;
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
              isCompra == false
                  ? getListaCompras(size)
                  : getListaInventario(size)
            ],
          ),
        ),
        floatingActionButton: Responsive.isMobile(context)
            ? normalButton("Nueva Compra", colorOrangLiU, colorOrangLiU, size,
                () {
                setState(() {
                  isCompra = !isCompra;
                });
              }, setState, context, LineIcons.plus)
            : const SizedBox(),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 4,
                  )
                : const SizedBox());
  }

  Widget getListaCompras(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.75,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: isMayorPrecio == true
              ? FirebaseFirestore.instance
                  .collection("compras")
                  .orderBy("total", descending: true)
                  .snapshots()
              : dateSelect != null
                  ? FirebaseFirestore.instance
                      .collection("compras")
                      .where(
                        "fecha",
                        isGreaterThanOrEqualTo: dateSelect,
                      )
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("compras")
                      .limit(50)
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
                return CardCompras(
                  size: size,
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
      height: size.height * 0.75,
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
                  .limit(100)
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
                        tipo: true,
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
                            tipo: true,
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
                            tipo: true,
                          );
                        },
                      );
          }),
    );
  }
}
