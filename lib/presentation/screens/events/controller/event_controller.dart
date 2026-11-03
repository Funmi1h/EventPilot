import 'package:get/get.dart';
import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/data/services/event_service.dart';

class EventController extends GetxController {
  final EventService _eventService = EventService();

  var events = <EventModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents(); // Charge les événements au démarrage
  }

  // la liste des événements
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final fetched = await _eventService.getEvents();
      events.assignAll(fetched); // Met à jour la liste observable
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les cérémonies : $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ajouter un nouvel événement
  Future<bool> addEvent({
    required String name,
    required String type,
    String? description, //lui il peut etre nulle
    required DateTime date,
    required String time,
    required String location,
    required double budget,
    bool isPaid = false,
    double ticketPrice = 0.0,
  }) async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar('Erreur', 'Vous devez être connecté.');
        return false;
      }

      final newEvent = EventModel(
        userId: user.id,
        name: name,
        type: type,
        description: description,
        date: date,
        time: time,
        location: location,
        budget: budget,
        isPaid: isPaid,
        ticketPrice: ticketPrice,
      );

      final created = await _eventService.createEvent(newEvent);
      events.add(created); //on ajoute a la liste locale

      Get.snackbar('Succès', 'Cérémonie créée avec succès !');
      return true;
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de la création : $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // supprimer un événement
  Future<void> removeEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      events.removeWhere((e) => e.id == eventId);
      Get.snackbar('Succès', 'Événement supprimé.');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer : $e');
    }
  }
}