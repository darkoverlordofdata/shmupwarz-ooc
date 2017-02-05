# port to ooc

# Can ooc replace vala?


Porting from genie to ooc is pretty simple, line for line equivalency in most cases. 
Mostly changing puctuation and case, order of definitions.
The biggest changes were in the SDL bindings. Ooc's paralell the original more closely,
and as a result are easier to use.
I think Vala bidings have a tendancy to be overly helpful, and do too much re-interpretation of the original api,
shoe horning it into an artificial oop hierarchy.

In some cases, the ooc stdlib is a bit short - no sort method on arrays for example. But I can also
extend the array class to implent sorting. 

Pros 
* overloaded methods
* overloaded operators
* match is an expression
* modular package manager with github backend
* extend existing objects
* no glib (gnome) dependancies
* legible c output.

Cons
* Not actively maintained (alt: https://github.com/magic-lang/rock/tree/rock_1.0.22)
* Not much activity on github

Issues:
* Rock doesn't warn about mixing numeric types, it just returns garbage at run time. You need to be very explicit.
* Property setters defined in extend are unable to reference the global scope.
* Can't always pass expressions as parameters, I need to save in local variables and pass them.
* Calculations with PI return garbage. I have to use 3.14159. Its probably the above type issue.
* Install instructions are wrong. Seems written for OSX, and maybe there are just no Ubuntu instruction?
* Documentation is 'sprawling', incorrect in places. Not easily usable as a reference. 


Performance is slippery, but I average the time spent in the update cycle per 1000 frames.

    nim:   .145644497
    vala:  .103343000
    ooc :  .066580000

ooc is faster than vala or nim. I experience no stuttering.
GLib dependancies are blocking me from android.

