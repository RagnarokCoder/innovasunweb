// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/calendario/calendar.dart';
import 'package:innovasun/screens/compras/compras.dart';
import 'package:innovasun/screens/correos/correos.dart';
import 'package:innovasun/screens/creditos/creditos.dart';
import 'package:innovasun/screens/dashboard/dashboard.dart';

import 'package:innovasun/screens/inventario/inventario.dart';
import 'package:innovasun/screens/maps/maps.dart';
import 'package:innovasun/screens/ventas/ventas.dart';

import '../../constants/responsive/responsive.dart';
import '../activos/activosv.dart';
import '../navigation/top_bar.dart';
import 'components/bottom_menu.dart';

class Home extends StatefulWidget {
  final String usuario;
  const Home({Key? key, required this.usuario}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

int indexGlobal = -1;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.usuario.split("_")[1].split("@")[0] == "inv") {
      select = "bodega";
    }
    return Scaffold(
        appBar: Responsive.isDesktop(context)
            ? appBar(size, setState, widget.usuario, context)
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
        body: indexGlobal == -1
            ? SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/logo.png",
                      width: 300,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Bienvenido a innovasun",
                      style: stylePrincipalBold(18, colorBlack),
                    )
                  ],
                ),
              )
            : indexGlobal == 0
                ? DashBoard(
                    usuario: widget.usuario,
                  )
                : indexGlobal == 1
                    ? MapsW(
                        usuario: widget.usuario,
                      )
                    : indexGlobal == 2
                        ? Ventas(
                            usuario: widget.usuario,
                          )
                        : indexGlobal == 3
                            ? Inventario(
                                usuario: widget.usuario, select: select)
                            : indexGlobal == 4
                                ? const Calendario()
                                : indexGlobal == 5
                                    ? Activo(
                                        usuario: widget.usuario,
                                      )
                                    : indexGlobal == 6
                                        ? Compras(
                                            usuario: widget.usuario,
                                          )
                                        : indexGlobal == 7
                                            ? Correos(
                                                usuario: widget.usuario,
                                              )
                                            : CreditosV(
                                                usuario: widget.usuario,
                                              ),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 0,
                  )
                : const SizedBox());
  }
}
