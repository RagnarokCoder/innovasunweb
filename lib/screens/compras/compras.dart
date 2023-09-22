// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/compras/backend/modal_compras.dart';

import 'package:innovasun/widgets/buscador.dart';
import 'package:line_icons/line_icons.dart';

import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import 'components/card_compras.dart';

class Compras extends StatefulWidget {
  const Compras({Key? key}) : super(key: key);

  @override
  _ComprasState createState() => _ComprasState();
}

String productSelect = "";

bool isFilter = false;
bool isMayorPrecio = false;
bool isMayorCantidad = false;
bool isAgotado = false;

dynamic totalC = 0;

class _ComprasState extends State<Compras> {
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
                                    titulo: "compra",
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              normalButton("Nueva Compra", colorOrangLiU,
                                  colorOrangLiU, size, () {
                                modalCompras(size, context, false);
                              }, setState, context, LineIcons.plus),
                              const SizedBox(
                                width: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Total ",
                                    style: styleSecondary(13, colorGrey),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "(\$${f.format(totalC)})",
                                    style: stylePrincipalBold(14, colorBlack),
                                  )
                                ],
                              ),
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
            SizedBox(
              height: size.height * 0.8,
              width: size.width,
              child: ListView(
                children: [for (int i = 0; i < 4; i++) const CardCompras()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
