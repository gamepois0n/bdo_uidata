-- 통치 메뉴(지역정보)
CloseButton				= UI.getChildControl( Panel_Lord_Controller, "Button_Win_Close" )
RegionName				= UI.getChildControl( Panel_Lord_Controller, "StaticText_RegionName" )
MakingRateProgressBar	= UI.getChildControl( Panel_Lord_Controller, "Progress2_MakingRate" ) 	-- ?앹궛??
FishRateProgressBar		= UI.getChildControl( Panel_Lord_Controller, "Progress2_FishRate" ) 	-- 臾쇨퀬湲곕웾
MakingRateText			= UI.getChildControl( Panel_Lord_Controller, "StaticText_MakingRate" )	-- ?앹궛??% ?쒖떆
FishRateText			= UI.getChildControl( Panel_Lord_Controller, "StaticText_FishRate" )	-- 臾쇨퀬湲곕웾 % ?쒖떆

-- 통치메뉴(명령)
PlantControlButton		= UI.getChildControl( Panel_Lord_Controller, "Button_PlantControl" )	-- ?덉쥌媛쒕웾
FishControlButton		= UI.getChildControl( Panel_Lord_Controller, "Button_FishControl" )	-- 移섏뼱諛⑸쪟
RainControlButton		= UI.getChildControl( Panel_Lord_Controller, "Button_RainControl" )	-- 湲곗슦??

CloseButton:addInputEvent("Mouse_LUp", "FGlobal_LordManagerClose()");

function FGlobal_LordManagerClose()
		Panel_Lord_Controller:SetShow(false);
end

