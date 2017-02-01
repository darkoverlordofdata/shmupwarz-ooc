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

Issues:

Numerics aren't fuilly type checked.
Printing a float with a %d mask outputs garbage.
An int times a float returns garbage. 

Those are invalid operations, and in both cases the fix is simply 
to use explicit casting or use the correct type. But the compler
should be raising this as an error. This is why we used to have 
hungarian notation. No one wants to return to that.

Calculations with PI return 0. I have to use literal 3.14159.

Performance is slippery, but I average the time spent in the update cycle per 1000 frames.

    vala:  .103343000
    ooc :  .066580000

ooc is about 33% faster than vala.
And I don't get any stuttering.
