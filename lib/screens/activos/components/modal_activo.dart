// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/activos/backend/delete_activos.dart';
import 'package:innovasun/screens/activos/backend/get_activo.dart';
import 'package:innovasun/screens/activos/backend/subir_activo.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/responsive/responsive.dart';

class ModalActivo extends StatefulWidget {
  final bool isEdit;
  final String usuario;
  final String id;
  const ModalActivo(
      {Key? key, required this.isEdit, required this.usuario, required this.id})
      : super(key: key);

  @override
  _ModalActivoState createState() => _ModalActivoState();
}

TextEditingController nombre = TextEditingController();
TextEditingController descripcion = TextEditingController();
TextEditingController precio = TextEditingController();
TextEditingController stock = TextEditingController();

String downloadUrl = "";

dynamic getImg;

bool isLoadingActivo = false;

var uuid = const Uuid();

Map<dynamic, dynamic> getActivo = {};

class _ModalActivoState extends State<ModalActivo> {
  @override
  void initState() {
    nombre.clear();
    descripcion.clear();
    precio.clear();
    stock.clear();
    getActivo.clear();
    if (widget.id != "") {
      getEditActivo(widget.id, setState);
    }
    super.initState();
  }

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
            widget.isEdit == true ? "Editar Activo" : "Agregar Activo",
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
                child: genericInput("Nombre", "Precio", precio, setState),
              ),
              SizedBox(
                width: size.width * 0.2,
                child: genericInput("Nombre", "Stock", stock, setState),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  isLoadingActivo == true
                      ? Center(
                          child: LoadingAnimationWidget.discreteCircle(
                              color: colorOrangLiU, size: 20))
                      : widget.isEdit == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                normalButton("Editar Activo", colorOrangLiU,
                                    colorOrangLiU, size, () {
                                  subirActivo(size, context, setState,
                                      widget.usuario, widget.id);
                                }, setState, context, LineIcons.edit),
                                const SizedBox(
                                  width: 10,
                                ),
                                normalButton("Eliminar Activo", colorOrangLiU,
                                    colorOrangLiU, size, () {
                                  eliminarActivo(size, context, setState,
                                      widget.id, widget.usuario);
                                }, setState, context, LineIcons.trash)
                              ],
                            )
                          : normalButton("Subir Activo", colorOrangLiU,
                              colorOrangLiU, size, () {
                              subirActivo(
                                  size, context, setState, widget.usuario, "");
                            }, setState, context, LineIcons.plusCircle)
                ],
              ),
              InkWell(
                onTap: () {
                  uploadToStorage(setState);
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width * .2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Center(
                      child: getImg != null
                          ? Image.memory(
                              getImg,
                              scale: .4,
                              width: 200,
                            )
                          : Icon(
                              LineIcons.retroCamera,
                              color: colorBlack,
                              size: 30,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
