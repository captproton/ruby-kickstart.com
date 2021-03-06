Description
-----------

Website for [ruby-kickstart.com](http://ruby-kickstart.com).
It is written in Sinatra.


Contributing
------------

I welcome contributions. The tests are not complete, unfortunately. I welcome
tests as well as help making the styles better, fixing bugs, making quiz
questions better, etc.


Infrastructure
--------------

The basic relationship is that quizzes have lots of quiz problems. There are
four types of quiz problems, predicate (true/false), match answer (user submits
text that is matched against a regex), multiple choice (select one of the options),
and many to many (many questions, many answers, user lines them up).

When a user takes a quiz, a quiz taken is created, which tracks the quiz the
user took. For each of the quiz's questions, the quiz taken has a solution.
The solutions mimic the problems (ie a solution type for each of the four
problem types).

Here is the basic infrastructure, in something sort of resembling an ER Diagram.

![er diagram](https://github.com/JoshCheek/ruby-kickstart.com/raw/master/resources/er-diagram.png)


Licenses
--------

The code in public/murano is under its own license given in that directory.

Everything else in this project is under the MIT license:

---------------------------------------

Copyright (c) 2011 Joshua Cheek

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
