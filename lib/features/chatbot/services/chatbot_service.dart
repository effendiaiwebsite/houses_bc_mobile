import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../shared/models/api_response.dart';
import '../models/chat_message_model.dart';

/// Chatbot Service
///
/// Handles communication with the chatbot API
class ChatbotService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Send a message to the chatbot
  Future<Result<ChatMessage>> sendMessage(
    String message, {
    String? sessionId,
  }) async {
    try {
      if (message.trim().isEmpty) {
        return Result.failure('Message cannot be empty');
      }

      if (message.length > 2000) {
        return Result.failure('Message is too long (max 2000 characters)');
      }

      final response = await _apiClient.post(
        ApiEndpoints.chatbotMessage,
        data: {
          'message': message.trim(),
          if (sessionId != null) 'sessionId': sessionId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final chatMessage = ChatMessage(
          id: data['messageId'] as String,
          sessionId: data['sessionId'] as String,
          role: 'assistant',
          content: data['message'] as String,
          timestamp: data['timestamp'] is String
              ? DateTime.parse(data['timestamp'])
              : DateTime.now(),
        );

        return Result.success(chatMessage);
      } else {
        final error = response.data?['error'] ?? 'Failed to send message';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Get chat history for a session
  Future<Result<List<ChatMessage>>> getHistory(String sessionId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.chatbotHistory(sessionId),
      );

      if (response.statusCode == 200) {
        final messages = (response.data['messages'] as List)
            .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
            .toList();

        return Result.success(messages);
      } else {
        final error = response.data?['error'] ?? 'Failed to fetch history';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Delete a chat session
  Future<Result<void>> deleteSession(String sessionId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.chatbotDeleteSession(sessionId),
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        final error = response.data?['error'] ?? 'Failed to delete session';
        return Result.failure(error);
      }
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  /// Sanitize user input (client-side validation)
  String sanitizeInput(String input) {
    // Remove excessive whitespace
    String cleaned = input.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Remove any HTML-like tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove special characters that might be problematic
    cleaned = cleaned.replaceAll(RegExp(r'[<>{}\\]'), '');

    return cleaned;
  }

  /// Validate message before sending
  bool isValidMessage(String message) {
    if (message.trim().isEmpty) return false;
    if (message.length > 2000) return false;

    // Check for suspicious patterns
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
    ];

    for (final pattern in suspiciousPatterns) {
      if (pattern.hasMatch(message)) {
        return false;
      }
    }

    return true;
  }
}
