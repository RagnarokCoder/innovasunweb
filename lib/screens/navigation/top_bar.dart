// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../constants/color/colores.dart';
import '../../constants/styles/style_principal.dart';
import '../home/home.dart';

appBar(Size size, StateSetter setter) {
  return AppBar(
    elevation: 2,
    backgroundColor: Colors.white,
    leading: Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.apps,
              color: colorGrey,
              size: 20,
            )),
      ],
    ),
    centerTitle: false,
    actions: [
      Image.asset(
        "lib/assets/logo.png",
        width: 70,
      ),
      const SizedBox(
        width: 250,
      ),
      menuItem(size, 0, setter, "Dashboard"),
      menuItem(size, 1, setter, "Instalaciones"),
      menuItem(size, 2, setter, "Ventas"),
      menuItem(size, 3, setter, "Inventario"),
      menuItem(size, 4, setter, "Calendario"),
      menuItem(size, 5, setter, "Activos"),
      menuItem(size, 6, setter, "Compras"),
      menuItem(size, 7, setter, "Correos"),
      menuItem(size, 8, setter, "Créditos"),
      SizedBox(
        width: size.width * 0.1,
      ),
      CircleAvatar(
        radius: 15,
        backgroundColor: colorOrangLiU,
      ),
      const SizedBox(
        width: 30,
      )
    ],
  );
}

Widget menuItem(Size size, int index, StateSetter setter, String title) {
  return InkWell(
    onTap: () {
      setter(() {
        indexGlobal = index;
      });
    },
    child: SizedBox(
      height: size.height * 0.05,
      width: size.width * 0.06,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: styleSecondary(
                12, indexGlobal == index ? colorOrangLiU : colorGrey),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: size.width * 0.002,
            width: size.width * 0.04,
            color: indexGlobal == index ? colorOrangLiU : Colors.transparent,
          )
        ],
      ),
    ),
  );
}
