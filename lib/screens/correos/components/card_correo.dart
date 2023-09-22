// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/correos/backend/modal_corr.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

class CardCorreos extends StatefulWidget {
  final String usuario;
  final DocumentSnapshot doc;
  final Size size;
  const CardCorreos(
      {Key? key, required this.usuario, required this.doc, required this.size})
      : super(key: key);

  @override
  _CardCorreosState createState() => _CardCorreosState();
}

class _CardCorreosState extends State<CardCorreos> {
  Map<dynamic, dynamic> getCorreo = {};
  @override
  Widget build(BuildContext context) {
    getCorreo = widget.doc.data() as Map;
    String creacion =
        DateFormat('dd-MM-yyyy').format(getCorreo['fecha'].toDate());
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        modalCorreo(size, context, true, widget.usuario, widget.doc.id);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(12),
        child: Container(
          height: size.height * 0.12,
          width: size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getCorreo['correo'],
                    style: styleSecondary(12, colorGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    creacion,
                    style: stylePrincipalBold(15, colorOrangLiU),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: size.height * 0.05,
                    width: size.width * 0.05,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                      "lib/assets/logo.png",
                    ))),
                  ),
                  Row(
                    children: [
                      Text(
                        "Enviados  ",
                        style: styleSecondary(12, colorGrey),
                      ),
                      Text(
                        "Este mes (35)",
                        style: stylePrincipalBold(14, colorBlack),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            LineIcons.braille,
                            color: colorBlack,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () {},
                          tooltip: "${getCorreo['nombre']}",
                          icon: const Icon(
                            LineIcons.infoCircle,
                            color: Colors.amber,
                            size: 20,
                          )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
