
import 'package:flutter/material.dart';

class ObscurableTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function validator;
  final Function onSaved;
  final Function onChanged;
  const ObscurableTextFormField({Key key, this.controller, this.labelText, this.hintText, this.validator, this.onSaved, this.onChanged}) : super(key: key);
  @override
  ObscurableTextFormFieldState createState() => ObscurableTextFormFieldState();
}

class ObscurableTextFormFieldState extends State<ObscurableTextFormField>{
  bool obscure = true;
  @override
  Widget build(BuildContext context){
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffix: IconButton(
          icon: Icon(Icons.lock),
          onPressed: (){
            setState(() {
              obscure = !obscure; 
            });
          })
      ),
      obscureText: obscure,
      controller: widget.controller,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
