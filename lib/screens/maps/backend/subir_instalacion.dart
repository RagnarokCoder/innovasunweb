import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/maps/components/modal_instalaciones.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';

Map<String, dynamic> createInstall = {};
Map<dynamic, dynamic> getFotos = {};
String downloadUrl = "";

subirInstalacion(Size size, BuildContext context, StateSetter setSt,
    String usuario, String id) async {
  var uuid = const Uuid();
  if (nombreController.text.isEmpty ||
      estadoController.text.isEmpty ||
      folioController.text.isEmpty ||
      clienteController.text.isEmpty ||
      direccionController.text.isEmpty ||
      comunidadController.text.isEmpty ||
      numIntController.text.isEmpty) {
    warning(
      size,
      context,
      "¡Campos vacios!",
      "Por favor no deje campos vacios",
    );
  } else {
    if (cantidadController.text.isEmpty) {
      cantidadController.text = "1";
    }
    if (observController.text.isEmpty) {
      observController.text = "Sin observación";
    }
    if (telefonoController.text.isEmpty) {
      telefonoController.text = "0";
    }
    var n = 0;
    for (var i in listFiles.keys) {
      n += 1;

      Reference ref =
          FirebaseStorage.instance.ref().child('fotos/${uuid.v4()}');

      TaskSnapshot uploadedFile = await ref.putData(i);
      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await ref.getDownloadURL();
        getFotos.putIfAbsent('${clienteController.text} $n', () => downloadUrl);
        downloadUrl = "";
        setSt(() {});
      } else {}
    }
    if (latitud.text.isEmpty || longitud.text.isEmpty) {
      createInstall = {
        "usuario": usuario,
        "cantidad": double.parse(cantidadController.text),
        "cliente": clienteController.text,
        "producto": "Calentadores",
        "isMaterial": false,
        "estado": estadoController.text,
        "folio": folioController.text,
        "nombre": nombreController.text,
        "direccion": direccionController.text,
        "comunidad": comunidadController.text,
        "numero": numIntController.text,
        "telefono": telefonoController.text,
        "observaciones": observController.text,
        "fotos": getFotos,
        "isWeb": true,
        "fecha": DateTime.now()
      };
    } else {
      createInstall = {
        "usuario": usuario,
        "cantidad": double.parse(cantidadController.text),
        "cliente": clienteController.text,
        "producto": "Calentadores",
        "isMaterial": false,
        "estado": estadoController.text,
        "folio": folioController.text,
        "nombre": nombreController.text,
        "direccion": direccionController.text,
        "comunidad": comunidadController.text,
        "numero": numIntController.text,
        "telefono": telefonoController.text,
        "fotos": getFotos,
        "observaciones": observController.text,
        "isWeb": true,
        "ubicacion": {
          "latitude": double.parse(latitud.text),
          "longitude": double.parse(longitud.text)
        },
        "fecha": DateTime.now()
      };
    }
    if (id == "") {
      return FirebaseFirestore.instance
          .collection("instalaciones")
          .add(createInstall)
          .then((value) => {
                setSt(
                  () {
                    clienteController.clear();
                    cantidadController.clear();
                    estadoController.clear();
                    folioController.clear();
                    nombreController.clear();
                    direccionController.clear();
                    comunidadController.clear();
                    numIntController.clear();
                    telefonoController.clear();
                    observController.clear();
                    latitud.clear();
                    longitud.clear();
                    isLoadingInst = false;
                  },
                ),
                success(size, context, "Instalacion guardada correctamente",
                    "La instalación ha sido guardada en la nube"),
              });
    }
    return FirebaseFirestore.instance
        .collection("instalaciones")
        .doc(id)
        .update(createInstall)
        .then((value) => {
              setSt(
                () {
                  clienteController.clear();
                  cantidadController.clear();
                  estadoController.clear();
                  folioController.clear();
                  nombreController.clear();
                  direccionController.clear();
                  comunidadController.clear();
                  numIntController.clear();
                  telefonoController.clear();
                  observController.clear();
                  latitud.clear();
                  longitud.clear();
                  isLoadingInst = false;
                },
              ),
              Navigator.of(context).pop(),
              success(size, context, "Instalacion guardada correctamente",
                  "La instalación ha sido guardada en la nube"),
            });
  }
}
