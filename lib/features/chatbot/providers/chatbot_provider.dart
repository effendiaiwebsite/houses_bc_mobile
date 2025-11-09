import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../services/chatbot_service.dart';
import '../../../shared/models/api_response.dart';

// Chatbot Service Provider
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService();
});

// Chatbot State
class ChatbotState {
  final ChatSession? session;
  final bool isLoading;
  final bool isTyping; // Bot is typing
  final String? error;
  final String? currentInput;

  ChatbotState({
    this.session,
    this.isLoading = false,
    this.isTyping = false,
    this.error,
    this.currentInput,
  });

  List<ChatMessage> get messages => session?.messages ?? [];
  String? get sessionId => session?.id;
  bool get hasSession => session != null;

  ChatbotState copyWith({
    ChatSession? session,
    bool? isLoading,
    bool? isTyping,
    String? error,
    String? currentInput,
  }) {
    return ChatbotState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
      error: error,
      currentInput: currentInput ?? this.currentInput,
    );
  }
}

// Chatbot Notifier
class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final ChatbotService _chatbotService;
  final Uuid _uuid = const Uuid();

  ChatbotNotifier(this._chatbotService) : super(ChatbotState());

  /// Send a message to the chatbot
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Sanitize input
    final sanitizedMessage = _chatbotService.sanitizeInput(message);

    // Validate
    if (!_chatbotService.isValidMessage(sanitizedMessage)) {
      state = state.copyWith(
        error: 'Invalid message content',
      );
      return;
    }

    // Create user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      sessionId: state.sessionId ?? _uuid.v4(),
      role: 'user',
      content: sanitizedMessage,
      timestamp: DateTime.now(),
    );

    // Update state with user message
    final currentSession = state.session ??
        ChatSession.empty(userMessage.sessionId);

    state = state.copyWith(
      session: currentSession.copyWith(
        messages: [...currentSession.messages, userMessage],
      ),
      isTyping: true,
      error: null,
    );

    // Send to API
    final result = await _chatbotService.sendMessage(
      sanitizedMessage,
      sessionId: state.sessionId,
    );

    if (result.isSuccess && result.data != null) {
      // Add bot response
      state = state.copyWith(
        session: state.session!.copyWith(
          id: result.data!.sessionId, // Update session ID from server
          messages: [...state.messages, result.data!],
          updatedAt: DateTime.now(),
        ),
        isTyping: false,
      );
    } else {
      // Handle error
      state = state.copyWith(
        isTyping: false,
        error: result.error ?? 'Failed to send message',
      );
    }
  }

  /// Load chat history
  Future<void> loadHistory(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _chatbotService.getHistory(sessionId);

    if (result.isSuccess && result.data != null) {
      final now = DateTime.now();
      state = state.copyWith(
        session: ChatSession(
          id: sessionId,
          messages: result.data!,
          createdAt: result.data!.isNotEmpty
              ? result.data!.first.timestamp
              : now,
          updatedAt: result.data!.isNotEmpty
              ? result.data!.last.timestamp
              : now,
        ),
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error ?? 'Failed to load history',
      );
    }
  }

  /// Clear current session
  void clearSession() {
    state = ChatbotState();
  }

  /// Delete session from server
  Future<void> deleteSession() async {
    if (state.sessionId == null) return;

    final sessionId = state.sessionId!;

    state = state.copyWith(isLoading: true);

    final result = await _chatbotService.deleteSession(sessionId);

    if (result.isSuccess) {
      state = ChatbotState(); // Reset to initial state
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error ?? 'Failed to delete session',
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Update current input (for draft saving)
  void updateCurrentInput(String input) {
    state = state.copyWith(currentInput: input);
  }
}

// Chatbot Provider
final chatbotProvider =
    StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  final chatbotService = ref.watch(chatbotServiceProvider);
  return ChatbotNotifier(chatbotService);
});
