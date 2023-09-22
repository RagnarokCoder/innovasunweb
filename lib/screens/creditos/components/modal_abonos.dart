// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/creditos/backend/subir_pago.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

class ModalAbonos extends StatefulWidget {
  final String usuario;
  final DocumentSnapshot doc;
  final Size size;
  const ModalAbonos(
      {Key? key, required this.usuario, required this.doc, required this.size})
      : super(key: key);

  @override
  _ModalAbonosState createState() => _ModalAbonosState();
}

Map<dynamic, dynamic> abonosModal = {};

class _ModalAbonosState extends State<ModalAbonos> {
  Map<dynamic, dynamic> abonosGet = {};
  @override
  void initState() {
    abonosGet = widget.doc.data() as Map;
    if (abonosGet['abonos'] != null) {
      abonosModal = abonosGet['abonos'];
    }
    super.initState();
  }

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
            "Abonos",
            style: styleSecondary(14, colorGrey),
          ),
          SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: ListView(
              children: [
                SizedBox(
                  width: size.width,
                  child: Column(
                    children: [
                      for (var i in abonosModal.keys) cardAbonos(size, i)
                    ],
                  ),
                )
              ],
            ),
          ),
          normalButton("Guardar Abonos", colorOrangLiU, colorOrangLiU, size,
              () {
            updateAbonos(
                size, context, setState, widget.usuario, widget.doc.id);
          }, setState, context, LineIcons.save)
        ],
      ),
    );
  }

  Widget cardAbonos(Size size, var i) {
    String creacion =
        DateFormat('dd-MM-yyyy').format(abonosModal[i]['fecha'].toDate());
    return Card(
      elevation: 2,
      child: Container(
        height: size.height * 0.1,
        width: size.width * 0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              abonosModal[i]['registro'],
              style: styleSecondary(12, colorGrey),
            ),
            Text(
              creacion,
              style: styleSecondary(13, colorOrangLiU),
            ),
            Text(
              "\$${f.format(abonosModal[i]['cantidad'])}",
              style: styleSecondary(11, colorBlack),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    abonosModal.remove(i);
                    debugPrint(abonosModal.length.toString());
                  });
                },
                icon: const Icon(
                  LineIcons.trash,
                  color: Colors.red,
                  size: 15,
                ))
          ],
        ),
      ),
    );
  }
}
