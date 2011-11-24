
public class Xanadu{

       public static def main(args:Rail[String]){
       
      
       finish async {
       val c1 = Clock.make(), c2 = Clock.make(), c3 = Clock.make(),
       c4 = Clock.make();

      // Activity A
      async clocked(c1, c2){
      c1.resumeAll();
      c2.resumeAll();
      c1.advanceAll();
      c2.advanceAll();
      atomic Console.OUT.println("Kubla Khan");
      c1.drop();
      }

      // Activity B 
   	      async clocked(c2,c3) {
	      c2.resume();
	      c3.resume();
	      c2.advance();
	      c3.advance();
	      c2.advance();
	      c3.advance();
	      c2.advanceAll();
	     // Clock.advanceAll(); 
	      atomic Console.OUT.println("Stately pleasure-dome decree :");
	      Clock.resumeAll();
	      c2.advance();
	      c2.advance();
	      Clock.resumeAll();
	      c3.advanceAll();
	      c3.drop();
	      c2.advance();
	      atomic Console.OUT.print("Down to the "); 
}      





      //Activity C
      async clocked (c3,c4){
      	    atomic Console.OUT.print("In Xanadu did ");
	    c4.resumeAll();
	    c3.resumeAll();
	    c4.advance();
	    c3.advance();
	    Clock.resumeAll();
	    Clock.resumeAll();
	    Clock.resumeAll();
	    c3.advanceAll();
	    c3.advance();
	    c4.advance();
	    Clock.resumeAll();
	  c3.advanceAll();
	   c3.drop();
	   c4.advance();
	   atomic Console.OUT.println("Through caverns measureless to man ");
	   
	    }






      // Activity D
      async clocked(c1, c4){
      c4.advanceAll();
      c1.advanceAll();
      Clock.resumeAll();
      Clock.resumeAll();
      Clock.advanceAll();
      atomic Console.OUT.println("Where Alph, the sacred river, ran");
      Clock.resumeAll();
      c1.advance();
      c4.drop();
      c1.advance();
      c1.advance();
      c1.resume();
      c1.resume();
      c1.resume();
      c1.resume();
      c1.advance();
      c1.advance();
      c1.advance();
      c1.advance();
      c1.advance();
      atomic Console.OUT.println("sunless sea.");

      }
            
      
      

      }
      




       }







}