#lang scribble/manual
@require[@for-label[phc-ts]
         (for-syntax racket/base)]

@title{phc-ts}
@author[@author+email["Suzanne Soy" "racket@suzanne.soy"]]

@defmodule[phc-ts]

There is no documentation for this package yet.

@(define-syntax (show-ids stx)
   (syntax-case stx ()
     [(_ b)
      (boolean? (syntax-e #'b))
      (let-values ([(vars stx-vars) (module->exports 'phc-ts)])
        #`(itemlist
           #,@(for*/list ([phase+ids (in-list (if (syntax-e #'b)
                                                  vars
                                                  stx-vars))]
                          [phase (in-value (car phase+ids))]
                          [id (in-list (cdr phase+ids))])
                #`(item (racketid #,(car id))
                        " at phase"
                        #,(number->string phase)))))]))

The following variables are provided:

@(show-ids #t)

The following syntaxes are provided:

@(show-ids #f)
