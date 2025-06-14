import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/services/invitation_service.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class InvitationNotifier extends StateNotifier<AsyncValue<String>> {
  final InvitationService _invitationService;
  final String _token;
  final Ref _ref;

  InvitationNotifier(this._invitationService, this._token, this._ref)
      : super(const AsyncValue.loading()) {
    loadInvitationCode();
  }

  Future<void> loadInvitationCode() async {
    try {
      state = const AsyncValue.loading();
      final code = await _invitationService.getInvitationCode(_token);
      state = AsyncValue.data(code);
    } catch (e, stack) {
      AppLogger.error('Failed to load invitation code: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> regenerateInvitationCode() async {
    try {
      final newCode = await _invitationService.regenerateInvitationCode(_token);
      state = AsyncValue.data(newCode);
    } catch (e) {
      AppLogger.error('Failed to regenerate invitation code: $e');
    }
  }
}

final invitationServiceProvider = Provider<InvitationService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return InvitationService(baseUrl: baseUrl);
});

final invitationNotifierProvider =
    StateNotifierProvider<InvitationNotifier, AsyncValue<String>>((ref) {
  final invitationService = ref.watch(invitationServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return InvitationNotifier(invitationService, token, ref);
});