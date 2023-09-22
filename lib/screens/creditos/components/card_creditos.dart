// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/creditos/backend/modal_corr.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

class CardCredito extends StatefulWidget {
  final String usuario;
  final DocumentSnapshot doc;
  final Size size;
  const CardCredito(
      {Key? key, required this.usuario, required this.doc, required this.size})
      : super(key: key);

  @override
  _CardCreditoState createState() => _CardCreditoState();
}

class _CardCreditoState extends State<CardCredito> {
  Map<dynamic, dynamic> credito = {};
  Map<dynamic, dynamic> abonosGet = {};

  dynamic totalAbono = 0;

  @override
  Widget build(BuildContext context) {
    credito = widget.doc.data() as Map;
    String creacion =
        DateFormat('dd-MM-yyyy').format(credito['vencimiento'].toDate());
    abonosGet.clear();
    totalAbono = 0;
    if (credito['abonos'] != null) {
      abonosGet = credito['abonos'];
    }

    for (var i in abonosGet.keys) {
      totalAbono += abonosGet[i]['cantidad'];
    }

    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        modalCredito(size, context, true, widget.doc.id, widget.usuario);
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
                    credito['comprador'],
                    style: styleSecondary(12, colorGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    creacion,
                    style: stylePrincipalBold(15, colorOrangLiU),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Total: \$${f.format(credito['total'])}",
                    style: stylePrincipalBold(12, colorBlack),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: size.height * 0.03,
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
                        "Por pagar  ",
                        style: styleSecondary(12, colorGrey),
                      ),
                      Text(
                        "\$${f.format(credito['total'] - totalAbono)}",
                        style: stylePrincipalBold(14, colorBlack),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Pagado  ",
                        style: styleSecondary(12, colorGrey),
                      ),
                      Text(
                        "\$${f.format(totalAbono)}",
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
                          onPressed: () {
                            modalAbonos(size, context, false, widget.doc,
                                widget.usuario);
                          },
                          icon: const Icon(
                            LineIcons.moneyCheck,
                            color: Colors.green,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            LineIcons.print,
                            color: Colors.blue.shade800,
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
