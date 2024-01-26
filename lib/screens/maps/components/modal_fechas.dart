// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:innovasun/constants/inputs/text_input.dart';

import '../../../constants/responsive/responsive.dart';
import '../backend/date_picker.dart';

class ModalFechas extends StatefulWidget {
  final String usuario;
  const ModalFechas({Key? key, required this.usuario}) : super(key: key);

  @override
  _ModalFechasState createState() => _ModalFechasState();
}

TextEditingController titulo = TextEditingController();

class _ModalFechasState extends State<ModalFechas> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height * 0.2,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          textInput("Nombre", "Titulo", titulo, setState, context),
          rangoFechaInstalacionMap(context, setState, size, widget.usuario),
        ],
      ),
    );
  }
}

modalFech(Size size, BuildContext context, String usuario) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          width: size.width,
          height: Responsive.isDesktop(context) ? 200 : 150,
          color: Colors.transparent,
          child: Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(350, 0, 350, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ModalFechas(
                usuario: usuario,
              )),
        );
      });
}
