import java.io.FileNotFoundException;
import java.util.HashMap;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;

@Aspect
public class Y {
	
	java.io.PrintWriter pw_calls = null;
	
	HashMap<String, Integer> hm = new HashMap<String, Integer>(); 
	
	public String escape(String in){
		return "\"" + in.replace("\"", "\"\"") + "\"";
	}
	
	Y(){
		try {
			pw_calls = new java.io.PrintWriter("D:\\calls.txt");
			pw_calls.println("fle,cls,mtd,args,bt");
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
	}
	
	@AfterReturning(pointcut="call(java.io.File.new(..))", returning="f")
	public void newfile(JoinPoint thisJoinPoint, java.io.File f){
		
		String fle = f.getPath();
		
		String loc = thisJoinPoint.getSourceLocation().toString();
		
		String cls = thisJoinPoint.getSourceLocation().getClass().getName();
		String mtd = thisJoinPoint.getSignature().toString();
		String args = "";
		String bt = "";
		
		boolean first=true;
		for(Object o : thisJoinPoint.getArgs()){
			if (first) { first=false; } else { args += ", "; }
			args += o.toString();
		}
		
	    int i = 0;
        for ( StackTraceElement frame : Thread.currentThread().getStackTrace()){
              bt += (i++) + ". " + frame.toString() + "\n";
        }
		
		pw_calls.printf("%s,%s,%s,%s,%s\n", escape(fle), escape(cls), escape(mtd), escape(args), escape(bt) );
		
		if (!hm.containsKey(loc)){
			hm.put(loc, 1);
		}
		
	}

}
