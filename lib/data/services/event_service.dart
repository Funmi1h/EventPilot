import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/event_model.dart';

class EventService {
  //creer un evenement dans supabase
  Future<EventModel> createEvent(EventModel event) async {
    final response = await supabase
        .from('events')
        .insert(event.toJson())
        .select()
        .single();

    final created = EventModel.fromJson(response);
    if (created.id != null && created.id!.isNotEmpty) {
      final generatedUrl = 'http://localhost:8080/#/public/event?id=${created.id}';
      try {
        await supabase.from('events').update({'public_url': generatedUrl}).eq('id', created.id!);
        created.publicLink = generatedUrl;
      } catch (_) {}
    }

    return created;
  }

  //recuperer tous les evenements de l'organisateur connecte
  Future<List<EventModel>> getEvents() async {
    final user = supabase.auth.currentUser;
    var query = supabase.from('events').select();
    
    //si l'utilisateur est connecte on recupere ses evenements
    if (user != null) {
      query = query.eq('organizer_id', user.id);
    }

    final response = await query
        .order('created_at', ascending: false)
        .timeout(const Duration(seconds: 8));

    return (response as List)
        .map((json) => EventModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  //recuperer un evenement specifique par son id
  Future<EventModel> getEventById(String eventId) async {
    final response = await supabase
        .from('events')
        .select()
        .eq('id', eventId)
        .single();

    return EventModel.fromJson(response);
  }

  //mettre a jour un evenement
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await supabase.from('events').update(data).eq('id', eventId);
  }

  //supprimer un evenement
  Future<void> deleteEvent(String eventId) async {
    await supabase.from('events').delete().eq('id', eventId);
  }
}
