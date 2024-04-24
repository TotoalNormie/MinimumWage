extends Node

#var collection: FirestoreCollection = Firebase.Firestore.collection("PowerUps")
#var document = await collection.get_doc().get_document
func _ready():
	var query: FirestoreQuery = FirestoreQuery.new()
	query.from('PowerUps')

	var query_task: FirestoreTask = Firebase.Firestore.query(query)
	var result: Array = await query_task.task_finished

	print(result)
