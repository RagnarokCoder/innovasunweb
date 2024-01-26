// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/compras/backend/subir_compra.dart';
import 'package:innovasun/screens/compras/components/card_carrito.dart';
import 'package:innovasun/screens/compras/compras.dart';
import 'package:innovasun/screens/ventas/ventas.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../widgets/buscador.dart';
import '../../correos/correos.dart';

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

Map<dynamic, dynamic> carritomail = {};

class _CarritoState extends State<Carrito> {
  @override
  void initState() {
    isOpenCart = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    subtotal = 0;
    if (carritoCompras.isEmpty) {
      subtotal = 0;
      descuento = 0;
    }
    for (var i in carritoCompras.keys) {
      subtotal += carritoCompras[i]['precio'] * carritoCompras[i]['cantidad'];
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
            "Carrito compras",
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
          SizedBox(
              width: widget.size.width * 0.4,
              height: widget.size.height * .07,
              child: BuscadorText(
                lista: correos,
                function: (String selectedValue) {
                  setState(() {
                    if (selectedValue == "") {
                      correoSelect = "";
                    } else {
                      correoSelect = selectedValue;
                    }
                  });
                },
                titulo: "correo",
              )),
          Container(
            height: widget.size.height * 0.65,
            width: widget.size.width,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: [
                carritoCompras.isEmpty
                    ? Center(
                        child: Text(
                          "El carrito esta vacio",
                          style: styleSecondary(18, colorGrey),
                        ),
                      )
                    : const SizedBox(),
                for (var i in carritoCompras.keys)
                  CardcarritoCompras(
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
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              isLoadingVentas == true
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          color: colorOrangLiU, size: 20))
                  : normalButton("Generar Compra", colorOrangLiU, colorOrangLiU,
                      widget.size, () {
                      for (var i in carritoCompras.keys) {
                        carritomail.putIfAbsent(
                            carritoCompras[i]['nombre'],
                            () => {
                                  "precio":
                                      "\$${f.format(carritoCompras[i]['precio'])}",
                                  "cantidad":
                                      f.format(carritoCompras[i]['cantidad'])
                                });
                      }

                      subirCompra(widget.size, context, widget.setter,
                          widget.usuario, "");
                      sendEmail(
                              nombre: "",
                              documento: "",
                              email: "",
                              mensaje:
                                  "Cualquier duda ó comentario puede contactarnos en innovasun.dev@gmail.com")
                          .then((value) => {});
                    }, setState, context, LineIcons.plusSquare),
            ],
          ))
        ],
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
            'mov': "Movimiento Compra ${widget.usuario}",
            'money': "\$${f.format(total)}",
            'description': carritomail.toString(),
            'message': mensaje,
          }
        }));
  }
}
