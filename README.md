# Number estimation task

Subjects report number of dots, briefly presented on screen. 
This codebase is made with the collaboration of the Hayden, Yoo, Sohn, Sheth, and Cantlon labs.
The dot generation part is based on Joonkoo Park’s code that systematically controls for size, density, etc (https://osf.io/s7xer/)

## description
entry point is main.m

## task
- Each trial, the computer select a number {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15} and present the dot stimuli for 1500ms.
- Subjects type a number using keyboard
- time course of a trial [ms]: 1500 dot, 500 delay, response (prompted by "="), 500 feedback, 500 ITI (with fixation mark)