import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color color;

  const LoadingButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: widget.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              widget.text,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }
}
