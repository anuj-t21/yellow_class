import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool circularBorder;
  final double? width;
  final String? key2;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSave;
  final void Function(String? value)? onChange;
  final void Function(String? value)? onFieldSubmit;
  final AutovalidateMode? autoValidateMode;

  CustomTextField({
    required this.hintText,
    required this.textEditingController,
    this.key2,
    this.width = 300,
    this.circularBorder = false,
    this.validator,
    this.onSave,
    this.onChange,
    this.onFieldSubmit,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
//    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: width,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
//        borderRadius: circularBorder
//            ? StyleConstants.commonBorder28
//            : StyleConstants.commonBorder4,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: TextFormField(
          key: key2 != null ? Key(key2!) : UniqueKey(),
          controller: textEditingController,
          obscureText: false,
          validator: validator ?? (value) {},
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 1,
              ),
//              borderRadius: circularBorder
//                  ? StyleConstants.tl28tr28Border
//                  : StyleConstants.tl4tr4Border,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 1,
              ),
//              borderRadius: circularBorder
//                  ? StyleConstants.tl28tr28Border
//                  : StyleConstants.tl4tr4Border,
            ),
          ),
          onSaved: onSave ?? (value) {},
          onChanged: onChange ?? (value) {},
          onFieldSubmitted: onFieldSubmit ?? (value) {},
          autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
        ),
      ),
    );
  }
}
