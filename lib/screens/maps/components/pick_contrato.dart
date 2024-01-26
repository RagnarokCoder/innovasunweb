// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/screens/maps/pdf/reporte_contrato.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/buttons/generic_button.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/inputs/text_input.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';
import '../maps.dart';
import 'modal_fechas.dart';

class PickContrato extends StatefulWidget {
  final StateSetter setter;
  const PickContrato({Key? key, required this.setter}) : super(key: key);

  @override
  _PickContratoState createState() => _PickContratoState();
}

Map<dynamic, dynamic> instalacionesGet = {};
String userSelect = "";
Map<dynamic, dynamic> instalacionesPdf = {};

class _PickContratoState extends State<PickContrato> {
  @override
  void initState() {
    for (var i in instalaciones.keys) {
      if (!instalacionesGet
          .containsKey(instalaciones[i]['cliente'].toString().toUpperCase())) {
        instalacionesGet.putIfAbsent(
            instalaciones[i]['cliente'].toString().toUpperCase(),
            () => {"select": false});
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          textInput("Nombre", "Titulo", titulo, setState, context),
          const SizedBox(
            height: 10,
          ),
          normalButton("Generar reporte", colorOrangLiU, colorOrangLiU, size,
              () {
            instalacionesPdf.clear();

            for (var r in instalaciones.keys) {
              if (userSelect ==
                  instalaciones[r]['cliente'].toString().toUpperCase()) {
                instalacionesPdf.putIfAbsent(r, () => instalaciones[r]);
                setState(() {});
              }
            }
            reporteContrato(size);
            titulo.clear();
          }, setState, context, LineIcons.plusCircle),
          SizedBox(
            width: size.width,
            child: Column(
              children: [
                for (var i in instalacionesGet.keys) selectCard(i, size)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget selectCard(var i, Size size) {
    return InkWell(
      onTap: () {
        setState(() {
          userSelect = i;
        });
      },
      child: SizedBox(
        width: Responsive.isDesktop(context) ? size.width * 0.3 : size.width,
        height: size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: Responsive.isDesktop(context)
                    ? size.width * 0.28
                    : size.width * 0.6,
                child: Text(
                  i,
                  style: styleSecondary(14, colorBlack),
                )),
            const SizedBox(
              width: 10,
            ),
            Icon(
              userSelect == i ? Icons.check_box : Icons.check_box_outline_blank,
              color: userSelect == i ? colorOrangLiU : colorBlack,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}

modalContrato(
    Size size, BuildContext context, String usuario, StateSetter setter) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            color: Colors.transparent,
            child: Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(400, 0, 400, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  height: size.height * 0.8,
                  width: Responsive.isDesktop(context)
                      ? size.width * 0.4
                      : size.width - 200,
                  child: PickContrato(
                    setter: setter,
                  )),
            ),
          );
        });
      });
}
