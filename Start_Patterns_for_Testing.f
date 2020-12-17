{ ------------ new variables used in this file ------------ }

variable mid
bmp-x-size @ 2 / mid !		{ place starting patterns at the middle of given array }
variable life%		{ choose the % of starting live cells you want }


{ ------------ create simple starting patterns ------------ }

: make_glider
1 mid @ mid @ array_!
1 mid @ 2 + mid @ 1 - array_!
1 mid @ 2 + mid @ array_!
1 mid @ 1 + mid @ 1 + array_!
1 mid @ 2 + mid @ 1 + array_! ;

: pi-heptomino
1 mid @ mid @ array_!
1 mid @ 1 + mid @ array_!
1 mid @ 1 - mid @ array_!
1 mid @ 1 + mid @ 1 + array_!
1 mid @ 1 + mid @ 2 + array_!
1 mid @ 1 - mid @ 1 + array_!
1 mid @ 1 - mid @ 2 + array_! ;

: e-heptomino
1 mid @ mid @ array_!
1 mid @ 1 + mid @ array_!
1 mid @ 2 + mid @ array_!
1 mid @ mid @ 1 + array_!
1 mid @ mid @ 2 + array_!
1 mid @ 1 - mid @ 1 + array_!
1 mid @ 1 + mid @ 2 + array_! ;


{ ------------ create random array of live and dead cells ------------ }

: random-life-%
  array-size @ 0 do
  100 RND			{ starting live cells are distributed randomly }
  life% @ < if 1 
  else 0 then
  array-address @ i + c! loop ;
