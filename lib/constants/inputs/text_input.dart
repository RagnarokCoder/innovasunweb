import 'package:flutter/material.dart';

import '../color/colores.dart';
import '../styles/style_principal.dart';

Widget textInput(
    String title, hint, TextEditingController controller, StateSetter setter) {
  return Container(
    margin: const EdgeInsets.only(left: 150, right: 150),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: colorwhite,
    ),
    child: TextField(
      controller: controller,
      style: styleSecondary(12, colorBlack),
      keyboardType: title == "Correo"
          ? TextInputType.emailAddress
          : title == "Teléfono"
              ? TextInputType.phone
              : title == "Nombre"
                  ? TextInputType.name
                  : TextInputType.number,
      cursorColor: colorBlack,
      decoration: InputDecoration(
        fillColor: colorLightGray,
        hintText: hint,
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

Widget genericInput(
    String title, hint, TextEditingController controller, StateSetter setter) {
  return Container(
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: colorwhite,
    ),
    child: TextField(
      controller: controller,
      style: styleSecondary(12, colorBlack),
      keyboardType: title == "Correo"
          ? TextInputType.emailAddress
          : title == "Teléfono"
              ? TextInputType.phone
              : title == "Nombre"
                  ? TextInputType.name
                  : TextInputType.number,
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

Widget textInputA(
    String title, hint, TextEditingController controller, StateSetter setter) {
  return Container(
    margin: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: colorwhite,
    ),
    child: TextField(
      minLines: 8,
      maxLines: 15,
      controller: controller,
      onChanged: (value) {
        setter(() {});
      },
      style: styleSecondary(12, colorBlack),
      keyboardType: title == "Correo"
          ? TextInputType.emailAddress
          : title == "Teléfono"
              ? TextInputType.phone
              : title == "Nombre"
                  ? TextInputType.name
                  : TextInputType.number,
      cursorColor: colorBlack,
      decoration: InputDecoration(
        fillColor: colorLightGray,
        hintText: hint,
        hintStyle: styleSecondary(12, colorBlack),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: controller.text.isNotEmpty ? 2 : 0,
                color: controller.text.isNotEmpty ? colorGrey : colorwhite),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: colorBlack),
            borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}
