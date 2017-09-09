#lang racket
(require phc-ts/stx-sort
         syntax/parse
         phc-toolkit/untyped/aliases
         rackunit)

(check-equal? (syntax-parse #'([a 3] [c 2] [b 1])
                [{~sort [{~key k} v] …}
                 (syntax->datum #'([k . v] …))])
              '([a . 3] [b . 1] [c . 2]))

(check-equal? (syntax-parse #'([a z y] [c x] [b w])
                [{~sort [{~key k} . {~sort {~key v} …}] …}
                 (syntax->datum #'([k v …] …))])
              '([a y z] [b w] [c x]))

(check-equal? (syntax-parse #'([a 5 4] [c 3 1 2] [b 0])
                [{~sort [{~key k} . {~sort {~key v} …}] …}
                 (syntax->datum #'([k v …] …))])
              '([a 4 5] [b 0] [c 1 2 3]))