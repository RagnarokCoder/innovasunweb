// ignore_for_file: non_constant_identifier_names, use_function_type_syntax_for_parameters, avoid_types_as_parameter_names

import 'package:flutter/material.dart';

import '../color/colores.dart';
import '../styles/style_principal.dart';

Widget passwordInput(String title, hint, TextEditingController controller,
    bool isObsc, VoidCallback fun, StateSetter setter) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(left: 150, right: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorwhite,
        ),
        child: TextField(
          style: styleSecondary(12, colorBlack),
          onChanged: (value) {
            setter(() {});
          },
          controller: controller,
          obscureText: isObsc,
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
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 150),
            child: TextButton(
                onPressed: fun,
                child: Text(
                  isObsc == true ? "Ver contraseña" : "Ocultar contraseña",
                  style: TextStyle(
                    color: colorGrey,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                )),
          )
        ],
      )
    ],
  );
}
