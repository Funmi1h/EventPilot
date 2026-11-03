import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/event_model.dart';

class EventService {

  //pour créer l'evenement 
  Future<EventModel> createEvent(EventModel event) async {
    final response = await supabase
        .from('events')
        .insert(event.toJson())//ici on convertit l'objet event dart en json compréhensible par supabase
        .select()
        .single();

    return EventModel.fromJson(response);
  }

  // récupérer tous les événements de l'utilisateur connecté
  Future<List<EventModel>> getEvents() async {
    final response = await supabase
        .from('events')
        .select()
        .order('date', ascending: true);

    return (response as List)
        .map((json) => EventModel.fromJson(json))
        .toList();
  }

  //récupérer les détails d'un événement par son id
  Future<EventModel> getEventById(String eventId) async {
    final response = await supabase
        .from('events')
        .select()
        .eq('id', eventId)
        .single();

    return EventModel.fromJson(response);
  }

  //mettre à jour un événement
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await supabase.from('events').update(data).eq('id', eventId);
  }

  // supprimer un événement
  Future<void> deleteEvent(String eventId) async {
    await supabase.from('events').delete().eq('id', eventId);
  }
}