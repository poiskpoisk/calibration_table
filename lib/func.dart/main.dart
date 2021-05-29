import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int rpm = 20;
const int turbo = 20;
const String manifest = 'T/R';

List<int> rpmScale = [for (int i = 500; i < 500 + rpm * 100; i += 100) i];
List<int> turboScale = [for (int i = 1000; i < 1000 + turbo * 100; i += 100) i];

List<List<int>> calibration = List.filled(turbo, [for (var i = 0; i < rpm; i += 1) i * 3]);

List<DataColumn> rpmHeader = [DataColumn(label: Text(manifest, textAlign: TextAlign.right))] +
    [for (int item in rpmScale) DataColumn(label: Text(item.toString()))] +
    [DataColumn(label: Text(manifest))];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Table',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: CalTable(title: 'Calibration table ( x:RPM, y:Turbo )', maxValue: 255),
    );
  }
}

class CalTable extends StatefulWidget {
  // Constructor with initializer ( : )
  CalTable({Key key, this.title, this.maxValue}) : super(key: key);

  final String title;
  final int maxValue; // Maximum value allowed for this calibration table

  @override
  _CalTableState createState() => _CalTableState(this.maxValue);
}

class _CalTableState extends State<CalTable> {
  _CalTableState(this.maxValue) : super();

  final int maxValue; // Maximum value allowed for this calibration table

  List<DataRow> getRowsTurbo() {
    // Формирует список строк, для представления в таблице

    List<DataRow> turboRows = [];
    double columnWidth = 35.2;

    List<DataCell> getCellsCore(int row) {

      DataCell getDataCell(int item) {
        TextEditingController cellController = TextEditingController(text: item.toString());

        return DataCell(Container(
          width: columnWidth, //SET width
          alignment: Alignment.center,
          child: TextField(
            controller: cellController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlignVertical: TextAlignVertical.center,
            autofocus: false, // Коггда таблица стартует, не одна ячейка не будет выбрана для редактирования
            //decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(10))),
            keyboardType: TextInputType.number,
            onSubmitted: (val) {
              if (int.parse(val) > this.maxValue) {
                cellController.text = this.maxValue.toString();
              }
            },
          ),
        ));
      }

      return ([
            // ignore: unnecessary_statements
            DataCell(Container(
                // Первая вертикальная синяя полоса Turbo, без возможности ввода
                width: columnWidth,
                alignment: Alignment.center,
                color: Colors.blue,
                child: Text(turboScale[row].toString(), style: TextStyle(fontWeight: FontWeight.bold))))
          ] +
          [for (int item in calibration[row]) getDataCell(item)] +
          [
            DataCell(Container(
                // Вторая вертикальная синяя полоса Turbo, без возможности ввода
                width: columnWidth,
                alignment: Alignment.center,
                color: Colors.blue,
                child: Text(turboScale[row].toString(), style: TextStyle(fontWeight: FontWeight.bold))))
          ]);
    }

    for (int row = 0; row < turboScale.length; row++) { turboRows.add(DataRow(cells: getCellsCore(row)));}
    turboRows.add(DataRow(

        // Нижняя синяя строчкс
        cells: [
              DataCell(Container(
                  //padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: columnWidth,
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Text(manifest, style: TextStyle(fontWeight: FontWeight.bold))))
            ] +
            [
              for (int item in rpmScale)
                DataCell(Container(
                    //padding: EdgeInsets.fromLTRB(15,0,15,0),
                    width: columnWidth,
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Text(item.toString(), style: TextStyle(fontWeight: FontWeight.bold))))
            ] +
            [
              DataCell(Container(
                  //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  width: columnWidth,
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Text(manifest, style: TextStyle(fontWeight: FontWeight.bold))))
            ]));
    return turboRows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: InteractiveViewer(
            // Масштабирование и прокручивание в 2-х направлениях 2 пальцами
            alignPanAxis: true, // Масштабирование только по осям X и Y
            constrained: false, // Позволять двигать таблицу при 100% масштабе
            minScale: 0.5,
            maxScale: 2,

            //padding: const EdgeInsets.all(8.0),
            child: DataTable(
                columns: rpmHeader,
                headingRowColor: MaterialStateProperty.all(Colors.blue),
                headingRowHeight: 26,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                dataRowHeight: 22.5,
                columnSpacing: 0,
                dividerThickness: 1.5,
                showBottomBorder: true,
                horizontalMargin: 0,
                rows: getRowsTurbo())),
      ),
    );
  }
}
