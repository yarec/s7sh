;;
;; basic-lib.scm
;;


;; is sym (a symbol) in *features* ?
(define (in-features? sym)
  (member sym *features*))

;; is path in *load-path* ?
(define (in-load-path? path)
  (member path *load-path*))

;; add directory in *load-path if it is not already present
(define (add-load-path directory)
  (when (not (in-load-path? directory))
    (set! *load-path* (cons directory *load-path*))))

;; quit, alias for exit
(define quit (lambda() (exit)))

;;
;; full-provide sym (a symbol)
;; add sym to *features,
;; add the directory of the current file to *load-path*
;; TODO: errors management!
(define-macro (full-provide sym)
              `(let ((provide-sym (lambda()
                                    (when (not (in-features? ,sym))
                                      (with-let (rootlet)
                                                (provide ,sym))))))
                 (let ((directory 
                         (let ((current-file (port-filename)))
                           (begin
                             ;; TODO: verify problems with length
                             (and (memv (current-file 0) '(#\/ #\~ #\.))
                                  (substring 
                                    current-file 
                                    0 
                                    (- (length current-file) 
                                       (+ 1 (length (symbol->string ,sym))))))))))
                   (when (and directory (not (in-load-path? directory)))
                     (provide-sym)
                     (set! *load-path* (cons directory *load-path*))))))

;; using full-provide
(full-provide 'basic-lib.scm)

;; debugging full-provide
(when (not *quiet*)
  (let ((show-list (lambda (list-name L)
                     (format #t "-------------------------------~%")
                     (format #t "~A~%" list-name)
                     (pretty-print L)
                     (format #t "~%~%"))))

    (show-list "*features*" *features*)
    (show-list "*load-path*:" *load-path*)))
(format #t "~%")
(pretty-print (macroexpand (full-provide 'basic-lib.scm)))
(format #t "~%~%")
