// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovasun/screens/activos/components/modal_activo.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';

Map<String, dynamic> createInventory = {};
uploadToStorage(StateSetter setSt) async {
  final ImagePicker picker = ImagePicker();

  var mediaData = await picker.getImage(source: ImageSource.gallery);

  List<int> bytes = await mediaData!.readAsBytes();
  getImg = bytes;
  setSt(() {});
}

subirActivo(Size size, BuildContext context, StateSetter setSt, String usuario,
    String id) async {
  if (nombre.text.isEmpty ||
      descripcion.text.isEmpty ||
      precio.text.isEmpty ||
      stock.text.isEmpty) {
    warning(
      size,
      context,
      "¡Campos vacios!",
      "Por favor no deje campos vacios",
    );
  } else {
    isLoadingActivo = true;
    if (getImg != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child('activos/${uuid.v4()}');

      TaskSnapshot uploadedFile = await ref.putData(getImg);
      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await ref.getDownloadURL();

        setSt(() {});
      } else {}
    }
    createInventory = {
      "nombre": nombre.text,
      "cantidad": double.parse(stock.text),
      "precio": double.parse(precio.text),
      "descripcion": descripcion.text,
      "fecha": DateTime.now(),
      "imagen": downloadUrl,
      "uuid": uuid.v4()
    };
    if (id != "") {
      FirebaseFirestore.instance
          .collection("activos")
          .doc(id)
          .update(createInventory)
          .then((value) => {
                setSt(
                  () {
                    createInventory.clear();
                    nombre.clear();
                    stock.clear();
                    precio.clear();
                    descripcion.clear();
                    downloadUrl = "";
                    getImg = null;
                    isLoadingActivo = false;
                  },
                ),
                Navigator.of(context).pop(),
                success(
                  size,
                  context,
                  "Activo guardado correctamente!",
                  "El activo ha sido guardado correctamente en la nube.",
                )
              });
    } else {
      FirebaseFirestore.instance
          .collection("activos")
          .add(createInventory)
          .then((value) => {
                setSt(
                  () {
                    createInventory.clear();
                    nombre.clear();
                    stock.clear();
                    precio.clear();
                    descripcion.clear();
                    downloadUrl = "";
                    getImg = null;
                    isLoadingActivo = false;
                  },
                ),
                Navigator.of(context).pop(),
                success(
                  size,
                  context,
                  "Producto guardado correctamente!",
                  "El producto ha sido guardado correctamente en la nube.",
                )
              });
    }
  }
}
