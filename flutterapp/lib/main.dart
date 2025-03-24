import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StudentInfoPage(),
    );
  }
}

class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({super.key});

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  final TextEditingController _studentIdController = TextEditingController();
  bool isScanning = false;
  Map<String, dynamic>? studentInfo;
  bool isLoading = false;
  String? errorMessage;

  // Use your local IP address for physical device (not localhost)
  final String baseUrl = 'http://192.168.1.12:5000';

  Future<void> fetchStudentInfo(String id) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      studentInfo = null;
    });

    try {
      id = id.trim();
      print('Attempting to fetch student info for ID: "$id"');

      final url = '$baseUrl/students/$id';  // Changed from /student/$id to /students/$id
      print('Making request to: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('Connection timed out after 15 seconds');
          throw TimeoutException('Connection timed out. Please check server connection.');
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final student = json.decode(response.body);
          print('Successfully parsed student data: $student');
          setState(() {
            studentInfo = student;
            errorMessage = null;
          });
        } catch (e) {
          print('Error parsing student data: $e');
          setState(() {
            errorMessage = 'Error reading student data. Please try again.';
          });
        }
      } else if (response.statusCode == 404) {
        print('Student not found in database. ID: $id');
        setState(() {
          errorMessage = 'Student ID not found: $id\nMake sure the ID exists in the database';
        });
      } else {
        print('Server error: ${response.statusCode}, Body: ${response.body}');
        setState(() {
          errorMessage = 'Server error ${response.statusCode}.\nPlease check if the server is running.';
        });
      }
    } catch (e, stackTrace) {
      print('Error occurred while fetching student info:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'Connection error.\nPlease check if the server is running at $baseUrl';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      setState(() {
        errorMessage = 'Camera permission is required to scan QR codes';
      });
      return;
    }
    if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text('Camera permission is required to scan QR codes. Please enable it in app settings.'),
            actions: [
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
      return;
    }
    setState(() {
      isScanning = true;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Student ID',
                border: OutlineInputBorder(),
                hintText: 'Type student ID here',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchStudentInfo(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_studentIdController.text.isNotEmpty) {
                      fetchStudentInfo(_studentIdController.text);
                    } else {
                      setState(() {
                        errorMessage = 'Please enter a student ID';
                      });
                    }
                  },
                  child: const Text('Search Student'),
                ),
                ElevatedButton.icon(
                  onPressed: _requestCameraPermission,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            if (isScanning)
              Expanded(
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.normal,
                        facing: CameraFacing.back,
                        torchEnabled: false,
                      ),
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                            print('QR Code Detected!');
                            String scannedText = barcode.rawValue!;
                            print('Raw QR code content: $scannedText');
                            
                            // Extract only the numeric part (student ID)
                            String studentId = scannedText.replaceAll(RegExp(r'[^0-9]'), '');
                            print('Extracted Student ID: $studentId');
                            
                            if (studentId.isNotEmpty) {
                              // Stop scanning immediately after detecting a code
                              setState(() {
                                isScanning = false;
                              });

                              // Show what was scanned in a dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Scanned Content'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Raw scan: $scannedText'),
                                      const SizedBox(height: 8),
                                      Text('Student ID: $studentId', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Set the ID in the text field and fetch info
                                        setState(() {
                                          _studentIdController.text = studentId;
                                        });
                                        fetchStudentInfo(studentId);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              print('No valid student ID found in QR code');
                              setState(() {
                                errorMessage = 'Invalid QR code. No student ID found.';
                                isScanning = false;
                              });
                            }
                            break;
                          }
                        }
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isScanning = false;
                              });
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('Cancel Scanning'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (studentInfo != null) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var entry in studentInfo!.entries)
                        if (entry.key != 'photoUrl')
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                      if (studentInfo!['photoUrl'] != null &&
                          studentInfo!['photoUrl'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.network(
                            studentInfo!['photoUrl'],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error,
                                  size: 100, color: Colors.red);
                            },
                          ),
                        )
                      else
                        const Text("No image available",
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }
}
