import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  @required String label,
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  @required Function validate,
  Function onTab,
  IconData prefix,
  bool enabled,


}) =>
    TextFormField(
      controller: controller,
      keyboardType: type ,
      onFieldSubmitted: onSubmit ,
      onChanged: onChange,
      validator: validate,
      onTap: onTab,
      enabled: enabled,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)
        )
      ),
    );
