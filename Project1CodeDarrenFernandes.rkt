#lang racket

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
             (parse-unary - history rest))];
        [(char=? token #\$) (parse-history history rest)]
        [(char-numeric? token) (parse-number trimmed)];for when there is an expression
        [else (error "Invalid-expression")]))))

;check if all the characters are whitespaces/nothing left to evaluat
(define (all-whitespace? char-list)
  (if (null? char-list) #t;base case
      (and (char-whitespace? (car char-list)) (all-whitespace? (cdr char-list)))));check if the car and rest of the list is a whitespace


(define (remove-leading-whitespace char-list)
  (if (or (null? char-list) (not (char-whitespace? (car char-list))))
      char-list ;if the list is empty or doesn't start with whitespace, return it.
      (remove-leading-whitespace (cdr char-list))))



