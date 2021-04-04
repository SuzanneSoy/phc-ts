#lang hyper-literate #:no-auto-require (dotlambda/unhygienic . turnstile/lang)

@(define (turnstile) @racketmodname[turnstile])

@(require racket/require
          (for-label (prefix-in host: (only-meta-in 0 turnstile/lang))
                     (prefix-in host:
                                (subtract-in (only-meta-in 1 turnstile/lang)
                                             (only-meta-in 0 turnstile/lang)))
                     macrotypes/examples/mlish))

@section{Introduction}

We define our type system as an extension to another language. We could extend
one of the many sufficiently capable languages built with @turnstile[]. Here,
we will base ourselves on @racketmodname[mlish], a ml-like language
implemented with @turnstile[], and provided as part of @turnstile[]'s suite of
examples.

@chunk[<*>
       (extends macrotypes/examples/mlish)]

Since @racketmodname[macrotypes/examples/mlish] provides some identifiers which
conflict with some racket utilities, we import those with a prefix.

@chunk[<*>
       (require racket/require
                (prefix-in host: turnstile/lang)
                (for-syntax "aliases.rkt")
                (for-syntax "stx-sort.rkt")
                (for-meta 2 syntax/stx)
                (for-meta 2 "stx-sort.rkt")
                (for-meta 2 "aliases.rkt"))]

We define a @racket[Record] type, in which the order of fields is irrelevant.

@CHUNK[<*>       
       ;;(host:provide (type-out Record))
       (host:provide Record (for-syntax ~Record))

       (define-type-constructor Record* #:arity >= 0
         #:arg-variances λstx.(make-list (sub1 (stx-length stx)) covariant))

       (define-type-constructor Field* #:arity = 2
         #:arg-variances λstx.(make-list (sub1 (stx-length stx)) covariant))

       (define-syntax (Field stx)
         (syntax-case stx ()
           [(_ ℓ τ) #`(Field* #,(mk-type #'(quote ℓ)) τ)]))
       
       (define-syntax Record
         (syntax-parser
           [(_ {~sort-seq [{~key ℓ:id} {~literal :} τ] …})
            #'(Record* [Field ℓ τ] …)]))

       (begin-for-syntax
         (define-syntax ~Field
           (pattern-expander
            (λ (stx)
              (syntax-case stx ()
                [(_ ℓ τ)
                 #'[~Field* ({~literal quote} ℓ) τ]]))))
              
         (define-syntax ~Record
           (pattern-expander
            (syntax-parser
              [(_ [ℓ {~literal :} τ] {~datum ⊤ρ}) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               #'(~Record* _ (… …) [~Field ℓ τ] _ (… …))]
              [(_ {~sort-seq [{~key ℓ} {~literal :} τ] …})
               #'(~Record* [~Field ℓ τ] …)]))))]

The builder form for the @racket[Record] type is @racket[record].

@chunk[<*>
       (host:provide record)
       (define-typed-syntax
         (record [ℓ:id {~literal =} e] …) ≫
         [⊢ e ≫ e- ⇒ τ] …
         #:with (tmp …) (generate-temporaries #'(e …))
         #:with (~sort [{~key sorted-ℓ} sorted-τ sorted-tmp] …) #'([ℓ τ tmp] …)
         --------
         [⊢ (let ([tmp e] …)
              (list- (list- 'sorted-ℓ sorted-tmp) …))
          ⇒ (Record [sorted-ℓ : sorted-τ] …)])]

Fields can be accessed via the @racket[getfield] operator. The @racket[i.ℓ]
notation will later be introduced, and will reduce to @racket[(getfield i ℓ)].

@chunk[<*>
       (host:provide getfield)
       (require (for-syntax "same-id-pattern.rkt"))
       (define-typed-syntax
         (getfield ℓ:id e) ≫
         [⊢ e ≫ e- ⇒ {~or {~Record [{~same-free-id ℓ} : τ] ⊤ρ} <record-err-ℓ>}]
         --------
         [⊢ (car- (assoc- 'ℓ e-)) ⇒ τ])]

@chunk[<record-err-ℓ>
       {~and
        other
        {~do (type-error
              #:src #'other
              #:msg "expected record type containing the field ~a, got: ~a"
              #'ℓ #'other)}}]

@chunk[<*>
       (host:provide :)
       (define-syntax (: stx)
         (raise-syntax-error ': "Invalid use of token" stx))]
       
We define a quick and dirty @racket[:type] operator, which can be used to
print the type of an expression. For now, we simply trigger an error message
which should contain the inferred type, unless the type of @racket[e] is an
@racket[Int].

@chunk[<*>
       (host:provide :type)
       (require syntax/macro-testing)
       (define ann/:type-regexp
         #px"ann: type mismatch: expected Int, given (.*)\n  expression:")
       (define-syntax-rule (:type e)
         (with-handlers ([(λ (exn) #true)
                          (λ (exn)
                            (displayln
                             (cadr (regexp-match ann/:type-regexp
                                                 (exn-message exn)))))])
           (convert-compile-time-error (ann e : Int))))]

@section{Conclusion}
