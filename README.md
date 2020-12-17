# Forth_Conway-s_Life

How to use this code:
1. First, go into the Export_and_Display file and change the file address in the make-data-file definition to a location on your computer folder. Note: the file name should not contain any spaces.
2. Decide what size array you would like between the options: 100x100, 500x500
3. Drag the 'Graphics_forXarray' file, where X is the array size you would like, into the SwiftForth console.
4. Decide what rule set you would like to apply to your Life Array. See below for descriptions of the different rule sets.
5. Drag the 'Conways_Life_X_Rules' file, where X represents the type of rule set you have chosen, into the SwiftForth console.
6. Drag the 'Start_Patterns_for_Testing' file into the SwiftForth console.
7. Drag the 'Export_and_Display' file into the SwiftForth console.
8. Decide on a starting setup, see below, and choose to display and/or export data from the Life Program, see below.
9. Note that the generation counter limit (for exporting data) is set to 1000 by default but can be changed by writing into the console:
      X gen_limit ! 
      where X is the limit you want. 

Rule sets:
- Conways_Life_Original_Rules: this uses the original rule set for Conway's Game of Life - cells stay alive with 2 or 3 neighbours and come alive with 3 neighbours
- Conways_Life_MoreReproductive_Rules: this changes the rules so cells stay alive with 2 or 3 neighbours and come alive with 2 or 3 neighbours
- Conways_Life_MoreResource_Rules: this changes the rules so cells stay alive with 2, 3, or 4 neighbours and come alive with 3 or 4 neighbours
- Conways_Life_Solitary_Rules: this changes the rules so cells stay alive with 0, 1, or 2 neighbours and come alive with 2 neighbours
- Conways_Life_Group_Rules: this changes the rules so cells stay alive with 4, 5, or 6 neighbours and come alive with 5 or 6 neighbours

Starting setups for manual input:
- make_glider: create a glider in the middle of the array which travels up and to the right such that it hits the top right corner of the array
- pi-heptomino: create the methuselah seed, pi-heptomino, in the middle of the array
- e-heptomino: create the methuselah seed, e-heptomino, in the middle of the array
- random-life-%: use this to start the array with a random array of 0's and 1's where the 1's occupy a desired % of the entire available population, determined first using:
       X life% !
       where X is the % you want (values 0 to 100). 
- reset_array: be sure to use this to clear the array if you want a fresh start with something else!
- show_array: use this to print the 0 and 1 values of the starting array to the console 
- you can build your own starting patterns using array_! ( n x y -- ) which puts the value n (which should be 0 or 1) at the (x,y) coordinate of the array

Display and/or export data by typing one of the following words into the console:
- go-life: displays the evolution of life from a given starting array, stops with key press
- go-data: displays the evolution of life from a given starting array and exports population data, stops after generation counter reaches generation limit
- go-data-only: tracks the evolution of life from a given starting array and exports population data, stops after generation counter reaches generation limit, does not open display
- go-data-all: tracks the evolution of life and exports population data, stops after generation counter reaches generation limit and repeats for every integer % of a starting population, prints the starting % of the population with each loop to indicate how far through data collection it is, does not open display
