// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/government/crimes/details.dart';
import 'package:ihuriro/screens/government/map/view.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class ListReportedCrimes extends StatefulWidget {
  const ListReportedCrimes({super.key});

  @override
  State<ListReportedCrimes> createState() => _ListReportedCrimesState();
}

class _ListReportedCrimesState extends State<ListReportedCrimes> {
  bool _loading = true, _generatingReport = false;

  List<Map<String, dynamic>> _allReported = [];

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(governmentReportedURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> decodedReporteds = decodedResponse['reported'];
      final List<Map<String, dynamic>> reporteds =
          List<Map<String, dynamic>>.from(decodedReporteds);
      setState(() {
        _allReported = reporteds;
        _loading = false;
      });
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> generateReport() async {
    generateAndSavePdf(_allReported);
  }

  void generateAndSavePdf(List<Map<String, dynamic>> reportData) async {
    final pdf = pw.Document();

    // Load a font that has Unicode support
    final font = await PdfGoogleFonts.nunitoRegular();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Fuel fillings for drivers report',
                style: pw.TextStyle(font: font, fontSize: 24),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                headers: <String>[
                  'Title',
                  'Description',
                  'Location',
                  'Type',
                  'Status',
                  'Repoter'
                ],
                data: reportData.map((item) {
                  final user = item['user'] as Map<String, dynamic>?;

                  return <String>[
                    item['title']?.toString() ?? 'N/A',
                    item['description']?.toString() ?? 'N/A',
                    "Lat: ${item['location_latitude']?.toString()}, Long: ${item['location_longitude']?.toString()}",
                    item['type']?.toString() ?? 'N/A',
                    item['status']?.toString() ?? 'N/A',
                    user?['name']?.toString() ?? 'N/A',
                  ];
                }).toList(),
                cellStyle: pw.TextStyle(font: font),
                headerStyle:
                    pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final path = '${directory?.path}/report.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _loading = false;
    });
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'report.pdf');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipPath(
          clipper: AppBarClipPath(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryRed, primaryRed.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Reported crimes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryRed,
                ),
              )
            : Column(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _generatingReport = true;
                        generateReport();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryRed,
                      ),
                      padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: _generatingReport
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Generate report',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allReported.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(index),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                _allReported[index]['title'],
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return CrimeDetails(
                                        title: _allReported[index]['title'],
                                        description: _allReported[index]
                                            ['description'],
                                        locationLatitude: _allReported[index]
                                            ['location_latitude'],
                                        locationLongitude: _allReported[index]
                                            ['location_longitude'],
                                        type: _allReported[index]['type'],
                                        status: _allReported[index]['status'],
                                        image: _allReported[index]['file']
                                            ['document'],
                                        name: _allReported[index]['user']
                                            ['name'],
                                        receiver: _allReported[index]['user']
                                            ['id'],
                                      );
                                    },
                                  ),
                                );
                              },
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _allReported[index]['type'],
                                    textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  (_allReported[index]['status'] == 'inactive')
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              'Inactive',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              'Active',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewMap(),
              ),
            );
          },
          child: Icon(
            Icons.location_on,
            color: primaryRed,
          ),
        ),
      ),
    );
  }
}
