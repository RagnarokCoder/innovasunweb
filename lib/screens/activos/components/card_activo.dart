// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/activos/backend/modal.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class CardActivo extends StatefulWidget {
  final String usuario;
  final DocumentSnapshot doc;
  final Size size;
  const CardActivo(
      {Key? key, required this.usuario, required this.doc, required this.size})
      : super(key: key);

  @override
  _CardActivoState createState() => _CardActivoState();
}

class _CardActivoState extends State<CardActivo> {
  Map<dynamic, dynamic> getActivo = {};
  @override
  Widget build(BuildContext context) {
    getActivo = widget.doc.data() as Map;
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        modalActivo(size, context, true, widget.usuario, widget.doc.id);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: size.height * 0.3,
              width: size.width * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.2,
                    width: size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(getActivo['imagen'] == "" ||
                                    getActivo['imagen'] == null
                                ? "https://firebasestorage.googleapis.com/v0/b/cmotion.appspot.com/o/logonegroa.png?alt=media&token=2088b7c3-4011-4d0f-a32d-8ccdb8cc0f9d"
                                : getActivo['imagen']))),
                  ),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                    color: colorOrangLiU,
                    thickness: 1,
                  ),
                  Text(
                    getActivo['nombre'],
                    style: styleSecondary(12, colorGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "\$${f.format(getActivo['precio'])} (MXN)",
                        style: stylePrincipalBold(14, colorBlack),
                      ),
                      Text(
                        "C. ${f.format(getActivo['cantidad'])}",
                        style: stylePrincipalBold(14, colorBlack),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                top: -15,
                right: -15,
                child: InkWell(
                  onTap: () {
                    createPDF(getActivo['uuid']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorOrange,
                        borderRadius: BorderRadius.circular(500)),
                    height: 45,
                    width: 45,
                    child: const Center(
                      child: Icon(
                        LineIcons.qrcode,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> createPDF(String uuid) async {
    final pdf = pw.Document(title: uuid);

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: uuid,
              color: PdfColor.fromHex("#000000"),
              width: 500,
              height: 500,
            ),
          ];
        }));

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    //List<int> qrb = bytes;
    html.window.open(url, 'Qr orden de compra');
  }
}
