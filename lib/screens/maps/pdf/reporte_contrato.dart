// ignore_for_file: depend_on_referenced_packages, unused_import, unused_local_variable

import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:innovasun/screens/maps/components/modal_fechas.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart';
import '../../../constants/vars/vars.dart';
import '../components/pick_contrato.dart';

dynamic total = 0;
Future<void> reporteContrato(Size size) async {
  total = 0;
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(192, 182, 170)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid(size);

  //Draw the header section by creating text element
  final PdfLayoutResult? result = drawHeader(page, pageSize, grid);
  //Draw grid
  drawGrid(page, grid, result!);
  //Save the PDF document
  final List<int> bytes = document.saveSync();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  await saveAndLaunchFile(bytes, 'reporteInstalacione.pdf');
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    ..setAttribute('download', fileName)
    ..click();
}

//Draws the invoice header
PdfLayoutResult? drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(232, 91, 12)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 60));
  //Draw string
  page.graphics.drawString(
      titulo.text, PdfStandardFont(PdfFontFamily.helvetica, 22),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 60),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(232, 91, 12)));

  page.graphics.drawString(
      "Instalaciones", PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.white,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle));

  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
  final PdfFont contentN =
      PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
  final PdfFont contentN2 =
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);

  //Draw string
  page.graphics.drawString('Tipo de reporte', contentFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  String invoiceNumber = '\r\n\rFecha: ${format.format(DateTime.now())}';
  final Size contentSize = contentFont.measureString(invoiceNumber);
  // ignore: leading_newlines_in_multiline_strings
  String nombre = '''''';
  String footerContent =
      // ignore: leading_newlines_in_multiline_strings
      '''''';
  for (var i in instalacionesPdf.keys) {
    total += (instalacionesPdf[i]['cantidad']);
  }
  String monedaS =
      ''' \r\n\r Reporte de instalaciones de $userSelect\nTotal: ${f.format(total)}''';

  PdfTextElement(text: invoiceNumber, font: contentN2).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));
  PdfTextElement(text: nombre, font: contentN).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 110, pageSize.width - (contentSize.width + 20),
          pageSize.height - 120));

  PdfTextElement(
          text: footerContent, brush: PdfBrushes.white, font: contentFont)
      .draw(page: page, bounds: const Rect.fromLTRB(30, 65, 400, 0));

  return PdfTextElement(text: monedaS, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 130, pageSize.width - (contentSize.width + 100),
          pageSize.height - 120));
}

//Draws the grid
void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
  Rect totalPriceCellBounds;
  Rect quantityCellBounds;
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
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 50, 0, 0))!;

  //Draw grand total.
}

//Create PDF grid and return
PdfGrid getGrid(Size size) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 8);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(232, 91, 12));
  headerRow.style.textBrush = PdfBrushes.white;

  headerRow.cells[0].value = 'Cliente';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Estado';
  headerRow.cells[2].value = 'Comunidad';
  headerRow.cells[3].value = 'Nombre';
  headerRow.cells[4].value = 'Dirección';
  headerRow.cells[5].value = 'Cantidad';
  headerRow.cells[6].value = 'Fecha';
  headerRow.cells[7].value = 'Instalador';

  final sortedKeysDesc = SplayTreeMap<String, dynamic>.from(
      instalacionesPdf, (keys2, keys1) => keys2.compareTo(keys1));
  //Add rows
  for (var i in instalacionesPdf.keys) {
    addProducts(
        i,
        sortedKeysDesc[i]['cliente'],
        sortedKeysDesc[i]['estado'],
        sortedKeysDesc[i]['comunidad'],
        sortedKeysDesc[i]['nombre'],
        sortedKeysDesc[i]['direccion'] ?? "",
        sortedKeysDesc[i]['cantidad'],
        sortedKeysDesc[i]['fecha'].toDate(),
        sortedKeysDesc[i]['usuario'],
        grid);
  }

  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable2);
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
      cell.style.backgroundBrush = PdfSolidBrush(PdfColor(255, 255, 255));
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void addProducts(
  var i,
  String cliente,
  estado,
  comunidad,
  nombre,
  direccion,
  dynamic cantidad,
  DateTime fecha,
  String usuario,
  PdfGrid grid,
) {
  final PdfGridRow row = grid.rows.add();

  row.cells[0].value = cliente;
  row.cells[1].value = estado;
  row.cells[2].value = comunidad;
  row.cells[3].value = nombre;
  row.cells[4].value = direccion;
  row.cells[5].value = cantidad.toString();
  row.cells[6].value = fecha.toString().split(' ')[0];
  row.cells[7].value = usuario;
}
