#!/bin/sed -f

# print all uniq lines on a sorted input-- only one copy of a duplicated
# line is printed
# like `uniq'

:b
$b
N
/^\(.*\)\n\1$/{
        s/.*\n//
        bb
}

$b

P
D
