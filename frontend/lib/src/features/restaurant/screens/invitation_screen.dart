import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              Text(
                code,
                style: const TextStyle(
                    fontSize: 32, letterSpacing: 2, color: Colors.black87),
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
