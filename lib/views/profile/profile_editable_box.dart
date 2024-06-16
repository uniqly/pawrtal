import 'dart:developer';

import 'package:flutter/material.dart';

class ProfileEditableBox extends StatelessWidget {
  final String fieldName;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final String? defaultText;
  final IconData? icon;
  final Widget? prefix;

  const ProfileEditableBox({
    super.key,
    required this.fieldName,
    required this.onChanged,
    required this.controller,
    this.defaultText,
    this.icon,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    log(controller?.text ?? 'no controller');
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Column( 
        children: [ 
          Row( 
            children: [ 
              if (icon != null)
              Icon(icon),
              if (icon != null)
              const SizedBox(width: 5.0,),
              Text(fieldName)
            ],
          ),
          TextFormField( 
            controller: controller,
            decoration: InputDecoration( 
              prefix: controller.text.isNotEmpty ? prefix : null,
            ),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}