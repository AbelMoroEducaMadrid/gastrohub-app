import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart'; // Para copiar al portapapeles
import 'package:gastrohub_app/src/features/restaurant/providers/invitation_provider.dart';

class InvitationScreen extends ConsumerStatefulWidget {
  const InvitationScreen({super.key});

  @override
  ConsumerState<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends ConsumerState<InvitationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invitationNotifierProvider.notifier).loadInvitationCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invitationAsync = ref.watch(invitationNotifierProvider);

    return Scaffold(
      body: invitationAsync.when(
        data: (code) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Código de Invitación',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    code,
                    style: const TextStyle(
                        fontSize: 32,
                        letterSpacing: 6,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Código copiado al portapapeles')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QrImageView(
                    data: code,
                    version: QrVersions.auto,
                    size: 300.0,
                    gapless: true,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          'Error al generar el QR',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(invitationNotifierProvider.notifier)
              .regenerateInvitationCode();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
