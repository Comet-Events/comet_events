import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/db.dart';

class EventService extends DatabaseService {
  
  Future<void> addNewEvent(Event event) async {
    await eventsCollection.document().setData(event.toJson());
  }

  Future<void> updateEvent(String id, Event updatedEvent) async {
    await eventsCollection.document(id).updateData(updatedEvent.toJson());
  }
  
}