import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/participant_model.dart';

class ParticipantService {
  //creer un participant
  Future<ParticipantModel> createParticipant(ParticipantModel participant) async {
    try {
      final response = await supabase
          .from('participants')
          .insert(participant.toJson())
          .select()
          .maybeSingle();

      if (response != null) {
        return ParticipantModel.fromJson(response);
      }
    } catch (_) {
      try {
        await supabase.from('participants').insert(participant.toJson());
      } catch (_) {}
    }

    return participant;
  }

  //recuperer tous les participants d'un evenement
  Future<List<ParticipantModel>> getParticipantsByEvent(String eventId) async {
    final response = await supabase
        .from('participants')
        .select()
        .eq('event_id', eventId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ParticipantModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  //mettre a jour le statut du participant
  Future<void> updateParticipantStatus(String participantId, String status) async {
    await supabase.from('participants').update({
      'registration_status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', participantId);
  }

  //supprimer un participant
  Future<void> deleteParticipant(String participantId) async {
    await supabase.from('participants').delete().eq('id', participantId);
  }
}

