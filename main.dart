import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const AsistenteMusicaApp());
}

class AsistenteMusicaApp extends StatelessWidget {
  const AsistenteMusicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Director de Atmósfera',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
      ),
      home: const DashboardAsistente(),
    );
  }
}

class DashboardAsistente extends StatefulWidget {
  const DashboardAsistente({super.key});

  @override
  State<DashboardAsistente> createState() => _DashboardAsistenteState();
}

class _DashboardAsistenteState extends State<DashboardAsistente> {
  final TextEditingController _comandoController = TextEditingController();
  final List<Map<String, String>> _mensajes = [
    {"sender": "ia", "text": "Esperando orden... (Ej: 'Dame un fondo místico para orar')"}
  ];

  // PEGA TU API KEY DE GOOGLE ACÁ ADENTRO DE LAS COMILLAS:
  final String _apiKey = "AIzaSyAPaODUcSkAsjUzbS9YXIM9HMuCSDLaFQg"; 

  Future<void> _enviarComando() async {
    final textoUsuario = _comandoController.text.trim();
    if (textoUsuario.isEmpty) return;

    setState(() {
      _mensajes.add({"sender": "user", "text": textoUsuario});
      _mensajes.add({"sender": "ia", "text": "Pensando y diseñando la estructura musical..."});
    });
    _comandoController.clear();

    try {
      final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey");
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Actúa como un experto productor musical y director de atmósferas. El usuario te va a pedir un tipo de música, pista o sonido. Tu tarea es responder brevemente confirmando qué instrumentos vas a activar (ej: pads, pianos, strings, ritmos), la velocidad (BPM) y el tono ideal para lograr lo que te pide. El usuario te pidió: $textoUsuario"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final respuestaIA = data['candidates'][0]['content']['parts'][0]['text'];
        
        setState(() {
          _mensajes.removeLast(); // Quita el mensaje de "Pensando..."
          _mensajes.add({"sender": "ia", "text": respuestaIA});
        });
      } else {
        setState(() {
          _mensajes.removeLast();
          _mensajes.add({"sender": "ia", "text": "Error al conectar con el cerebro musical. Revisá tu API Key."});
        });
      }
    } catch (e) {
      setState(() {
        _mensajes.removeLast();
        _mensajes.add({"sender": "ia", "text": "Hubo un problema de conexión."});
      });
    }
  }

  void _botonPanico() {
    setState(() {
      _mensajes.add({
        "sender": "ia", 
        "text": "¡MUTE TOTAL! Sonido apagado por seguridad."
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente de Música Funcional'),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: ListView.builder(
                  itemCount: _mensajes.length,
                  itemBuilder: (context, index) {
                    final msg = _mensajes[index];
                    final isUser = msg["sender"] == "user";
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF2C3E50) : const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(12.0).copyWith(
                            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
                            bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                          ),
                          border: Border.all(
                            color: isUser ? Colors.blueGrey.shade600 : Colors.grey.shade700,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          msg["text"] ?? "",
                          style: TextStyle(
                            fontSize: 16, 
                            color: isUser ? Colors.white : Colors.white70,
                            height: 1.4
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _botonPanico,
                child: const Text(
                  'BOTÓN DE PÁNICO (MUTE)', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comandoController,
                    decoration: InputDecoration(
                      hintText: 'Escribí qué atmósfera necesitás...',
                      fillColor: const Color(0xFF1E1E1E),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF1DB954),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _enviarComando,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
