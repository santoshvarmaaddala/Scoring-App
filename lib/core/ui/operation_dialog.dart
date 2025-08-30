import 'package:flutter/material.dart';
import "../../utils/app_constants.dart";

void showConfirmationDialog(
    BuildContext context,
    VoidCallback onConfirm,
    String operation,
) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm ${operation.capitalize()}'),
        content: Text('Are you sure you want to $operation this item?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,      // Button background
            foregroundColor: Colors.white,    // Text/Icon color
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(operation.capitalize()),
        )

        ],
      );
    },
  );
}
