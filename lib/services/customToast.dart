// toast_service.dart
import 'package:flutter/material.dart';

class ToastService {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void showToast(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool isError = true,
  }) {
    if (_isVisible) {
      _overlayEntry?.remove();
      _isVisible = false;
    }

    _overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) =>
              ToastOverlay(message: message, isError: isError),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;

    Future.delayed(duration, () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
        _isVisible = false;
      }
    });
  }
}

class ToastOverlay extends StatefulWidget {
  final String message;
  final bool isError;

  const ToastOverlay({Key? key, required this.message, this.isError = true})
    : super(key: key);

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(_animation),
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      widget.isError
                          ? Colors.red.shade600
                          : Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.isError ? Colors.red : Colors.green)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isError
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
