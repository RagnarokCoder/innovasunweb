// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/ventas/backend/delete_venta.dart';
import 'package:line_icons/line_icons.dart';

class CardListVenta extends StatefulWidget {
  final StateSetter setter;
  final String usuario;
  final DocumentSnapshot doc;
  const CardListVenta({
    Key? key,
    required this.setter,
    required this.usuario,
    required this.doc,
  }) : super(key: key);

  @override
  _CardListVentaState createState() => _CardListVentaState();
}

class _CardListVentaState extends State<CardListVenta> {
  Map<dynamic, dynamic> getVenta = {};
  Map<dynamic, dynamic> carrito = {};

  @override
  Widget build(BuildContext context) {
    getVenta = widget.doc.data() as Map;
    carrito = getVenta['carrito'];
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        height: size.height * 0.12,
        width: size.width,
        color: Colors.white,
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: size.width * 0.2,
              height: size.height,
              child: ListView(
                children: [
                  for (var i in carrito.keys)
                    Card(
                      elevation: 2,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.18,
                              height: size.height * 0.04,
                              child: Text(
                                "${carrito[i]['nombre']}: ",
                                overflow: TextOverflow.ellipsis,
                                style: styleSecondary(11, colorGrey),
                              ),
                            ),
                            Text(
                              carrito[i]['cantidad'].toString(),
                              style: stylePrincipalBold(13, colorBlack),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              width: size.width * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Comprador: ${getVenta['comprador']}",
                    style: stylePrincipalBold(13, colorBlack),
                  ),
                  IconButton(
                      onPressed: () {
                        eliminarVenta(size, context, setState, widget.doc.id,
                            widget.usuario, carrito);
                      },
                      icon: const Icon(
                        LineIcons.trash,
                        color: Colors.red,
                        size: 15,
                      ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                getVenta['isPago'] != null
                    ? Text(
                        getVenta['isPago'] == true
                            ? "Transferencia"
                            : "Efectivo",
                        style: styleSecondary(13, colorBlack),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  getVenta['usuario'],
                  style: styleSecondary(9, colorOrange),
                ),
                Text(
                  getVenta['fecha'].toDate().toString().split(" ")[0],
                  style: styleSecondary(8, colorBlack),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
