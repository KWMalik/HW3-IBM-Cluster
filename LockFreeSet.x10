import x10.util.concurrent.AtomicReference;

public class LockFreeSet {
	
	
	var head:AtomicReference[Node];
	var tail:AtomicReference[Node];
	var sentinel:Node;

	
	// May want to use this node class 
	public static class Node { 
		var key:Int; 
		var next:Node;
		var prev:Node;
		var marked:Boolean;
			
		def this(k:Int, n:Node ) { 
			key = k;
			next = n;
			prev = null;
			marked = false; 
		}
		
		def this(){
			key = Int.MAX_VALUE;
			next = null;
			prev = null;
			marked = false;
		}
		
		public def printNode(){
			Console.OUT.println("<"+key+ ","+marked+ ">");
		}
		
	}
	
	/*
	 * Note: The nodes in the list are ordered by their keys;
	 * 
	 */
	
	

	
	def this() {
		sentinel = new Node();
		sentinel.key = -1;
		head = new AtomicReference[Node]();
		head.set(sentinel);
		
	}
	
	// Returns true if list is empty
	public def isEmpty():Boolean{
		
		return head == null;
	}
	/*
	adds an item to the set if it is not present
	 returns true on success and fail on failure
	 * 
	 */
	public def add(key:Int) : Boolean {
		/* Change Me*/
	
		var node:Node = new Node(key,null);
		var currentRef:Node = head.get();
		var added:Boolean = true;
		var atomRef:AtomicReference[Node] = new AtomicReference[Node]();
		
		while(added){
			
			if(contains(key)){
				return false;
			}
			atomRef.set(node);
			
			if (casHead(head.get(), node)){
				return true;
			}
			
			
		}
		
		return false; 

	}
	
	private atomic def casHead(oldVal:Node, newVal:Node):Boolean{
		
		var headNode:Node = head.get();
		if(head.get() == oldVal && headNode.marked != true){
			newVal.next = headNode;
			head.set(newVal);
			return true;
		}
		
		return false;
		
	}
	
	private atomic def casSet(oldVal:Node, newVal:Node):Boolean{
		
		var oldRef:AtomicReference[Node] = new AtomicReference[Node]();
		var newRef:AtomicReference[Node] = new AtomicReference[Node]();
		oldRef.set(oldVal.next);
		newRef.set(newVal.next);

		if(newRef != oldRef){
			oldVal.next = newVal.next;
			return true;
		}
		
		return false;
		
	}
	
	public def insert(key:Int):Boolean{
		
		var added:Boolean = true;
		var current:Node = head.get();
		var prev:Node = new Node();
		var next:Node = new Node();
		var node:Node = new Node(key,null);
		
		
		while(added){
			
			if(contains(key)){
				added = false;
				return added;
			}
			
			
			while(current != null){
				
				if(current.key < key && current.next == null ){						
						Console.OUT.println(current.key);
						Console.OUT.println("Loop One");
				}else if(current.key < key && current.next.key > key){	
						Console.OUT.println(current.key);
						Console.OUT.println("Loop Two");

				}
				if(current != null){
				prev = current;
				}
				else if(current.next != null){
					next = current.next;
				}
				
				current = current.next;
				
			}
			
			return false;
			
			
		}// end while
		
		return false;
		
		
		
		
	}

	
	/*
	 * remover() removes a node if present, returns
	 * true on success and false on failure. 
	 * 
	 */
	
	public def remove(key:Int) : Boolean { 

		
		/* See if we are at end of list. */
		var currP:Node = new Node();
		var prevP:Node = new Node();
		var dummy:Boolean = false;
		
		/* For 1st node, there is not previous */
		prevP = null;
		
		/* 
		 * Visit each node, maintaining a reference to 
		 * the previous node we just visited.
		 * 
		 */
		
		if(!contains(key)) return false;
		
		for(currP = head.get(); currP != null; currP = currP.next){
			
			if(currP.key == key){// Found Element
				if(prevP == null){
					/* Fix Head of List */
					casHead(head.get(),currP.next);
				}else{
					/*
					 * Fix previous node's next to skip
					 * over the removed node.
					 */
					if(casSet(prevP,currP)){	
						dummy = false;
						return dummy;
					}
					
					
					
					
				}
				
			}
			prevP = currP;

		}// end for
		
		return false;
		
		
	}
	
	public def printSet(){
		
		var current:Node = head.get();
		
		Console.OUT.println("The Set Contains: ");

		while(current != null){
			current.printNode();
			current = current.next;
		}
		
		Console.OUT.println();		
	}
	
	/*
	 * contains() returns true if the item is present 
	 * and false if not present
	 * 
	 */
	
	public def contains(key:Int) : Boolean { 
		
		var current:Node = head.get();
		
		
		while(current != null){
			
			if (current.key == key){
				return true;
			}
			else
				current = current.next;	
		}
		
		return false; 
		
	}
	
	
	
	public static def main( args:Array[String] ) {
	
		var list:LockFreeSet = new LockFreeSet();
		list.add(1);
		list.add(2);
		list.add(3);
		list.add(4);
		list.add(5);
		list.printSet();
		
		Console.OUT.println("Removing Element 4...");
		list.remove(4);
		Console.OUT.println("The list contains four: "+ list.contains(4));
		list.printSet();
	
		
	}




}