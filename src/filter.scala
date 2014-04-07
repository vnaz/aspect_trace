import scala.io.Source
import scala.collection.mutable.Map

val map = Map[String, Map[String, Int]]()
val fileName = "d:\\X.txt"
val src = Source.fromFile(fileName)

var path = new Array[String](500)
var depth = 0

var pdepth = 0

for(line <- src.getLines()){
  depth = line.indexOf("-> ")
  val pkg_method = line.substring(line.indexOf("-> ")+3, line.lastIndexOf("("))
  //val tmp = pkg_method.split("[.](?=[^.]+[.][^.]+[(])")
  //val (pkg:String, method:String) = if (tmp.length == 2) { (tmp(0), tmp(1)) } else { ("", pkg_method) }
  val (pkg:String, method:String) = pkg_method.splitAt(pkg_method.lastIndexOf("."))
  
  path(depth) = line
  
  val cnt = map.getOrElseUpdate(pkg, Map()).getOrElseUpdate(method, 0) + 1
  map(pkg)(method) = cnt
  
  
  
  /* // Print interested classes
  if (depth < pdepth) { pdepth = depth }
  
  if (pkg == "de.hybris.bootstrap.config.ExtensionInfo"){
      for (i <- pdepth to depth-1) { println( path(i) ) }
      println(line)
      
      pdepth = depth
  }*/
}


for ( (pkg, value) <- map.toList.sortBy( _._1 ) ) { 
  printf("%s:\n", pkg)
  for ( (method, num) <- value.toList.sortBy( _._2 ).reverse){
    printf("    -> %010d - %s\n", num, method)
  }
  println
}

src.close()
