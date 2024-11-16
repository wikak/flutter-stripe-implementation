import 'package:flutter/material.dart';

class ResuableTextField extends StatefulWidget {
  const ResuableTextField(
      {super.key,
      required this.hint,
      this.isNumber,
      required this.controller,
      required this.formKey,
      required this.title});
  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formKey;

  @override
  State<ResuableTextField> createState() => _ResuableTextFieldState();
}

class _ResuableTextFieldState extends State<ResuableTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        keyboardType:
            widget.isNumber == null ? TextInputType.text : TextInputType.number,
        decoration:
            InputDecoration(label: Text(widget.title), hintText: widget.hint),
            validator: (value) => value!.isEmpty ? 'Please enter a value' : null,
            controller: widget.controller,
      ),
    );
  }
}
