import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swiring_app/Services/DateConverterService.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  _DateTimePickerState createState() => _DateTimePickerState(selectedDate);
}

class _DateTimePickerState extends State<DateTimePicker> {
  _DateTimePickerState(this.selectedDate);
  DateTime selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      widget.selectDate(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: widget.labelText,
            valueText: DateConverterService.getDateAsString(selectedDate),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key, this.child, this.labelText, this.valueText, this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
