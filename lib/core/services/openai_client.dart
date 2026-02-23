import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/entities.dart';

class AiRequestMessage {
  const AiRequestMessage({required this.role, required this.content});

  final AiRole role;
  final String content;
}

class AiRequest {
  const AiRequest({
    required this.model,
    required this.systemPrompt,
    required this.messages,
  });

  final String model;
  final String systemPrompt;
  final List<AiRequestMessage> messages;
}

enum AssistantActionType { createGoal, createTask }

class AssistantActionProposal {
  const AssistantActionProposal({required this.type, required this.payload});

  final AssistantActionType type;
  final Map<String, dynamic> payload;
}

class AiResponse {
  const AiResponse({required this.text, this.action});

  final String text;
  final AssistantActionProposal? action;
}

abstract class AiClient {
  Future<AiResponse> send({required String apiKey, required AiRequest request});
}

class OpenAiResponsesClient implements AiClient {
  OpenAiResponsesClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static final Uri _endpoint = Uri.parse('https://api.openai.com/v1/responses');

  @override
  Future<AiResponse> send({
    required String apiKey,
    required AiRequest request,
  }) async {
    final payload = {
      'model': request.model,
      'input': [
        {
          'role': 'system',
          'content': [
            {'type': 'input_text', 'text': request.systemPrompt},
          ],
        },
        for (final message in request.messages)
          {
            'role': _roleToOpenAi(message.role),
            'content': [
              {'type': 'input_text', 'text': message.content},
            ],
          },
      ],
    };

    final response = await _httpClient.post(
      _endpoint,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'OpenAI request failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid OpenAI response payload.');
    }

    final outputText = _extractOutputText(decoded).trim();
    final parsedEnvelope = _tryParseAssistantEnvelope(outputText);

    return AiResponse(
      text: parsedEnvelope.reply,
      action: parsedEnvelope.action,
    );
  }

  String _roleToOpenAi(AiRole role) {
    switch (role) {
      case AiRole.user:
        return 'user';
      case AiRole.assistant:
        return 'assistant';
      case AiRole.system:
        return 'system';
    }
  }

  String _extractOutputText(Map<String, dynamic> decoded) {
    final outputText = decoded['output_text'];
    if (outputText is String && outputText.trim().isNotEmpty) {
      return outputText;
    }

    final output = decoded['output'];
    if (output is List) {
      final buffer = StringBuffer();
      for (final item in output) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final content = item['content'];
        if (content is! List) {
          continue;
        }
        for (final contentItem in content) {
          if (contentItem is! Map<String, dynamic>) {
            continue;
          }
          final text = contentItem['text'];
          if (text is String && text.isNotEmpty) {
            if (buffer.isNotEmpty) {
              buffer.writeln();
            }
            buffer.write(text);
          }
        }
      }
      if (buffer.isNotEmpty) {
        return buffer.toString();
      }
    }

    return 'No response text received from model.';
  }

  _AssistantEnvelope _tryParseAssistantEnvelope(String rawText) {
    final trimmed = rawText.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return _AssistantEnvelope(reply: rawText, action: null);
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map<String, dynamic>) {
        return _AssistantEnvelope(reply: rawText, action: null);
      }

      final reply = decoded['reply'];
      final replyText = reply is String && reply.trim().isNotEmpty
          ? reply
          : rawText;

      final action = _parseAction(decoded['action']);
      return _AssistantEnvelope(reply: replyText, action: action);
    } catch (_) {
      return _AssistantEnvelope(reply: rawText, action: null);
    }
  }

  AssistantActionProposal? _parseAction(Object? rawAction) {
    if (rawAction is! Map<String, dynamic>) {
      return null;
    }

    final typeRaw = rawAction['type'];
    if (typeRaw is! String) {
      return null;
    }

    switch (typeRaw) {
      case 'create_goal':
        return AssistantActionProposal(
          type: AssistantActionType.createGoal,
          payload: Map<String, dynamic>.from(rawAction),
        );
      case 'create_task':
        return AssistantActionProposal(
          type: AssistantActionType.createTask,
          payload: Map<String, dynamic>.from(rawAction),
        );
      default:
        return null;
    }
  }
}

class _AssistantEnvelope {
  const _AssistantEnvelope({required this.reply, required this.action});

  final String reply;
  final AssistantActionProposal? action;
}
