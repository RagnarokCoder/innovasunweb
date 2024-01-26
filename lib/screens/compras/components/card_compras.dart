// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, unused_local_variable, unnecessary_set_literal

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/compras/backend/modal_compras.dart';
import 'package:innovasun/screens/compras/backend/subir_compra.dart';
import 'package:innovasun/screens/compras/pdf/orden_compra.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

import '../../../constants/alerts/error.dart';
import '../../../constants/alerts/success.dart';
import '../../../constants/responsive/responsive.dart';

class CardCompras extends StatefulWidget {
  final Size size;
  final String usuario;
  final DocumentSnapshot doc;
  const CardCompras(
      {Key? key, required this.usuario, required this.doc, required this.size})
      : super(key: key);

  @override
  _CardComprasState createState() => _CardComprasState();
}

bool isLoadingUpdate = false;
bool isLoadPdf = false;

String? pdfUrl;
String getURL = "";

class _CardComprasState extends State<CardCompras> {
  Map<dynamic, dynamic> compra = {};
  bool isMateriales = false;
  bool isLoadCorreo = false;
  @override
  Widget build(BuildContext context) {
    compra = widget.doc.data() as Map;
    Map<dynamic, dynamic> materiales = compra['carrito'];
    String creacion = DateFormat('dd-MM-yyyy').format(compra['fecha'].toDate());
    Size size = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          modalCompras(size, context, true, widget.usuario, widget.doc.id);
        },
        child: Responsive.isDesktop(context)
            ? cardDesk(size, creacion, materiales)
            : cardMobile(size, creacion, materiales));
  }

  Widget cardMobile(
      Size size, String creacion, Map<dynamic, dynamic> materiales) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(12),
      child: Container(
        height: size.height * 0.3,
        width: Responsive.isMobile(context) ? size.width : size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              compra['isPendiente'] == true
                  ? LineIcons.questionCircle
                  : LineIcons.checkCircle,
              color:
                  compra['isPendiente'] == true ? colorOrangLiU : Colors.green,
              size: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  compra['correo'],
                  style: styleSecondary(12, colorGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  creacion,
                  style: stylePrincipalBold(15, colorOrangLiU),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isMateriales == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Costo  ",
                            style: styleSecondary(12, colorGrey),
                          ),
                          Text(
                            "\$${f.format(compra['total'])} (MXN)",
                            style: stylePrincipalBold(14, colorBlack),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Materiales  ",
                            style: styleSecondary(12, colorGrey),
                          ),
                          Text(
                            "${materiales.length}",
                            style: stylePrincipalBold(14, colorBlack),
                          ),
                        ],
                      )
                    ],
                  )
                : SizedBox(
                    height: size.height * 0.2,
                    width: Responsive.isMobile(context)
                        ? size.width * 0.5
                        : size.width * 0.3,
                    child: ListView(
                      children: [
                        for (var i in materiales.keys)
                          cardMaterial(i, size, materiales)
                      ],
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Responsive.isMobile(context)
                    ? const SizedBox()
                    : Container(
                        height: size.height * 0.1,
                        width: size.width * 0.05,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                          "lib/assets/logo.png",
                        ))),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    isLoadingUpdate == true
                        ? LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20)
                        : compra['isPendiente'] == false
                            ? const Icon(
                                Icons.abc,
                                color: Colors.transparent,
                              )
                            : IconButton(
                                onPressed: () {
                                  updateInventario(size, context, setState,
                                      materiales, widget.doc.id);
                                },
                                icon: const Icon(
                                  LineIcons.checkCircle,
                                  color: Colors.green,
                                  size: 20,
                                )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isMateriales = !isMateriales;
                          });
                        },
                        icon: const Icon(
                          LineIcons.infoCircle,
                          color: Colors.amber,
                          size: 20,
                        )),
                    isLoadPdf == true
                        ? LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20)
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isLoadPdf = true;
                                generateCompra(setState, compra);
                              });
                            },
                            icon: Icon(
                              LineIcons.pdfFile,
                              color: colorblueLi,
                              size: 20,
                            )),
                    isLoadCorreo == true
                        ? LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20)
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                if (bytspdf == null) {
                                  error(size, context, "Debe descargar el pdf",
                                      "Antes de enviar por correo necesita generar el pdf");
                                } else {
                                  isLoadCorreo = true;
                                  getPdfBytes(bytspdf, size, (fn) {}, "",
                                      compra['correo']);
                                }
                              });
                            },
                            icon: Icon(
                              LineIcons.paperPlane,
                              color: colorOrangLiU,
                              size: 20,
                            )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardDesk(
      Size size, String creacion, Map<dynamic, dynamic> materiales) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(12),
      child: Container(
        height: size.height * 0.2,
        width: Responsive.isMobile(context) ? size.width : size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              compra['isPendiente'] == true
                  ? LineIcons.questionCircle
                  : LineIcons.checkCircle,
              color:
                  compra['isPendiente'] == true ? colorOrangLiU : Colors.green,
              size: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  compra['correo'],
                  style: styleSecondary(12, colorGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  creacion,
                  style: stylePrincipalBold(15, colorOrangLiU),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isMateriales == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Costo  ",
                            style: styleSecondary(12, colorGrey),
                          ),
                          Text(
                            "\$${f.format(compra['total'])} (MXN)",
                            style: stylePrincipalBold(14, colorBlack),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Materiales  ",
                            style: styleSecondary(12, colorGrey),
                          ),
                          Text(
                            "${materiales.length}",
                            style: stylePrincipalBold(14, colorBlack),
                          ),
                        ],
                      )
                    ],
                  )
                : SizedBox(
                    height: size.height * 0.2,
                    width: Responsive.isMobile(context)
                        ? size.width * 0.5
                        : size.width * 0.3,
                    child: ListView(
                      children: [
                        for (var i in materiales.keys)
                          cardMaterial(i, size, materiales)
                      ],
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Responsive.isMobile(context)
                    ? const SizedBox()
                    : Container(
                        height: size.height * 0.1,
                        width: size.width * 0.05,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                          "lib/assets/logo.png",
                        ))),
                      ),
                Row(
                  mainAxisAlignment: Responsive.isMobile(context)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    isLoadingUpdate == true
                        ? LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20)
                        : compra['isPendiente'] == false
                            ? const Icon(
                                Icons.abc,
                                color: Colors.transparent,
                              )
                            : IconButton(
                                onPressed: () {
                                  updateInventario(size, context, setState,
                                      materiales, widget.doc.id);
                                },
                                icon: const Icon(
                                  LineIcons.checkCircle,
                                  color: Colors.green,
                                  size: 20,
                                )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isMateriales = !isMateriales;
                          });
                        },
                        icon: const Icon(
                          LineIcons.infoCircle,
                          color: Colors.amber,
                          size: 20,
                        )),
                    isLoadPdf == true
                        ? LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20)
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isLoadPdf = true;
                                generateCompra(setState, compra);
                              });
                            },
                            icon: Icon(
                              LineIcons.pdfFile,
                              color: colorblueLi,
                              size: 20,
                            )),
                    isLoadCorreo == true
                        ? LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20)
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                if (bytspdf == null) {
                                  error(size, context, "Debe descargar el pdf",
                                      "Antes de enviar por correo necesita generar el pdf");
                                } else {
                                  isLoadCorreo = true;
                                  getPdfBytes(bytspdf, size, (fn) {}, "",
                                      compra['correo']);
                                }
                              });
                            },
                            icon: Icon(
                              LineIcons.paperPlane,
                              color: colorOrangLiU,
                              size: 20,
                            )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getPdfBytes(var pdfLocal, Size size, StateSetter setter, String contacto,
      correo) async {
    FirebaseStorage fs = FirebaseStorage.instance;
    pdfUrl = null;
    Uint8List fileBytes = Uint8List.fromList(pdfLocal);
    var snapshot =
        await fs.ref().child('compras/${widget.doc.id}.pdf').putData(fileBytes);
    pdfUrl = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("compras")
        .doc(widget.doc.id)
        .update({"url": pdfUrl, "isCorreo": true}).then(
            (value) => enviarCorreo(size, setter, contacto, correo));
  }

  enviarCorreo(Size size, StateSetter setter, String contacto, correo) {
    Map<dynamic, dynamic> comp = {};
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("compras").doc(widget.doc.id);
    documentReference.get().then((doc) {
      if (doc.exists) {
        setState(() {
          comp = doc.data() as Map;
          if (comp['url'] != null) {
            getURL = comp['url'];
          }
        });
      } else {}
    }).whenComplete(() => {
          sendEmail(
                  nombre: compra['correo'],
                  documento: getURL,
                  email: compra['correo'],
                  mensaje:
                      "Cualquier duda ó comentario puede contactarnos en innovasun.dev@gmail.com")
              .then((value) => {
                    success(size, context, "Correo enviado correctamente!",
                        "El correo ha sido enviado correctamente al proveedor!"),
                    setState(() {
                      isLoadCorreo = false;
                    })
                  })
        });
  }

  Future sendEmail({
    required String nombre,
    required String documento,
    required String email,
    required String mensaje,
  }) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = 'service_mn5riqm';
    const templateId = 'template_mlugovf';
    const userId = 'oiApsAfNbghiTHpiz';

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'name': "Orden de compra para $email",
            'document': documento,
            'email': email,
            'message': mensaje,
            'usuario': widget.usuario
          }
        }));
  }

  Widget cardMaterial(var i, Size size, Map<dynamic, dynamic> auxMap) {
    return Card(
      elevation: 2,
      child: Container(
        height: size.height * 0.08,
        width: size.width,
        color: Colors.white,
        margin: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              auxMap[i]['nombre'],
              style: styleSecondary(12, colorGrey),
            ),
            Text(
              "Cantidad: ${auxMap[i]['cantidad']}",
              style: stylePrincipalBold(14, colorBlack),
            ),
            Text(
              "Subtotal \$${f.format((auxMap[i]['cantidad'] * auxMap[i]['precio']))}",
              style: stylePrincipalBold(14, colorBlack),
            ),
          ],
        ),
      ),
    );
  }
}
