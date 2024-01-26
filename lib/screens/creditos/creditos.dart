// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/responsive/responsive.dart';
import 'package:innovasun/screens/correos/backend/get_correo.dart';
import 'package:innovasun/screens/correos/correos.dart';
import 'package:innovasun/screens/creditos/backend/get_creditos.dart';
import 'package:innovasun/screens/creditos/components/card_creditos.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../widgets/buscador.dart';
import '../home/components/bottom_menu.dart';

class CreditosV extends StatefulWidget {
  final String usuario;
  const CreditosV({Key? key, required this.usuario}) : super(key: key);

  @override
  _CreditosVState createState() => _CreditosVState();
}

bool isFilter = false;
bool isAntiguo = false;
bool isVencido = false;
bool isLoadingPago = false;

dynamic vencidos = 0;

String creditoselect = "";

Map<dynamic, dynamic> creditosGet = {};

class _CreditosVState extends State<CreditosV> {
  @override
  void initState() {
    getAllCorreos();
    getCreditos(setState);
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
                                    width: Responsive.isMobile(context)
                                        ? size.width * .5
                                        : size.width * 0.3,
                                    height: size.height * .07,
                                    child: BuscadorText(
                                      lista: correos,
                                      function: (String selectedValue) {
                                        setState(() {
                                          if (selectedValue == "") {
                                            creditoselect = "";
                                          } else {
                                            creditoselect = selectedValue;
                                          }
                                        });
                                      },
                                      titulo: "credito",
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            )
                          : SizedBox(
                              width: Responsive.isMobile(context)
                                  ? size.width * 0.8
                                  : size.width * 0.5,
                              height: size.height * .1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  normalButton(
                                      isAntiguo == false
                                          ? "Más Antiguo"
                                          : "Más Reciente",
                                      colorOrangLiU,
                                      colorOrangLiU,
                                      size, () {
                                    setState(() {
                                      isAntiguo = !isAntiguo;
                                    });
                                  },
                                      setState,
                                      context,
                                      isAntiguo == false
                                          ? LineIcons.arrowUp
                                          : LineIcons.arrowDown),
                                  normalButton("Limpiar filtros", colorOrangLiU,
                                      colorOrangLiU, size, () {
                                    setState(() {
                                      isVencido = false;
                                      isAntiguo = false;
                                      creditoselect = "";
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
              getVentasCredito(size)
            ],
          ),
        ),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 5,
                  )
                : const SizedBox());
  }

  Widget getVentasCredito(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: isAntiguo == true
              ? FirebaseFirestore.instance
                  .collection("ventas")
                  .orderBy("vencimiento", descending: isAntiguo)
                  .snapshots()
              : creditoselect != ""
                  ? FirebaseFirestore.instance
                      .collection("ventas")
                      .where("isContado", isEqualTo: false)
                      .where("comprador", isEqualTo: creditoselect)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("ventas")
                      .where("isContado", isEqualTo: false)
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
                return CardCredito(
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
