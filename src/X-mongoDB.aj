import com.mongodb.MongoClient;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;


public aspect X {
	MongoClient mongoClient;

	DB db;
	DBCollection coll;
	
	DBObject[] prevDocs;
	StackTraceElement[] prevStack;
	
	void saveStack(){
		StackTraceElement[] stack = java.lang.Thread.currentThread().getStackTrace();
		DBObject[] docs = new BasicDBObject[stack.length];
		
		int i = stack.length-1;
		
		if (prevStack != null){
			int j = prevStack.length-1;
			while ( i>=0 && j>=0 && prevStack[j].equals(stack[i]) ){
				docs[i] = prevDocs[j];
				i--; j--;
			}
		}
		
		DBObject parent = null;
		while (i>2){
			DBObject doc = new BasicDBObject("name", "StackElement");
			doc.put("name", stack[i].toString() );
			doc.put("parent", parent);
			coll.insert(doc);
			
			docs[i] = doc;
			parent = doc;
			i--; 
		}
		
		prevStack = stack;
		prevDocs = docs;
	}
	
	X(){
		try {
			mongoClient = new MongoClient( "localhost" , 27017 );
			DB db = mongoClient.getDB( "mydb" );
			DBCollection coll = db.getCollection("testCollection");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	before(): call(* de.hybris..*(..)){
		saveStack();
	}
	
}
