import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsi_ba_parkir_desktop/app/routes/app_pages.dart';

import '../controllers/parking_visitor_controller.dart';

class ParkingVisitorView extends GetView<ParkingVisitorController> {
  const ParkingVisitorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengunjung Parkir'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: controller.getParkingData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var parkingData = snapshot.data!.docs;
            parkingData.sort((a, b) {
              var entryTimeA = DateTime.parse(a['entryTime']);
              var entryTimeB = DateTime.parse(b['entryTime']);
              return entryTimeB.compareTo(entryTimeA);
            });

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 3,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Obx(() {
                          return PaginatedDataTable(
                            showCheckboxColumn: false,
                            rowsPerPage: 10,
                            columns: [
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    'No',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text('Nama',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text('Nomor HP',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text('Plat',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text('Kendaraan',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              DataColumn(
                                tooltip: 'Klik untuk ubah status',
                                onSort: (columnIndex, ascending) {
                                  // Panggil fungsi sorting di sini
                                  // Contoh: controller.sortByStatus(ascending);
                                },
                                numeric: false,
                                label: InkWell(
                                  onTap: () {
                                    // Tampilkan dialog pilihan
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Pilih Status'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('Masuk'),
                                                onTap: () {
                                                  controller
                                                      .changeStatusAndFilter(
                                                          'Masuk');
                                                  Navigator.pop(
                                                      context, 'Masuk');
                                                },
                                              ),
                                              ListTile(
                                                title: Text('Keluar'),
                                                onTap: () {
                                                  controller
                                                      .changeStatusAndFilter(
                                                          'Keluar');
                                                  Navigator.pop(
                                                      context, 'Keluar');
                                                },
                                              ),
                                              ListTile(
                                                title: Text('Semua'),
                                                onTap: () {
                                                  controller
                                                      .changeStatusAndFilter(
                                                          'Semua');
                                                  Navigator.pop(
                                                      context, 'Semua');
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text('Status',
                                          style: TextStyle(fontSize: 18)),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.sort,
                                        color: Colors
                                            .blue, // Sesuaikan warna ikon sorting
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text('Masuk',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text('Keluar',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            ],
                            // Pass the filtered data to the source
                            source: ParkingDataDataTableSource(
                              _filteredParkingData(parkingData),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Helper function to filter parking data based on the selected filter
  List<DocumentSnapshot> _filteredParkingData(List<DocumentSnapshot> data) {
    if (controller.filter.value == 'Semua') {
      return data;
    } else {
      return data
          .where(
            (snapshot) => snapshot['status'] == controller.filter.value,
          )
          .toList();
    }
  }
}

class ParkingDataDataTableSource extends DataTableSource {
  final List<DocumentSnapshot> _parkingData;

  ParkingDataDataTableSource(this._parkingData);

  @override
  DataRow getRow(int index) {
    var rowData = _parkingData[index].data() as Map<String, dynamic>;
    var status = rowData['status'];
    var bgColor = status == 'Masuk' ? Colors.yellow : Colors.green;

    return DataRow(
      color: MaterialStateColor.resolveWith(
          (states) => bgColor.withOpacity(0.3) ?? Colors.transparent),
      cells: [
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text('${index + 1}'), // Tambahkan 1 ke indeks
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => Get.toNamed(
              Routes.parkingDetail,
              arguments: rowData,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              child: Text(rowData['name'] ?? ''),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text(rowData['phone'] ?? ''),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text(rowData['plate'] ?? '-'),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text(rowData['vehicle'] ?? '-'),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text(rowData['status'] ?? '-'),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text(entryTimeFormatter(rowData['entryTime'] ?? '')),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Text(
              rowData['exitTime'] != null
                  ? entryTimeFormatter(rowData['exitTime'])
                  : '-',
            ),
          ),
        ),
      ],
      // onSelectChanged: (isSelected) {
      //   // Handle row selection
      //   if (isSelected != null && isSelected) {
      //     // Handle the row click event
      //     print('Clicked row ${index + 1}');
      //     print('Name: ${rowData['name']}');
      //     // Add other fields as needed
      //   }
      // },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _parkingData.length;

  @override
  int get selectedRowCount => 0;
}

String entryTimeFormatter(String entryTime) {
  var parsedEntryTime = DateTime.parse(entryTime);
  return "${parsedEntryTime.day}/${parsedEntryTime.month}/${parsedEntryTime.year} ${parsedEntryTime.hour}:${parsedEntryTime.minute}:${parsedEntryTime.second}";
}
