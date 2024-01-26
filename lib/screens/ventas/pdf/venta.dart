// ignore_for_file: avoid_web_libraries_in_flutter, unused_local_variable, unnecessary_string_interpolations, unnecessary_null_comparison, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart';
import '../../../constants/vars/vars.dart';
import '../backend/subir_ventas.dart';

Future<void> generateVenta(StateSetter setter, bool isVenta) async {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(232, 91, 12)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid();

  //Draw the header section by creating text element
  final PdfLayoutResult result = drawHeader(page, pageSize, grid, isVenta);
  http.Response response = await http.get(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/cmotion.appspot.com/o/logo-2.png?alt=media&token=6f6fce82-7c37-429f-8259-9b3d59b76563&_gl=1*yoqk6i*_ga*NjE3MjcxMTM0LjE2NzU3OTQwODk.*_ga_CW55HF8NVT*MTY5NTg3MDgyMi4zMTAuMS4xNjk1ODcwOTM1LjQ3LjAuMA.."),
  );
  final List<int> imageData = response.bodyBytes;
//Load the image using PdfBitmap.
  final PdfBitmap image = PdfBitmap(imageData);
//Draw the image to the PDF page.
  page.graphics.drawImage(image, const Rect.fromLTWH(30, 10, 130, 30));
  //Draw grid
  drawGrid(page, grid, result);
  //Add invoice footer
  drawFooter(page, pageSize);
  //Save the PDF document
  final List<int> bytes = document.saveSync();
  //Dispose the document.
  document.dispose();
  //Save and launch the file.
  await saveAndLaunchFile(
      bytes, isVenta == true ? 'venta.pdf' : 'cotizacion.pdf');
  setter(() {
    //isPdfLoding = false;
  });
}

//Draws the invoice header
PdfLayoutResult drawHeader(
    PdfPage page, Size pageSize, PdfGrid grid, bool isVenta) {
  //Draw rectangle

  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

  final PdfFont obv = PdfStandardFont(PdfFontFamily.helvetica, 12);
  final PdfFont title =
      PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold);
  final PdfFont contentFontN =
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);
  //Draw string
  page.graphics.drawString(
      isVenta == true ? '''Ticket de Compra''' : '''Cotización''', title,
      brush: PdfBrushes.black,
      bounds: const Rect.fromLTWH(380, 0, 200, 55),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  String creacion = DateFormat('dd-MM-yyyy').format(createVenta['fecha']);
  const String detalle2 = "";
  final Size contentSize = contentFont.measureString(detalle2);
  // ignore: leading_newlines_in_multiline_strings

  String staticText = "Codigo: ";
  String variableText = '${createVenta['uuid']}';
  final PdfTextElement staticElement = PdfTextElement(
    text: staticText,
    font: contentFontN,
  );

  final PdfTextElement variableElement = PdfTextElement(
    text: variableText,
    font: contentFont,
  );

  // Draw the PdfTextElements on the page
  staticElement.draw(
    page: page,
    bounds: Rect.fromLTWH(30, 100, pageSize.width - (contentSize.width + 30),
        pageSize.height - 120),
  );

  variableElement.draw(
    page: page,
    bounds: Rect.fromLTWH(70, 100, pageSize.width - (contentSize.width + 30),
        pageSize.height - 120),
  );
  String fechast = "Fecha: ";
  String fechava = creacion;
  final PdfTextElement fechasta = PdfTextElement(
    text: fechast,
    font: contentFontN,
  );

  final PdfTextElement fechavar = PdfTextElement(
    text: fechava,
    font: contentFont,
  );

  // Draw the PdfTextElements on the page
  fechasta.draw(
    page: page,
    bounds: Rect.fromLTWH(30, 110, pageSize.width - (contentSize.width + 30),
        pageSize.height - 120),
  );

  fechavar.draw(
    page: page,
    bounds: Rect.fromLTWH(60, 110, pageSize.width - (contentSize.width + 30),
        pageSize.height - 120),
  );

  String noproveedor = "Comprador: ";
  String noproovedorv = "${createVenta['comprador']}";
  final PdfTextElement noprovsa = PdfTextElement(
    text: noproveedor,
    font: contentFontN,
  );

  final PdfTextElement nprovva = PdfTextElement(
    text: noproovedorv,
    font: contentFont,
  );

  // Draw the PdfTextElements on the page
  noprovsa.draw(
    page: page,
    bounds: Rect.fromLTWH(30, 120, pageSize.width - (contentSize.width + 30),
        pageSize.height - 120),
  );

  nprovva.draw(
    page: page,
    bounds: Rect.fromLTWH(95, 120, pageSize.width - (contentSize.width + 30),
        pageSize.height - 120),
  );

  /*PdfTextElement(text: detalle2, font: contentFontN).draw(
      page: page, bounds: Rect.fromLTWH(310, 110, 200, pageSize.height - 120));*/

  return PdfTextElement(text: "", font: contentFontN).draw(
      page: page, bounds: Rect.fromLTWH(30, 120, 500, pageSize.height - 120))!;
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
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 70, 0, 0))!;

  //Draw grand total.
  page.graphics.drawString('Subtotal: ',
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10,
          quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(
      createVenta['isIva'] == true
          ? "\$${f.format((total / 1.16))}"
          : "\$${f.format((total))}",
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 10,
          totalPriceCellBounds!.width,
          totalPriceCellBounds!.height));
  page.graphics.drawString(createVenta['isIva'] == true ? 'Iva: ' : '',
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 20,
          quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(
      createVenta['isIva'] == true ? "\$${f.format((total * .16))}" : "",
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 20,
          totalPriceCellBounds!.width,
          totalPriceCellBounds!.height));
  page.graphics.drawString('Total: ',
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 30,
          quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(
      createVenta['isIva'] == true
          ? "\$${f.format((total))}"
          : "\$${f.format((total))}",
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 30,
          totalPriceCellBounds!.width,
          totalPriceCellBounds!.height));
}

//Draw the invoice footer data.
void drawFooter(PdfPage page, Size pageSize) {
  final PdfPen linePen =
      PdfPen(PdfColor(232, 91, 12), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));

  const String footerContent =
      // ignore: leading_newlines_in_multiline_strings
      '''Carr. San Fco. / León Km 5 Camino a gala y a serdan #9 cañada de\nsotos Tels: 477 649 09 41 y 476 132 2810\n36416 Purisima del Rincon Gto.''';

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
  grid.columns.add(count: 4);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(232, 91, 12));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Produco';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Cantidad';
  headerRow.cells[2].value = 'Precio';
  headerRow.cells[2].value = 'Subtotal';
  //Add rows
  Map<dynamic, dynamic> productos = {};
  productos = createVenta['carrito'] as Map;
  debugPrint(productos.toString());
  for (var i in productos.keys) {
    addProducts(productos[i]['nombre'], productos[i]['cantidad'],
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
    String descripcion, dynamic unidad, dynamic precio, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = descripcion;
  row.cells[1].value = unidad.toString();
  row.cells[2].value = "\$${f.format(precio)}";
  row.cells[3].value = "\$${f.format(precio * unidad)}";
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    ..setAttribute('download', fileName)
    ..click();
}
