// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/screens/ventas/backend/subir_gasto.dart';
import 'package:innovasun/screens/ventas/ventas.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/inputs/text_input.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

class GastosCaja extends StatefulWidget {
  final String usuario;
  const GastosCaja({Key? key, required this.usuario}) : super(key: key);

  @override
  _GastosCajaState createState() => _GastosCajaState();
}

TextEditingController cantidad = TextEditingController();
TextEditingController recibe = TextEditingController();
TextEditingController concepto = TextEditingController();

class _GastosCajaState extends State<GastosCaja> {
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
            "Gastos en Caja",
            style: styleSecondary(14, colorGrey),
          ),
          const SizedBox(
            height: 15,
          ),
          genericInput("Nombre", "Cantidad", cantidad, setState),
          genericInput("Nombre", "Quien recibe", recibe, setState),
          genericInput("Nombre", "Concepto", concepto, setState),
          const SizedBox(
            height: 15,
          ),
          isLoadingGasto == true
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: colorOrangLiU, size: 20))
              : normalButton("Subir Gasto", colorOrangLiU, colorOrangLiU, size,
                  () {
                  subirGastoCaja(size, context, setState, widget.usuario);
                }, setState, context, LineIcons.plusSquare)
        ],
      ),
    );
  }
}
