#lang racket
(provide ~same-free-id)

(require syntax/parse)

(define-splicing-syntax-class (same-free-id f)
  #:description (format "the identifier ~a"
                        (syntax-e f))
  (pattern x #:when (and (identifier? #'x) (free-identifier=? #'x f))))

(define-syntax ~same-free-id
  (pattern-expander
   (λ (stx)
     (syntax-case stx ()
       [(_ pvar) (identifier? #'pvar) #'{~var || (same-free-id #'pvar)}]))))
