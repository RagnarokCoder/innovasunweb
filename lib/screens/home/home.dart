// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/screens/calendario/calendar.dart';
import 'package:innovasun/screens/compras/compras.dart';
import 'package:innovasun/screens/correos/correos.dart';
import 'package:innovasun/screens/creditos/creditos.dart';
import 'package:innovasun/screens/dashboard/dashboard.dart';

import 'package:innovasun/screens/inventario/inventario.dart';
import 'package:innovasun/screens/maps/maps.dart';
import 'package:innovasun/screens/ventas/ventas.dart';

import '../activos/activosv.dart';
import '../navigation/top_bar.dart';

class Home extends StatefulWidget {
  final String usuario;
  const Home({Key? key, required this.usuario}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

int indexGlobal = 0;

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(size, setState),
        body: indexGlobal == 0
            ? const DashBoard()
            : indexGlobal == 1
                ? MapsW(
                    size: size,
                  )
                : indexGlobal == 2
                    ? Ventas(
                        usuario: widget.usuario,
                      )
                    : indexGlobal == 3
                        ? Inventario(
                            usuario: widget.usuario,
                          )
                        : indexGlobal == 4
                            ? const Calendario()
                            : indexGlobal == 5
                                ? Activo(
                                    usuario: widget.usuario,
                                  )
                                : indexGlobal == 6
                                    ? const Compras()
                                    : indexGlobal == 7
                                        ? Correos(
                                            usuario: widget.usuario,
                                          )
                                        : CreditosV(
                                            usuario: widget.usuario,
                                          ));
  }
}
