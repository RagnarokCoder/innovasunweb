// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:innovasun/screens/maps/maps.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:intl/intl.dart';
import 'package:universal_html/html.dart';

import '../../../constants/vars/vars.dart';

Future<void> sanfrancisco(StateSetter setter, var i) async {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  //Draw rectangle

  //Generate PDF grid.
  final PdfGrid grid = getGrid();

  //Draw the header section by creating text element
  final PdfLayoutResult result = drawHeader(page, pageSize, grid, i);
  http.Response response = await http.get(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/cmotion.appspot.com/o/LOGO-3.png?alt=media&token=f3e247a2-d948-4f71-90c9-aa3e0fdc9d08&_gl=1*1030ez4*_ga*NjE3MjcxMTM0LjE2NzU3OTQwODk.*_ga_CW55HF8NVT*MTY5NzU4NjA5OS4zMzQuMS4xNjk3NTg2MTEzLjQ2LjAuMA.."),
  );
  final List<int> imageData = response.bodyBytes;
//Load the image using PdfBitmap.
  final PdfBitmap image = PdfBitmap(imageData);
//Draw the image to the PDF page.
  page.graphics.drawImage(image, const Rect.fromLTWH(10, 0, 110, 80));
  //Draw grid
  //drawGrid(page, grid, result);
  //Add invoice footer
  drawFooter(page, pageSize);
  //Save the PDF document
  final List<int> bytes = document.saveSync();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  await saveAndLaunchFile(bytes, 'sanfrancisco.pdf');
  setter(() {});
}

//Draws the invoice header
PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid, var i) {
  //Draw rectangle

  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
  final PdfFont title =
      PdfStandardFont(PdfFontFamily.helvetica, 7.5, style: PdfFontStyle.bold);
  final PdfFont title1 =
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);
  final PdfFont contentFontN =
      PdfStandardFont(PdfFontFamily.helvetica, 13, style: PdfFontStyle.bold);
  //Draw string
  page.graphics.drawString(
      '''CONTRATO No.: ${instalaciones[i]['cliente']} \n\nMEJORAMIENTO DE VIVIENDA (PROGRAMA DE SUMINISTRO Y COLOCACIÓN DE CALENTADORES\nSOLARES) EN CABECERA MUICIPAL\n\nEste programa es publico, ajeno a cualquier partido politico, queda prohibido el uso para fines distintos a los establecidos en el programa''',
      title,
      brush: PdfBrushes.black,
      bounds: const Rect.fromLTWH(120, 5, 385, 75),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  page.graphics.drawString(
      '''Folio:            ${instalaciones[i]['folio']}''', title1,
      brush: PdfBrushes.black,
      bounds: const Rect.fromLTWH(420, 50, 300, 55),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  String datosPago = "ACTA ENTREGA RECEPCIÓN DEL BENEFICIARIO";
  String creacion = DateFormat('dd-MM-yyyy').format(DateTime.now());
  const String detalle2 =
      '''RECIBI CALENTADOR SOLAR DE 12 TUBOS DE 150 LTS. SE INSTALO CORRECTAMENTE Y A MI ENTERA\n SATISFACCION QUEDO FUNCIONANDO ADECUADAMENTE, TAMBIEN ME FUE ENTREGADA LA POLIZA DE\n GARANTIA POR 5 AÑOS, MANUAL DEL BUEN USO, CUIDADOS QUE SE DEBE DE TENER CON EL CALENTADOR\n SOLAR Y EL CALENDARIO PARA LA PROGRAMACION DE LOS MANTENIMIENTOS. Y ME COMPROMETO A\n SEGUIR LO INDICADO EN EL MANUAL PARA ASEGURAR EL BUEN FUNCIONAMIENTO DEL CALENTADOR SOLAR.''';
  final Size contentSize = contentFont.measureString(datosPago);
  // ignore: leading_newlines_in_multiline_strings
  String detalleProveedor =
      '''NOMBRE:              ${instalaciones[i]['nombre']}\nCOLONIA:              ${instalaciones[i]['comunidad']}\nNUMERO:              ${instalaciones[i]['numero']}\nDOMICILIO:           ${instalaciones[i]['direccion']}\nCURP:              ''';

  String observaciones = 'DIRECCIÓN DE INFRAESTRUCTURA SFR\nFIRMA';

  String firma2 = 'DIRECCIÓN DE DESARROLLO SOCIAL Y HUMANO\nFIRMA';
  String firma3 =
      '${instalaciones[i]['nombre'].toString().toUpperCase()}\nFIRMA';
  String firma4 = 'CONTRATISTA\nFIRMA';

  PdfTextElement(text: datosPago, font: contentFontN).draw(
      page: page,
      bounds: Rect.fromLTWH(115, 120,
          pageSize.width - (contentSize.width + 400), pageSize.height - 120))!;

  PdfTextElement(
      text: detalle2,
      font: title1,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      )).draw(
    page: page,
    bounds: Rect.fromLTWH(10, 240, 500, pageSize.height - 120),
  )!;

  PdfTextElement(
      text: observaciones,
      font: title,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      )).draw(
    page: page,
    bounds: Rect.fromLTWH(25, 440, 200, pageSize.height - 120),
  )!;
  PdfTextElement(
      text: firma2,
      font: title,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      )).draw(
    page: page,
    bounds: Rect.fromLTWH(280, 440, 200, pageSize.height - 120),
  )!;

  PdfTextElement(
      text: firma3,
      font: title,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      )).draw(
    page: page,
    bounds: Rect.fromLTWH(25, 550, 200, pageSize.height - 120),
  )!;
  PdfTextElement(
      text: firma4,
      font: title,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      )).draw(
    page: page,
    bounds: Rect.fromLTWH(280, 550, 200, pageSize.height - 120),
  )!;

  return PdfTextElement(text: detalleProveedor, font: contentFont).draw(
      page: page, bounds: Rect.fromLTWH(50, 160, 400, pageSize.height - 120))!;
}

//Draws the grid
Future<void> drawGrid(
    PdfPage page, PdfGrid grid, PdfLayoutResult result) async {
  Rect? totalPriceCellBounds;
  Rect? quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 100, 0, 0))!;

  //Draw grand total.
}

//Draw the invoice footer data.
void drawFooter(PdfPage page, Size pageSize) {
  final PdfPen linePen =
      PdfPen(PdfColor(13, 125, 78), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line

  const String footerContent =
      // ignore: leading_newlines_in_multiline_strings
      '''''';

  //Added 30 as a margin for the layout
  page.graphics.drawString(
      footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}

//Create PDF grid and return
PdfGrid getGrid() {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 3);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(13, 125, 78));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Descripción';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Unidad';
  headerRow.cells[2].value = 'Precio';
  //Add rows
  Map<dynamic, dynamic> productos = {};
  //productos = getDocument['0']['productos'] as Map;

  for (var i in productos.keys) {
    addProducts(productos[i]['descripcion'], productos[i]['unidad'],
        productos[i]['precio'], grid);
  }

  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable1Light);
  //Set gird columns width
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void addProducts(
    String descripcion, String unidad, dynamic precio, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = descripcion;
  row.cells[1].value = unidad;
  row.cells[2].value = f.format(precio).toString();
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    ..setAttribute('download', fileName)
    ..click();
}
