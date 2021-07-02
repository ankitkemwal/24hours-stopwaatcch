# 24hours-stopwatch
The aim of this project is to demonstrate the working of a timer we use in our daily life. 
We are design a 24 hour Stopwatch using VHDL languge.

This code has three main components

1. Digital Counters
2. Binary to BCD converter
3. BCD to Seven Segment display

Binary counter are the sequential logic to count the clock signals. In the following code we are going to use 3 counters.
First counter is to count the seconds, Second counter is used to count the minutes, and third counter is used to count the hours.
The second and minutes counter counts from 0 to 59. And hour counter counts form 0 to 23.

This code will take 3 inputs
1. Reset
2. Clock
3. Start

Clock: - Clock pulse is the main component of this project. It frequency is equal to 1 second. The Second counter Counts the clock signal, Minute Counter counts the clock signal followed
by the hour counter.

Start: - Here start works as pause and play button. When Start = 1 the stopwatch will work and if start = 0 the stopwatch will get
pause until the start gets 1, and starts counting from the same point.

Reset: - It is used to reset the clock. If reset = 1 the stopwatch gets reset. If Reset = 0, the stopwatch will work.
Binary to BCD conversion, All the counters till now are counting in the binary form, But this data is need to be converted into two understandable form for 7-Segment display
that is BCD form.
