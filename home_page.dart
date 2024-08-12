import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:virtual_voice_assistant/feature_box.dart';
import 'package:virtual_voice_assistant/openai_service.dart';
import 'package:virtual_voice_assistant/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  final OpenAIService openAIService = OpenAIService();

  String _lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;
  @override
  void initState() {
    initializeSpeechToText();
    initializeTextToSpeech();
    super.initState();
  }

  Future<void> initializeSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> initializeTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  Future<void> _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  Future<void> speakItLoud(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ria"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: 160,
                  width: 160,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Pallete.assistantCircleColor,
                  ),
                ),
              ),
              Container(
                height: 170,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/virtualAssistant.png'),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            margin:
                const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 30),
            decoration: BoxDecoration(
              border: Border.all(
                color: Pallete.borderColor,
              ),
              borderRadius:
                  BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
            ),
            child: Text(
              generatedContent == null
                  ? "Good Morning, What can I do for you?"
                  : generatedContent!,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                fontSize: generatedContent == null ? 25 : 18,
                fontWeight: FontWeight.bold,
                color: Pallete.mainFontColor,
              ),
            ),
          ),
          if (generatedImageUrl != null) Image.network(generatedImageUrl!),
          Visibility(
            visible: generatedContent == null && generatedImageUrl == null,
            child: Container(
              padding: const EdgeInsets.only(left: 25),
              margin: const EdgeInsets.only(top: 15),
              alignment: Alignment.centerLeft,
              child: const Text(
                "You can try some of the these",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Pallete.mainFontColor,
                ),
              ),
            ),
          ),
          Visibility(
            visible: generatedContent == null,
            child: const Column(
              children: [
                FeatureBox(
                  headerText: "ChatGPT",
                  contentText:
                      "A smarter way to stay organized and informed with ChatGPT",
                  color: Pallete.firstSuggestionBoxColor,
                ),
                FeatureBox(
                  headerText: "Dall-E",
                  contentText:
                      "Get inspired and stay creative with your personal assistant powered by Dall-E",
                  color: Pallete.secondSuggestionBoxColor,
                ),
                FeatureBox(
                  headerText: "Smart Voice Assistant",
                  contentText:
                      "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                  color: Pallete.thirdSuggestionBoxColor,
                ),
              ],
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await _startListening();
          } else if (speechToText.isListening) {
            final response = await openAIService.isArtPromptApi(_lastWords);
            if (response.contains('https')) {
              generatedImageUrl = response;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageUrl = null;
              generatedContent = response;
              setState(() {});
              await speakItLoud(response);
            }

            await _stopListening();
          } else {
            initializeSpeechToText();
          }
        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: const Icon(
          Icons.mic,
        ),
      ),
    );
  }
}
