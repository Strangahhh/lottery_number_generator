import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart'; // Ensure this is only imported once

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lottery Number Generator'),
        ),
        body: NumberInputWidget(),
      ),
    );
  }
}

class NumberInputWidget extends StatefulWidget {
  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<String> lotteryNumbers = List.filled(6, "");
  File? selectedImage;

  final Map<String, String> numberWords = {
    '0': 'Zero', '1': 'One', '2': 'Two', '3': 'Three', '4': 'Four',
    '5': 'Five', '6': 'Six', '7': 'Seven', '8': 'Eight', '9': 'Nine',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (selectedImage != null)
          Expanded(
            child: Image.file(selectedImage!, fit: BoxFit.cover),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 50,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '', // Hide the length counter
                    ),
                  ),
                ),
                Text(
                  numberWords[lotteryNumbers[index]] ?? '',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          }),
        ),
        ElevatedButton(
          onPressed: () {
            generateLotteryNumbers();
          },
          child: Text('Generate Numbers'),
        ),
        ElevatedButton(
          onPressed: selectImage,
          child: Text('Select Background Image'),
        ),
        // Horizontal display of generated numbers
        Text(
          lotteryNumbers.join(' '),
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  void selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  void generateLotteryNumbers() {
    final random = Random();
    for (int i = 0; i < 6; i++) {
      if (_controllers[i].text.isEmpty) {
        // Generate a random number for empty fields
        lotteryNumbers[i] = (random.nextInt(9) + 1).toString(); // Numbers 1-9
      } else {
        lotteryNumbers[i] = _controllers[i].text;
      }
    }

    setState(() {}); // Update the UI with the new numbers
  }
}

