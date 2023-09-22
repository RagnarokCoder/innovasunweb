import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import '../color/colores.dart';
import '../styles/style_principal.dart';

error(
  Size size,
  BuildContext context,
  String title,
  subtitle,
) {
  ElegantNotification.error(
    title: Text(
      title,
      style: stylePrincipalBold(14, colorBlack),
    ),
    description: Text(
      subtitle,
      style: styleSecondary(12, colorGrey),
    ),
    width: size.width * 0.5,
    notificationPosition: NotificationPosition.topRight,
  ).show(context);
}
