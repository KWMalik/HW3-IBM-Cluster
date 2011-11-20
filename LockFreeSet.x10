public class LockFreeSet {
	
	
	// May want to use this node class 
	public static class Node { 
		var key:Int; 
		var next:Node;
		var marked:Boolean;
			
		def this(k:Int, n:Node ) { 
			key = k;
			next = n;
			marked = false; 
		}
	}
	

	def this() {
		
	}
	
	
	public def add(key:Int) : Boolean {
		/* Change Me*/
		return false; 

	}
	
	
	public def remove(key:Int) : Boolean { 
		/* Change Me*/
		
		return false; 
		
	}
	
	
	public def contains(key:Int) : Boolean { 
		
		/* Change Me*/
		return false; 
		
	}
	
	
	
	public static def main( args:Array[String] ) {
	
	}

}