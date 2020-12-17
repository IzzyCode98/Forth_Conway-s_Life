{ ------------ new variables used in this file ------------ }

variable mid
bmp-x-size @ 2 / mid !



{ ------------ create simple starting patterns ------------ }

: make_glider
1 mid @ mid @ array_!
1 mid @ 2 + mid @ 1 - array_!
1 mid @ 2 + mid @ array_!
1 mid @ 1 + mid @ 1 + array_!
1 mid @ 2 + mid @ 1 + array_! ;



{ ------------ create random array of live and dead cells ------------ }

: random-life-10%
  array-size @ 0 do
  10 RND
  0 = if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-20%
  array-size @ 0 do
  10 RND
  2 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-30%
  array-size @ 0 do
  10 RND
  3 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-40%
  array-size @ 0 do
  10 RND
  4 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-50%
  array-size @ 0 do
  10 RND
  5 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-60%
  array-size @ 0 do
  10 RND
  6 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-70%
  array-size @ 0 do
  10 RND
  7 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-80%
  array-size @ 0 do
  10 RND
  8 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: random-life-90%
  array-size @ 0 do
  10 RND
  9 < if 1 
  else 0 then
  array-address @ i + c! loop ;

: life-100%
  array-size @ 0 do
  1 array-address @ i + c! loop ;

