import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NtripInterface extends StatefulWidget {
  const NtripInterface({super.key});

  @override
  _NtripInterfaceState createState() => _NtripInterfaceState();
}

class _NtripInterfaceState extends State<NtripInterface> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  List<String> mountPoints = [];
  String? selectedMountPoint;
  bool isLoading = false;

  Future<String> fetchNTRIPData({String? mountPoint}) async {
    final String username = _userController.text;
    final String password = _passController.text;
    final String authHeader =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    print('Connected to ${_hostController.text}:${_portController.text}');
    final Socket socket = await Socket.connect(
        _hostController.text, int.parse(_portController.text));

    String request;
    if (mountPoint != null) {
      request = 'GET /$mountPoint HTTP/1.1\r\n'
          'User-Agent: NTRIP FlutterClient/1.0\r\n'
          'Authorization: $authHeader\r\n'
          'Connection: close\r\n'
          'Accept: */*\r\n'
          '\r\n';
    } else {
      request = 'GET / HTTP/1.1\r\n'
          'User-Agent: NTRIPClient/0.9\r\n'
          'Authorization: $authHeader\r\n'
          'Connection: close\r\n'
          '\r\n';
    }

    socket.write(request);
    socket.flush();

    final response = await socket
        .fold(
          BytesBuilder(),
          (BytesBuilder builder, List<int> data) => builder..add(data),
        )
        .then((builder) => builder.takeBytes());

    print('Raw Response Bytes: $response');

    socket.destroy();
    return utf8.decode(response);
  }

  void parseSourceTable(String rawText) {
    List<String> lines = rawText.split('\n');
    List<String> sources = [];

    for (String line in lines) {
      if (line.startsWith('STR;')) {
        sources.add(line.split(';')[1]);
      }
    }

    setState(() {
      mountPoints = sources;
      selectedMountPoint = mountPoints.isNotEmpty ? mountPoints[0] : null;
    });
  }

  Future<void> getMountPoints() async {
    setState(() => isLoading = true);

    try {
      String data = await fetchNTRIPData();
      parseSourceTable(data);
    } catch (e) {
      print('Error: $e');
    }

    setState(() => isLoading = false);
  }

  Future<void> connectToMountPoint() async {
    if (selectedMountPoint == null) {
      print('No mountpoint selected');
      return;
    }

    setState(() => isLoading = true);

    try {
      final String username = _userController.text;
      final String password = _passController.text;
      final String authHeader =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      print('Connecting to ${_hostController.text}:${_portController.text}');
      final Socket socket = await Socket.connect(
          _hostController.text, int.parse(_portController.text));

      String request = 'GET /$selectedMountPoint HTTP/1.1\r\n'
          'User-Agent: NTRIP FlutterClient/1.0\r\n'
          'Authorization: $authHeader\r\n'
          'Connection: close\r\n'
          'Accept: */*\r\n'
          '\r\n';

      socket.write(request);
      socket.flush();

      print('Connected to mountpoint: $selectedMountPoint');

      socket.listen(
        (List<int> data) {
          print('Received Data: ${utf8.decode(data)}');
        },
        onError: (error) {
          print('Error: $error');
        },
        onDone: () {
          print('Connection closed');
          socket.destroy();
        },
      );
    } catch (e) {
      print('Error connecting to mountpoint: $e');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField("Host", _hostController),
              buildTextField("Port", _portController, isNumber: true),
              buildTextField("Username", _userController),
              buildTextField("Password", _passController, isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: getMountPoints,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Get Mountpoints", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              if (mountPoints.isNotEmpty)
                DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: selectedMountPoint,
                  onChanged: (value) {
                    setState(() => selectedMountPoint = value);
                  },
                  items: mountPoints.map((mp) {
                    return DropdownMenuItem<String>(
                      value: mp,
                      child: Text(mp, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              if (selectedMountPoint != null)
                ElevatedButton(
                  onPressed: connectToMountPoint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Connect", style: TextStyle(fontSize: 18)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
