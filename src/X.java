import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;

import javax.swing.JFrame;
@Aspect
public class X extends SecurityManager {
	
	java.io.PrintWriter pw = null;
	groovy.ui.Console console=null;
	groovy.lang.GroovyShell shell = null; 
	
	public ArrayList<groovy.lang.GroovyCallable<Void>> listeners = new ArrayList<groovy.lang.GroovyCallable<Void>>();
	
	public ArrayList<String> some = new ArrayList<String>(); 
	
	X(){
		try{
			pw = new java.io.PrintWriter("D:\\X.txt");
			
			console = new groovy.ui.Console();
			console.run();
			shell = console.getShell();
			shell.setVariable("X", this);
			
			((JFrame)console.getFrame()).addWindowListener(new WindowAdapter() {
				@Override
				public void windowClosed(WindowEvent paramWindowEvent) {
					synchronized (console) {
						console.notifyAll();
					}
					super.windowClosed(paramWindowEvent);
				}
			});
			
			//Thread to prevent exiting before script console closed
			Thread thread = new Thread(){
				public void run() {
					synchronized (console) {
						try {
							console.wait();
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
					}
				};
			};
			thread.setDaemon(false);
			thread.start();
			
		}catch(Exception e){ e.printStackTrace(); }
	}
	
	public void   listen(groovy.lang.GroovyCallable<Void> listener){ listeners.add(listener); }
	public void nolisten(groovy.lang.GroovyCallable<Void> listener){ listeners.remove(listener); }
	
	public void callHandler(){
		for(groovy.lang.GroovyCallable<Void> listener: listeners){
			try {
				listener.call();
			} catch (Exception e) {
				synchronized (console) { console.notifyAll(); }
				e.printStackTrace();
			}
		}
	}
	
	
	
	@AfterReturning(pointcut="call(java.io.File.new(..))", returning="f")
	public void newfile(JoinPoint thisJoinPoint, java.io.File f){
		pw.println(f.getPath());
		pw.println("-> " + thisJoinPoint.getSourceLocation() );
		//pw.println("-> " + thisEnclosingJoinPointStaticPart.getSignature());
		//callHandler();
		some.add(f.getPath());
	}
	
	
	@Before("call(* java.lang.System.exit(*))")
	public void exit(){
		synchronized(console){
			try {
				if ( console!=null && ((JFrame)console.getFrame()).isVisible() ){
					console.wait();
				}
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		System.out.println("injected Exit");
	}
}
