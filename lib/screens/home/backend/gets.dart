// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../dashboard/dashboard.dart';

getVentasDash(StateSetter setter) {
  FirebaseFirestore.instance.collection("ventas").snapshots().listen((result) {
    totalVentas = 0;
    result.docs.forEach((result) {
      setter(() {
        totalVentas += result.data()['total'];
      });
    });
  });
}

getVentasAnio(StateSetter setter) {
  FirebaseFirestore.instance.collection("ventas").snapshots().listen((result) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    result.docs.forEach((result) {
      DateTime ventaDate = result.data()['fecha'].toDate();
      if (ventaDate.year == currentYear) {
        setter(() {
          ventas.putIfAbsent(result.id, () => result.data());
        });
      }
    });
  });
}

getVentasComparativas() {
  FirebaseFirestore.instance.collection("ventas").snapshots().listen((result) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    Map<String, dynamic> ventasMesActual = {};
    Map<String, dynamic> ventasMesPasado = {};
    Map<String, dynamic> ventasMesAnoPasado = {};

    result.docs.forEach((result) {
      DateTime ventaDate = result.data()['fecha'].toDate();

      if (ventaDate.year == currentYear && ventaDate.month == currentMonth) {
        ventasMesActual.putIfAbsent(result.id, () => result.data());
      }

      int mesPasado = currentMonth - 1;
      int yearPasado = currentYear;

      // Ajustar la lógica para obtener el mes del año pasado
      if (mesPasado == 0) {
        mesPasado = 12;
        yearPasado = now.year - 1;
      }

      if (ventaDate.year == yearPasado && ventaDate.month == mesPasado) {
        ventasMesPasado.putIfAbsent(result.id, () => result.data());
      }

      // Calcular el mes del año pasado
      if (ventaDate.year == yearPasado && ventaDate.month == currentMonth) {
        ventasMesAnoPasado.putIfAbsent(result.id, () => result.data());
      }
    });

    // Calcular los totales después de iterar sobre los resultados
    totalMesActual =
        ventasMesActual.values.fold(0, (sum, venta) => sum + venta['total']);
    totalMesPasado =
        ventasMesPasado.values.fold(0, (sum, venta) => sum + venta['total']);
    totalMesAnoPasado =
        ventasMesAnoPasado.values.fold(0, (sum, venta) => sum + venta['total']);
    // Calcular el porcentaje de camb io
    porcentajeCambio =
        ((totalMesActual - totalMesPasado) / totalMesPasado) * 100;
    porcentajeCambioanio =
        ((totalMesActual - totalMesAnoPasado) / totalMesAnoPasado) * 100;
  });
}

getInstalacionesMes(StateSetter setter) {
  FirebaseFirestore.instance
      .collection("instalaciones")
      .snapshots()
      .listen((result) {
    DateTime now = DateTime.now();
    int currentMont = now.month;
    int currentYear = now.year;
    totalInstalaciones = 0;
    result.docs.forEach((result) {
      totalInstalaciones += 1;
      DateTime ventaDate = result.data()['fecha'].toDate();
      if (ventaDate.year == currentYear && ventaDate.month == currentMont) {
        setter(() {
          instalacionesDash.putIfAbsent(result.id, () => result.data());
        });
      }
    });
  });
}

getComprasDash(StateSetter setter) {
  FirebaseFirestore.instance.collection("compras").snapshots().listen((result) {
    totalCompras = 0;
    result.docs.forEach((result) {
      setter(() {
        totalCompras += result.data()['total'];
      });
    });
  });
}

getGastosDash(StateSetter setter) {
  FirebaseFirestore.instance
      .collection("gastos_caja")
      .snapshots()
      .listen((result) {
    totalGastos = 0;
    result.docs.forEach((result) {
      setter(() {
        totalGastos += result.data()['cantidad'];
      });
    });
  });
}

getCorreos(StateSetter setter) {
  FirebaseFirestore.instance.collection("correos").snapshots().listen((result) {
    totalCorreos = 0;
    result.docs.forEach((result) {
      setter(() {
        totalCorreos += 1;
      });
    });
  });
}

void getInventario(StateSetter setter) {
  FirebaseFirestore.instance
      .collection("inventario")
      .snapshots()
      .listen((result) {
    List<Map<String, dynamic>> inventarioList = [];

    result.docs.forEach((result) {
      if (!inventarioList
          .any((element) => element['nombre'] == result.data()['nombre'])) {
        inventarioList.add(result.data());
      }
    });

    inventarioList.sort((a, b) => b['cantidad'].compareTo(a['cantidad']));

    List<Map<String, dynamic>> top15Productos =
        inventarioList.take(15).toList();

    top15Productos.forEach((producto) {
      inventarioGet.putIfAbsent(producto['nombre'], () => producto);
    });
    inventarioGet.forEach((nombre, producto) {
      totalInventario += producto['cantidad'] * producto['compra'];
    });
    setter(() {});
  });
}
