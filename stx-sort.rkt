#lang racket

(provide ~sort
         ~sort-seq
         ~key)

;; Note: when using nested ~sort, the inner sort is not performed during the
;; first pass for the outer ~sort. Once the values for the outer ~sort have been
;; gathered and sorted, then the innder ~sort is applied. This means that the
;; comparison operator for the outer ~sort should work with unsorted
;; sub-sequences.s

(require syntax/parse
         "aliases.rkt"
         syntax/stx
         racket/stxparam
         (for-syntax racket/syntax))

(define-for-syntax sort-scope (make-syntax-introducer))
(define-syntax-parameter current-key-id #f)

(define-for-syntax (~sort-ish op*)
  (pattern-expander
   (λ (stx)
     (syntax-case stx (…)
       [(self pat …)
        (if (syntax-parameter-value #'current-key-id)
            #`(#,@op* _ …)
            #`(~and (#,@op* tmp …)
                    (~parse (pat …)
                            (sort/stx self #'(tmp …) pat))))]))))
(define-syntax ~sort (~sort-ish #'{}))

(define-syntax ~sort-seq (~sort-ish #'{~seq}))

(define-syntax (sort/stx stx)
  (syntax-case stx ()
    [(_ ctx stxlist pat)
     #'(syntax-parameterize
           ([current-key-id (generate-temporary #'key)])
         (def-cls tmpcls pat)
         (and (syntax-parse stxlist [({~var || tmpcls} …) #t] [_ (displayln (format "Failed to parse ~a as ~a." stxlist 'pat)) #f])
              (sort (syntax->list stxlist)
                    (λ (a b)
                      (cond
                        [(and (symbol? a) (symbol? b)) (symbol<? a b)]
                        [(and (number? a) (number? b)) (< a b)]
                        [else (number? a)])) ; numbers come first in the order
                    #:key (do-parse tmpcls))))]))

(define-syntax (def-cls stx)
  (syntax-case stx ()
    [(_ tmpcls pat)
     (with-syntax ([key (syntax-parameter-value
                         #'current-key-id)])
       #'(define-syntax-class tmpcls
           ;; I can't seem to manage to establish reliable communication between
           ;; the ~sort and the ~key. So here we're relying on the fact that
           ;; #:attributes is actually unhygienic, in order to get a handle on
           ;; the key as defined by ~key.
           #:attributes (key)
           (pattern pat)))]))

(define-syntax (do-parse stx)
  (syntax-case stx ()
    [(_ tmpcls)
     (with-syntax ([x.key (format-id #'x "x.~a" (syntax-parameter-value
                                                 #'current-key-id))])
       #'(syntax-parser
           [(~var x tmpcls) (syntax-e #'x.key)]))]))

(define-syntax ~key
  (pattern-expander
   (λ (stx)
     (syntax-case stx ()
       [(self pat)
        (if (syntax-parameter-value #'current-key-id)
            (with-syntax ([key (syntax-parameter-value #'current-key-id)])
              #`(~and pat key))
            #'(~and pat _))]))))

#;(syntax-parse #'([a 3] [c 1] [b 2])
    [{~sort [{~key k} v] …}
     #'([k . v] …)])
