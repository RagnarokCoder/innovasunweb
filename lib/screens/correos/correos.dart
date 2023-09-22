// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/correos/backend/get_correo.dart';
import 'package:innovasun/screens/correos/backend/modal_corr.dart';
import 'package:innovasun/screens/correos/components/card_correo.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/buttons/generic_button.dart';
import '../../constants/color/colores.dart';
import '../../widgets/buscador.dart';

class Correos extends StatefulWidget {
  final String usuario;
  const Correos({Key? key, required this.usuario}) : super(key: key);

  @override
  _CorreosState createState() => _CorreosState();
}

String correoSelect = "";

List<String> correos = [];

class _CorreosState extends State<Correos> {
  @override
  void initState() {
    getAllCorreos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      titulo: "correo",
                    )),
                const SizedBox(
                  width: 15,
                ),
                normalButton("Nuevo Correo", colorOrangLiU, colorOrangLiU, size,
                    () {
                  modalCorreo(size, context, false, widget.usuario, "");
                }, setState, context, LineIcons.plus),
                const SizedBox(
                  width: 15,
                ),
                normalButton("Limpiar", colorOrangLiU, colorOrangLiU, size, () {
                  setState(() {
                    correoSelect = "";
                  });
                }, setState, context, LineIcons.broom),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            getListaCorreos(size)
          ],
        ),
      ),
    );
  }

  Widget getListaCorreos(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.8,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream: correoSelect != ""
              ? FirebaseFirestore.instance
                  .collection("correos")
                  .where("nombre", isEqualTo: correoSelect)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("correos")
                  .limit(25)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: colorOrangLiU, size: 20));
            }
            if (snapshot.data!.docs.isEmpty) {
              return const SizedBox();
            }
            int length = snapshot.data!.docs.length;
            return ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot doc = snapshot.data!.docs[index];
                return CardCorreos(
                  size: size,
                  doc: doc,
                  usuario: widget.usuario,
                );
              },
            );
          }),
    );
  }
}
