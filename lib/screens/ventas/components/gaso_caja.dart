// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/ventas/backend/subir_gasto.dart';
import 'package:innovasun/screens/ventas/ventas.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../constants/inputs/text_input.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

class GastosCaja extends StatefulWidget {
  final String usuario;
  const GastosCaja({Key? key, required this.usuario}) : super(key: key);

  @override
  _GastosCajaState createState() => _GastosCajaState();
}

TextEditingController cantidad = TextEditingController();
TextEditingController recibe = TextEditingController();
TextEditingController concepto = TextEditingController();

bool isSum = false;

class _GastosCajaState extends State<GastosCaja> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      height: size.height * 0.8,
      width:
          Responsive.isDesktop(context) ? size.width * 0.3 : size.width - 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Gastos en Caja",
            style: styleSecondary(14, colorGrey),
          ),
          const SizedBox(
            height: 15,
          ),
          genericInput("Nombre", "Monto*", cantidad, setState),
          genericInput("Nombre", "Quien Recibe*", recibe, setState),
          genericInput("Nombre", "Concepto*", concepto, setState),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isSum = true;
                    });
                  },
                  icon: Icon(
                    LineIcons.checkCircle,
                    color: isSum == true ? colorOrangLiU : Colors.transparent,
                    size: 15,
                  ),
                  label: Text(
                    "Sumar a caja",
                    style: styleSecondary(12, colorBlack),
                  )),
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isSum = false;
                    });
                  },
                  icon: Icon(
                    LineIcons.checkCircle,
                    color: isSum == false ? colorOrangLiU : Colors.transparent,
                    size: 15,
                  ),
                  label: Text(
                    "Restar a caja",
                    style: styleSecondary(12, colorBlack),
                  )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          isLoadingGasto == true
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: colorOrangLiU, size: 20))
              : normalButton("Subir Gasto", colorOrangLiU, colorOrangLiU, size,
                  () {
                  subirGastoCaja(size, context, setState, widget.usuario);
                  sendEmail(
                          nombre: "",
                          documento: "",
                          email: "",
                          mensaje:
                              "Cualquier duda ó comentario puede contactarnos en innovasun.dev@gmail.com")
                      .then((value) => {});
                }, setState, context, LineIcons.plusSquare)
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
            'mov': "Movimiento Gasto en caja ${widget.usuario}",
            'money': "\$${f.format(double.parse(cantidad.text))}",
            'description': concepto.text,
            'message': mensaje,
          }
        }));
  }
}
