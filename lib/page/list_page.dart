import 'package:fleme/widgets/images_list_widget.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ImagesList()],
          ),
        ),
      ),
    );
  }
}
