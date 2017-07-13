#lang info
(define collection "$$$PKG_NAME$$$")
(define deps '("base" ;; ("base" "6.4")
               "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"))
(define scribblings '(("scribblings/$$$PKG_NAME$$$.scrbl" ())))
(define pkg-desc "")
(define version "0.0")
(define pkg-authors '("Georges Dupéron"))
