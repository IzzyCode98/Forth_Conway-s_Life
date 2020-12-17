{ ------------ create the array based on the size given in the graphics file ------------ }

variable array-size
variable array-address
bmp-x-size @ bmp-y-size @ * array-size !
create make_array array-size @ allocate drop
array-address !
: array_@ ( x y -- ) { finds the value at x,y coordinate of the array }
1 - bmp-x-size @ * swap 1 - + array-address @ + c@ ; 
: array_! ( n x y -- ) { puts the value n at x,y coordinate of the array }
 1 - bmp-x-size @ * swap 1 - + array-address @ + c! ;


{ --------------- words for counting live cells and exporting data--------------------}

variable pop                                      { population variable }
: clearpop 0 pop ! ;                              { Sets population variable to 0 }
  clearpop

: countpop array-size @ 0 do array-address @ i + c@ 1 = if 1 pop +! then loop ;

variable pop-data-id                             { Create Variable to hold file id handle }

: make-data-file                                  { Create a test file to read / write to  }
  s" C:\Users\isabe\Downloads\Conways_Life_Helper_Code_Examples_V4\ConwaysLife\Diff_Array_Life\popul_data.dat" r/w create-file drop  { Create the file } 
  pop-data-id !                                  { Store file handle for later use }
;

: close-data-file                                 { Close the file pointed to by the file  }
  pop-data-id @                                  { handle.                                }
  close-file drop
; 

: write-pop-data                                        { Write a series of integer numbers to a }               
  pop @ (.) pop-data-id @ write-line drop                { looped structure.  File must be open   }                                                     { for R/W access first.                  }
  ;


{ ------------ make pixel white for life (1) and black for dead (0) ------------ }

: white-pixel ( addr n -- )
  3 * swap 54 + + dup dup
  255 swap c!
  255 swap 1 + c!
  255 swap 2 + c! ;

: black-pixel ( addr n -- )
  3 * swap 54 + + dup dup
  0 swap c!
  0 swap 1 + c!
  0 swap 2 + c! ;

: liveordead 
array-size @ 0 do array-address @ i + c@ 
case
0 of bmp-address @ i black-pixel endof
1 of bmp-address @ i white-pixel endof 
." Error, no live or dead cell found. " 
endcase
loop ;


{ ------------ create an array to represent the number of live neighbours each cell has ------------ }

variable neighbour_array    
variable neibor_var
create make_neighbour_array array-size @ allocate drop
neighbour_array !


{ ------------ for each cell, check each neighbour cell to see it is dead or alive and put number of live neighbours into neighbour array ------------ }
{ ------------ setup for wrapped boundaries ------------ }

: add_1 array-address @ + C@ 1 = 
	if 1 neibor_var +! then ;

: test_right 
	dup bmp-x-size @ mod 0= 
	if bmp-x-size @ - then ;
: test_left
	dup 1 + bmp-x-size @ mod 0= 
	if bmp-x-size @ + then ;
: test_bottom
	dup array-size @ 1 - >
	if array-size @ - then ;
: test_top
	dup 0 < 
	if array-size @ + then ;


: countlive 0 neibor_var ! { reset the neighbour variable }
	1 + test_right add_1 { neighbour on right side }
	1 - test_left add_1 { neighbour on left side }
	bmp-x-size @ + test_bottom add_1 { neighbour on bottom }
	bmp-x-size @ - test_top add_1 { neighbour on top }
	bmp-x-size @ 1 + + test_right test_bottom add_1 { neighbour on bottom right diagonal }
	bmp-x-size @ 1 + - test_left test_top add_1 { neighbour on top left diagonal }
	bmp-x-size @ 1 - + test_left test_bottom add_1 { neighbour on bottom left diagonal }
	bmp-x-size @ 1 - - test_right test_top add_1 { neighbour on top right diagonal } ;

