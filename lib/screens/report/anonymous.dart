// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/crime.dart';
import 'package:image_picker/image_picker.dart';

enum ReportType { crime, oridinary, weather }

class Anonymous extends StatefulWidget {
  const Anonymous({super.key});

  @override
  State<Anonymous> createState() => _AnonymousState();
}

class _AnonymousState extends State<Anonymous> {
  bool _loading = false;
  XFile? imageFile;
  String locationLatitude = '-1.9462';
  String locationLongitude = '30.0614';
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  ReportType? _selectedReport;

  void reportCrime() async {
    setState(() {
      _loading = true;
    });

    ApiResponse response = await register(
      title.text,
      description.text,
      getEnumValue(_selectedReport),
      imageFile,
      locationLatitude,
      locationLongitude,
    );
    if (response.error == null) {
      setState(() {
        _loading = false;
        title.text = '';
        description.text = '';
        imageFile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Crime reported'),
        ),
      );
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  String getEnumValue(ReportType? enumValue) {
    if (enumValue != null) {
      return enumValue.toString().split('.').last;
    }
    return '';
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
              color: primaryRed,
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
                        "Create anonymous report",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Title is required';
                      } else {
                        return null;
                      }
                    },
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Description is required';
                      } else {
                        return null;
                      }
                    },
                    controller: description,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<ReportType>(
                    value: _selectedReport,
                    validator: (val) {
                      if (val == null) {
                        return 'Crime Type is required';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        _selectedReport = val;
                      });
                    },
                    items: ReportType.values.map((type) {
                      return DropdownMenuItem<ReportType>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      hintText: 'Crime Type:',
                      labelText: 'Crime Type',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  imageFile != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.file(File(imageFile!.path)),
                        )
                      : TextButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: primaryRed,
                                  size: 30,
                                ),
                                Text(
                                  "Take picture",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        ),
                  TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        reportCrime();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryRed,
                      ),
                      padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: (_loading)
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Create',
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
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }
}
