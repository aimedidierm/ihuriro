import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/map/view.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class CrimeDetails extends StatefulWidget {
  final String title, description, location, type, status;
  const CrimeDetails({
    Key? key,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
  }) : super(key: key);

  @override
  State<CrimeDetails> createState() => _CrimeDetailsState();
}

class _CrimeDetailsState extends State<CrimeDetails> {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Type: ${widget.type}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Status: ${widget.status}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.description),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const ViewMap();
                    },
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => primaryRed,
                ),
                padding: MaterialStateProperty.resolveWith(
                  (states) => const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  'View Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}