// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';

import 'package:innovasun/constants/responsive/responsive.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:line_icons/line_icons.dart';

import '../ventas.dart';

class CardCarrito extends StatefulWidget {
  final dynamic i;
  final StateSetter setter;
  const CardCarrito({
    Key? key,
    this.i,
    required this.setter,
  }) : super(key: key);

  @override
  _CardCarritoState createState() => _CardCarritoState();
}

TextEditingController price = TextEditingController();
TextEditingController cantidadC = TextEditingController();

class _CardCarritoState extends State<CardCarrito> {
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      child: Container(
        height: size.height * 0.16,
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
                  carrito[widget.i]['nombre'],
                  style: styleSecondary(13, colorGrey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                isEdit == true
                    ? SizedBox(
                        height: size.height * 0.06,
                        width: Responsive.isDesktop(context)
                            ? size.width * 0.12
                            : size.width * .3,
                        child: genericInputN(
                            "Cantidad", "Cantidad", cantidadC, setState))
                    : Text(
                        "Cantidad: ${f.format(carrito[widget.i]['cantidad'])}",
                        style: styleSecondary(14, colorGrey),
                      ),
                isEdit == true
                    ? SizedBox(
                        height: size.height * 0.06,
                        width: Responsive.isDesktop(context)
                            ? size.width * 0.12
                            : size.width * .3,
                        child:
                            genericInputN("Precio", "Precio", price, setState))
                    : Text(
                        "Precio: \$${f.format(carrito[widget.i]['precio'])}",
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
                            if (carrito[widget.i]['cantidad'] > 1) {
                              carrito[widget.i]['cantidad'] -= 1;
                            } else {
                              carrito.remove(widget.i);
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
                            carrito[widget.i]['cantidad'] += 1;
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
                        carrito.remove(widget.i);
                      });
                    },
                    icon: const Icon(
                      LineIcons.trash,
                      color: Colors.red,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    },
                    icon: const Icon(
                      LineIcons.edit,
                      color: Colors.amber,
                      size: 20,
                    )),
                Responsive.isDesktop(context)
                    ? Text(
                        "Subtotal: \$${f.format(carrito[widget.i]['precio'] * carrito[widget.i]['cantidad'])}",
                        style: stylePrincipalBold(16, colorBlack),
                      )
                    : const SizedBox()
              ],
            ),
            Responsive.isMobile(context)
                ? Text(
                    "Subtotal: \$${f.format(carrito[widget.i]['precio'] * carrito[widget.i]['cantidad'])}",
                    style: stylePrincipalBold(16, colorBlack),
                  )
                : const SizedBox()
          ],
        ),
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
            if (title == "Precio") {
              carrito[widget.i]['precio'] = double.parse(controller.text);
            } else {
              carrito[widget.i]['cantidad'] = double.parse(controller.text);
            }

            isEdit = false;
            cantidadC.clear();
            price.clear();
          });
          widget.setter(() {});
        },
        style: styleSecondary(12, colorBlack),
        keyboardType: TextInputType.number,
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
}
