// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:line_icons/line_icons.dart';

import '../compras.dart';

class CardcarritoCompras extends StatefulWidget {
  final dynamic i;
  final StateSetter setter;
  const CardcarritoCompras({
    Key? key,
    this.i,
    required this.setter,
  }) : super(key: key);

  @override
  _CardcarritoComprasState createState() => _CardcarritoComprasState();
}

class _CardcarritoComprasState extends State<CardcarritoCompras> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      child: Container(
        height: size.height * 0.14,
        width: size.width,
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.04,
              child: Center(
                child: Text(
                  carritoCompras[widget.i]['nombre'],
                  style: styleSecondary(13, colorGrey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Cantidad: ${f.format(carritoCompras[widget.i]['cantidad'])}",
                  style: styleSecondary(14, colorGrey),
                ),
                Text(
                  "Precio: \$${f.format(carritoCompras[widget.i]['precio'])}",
                  style: styleSecondary(14, colorGrey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.setter(() {
                            if (carritoCompras[widget.i]['cantidad'] > 1) {
                              carritoCompras[widget.i]['cantidad'] -= 1;
                            } else {
                              carritoCompras.remove(widget.i);
                            }
                          });
                        },
                        icon: Icon(
                          LineIcons.minusCircle,
                          color: colorOrangLiU,
                          size: 20,
                        )),
                    IconButton(
                        onPressed: () {
                          widget.setter(() {
                            carritoCompras[widget.i]['cantidad'] += 1;
                          });
                        },
                        icon: Icon(
                          LineIcons.plusCircle,
                          color: colorOrangLiU,
                          size: 20,
                        )),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      widget.setter(() {
                        carritoCompras.remove(widget.i);
                      });
                    },
                    icon: const Icon(
                      LineIcons.trash,
                      color: Colors.red,
                      size: 20,
                    )),
                Text(
                  "Subtotal: \$${f.format(carritoCompras[widget.i]['precio'] * carritoCompras[widget.i]['cantidad'])}",
                  style: stylePrincipalBold(16, colorBlack),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
