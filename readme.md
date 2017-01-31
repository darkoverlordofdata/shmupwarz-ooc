# port to ooc

status - initial pass complete. It doesn't crash...

# Can ooc replace vala?

Porting from genie to ooc, little changes other than puctuation and case.

Pros 
* overloaded methods
* overloaded operators
* match is an expression
* modular package manager with github backend

Cons
* Doesn't warn about primitive type mismatch.
* Inner struct of a nested struct is read only.
* Installation and tool documentation is dodgy. 
* Not actively maintained
* Not much activity on github
* Not much documentation or examples

Mixing floating point and ints can fail at runtime where vala presents a compiler error. 
In both cases the fix is explicit casting.
Calculations with PI don't work. I have to use literal 3.14159.
Stdlib is a bit short on functionality, for example, there is no sort or insert method on arrays. 
SDL bindings are incomplete.



