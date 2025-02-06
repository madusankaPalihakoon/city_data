import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

const String htmlContent = '''
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

class _MapState extends State<Map> {
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

  final late params = const PlatformWebViewControllerCreationParams();

  final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
