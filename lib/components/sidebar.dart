import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback toggleSidebar;

  const Sidebar({required this.toggleSidebar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 250,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Menu",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: toggleSidebar,
                ),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("Map View"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.layers),
              title: Text("Layers"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
