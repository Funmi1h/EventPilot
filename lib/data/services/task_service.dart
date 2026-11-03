import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/task_model.dart';

class TaskService {
//ajouter une tache
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await supabase
        .from('tasks')
        .insert(task.toJson())
        .select()
        .single();

    return TaskModel.fromJson(response);//genre on converrtit le json de supabase en dart 
  }

  // récupérer les taches d'un événement triées par due_date
  Future<List<TaskModel>> getTasksByEvent(String eventId) async {
    final response = await supabase
        .from('tasks')
        .select()
        .eq('event_id', eventId)
        .order('due_date', ascending: true);//genre la date la plus ancienne etainsi de suite jusqua la derniere tache 

    return (response as List)
        .map((json) => TaskModel.fromJson(json)) 
        .toList();
  }

  // mettre à jour une tâche ou son statut
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    //  date de modification
    data['updated_at'] = DateTime.now().toIso8601String();
    await supabase.from('tasks').update(data).eq('id', taskId);
  }

  // supprimer une tâche
  Future<void> deleteTask(String taskId) async {
    await supabase.from('tasks').delete().eq('id', taskId);
  }
}