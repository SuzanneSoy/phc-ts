#lang racket
(require syntax/parse
         phc-ts/same-id-pattern
         rackunit)

(check-true (syntax-parse #'(a 1 2 a 4)
                [(y _ ... {~same-free-id y} _ ...) #t]
                [_ #f]))

(check-false (syntax-parse #'(a 1 2 b 4)
                [(y _ ... {~same-free-id y} _ ...) #t]
                [_ #f]))