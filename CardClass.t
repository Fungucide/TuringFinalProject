% Classes.t
% Dec 5, 2016
% William Fung
% card and deck classes

% Updates
% ---------------------
% Dec 5, 2016
% - Initial Creation of file
% - Created DataType of stack
% - Fix stack pointers
% - Finished class card
% ---------------------
% Dec 6, 2016
% - Completed Pop and Push for deckOfCards
% - Fixed stackElement
% - Added Shuffling
% ---------------------
% Dec 7, 2016
% -

% To do
% ---------------------
% - Add a way to shuffle cards
% - Fix stackElement


class card

    export (value, suit, sprite, setValues)
    % Vaues for class
    var value : int
    var suit : int
    var valueSet : boolean := false
    var sprite : int

    % Set values of card
    procedure setValues (v, s : int)

	% Check for value exceptions
	if v < 1 or v > 14 or s < 1 or s > 4 then
	    put "Error"
	    quit
	end if

	% Check for value already set
	if valueSet then
	    put "Error"
	    quit
	end if

	% Set Values
	value := v
	suit := s
	valueSet := true

    end setValues

    procedure setSprite (path : string)
	sprite := Pic.FileNew (path)
    end setSprite


end card

class deckOfCards

    import card
    export (size, push, pop, peek, shuffle, listAll)
    var cards : flexible array 0 .. 0 of ^card
    var size : int := 0

    procedure push (c : ^card)
	new cards, size + 1
	cards (size) := c
	size += 1
    end push

    procedure pop (var c : ^card)
	c := cards (size)
	new cards, size - 1
	size -= 1
    end pop

    procedure peek (var c : ^card)
	c := cards (size)
    end peek

    procedure shuffle
	var indexS : int
	var temp : ^card
	for i : 0 .. size - 1
	    indexS := Rand.Int (0, size -1)
	    temp := cards (indexS)
	    cards (indexS) := cards (i)
	    cards (i) := temp
	end for
    end shuffle

    procedure listAll
	for i : 0 .. size-1
	    put "Value: ", cards (i) -> value, " Suit: ", cards (i) -> suit
	end for
    end listAll
end deckOfCards


