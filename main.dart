import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFF121212), // Fondo oscuro estilo Spotify
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
  String _estadoIa = "Esperando orden... (Ej: 'Dame un fondo místico para orar')";

  void _enviarComando() {
    setState(() {
      if (_comandoController.text.isNotEmpty) {
        _estadoIa = "Procesando atmósfera: '${_comandoController.text}'...\nBuscando sonidos premium de alta calidad...";
        _comandoController.clear();
      }
    });
  }

  void _botonPanico() {
    setState(() {
      _estadoIa = "¡MUTE TOTAL! Sonido apagado por seguridad.";
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pantalla de Estado de la IA
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Center(
                  child: Text(
                    _estadoIa,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botón de Pánico (Mute)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _botonPanico,
                child: const Text('BOTÓN DE PÁNICO (MUTE)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),

            // Cuadro de texto y envío abajo
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
