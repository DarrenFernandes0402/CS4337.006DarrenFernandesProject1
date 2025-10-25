Sunday October 19, 2025
I looked at the project and worked on it a bit so far. I know that subtraction is something I do not have to worry about to that is good. My initial thoughts were that there definitely have to be different functions for each part, since we need to handle multiple things. I think addition and multiplication can be the same function but division and a negative number have to be dealt with separately. So far I have made something to remove leading whitespaces based on what I think I will need. I might work on the main function next just to see what else I will need as I move through it.
I also added one more thing, the main loop. this is the loop taht first checks if it is in batch mode or regular mode. I also added the read method and the exit strategy. 
I added some mroe functionality to the main loop, I added the error handling method, a method to get the values from something that evaluates the necessary values, and something to check if there is anything remining in the expressions. I also then looped back to the main expression and added a fail case. The history keeps adding things to the start of history, which means when I add something to get it, I will reverse the list.
I think I might ask the professor for some help with the batch mode.


Monday October 20th, 2025
About to start on some more funcitons but I am not sure how much I can do since I do have class.
Today was much better, and I got as decent bit done for the code. I got to add the main functionality, the functions that do the evaluation of the functions. This mainly calls the functions that should do the necessary evaluations, but calls and handles them as needed.
I should also be able to work on it tomorrow since I am free, and I hope to get a large part of the code done.

Tuesday October 21st, 2025
Got up early for class and got that done. Hoping I can tackle a huge part of the code now.
Today I did get the bulkiest part of the code done. that specific functions that do the actual math and calculations. These were a bit tricky and I did rearrange the methods a bit, but I did stick to the original structure I had used with the evaluation method. I only need to implement the batch method and the normal main method such that the calculator runs. And ofcourse, test it.
Hope to get the main loop and testing done tomorrow and submit early

Friday October 24th, 2025
Those plans were shot. I was up late working on another class' homework and could not get this done. I then messed up my sleep schedule and slept at 5AM, then got up at 7:30 for class. today I had to go to work for the first hal;f of the day, but the main loop is pretty easy so hoping it works
Today I finally got to the rest of the code. implemented the final funcitons needed as well as the main method. I did also integrate the batch and prompt mode, and tested it. I am unable to test it for some reason on the command prompt.
Turns out I needed to add racket to my binaries, but i do not want to do that, so I just used the system path to run it. It worked! Well by worked i mean quit and batch mode did not work, but it ran!
The error was in the quit function that did not have the right way to get strings in. Even my batch mode wasn't working but that's because I was running it with echo and quotes, which sent the quotes in as well as the expressions. It does work!
Time to work on the readme:)