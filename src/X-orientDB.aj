import com.orientechnologies.orient.core.db.document.ODatabaseDocumentTx;
import com.orientechnologies.orient.core.record.impl.ODocument;

public aspect X {
	ODatabaseDocumentTx db;

	ODocument[] prevDocs;
	StackTraceElement[] prevStack;
	
	final String ORIENTDB_URI = "plocal:./orientDB";
	final String ORIENTDB_USER = "admin";
	final String ORIENTDB_PASS = "admin";
	
	void saveStack(){
		StackTraceElement[] stack = java.lang.Thread.currentThread().getStackTrace();
		ODocument[] docs = new ODocument[stack.length];
		
		int i = stack.length-1;
		
		if (prevStack != null){
			int j = prevStack.length-1;
			while ( i>=0 && j>=0 && prevStack[j].equals(stack[i]) ){
				docs[i] = prevDocs[j];
				i--; j--;
			}
		}
		
		ODocument parent = null;
		while (i>2){
			ODocument doc = new ODocument("StackElement");
			doc.field( "name", stack[i].toString() );
			doc.field( "parent", parent);
			doc.save();
			
			docs[i] = doc;
			parent = doc;
			i--; 
		}
		
		prevStack = stack;
		prevDocs = docs;
	}
	
	X(){
		ODatabaseDocumentTx db = new ODatabaseDocumentTx(ORIENTDB_URI);
		try {
			db.open(ORIENTDB_USER, ORIENTDB_PASS);
		} catch (Exception e) {
			db.create();
		}
	}
	
	before(): call(* de.hybris..*(..)){
		saveStack();
	}
	
	before(): call(* java.lang.System.exit(*)){
		if (db!=null){
			db.close();
		}
	}
	
}
