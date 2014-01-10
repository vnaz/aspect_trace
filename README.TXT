to make sources compilation you need: 
aspectjrt.jar and groovy.jar

aspectjrt.jar <- c:\aspectj1.7\lib\aspectjrt.jar;
groovy.jar    <- c:\groovy-2.2.1\embeddable\groovy-all-2.2.1-indy.jar

before run agent you should modify CLASSPATH, example:
SET CLASSPATH=%CLASSPATH%;aspectjrt.jar;X.jar;groovy.jar;

run agent:
-javaagent:c:\aspectj1.7\lib\aspectjweaver.jar -Dorg.aspectj.weaver.loadtime.configuration="myaop.xml"

run agent verbose:
-javaagent:c:\aspectj1.7\lib\aspectjweaver.jar -Dorg.aspectj.weaver.loadtime.configuration="myaop.xml" -Dorg.aspectj.weaver.showWeaveInfo=true -Daj.weaving.verbose=true 