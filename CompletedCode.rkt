#lang racket
;This is the main loop of the program. It takes in the boolean describing if the program is running in batch mode or not.
;If it is in batch mode, it displays '>'.
;It also takes the history (past values) as an argument to append to the answer)
(define (main-loop interactive? history)

  ;if it is in interactive mode, it prints a line and waits for the user
  ;if it is not in interactive mode,then it does not print the line for user input, just takes it directly
  (when interactive?
        (display "> ")
        (flush-output))

  (let ([line (read-line)])
    (cond
      [(eof-object? line) (void)] ;if the line read is empty/end of file/end by user, ends the program
      [(equal? line "quit") (void)] ; if the line has the word quit exactly
      [else ;all other cases
       (with-handlers ([exn:fail? (lambda (ex)    ;try the code, but if any error is returned, send it back to the output with the prefix "error"
                                    (display "Error: ")
                                    (displayln (exn-message ex))
                                    (main-loop interactive? history))])
         (let-values ([(result remaining-chars)
                       (eval-expression history (string->list line))]) ;assign the value returned to the values in the line above
           ;we need to check the value remaining if it is a whitespace or something else, and if the entire expression was evaluated
           (if (all-whitespace? remaining-chars)
               (let* ([new-history (cons result history)]
                      [history-id (length new-history)]
                      [float-result (real->double-flonum result)])
                 (display history-id)
                 (display ": ")
                 (displayln float-result)
                 (main-loop interactive? new-history))
               ;fail case
               (begin
                 (displayln "Error: Invalid expression")
                 (main-loop interactive? history)))))])))
       
;check if all the characters are whitespaces/nothing left to evaluate
(define (all-whitespace? char-list)
  (if (null? char-list) #t;base case
      (and (char-whitespace? (car char-list)) (all-whitespace? (cdr char-list)))));check if the car and rest of the list is a whitespace

(define (eval-expression history char-list)
  (let ([trimmed (remove-leading-whitespace char-list)])
    (when (null? trimmed)
      (error "Invalid Expression"))
    (let ([token (car trimmed)] [rest (cdr trimmed)])
      (cond
        ;multiple and add have the same structure so they can be passed into the same function
        [(char=? token #\+) (parse-binary + history rest)] 
        [(char=? token #\*) (parse-binary * history rest)]
        ;divide has to check if there is a zero in the denominator, so we pass it into a seperate function
        [(char=? token #\/) (parse-division history rest)]
        [(char=? token #\-)
         (if (and (not (null? rest)) (char-numeric? (car rest)));if rest is not null, and the next value is a number (not a whitespace), it is a negative number
             (parse-number trimmed)
             (parse-unary - history rest))];else its an expresssion that needs to be treated as a negative before returning
        [(char=? token #\$) (parse-history history rest)]
        [(char-numeric? token) (parse-number trimmed)]
        [else (error "Invalid-expression")]))))

(define (parse-binary op history char-list)
  (let-values ([(val1 rest1) (eval-expression history char-list)])
    (let-values ([(val2 rest2) (eval-expression history rest1)])
      (values (op val1 val2) rest2))))

(define (parse-division history char-list)
  (let-values ([(val1 rest1) (eval-expression history char-list)])
    (let-values ([(val2 rest2) (eval-expression history rest1)])
      (when (zero? val2)
        (error "Division by zero"))
      (values (quotient val1 val2) rest2))))

(define (parse-unary op history char-list);get the entire expression after to become negative
  (let-values ([(val rest) (eval-expression history char-list)])
    (values (op val) rest)))

(define (parse-number char-list)
  (define (is-num-char? c)
    (or (char-numeric? c)
        (and (char=? c #\-)
             (eq? (list-ref char-list 0) #\-)))) ; Allow '-' only at the start
  
  (let-values ([(num-chars rest) (custom-span is-num-char? char-list)])
    (let ([num (string->number (list->string num-chars))])
      (if num
          (values num rest)
          (error "Invalid Expression")))))

(define (custom-span pred lst)
  (let loop ([current-lst lst] [prefix '()])
    (if (or (null? current-lst) (not (pred (car current-lst))))
        (values (reverse prefix) current-lst)
        (loop (cdr current-lst) (cons (car current-lst) prefix)))))

(define (parse-history history char-list)
  (let-values ([(id-chars rest) (custom-span char-numeric? char-list)])
    (when (null? id-chars)
      (error "Invalid Expression"))
    (let ([id (string->number (list->string id-chars))])
      (if (and id (> id 0) (<= id (length history)))
          ;; History is (v3 v2 v1). To get $1 (v1), we reverse to (v1 v2 v3) and get index 0.
          (values (list-ref (reverse history) (sub1 id)) rest)
          (error "Invalid Expression")))))

(define (remove-leading-whitespace char-list)
  (if (or (null? char-list) (not (char-whitespace? (car char-list))))
      char-list ;if the list is empty or doesn't start with whitespace, return it.
      (remove-leading-whitespace (cdr char-list)))) 

(define (main)
  (define interactive?
    (let ([args (current-command-line-arguments)])
      (not (or (vector-member "-b" args)
               (vector-member "--batch" args)))))
  
  (main-loop interactive? '()))



(main)




         