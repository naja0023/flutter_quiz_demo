import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/root_screen/provider/root_provider.dart';

class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          elevation: 5,
        ),
        onPressed: () {
          Provider.of<RootProvider>(context, listen: false).navigateToHome();
        },
        child: const Text(
          'BACK TO HOME',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
