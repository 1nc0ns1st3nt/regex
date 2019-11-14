# regex
unfinished regex parser written in data-directed programming

heavily inspired by SICP.

lexi.rkt  
It utilizes two files, stream-oop & table, these two constructs are quite vital for the data-directed approach to work.
Showing how this approach can be done, and the design of the framework allows us to easily add and modify the "logic" without "touching" the core code.

compile.rkt  
unfinished regex evaluator

example outputs:  
```
> (analysis "123+")
'((char . #\1) (char . #\2) (#\+ char . #\3))  
> (analysis "[123]+")  
'((#\+ #\[ #\1 #\2 #\3)) 
```
