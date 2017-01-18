% PokerHands.t
% Dec 5, 2016
% William Fung
% Poker Hands

% Updates
% ---------------------
% Dec 21, 2016
% - figuring out position for all cards
% ---------------------

var winID : int
winID := Window.Open ("position:0;200,graphics:1280;680")
var font1 : int
var image : int
View.Set ("offscreeenonly")
var backGround := Pic.FileNew ("table.jpg")
backGround := Pic.Scale (backGround, 1280, 680)
Pic.Draw (backGround, 0, 0, 0)

procedure getCardImage (value, suit, x, y, revealed, rotation : int)
    var imgName := "Cards/" + intstr (value) + intstr (suit) + ".gif"
    %put(imgName)

    if revealed = 1 then
	image := Pic.FileNew (imgName)
    else
	image := Pic.FileNew ("backOfCard.gif")
    end if
    image := Pic.Scale (image, 100, 150)
    image := Pic.Rotate (image, 90 * rotation, -1, -1)
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

var cards : array 0 .. 51 of ^card

for i : 0 .. 51
    new card, cards (i)
    cards (i) -> setValues (i mod 13 + 1, i div 13 + 1)
end for

% buttons
drawfillbox (800, 20, 1000, 70, grey)
drawfillbox (1010, 20, 1220, 70, grey)
drawfillbox (800, 100, 1000, 150, grey)
drawfillbox (1010, 100, 1220, 150, grey)

testGame -> initialize (cards)
% testGame -> dealPile -> listAll
testGame -> dealPlayer
testGame -> players (0) -> cards -> getCards (see)
%put(see(0)->value)
%put(see(0)->suit)
%put(see(1)->value)
%put(see(1)->suit)
getCardImage (see (0) -> value, see (0) -> suit, 525, 20, 1, 0)
getCardImage (see (1) -> value, see (1) -> suit, 675, 20, 1, 0)


testGame -> players (1) -> cards -> getCards (see)
%put(see(0)->value)
%put(see(0)->suit)
%put(see(1)->value)
%put(see(1)->suit)
getCardImage (see (0) -> value, see (0) -> suit, 1110, 225, 1, 3)
getCardImage (see (1) -> value, see (1) -> suit, 1110, 375, 1, 3)


testGame -> players (2) -> cards -> getCards (see)
%put(see(0)->value)
%put(see(0)->suit)
%put(see(1)->value)
%put(see(1)->suit)
getCardImage (see (0) -> value, see (0) -> suit, 525, 510, 1, 2)
getCardImage (see (1) -> value, see (1) -> suit, 675, 510, 1, 2)


testGame -> players (3) -> cards -> getCards (see)
%put(see(0)->value)
%put(see(0)->suit)
%put(see(1)->value)
%put(see(1)->suit)
getCardImage (see (0) -> value, see (0) -> suit, 20, 225, 1, 1)
getCardImage (see (1) -> value, see (1) -> suit, 20, 375, 1, 1)

testGame -> dealCommunity (3)

var community : array 0 .. 4 of ^card
% show community pile
testGame -> communityPile -> getCards (community)
getCardImage (community (0) -> value, community (0) -> suit, 360, 230, 1, 0)
getCardImage (community (1) -> value, community (1) -> suit, 480, 230, 1, 0)
getCardImage (community (2) -> value, community (2) -> suit, 600, 230, 1, 0)


var op : int
var p : int := 0
var amount : int
var b : int := 0

testGame -> raise ((testGame -> dealerPos + 1) mod 4, 100)
testGame -> raise (testGame -> dealerPos, 100)

b := 200

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
    if testGame -> players (p) -> folded = false then
	get op
	if op = 1 then
	    testGame -> call (p)
	elsif op = 2 then
	    get amount
	    testGame -> raise (p, amount)
	    b := testGame -> players (p) -> playerBet
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
getCardImage (community (3) -> value, community (3) -> suit, 720, 230, 1, 0)

% round 2
loop
    if testGame -> players (p) -> folded = false then
	get op
	if op = 1 then
	    testGame -> call (p)
	elsif op = 2 then
	    get amount
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
getCardImage (community (4) -> value, community (4) -> suit, 840, 230, 1, 0)

% round 3
loop
    if testGame -> players (p) -> folded = false then
	get op
	if op = 1 then
	    testGame -> call (p)
	elsif op = 2 then
	    get amount
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

put ""
put testGame -> checkWin
pause(1000)
