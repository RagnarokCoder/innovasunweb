// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';
import '../components/modal_inventario.dart';

Map<String, dynamic> createInventory = {};
uploadToStorage(StateSetter setSt) async {
  final ImagePicker picker = ImagePicker();

  var mediaData = await picker.getImage(source: ImageSource.gallery);

  List<int> bytes = await mediaData!.readAsBytes();
  getImg = bytes;
  setSt(() {});
}

subirProducto(Size size, BuildContext context, StateSetter setSt,
    String usuario, String id) async {
  if (nombre.text.isEmpty ||
      descripcion.text.isEmpty ||
      venta.text.isEmpty ||
      compra.text.isEmpty ||
      stock.text.isEmpty) {
    warning(
      size,
      context,
      "¡Campos vacios!",
      "Por favor no deje campos vacios",
    );
  } else {
    isLoadingInventario = true;
    if (getImg != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child('inventario/${uuid.v4()}');

      TaskSnapshot uploadedFile = await ref.putData(getImg);
      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await ref.getDownloadURL();

        setSt(() {});
      } else {}
    }
    createInventory = {
      "nombre": nombre.text,
      "cantidad": double.parse(stock.text),
      "venta": double.parse(venta.text),
      "compra": double.parse(compra.text),
      "descripcion": descripcion.text,
      "fecha": DateTime.now(),
      "imagen": downloadUrl,
      "uuid": uuid.v4(),
      "categoria": categoria
    };
    if (id != "") {
      FirebaseFirestore.instance
          .collection("inventario")
          .doc(id)
          .update(createInventory)
          .then((value) => {
                setSt(
                  () {
                    createInventory.clear();
                    nombre.clear();
                    stock.clear();
                    venta.clear();
                    compra.clear();
                    descripcion.clear();
                    downloadUrl = "";
                    getImg = null;
                    isLoadingInventario = false;
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
    } else {
      FirebaseFirestore.instance
          .collection("inventario")
          .add(createInventory)
          .then((value) => {
                setSt(
                  () {
                    createInventory.clear();
                    nombre.clear();
                    stock.clear();
                    venta.clear();
                    compra.clear();
                    descripcion.clear();
                    downloadUrl = "";
                    getImg = null;
                    isLoadingInventario = false;
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
