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
  100 ms			{ Delay for viewing ease, reduce for higher speed }
  key?                             { Break test loop on key press                    }
  until                              
  cr ." Ending stretch to window test " 
  cr cr
  ;


{ ------------ go-data displays the evolution of life from a given starting array and exports population data, stops after generation counter reaches generation limit ------------ }

variable gen_counter
variable gen_limit
1000 gen_limit !

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
  gen_counter @ gen_limit @ =                             { Break test loop after 1000 generations}
  until                             
  cr ." Ending stretch to window test " 
  cr cr
  close-data-file ;


{ ------------ go-data-only tracks the evolution of life from a given starting array and exports population data, stops after generation counter reaches generation limit, does not open display ------------ }

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
  gen_counter @ gen_limit @ =                             { Break test loop after 1000 generations}
  until                             
  cr ." Ending data collection " 
  cr cr
  close-data-file ;


{ ------------ go-data-all tracks the evolution of life and exports population data, stops after generation counter reaches generation limit and repeats for every integer % of a starting population, does not open display ------------ }

: go-data-all
  make-data-file
  cr ." Starting data collection " 
  cr cr
  101 0 do i dup . life% !		{ prints the starting % of the population with each loop to indicate how far through data collection it is }
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
  gen_counter @ gen_limit @ =                             { Break test loop after 1000 generations}
  until  
  loop                           
  cr ." Ending data collection " 
  cr cr
  close-data-file ;
