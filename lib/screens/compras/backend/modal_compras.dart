import 'package:flutter/material.dart';

import '../../../constants/responsive/responsive.dart';
import '../components/modal_compras.dart';

modalCompras(
    Size size, BuildContext context, bool isEdit, String usuario, doc) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          width: size.width,
          height: Responsive.isDesktop(context) ? size.height * 0.8 : 150,
          color: Colors.transparent,
          child: Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(350, 0, 350, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ModalCompras(
                isEdit: isEdit,
                doc: doc,
                usuario: usuario,
              )),
        );
      });
}
