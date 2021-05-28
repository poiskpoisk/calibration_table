import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int rpm = 51;
const int turbo = 39;
const String manifest = 'T/R';

List<int> rpmScale = [for (int i = 500; i < 500 + rpm * 100; i += 100) i];
List<int> turboScale = [for (int i = 1000; i < 1000 + turbo * 100; i += 100) i];

List<List<int>> calibration = List.filled(turbo, [for (var i = 0; i < rpm; i += 1) i * 3]);

List<DataColumn> rpmHeader =
    [DataColumn(label: Text(manifest, textAlign: TextAlign.right))] + [for (int item in rpmScale) DataColumn(label: Text(item.toString()))] + [DataColumn(label: Text(manifest))];



List<DataRow> getRowsTurbo() {

  List<DataRow> turboRows = [];
  double columnWidth = 35.2;

  for (int row = 0; row < turboScale.length; row++) {
    turboRows.add(DataRow(
        cells: [
              DataCell(Container(
                  //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  width: columnWidth,
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Text(turboScale[row].toString(), style: TextStyle(fontWeight: FontWeight.bold))))
            ] +
            [
              for (int item in calibration[row])
                DataCell(Container(
                    width: columnWidth, //SET width
                    alignment: Alignment.center,
                    child:
                        TextFormField(
                            initialValue: item.toString(),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            textAlignVertical: TextAlignVertical.center,
                            //decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(10))),
                            //maxLength: 3,
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              // ignore: unrelated_type_equality_checks
                              if (value == 0) {
                                print('777');
                                return 'Please enter some text';
                              }
                              print('jjj');
                              return null;},
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (val) {
                             print(val);
                          },
                        ),
                ))
            ] +
            [
              DataCell(Container(
                //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  width: columnWidth,
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Text(turboScale[row].toString(), style: TextStyle(fontWeight: FontWeight.bold))))
            ]
    ));
  }
  turboRows.add(DataRow(
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
          ]
          ));
  return turboRows;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Table',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyDataTable(title: 'Flutter DataTable Page'),
    );
  }
}

class MyDataTable extends StatefulWidget {
  MyDataTable({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
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
