// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/screens/correos/correos.dart';
import 'package:innovasun/screens/ventas/backend/subir_ventas.dart';
import 'package:innovasun/widgets/buscador.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/buttons/generic_button.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

class ModalCreditoVentas extends StatefulWidget {
  final String usuario;
  final StateSetter setter;
  const ModalCreditoVentas(
      {Key? key, required this.usuario, required this.setter})
      : super(key: key);

  @override
  _ModalCreditoVentasState createState() => _ModalCreditoVentasState();
}

String correoSelect = "";

bool isLoadingCredito = false;

DateTime vencimiento = DateTime.now();

class _ModalCreditoVentasState extends State<ModalCreditoVentas> {
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
            "Generar Credito",
            style: styleSecondary(14, colorGrey),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              width: size.width * 0.3,
              height: size.height * .07,
              child: BuscadorText(
                lista: correos,
                function: (String selectedValue) {
                  setState(() {
                    if (selectedValue == "") {
                      correoSelect = "";
                    } else {
                      correoSelect = selectedValue;
                    }
                  });
                },
                titulo: "nombre",
              )),
          Container(
              height: size.height * 0.3,
              width: size.width * .2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: SfDateRangePicker(
                selectionColor: colorOrangLiU,
                backgroundColor: Colors.white,
                todayHighlightColor: colorOrangLiU,
                selectionTextStyle: styleSecondary(12, Colors.white),
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  vencimiento = dateRangePickerSelectionChangedArgs.value;
                },
              )),
          const SizedBox(
            height: 15,
          ),
          isLoadingCredito == true
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: colorOrangLiU, size: 20))
              : normalButton(
                  "Subir Credito", colorOrangLiU, colorOrangLiU, size, () {
                  subirVenta(size, context, widget.setter, widget.usuario);
                }, setState, context, LineIcons.plusSquare)
        ],
      ),
    );
  }
}
