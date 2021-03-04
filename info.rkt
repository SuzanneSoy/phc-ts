#lang info
(define collection "phc-ts")
(define deps '(("base" "6.7.0.900")
               "rackunit-lib"
               "reprovide-lang"
               "dotlambda"
               "hyper-literate"
               "phc-toolkit"
               "turnstile"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "scribble-enhanced"))
(define scribblings '(("scribblings/phc-ts.scrbl" ())))
(define pkg-desc "")
(define version "0.0")
(define pkg-authors '(|Suzanne Soy|))
