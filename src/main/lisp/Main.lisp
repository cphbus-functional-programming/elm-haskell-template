(defun factorial (n) (if (<= n 0) 1 (* n (factorial (- n 1)))))

(write (format nil "Hello World and 100! = ~A" (factorial 100)))
