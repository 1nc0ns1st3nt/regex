# regex
regex parser written in data-directed programming

heavily inspired by SICP.

lexi.rkt utilizes two files, stream-oop & table, there two constructs are quite vital for the data-directed approach to work.

example outputs:
> \>(analysis "123+")
> '((char . #\1) (char . #\2) (#\+ char . #\3))
> \> (analysis "[123]+")
> '((#\+ #\[ #\1 #\2 #\3))
> 
