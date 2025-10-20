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


(define (remove-leading-whitespace char-list)
  (if (or (null? char-list) (not (char-whitespace? (car char-list))))
      char-list ;if the list is empty or doesn't start with whitespace, return it.
      (remove-leading-whitespace (cdr char-list)))) 