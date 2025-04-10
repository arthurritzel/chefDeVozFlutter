import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_markdown/flutter_markdown.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef de Voz',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MotivationalScreen(),
    );
  }
}

class MotivationalScreen extends StatefulWidget {
  const MotivationalScreen({Key? key}) : super(key: key);

  @override
  State<MotivationalScreen> createState() => _MotivationalScreenState();
}

class _MotivationalScreenState extends State<MotivationalScreen> {
  final TextEditingController ingredientesController = TextEditingController();
  String _receitaResponse = '';
  bool _isLoading = false;
  bool _isListening = false;
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
        });
      },
    );
    if (!available) {
      // O reconhecimento de voz não está disponível no dispositivo
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              ingredientesController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  Future<void> _getReceita() async {
  if (ingredientesController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, diga os ingredientes que você tem')),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final String apiKey = 'AIzaSyCq4d7u0JFryI7AxyTmyjXQLfL18_K8ZfU';
    final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final String ingredients = ingredientesController.text;
    final String prompt = '''
Você é um chef criativo e prático.

Com base apenas nos seguintes ingredientes informados: "$ingredients"

Sugira uma ou mais receitas possíveis que podem ser preparadas usando apenas esses ingredientes (ou adicionando poucos ingredientes comuns como sal, azeite, alho etc.).

As receitas devem ser simples, criativas e ter instruções curtas. 
Use um tom informal e amigável, como se estivesse falando com um amigo. 

Se possível, dê um nome divertido para o prato!
''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": prompt
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.9,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 800,
        }
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final String content = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      setState(() {
        _receitaResponse = content;
        ingredientesController.clear();
      });
    } else {
      setState(() {
        _receitaResponse = 'Erro ao obter receita: ${response.statusCode}\n${response.body}';
      });
    }
  } catch (e) {
    setState(() {
      _receitaResponse = 'Erro ao conectar com a API: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 253, 239, 216),
        foregroundColor: Color(0xFFFF7043),
        toolbarHeight: 100, // Aumenta a altura da AppBar
        title: Row(
          children: [
            Image.asset(
              'assets/images/chef_logo.png',
              height: 94, // ajuste proporcional ao novo tamanho
            ),
            const SizedBox(width: 12),
            const Text(
              'Chef de Voz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Com o que vamos cozinhar hoje?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Insira os ingredientes que você tem em casa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ingredientesController,
                    decoration: const InputDecoration(
                      hintText: 'Com o que vamos cozinhar hoje?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.redAccent : Colors.purple,
                  ),
                  child: IconButton(
                    onPressed: _listen,
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getReceita,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Criar Receita', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            if (_receitaResponse.isNotEmpty) ...[
              const SizedBox(height: 12),
              if (_receitaResponse.trim().isNotEmpty) ...[
                const Text(
                  'Pega essas receitas mais que deliciosas:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: MarkdownBody( // se estiver usando flutter_markdown
                        data: _receitaResponse,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ingredientesController.dispose();
    super.dispose();
  }
}