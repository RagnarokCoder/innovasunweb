// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/buttons/generic_button.dart';
import 'package:innovasun/screens/calendario/calendar.dart';
import 'package:innovasun/screens/calendario/pdf/reporte_instalador.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/color/colores.dart';
import '../../../constants/responsive/responsive.dart';
import '../../../constants/styles/style_principal.dart';

class SelectChats extends StatefulWidget {
  final StateSetter setter;
  const SelectChats({Key? key, required this.setter}) : super(key: key);

  @override
  _SelectChatsState createState() => _SelectChatsState();
}

Map<dynamic, dynamic> usuarioGet = {};
String userSelect = "";
Map<dynamic, dynamic> instalacionesPdf = {};

class _SelectChatsState extends State<SelectChats> {
  @override
  void initState() {
    for (var i in usuarios) {
      usuarioGet.putIfAbsent(i, () => {"select": false});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: ListView(
        children: [
          normalButton("Generar reporte", colorOrangLiU, colorOrangLiU, size,
              () {
            instalacionesPdf.clear();

            for (var r in instalaciones.keys) {
              if (userSelect == instalaciones[r]['usuario']) {
                instalacionesPdf.putIfAbsent(r, () => instalaciones[r]);
                setState(() {});
              }
            }
            reporteInstalador(size);
          }, setState, context, LineIcons.plusCircle),
          SizedBox(
            width: size.width,
            child: Column(
              children: [for (var i in usuarios) selectCard(i, size)],
            ),
          )
        ],
      ),
    );
  }

  Widget selectCard(var i, Size size) {
    return InkWell(
      onTap: () {
        setState(() {
          userSelect = i;
        });
      },
      child: SizedBox(
        width: Responsive.isDesktop(context) ? size.width * 0.3 : size.width,
        height: size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: Responsive.isDesktop(context)
                    ? size.width * 0.28
                    : size.width * 0.6,
                child: Text(
                  i,
                  style: styleSecondary(14, colorBlack),
                )),
            const SizedBox(
              width: 10,
            ),
            Icon(
              userSelect == i ? Icons.check_box : Icons.check_box_outline_blank,
              color: userSelect == i ? colorOrangLiU : colorBlack,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}

modalSelect(
    Size size, BuildContext context, String usuario, StateSetter setter) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: size.width * 0.4,
            height: size.height * 0.4,
            color: Colors.transparent,
            child: Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(400, 0, 400, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  height: size.height * 0.8,
                  width: Responsive.isDesktop(context)
                      ? size.width * 0.4
                      : size.width - 200,
                  child: SelectChats(
                    setter: setter,
                  )),
            ),
          );
        });
      });
}
