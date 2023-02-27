import 'package:flutter/material.dart';
import 'package:mysecondapp/models/sportiObj.dart';
import 'package:mysecondapp/pages/home/sport_tile.dart';
import 'package:provider/provider.dart';

class SportiList extends StatefulWidget {
  @override
  _SportiListState createState() => _SportiListState();
}

class _SportiListState extends State<SportiList> {
  @override
  Widget build(BuildContext context) {
    final sportis = Provider.of<List<Sporti>?>(context) ?? [];

    return ListView.builder(
      itemCount: sportis.length,
      itemBuilder: (context, index) {
        return SportiTile(sporti: sportis[index]);
      },
    );
  }
}
