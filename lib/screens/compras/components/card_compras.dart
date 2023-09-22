// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/compras/backend/modal_compras.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

class CardCompras extends StatefulWidget {
  const CardCompras({Key? key}) : super(key: key);

  @override
  _CardComprasState createState() => _CardComprasState();
}

class _CardComprasState extends State<CardCompras> {
  @override
  Widget build(BuildContext context) {
    String creacion = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        modalCompras(size, context, true);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(12),
        child: Container(
          height: size.height * 0.2,
          width: size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Titulo compra",
                    style: styleSecondary(12, colorGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    creacion,
                    style: stylePrincipalBold(15, colorOrangLiU),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        "Costo  ",
                        style: styleSecondary(12, colorGrey),
                      ),
                      Text(
                        "\$${f.format(5000)} (MXN)",
                        style: stylePrincipalBold(14, colorBlack),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Materiales  ",
                        style: styleSecondary(12, colorGrey),
                      ),
                      Text(
                        "5",
                        style: stylePrincipalBold(14, colorBlack),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: size.width * 0.05,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                      "lib/assets/logo.png",
                    ))),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            LineIcons.checkCircle,
                            color: Colors.green,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            LineIcons.infoCircle,
                            color: Colors.amber,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            LineIcons.paperPlane,
                            color: colorOrangLiU,
                            size: 20,
                          )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
