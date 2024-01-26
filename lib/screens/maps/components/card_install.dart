// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/maps/backend/delete_install.dart';
import 'package:innovasun/screens/maps/backend/modal_mapa.dart';
import 'package:line_icons/line_icons.dart';

class CardInstall extends StatefulWidget {
  final StateSetter setter;
  final String usuario;
  final DocumentSnapshot doc;
  const CardInstall(
      {Key? key,
      required this.setter,
      required this.usuario,
      required this.doc})
      : super(key: key);

  @override
  _CardInstallState createState() => _CardInstallState();
}

class _CardInstallState extends State<CardInstall> {
  Map<dynamic, dynamic> getInstall = {};
  @override
  Widget build(BuildContext context) {
    getInstall = widget.doc.data() as Map;
    String fecha = getInstall['fecha'].toDate().toString().split(" ")[0];
    String hora = getInstall['fecha'].toDate().toString().split(" ")[1];
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        height: size.height * 0.1,
        width: size.width,
        color: Colors.white,
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: size.width * 0.2,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "$fecha: $hora",
                    style: styleSecondary(10, colorGrey),
                  ),
                  Text(
                    getInstall['usuario'],
                    overflow: TextOverflow.ellipsis,
                    style: stylePrincipalBold(13, colorBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Contrato: ${getInstall['cliente']}",
                    overflow: TextOverflow.ellipsis,
                    style: styleSecondary(12, colorOrangLiU),
                  ),
                  Text(
                    "Beneficiario: ${getInstall['nombre']}",
                    overflow: TextOverflow.ellipsis,
                    style: stylePrincipalBold(10, colorBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        eliminarInstall(size, context, setState, widget.doc.id,
                            widget.usuario);
                      },
                      icon: const Icon(
                        LineIcons.trash,
                        color: Colors.red,
                        size: 15,
                      )),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        modalInstal(
                            size, context, true, widget.usuario, widget.doc.id);
                      },
                      icon: const Icon(
                        LineIcons.edit,
                        color: Colors.amber,
                        size: 15,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
