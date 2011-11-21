## Name:Kurry L Tran
## Homework 3 
## COMS 4130 Principles and Practice of Parallel Programming 
## Fall 2011
##
##



# Problem 1(20 points)  

Let S be a statement of the form <clk>.advance() where <clk> is c1,c2, c3 or c4. 

Add statements S to the following X10 code so that it deterministically prints out the 
following lines in order: 

In Xanadu did Kubla Khan
Stately pleasure-dome decree :
Where Alph, the sacred river, ran
Through caverns measureless to man
Down to the sunless sea. 

To receive full credit, your solution should minimize the calls to advance(). 

public class Xanadu {
	public static def main(Array[String]) {
		finish async { 
			val 	c1 = Clock.make(), c2 = Clock.make(), 
				c3 = Clock.make(), c4 = Clock.make() ; 
			
			// Activity A 
			async clocked(c1, c2) { 
				Console.OUT.println("Kubla Khan"); 
			}
			
			// Activity B 
			async clocked(c2,c3) { 
				Console.OUT.println("Stately pleasure-dome decree :"); 
				Console.OUT.print("Down to the "); 			
			}
			
			// Activity C 
			async clocked (c3,c4) { 
				Console.OUT.print("In Xanadu did ");
				Console.OUT.println("Through caverns measureless to man"); 
			}
			
			// Activity D 
			async clocked (c1,c4) { 
				Console.OUT.println("Where Alph, the sacred river, ran");  
				Console.OUT.println("sunless sea. ");
			}
		}		
	}
}  



# Problem 2 (25 points) 
For (a)-(d), state whether the code provided is (I) safe or unsafe, (II)
determinate or indeterminate. You must explain your answers to receive credit.

(a)  	
1	val M = 5;
2	val N = 10;
3	val a = new Rail[Int](N,0);
4		
5	finish for ( id in 0..(N-1) ) async { 
6		var b:Int = 0;
7		for (i in 0..(M-1)){  
8			a(id) += i + b++; 
9		}	
10	}

I. The program provided is safe since:
    1. The program preserves the natural ordering of the dependency graph and 
satifies the partial correctness property.
    2. The program satisfies the mutual exclusion property since in the critical
section each async accesses separate sections of the array leaving the array in 
a consistent state for other asyncs.
    3. The program is absent of deadlock. 

II. The program provided is determinant since:
    1. The program given any initial state will produce the exact same result
independent of how each unit of execution is scheduled, since each async task
is operating on an independent memory location on the shared data structure.

(b) 
1    val M = 5; 
2    val N = 10; 
3    val a = new Rail[Int](4*N,0);
4		
5    var b:Int = 0;
6    finish for ( id in 0..(N-1) ) async { 
7		for (i in 0..(N-1)) { 
8			a(id+i) = b;
9			atomic b += i;  
10		}
11	}

I. The program provided is not safe since:
    1. A race condition occurs in the critical section at line 8. 
    2. We cannot guarantee mutual exclusion in the critical section
since scheduler non-determinism causes parallel threads to interleave
in arbitrary fashion, thus multiple threads may concurrently try to 
write to memory location a(id+i).
    3. The program does not always preserve the ordering of the 
dependency graph and it does not satisfy the partial correctness
property.

II. The program provided is not deterministic since:
    1. Not all executions of the code produce the exact same final state.
    2. Each state of the program is determined by the value of b, and
depending on which thread executes the atomic statement first, the value
of a(id+i) is set and this is non-deterministic due to the scheduler.   

(c)
1	val N = 10; 
2	val a = new Rail[Int](N*N,0); 
3		
4	var b:Int = 0; 
5	finish for ( id in 0..(N-1) ) async { 
6		for (i in 0..(N-1)) async{ 
7			a(id+i*N) = i%N;
8			atomic b += i;  
9		}
10	}

I. The program is not safe since:
   1. The race condition on line 7 causes the write
to memory location a(id+i*N) to  be non-deterministic,
 and mutual exclusion cannot be guaranteed since there
could be multiples writes to the same location depending
on the scheduler.

II. The program is not deterministic since:
    1. The program is not deterministic since the 
dependencies change due to the execution of the 
atomic statement on line 8 which affects the final
state of the program. 



(d)
	var b : Int = 0; 
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






(e) Incensed by the meager attention the sports media pays to Division I-AA
football (of which Columbia is a member), a Columbia business major decides to
launch a website that is devoted to I-AA football. Among other things, the
website lets people rate players on a weekly basis. This is the service routine
for accumulating the ratings:

	val nplayers = 6000; 
	val ratings = new Array[Long](nplayers, 0); 	

	// rating is on a scale from 0 to 5 	
	public def submitRating(playerId :Int, rating:Int ){ 
		atomic ratings(playerId) += rating ; 
	}
	

Being an optimist, our business major expects millions of visitors per week. Why
will the above function give poor performance when a large number of people are
trying to submit ratings at the same time ? What can you, a COMS 4130 student,
do to speed up the ratings service?


# Problem 3 (35 points) 

You are to implement a lock-free list-based set.    

Fill in the add(), remove() and contain() methods in LockFreeSet.x10. add() adds
an item to the set if it is not already present, it also returns true on success
and false on failure (i.e. when the item is already present).  remove() removes
a node if present, returns true on success and false on failure. contains()
returns true if the item is present and false if not present.

You must implement the algorithm given in
http://www.research.ibm.com/people/m/michael/spaa-2002.pdf .

Here are a few pointers to get you started: 

- The Node data structure used in the paper uses a tag field to prevent
  occurrence of the ABA problem (
  http://en.wikipedia.org/wiki/ABA_problem). Because you are running in a
  garbage collected environment, you don't have to worry about the tag field and
  your implementation can ignore the details surrounding memory management.

- The nodes in the list are ordered by their keys.

- The data structure should contain two sentinel nodes : head and tail.

- The CAS operation you implement is similar to the one used in the Queue
  implementation in unit5 lecture notes. But you need a slightly different
  version as you need to account for the marked field.

In addition to the implementation, you need to answer the following question:

Why can you not just update the next field atomically using compareAndSwap? Why
did you have to introduce a marked bit/field ? Show an interleaving where just
using compareAndSwap on next leads to incorrect behavior.


# Problem 4 ( 20 points ) 

Suppose n asyncs call the direction() function in the Directions class. 
(a) At most how many asyncs get the value RIGHT ? 
(b) At most how many asyncs get the value FORWARD?
(c) At most how many asyncs get the value LEFT?

You will not get points for magically guessing the correct answer. You must
prove that your answer is correct.

public class Directions {

	public static LEFT:Int = 0; 
	public static RIGHT:Int = 1; 
	public static FORWARD:Int = 2; 
	
	var last:Int = -1; 
	var toTheRight:Boolean = false; 

	public def direction(asyncId:Int) :Int { 
		last = asyncId;
		if (toTheRight)  
			return RIGHT; 
		toTheRight = true; 
		if ( last == asyncId ) { 
			return FORWARD; 
		} else { 
			return LEFT; 
		}
	}	
}







