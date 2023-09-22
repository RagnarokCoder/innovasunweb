import 'package:flutter/material.dart';

import '../color/colores.dart';
import '../responsive/responsive.dart';
import '../styles/style_principal.dart';

dialogOptions(Color color, String text, IconData icon, BuildContext context,
    VoidCallback yes, VoidCallback no) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
          child: Container(
              width: Responsive.isDesktop(context)
                  ? MediaQuery.of(context).size.width * 0.3
                  : MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              margin: Responsive.isDesktop(context)
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: color),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "lib/assets/logo.png",
                        width: 60,
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width * 0.15
                            : MediaQuery.of(context).size.width * 0.3,
                        child: Text(text,
                            style: stylePrincipalBold(12, colorBlack)),
                      ),
                      Icon(
                        icon,
                        color: colorGrey,
                        size: 15,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                          onPressed: yes,
                          icon: Icon(
                            Icons.check,
                            color: Colors.green.shade700,
                            size: 18,
                          ),
                          label: Text(
                            "Aceptar",
                            style: styleSecondary(12, colorGrey),
                          )),
                      TextButton.icon(
                          onPressed: no,
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red.shade700,
                            size: 18,
                          ),
                          label: Text(
                            "Cancelar",
                            style: styleSecondary(12, colorGrey),
                          ))
                    ],
                  )
                ],
              ))));
}
