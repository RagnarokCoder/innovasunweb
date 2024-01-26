// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/ventas/backend/get_ventas.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

dynamic cajaChica = 0;

class CajaChica extends StatefulWidget {
  final String usuario;
  const CajaChica({Key? key, required this.usuario}) : super(key: key);

  @override
  _CajaChicaState createState() => _CajaChicaState();
}

Map<dynamic, dynamic> movimiento = {};

dynamic sumas = 0, restas = 0;

bool isEdit = false;

TextEditingController price = TextEditingController();

class _CajaChicaState extends State<CajaChica> {
  @override
  void initState() {
    getCaja(setState);
    getCajas(setState);
    for (var i in movimiento.keys) {
      if (movimiento[i]['isSum'] == true) {
        cajaChica += movimiento[i]['cantidad'];
      } else {
        cajaChica -= movimiento[i]['cantidad'];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    sumas = 0;
    restas = 0;
    for (var i in movimiento.keys) {
      if (movimiento[i]['isSum'] == true) {
        sumas += movimiento[i]['cantidad'];
      } else {
        restas += movimiento[i]['cantidad'];
      }
    }
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
            "Caja chica",
            style: styleSecondary(14, colorGrey),
          ),
          const SizedBox(
            height: 15,
          ),
          isEdit == false
              ? InkWell(
                  onTap: widget.usuario == "jeanelle_admin@innovasun.com"
                      ? () {
                          setState(() {
                            isEdit = true;
                          });
                        }
                      : null,
                  child: Text(
                    "Presupuesto\n\$${f.format(cajaChica)}",
                    textAlign: TextAlign.center,
                    style: stylePrincipalBold(12, colorBlack),
                  ),
                )
              : SizedBox(
                  height: size.height * 0.05,
                  width: Responsive.isDesktop(context)
                      ? size.width * 0.1
                      : size.width * .3,
                  child: genericInputN("Cantidad", "Precio", price, setState)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Devoluciones\n\$${f.format(sumas)}",
                textAlign: TextAlign.center,
                style: stylePrincipalBold(12, Colors.green),
              ),
              Text(
                "Salidas\n\$${f.format(restas)}",
                textAlign: TextAlign.center,
                style: stylePrincipalBold(12, Colors.red),
              ),
              Text(
                "En caja\n\$${f.format((cajaChica + sumas) - restas)}",
                textAlign: TextAlign.center,
                style: stylePrincipalBold(12, Colors.amber),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.35,
            width: size.width,
            child: ListView(
              children: [for (var i in movimiento.keys) cardAbonos(size, i)],
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
            isEdit = false;
            FirebaseFirestore.instance
                .collection("caja_chica")
                .doc("caja")
                .update({"total": double.parse(controller.text)}).then(
                    (value) => {
                          controller.clear(),
                          setState(() {
                            getCaja(setState);
                          })
                        });
          });
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

  Widget cardAbonos(Size size, var i) {
    String creacion =
        DateFormat('dd-MM-yyyy').format(movimiento[i]['fecha'].toDate());
    return Card(
      elevation: 2,
      child: Container(
        height: size.height * 0.1,
        width: Responsive.isMobile(context) ? size.width : size.width * 0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  movimiento[i]['concepto'],
                  style: styleSecondary(12, colorGrey),
                ),
                movimiento[i]['isSum'] == true
                    ? Icon(
                        LineIcons.arrowUp,
                        color: color9,
                        size: 15,
                      )
                    : Icon(
                        LineIcons.arrowDown,
                        color: color3,
                        size: 15,
                      )
              ],
            ),
            Text(
              creacion,
              style: styleSecondary(13, colorOrangLiU),
            ),
            Text(
              "\$${f.format(movimiento[i]['cantidad'])}",
              style: styleSecondary(11, colorBlack),
            ),
          ],
        ),
      ),
    );
  }
}
