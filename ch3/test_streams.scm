#lang racket

(require racket/stream)

;; cons-stream is a special form
;(define (cons-stream a b)   ;; we don't need to compute b!!! 
;  (cons a (stream-delay b)))

;(define (stream-car stream)
;  (car stream))

;(define (stream-cdr stream)
;  (stream-force (cdr stream)))

(define (my-stream-ref s n)
  (if (= n 0)
      (stream-first s)
      (my-stream-ref (stream-rest s) (- n 1))))

(define (my-stream-map proc s)
  (if (stream-empty? s)
      empty-stream
      (stream-cons (proc (stream-first s))
                   (my-stream-map proc (stream-rest s)))))

(define (my-stream-for-each proc s)
  (if (stream-empty? s)
      'done
      (begin (proc (stream-first s))
             (my-stream-for-each proc (stream-rest s)))))

(define (display-stream s)
  (stream-for-each (lambda (x) (newline) (display x)) s))

(define (stream-enumerate-interval low high)
  (if (> low high)
      empty-stream
      (stream-cons
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (my-stream-filter pred stream)
  (cond ((stream-empty? stream) empty-stream)
        ((pred (stream-first stream))
         (stream-cons (stream-first stream)
                      (my-stream-filter pred (stream-rest stream))))
        (else
         (my-stream-filter pred (stream-rest stream)))))