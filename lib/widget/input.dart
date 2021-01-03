import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput {
  BuildContext context;
  TextEditingController controller;
  String labelName;
  String hint;
  Function onchange;
  Function ontap;
  EdgeInsetsGeometry container1Margin;
  EdgeInsetsGeometry container2Margin;
  bool validateEmpty;
  FormFieldValidator<String> validator;
  bool hidePass;
  String initValue = "";
  bool readOnly;
  double bottomMargin;
  double topMargin;
  TextInputType keyboardType;
  TextInputAction inputAction;
  List<TextInputFormatter> inputFormatters;
  bool enabled;
  CustomInput(this.context,
      {this.controller,
      this.labelName = "",
      this.hint = "",
      this.onchange,
      this.ontap,
      this.initValue,
      this.hidePass = false,
      this.readOnly = false,
      this.bottomMargin = 10.0,
      this.topMargin = 12.0,
      this.keyboardType,
      this.inputAction,
      this.container1Margin,
      this.container2Margin,
      this.validateEmpty = false,
      this.enabled = true,
      this.inputFormatters,
      this.validator}) {
    if (this.validateEmpty && this.validator == null) {
      this.validator =
          (val) => val == "" ? this.labelName + " alanı zorunludur." : null;
    }
  }

  Widget create() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
      margin: EdgeInsets.only(top: this.topMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (this.labelName != "")
            Container(
              margin: EdgeInsets.only(bottom: this.bottomMargin),
              child: Text(
                this.labelName,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          CupertinoTextFormFieldRow(
              enabled: this.enabled,
              textInputAction: this.inputAction,
              keyboardType: this.keyboardType,
              readOnly: this.readOnly,
              obscureText: this.hidePass,
              initialValue: this.initValue,
              onChanged: this.onchange,
              onTap: this.ontap,
              controller: this.controller,
              inputFormatters: this.inputFormatters,
              style: Theme.of(context).textTheme.bodyText1,
              validator: this.validator),
        ],
      ),
    );
  }
}
