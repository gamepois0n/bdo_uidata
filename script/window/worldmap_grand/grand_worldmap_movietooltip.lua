local 	_title 			= UI.getChildControl( Panel_WorldMap_MovieGuide, "StaticText_MovieTitle" )
local 	_panelBG 		= UI.getChildControl( Panel_WorldMap_MovieGuide, "Static_MovieToolTipPanel_BG" )
local 	_btn_Close	 	= UI.getChildControl( Panel_WorldMap_MovieGuide, "Button_Close" )

local 	_btn_Movie_1 	= UI.getChildControl( Panel_WorldMap_MovieGuide, "Button_Movie_0" )
local 	_btn_Movie_2 	= UI.getChildControl( Panel_WorldMap_MovieGuide, "Button_Movie_1" )
local 	_btn_Movie_3 	= UI.getChildControl( Panel_WorldMap_MovieGuide, "Button_Movie_2" )
local 	_btn_Movie_4 	= UI.getChildControl( Panel_WorldMap_MovieGuide, "Button_Movie_3" )


function Panel_Worldmap_MovieGuide_Init()
	if isGameTypeKorea() or isGameTypeJapan() then
		_btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 18 .. ")" )
		_btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 19 .. ")" )
		_btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 22 .. ")" )
		_btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 27 .. ")" )
	elseif isGameTypeRussia() then
		_btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 12 .. ")" )
		_btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 13 .. ")" )
		_btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 16 .. ")" )
		_btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 21 .. ")" )
	elseif isGameTypeEnglish() then
		_btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 16 .. ")" )
		_btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 17 .. ")" )
		_btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 20 .. ")" )
		_btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 25 .. ")" )
	end

	_btn_Close:addInputEvent("Mouse_LUp", "Panel_Worldmap_MovieGuide_Toggle()")
	Panel_WorldMap_MovieGuide:SetPosX( 425 )
	Panel_WorldMap_MovieGuide:SetPosY( 70 )
	Panel_WorldMap_MovieGuide:SetShow(false );
end

function Panel_Worldmap_MovieGuide_Close()
	Panel_MovieTheater640_Initialize()
	Panel_MovieTheater_640:SetShow( false, false )

	if( ToClient_WorldMapIsShow() ) then
		WorldMapPopupManager:pop()
	end
end


function Panel_Worldmap_MovieGuide_Open()
	if	( ToClient_WorldMapIsShow() )	then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_WorldMap_MovieGuide, true )
	end

	-- Panel_MovieTheater_640:SetShow( true, true )

	if isGameTypeKorea() or isGameTypeJapan() then
		Panel_MovieTheater640_GameGuide_Func(18)
		_btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 18 .. ")" )
		_btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 19 .. ")" )
		_btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 22 .. ")" )
		_btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 27 .. ")" )
	elseif isGameTypeRussia() then
		Panel_MovieTheater640_GameGuide_Func(15)
		_btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 15 .. ")" )
		_btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 16 .. ")" )
		_btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 19 .. ")" )
		_btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 24 .. ")" )
	elseif isGameTypeEnglish() then
		Panel_MovieTheater640_GameGuide_Func(16)
		_btn_Movie_1:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 16 .. ")" )
		_btn_Movie_2:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 17 .. ")" )
		_btn_Movie_3:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 20 .. ")" )
		_btn_Movie_4:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_GameGuide_Func(" .. 25 .. ")" )
	end

	Panel_MovieTheater_640:SetPosX( getScreenSizeX()/2 - Panel_MovieTheater_640:GetSizeX()/2 )
	Panel_MovieTheater_640:SetPosY( getScreenSizeY()/2 - Panel_MovieTheater_640:GetSizeY()/2 )
	Panel_WorldMap_MovieGuide:SetPosX( Panel_MovieTheater_640:GetPosX() - Panel_WorldMap_MovieGuide:GetSizeX() - 5 )
	Panel_WorldMap_MovieGuide:SetPosY( Panel_MovieTheater_640:GetPosY() + Panel_MovieTheater_640:GetSizeY() - Panel_WorldMap_MovieGuide:GetSizeY())
end

function Panel_Worldmap_MovieGuide_Toggle()
	if ( Panel_WorldMap_MovieGuide:GetShow() == true ) then
		Panel_Worldmap_MovieGuide_Close()	
	else
		Panel_Worldmap_MovieGuide_Open()
	end
end

