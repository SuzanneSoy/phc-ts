#lang scribble/manual
@require[@for-label[$$$PKG_NAME$$$
                    racket/base]]

@title{$$$PKG_NAME$$$}
@author[@author+email["Georges Dupéron" "georges.duperon@gmail.com"]]

@defmodule[$$$PKG_NAME$$$]

There is no documentation for this package yet.

@(define-syntax (show-ids _stx)
   (syntax-case stx ()
     [(_ b)
      (boolean? (syntax-e #'b))
      (let-values ([(vars stx-vars) (module->exports $$$PKG_NAME$$$)])
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