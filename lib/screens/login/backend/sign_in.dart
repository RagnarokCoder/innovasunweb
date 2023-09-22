import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../../../constants/alerts/error.dart';
import '../login.dart';

Future signIn(Size size, StateSetter stateSetter, BuildContext context) async {
  if (usuario.text.isEmpty || password.text.isEmpty) {
    debugPrint("error");
    error(size, context, "¡No deje campos vacios!",
        "Verifique que todos los campos esten llenos");
  } else {
    stateSetter(() {
      isLoadingLogin = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: usuario.text.trim(), password: password.text.trim())
          .whenComplete(() => {
                stateSetter(() {
                  isLoadingLogin = false;
                })
              });
    } on FirebaseAuthException catch (e) {
      stateSetter(() {
        if (e.code == "wrong-password") {
          error(size, context, "¡Contraseña incorrecta!",
              "Verifique su contraseña para continuar");
        } else if (e.code == "user-not-found") {
          error(size, context, "¡Usuario no encontrado!",
              "El usuario con el que intento ingresar no existe");
        } else if (e.code == "invalid-email") {
          error(size, context, "usuario incorrecto!",
              "El usuario con el que intento ingresar no es correcto");
        }
      });
    }
  }

  navigatorKey.currentState?.popUntil((route) => route.isFirst);
}
