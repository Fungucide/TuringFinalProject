% PokerHands.t
% Dec 5, 2016
% William Fung
% Poker Hands

% Updates
% ---------------------
% Dec 21, 2016
% - figuring out position for all cards
% ---------------------
var font1, font2 : int
var image : int
var backGround := Pic.FileNew ("table.jpg")
backGround := Pic.Scale (backGround, 1280, 680)
var x, y, btnNumber, btnUpDown, buttons : int
var win : array 0 .. 3 of boolean

var imgName : string
var names : array 1 .. 4, 1 .. 13, 0 .. 3 of int
for i : 1 .. 4
    for j : 1 .. 13
	for k : 0 .. 3
	    imgName := "Cards/" + intstr (j) + intstr (i) + ".gif"
	    names (i, j, k) := Pic.FileNew (imgName)
	    names (i, j, k) := Pic.Scale (names (i, j, k), 100, 150)
	    names (i, j, k) := Pic.Rotate (names (i, j, k), 90 * k, -1, -1)
	end for
    end for
end for

var cardBack : array 0 .. 3 of int
for i : 0 .. 3
    cardBack (i) := Pic.FileNew ("backOfCard.gif")
    cardBack (i) := Pic.Scale (cardBack (i), 100, 150)
    cardBack (i) := Pic.Rotate (cardBack (i), 90 * i, -1, -1)
end for

procedure getCardImage (value, suit, x, y, revealed, rotation : int)
    %var imgName := "Cards/" + intstr (value) + intstr (suit) + ".gif"
    %put(imgName)

    if revealed = 0 then
	image := names (suit, value, rotation)
    else
	image := cardBack (rotation)
    end if

    Pic.Draw (image, x, y, 0)
end getCardImage

function leftPad (input, leng : int) : string
    var ans : string := intstr (input)
    loop
	exit when length (ans) >= leng
	ans := "0" + ans
    end loop
    result ans
end leftPad


/*
 %player hand
 drawfillbox (525, 20, 625, 170, white)
 drawfillbox (775, 20, 675, 170, white)
 %top hand
 drawfillbox (525, 510, 625, 660, white)
 drawfillbox (775, 510, 675, 660, white)
 %left hand
 drawfillbox (20, 325, 170, 225, white)
 drawfillbox (20, 375, 170, 475, white)
 %right hand
 drawfillbox (1110, 325, 1260, 225, white)
 drawfillbox (1110, 375, 1260, 475, white)
 %middle cards
 drawfillbox (360, 230, 460, 380, white)
 drawfillbox (480, 230, 580, 380, white)
 drawfillbox (600, 230, 700, 380, white)
 drawfillbox (720, 230, 820, 380, white)
 drawfillbox (840, 230, 940, 380,white)
 %points
 */
font1 := Font.New ("serif:20")





%getCardImage (1, 1, 525, 20, 1, 0)
%getCardImage (12, 1, 675, 20, 1, 0)


% start actial game testing


include "GameClass.t"
var testGame : ^game
new game, testGame

var see : array 0 .. 1 of ^card
var foldCount : int
var cards : array 0 .. 51 of ^card

for i : 0 .. 51
    new card, cards (i)
    cards (i) -> setValues (i mod 13 + 1, i div 13 + 1)
end for

% buttons


