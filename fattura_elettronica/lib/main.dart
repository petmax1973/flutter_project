import 'package:flutter/material.dart';

import 'models/fattura.dart';
import 'ui/fattura_view.dart';
import 'utils/xml_parser.dart';
import 'utils/folder_picker.dart';

void main() {
  runApp(const FatturaApp());
}

class FatturaApp extends StatelessWidget {
  const FatturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fattura Elettronica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // A strong premium blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily:
            'Inter', // A modern sans-serif font standard in Flutter (if available, otherwise fallback)
      ),
      home: const FatturaHomePage(),
    );
  }
}

class FatturaHomePage extends StatefulWidget {
  const FatturaHomePage({super.key});

  @override
  State<FatturaHomePage> createState() => _FatturaHomePageState();
}

class _FatturaHomePageState extends State<FatturaHomePage>
    with SingleTickerProviderStateMixin {
  Fattura? _fattura;
  String _errorMessage = '';

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final List<String> xmlContents = await pickFolderAndReadFiles();

      if (xmlContents.isNotEmpty) {
        Fattura? validFattura;
        
        for (var content in xmlContents) {
          if (content.isEmpty) continue;
          
          try {
            validFattura = FatturaXmlParser.parse(content);
            break; // Trovata! Fermiamo la ricerca
          } catch (e) {
            // Se non è una fattura, passiamo al prossimo file
            continue;
          }
        }

        if (validFattura != null) {
          setState(() {
            _fattura = validFattura;
            _errorMessage = '';
          });
          // Trigger presentation animation
          _animController.forward(from: 0.0);
        } else {
          setState(() {
            _fattura = null;
            _errorMessage = 'Nessuna FatturaPA valida trovata nella cartella selezionata.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Errore durante l'apertura o lettura della cartella: $e";
        _fattura = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lettore FatturaPA',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_fattura == null) ...[
                      const Icon(Icons.drive_folder_upload, size: 80, color: Colors.blueAccent),
                      const SizedBox(height: 24),
                      Text(
                        'Visualizza le tue Fatture Elettroniche',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Seleziona in maniera diretta l\'intera cartella (es. "19_03_2026") e il file corretto verrà estrapolato automaticamente!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 48),
                    ],
                    
                    Center(
                      child: FilledButton.icon(
                        onPressed: _pickFile,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.drive_folder_upload, size: 28),
                        label: const Text('Seleziona Cartella Fattura'),
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (_errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.red.shade900),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (_fattura != null)
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: FatturaView(fattura: _fattura!),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
