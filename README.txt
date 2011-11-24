## Name:Kurry L Tran
## Homework 3 
## COMS 4130 Principles and Practice of Parallel Programming 
## Fall 2011
##
##

Note: I reused the makefile from the previous assignment.
Build and Run:
make xanadu
make lockfreeset

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

I. The program provided is not safe since:
   1. There are two writes to be running in parallel, and the clocks
are not synchronized and thus there may be a write-write error.

II. The program is not determinant since:
    1. Depending on the scheduler, the first activity may write to b or 
vice versa, thus the program is not determinant. 


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

Answer:
The program will have slow performance since the atomic statement will cause the
program to block, halting all other writes to the array.
What you could do is create a hash table that allows concurrent accesses, and have
different locks for different buckets. That way you can safely allow reads/writes 
and maintain a safe shared data strucutre with concurrent accesses.


# Problem 3 (35 points) 
Why can you not just update the next field atomically using compareAndSwap? Why
did you have to introduce a marked bit/field ? Show an interleaving where just
using compareAndSwap on next leads to incorrect behavior.

Answer:

You cannot update the next field atomically using compareAndSwap since it 
would be suseptible to live lock. The purpose of a marked bit/field allows
marking the next pointer of a deleted node to prevent a concurrent insert 
operation from linking another node after the deleted node was used.
Also, marking nodes allows for the reuse of nodes arbitrary reuse of nodes
in the future. 

If two processes are running in parallel, one process may set the next
field to one node to null, while the other process is setting the prev
node to the next node, which would lead to incorrect behavior. 

# Problem 4 ( 20 points ) 

Suppose n asyncs call the direction() function in the Directions class. 
(a) At most how many asyncs get the value RIGHT ? 
(b) At most how many asyncs get the value FORWARD?
(c) At most how many asyncs get the value LEFT?

You will not get points for magically guessing the correct answer. You must
prove that your answer is correct.

Assuming writes to Int and Boolean are atomic. 

a. Answer: n - 1

Proof: Suppose n asyncs call the direction() function in the Directions class.
For the set of asyncs there must exist a first async that calls the direction()
function. Without loss of generality, suppose async ONE calls the direction() function
first. Async ONE would enter the body of the function and set last = 1, and read the 
branch statement and would continue, since toTheRight == false, and then atomically
write to "toTheRight" and set the value equal to true. 
     After the atomic write to "toTheRight" n - 1 asyncs are running in parallel
and calling the direction() function and since toTheRight is equal to true, all
n - 1 asyncs could have branched at the if statement and returned "RIGHT" and
exited the body of the function. Thus, while async ONE is executing the body 
of the function, n - 1 asyncs could get the value RIGHT.

b. Answer: 1

Proof: Suppose the same conditions as stated in (a). Suppose async ONE
has finished writing to "toTheRight", when async ONE is evaluating the
branch statement n - 1 asyncs are running in parallel and could have 
written to the value "last" while async ONE was evaluating the branch
statement, thus if another async has overwritten "last", async ONE
would return LEFT, and if another async had not overwritten "last",
async ONE would return FORWARD. Thus, at most one async could return
FORWARD or LEFT since, all asyncs after async ONE will return RIGHT
since all future writes to toTheRight set the value to true, thus
branch and return at the first if statement. 

c. Answer: 1  
See part (b) for proof. Since all asyncs after the async ONE 
evaluate toTheRight == true, they all branch and return RIGHT,
and only async ONE can possibly return LEFT.







