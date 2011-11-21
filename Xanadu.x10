public class Xanadu {

	public static def main(Array[String]) {
			
		finish async { 
			val c1 = Clock.make(), c2 = Clock.make(), c3 = Clock.make(), c4 = Clock.make() ; 
			
			// Activity A 
			async clocked(c1, c2) { 

			atomic Console.OUT.println("Kubla Khan");

			}
			
			// Activity B 
			async clocked(c2,c3) { 

			atomic Console.OUT.println("Stately pleasure-dome decree :"); 
			//	c3.resume();
			//	Console.OUT.print("Down to the "); 
			}
			
			// Activity C 
			async clocked (c3,c4) { 
			atomic	Console.OUT.print("In Xanadu did ");

			atomic	Console.OUT.println("Through caverns measureless to man");
			}
			
			// Activity D 
			async clocked (c1,c4) { 

			atomic	Console.OUT.println("Where Alph, the sacred river, ran");  

			atomic	Console.OUT.println("sunless sea. "); 
			}
		}	
	}
}