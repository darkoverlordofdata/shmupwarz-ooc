# port to ooc

# Can ooc replace vala?

Porting from genie to ooc, little changes other than puctuation and case.

Pros 
* overloaded methods
* overloaded operators
* match is an expression
* modular package manager with github backend

Cons
* Rock doesn't warn about primitive type mismatch.
* Installation and tool documentation is dodgy. 
* Not actively maintained
* Not much activity on github
* Not much documentation or examples

bugs:

Mixing floating point and ints can fail at runtime where vala presents a compiler error. 
Printing a float with a %d mask produces garbage. 
In all cases the fix is simply explicit casting or use the correct type. But the compler
should be raising this as an error. This is why we used to have hungarian notation. No one
wants to return to that.

Calculations with PI don't work. I have to use literal 3.14159.


Performance is slippery, but I average the time spent in the update cycle per 1000 frames.

vala:  .089357000
ooc :  .147849000

As you can see vala runs a little faster, but both run in
less than 10% of the available frame time.
Performance is not an issue, and I don't see stuttering like with Nim.



