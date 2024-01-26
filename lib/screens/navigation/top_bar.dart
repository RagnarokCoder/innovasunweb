// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../constants/color/colores.dart';
import '../../constants/dialogs/dialog_options.dart';
import '../../constants/styles/style_principal.dart';
import '../../constants/vars/vars.dart';
import '../home/home.dart';

String select = "";
appBar(Size size, StateSetter setter, String usuario, BuildContext context) {
  if (usuario.split("_")[1].split("@")[0] == "admin") {
    select = "admin";
  } else if (usuario.split("_")[1].split("@")[0] == "mostrador") {
    select = "invent";
  } else if (usuario.split("_")[1].split("@")[0] == "arq") {
    select = "arqui";
  } else if (usuario.split("_")[1].split("@")[0] == "inv") {
    select = "bodega";
  }
  return AppBar(
    elevation: 2,
    backgroundColor: Colors.white,
    leading: Row(
      children: [
        IconButton(
            onPressed: () {
              cerrarSesion(size, context, setter);
            },
            icon: Icon(
              LineIcons.alternateSignOut,
              color: colorGrey,
              size: 20,
            )),
      ],
    ),
    centerTitle: false,
    actions: select == "admin"
        ? [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/logo.png",
                  width: 70,
                ),
                Text(
                  version,
                  style: stylePrincipalBold(8, colorGrey),
                )
              ],
            ),
            const SizedBox(
              width: 150,
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
              width: size.width * 0.08,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenido",
                  style: styleSecondary(10, colorGrey),
                ),
                Text(
                  usuario,
                  style: stylePrincipalBold(11, colorBlack),
                ),
              ],
            ),
            const SizedBox(
              width: 30,
            )
          ]
        : [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/logo.png",
                  width: 70,
                ),
                Text(
                  version,
                  style: stylePrincipalBold(8, colorGrey),
                )
              ],
            ),
            const SizedBox(
              width: 150,
            ),
            select == "invent" || select == "arqui" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 0, setter, "Dashboard"),
            select == "invent" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 1, setter, "Instalaciones"),
            select == "bodega"
                ? const SizedBox()
                : menuItem(size, 2, setter, "Ventas"),
            select == "invent" || select == "arqui"
                ? const SizedBox()
                : menuItem(size, 3, setter, "Inventario"),
            select == "invent" || select == "arqui" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 4, setter, "Calendario"),
            select == "invent" || select == "arqui" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 5, setter, "Activos"),
            select == "arqui" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 6, setter, "Compras"),
            select == "invent" || select == "arqui" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 7, setter, "Correos"),
            select == "arqui" || select == "bodega"
                ? const SizedBox()
                : menuItem(size, 8, setter, "Créditos"),
            SizedBox(
              width: size.width * 0.4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenido",
                  style: styleSecondary(10, colorGrey),
                ),
                Text(
                  usuario,
                  style: stylePrincipalBold(11, colorBlack),
                )
              ],
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

cerrarSesion(
  Size size,
  BuildContext context,
  StateSetter setSt,
) {
  dialogOptions(colorwhite, "¿Desea cerrar sesión?", LineIcons.info, context,
      () {
    Navigator.of(context).pop();
    FirebaseAuth.instance.signOut();
  }, () {
    Navigator.of(context).pop();
  });
}
