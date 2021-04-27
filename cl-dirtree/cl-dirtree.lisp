(defpackage :cl-dirtree
  (:use :cl :cl-fad)
  (:export :dirtree))
(in-package :cl-dirtree)

(require 'uiop)

(defun walk (dir prefix)
  (let ((*filepaths* (cl-fad:list-directory dir)))
    ;(print *filepaths*)
    (dotimes (i (list-length *filepaths*))


    (let ((*nthitem* (nth i *filepaths*)))
      (if (= i (- (list-length *filepaths*) 1))
        (progn
	  (format t "~A└── ~A~%" prefix *nthitem*)
	  (if (uiop:directory-exists-p *nthitem*)
	    (walk *nthitem* (concatenate 'string prefix "    "))
	  )
	)
      )

      (if (/= i (- (list-length *filepaths*) 1))
	(progn
	  (format t "~A├── ~A~%" prefix *nthitem*)
	  (if (uiop:directory-exists-p *nthitem*)
	      (walk *nthitem* (concatenate 'string prefix "│   "))
	  )
	)
      )
))))

(defun dirtree (dir)
  (walk dir "")
)


