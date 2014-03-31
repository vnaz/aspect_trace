import java.io.PrintWriter;

public aspect X {
	PrintWriter pw = null;
	
	StackTraceElement[] prevStack;
	
	
	void printStack(){
		StackTraceElement[] stack = java.lang.Thread.currentThread().getStackTrace();
			
		int indent = 0;
		int i = stack.length-1;
		
		if (prevStack != null){
			int j = prevStack.length-1;
			while ( i>=0 && j>=0 && prevStack[j].equals(stack[i]) ){ i--; j--; indent++;}
		}
		
		int j=0;
		while (i>2){
			for (j=0; j<indent; j++){ pw.print(" "); }
			pw.println( "-> " + stack[i].toString() );
			i--; indent++;
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
