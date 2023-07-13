import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CustomDropDown<T> extends StatelessWidget {
  final ValueChanged<T?>? onChanged;
  final CrossAxisAlignment crossAxisAlignment;
  final String label;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<T>? validator;
  final DropdownSearchOnFind<T>? asyncItems;
  final T? value;
  final bool enabled;
  final DropdownSearchFilterFn<T>? filterFn;
  final DropdownSearchItemAsString<T>? itemAsString;
  const CustomDropDown({
    Key? key,
    required this.onChanged,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.label,
    this.helperText,
    this.errorText,
    this.validator,
    this.value,
    this.enabled = true,
    this.filterFn,
    this.asyncItems,
    this.itemAsString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.w400, color: Color(0xFF6B7281)),
        ),
        if (helperText != null && helperText!.isNotEmpty)
          Text(helperText!,
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black38,
                  fontSize: 12)),
        const SizedBox(
          height: 1,
        ),
        DropdownSearch<T>(
          selectedItem: value,
          validator: validator,
          filterFn: filterFn,
          asyncItems: asyncItems,
          itemAsString: itemAsString,
          onChanged: onChanged,
          enabled: enabled,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchDelay: Duration(milliseconds: 100),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 1, overflow: TextOverflow.fade),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB1B4E6), width: 2.0),
                ),
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          autoValidateMode: AutovalidateMode.always,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              errorStyle: const TextStyle(height: 0.65),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB1B4E6), width: 2.0),
              ),
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              isDense: true,
              errorText: errorText,
            ),
          ),
          dropdownButtonProps: const DropdownButtonProps(
            splashRadius: 1.0,

          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}