import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoDialog extends StatefulWidget {
  const ToDoDialog({Key? key, required this.todoTitleController})
      : super(key: key);
  final TextEditingController todoTitleController;

  @override
  _ToDoDialogState createState() => _ToDoDialogState();
}

class _ToDoDialogState extends State<ToDoDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Customize the date picker theme
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
      }
    });
  }

  void _showTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Customize the time picker theme
          child: child!,
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          _selectedTime = selectedTime;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
      backgroundColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Todo",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.cancel, color: Colors.white),
          )
        ],
      ),
      children: [
        TextFormField(
          controller: widget.todoTitleController,
          style: TextStyle(fontSize: 20, color: Colors.white),
          autofocus: true,
          decoration: InputDecoration(
            hintText: "eg. My Meeting",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _showDatePicker(context), // Show date picker
          child: Text(
            _selectedDate == null
                ? "Select Date"
                : "Date: ${DateFormat.yMMMd().format(_selectedDate!)}", // Format the selected date
            style: TextStyle(color: Colors.purple),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _showTimePicker(context), // Show time picker
          child: Text(
            _selectedTime == null
                ? "Select Time"
                : "Time: ${_selectedTime!.format(context)}",
            style: TextStyle(color: Colors.purple),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedDate != null && _selectedTime != null) {
                DateTime selectedDateTime = DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                );
                Navigator.pop(context, selectedDateTime);
              }
            },
            child: Text("ADD"),
          ),
        ),
      ],
    );
  }
}
