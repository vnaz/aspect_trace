import java.io.PrintWriter;

public aspect X {
	PrintWriter pw = null;
	
	StackTraceElement[] prevStack;
	
	boolean checkPrint(StackTraceElement it){
	    if ( it.getClassName().contains("de.hybris") ){
	        return true;
	    }
	    return false;
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
	
	X(){
		try{
			pw = new PrintWriter("D:\\X.txt");
		}catch(Exception e){ e.printStackTrace(); }
	}
	
	before(): call(* de.hybris..*(..)) {
		printStack();
	}
}
