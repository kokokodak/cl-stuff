;; script to convert input file of "fin = eng" to org-drill file
;; 2023 ttm

(load "~/quicklisp/setup.lisp")

(ql:quickload 'cl-ppcre :silent t)

(define-condition invalid-data (error)
  ((line :initarg :line
	 :reader line))
  (:report (lambda (condition stream)
 	      (format stream "Offending line: '~a'" (line condition)))))

(defun verify-data (line)
  "checks whether string line contains equal sign"
  (when (= 1 (count #\= line :test #'char-equal))
    t))

(defun split-line (line)
  "splits line on equal sign with optional spaces into two values"
  (if (verify-data line)
      (subseq (cl-ppcre:split " *= *" line) 0 2)
      (error 'invalid-data :line line)))

(defun create-od-item (fin eng)
  "returns org-drill item"
  (format nil "* Question :drill:
~a

** Answer
~a
" fin eng))

(defun create-od-item-from-line (line)
  "creates org-drill item from line"
  (let ((tuple (split-line line)))
    (create-od-item (first tuple) (second tuple))))

(defun main ()
  (if (nth 1 sb-ext:*posix-argv*)
      (with-open-file (infile (nth 1 sb-ext:*posix-argv*))
	(loop for line = (read-line infile nil)
	      while line
	      do (format t "~a~%" (create-od-item-from-line line))))
      (format *error-output* "Usage: ~a file-to-convert" (first sb-ext:*posix-argv*))))

