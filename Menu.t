% menu screen

var wind : int
wind := Window.Open ("position:0;200,graphics:1280;680")
var font : int
View.Set ("offscreeenonly")
var back := Pic.FileNew ("table.jpg")
back := Pic.Scale (back, 1280, 680)
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

var x, y, btnNumber, btnUpDown, buttons : int


loop
Mouse.ButtonWait ("down", x, y, btnNumber, btnUpDown)
if 575 < x and x < 725 and 350 < y  and y < 400 then
    exit when true
elsif 575 < x and x < 725 and 250 < y and y < 300 then

elsif 575 < x and x < 725 and 150 < y and y < 200 then
    Window.Close(wind)
end if
end loop
include "GUI.t"
Window.Close(wind)
