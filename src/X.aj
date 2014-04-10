import java.io.PrintWriter;

public aspect X {
	PrintWriter pw = null;
	
	StackTraceElement[] prevStack;
	
	X(){
		try{
			pw = new PrintWriter("D:\\X.txt");
		}catch(Exception e){ e.printStackTrace(); }
	}
	
	boolean checkPrint(StackTraceElement it){
	    return true;
	    /*if ( it.getClassName().contains("de.hybris") ){
	        return true;
	    }
	    return false;*/
	}
	
	void printStack(){ 
		StackTraceElement[] stack = java.lang.Thread.currentThread().getStackTrace();
		
		int indent = 0;
		
		int i = stack.length-1;
		
		if (prevStack != null){
			int j = prevStack.length-1;
			while ( i>=0 && j>=0 && prevStack[j].equals(stack[i]) ){ i--; j--; if(checkPrint(stack[i+1])){ indent++; } }
		}
		
		int j=0;
		while (i>2){
		    if ( checkPrint(stack[i]) ){
                for (j=0; j<indent; j++){ pw.print(" "); }
                pw.println( "-> " + stack[i].getClassName() + "." + stack[i].getMethodName() );
                indent++;
            }
            i--; 
		}
		
		pw.flush();
		prevStack = stack;
	}
	
	//File tracing
	after() returning(java.io.File f): call(java.io.File.new(..)){
	   String fle = f.getAbsolutePath();
	   if (fle.contains("-items.xml") || fle.contains("-beans.xml") || fle.contains("-spring.xml")){
	       
	       //printStack();
	       
	       pw.println(fle);
	       pw.flush();
	   }
	}
	
	//methods inside package tracing
	before(): call(* de.hybris..*(..)) {
		printStack();
	}
	
	
	
	/* // ANT STUFF
	// ---------	
	int[] antStack = new int[50000];
	int pAntStack = 0; 
	
	before() : execution( void org.apache.tools.ant.Target.execute() ){
	    try {
            Object o = thisJoinPoint.getThis();
            antStack[pAntStack] = o.hashCode(); pAntStack++;
            
            String name = String.valueOf( o.getClass().getMethod("getName", new Class[]{}).invoke(o, new Object[]{}) );
            
            Object loc = o.getClass().getMethod("getLocation", new Class[]{}).invoke(o, new Object[]{});
            String fname = String.valueOf( loc.getClass().getMethod("getFileName", new Class[]{}).invoke(loc, new Object[]{}) );
            String fline = String.valueOf( loc.getClass().getMethod("getLineNumber", new Class[]{}).invoke(loc, new Object[]{}) );
            
            for (int i=0; i<pAntStack; i++){ pw.print(" "); } 
            pw.println("-> Target: " + name + " - " + fname + ":" + fline);
            pw.flush();
        }catch(Exception e) { e.printStackTrace(); }
	}
	
	after() : execution( void org.apache.tools.ant.Target.execute() ){
	    int o = thisJoinPoint.getThis().hashCode();
	    if (pAntStack>0 && antStack[pAntStack-1] == o ){ pAntStack--; }
	}
	
	before() : execution( void org.apache.tools.ant.Task.perform() ){
	    try{
            Object o = thisJoinPoint.getThis();
            antStack[pAntStack] = o.hashCode(); pAntStack++;
            
            String name = o.getClass().getMethod("getTaskName", new Class[]{}).invoke(o, new Object[]{}).toString();
            
            // String type = "?";
            // try{
            //     Object w = o.getClass().getMethod("getWrapper", new Class[]{}).invoke(o, new Object[]{});
            //     Object map = w.getClass().getMethod("getAttributeMap", new Class[]{}).invoke(w, new Object[]{});
            //     Object val = map.getClass().getMethod("get", new Class[]{ java.lang.Object.class }).invoke(map, new Object[]{ "class" });
            //     if (val != null) { type = val.toString(); }
            // }catch(Exception e){ e.printStackTrace(); }
            // String type = o.getClass().toString();
            
            Object loc = o.getClass().getMethod("getLocation", new Class[]{}).invoke(o, new Object[]{});
            String fname = String.valueOf( loc.getClass().getMethod("getFileName", new Class[]{}).invoke(loc, new Object[]{}) );
            String fline = String.valueOf( loc.getClass().getMethod("getLineNumber", new Class[]{}).invoke(loc, new Object[]{}) );
            
            
            for (int i=0; i<pAntStack; i++){ pw.print(" "); } 
            pw.println("-> Task: " + name + " - " + fname + ":" + fline );
            pw.flush();
        }catch(Exception e){ e.printStackTrace(); }
	}
	
	after() : execution( void org.apache.tools.ant.Task.perform() ){
	    int o = thisJoinPoint.getThis().hashCode();
	    if (pAntStack>0 && antStack[pAntStack-1] == o ){ pAntStack--; }
	}*/
}
