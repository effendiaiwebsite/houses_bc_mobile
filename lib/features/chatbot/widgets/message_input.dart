import 'package:flutter/material.dart';

/// Message Input Widget
///
/// Text input field with send button for chat messages
class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: isEnabled,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: isEnabled ? (_) => onSend() : null,
                decoration: InputDecoration(
                  hintText: 'Ask about home buying in BC...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: isEnabled
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              child: IconButton(
                icon: const Icon(Icons.send, size: 20),
                color: Colors.white,
                onPressed: isEnabled ? onSend : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
