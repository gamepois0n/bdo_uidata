local FindList = UI.getChildControl( Panel_WorldMap_Main, "List_ItemList" )
local IM = CppEnums.EProcessorInputMode
local isCloseWorldMap 			= false

Panel_WorldMap_Main:SetShow(false, false);

--function FromClient_WorldMapOpen()
--end


--registerEvent("FromClient_ExitWorldMap",				"FromClient_ExitWorldMap")
--registerEvent("FromClient_WorldMapOpen",				"FromClient_WorldMapOpen")
--registerEvent("FromClient_ImmediatelyCloseWorldMap",	"FGlobal_WorldMapClose")
