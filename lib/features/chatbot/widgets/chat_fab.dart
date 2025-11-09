import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/chatbot_provider.dart';

/// Floating Chat Button
///
/// Displays a floating action button for opening the chat
class ChatFAB extends ConsumerWidget {
  const ChatFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatbotProvider);
    final hasUnread = chatState.hasSession && chatState.messages.isNotEmpty;

    return FloatingActionButton(
      heroTag: 'chatbot_fab',
      onPressed: () {
        context.push('/chat');
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          const Icon(Icons.chat_bubble, color: Colors.white),
          if (hasUnread)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
