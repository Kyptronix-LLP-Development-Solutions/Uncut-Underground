import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'text_widget.dart';

/* -------------------------------------------------------------------------- */
/*                                inputField 1                                */
/* -------------------------------------------------------------------------- */

class InpuTFormField01 extends StatefulWidget {
  const InpuTFormField01({
    Key? key,
    required this.text,
    this.controller,
    this.textInputType,
    this.formValidator,
    this.hintText,
    this.iconColor,
    required this.isPassword,
  }) : super(key: key);

  final String text;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? Function(String?)? formValidator;
  final String? hintText;
  final Color? iconColor;
  final bool isPassword;

  @override
  State<InpuTFormField01> createState() => _InpuTFormField01State();
}

class _InpuTFormField01State extends State<InpuTFormField01> {
  bool visiblePassword = false;
  @override
  void initState() {
    if (widget.isPassword == true) {
      setState(() {
        visiblePassword = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ---------------------------------- label --------------------------------- */
          Row(
            children: [
              CustomTextWidget01(
                text: widget.text,
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              const CustomTextWidget01(
                text: '*',
                color: Colors.red,
              )
            ],
          ),
          const Gap(10.0),

          /* ------------------------------- input field ------------------------------ */
          Container(
            decoration: const BoxDecoration(
              boxShadow: [],
            ),
            child: TextFormField(
              controller: widget.controller,
              enableSuggestions: true,
              keyboardType: widget.textInputType,
              obscureText: visiblePassword,
              validator: widget.formValidator,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                // border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: widget.hintText,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            visiblePassword = !visiblePassword;
                          });
                        },
                        icon: visiblePassword
                            ? Icon(
                                Icons.visibility_off,
                                color: widget.iconColor ?? Colors.black,
                              )
                            : Icon(
                                Icons.visibility,
                                color: widget.iconColor ?? Colors.black,
                              ),
                      )
                    : Icon(
                        Icons.mail,
                        color: widget.iconColor ?? Colors.black,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                inputField 2                                */
/* -------------------------------------------------------------------------- */
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InpuTFormField02 extends StatefulWidget {
  const InpuTFormField02({
    Key? key,
    required this.text,
    this.controller,
    this.textInputType,
    this.formValidator,
    this.hintText,
    this.textCapitalization,
  }) : super(key: key);

  final String text;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? Function(String?)? formValidator;
  final String? hintText;

  final TextCapitalization? textCapitalization;

  @override
  State<InpuTFormField02> createState() => _InpuTFormField02State();
}

class _InpuTFormField02State extends State<InpuTFormField02> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ---------------------------------- label --------------------------------- */
          Row(
            children: [
              CustomTextWidget01(
                text: widget.text,
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              const CustomTextWidget01(
                text: '*',
                color: Colors.red,
              )
            ],
          ),
          const Gap(10.0),

          /* ------------------------------- input field ------------------------------ */
          Container(
            decoration: const BoxDecoration(
              boxShadow: [],
            ),
            child: TextFormField(
              controller: widget.controller,
              enableSuggestions: true,
              keyboardType: widget.textInputType,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.sentences,
              validator: widget.formValidator,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                // border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: widget.hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 combobox 1                                 */
/* -------------------------------------------------------------------------- */

class CustomComboBox extends StatefulWidget {
  const CustomComboBox({
    Key? key,
    required this.text,
    required this.items,
    this.controller,
    this.formValidator,
    this.hintText,
  }) : super(key: key);

  final String text;
  final List<String> items;
  final TextEditingController? controller;
  final String? Function(String?)? formValidator;
  final String? hintText;

  @override
  State<CustomComboBox> createState() => _CustomComboBoxState();
}

class _CustomComboBoxState extends State<CustomComboBox> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ---------------------------------- label --------------------------------- */
          Row(
            children: [
              CustomTextWidget01(
                text: widget.text,
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              const Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),

          /* ----------------------------- dropdown button ---------------------------- */
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                // BoxShadow(
                //   color: Colors.grey.withOpacity(0.5),
                //   spreadRadius: 3,
                //   blurRadius: 10,
                //   offset: const Offset(0, 5),
                // ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedItem,
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                });
              },
              validator: widget.formValidator,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: widget.hintText,
              ),
              items: widget.items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
