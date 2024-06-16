import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/crimes/details.dart';
import 'package:ihuriro/screens/government/map/view.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class ListReportedCrimes extends StatefulWidget {
  const ListReportedCrimes({super.key});

  @override
  State<ListReportedCrimes> createState() => _ListReportedCrimesState();
}

class _ListReportedCrimesState extends State<ListReportedCrimes> {
  bool _loading = false;

  final List<Map<String, dynamic>> _allCrimes = [
    {
      "title": "Accident in Remera",
      "description": "Habaye ikibazo gituma umuriro ugenda ahantu hose.",
      "location": "30303,9090",
      "type": "crime",
      "status": "active",
    },
    {
      "title": "Bank robbed",
      "description": "Habaye ikibazo gituma umuriro ugenda ahantu hose.",
      "location": "30303,9090",
      "type": "oridinary",
      "status": "inactive",
    }
  ];

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
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(index),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                _allCrimes[index]['title'],
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
                                        title: _allCrimes[index]['title'],
                                        description: _allCrimes[index]
                                            ['description'],
                                        location: _allCrimes[index]['location'],
                                        type: _allCrimes[index]['type'],
                                        status: _allCrimes[index]['status'],
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
                                    _allCrimes[index]['type'],
                                    textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  (_allCrimes[index]['status'] == 'inactive')
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
