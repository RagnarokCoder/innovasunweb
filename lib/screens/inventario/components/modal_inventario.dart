// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/inventario/backend/delete_inventario.dart';
import 'package:innovasun/screens/inventario/backend/subir_producto.dart';
import 'package:innovasun/screens/ventas/components/gaso_caja.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/responsive/responsive.dart';
import '../backend/get_inventory.dart';

class ModalInventario extends StatefulWidget {
  final bool isEdit;
  final String usuario;
  final String doc;
  const ModalInventario(
      {Key? key,
      required this.isEdit,
      required this.usuario,
      required this.doc})
      : super(key: key);

  @override
  _ModalInventarioState createState() => _ModalInventarioState();
}

TextEditingController nombre = TextEditingController();
TextEditingController descripcion = TextEditingController();
TextEditingController venta = TextEditingController();
TextEditingController compra = TextEditingController();
TextEditingController stock = TextEditingController();

String downloadUrl = "";
String categoria = "";
dynamic getImg;

int index = 0;

bool isLoadingInventario = false;

var uuid = const Uuid();

Map<dynamic, dynamic> getInventory = {};

class _ModalInventarioState extends State<ModalInventario> {
  @override
  void initState() {
    nombre.clear();
    cantidad.clear();
    venta.clear();
    compra.clear();
    stock.clear();
    descripcion.clear();
    getInventory.clear();
    if (widget.doc != "") {
      getEditInventario(widget.doc, setState);
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
            widget.isEdit == true ? "Editar Producto" : "Agregar Produto",
            style: styleSecondary(14, colorGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: Responsive.isMobile(context)
                    ? size.width * 0.4
                    : size.width * 0.2,
                child: genericInput("Nombre", "Nombre", nombre, setState),
              ),
              SizedBox(
                width: Responsive.isMobile(context)
                    ? size.width * 0.4
                    : size.width * 0.2,
                child: genericInput(
                    "Nombre", "Descripción", descripcion, setState),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: Responsive.isMobile(context)
                    ? size.width * 0.4
                    : size.width * 0.2,
                child:
                    genericInput("Nombre", "Precio Compra", compra, setState),
              ),
              SizedBox(
                width: Responsive.isMobile(context)
                    ? size.width * 0.4
                    : size.width * 0.2,
                child: genericInput("Nombre", "Precio Venta", venta, setState),
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
                    width: Responsive.isMobile(context)
                        ? size.width * 0.4
                        : size.width * 0.2,
                    child: genericInput("Nombre", "Stock", stock, setState),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: Responsive.isMobile(context)
                          ? size.width * 0.4
                          : size.width * 0.2,
                      child: filters(size)),
                  const SizedBox(
                    height: 30,
                  ),
                  isLoadingInventario == true
                      ? Center(
                          child: LoadingAnimationWidget.discreteCircle(
                              color: colorOrangLiU, size: 20))
                      : widget.isEdit == true
                          ? Responsive.isDesktop(context)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    normalButton("Editar Producto",
                                        colorOrangLiU, colorOrangLiU, size, () {
                                      subirProducto(size, context, setState,
                                          widget.usuario, widget.doc);
                                    }, setState, context, LineIcons.edit),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    normalButton("Eliminar Producto",
                                        colorOrangLiU, colorOrangLiU, size, () {
                                      eliminarProducto(size, context, setState,
                                          widget.doc, widget.usuario);
                                    }, setState, context, LineIcons.trash)
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    normalButton("Editar Producto",
                                        colorOrangLiU, colorOrangLiU, size, () {
                                      subirProducto(size, context, setState,
                                          widget.usuario, widget.doc);
                                    }, setState, context, LineIcons.edit),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    normalButton("Eliminar Producto",
                                        colorOrangLiU, colorOrangLiU, size, () {
                                      eliminarProducto(size, context, setState,
                                          widget.doc, widget.usuario);
                                    }, setState, context, LineIcons.trash)
                                  ],
                                )
                          : normalButton("Subir Producto", colorOrangLiU,
                              colorOrangLiU, size, () {
                              subirProducto(
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
                    width: Responsive.isMobile(context)
                        ? size.width * 0.4
                        : size.width * .2,
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

  Widget filters(Size size) {
    return SizedBox(
      height: size.height * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                index = 0;
                categoria = "Bodega";
              });
            },
            child: Container(
              width: Responsive.isDesktop(context)
                  ? size.width * 0.05
                  : size.width * 0.15,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      topLeft: Radius.circular(50)),
                  color: index == 0 ? colorOrangLiU : Colors.white),
              child: Center(
                child: Text(
                  "Bodega",
                  style: styleSecondary(
                      12, index == 0 ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 1;
                categoria = "Tienda";
              });
            },
            child: Container(
              width: Responsive.isDesktop(context)
                  ? size.width * 0.05
                  : size.width * 0.15,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: index == 1 ? colorOrangLiU : Colors.white),
              child: Center(
                child: Text(
                  "Tienda",
                  style: styleSecondary(
                      12, index == 1 ? Colors.white : Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
