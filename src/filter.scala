import scala.io.Source
import scala.collection.mutable.Map

val fileName = "d:\\X.txt"

val map = Map[String, Int]()
var path = new Array[String](500)

var interested :List[String] = List[String]()

for( iter <- List(1,2) ){ // 1 - Collect information; 2 - Print interested;

  var depth = 0
  var pdepth = 0

  val src = Source.fromFile(fileName)
  for(line <- src.getLines()){
    val pkg_method = line.substring(line.indexOf("-> ")+3, line.lastIndexOf("("))
    
    if (iter == 1){
      // collecting calls count
      map(pkg_method) = map.getOrElseUpdate(pkg_method, 0) + 1
    }
    else if (iter == 2){
      //tracing stack
      depth = line.indexOf("-> ")
      path(depth) = line
      if (depth < pdepth) { pdepth = depth }
    
      // output
      if ( interested.contains(pkg_method) ) {
        //for (i <- pdepth to depth-2) { println( path(i) ) }
        println(line) //.replace("->", "->>"))
        
        pdepth = depth
      }
    }
  }
  src.close()
  
  //filtering interested calls
  if (iter == 1) { 
    val tmp =  map.toList.filter( _._2 < 5)
    
    val tmp2 = tmp.map( x => x._1.toString.split("[.](?=[^.]+$)").toList :+ x._2.toString )
    for ( (k,v) <- tmp2.groupBy( _(0) ).toList.sortBy( _._1 ) ) { 
      printf("%s\n  %s\n", k, v.sortBy( _(1) ).map( x => x(2)  + "x - " + x(1)).mkString("\n  ") )
    }
    println
    
    interested = tmp.map( _._1 )
  }
}
