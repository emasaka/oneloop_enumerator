# oneloop_enumerator

Run method chain of Enumerable object in one loop.

## Description

Following expression:

    (1..10000).map {|i|
         # something 1
       }.inject {|r, i|
         # something 2
       }

executes 'something 1' 10000 times, then executes 'something 2' 10000 times.

However, following expression:

    require 'oneloop_enumerator'

    (1..10000).to_oneloop_enumerator.map {|i|
         # something 1
       }.inject {|r, i|
         # something 2
       }

executes 'something 1 and something 2' 10000 times (in one loop).

## Warnings

* It's just a experimental implementation

