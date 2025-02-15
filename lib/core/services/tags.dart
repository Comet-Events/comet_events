import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comet_events/core/objects/objects.dart';
import 'package:comet_events/core/services/services.dart';

class TagsService extends DatabaseService {

  List<Tag> _categories = [];
  List<Tag> get categories => _categories;

  TagsService() {
    fetchCategories().then((c) { _categories = c; });
  }

  Future<List<Tag>> fetchCategories({bool orderByPopularity = true}) async {
    if(categories.length > 0) return categories;
    QuerySnapshot snapshot;
    try {
    if(orderByPopularity) {
      snapshot = await tagsCollection
        .where('category.category', isEqualTo: true)
        .orderBy('popularity', descending: true)
        .getDocuments();
    } else {
      snapshot = await tagsCollection
        .where('category.category', isEqualTo: true)
        .getDocuments();
    }
    } catch (err) {
      print(err);
    }
    _categories = snapshot != null ? snapshot.documents.map((e) => Tag.fromJson(e.data)).toList() : [];
    return categories;
  }

  Future<void> incrementCategories(List<String> categories) async {
    WriteBatch batch = db.batch();
    categories.forEach((category) {
      batch.updateData(tagsCollection.document(category), {"popularity": FieldValue.increment(1)});
    });
    await batch.commit();
  }
  Future<void> incrementTags(List<String> tags) async {
    WriteBatch batch = db.batch();
    tags.forEach((tag) {
      print(tag);
      batch.setData(tagsCollection.document(tag), {"name": tag, "popularity": FieldValue.increment(1)}, merge: true);
    });
    await batch.commit();
  }

}