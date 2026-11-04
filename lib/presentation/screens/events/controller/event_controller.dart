import 'package:get/get.dart';
import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/data/services/event_service.dart';

class EventController extends GetxController {
  final EventService _eventService = EventService();

  //la liste observable des evenements et l'indicateur de chargement
  var events = <EventModel>[].obs;
  var isLoading = false.obs;

  //l'evenement actuellement selectionne
  var selectedEvent = Rxn<EventModel>();

  @override
  void onInit() {
    super.onInit();
    fetchEvents(); //on charge les evenements au demarrage
  }

  //charger les evenements de l'organisateur connecte
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final fetched = await _eventService.getEvents();
      events.assignAll(fetched); //on met a jour la liste locale
      if (events.isNotEmpty && selectedEvent.value == null) {
        selectedEvent.value = events.first;
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les événements : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //choisir un evenement pour le tableau de bord
  void selectEvent(EventModel event) {
    selectedEvent.value = event;
  }

  //ajouter un nouvel evenement dans supabase
  Future<bool> addEvent({
    required String name,
    required String type,
    String? description,
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
        Get.snackbar(
          'Erreur',
          'Vous devez être connecté.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
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
      events.insert(0, created); //on ajoute en tete de liste
      selectedEvent.value = created;

      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la création : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //modifier un evenement dans supabase
  Future<bool> updateEventDetails({
    required String eventId,
    required String name,
    required String type,
    String? description,
    required String location,
    required double budget,
    required bool isPaid,
    required double ticketPrice,
  }) async {
    try {
      isLoading.value = true;
      final updateData = {
        'name': name,
        'event_type': type,
        'description': description,
        'location': location,
        'initial_budget': budget,
        'is_paid': isPaid,
        'participation_fee': ticketPrice,
      };

      await _eventService.updateEvent(eventId, updateData);

      //on met a jour l'objet directement en memoire
      final index = events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        final current = events[index];
        current.name = name;
        current.type = type;
        current.description = description;
        current.location = location;
        current.budget = budget;
        current.isPaid = isPaid;
        current.ticketPrice = ticketPrice;
        events.refresh();
      }

      Get.snackbar(
        'Succès',
        'Événement modifié avec succès !',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de modifier l\'événement : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //supprimer un evenement dans supabase et dans la liste
  Future<void> removeEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      events.removeWhere((e) => e.id == eventId); //on retire de la liste locale
      if (selectedEvent.value?.id == eventId) {
        selectedEvent.value = events.isNotEmpty ? events.first : null;
      }
      Get.snackbar(
        'Succès',
        'Événement supprimé.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }
}
