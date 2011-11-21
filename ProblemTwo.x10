public class ProblemTwo{

       public static def main(Array[String]){
       
       var b:Int = 0;
        finish async {
                val c1 = Clock.make(), c2 = Clock.make(), c3 = Clock.make();
                async clocked (c1,c2,c3) {
                        c1.advance();
                        b++;
                        c2.advance();
                        c3.advance();
                }
                async clocked ( c1, c3) {
                        c1.advance();
                        c1.advance();
                        c3.advance();
                        b++;
                }
        }
  


       }

}