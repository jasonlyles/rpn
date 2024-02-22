# Reverse Polish Notation Calculator

## Ruby Versions

This code is known to work with Ruby versions >= 2.6.5 Versions of Ruby < 2.6.5 may not work with this calculator, and <= 2.5.x are known to not work properly. The Ruby version for this code is set to 3.1.4, but you can update the .ruby-version file to use whatever Ruby you have installed that's >= 2.6.5.
## How to use the calculator

* To launch the calculator, change to the application's root dir and type `ruby app/calc.rb`.
* At the `>` prompt, enter numeric values and/or supported arithmetic operators in correct Reverse Polish Notation order. You can enter a single value at a time, or a sequence of values.
* The current supported arithmetic operators are +, -, * (multiplication) and / (division).
* Positive and negative values are supported.
* Decimals are supported.
* To quit the application, either type `q` and press `Enter` or type `Ctrl-C`

Some examples of proper usage:
```
> 5
5.0
> 8
8.0
> +
13.0
```
```
> 5 5 5 8 + + -
-13.0
> 13 +
0.0
```
```
> -3
-3.0
> -2
-2.0
> *
6.0
> 5
5.0
> +
11.0
```
```
> 5
5.0
> 9
9.0
> 1
1.0
> -
8.0
> /
0.625
```
To learn more, check out [Wikipedia](https://en.wikipedia.org/wiki/Reverse_Polish_notation)

## Solution

* First we take the input and split on spaces and run each of the values through a loop to make sure that they are either numeric or a supported operator.
* If the value is numeric, push it onto a stack.
* If the value is an operator, pop the last 2 values off the stack. If there are 2 numeric values we can get from the stack, perform the operation and push the result onto the stack. If there are not 2 numeric values, we have an operator being passed "out of turn". Raise an error and display a message to the calc user.

## Technical Choices

* I chose to separate the calculator and CLI functionality from each other because the CLI is one of several possible interfaces and the calculator class should encapsulate all of the calculator's functionality, and nothing else. The calculator class can be reused with another interface. (API, web view, etc)
* I set up a logger so we could see the inputs used and what was left on the stack when any errors might occur. This will help us troubleshoot any errors and work towards making the calculator more user-friendly by seeing what troubles users may commonly have. The error logging also hides the error details from the user for a more user-friendly experience.

## Trade-offs

If there were more time to spend on this project, we could:
1. Send the errors to an aggregation service so we wouldn't have to get the log on the server/user's machine.
2. Get quitting the program by using Ctrl-D working. I spent some time trying to make that work, but it was not cooperating. In the interest of getting this finished, I'm handling the error that it's throwing and displaying a friendly message to the user.
3. After writing a regex to be sure the order of the input was correct in the calc's `input_valid?` method, I thought that it would be more efficient, readable and maintainable to use a variable to keep track of if we had seen an operator or not yet. If we had, then we should not see any numeric values after that. If we did, then the input was out of order, and we could raise an error.
4. Implement up/down arrow key functionality so that the user can repeat values easily.
5. Determine the issues the app is encountering in Ruby versions older than 2.6.x and rewrite those portions of the app so that we could support Ruby >= 2.0.x

## TODO

* Should be able to quit the program using Ctrl-D. This currently throws an error that gets handled and displays a friendly message to the user.
* Remove the regex in `input_valid?` and use a variable for the loop below to track if we've seen an operator. There shouldn't be any numeric values once we see an operator.
* Write tests for the CLI
