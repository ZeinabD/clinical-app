import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyTextfield extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final IconData? prefixIcon;
  final GestureTapCallback? onTap;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 23, color: Theme.of(context).colorScheme.onSurface),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15),
            child: FaIcon(
              prefixIcon, 
              color: Theme.of(context).colorScheme.primary, 
              size: 35),
          ),
          enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
        ),
      ),
    );
  }
}