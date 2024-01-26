// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/compras/backend/subir_compra.dart';
import 'package:innovasun/screens/inventario/inventario.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/responsive/responsive.dart';
import '../../../widgets/buscador.dart';
import '../../correos/correos.dart';

class ModalCompras extends StatefulWidget {
  final bool isEdit;
  final String usuario;
  final String doc;
  const ModalCompras(
      {Key? key,
      required this.isEdit,
      required this.usuario,
      required this.doc})
      : super(key: key);

  @override
  _ModalComprasState createState() => _ModalComprasState();
}

TextEditingController nombre = TextEditingController();
TextEditingController descripcion = TextEditingController();
TextEditingController correo = TextEditingController();

bool isCompraLoading = false;
String inventarioSelect = "";

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
                  height: size.height * .07,
                  child: BuscadorText(
                    lista: inventario,
                    function: (String selectedValue) {
                      setState(() {
                        if (selectedValue == "") {
                          inventarioSelect = "";
                        } else {
                          inventarioSelect = selectedValue;
                        }
                      });
                    },
                    titulo: "producto",
                  )),
              SizedBox(
                  width: size.width * 0.2,
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
                    titulo: "correo",
                  )),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          isCompraLoading == true
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: colorOrangLiU, size: 20))
              : widget.isEdit == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        normalButton(
                            "Editar Compra", colorOrangLiU, colorOrangLiU, size,
                            () {
                          subirCompra(size, context, setState, widget.usuario,
                              widget.doc);
                        }, setState, context, LineIcons.edit),
                        const SizedBox(
                          width: 10,
                        ),
                        normalButton("Eliminar Correo", colorOrangLiU,
                            colorOrangLiU, size, () {
                          /*eliminarCorreo(size, context, setState, widget.doc,
                              widget.usuario);*/
                        }, setState, context, LineIcons.trash)
                      ],
                    )
                  : normalButton(
                      "Subir Compra", colorOrangLiU, colorOrangLiU, size, () {
                      subirCompra(size, context, setState, widget.usuario, "");
                    }, setState, context, LineIcons.plusCircle)
        ],
      ),
    );
  }
}
