import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_voice_assistant/keys.dart';

class OpenAIService {
  List<Map<String, String>> messages = [];

  Future<String> isArtPromptApi(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey'
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture,image or any art?Simply say yes or no.'
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        content = content.toLowerCase();
        switch (content) {
          case 'yes,':
          case 'yes.':
          case 'yes':
            final res = await dallEApi(prompt);
            return res;
          default:
            final res = await chatGPTApi(prompt);
            return res;
        }
      }
    } catch (e) {
      const SnackBar(content: Text("e.toString()"));
    }

    return 'An internal Occur occurred';
  }

  Future<String> chatGPTApi(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey'
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
        }),
      );
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        messages.add({
          'role': 'assistant',
          'content': content,
        });

        return content;
      }
    } catch (e) {
      const SnackBar(content: Text("e.toString()"));
    }

    return 'An internal Occur occurred';
  }

  Future<String> dallEApi(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/images/generations"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey'
        },
        body: json.encode({
          'prompt': prompt,
          'n': 1,
        }),
      );
      if (response.statusCode == 200) {
        String imageUrl = jsonDecode(response.body)['data'][0]['url'];
        imageUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });

        return imageUrl;
      }
    } catch (e) {
      const SnackBar(content: Text("e.toString()"));
    }

    return 'An internal Occur occurred';
  }
}