: count_neighbour array-size @ 0 do i dup dup dup dup dup dup dup { put 8 of i on the stack, loops through each cell in array }
	countlive neibor_var @ neighbour_array @ i + c! loop ;

  
{ ------------ apply Conway's Life rules, replace original array with next generation cells  ------------ }

: next_gen array-size @ 0 do array-address @ i + c@ case
0 of neighbour_array @ i + c@ case
3 of 1 array-address @ i + c! endof
0 array-address @ i + c! endcase endof
1 of neighbour_array @ i + c@ case
3 of 1 array-address @ i + c! endof 
2 of 1 array-address @ i + c! endof 
0 array-address @ i + c! endcase endof
endcase loop count_neighbour ;


{ ------------ go-life displays the evolution of life from a given starting array, stops with key press ------------ }

: go-life                           { Draw bmp to screen at variable pixel size       }
  cr ." Starting stretch to window test " 
  cr cr
  New-bmp-Window-stretch              { Create new "stretch" window                     }
  bmp-window-handle !                 { Store window handle                             }
  begin                            { Begin update / display loop                     }
  liveordead
  bmp-address @ bmp-to-screen-stretch { Stretch .bmp to display window                  }
  count_neighbour
  next_gen
  100 ms
  key?                             { Break test loop on key press                    }
  until                              { Delay for viewing ease, reduce for higher speed }
  cr ." Ending stretch to window test " 
  cr cr
  ;


{ ------------ go-data displays the evolution of life from a given starting array and exports population data, stops after 1000 generations ------------ }

variable gen_counter

: go-data                           { Draw bmp to screen at variable pixel size       }
  0 gen_counter !
  make-data-file
  cr ." Starting stretch to window test " 
  cr cr
  New-bmp-Window-stretch              { Create new "stretch" window                     }
  bmp-window-handle !                 { Store window handle                             }
  begin                            { Begin update / display loop                     }
  clearpop countpop                { sets population variable to zero and re-counts }
  write-pop-data
  liveordead
  bmp-address @ bmp-to-screen-stretch { Stretch .bmp to display window                  }
  count_neighbour
  next_gen
  1 gen_counter +!
  gen_counter @ 1000 =                             { Break test loop after 1000 generations}
  until                             
  cr ." Ending stretch to window test " 
  cr cr
  close-data-file ;

: go-data-only                           
  0 gen_counter !
  make-data-file
  cr ." Starting data collection " 
  cr cr
  begin                            { Begin update / display loop                     }
  clearpop countpop                { sets population variable to zero and re-counts }
  write-pop-data
  liveordead
  count_neighbour
  next_gen
  1 gen_counter +!
  gen_counter @ 1000 =                             { Break test loop after 1000 generations}
  until                             
  cr ." Ending data collection " 
  cr cr
  close-data-file ;

{ ------------ useful words for troubleshooting and seeing data ------------ }

: reset_neighbour neighbour_array @ array-size @ erase 0 neibor_var ! ;  
: show_neighbour array-size @ 0 do i bmp-x-size @ mod 0= if cr then neighbour_array @ i + c@ 3 .R loop ;

: reset_array array-address @ array-size @ erase reset_neighbour ;
: show_array array-size @ 0 do i bmp-x-size @ mod 0= if cr then array-address @ i + c@ 3 .R loop ; 

: clearstack depth 0 > if begin drop depth 0 = until then ;

{ ------------ do all data in 1 ------------ }

variable life%

: random-life-%
  array-size @ 0 do
  100 RND
  life% @ < if 1 
  else 0 then
  array-address @ i + c! loop ;


: go-data-all
  make-data-file
  cr ." Starting data collection " 
  cr cr
  101 0 do i life% !
  reset_array
  random-life-%                           
  0 gen_counter !  
  begin                            { Begin update / display loop                     }
  clearpop countpop                { sets population variable to zero and re-counts }
  write-pop-data
  liveordead
  count_neighbour
  next_gen
  1 gen_counter +!
  gen_counter @ 1000 =                             { Break test loop after 1000 generations}
  until  
  loop                           
  cr ." Ending data collection " 
  cr cr
  close-data-file ;
