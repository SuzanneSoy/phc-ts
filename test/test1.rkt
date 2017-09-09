#lang s-exp phc-ts
(require turnstile/examples/tests/rackunit-typechecking)

(check-type (λ ([x : X]) (ann x : X)) : (→/test A A))
(check-type (λ ([x : y]) (ann x : y)) : (→/test A A))
(check-type (λ ([x : y]) x) : (→/test A A))
(check-type (record [b = 1] [a = 2]) : (Record [a : Int] [b : Int]))
(check-type (record [a = 2] [b = 1]) : (Record [a : Int] [b : Int]))
(typecheck-fail
 (getfield c (record [b = 1] [a = 2]))
 #:with-msg (string-append "expected record type containing the field c, got:"
                           " \\(Record \\(a : Int\\) \\(b : Int\\)\\)"))