# port to ooc

# Can ooc replace vala?

Porting from genie to ooc, little changes other than puctuation and case.

Pros 
* overloaded methods
* overloaded operators
* match is an expression
* modular package manager with github backend

Cons
* Rock doesn't warn about numeric type mismatch.
* Installation and tool documentation is dodgy. 
* Not actively maintained
* Not much activity on github
* Not much documentation or examples

Issues:

* Calculations with PI return 0. I have to use literal 3.14159.

Performance is slippery, but I average the time spent in the update cycle per 1000 frames.

    nim:   .145644497
    vala:  .103343000
    ooc :  .066580000

ooc is about 33% faster than vala.
And I don't get any stuttering.
