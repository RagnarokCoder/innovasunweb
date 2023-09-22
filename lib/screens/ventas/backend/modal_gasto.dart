import 'package:flutter/material.dart';
import 'package:innovasun/screens/ventas/components/gaso_caja.dart';
import 'package:innovasun/screens/ventas/components/modal_credito.dart';

import '../../../constants/responsive/responsive.dart';

modalGasto(Size size, BuildContext context, String usuario) {
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
              child: GastosCaja(
                usuario: usuario,
              )),
        );
      });
}

modalCredito(
    Size size, BuildContext context, String usuario, StateSetter setter) {
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
              child: ModalCreditoVentas(
                usuario: usuario,
                setter: setter,
              )),
        );
      });
}
