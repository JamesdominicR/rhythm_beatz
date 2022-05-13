import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String? titleNew;
  final IconData leadingNew;
  // final PopupMenuButton? trailingNew;
  final Function()? ontapNew;
  const CustomListTile(
      {Key? key,
      required this.titleNew,
      required this.leadingNew,
      // this.trailingNew,
      this.ontapNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        titleNew!,
        style: const TextStyle(
            fontSize: 25, fontFamily: 'Poppins', color: Colors.white),
      ),
      leading: Icon(
        leadingNew,
        color: Colors.white,
      ),
      onTap: ontapNew,
    );
  }
}
