import 'package:flutter/material.dart';
import '../color/colores.dart';
import '../responsive/responsive.dart';
import '../styles/style_principal.dart';

bool isHover = false;
Widget genericButton(String title, Color color, color2, Size size,
    VoidCallback fun, StateSetter setst, BuildContext context) {
  return InkWell(
    onHover: (value) {
      setst((() {
        isHover = value;
      }));
    },
    onTap: fun,
    child: Container(
      height: size.height * 0.08,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.4,
      decoration: BoxDecoration(
          color: isHover == false ? color : color2,
          borderRadius: BorderRadius.circular(18)),
      child: Center(
          child: Text(
        title,
        style: stylePrincipalBold(14, Colors.white),
      )),
    ),
  );
}

Widget genericButtonV(String title, Color color, color2, Size size,
    VoidCallback fun, StateSetter setst, BuildContext context) {
  return InkWell(
    onHover: (value) {
      setst((() {
        isHover = value;
      }));
    },
    onTap: fun,
    child: Container(
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.3 : size.width * 0.5,
      decoration: BoxDecoration(
          color: isHover == false ? color : color2,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        title,
        style: stylePrincipalBold(14, Colors.white),
        textAlign: TextAlign.center,
      )),
    ),
  );
}

Widget normalButton(String title, Color color, color2, Size size,
    VoidCallback fun, StateSetter setst, BuildContext context, IconData icon) {
  return InkWell(
    onHover: (value) {
      setst((() {
        isHover = value;
      }));
    },
    onTap: fun,
    child: Container(
        height: size.height * 0.04,
        width:
            Responsive.isDesktop(context) ? size.width * 0.1 : size.width * 0.2,
        decoration: BoxDecoration(
            color: isHover == false ? color : color2,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: colorwhite,
              size: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: styleSecondary(11, colorwhite),
              textAlign: TextAlign.center,
            ),
          ],
        )),
  );
}

Widget normalButtonSmall(String title, Color color, color2, Size size,
    VoidCallback fun, StateSetter setst, BuildContext context, IconData icon) {
  return InkWell(
    onHover: (value) {
      setst((() {
        isHover = value;
      }));
    },
    onTap: fun,
    child: Container(
        height: size.height * 0.04,
        width: Responsive.isDesktop(context)
            ? size.width * 0.07
            : size.width * 0.2,
        decoration: BoxDecoration(
            color: isHover == false ? color : color2,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: colorwhite,
              size: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: styleSecondary(11, colorwhite),
              textAlign: TextAlign.center,
            ),
          ],
        )),
  );
}
