import 'package:flutter/material.dart';

class VisitorHome extends StatefulWidget {
  const VisitorHome({super.key});

  @override
  State<VisitorHome> createState() => _VisitorHomeState();
}

class _VisitorHomeState extends State<VisitorHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Home de los visitantes de villa quien'),
          IconButton(
              onPressed: () {
                //Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
              icon: Icon(Icons.back_hand))
        ],
      ),
    );
  }
}
