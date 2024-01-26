// ignore_for_file: library_private_types_in_public_api, unused_local_variable
import 'dart:convert';
import 'package:http/http.dart' as http;
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

import '../../../constants/responsive/responsive.dart';

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
bool isCotizacion = false;
bool isEdit = false;
bool isPago = false;

TextEditingController monto = TextEditingController();
TextEditingController subtotalController = TextEditingController();
TextEditingController percent = TextEditingController();
TextEditingController cliente = TextEditingController();

String pinL = "0522";

dynamic subtotal = 0;
dynamic auxsub = 0;
dynamic descuento = 0;

Map<dynamic, dynamic> carritomail = {};

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
    if (auxsub != 0) {
      subtotal += auxsub;
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Carrito",
                style: styleSecondary(13, colorGrey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cotización",
                    style: styleSecondary(11, colorBlack),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Switch(
                    value: isCotizacion,
                    onChanged: (value) {
                      setState(() {
                        isCotizacion = value;
                      });
                    },
                  ),
                ],
              )
            ],
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
            height: widget.size.height * 0.63,
            width: widget.size.width,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: [
                genericInput("Nombre", "Cliente", cliente, setState),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Sin IVA/Con IVA",
                    style: styleSecondary(11, colorBlack),
                  ),
                  Switch(
                    value: isIva,
                    activeColor: colorOrangLiU,
                    onChanged: (value) {
                      setState(() {
                        isIva = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Efectivo/Transferencia",
                    style: styleSecondary(11, colorBlack),
                  ),
                  Switch(
                    value: isPago,
                    activeColor: colorOrangLiU,
                    onChanged: (value) {
                      setState(() {
                        isPago = value;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: widget.usuario == "lilian_admin@innovasun.com" ||
                        widget.usuario == "jeanelle_admin@innovasun.com"
                    ? () {
                        setState(() {
                          isEdit = !isEdit;
                        });
                      }
                    : null,
                child: isEdit == true
                    ? SizedBox(
                        height: widget.size.height * 0.05,
                        width: Responsive.isDesktop(context)
                            ? widget.size.width * 0.1
                            : widget.size.width * .3,
                        child: genericInputN(
                            "Cantidad", "Precio", price, setState))
                    : Text(
                        "Subtotal: \$${f.format(subtotal)}",
                        style: styleSecondary(12, colorGrey),
                      ),
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
                                for (var i in carrito.keys) {
                                  carritomail.putIfAbsent(
                                      carrito[i]['nombre'],
                                      () => {
                                            "precio":
                                                "\$${f.format(carrito[i]['precio'])}",
                                            "cantidad":
                                                f.format(carrito[i]['cantidad'])
                                          });
                                }
                                sendEmail(
                                        nombre: "",
                                        documento: "",
                                        email: "",
                                        mensaje:
                                            "Cualquier duda ó comentario puede contactarnos en innovasun.dev@gmail.com")
                                    .then((value) => {});
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

  Widget genericInputN(String title, hint, TextEditingController controller,
      StateSetter setter) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorwhite,
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          setState(() {
            auxsub = double.parse(controller.text) - subtotal;
            isEdit = false;
            controller.clear();
          });
          widget.setter(() {});
        },
        style: styleSecondary(12, colorBlack),
        keyboardType: title == "Correo"
            ? TextInputType.emailAddress
            : title == "Teléfono"
                ? TextInputType.phone
                : title == "Nombre"
                    ? TextInputType.name
                    : TextInputType.number,
        cursorColor: colorBlack,
        decoration: InputDecoration(
          fillColor: colorLightGray,
          hintText: hint,
          labelText: hint,
          hintStyle: styleSecondary(12, colorBlack),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: controller.text.isNotEmpty ? 2 : 1,
                  color: controller.text.isNotEmpty ? colorGrey : colorwhite),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: colorBlack),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Future sendEmail({
    required String nombre,
    required String documento,
    required String email,
    required String mensaje,
  }) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = 'service_mn5riqm';
    const templateId = 'template_la7vvtv';
    const userId = 'oiApsAfNbghiTHpiz';

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'mov': "Movimiento Venta en mostrador (contado) ${widget.usuario}",
            'money': "\$${f.format(total)}",
            'description': carritomail.toString(),
            'message': mensaje,
          }
        }));
  }
}
