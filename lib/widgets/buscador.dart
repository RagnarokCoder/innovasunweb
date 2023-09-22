// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../constants/responsive/responsive.dart';
import '../constants/styles/style_principal.dart';

class BuscadorText extends StatefulWidget {
  final List<String> lista;
  final String titulo;
  final Function(String) function;
  const BuscadorText({
    Key? key,
    required this.lista,
    required this.function,
    required this.titulo,
  }) : super(key: key);

  @override
  _BuscadorTextState createState() => _BuscadorTextState();
}

class _BuscadorTextState extends State<BuscadorText> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: Responsive.isDesktop(context)
          ? size.height * 0.06
          : size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.18 : size.width * 0.5,
      child: Autocomplete<String>(
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              cursorColor: Colors.grey,
              controller: textEditingController,
              focusNode: focusNode,
              onEditingComplete: onFieldSubmitted,
              style: styleSecondary(13, Colors.grey),
              decoration: InputDecoration(
                labelStyle: styleSecondary(12, Colors.grey),
                hintText: "buscar ${widget.titulo}...",
                hintStyle: styleSecondary(12, Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15)),
              ),
            );
          },
          optionsBuilder: (TextEditingValue textValue) {
            return widget.lista.where((String value) =>
                value.toLowerCase().startsWith(textValue.text.toLowerCase()));
          },
          onSelected: widget.function),
    );
  }
}
