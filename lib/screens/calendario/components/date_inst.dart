import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/calendario/pdf/reporte_fechas.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/buttons/generic_button.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/styles/style_principal.dart';
import '../calendar.dart';

DateTime today = DateTime.now().add(const Duration(days: 1));
List<DateTime?> _dialogCalendarPickerValue = [DateTime.now(), today];

rangoFechaInstalacion(
    BuildContext context, StateSetter setter, Size size, String usuario) {
  const dayTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  final weekendTextStyle =
      TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
  final anniversaryTextStyle = TextStyle(
    color: Colors.red[400],
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );
  final config = CalendarDatePicker2WithActionButtonsConfig(
    dayTextStyle: dayTextStyle,
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: colorOrangLiU,
    closeDialogOnCancelTapped: true,
    firstDayOfWeek: 1,
    cancelButton: Text(
      "Cancelar",
      style: styleSecondary(12, colorBlack),
    ),
    okButton: Text(
      "Generar",
      style: styleSecondary(12, colorBlack),
    ),
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    centerAlignModePicker: true,
    customModePickerIcon: const SizedBox(),
    selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
    dayTextStylePredicate: ({required date}) {
      TextStyle? textStyle;
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        textStyle = weekendTextStyle;
      }
      if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
        textStyle = anniversaryTextStyle;
      }
      return textStyle;
    },
    dayBuilder: ({
      required date,
      textStyle,
      decoration,
      isSelected,
      isDisabled,
      isToday,
    }) {
      Widget? dayWidget;
      if (date.day % 3 == 0 && date.day % 9 != 0) {
        dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  MaterialLocalizations.of(context).formatDecimal(date.day),
                  style: textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 27.5),
                  child: Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isSelected == true ? Colors.white : colorOrangLiU,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return dayWidget;
    },
    yearBuilder: ({
      required year,
      decoration,
      isCurrentYear,
      isDisabled,
      isSelected,
      textStyle,
    }) {
      return Center(
        child: Container(
          decoration: decoration,
          height: 36,
          width: 72,
          child: Center(
            child: Semantics(
              selected: isSelected,
              button: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    year.toString(),
                    style: textStyle,
                  ),
                  if (isCurrentYear == true)
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return normalButton("Reporte por fechas", colorOrangLiU, colorOrangLiU, size,
      () async {
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: _dialogCalendarPickerValue,
      dialogBackgroundColor: colorwhite,
    );
    if (values != null) {
      setter(() {
        _dialogCalendarPickerValue = values;
        rangoA = _dialogCalendarPickerValue[0]!;
        rangoB = _dialogCalendarPickerValue[1]!;
        allMoves.clear();

        for (var r in ventas.keys) {
          DateTime fecha = ventas[r]['fecha'].toDate();
          if (fecha.isAfter(rangoA!) && fecha.isBefore(rangoB!)) {
            allMoves.putIfAbsent(r, () => ventas[r]);
            allMoves[r]['categoria'] = "venta";
          }
        }
        for (var r in gastos.keys) {
          DateTime fecha = gastos[r]['fecha'].toDate();
          if (fecha.isAfter(rangoA!) && fecha.isBefore(rangoB!)) {
            allMoves.putIfAbsent(r, () => gastos[r]);
            allMoves[r]['categoria'] = "gasto";
          }
        }
        for (var r in compras.keys) {
          DateTime fecha = compras[r]['fecha'].toDate();
          if (fecha.isAfter(rangoA!) && fecha.isBefore(rangoB!)) {
            allMoves.putIfAbsent(r, () => compras[r]);
            allMoves[r]['categoria'] = "compra";
          }
        }
        reporteFechasInstalacion(size);
      });
    }
  }, setter, context, LineIcons.calendar);
}
