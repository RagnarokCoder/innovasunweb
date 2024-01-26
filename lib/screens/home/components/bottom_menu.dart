// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/screens/compras/compras.dart';
import 'package:innovasun/screens/creditos/creditos.dart';
import 'package:innovasun/screens/dashboard/dashboard.dart';
import 'package:innovasun/screens/inventario/inventario.dart';
import 'package:innovasun/screens/maps/maps.dart';
import 'package:innovasun/screens/ventas/ventas.dart';
import 'package:line_icons/line_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../constants/styles/style_principal.dart';

class BottomMenu extends StatefulWidget {
  final String usuario;
  final StateSetter setter;
  final int index;
  const BottomMenu(
      {Key? key,
      required this.usuario,
      required this.setter,
      required this.index})
      : super(key: key);

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      backgroundColor: Colors.white,
      currentIndex: widget.index,
      onTap: (i) => {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => i == 0
                ? DashBoard(
                    usuario: widget.usuario,
                  )
                : i == 1
                    ? MapsW(
                        usuario: widget.usuario,
                      )
                    : i == 2
                        ? Ventas(usuario: widget.usuario)
                        : i == 3
                            ? Inventario(
                                usuario: widget.usuario,
                                select: "",
                              )
                            : i == 4
                                ? Compras(
                                    usuario: widget.usuario,
                                  )
                                : CreditosV(
                                    usuario: widget.usuario,
                                  ),
            transitionDuration: Duration.zero,
          ),
        )
      },
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: Icon(
            LineIcons.barChart,
            color: colorBlack,
            size: 15,
          ),
          title: Text(
            "Indicadores",
            style: styleSecondary(12, colorGrey),
          ),
          selectedColor: colorBlack,
        ),

        /// Likes
        SalomonBottomBarItem(
          icon: Icon(
            LineIcons.mapSigns,
            color: colorBlack,
            size: 15,
          ),
          title: Text(
            "Instalaciones",
            style: styleSecondary(12, colorGrey),
          ),
          selectedColor: colorBlack,
        ),

        SalomonBottomBarItem(
          icon: Icon(
            LineIcons.shoppingCart,
            color: colorGrey,
            size: 15,
          ),
          title: Text(
            "Ventas",
            style: styleSecondary(12, colorGrey),
          ),
          selectedColor: colorBlack,
        ),

        SalomonBottomBarItem(
          icon: Icon(
            LineIcons.boxes,
            color: colorGrey,
            size: 15,
          ),
          title: Text(
            "Inventario",
            style: styleSecondary(12, colorGrey),
          ),
          selectedColor: colorBlack,
        ),
        SalomonBottomBarItem(
          icon: Icon(
            LineIcons.dollarSign,
            color: colorGrey,
            size: 15,
          ),
          title: Text(
            "Compras",
            style: styleSecondary(12, colorGrey),
          ),
          selectedColor: colorBlack,
        ),
        SalomonBottomBarItem(
          icon: Icon(
            LineIcons.creditCard,
            color: colorGrey,
            size: 15,
          ),
          title: Text(
            "Creditos",
            style: styleSecondary(12, colorGrey),
          ),
          selectedColor: colorBlack,
        ),
      ],
    );
  }
}
