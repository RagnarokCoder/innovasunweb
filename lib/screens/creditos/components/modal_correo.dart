// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/creditos/backend/subir_pago.dart';
import 'package:line_icons/line_icons.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/responsive/responsive.dart';

class ModalCredito extends StatefulWidget {
  final bool isEdit;
  final String doc;
  final String usuario;
  const ModalCredito(
      {Key? key,
      required this.isEdit,
      required this.doc,
      required this.usuario})
      : super(key: key);

  @override
  _ModalCreditoState createState() => _ModalCreditoState();
}

TextEditingController nombre = TextEditingController();
TextEditingController abono = TextEditingController();
TextEditingController responsable = TextEditingController();

DateTime fechaPago = DateTime.now();

class _ModalCreditoState extends State<ModalCredito> {
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
            widget.isEdit == true ? "Agregar Pago" : "Agregar Correo",
            style: styleSecondary(14, colorGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.2,
                child: genericInput("Concepto", "Concepto", nombre, setState),
              ),
              SizedBox(
                width: size.width * 0.2,
                child: genericInput("Nombre", "Cantidad", abono, setState),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.width * 0.2,
                    child: genericInput(
                        "Nombre", "Responsable", responsable, setState),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  normalButton("Subir Pago", colorOrangLiU, colorOrangLiU, size,
                      () {
                    subirPago(
                        size, context, setState, widget.usuario, widget.doc);
                  }, setState, context, LineIcons.plusCircle)
                ],
              ),
              Container(
                  height: size.height * 0.3,
                  width: size.width * .2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: SfDateRangePicker(
                    selectionColor: colorOrangLiU,
                    backgroundColor: Colors.white,
                    todayHighlightColor: colorOrangLiU,
                    selectionTextStyle: styleSecondary(12, Colors.white),
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      fechaPago = dateRangePickerSelectionChangedArgs.value;
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
