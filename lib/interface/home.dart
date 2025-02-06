import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../components/sidebar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSidebarOpen = false;
  late final WebViewController _controller;

  void _toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  void _openPointPanel() {
    // Functionality for opening point panel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            initialUrl: 'about:blank', // Load local HTML file
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets();
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.blue.shade500,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: _toggleSidebar,
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.save, color: Colors.white),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.file_present, color: Colors.white),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {}),
              ],
            ),
          ),
          if (isSidebarOpen) Sidebar(toggleSidebar: _toggleSidebar),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.blue.shade500,
                onPressed: _openPointPanel,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loadHtmlFromAssets() async {
    String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          html, body { margin: 0; padding: 0; height: 100%; }
          #map { width: 100%; height: 100vh; }
        </style>
        <link rel="stylesheet" href="https://unpkg.com/ol/ol.css">
        <script src="https://unpkg.com/ol/dist/ol.js"></script>
      </head>
      <body>
        <div id="map"></div>
        <script>
          var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({
                source: new ol.source.OSM()
              })
            ],
            view: new ol.View({
              center: ol.proj.fromLonLat([80.7718, 7.8731]), // Sri Lanka Coordinates
              zoom: 6
            })
          });
        </script>
      </body>
      </html>
    ''';

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(htmlContent));

    _controller.loadUrl(Uri.dataFromString(
      htmlContent,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'), // Correct encoding (UTF-8)
      base64: true, // This tells the WebView to interpret the content as Base64
    ).toString());
  }
}
