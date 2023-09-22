// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/responsive/responsive.dart';

class ModalCompras extends StatefulWidget {
  final bool isEdit;
  const ModalCompras({Key? key, required this.isEdit}) : super(key: key);

  @override
  _ModalComprasState createState() => _ModalComprasState();
}

TextEditingController nombre = TextEditingController();
TextEditingController descripcion = TextEditingController();
TextEditingController materiales = TextEditingController();
TextEditingController correo = TextEditingController();

class _ModalComprasState extends State<ModalCompras> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      height: size.height * 0.8,
      width:
          Responsive.isDesktop(context) ? size.width * 0.3 : size.width - 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.isEdit == true ? "Editar Compra" : "Agregar Compra",
            style: styleSecondary(14, colorGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.2,
                child: genericInput("Nombre", "Nombre", nombre, setState),
              ),
              SizedBox(
                width: size.width * 0.2,
                child: genericInput(
                    "Nombre", "Descripción", descripcion, setState),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.2,
                child:
                    genericInput("Nombre", "Materiales", materiales, setState),
              ),
              SizedBox(
                width: size.width * 0.2,
                child: genericInput("Nombre", "Correo", correo, setState),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          normalButton("Subir Compra", colorOrangLiU, colorOrangLiU, size,
              () {}, setState, context, LineIcons.plusCircle)
        ],
      ),
    );
  }
}
