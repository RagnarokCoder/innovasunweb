// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/alerts/error.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/ventas/backend/modal_gasto.dart';
import 'package:innovasun/screens/ventas/backend/subir_ventas.dart';
import 'package:innovasun/screens/ventas/components/card_carrito.dart';
import 'package:innovasun/screens/ventas/ventas.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:uuid/uuid.dart';

class Carrito extends StatefulWidget {
  final Size size;
  final String usuario;
  final String doc;
  final StateSetter setter;
  const Carrito(
      {Key? key,
      required this.size,
      required this.usuario,
      required this.doc,
      required this.setter})
      : super(key: key);

  @override
  _CarritoState createState() => _CarritoState();
}

bool isContado = true;
bool isPin = false;
bool isPinCorrect = false;
bool isIva = false;

TextEditingController monto = TextEditingController();
TextEditingController percent = TextEditingController();

String pinL = "0522";

dynamic subtotal = 0;
dynamic descuento = 0;

var uuid = const Uuid();

class _CarritoState extends State<Carrito> {
  @override
  void initState() {
    isOpenC = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    subtotal = 0;
    if (carrito.isEmpty) {
      subtotal = 0;
      descuento = 0;
    }
    for (var i in carrito.keys) {
      subtotal += carrito[i]['precio'] * carrito[i]['cantidad'];
    }

    subtotal -= descuento;
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Carrito",
            style: styleSecondary(13, colorGrey),
          ),
          Divider(
            indent: 40,
            endIndent: 40,
            color: colorOrange,
            thickness: 1,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: widget.size.height * 0.7,
            width: widget.size.width,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: [
                carrito.isEmpty
                    ? Center(
                        child: Text(
                          "El carrito esta vacio",
                          style: styleSecondary(18, colorGrey),
                        ),
                      )
                    : const SizedBox(),
                for (var i in carrito.keys)
                  CardCarrito(
                    i: i,
                    setter: widget.setter,
                  )
              ],
            ),
          ),
          Switch(
            value: isIva,
            onChanged: (value) {
              setState(() {
                isIva = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Subtotal: \$${f.format(subtotal)}",
                style: styleSecondary(12, colorGrey),
              ),
              Text(
                isIva == false
                    ? "Iva: \$${f.format(0)}"
                    : "Iva: \$${f.format(subtotal * .16)}",
                style: stylePrincipalBold(12, colorGrey),
              ),
              Column(
                children: [
                  descuento > 0
                      ? Text(
                          "Descuento: (\$${f.format(descuento)})",
                          style: styleSecondary(11, colorBlack),
                        )
                      : const SizedBox(),
                  Text(
                    isIva == false
                        ? "Total: \$${f.format(subtotal)}"
                        : "Total: \$${f.format(subtotal * 1.16)}",
                    style: stylePrincipalBold(15, colorBlack),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          AnimatedSizeAndFade(
            child: isPin == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      isLoadingVentas == true
                          ? Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                  color: colorOrangLiU, size: 20))
                          : normalButton("Generar Venta", colorOrangLiU,
                              colorOrangLiU, widget.size, () {
                              if (isContado == true) {
                                subirVenta(widget.size, context, widget.setter,
                                    widget.usuario);
                              } else {
                                modalCredito(widget.size, context,
                                    widget.usuario, widget.setter);
                              }
                            }, setState, context, LineIcons.plusSquare),
                      normalButton("Agregar Descuento", colorOrangLiU,
                          colorOrangLiU, widget.size, () {
                        setState(() {
                          isPin = true;
                        });
                      }, setState, context, LineIcons.percent),
                      normalButtonSmall(
                          isContado == false ? "Credito" : "Contado",
                          colorOrangLiU,
                          colorOrangLiU,
                          widget.size, () {
                        setState(() {
                          isContado = !isContado;
                        });
                      }, setState, context, LineIcons.handHoldingUsDollar),
                    ],
                  )
                : isPinCorrect == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: widget.size.width * 0.1,
                            child: genericInput(
                                "Nombre", "Monto (\$)", monto, setState),
                          ),
                          SizedBox(
                            width: widget.size.width * 0.1,
                            child: genericInput(
                                "Nombre", "Porcentaje (%)", percent, setState),
                          ),
                          normalButtonSmall("Agregar", colorOrangLiU,
                              colorOrangLiU, widget.size, () {
                            setState(() {
                              if (monto.text.isNotEmpty) {
                                descuento = double.parse(monto.text);
                                monto.clear();
                                isPin = false;
                              }
                              if (percent.text.isNotEmpty) {
                                descuento = (subtotal *
                                    (double.parse(percent.text) * 0.01));
                                percent.clear();
                                isPin = false;
                              }
                            });
                          }, setState, context, LineIcons.plusCircle),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPin = false;
                                  isPinCorrect = false;
                                });
                              },
                              icon: const Icon(
                                LineIcons.times,
                                color: Colors.red,
                                size: 15,
                              ))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 150,
                            child: Pinput(
                              onCompleted: (value) {
                                setState(() {
                                  if (value == pinL) {
                                    isPinCorrect = true;
                                  } else {
                                    error(
                                        widget.size,
                                        context,
                                        "Pin incorrecto",
                                        "El pin es incorrecto, intenta nuevamente.");
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPin = false;
                                });
                              },
                              icon: const Icon(
                                LineIcons.times,
                                color: Colors.red,
                                size: 15,
                              ))
                        ],
                      ),
          )
        ],
      ),
    );
  }
}
