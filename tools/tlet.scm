(define size 1000000)
(set! (*s7* 'safety) -1)
(set! (*s7* 'heap-size) (* 9 1024000))

(define symbols (make-vector size 'a symbol?))
(define e (inlet))

(define (make-symbols)
  (do ((e1 e)
       (syms symbols)
       (i 0 (+ i 1)))
      ((= i size))
    (varlet e1 (vector-set! syms i (symbol "a-" (number->string i))) i)))
(make-symbols)

(define (add)
  (let ((sum 0)
	(e1 e))
    (for-each
     (lambda (x)
       (set! sum (+ sum (let-ref e1 x))))
     symbols)
    sum))

(define (subtract)
  (let ((sum 0)
	(e1 e))
    (for-each
     (lambda (x)
       (set! sum (- sum (let-ref e1 x))))
     (reverse! symbols))
    sum))

(define (whatever)
  (let ((sum 0))
    (do ((i 0 (+ i 1)))
	((= i size))
      (set! sum (+ sum (let-ref e (vector-ref symbols (random i))))))
    sum))

(format *stderr* "~A ~A ~A ~A~%" (/ (- (* size size) size) 2) (add) (subtract) (whatever))

(define (in-e)
  (with-let (sublet e :symbols symbols :size size)
    (let ((sum1 0.0)
	  (sum2 0.0)
	  (sum3 0.0)
	  (inc 0.0))
      (do ((i 0 (+ i 1)))
	  ((= i size))
	(set! inc (symbol->value (vector-ref symbols i)))
	(set! sum1 (+ sum1 inc))
	(set! sum2 (- sum2 inc))
	(set! sum3 (+ sum3 (symbol->value (vector-ref symbols (random i))))))
      (format *stderr* "~A ~A ~A ~A~%" (/ (- (* size size) size) 2) sum1 sum2 sum3))))
(in-e)

(exit)

