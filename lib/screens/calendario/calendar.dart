// ignore_for_file: library_private_types_in_public_api

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/vars/vars.dart';
import 'package:innovasun/screens/calendario/backend/get_ventas.dart';
import 'package:innovasun/screens/calendario/components/date_inst.dart';
import 'package:innovasun/screens/calendario/components/select_user.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants/buttons/generic_button.dart';
import '../../constants/responsive/responsive.dart';

class Calendario extends StatefulWidget {
  const Calendario({Key? key}) : super(key: key);

  @override
  _CalendarioState createState() => _CalendarioState();
}

CalendarController calendarController = CalendarController();

int checkvalue = 0;

bool isFilter = false;
bool isLoadingCalendario = false;

Map<dynamic, dynamic> ventas = {};
Map<dynamic, dynamic> compras = {};
Map<dynamic, dynamic> gastos = {};
Map<dynamic, dynamic> instalaciones = {};
Map<dynamic, dynamic> allMoves = {};

String filters = "";

List<String> usuarios = [];

DateTime? rangoA, rangoB;

class _CalendarioState extends State<Calendario> {
  @override
  void initState() {
    getAll();
    super.initState();
  }

  void clearAllLists() {
    ventas.clear();
    compras.clear();
    gastos.clear();
    instalaciones.clear();
  }

  getAll() {
    setState(() {
      clearAllLists();
      getInstalaciones(setState);
      if (filters == "") {
        getVentas(setState);
        getGastos(setState);
        getCompras(setState);
        getInstalaciones(setState);
        getUsuarios(setState);
      } else {
        Map<String, Function> filterFunctions = {
          'ventas': getVentas,
          'gastos': getGastos,
          'compras': getCompras,
          'instalaciones': getInstalaciones,
        };

        Function? filterFunction = filterFunctions[filters];
        if (filterFunction != null) {
          filterFunction(setState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      supportedLocales: const [
        Locale('es'),
      ],
      home: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [filtros(size), calendario(size)],
          ),
        ),
      ),
    );
  }

  Widget filtros(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isFilter = !isFilter;
            });
          },
          child: Row(
            children: [
              Text(
                "Filtros",
                style: TextStyle(
                  color: colorGrey,
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                LineIcons.expand,
                color: colorGrey,
                size: 15,
              )
            ],
          ),
        ),
        AnimatedSizeAndFade(
            child: isFilter == false
                ? SizedBox(
                    width: size.width * .5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        clickFilter("Compras", colorOrangLiU),
                        clickFilter("Ventas", Colors.amber),
                        clickFilter("Gastos", Colors.purpleAccent),
                        clickFilter("Instalaciones", colorOrange),
                        clickFilter("Todos", colorBlack)
                      ],
                    ),
                  )
                : SizedBox(
                    width: size.width * 0.7,
                    height: size.height * .1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        normalButton("Filtrar por Día", colorOrangLiU,
                            colorOrangLiU, size, () {
                          setState(() {
                            checkvalue = 1;
                            isLoadingCalendario = true;
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                setState(() {
                                  isLoadingCalendario = false;
                                });
                              },
                            );
                          });
                        }, setState, context, LineIcons.calendarPlus),
                        normalButton("Filtrar por Semana", colorOrangLiU,
                            colorOrangLiU, size, () {
                          checkvalue = 2;
                          isLoadingCalendario = true;
                          Future.delayed(
                            const Duration(milliseconds: 500),
                            () {
                              setState(() {
                                isLoadingCalendario = false;
                              });
                            },
                          );
                        }, setState, context, LineIcons.calendarPlus),
                        normalButton("Filtrar por Mes", colorOrangLiU,
                            colorOrangLiU, size, () {
                          checkvalue = 0;
                          isLoadingCalendario = true;
                          Future.delayed(
                            const Duration(milliseconds: 500),
                            () {
                              setState(() {
                                isLoadingCalendario = false;
                              });
                            },
                          );
                        }, setState, context, LineIcons.calendarPlus),
                        normalButton("Reporte instalador", colorOrangLiU,
                            colorOrangLiU, size, () {
                          modalSelect(size, context, "", setState);
                        }, setState, context, LineIcons.folderOpen),
                        rangoFechaInstalacion(context, setState, size, "")
                      ],
                    ),
                  )),
        const SizedBox()
      ],
    );
  }

  Widget clickFilter(String filter, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          isLoadingCalendario = true;

          String newFilters = "";
          if (filter == "Ventas") {
            newFilters = "ventas";
          } else if (filter == "Gastos") {
            newFilters = "gastos";
          } else if (filter == "Compras") {
            newFilters = "compras";
          } else if (filter == "Instalaciones") {
            newFilters = "instalaciones";
          } else if (filter == "TODOS") {
            newFilters = "";
          }

          filters = newFilters;
          getAll();

          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              isLoadingCalendario = false;
            });
          });
        });
      },
      child: Row(
        children: [
          Text(
            filter,
            style: TextStyle(
              color: colorGrey,
              fontSize: 11,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Icon(
            LineIcons.circleNotched,
            color: color,
            size: 15,
          )
        ],
      ),
    );
  }

  Widget calendario(Size size) {
    debugPrint(checkvalue.toString());
    return SizedBox(
        height: isFilter == true ? size.height * 0.75 : size.height * 0.85,
        width: Responsive.isDesktop(context)
            ? size.width
            : Responsive.isTablet(context)
                ? size.width * 0.7
                : size.width,
        child: isLoadingCalendario == true
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: colorOrangLiU, size: 20))
            : SfCalendar(
                cellBorderColor: Colors.white,
                todayHighlightColor: Colors.white,
                backgroundColor: Colors.white,
                showNavigationArrow: true,
                view: checkvalue == 1
                    ? CalendarView.timelineDay
                    : checkvalue == 2
                        ? CalendarView.workWeek
                        : CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),
                onTap: (calendarTapDetails) {},
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (var i in ventas.keys) {
      DateTime date = ventas[i]['fecha'].toDate();
      meetings.add(
        Meeting("Venta \$${f.format(ventas[i]['total'])}", date,
            date.add(const Duration(hours: 1)), Colors.amber, false, () {}),
      );
    }
    for (var i in gastos.keys) {
      DateTime date = gastos[i]['fecha'].toDate();
      meetings.add(
        Meeting(
            "Gasto \$${f.format(gastos[i]['cantidad'])}",
            date,
            date.add(const Duration(hours: 1)),
            Colors.purpleAccent,
            false,
            () {}),
      );
    }
    for (var i in compras.keys) {
      DateTime date = compras[i]['fecha'].toDate();
      meetings.add(
        Meeting("Compra \$${f.format(compras[i]['total'])}", date,
            date.add(const Duration(hours: 1)), colorOrangLiU, false, () {}),
      );
    }
    for (var i in instalaciones.keys) {
      DateTime date = instalaciones[i]['fecha'].toDate();
      meetings.add(
        Meeting("Instalación", date, date.add(const Duration(hours: 1)),
            colorOrange, false, () {}),
      );
    }
    return meetings;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.fun);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  Function fun;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    Meeting meetingData = Meeting(
        "Demo",
        DateTime.now(),
        DateTime.now().add(const Duration(hours: 1)),
        colorOrangLiU,
        false,
        () {});
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
