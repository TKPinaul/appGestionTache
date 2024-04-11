import 'package:flutter/material.dart';

class BoutonValider extends StatelessWidget {
  final Function onPresseValidate;
  final String texteValidate;
  final Color colorDeFont;

  const BoutonValider({
    super.key,
    required this.onPresseValidate,
    required this.texteValidate,
    required this.colorDeFont
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () => onPresseValidate(),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(500, 60),
            backgroundColor: colorDeFont
        ),
        child: Text(
          texteValidate,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
