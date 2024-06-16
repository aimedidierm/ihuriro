import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/resources/create.dart';
import 'package:ihuriro/screens/government/resources/details.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class ListResources extends StatefulWidget {
  const ListResources({super.key});

  @override
  State<ListResources> createState() => _ListResourcesState();
}

class _ListResourcesState extends State<ListResources> {
  bool _loading = false;

  final List<Map<String, dynamic>> _allResources = [
    {
      "title": "Emergency number",
      "description": "Habaye ikibazo gituma uhamagara wahagara kuri iyi nimero",
      "summary": "You can call 911",
    },
    {
      "title": "Emergency number",
      "description": "Habaye ikibazo gituma uhamagara wahagara kuri iyi nimero",
      "summary": "You can call 911",
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
                        "Safety resources",
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
                                _allResources[index]['title'],
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ResourcesDetails(
                                        title: _allResources[index]['title'],
                                        description: _allResources[index]
                                            ['description'],
                                        summary: _allResources[index]
                                            ['summary'],
                                      );
                                    },
                                  ),
                                );
                              },
                              subtitle: Text(
                                _allResources[index]['summary'],
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                builder: (context) => const CreateResource(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: primaryRed,
          ),
        ),
      ),
    );
  }
}
