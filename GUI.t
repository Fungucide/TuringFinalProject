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
backGround := Pic.Scale(backGround,1280,680)
Pic.Draw(backGround,0,0,0)

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

var score1, score2, score3, score4, pot, bet : int
score1 := 2000
score2 := 2000
score3 := 2000
score4 := 2000
pot := 0
bet := 0

%player hand
drawfillbox (525, 20, 625, 170, black)
drawfillbox (775, 20, 675, 170, black)
%top hand
drawfillbox (525, 510, 625, 660, black)
drawfillbox (775, 510, 675, 660, black)
%left hand
drawfillbox (20, 325, 170, 225, black)
drawfillbox (20, 375, 170, 475, black)
%right hand
drawfillbox (1110, 325, 1260, 225, black)
drawfillbox (1110, 375, 1260, 475, black)
%middle cards
drawfillbox (360, 230, 460, 380, black)
drawfillbox (480, 230, 580, 380, black)
drawfillbox (600, 230, 700, 380, black)
drawfillbox (720, 230, 820, 380, black)
drawfillbox (840, 230, 940, 380, black)
%points
font1 := Font.New ("serif:20")

Font.Draw ("Points: " + leftPad (score1, 4), 580, 180, font1, black)
Font.Draw ("Points: " + leftPad (score2, 4), 580, 480, font1, black)
Font.Draw ("Points: " + leftPad (score3, 4), 30, 490, font1, black)
Font.Draw ("Points: " + leftPad (score4, 4), 1120, 490, font1, black)
%pot and current bet
Font.Draw ("Pot: " + leftPad (pot, 4), 480, 400, font1, black)
Font.Draw ("Current bet: " + leftPad (bet, 4), 680, 400, font1, black)


getCardImage (1, 1, 525, 20, 1, 0)
getCardImage (12, 1, 675, 20, 1, 0)


% start actial game testing


include "GameClass.t"
var testGame : ^game
new game, testGame

var see : array 0..1 of ^card 

var cards : array 0 .. 51 of ^card

for i : 0 .. 51
    new card, cards (i)
    cards (i) -> setValues (i mod 13 + 1, i div 13 + 1)
end for
testGame -> initialize (cards)
% testGame -> dealPile -> listAll
testGame -> dealPlayer
testGame -> players(0)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)
put("")

testGame -> players(1)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)
put("")

testGame -> players(2)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)
put("")

testGame -> players(3)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)

testGame->dealCommunity(3)
