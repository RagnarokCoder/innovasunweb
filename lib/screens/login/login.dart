// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/inputs/password_input.dart';
import 'package:innovasun/constants/inputs/text_input.dart';
import 'package:innovasun/constants/responsive/responsive.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/login/backend/sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

TextEditingController usuario = TextEditingController();
TextEditingController password = TextEditingController();

bool isObsc = true;
bool isLoadingLogin = false;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Responsive(
        mobile: loginMobile(size),
        tablet: loginMobile(size),
        desktop: loginDesk(size));
  }

  Widget loginMobile(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      color: colorGray,
      child: Center(
        child: Card(
          elevation: 4,
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "lib/assets/logo.png",
                      width: 100,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Login",
                      style: styleSecondary(16, colorGrey),
                    ),
                    Text(
                      "Bienvenido de Nuevo",
                      style: stylePrincipalBold(20, colorBlack),
                    ),
                  ],
                ),
                Column(
                  children: [
                    textInput("Nombre", "Usuario", usuario, setState, context),
                    const SizedBox(
                      height: 25,
                    ),
                    passwordInput("Password", "Contraseña", password, isObsc,
                        () {
                      setState(() {
                        isObsc = !isObsc;
                      });
                    }, setState, context)
                  ],
                ),
                isLoadingLogin == true
                    ? Center(
                        child: LoadingAnimationWidget.discreteCircle(
                            color: colorOrangLiU, size: 20))
                    : genericButtonV(
                        "Iniciar Sesión", colorOrangLiU, colorBlack, size, () {
                        signIn(size, setState, context);
                      }, setState, context),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Ayuda",
                      style: TextStyle(
                        color: colorBlack,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginDesk(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      color: colorGray,
      child: Center(
        child: Card(
          elevation: 4,
          child: Container(
            height: size.height * 0.9,
            width: size.width * 0.9,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: size.width * 0.35,
                  height: size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("lib/assets/calentador.jpg"),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: size.width * 0.6,
                    height: size.height * 0.9,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              "lib/assets/logo.png",
                              width: 100,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Login",
                              style: styleSecondary(16, colorGrey),
                            ),
                            Text(
                              "Bienvenido de Nuevo",
                              style: stylePrincipalBold(20, colorBlack),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            textInput("Nombre", "Usuario", usuario, setState,
                                context),
                            const SizedBox(
                              height: 25,
                            ),
                            passwordInput(
                                "Password", "Contraseña", password, isObsc, () {
                              setState(() {
                                isObsc = !isObsc;
                              });
                            }, setState, context)
                          ],
                        ),
                        isLoadingLogin == true
                            ? Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                    color: colorOrangLiU, size: 20))
                            : genericButtonV("Iniciar Sesión", colorOrangLiU,
                                colorBlack, size, () {
                                signIn(size, setState, context);
                              }, setState, context),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Ayuda",
                              style: TextStyle(
                                color: colorBlack,
                                fontSize: 11,
                                decoration: TextDecoration.underline,
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
