(set! (*s7* 'heap-size) (* 8 1024000))

(define* (f0 a b)
  (display b #f))

(define* (f1 a . b)
  (display b #f))

(define* (f2 a)
  (display 2 #f))

(define* (f3)
  (display 3 #f))

(define* (f4)
  (apply + (list 1 2)))

(define* (f5 (a 1))
  (apply + (list a 2)))

(define* (f6 a . b)
  (apply values (cons a b)))

(define* (f7 (a 1) (b 2))
  (apply + (list a b)))

(define* (f8 a b c)
  (list a b c))

(define* (f9 a :rest b)
  (list a b))

(define* (f10 a :allow-other-keys)
  (display a #f))

(define* (f11 . a)
  (apply list a))

(define* (tfib n (a 1) (b 1))
  (if (= n 0)
      a
      (if (= n 1)
	  b
	  (tfib (- n 1) b (+ a b)))))

(define (d1)
  (tfib 35)
  (let ((x 1) (y 2))
    (do ((i 0 (+ i 1)))
	((= i 200000))
      (f0 1 2)
      (f0 x y)
      (f0 :a x)
      (f0 1)
      (f0)
      (f0 :a 1 2)
      (f0 :b 1)
      (f1 1 2 3)
      (f1 1 2)
      (f1 y x)
      (f1 1)
      (f1 :a 1)
      (f1)
      (f1 (- y 1))
      (f2) (f2)
      (f2 1)
      (f2 :a 1)
      (f3) (f3) (f3)
      (f4) (f4) (f4)
      (f5) (f5)
      (f5 1)
      (f5 (- x 1))
      (f5 :a 1)
      (f6 1 2 3)
      (f6 1 2)
      (f6 1)
      (f6 :a 1)
      (f6)
      (f7 1 2)
      (f7 1)
      (f7)
      (f8)
      (f8 :b 2)
      (f8 :c 3 :b 2 :a 1)
      (f9)
      (f9 1 x y)
      (f10)
      (f10 :a 2 :b 2)
      (f11)
      (f11 x)
      (f11 x y))))

(d1)

(exit)
