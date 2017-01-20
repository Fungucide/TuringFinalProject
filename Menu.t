% menu screen

var wind : int
wind := Window.Open ("position:0;200,graphics:1280;680")
var font : int
View.Set ("offscreeenonly")
var back := Pic.FileNew ("table.jpg")
back := Pic.Scale (back, 1280, 680)
Pic.Draw (back, 0, 0, 0)
include "GUI.t"

var mx, my, mbtnNumber, mbtnUpDown : int


loop
    Pic.Draw (back, 0, 0, 0)
    font := Font.New ("serif:80")
    Font.Draw ("Texas Hold'em", 320, 450, font, white)
    drawfillbox (575, 350, 725, 400, white)
    drawfillbox (575, 250, 725, 300, white)
    drawfillbox (575, 150, 725, 200, white)

    font := Font.New ("serif:20")
    Font.Draw ("Play", 625, 360, font, black)
    Font.Draw ("Instructions", 590, 260, font, black)
    Font.Draw ("Exit", 625, 160, font, black)

    Mouse.ButtonWait ("down", mx, my, mbtnNumber, mbtnUpDown)
    if 575 < mx and mx < 725 and 350 < my and my < 400 then
	Pic.Draw (back, 0, 0, 0)
	startGame
    elsif 575 < mx and mx < 725 and 250 < my and my < 300 then
	Pic.Draw (back, 0, 0, 0)
	Font.Draw ("1. click on play", 100, 600, font, white)
	Font.Draw ("2. the four commands are", 100, 550, font, white)
	Font.Draw ("call: match the current point invested", 200, 500, font, white)
	Font.Draw ("raise: add a certain amount to points invested", 200, 450, font, white)
	Font.Draw ("fold: drop out of the current round", 200, 400, font, white)
	Font.Draw ("all-in: invest all your points", 200, 350, font, white)
	Font.Draw ("3. after five cards are dealt to the centre, the player with the highest hand get all points invested", 100, 300, font, white)
	Font.Draw ("4. repear until all but one player has 0 points", 100, 250, font, white)
	Font.Draw ("click to return to menu", 550, 170, font, white)
	Mouse.ButtonWait ("down", mx, my, mbtnNumber, mbtnUpDown)
	Pic.Draw (back, 0, 0, 0)
    elsif 575 < mx and mx < 725 and 150 < my and my < 200 then
	Window.Close (wind)
    end if
end loop


