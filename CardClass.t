% CardClass.t
% Dec 5, 2016
% William Fung
% card and deck classes

% Updates
% ---------------------
% Dec 15, 2016
% - Initial Creation of file
% - Created DataType of stack
% - Fix stack pointers
% - Finished class card
% ---------------------
% Dec 16, 2016
% - Completed Pop and Push for deckOfCards
% - Fixed stackElement
% - Added Shuffling
% ---------------------
% Dec 17, 2016
% - Added a way to sort cards

% To do
% ---------------------
% - Add Hand Class


% Class representing a single card
class card

    export (value, suit, image, setValues, setImage, compare)

    % Vaues for class
    var value : int
    var suit : int
    var valueSet : boolean := false
    var image : int

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

    % Add Image for Card
    procedure setImage (path : string)
	image := Pic.FileNew (path)
    end setImage


    function compare (c : ^card) : int
	if value > c -> value then
	    result 1
	elsif value < c -> value then
	    result - 1
	else
	    result 0
	end if
    end compare
end card

% Class representing Deck of Cards
class deckOfCards

    % Deck of Cards needs class cards
    import card

    % Export Functions
    export (size, push, pop, peek, shuffle, listAll)

    % Variables
    var cards : flexible array 0 .. 0 of ^card
    var size : int := 0

    % Add a card to the deck
    procedure push (c : ^card)
	new cards, size + 1
	cards (size) := c
	size += 1
    end push

    % Take the top card off of the deck
    function pop : ^card
	var temp := cards (size)
	new cards, size - 1
	size -= 1
	result temp
    end pop

    % Look at the top card
    function peek : ^card
	result cards (size)
    end peek

    % Look at the card at element e
    function peekAtElement (e : int) : ^card
	result cards (e)
    end peekAtElement

    % Shuffle the order of the cards
    procedure shuffle
	var indexS : int
	var temp : ^card
	for i : 0 .. size - 1
	    indexS := Rand.Int (0, size - 1)
	    temp := cards (indexS)
	    cards (indexS) := cards (i)
	    cards (i) := temp
	end for
    end shuffle

    % Print out all the cards
    procedure listAll
	for i : 0 .. size - 1
	    put "Value: ", cards (i) -> value, " Suit: ", cards (i) -> suit
	end for
    end listAll

end deckOfCards

proc sort (var c : array 0 .. * of ^card)

    if upper (c) < 1 then
	return
    end if

    var fs : int
    var ss : int

    if (upper (c) + 1) mod 2 = 0 then
	fs := (upper (c) + 1) div 2 - 1
	ss := (upper (c) + 1) div 2 - 1
    else
	fs := upper (c) div 2 - 1
	ss := upper (c) div 2
    end if

    var f : array 0 .. fs of ^card
    var s : array 0 .. ss of ^card

    for i : 0 .. fs
	f (i) := c (i)
    end for

    for i : ss .. upper (c) - 1
	s (i - ss) := c (i)
    end for

    sort (f)
    sort (s)

    var fc, sc : int := 0
    for i : 0 .. upper (c)
	if fc > upper (f) then
	    c (i) := s (sc)
	    sc += 1
	elsif sc > upper (s) then
	    c (i) := f (fc)
	    fc += 1
	elsif f (fc) -> compare (s (sc)) = -1 then
	    c (i) := f (fc)
	    fc += 1
	else
	    c (i) := s (sc)
	    sc += 1
	end if
    end for
end sort
