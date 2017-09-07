#lang scribble/manual
@require[@for-label[phc-ts
                    racket/base]]

@title{phc-ts}
@author[@author+email["Georges Dupéron" "georges.duperon@gmail.com"]]

@defmodule[phc-ts]

There is no documentation for this package yet.

@(define-syntax (show-ids _stx)
   (syntax-case stx ()
     [(_ b)
      (boolean? (syntax-e #'b))
      (let-values ([(vars stx-vars) (module->exports phc-ts)])
        #`(itemlist
           #,(for*/list ([phase+ids (in-list (if (syntax-e #'b) vars stx-vars))]
                         [phase (in-value (car phase+ids))]
                         [id (in-list (cdr phase+ids))])
               #`(item (racketit #,id)
                       "at phase"
                       #,(number->string phase)))))]))

The following variables are provided:

@(show-ids #t)

The following syntaxes are provided:

@(show-ids #f)