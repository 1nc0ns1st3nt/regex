
#lang racket

(provide regex)

(require "stream-oop.rkt"
         "operation-table.rkt")

(define (re/tag x y) (cons x y))

(define (stream-next stm) ((stm 'read-char) 'done))
(define (stream-read-until stm c)
  (regex ((stm 'read-until) c)))

(define (install-re-lexi)
  (define (lexi-self stm c) 'self)
  (define (lexi-repeat stm c) 'repeat)
  ;;
  (put 'lexi #\$ lexi-self)
  (put 'lexi #\^ lexi-self)
  (put 'lexi #\. lexi-self)
  ;;
  (put 'lexi #\* lexi-repeat)
  (put 'lexi #\+ lexi-repeat)
  (put 'lexi #\? lexi-repeat)
  ;;
  (put 'lexi #\|
       (lambda (stm c)
         (lexi stm (stream-next stm))))
  (put 'lexi #\[
       (lambda (stm c)
         (stream-read-until stm #\])))
  (put 'lexi #\{
       (lambda (stm c)
         (stream-read-until stm #\})))
  (put 'lexi #\(
       (lambda (stm c)
         (stream-read-until stm #\))))
  (put 'lexi #\\
       (lambda (stm c)
         (stream-next stm)))
  ;;
  'done)

(define (install-re-parse)
  (define (parse-re/pop re acc)
    "pop last to group together"
    (cons (re/tag (car re) (car acc))
          (cdr acc)))
  ;;
  (put 'parse #\* parse-re/pop)
  (put 'parse #\+ parse-re/pop)
  (put 'parse #\? parse-re/pop)
  (put 'parse #\|
       (lambda (re acc)
         (let ((re-op (car re))
               (re-expr (cdr re)))
           (cons (re/tag re-op
                         (list (car acc) re-expr))
                 (cdr acc)))))
  ;;
  'done)

(define (lexi stm char)
  (let ((lexi-proc (get 'lexi char)))
    (if lexi-proc
        (re/tag char (lexi-proc stm char))
        (re/tag 'char char))))

(define (parse lexical-re acc)
  (install-re-parse)
  (let ((parse-proc (get 'parse (car lexical-re))))
    (if parse-proc
        (parse-proc lexical-re acc)
        ;; (error "a proc is missing for re-type: PARSE"
        ;;        lexical-re)
        (cons lexical-re acc))))

(define (regex string)
  (install-re-lexi)
  (define stm (make-string-stream string))
  (define (iter acc)
    (if ((stm 'is-empty))
        (reverse acc)
        (let ((c (stream-next stm)))
          (iter (parse (lexi stm c)
                       acc)))))
  (iter '()))

