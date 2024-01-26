// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:innovasun/constants/color/colores.dart';
import 'package:innovasun/constants/responsive/responsive.dart';
import 'package:innovasun/constants/styles/style_principal.dart';
import 'package:innovasun/screens/activos/activosv.dart';
import 'package:innovasun/screens/activos/backend/get_activos.dart';
import 'package:innovasun/screens/creditos/backend/get_creditos.dart';
import 'package:innovasun/screens/creditos/creditos.dart';
import 'package:line_icons/line_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/vars/vars.dart';
import '../home/backend/gets.dart';
import '../home/components/bottom_menu.dart';

class DashBoard extends StatefulWidget {
  final String usuario;
  const DashBoard({Key? key, required this.usuario}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

List<_PieData> comparativa = [];
List<ChartData2> instalacionesData = [];
List<ChartData2> inventarioData = [];

dynamic totalVentas = 0;
dynamic totalCompras = 0;
dynamic totalGastos = 0;
dynamic totalInventario = 0;
dynamic totalCorreos = 0;
dynamic totalInstalaciones = 0;

Map<dynamic, dynamic> ventas = {};
Map<int, dynamic> ventasDash = {};
Map<dynamic, dynamic> instalacionesDash = {};
Map<int, dynamic> instalacionesTotales = {};
Map<dynamic, dynamic> inventarioGet = {};

List<ChartData> ventasGet = [];

List<String> fechasName = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre'
];

double totalMesActual = 0;
double totalMesPasado = 0;
double porcentajeCambio = 0;
double porcentajeCambioanio = 0;
double totalMesAnoPasado = 0;

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    getVentasDash(setState);
    getComprasDash(setState);
    getGastosDash(setState);
    getVentasAnio(setState);
    getVentasComparativas();
    getInstalacionesMes(setState);
    getCreditos(setState);
    getProductsI(setState);
    getInventario(setState);
    getCorreos(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    comparativa.clear();
    ventasGet.clear();
    ventasDash.clear();
    instalacionesData.clear();
    inventarioData.clear();
    instalacionesTotales.clear();
    comparativa.add(
      _PieData('Ventas', totalVentas, "\$${f.format(totalVentas)}"),
    );
    comparativa.add(
      _PieData('Compras', totalCompras, "\$${f.format(totalCompras)}"),
    );
    comparativa.add(
      _PieData('Gastos', totalGastos, "\$${f.format(totalGastos)}"),
    );
    for (var i in ventas.keys) {
      DateTime month = ventas[i]['fecha'].toDate();
      if (ventasDash.containsKey(month.month)) {
        ventasDash[month.month]['total'] += ventas[i]['total'];
      } else {
        ventasDash.putIfAbsent(
            month.month, () => {"total": ventas[i]['total'], "fecha": month});
      }
    }

    var sortedByKeyMap = Map.fromEntries(ventasDash.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    for (var i in sortedByKeyMap.keys) {
      DateTime fecha = sortedByKeyMap[i]['fecha'];
      ventasGet.add(ChartData("${fechasName[i - 1]} - ${fecha.year}",
          sortedByKeyMap[i]['total'], fecha.month, fecha.year));
    }

    for (var i in instalacionesDash.keys) {
      DateTime fecha = instalacionesDash[i]['fecha'].toDate();
      if (instalacionesTotales.containsKey(fecha.day)) {
        instalacionesTotales[fecha.day]['total'] += 1;
      } else {
        instalacionesTotales.putIfAbsent(
            fecha.day, () => {"total": 1, "fecha": fecha});
      }
    }

    var sortedByKeyMap2 = Map.fromEntries(instalacionesTotales.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    for (var i in sortedByKeyMap2.keys) {
      DateTime fecha = sortedByKeyMap2[i]['fecha'];
      instalacionesData
          .add(ChartData2(fecha.day.toString(), sortedByKeyMap2[i]['total']));
    }

    inventarioGet.forEach((nombre, producto) {
      inventarioData.add(ChartData2(producto['nombre'], producto['cantidad']));
    });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width * 0.97,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      cardTopCantidad("Creditos Vencidos", vencidos, size),
                      cardTopMoney("Total Activos", totalA, size),
                      cardTopMoney("Total Inventario", totalInventario, size),
                      cardTopCantidad("Total Clientes", totalCorreos, size),
                      cardTopCantidad(
                          "Total Instalaciones", totalInstalaciones, size),
                    ],
                  ),
                ),
                Responsive.isMobile(context)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          comparativaW(size),
                          ventasAnio(size),
                          comparativaMes(size),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          comparativaW(size),
                          ventasAnio(size),
                          comparativaMes(size),
                        ],
                      ),
                Responsive.isMobile(context)
                    ? Column(
                        children: [
                          instalacionesMes(size),
                          inventarioMes(size),
                          comparativaMesAnio(size)
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          instalacionesMes(size),
                          inventarioMes(size),
                          comparativaMesAnio(size)
                        ],
                      )
              ],
            )),
        bottomNavigationBar:
            Responsive.isMobile(context) || Responsive.isTablet(context)
                ? BottomMenu(
                    setter: setState,
                    usuario: widget.usuario,
                    index: 0,
                  )
                : const SizedBox());
  }

  Widget comparativaMes(Size size) {
    return Card(
      elevation: 2,
      child: Container(
        width: Responsive.isDesktop(context) ? size.width * .3 : size.width,
        height: size.height * 0.4,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ventas del Mes",
              style: stylePrincipalBold(16, colorBlack),
            ),
            Text(
              "\$${f.format(totalMesActual)}",
              style: stylePrincipalBold(16, colorBlack),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.backward,
                  size: 15,
                  color: colorBlack,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "\$${f.format(totalMesPasado)}",
                  style: styleSecondary(11, colorBlack),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  porcentajeCambio < 0
                      ? LineIcons.arrowDown
                      : LineIcons.arrowUp,
                  size: 15,
                  color: porcentajeCambio < 0 ? color3 : color9,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "${f.format(porcentajeCambio)}%",
                  style: stylePrincipalBold(
                      18, porcentajeCambio < 0 ? color3 : color9),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget comparativaMesAnio(Size size) {
    return Card(
      elevation: 2,
      child: Container(
        width: Responsive.isDesktop(context) ? size.width * .3 : size.width,
        height: size.height * 0.4,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Comparativa con año pasado",
              style: stylePrincipalBold(16, colorBlack),
            ),
            Text(
              "\$${f.format(totalMesActual)}",
              style: stylePrincipalBold(16, colorBlack),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.backward,
                  size: 15,
                  color: colorBlack,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "\$${f.format(totalMesAnoPasado)}",
                  style: styleSecondary(11, colorBlack),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  porcentajeCambioanio < 0
                      ? LineIcons.arrowDown
                      : LineIcons.arrowUp,
                  size: 15,
                  color: porcentajeCambioanio < 0 ? color3 : color9,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "${f.format(porcentajeCambioanio)}%",
                  style: stylePrincipalBold(
                      18, porcentajeCambioanio < 0 ? color3 : color9),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget inventarioMes(Size size) {
    return Card(
      elevation: 2,
      child: Container(
          height: size.height * 0.38,
          width: Responsive.isMobile(context) ? size.width : size.width * 0.33,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: SfCartesianChart(
              plotAreaBorderColor: Colors.purple,
              plotAreaBorderWidth: 0,
              isTransposed: true,
              title: ChartTitle(
                  text:
                      "Top 15 Inventario del Mes ${fechasName[DateTime.now().month - 1]}",
                  textStyle: stylePrincipalBold(13, colorGrey)),
              series: <ChartSeries>[
                BarSeries<ChartData2, String>(
                    borderWidth: 0,
                    isTrackVisible: false,
                    color: color10,
                    borderRadius: BorderRadius.circular(15),
                    dataSource: inventarioData,
                    enableTooltip: true,
                    xValueMapper: (ChartData2 data, _) => data.xData,
                    yValueMapper: (ChartData2 data, _) => data.yData,
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: styleSecondary(9, colorBlack))),
              ],
              primaryXAxis: CategoryAxis(
                majorGridLines:
                    const MajorGridLines(width: 0), // Hide vertical gridlines
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines:
                    const MajorGridLines(width: 0), // Hide horizontal gridlines
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ))),
    );
  }

  Widget instalacionesMes(Size size) {
    return Card(
      elevation: 2,
      child: Container(
          height: size.height * 0.38,
          width: Responsive.isMobile(context) ? size.width : size.width * 0.33,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: SfCartesianChart(
              plotAreaBorderColor: Colors.purple,
              plotAreaBorderWidth: 0,
              isTransposed: false,
              title: ChartTitle(
                  text:
                      "Instalaciones del Mes ${fechasName[DateTime.now().month - 1]}",
                  textStyle: stylePrincipalBold(13, colorGrey)),
              series: <ChartSeries>[
                BarSeries<ChartData2, String>(
                    borderWidth: 0,
                    isTrackVisible: false,
                    color: color6,
                    borderRadius: BorderRadius.circular(15),
                    dataSource: instalacionesData,
                    enableTooltip: true,
                    xValueMapper: (ChartData2 data, _) => data.xData,
                    yValueMapper: (ChartData2 data, _) => data.yData,
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: styleSecondary(12, colorBlack))),
              ],
              primaryXAxis: CategoryAxis(
                majorGridLines:
                    const MajorGridLines(width: 0), // Hide vertical gridlines
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines:
                    const MajorGridLines(width: 0), // Hide horizontal gridlines
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ))),
    );
  }

  Widget ventasAnio(Size size) {
    return Card(
      elevation: 2,
      child: Container(
          height: size.height * 0.4,
          width: Responsive.isMobile(context) ? size.width : size.width * .33,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: SfCartesianChart(
            title: ChartTitle(
                text: 'Ventas del año ${DateTime.now().year}',
                textStyle: stylePrincipalBold(13, colorOrangLiU)),
            primaryXAxis: CategoryAxis(
              axisLine: const AxisLine(width: 0),
              majorGridLines:
                  const MajorGridLines(width: 0), // Hide horizontal gridlines
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            enableAxisAnimation: true,
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<ChartData, String>(
                dataSource: ventasGet,
                xValueMapper: (ChartData sales, _) => sales.month,
                yValueMapper: (ChartData sales, _) => sales.monto,
                dataLabelMapper: (ChartData sales, _) =>
                    '\$${f.format(sales.monto)}',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                width: 2,
                markerSettings: const MarkerSettings(isVisible: true),
                color: colorOrangLiU,
              )
            ],
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              majorGridLines:
                  const MajorGridLines(width: 0), // Hide horizontal gridlines
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
          )),
    );
  }

  Widget comparativaW(Size size) {
    return Card(
      elevation: 2,
      child: Container(
        height: size.height * 0.4,
        width: Responsive.isMobile(context) ? size.width : size.width * 0.33,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: SfCircularChart(
            palette: <Color>[
              color1,
              color2,
              color3,
              color4,
              color5,
              color6,
              color7,
              color8,
              color9,
              color10,
            ],
            title: ChartTitle(
                text: 'Gastos vs Compras vs Ventas',
                textStyle: stylePrincipalBold(13, colorOrangLiU)),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.right,
              toggleSeriesVisibility: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <PieSeries<_PieData, String>>[
              PieSeries<_PieData, String>(
                  strokeColor: colorBlack,
                  explode: true,
                  explodeIndex: 0,
                  dataSource: comparativa,
                  xValueMapper: (_PieData data, _) => data.xData,
                  yValueMapper: (_PieData data, _) => data.yData,
                  dataLabelMapper: (_PieData data, _) => data.text,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  )),
            ]),
      ),
    );
  }

  Widget cardTopMoney(String title, dynamic money, Size size) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 10),
      child: Container(
          height: size.height * 0.1,
          width: Responsive.isMobile(context)
              ? size.width * 0.3
              : size.width * 0.15,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: styleSecondary(
                    Responsive.isMobile(context) ? 12 : 13, colorGrey),
              ),
              Text(
                "\$${f.format(money)}",
                style: stylePrincipalBold(
                    Responsive.isMobile(context) ? 13 : 16, colorBlack),
              )
            ],
          )),
    );
  }

  Widget cardTopCantidad(String title, dynamic money, Size size) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 10),
      child: Container(
          height: size.height * 0.1,
          width: Responsive.isMobile(context)
              ? size.width * 0.3
              : size.width * 0.15,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: styleSecondary(13, colorGrey),
              ),
              Text(
                f.format(money).toString(),
                style: stylePrincipalBold(16, colorBlack),
              )
            ],
          )),
    );
  }
}

class ChartData {
  ChartData(this.month, this.monto, this.mes, this.anio);
  final String month;
  double monto;
  int mes;
  int anio;
}

class _PieData {
  _PieData(
    this.xData,
    this.yData,
    this.text,
  );
  final String xData;
  final num yData;
  final String text;
}

class ChartData2 {
  ChartData2(
    this.xData,
    this.yData,
  );
  final String xData;
  final dynamic yData;
}