procedure startGame
    var win : array 0 .. 3 of boolean
    testGame -> initialize (cards)
    loop
	foldCount := 0
	for i : 0 .. 3
	    if testGame -> players (i) -> points <= 0 then
		testGame -> players (i) -> fold
		foldCount += 1
	    end if
	end for
	if foldCount >= 3 then
	    exit when true
	end if

	testGame -> dealPlayer
	testGame -> players (0) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 525, 20, 1, 0)
	getCardImage (see (1) -> value, see (1) -> suit, 675, 20, 1, 0)


	testGame -> players (1) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, 1, 3)
	getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, 1, 3)


	testGame -> players (2) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 525, 510, 1, 2)
	getCardImage (see (1) -> value, see (1) -> suit, 675, 510, 1, 2)


	testGame -> players (3) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 220, 225, 1, 1)
	getCardImage (see (1) -> value, see (1) -> suit, 220, 375, 1, 1)

	testGame -> dealCommunity (3)


	testGame -> players (0) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 525, 20, 1, 0)
	getCardImage (see (1) -> value, see (1) -> suit, 675, 20, 1, 0)
	testGame -> players (1) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, 1, 3)
	getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, 1, 3)
	testGame -> players (2) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 525, 510, 1, 2)
	getCardImage (see (1) -> value, see (1) -> suit, 675, 510, 1, 2)
	testGame -> players (3) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 220, 225, 1, 1)
	getCardImage (see (1) -> value, see (1) -> suit, 220, 375, 1, 1)



	var community : array 0 .. 4 of ^card
	% show community pile
	testGame -> communityPile -> getCards (community)
	getCardImage (community (0) -> value, community (0) -> suit, 360, 230, 0, 0)
	getCardImage (community (1) -> value, community (1) -> suit, 480, 230, 0, 0)
	getCardImage (community (2) -> value, community (2) -> suit, 600, 230, 0, 0)


	var op : int
	var p : int := 0
	var amount : int
	var b : int := 0

	testGame -> raise ((testGame -> dealerPos + 1) mod 4, 100)
	testGame -> raise (testGame -> dealerPos, 100)

	b := 300

	drawfillbox (570, 175, 720, 205, green)
	drawfillbox (570, 475, 720, 505, green)
	drawfillbox (20, 485, 170, 515, green)
	drawfillbox (1115, 485, 1265, 515, green)
	drawfillbox (470, 395, 920, 425, green)
	% player bets
	Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	%pot and current bet
	Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)

	% round 1
	loop
	    if testGame -> players (p) -> folded = false or testGame -> players (p) -> points = 0 then

		drawfillbox (800, 20, 1000, 70, grey)
		drawfillbox (1010, 20, 1210, 70, grey)
		drawfillbox (800, 100, 1000, 150, grey)
		drawfillbox (1010, 100, 1210, 150, grey)
		Font.Draw ("Call", 875, 110, font1, black)
		Font.Draw ("Raise", 1075, 110, font1, black)
		Font.Draw ("Fold", 875, 30, font1, black)
		Font.Draw ("All-in", 1075, 30, font1, black)

		testGame -> players (0) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 525, 20, p, 0)
		getCardImage (see (1) -> value, see (1) -> suit, 675, 20, p, 0)
		testGame -> players (1) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, p - 1, 3)
		getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, p - 1, 3)
		testGame -> players (2) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 525, 510, p - 2, 2)
		getCardImage (see (1) -> value, see (1) -> suit, 675, 510, p - 2, 2)
		testGame -> players (3) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 220, 225, p - 3, 1)
		getCardImage (see (1) -> value, see (1) -> suit, 220, 375, p - 3, 1)

		loop
		    Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
		    if 800 < x and x < 1000 and 100 < y and y < 150 then
			op := 1
			exit when true
		    elsif 1010 < x and x < 1210 and 100 < y and y < 150 then
			op := 2
			exit when true
		    elsif 800 < x and x < 1000 and 20 < y and y < 70 then
			op := 3
			exit when true
		    elsif 1010 < x and x < 1210 and 20 < y and y < 70 then
			op := 4
			exit when true
		    end if
		end loop

		if op = 1 then
		    testGame -> call (p)
		elsif op = 2 then

		    drawfillbox (800, 20, 1000, 70, grey)
		    drawfillbox (1010, 20, 1210, 70, grey)
		    drawfillbox (800, 100, 1000, 150, grey)
		    drawfillbox (1010, 100, 1210, 150, grey)
		    Font.Draw ("$100", 875, 110, font1, black)
		    Font.Draw ("$200", 1075, 110, font1, black)
		    Font.Draw ("$300", 875, 30, font1, black)
		    Font.Draw ("$400", 1075, 30, font1, black)

		    loop
			Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
			if 800 < x and x < 1000 and 100 < y and y < 150 then
			    amount := 100
			    exit when true
			elsif 1010 < x and x < 1210 and 100 < y and y < 150 then
			    amount := 200
			    exit when true
			elsif 800 < x and x < 1000 and 20 < y and y < 70 then
			    amount := 300
			    exit when true
			elsif 1010 < x and x < 1210 and 20 < y and y < 70 then
			    amount := 400
			    exit when true
			end if
		    end loop

		    drawfillbox (800, 20, 1000, 70, grey)
		    drawfillbox (1010, 20, 1210, 70, grey)
		    drawfillbox (800, 100, 1000, 150, grey)
		    drawfillbox (1010, 100, 1210, 150, grey)
		    Font.Draw ("Call", 875, 110, font1, black)
		    Font.Draw ("Raise", 1075, 110, font1, black)
		    Font.Draw ("Fold", 875, 30, font1, black)
		    Font.Draw ("All-in", 1075, 30, font1, black)

		    testGame -> raise (p, amount)
		    b := testGame -> players (p) -> playerBet
		elsif op = 3 then
		    testGame -> fold (p)
		elsif op = 4 then
		    testGame -> allIn (p)
		    b := testGame -> players (p) -> playerBet
		end if
	    end if
	    p := p + 1
	    p := p mod 4
	    exit when testGame -> endRound
	    drawfillbox (570, 175, 720, 205, green)
	    drawfillbox (570, 475, 720, 505, green)
	    drawfillbox (20, 485, 170, 515, green)
	    drawfillbox (1115, 485, 1265, 515, green)
	    drawfillbox (470, 395, 920, 425, green)
	    % player bets
	    Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	    %pot and current bet
	    Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	    Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)
	end loop

	b := 0
	drawfillbox (570, 175, 720, 205, green)
	drawfillbox (570, 475, 720, 505, green)
	drawfillbox (20, 485, 170, 515, green)
	drawfillbox (1115, 485, 1265, 515, green)
	drawfillbox (470, 395, 920, 425, green)
	% player bets
	Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	%pot and current bet
	Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)

	testGame -> dealCommunity (1)
	testGame -> communityPile -> getCards (community)
	getCardImage (community (3) -> value, community (3) -> suit, 720, 230, 0, 0)

	% round 2
	loop
	    if testGame -> players (p) -> folded = false then
		testGame -> players (0) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 525, 20, p, 0)
		getCardImage (see (1) -> value, see (1) -> suit, 675, 20, p, 0)
		testGame -> players (1) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, p - 1, 3)
		getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, p - 1, 3)
		testGame -> players (2) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 525, 510, p - 2, 2)
		getCardImage (see (1) -> value, see (1) -> suit, 675, 510, p - 2, 2)
		testGame -> players (3) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 220, 225, p - 3, 1)
		getCardImage (see (1) -> value, see (1) -> suit, 220, 375, p - 3, 1)

		loop
		    Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
		    if 800 < x and x < 1000 and 100 < y and y < 150 then
			op := 1
			exit when true
		    elsif 1010 < x and x < 1210 and 100 < y and y < 150 then
			op := 2
			exit when true
		    elsif 800 < x and x < 1000 and 20 < y and y < 70 then
			op := 3
			exit when true
		    elsif 1010 < x and x < 1210 and 20 < y and y < 70 then
			op := 4
			exit when true
		    end if
		end loop

		if op = 1 then
		    testGame -> call (p)
		elsif op = 2 then

		    drawfillbox (800, 20, 1000, 70, grey)
		    drawfillbox (1010, 20, 1210, 70, grey)
		    drawfillbox (800, 100, 1000, 150, grey)
		    drawfillbox (1010, 100, 1210, 150, grey)
		    Font.Draw ("$100", 875, 110, font1, black)
		    Font.Draw ("$200", 1075, 110, font1, black)
		    Font.Draw ("$300", 875, 30, font1, black)
		    Font.Draw ("$400", 1075, 30, font1, black)

		    loop
			Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
			if 800 < x and x < 1000 and 100 < y and y < 150 then
			    amount := 100
			    exit when true
			elsif 1010 < x and x < 1210 and 100 < y and y < 150 then
			    amount := 200
			    exit when true
			elsif 800 < x and x < 1000 and 20 < y and y < 70 then
			    amount := 300
			    exit when true
			elsif 1010 < x and x < 1210 and 20 < y and y < 70 then
			    amount := 400
			    exit when true
			end if
		    end loop

		    drawfillbox (800, 20, 1000, 70, grey)
		    drawfillbox (1010, 20, 1210, 70, grey)
		    drawfillbox (800, 100, 1000, 150, grey)
		    drawfillbox (1010, 100, 1210, 150, grey)
		    Font.Draw ("Call", 875, 110, font1, black)
		    Font.Draw ("Raise", 1075, 110, font1, black)
		    Font.Draw ("Fold", 875, 30, font1, black)
		    Font.Draw ("All-in", 1075, 30, font1, black)

		    testGame -> raise (p, amount)
		    b := b + amount
		elsif op = 3 then
		    testGame -> fold (p)
		elsif op = 4 then
		    testGame -> allIn (p)
		end if
	    end if
	    p := p + 1
	    p := p mod 4
	    exit when testGame -> endRound
	    drawfillbox (570, 175, 720, 205, green)
	    drawfillbox (570, 475, 720, 505, green)
	    drawfillbox (20, 485, 170, 515, green)
	    drawfillbox (1115, 485, 1265, 515, green)
	    drawfillbox (470, 395, 920, 425, green)
	    % player bets
	    Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	    %pot and current bet
	    Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	    Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)
	end loop

	b := 0
	drawfillbox (570, 175, 720, 205, green)
	drawfillbox (570, 475, 720, 505, green)
	drawfillbox (20, 485, 170, 515, green)
	drawfillbox (1115, 485, 1265, 515, green)
	drawfillbox (470, 395, 920, 425, green)
	% player bets
	Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	%pot and current bet
	Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)

	testGame -> dealCommunity (1)
	testGame -> communityPile -> getCards (community)
	getCardImage (community (4) -> value, community (4) -> suit, 840, 230, 0, 0)

	% round 3
	loop
	    if testGame -> players (p) -> folded = false then
		testGame -> players (0) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 525, 20, p, 0)
		getCardImage (see (1) -> value, see (1) -> suit, 675, 20, p, 0)
		testGame -> players (1) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, p - 1, 3)
		getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, p - 1, 3)
		testGame -> players (2) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 525, 510, p - 2, 2)
		getCardImage (see (1) -> value, see (1) -> suit, 675, 510, p - 2, 2)
		testGame -> players (3) -> cards -> getCards (see)
		getCardImage (see (0) -> value, see (0) -> suit, 220, 225, p - 3, 1)
		getCardImage (see (1) -> value, see (1) -> suit, 220, 375, p - 3, 1)

		loop
		    Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
		    if 800 < x and x < 1000 and 100 < y and y < 150 then
			op := 1
			exit when true
		    elsif 1010 < x and x < 1210 and 100 < y and y < 150 then
			op := 2
			exit when true
		    elsif 800 < x and x < 1000 and 20 < y and y < 70 then
			op := 3
			exit when true
		    elsif 1010 < x and x < 1210 and 20 < y and y < 70 then
			op := 4
			exit when true
		    end if
		end loop

		if op = 1 then
		    testGame -> call (p)
		elsif op = 2 then

		    drawfillbox (800, 20, 1000, 70, grey)
		    drawfillbox (1010, 20, 1210, 70, grey)
		    drawfillbox (800, 100, 1000, 150, grey)
		    drawfillbox (1010, 100, 1210, 150, grey)
		    Font.Draw ("$100", 875, 110, font1, black)
		    Font.Draw ("$200", 1075, 110, font1, black)
		    Font.Draw ("$300", 875, 30, font1, black)
		    Font.Draw ("$400", 1075, 30, font1, black)

		    loop
			Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
			if 800 < x and x < 1000 and 100 < y and y < 150 then
			    amount := 100
			    exit when true
			elsif 1010 < x and x < 1210 and 100 < y and y < 150 then
			    amount := 200
			    exit when true
			elsif 800 < x and x < 1000 and 20 < y and y < 70 then
			    amount := 300
			    exit when true
			elsif 1010 < x and x < 1210 and 20 < y and y < 70 then
			    amount := 400
			    exit when true
			end if
		    end loop

		    drawfillbox (800, 20, 1000, 70, grey)
		    drawfillbox (1010, 20, 1210, 70, grey)
		    drawfillbox (800, 100, 1000, 150, grey)
		    drawfillbox (1010, 100, 1210, 150, grey)
		    Font.Draw ("Call", 875, 110, font1, black)
		    Font.Draw ("Raise", 1075, 110, font1, black)
		    Font.Draw ("Fold", 875, 30, font1, black)
		    Font.Draw ("All-in", 1075, 30, font1, black)

		    testGame -> raise (p, amount)
		    b := b + amount
		elsif op = 3 then
		    testGame -> fold (p)
		elsif op = 4 then
		    testGame -> allIn (p)
		end if
	    end if
	    p := p + 1
	    p := p mod 4
	    exit when testGame -> endRound
	    drawfillbox (570, 175, 720, 205, green)
	    drawfillbox (570, 475, 720, 505, green)
	    drawfillbox (20, 485, 170, 515, green)
	    drawfillbox (1115, 485, 1265, 515, green)
	    drawfillbox (470, 395, 920, 425, green)
	    % player bets
	    Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	    Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	    %pot and current bet
	    Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	    Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)
	end loop

	b := 0
	drawfillbox (570, 175, 720, 205, green)
	drawfillbox (570, 475, 720, 505, green)
	drawfillbox (20, 485, 170, 515, green)
	drawfillbox (1115, 485, 1265, 515, green)
	drawfillbox (470, 395, 920, 425, green)
	% player bets
	Font.Draw ("Points: " + leftPad (testGame -> players (0) -> points, 4), 580, 180, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (2) -> points, 4), 580, 480, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (3) -> points, 4), 30, 490, font1, white)
	Font.Draw ("Points: " + leftPad (testGame -> players (1) -> points, 4), 1120, 490, font1, white)
	%pot and current bet
	Font.Draw ("Pot: " + leftPad (testGame -> pot, 4), 480, 400, font1, white)
	Font.Draw ("Current points: " + leftPad (b, 4), 680, 400, font1, white)


	var numberOfPlayersWon : int := 0
	win := testGame -> checkWin
	for i : 0 .. 3
	    if win (i) then
		numberOfPlayersWon += 1
	    end if
	end for
	for i : 0 .. 3
	    if win (i) then
		testGame -> players (i) -> win (testGame -> pot div numberOfPlayersWon)
	    end if
	end for

	testGame -> players (0) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 525, 20, 0, 0)
	getCardImage (see (1) -> value, see (1) -> suit, 675, 20, 0, 0)
	testGame -> players (1) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, 0, 3)
	getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, 0, 3)
	testGame -> players (2) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 525, 510, 0, 2)
	getCardImage (see (1) -> value, see (1) -> suit, 675, 510, 0, 2)
	testGame -> players (3) -> cards -> getCards (see)
	getCardImage (see (0) -> value, see (0) -> suit, 220, 225, 0, 1)
	getCardImage (see (1) -> value, see (1) -> suit, 220, 375, 0, 1)

	Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)

	var temp : ^card

	loop
	    temp := testGame -> burnPile -> pop
	    exit when testGame -> burnPile -> size = -1
	end loop

	testGame -> communityPile -> clearHand
	testGame -> players (0) -> cards -> clearHand
	testGame -> players (1) -> cards -> clearHand
	testGame -> players (2) -> cards -> clearHand
	testGame -> players (3) -> cards -> clearHand
	testGame -> players (0) -> unfold
	testGame -> players (1) -> unfold
	testGame -> players (2) -> unfold
	testGame -> players (3) -> unfold
	testGame -> setDeck (cards)
	testGame -> clearPot

	Pic.Draw (backGround, 0, 0, 0)
    end loop
    drawfillbox (0, 0, 1280, 680, black)
    font2 := Font.New ("serif:100")
    for i : 0 .. 3
	if win (i) then
	    Font.Draw ("Player " + intstr (i + 1 mod 4) + " won", 20, 200, font2, white)
	end if
    end for
    Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
    return
end startGame
