// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/alerts/warning.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/ventas/ventas.dart';
import 'package:line_icons/line_icons.dart';

class CardVentas extends StatefulWidget {
  final StateSetter setter;
  final String usuario;
  final DocumentSnapshot doc;
  final Size size;
  const CardVentas(
      {Key? key,
      required this.setter,
      required this.usuario,
      required this.doc,
      required this.size})
      : super(key: key);

  @override
  _CardVentasState createState() => _CardVentasState();
}

class _CardVentasState extends State<CardVentas> {
  Map<dynamic, dynamic> getVenta = {};
  @override
  Widget build(BuildContext context) {
    getVenta = widget.doc.data() as Map;
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: size.height * 0.3,
            width: size.width * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.2,
                  width: size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(getVenta['imagen'] == "" ||
                                  getVenta['imagen'] == null
                              ? "https://firebasestorage.googleapis.com/v0/b/cmotion.appspot.com/o/logonegroa.png?alt=media&token=2088b7c3-4011-4d0f-a32d-8ccdb8cc0f9d"
                              : getVenta['imagen']))),
                ),
                Divider(
                  indent: 50,
                  endIndent: 50,
                  color: colorOrangLiU,
                  thickness: 1,
                ),
                Text(
                  getVenta['nombre'],
                  style: styleSecondary(12, colorGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "\$${f.format(getVenta['venta'])} (MXN)",
                      style: stylePrincipalBold(14, colorBlack),
                    ),
                    Text(
                      "C. ${f.format(getVenta['cantidad'])}",
                      style: stylePrincipalBold(14, colorBlack),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: -15,
              right: -15,
              child: InkWell(
                onTap: () {
                  widget.setter(() {
                    if (getVenta['cantidad'] <= 0) {
                      warning(size, context, "Ya no cuentas con stock",
                          "Revisa el stock de este producto");
                    } else if (carrito.containsKey(getVenta['uuid'])) {
                      warning(
                          size,
                          context,
                          "El producto ya esta en el carrito",
                          "Este producto ya esta agregado al carrito");
                    } else {
                      carrito.putIfAbsent(
                          getVenta['uuid'],
                          () => {
                                "nombre": getVenta['nombre'],
                                "cantidad": 1,
                                "precio": getVenta['venta']
                              });
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: colorOrange,
                      borderRadius: BorderRadius.circular(500)),
                  height: 35,
                  width: 35,
                  child: const Center(
                    child: Icon(
                      LineIcons.shoppingCart,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
