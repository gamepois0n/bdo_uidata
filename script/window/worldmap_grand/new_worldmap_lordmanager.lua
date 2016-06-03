-- ÅëÄ¡ ¸Ş´º(Áö¿ªÁ¤º¸)
CloseButton				= UI.getChildControl( Panel_Lord_Controller, "Button_Win_Close" )
RegionName				= UI.getChildControl( Panel_Lord_Controller, "StaticText_RegionName" )
MakingRateProgressBar	= UI.getChildControl( Panel_Lord_Controller, "Progress2_MakingRate" ) 	-- ?ì‚°??
FishRateProgressBar		= UI.getChildControl( Panel_Lord_Controller, "Progress2_FishRate" ) 	-- ë¬¼ê³ ê¸°ëŸ‰
MakingRateText			= UI.getChildControl( Panel_Lord_Controller, "StaticText_MakingRate" )	-- ?ì‚°??% ?œì‹œ
FishRateText			= UI.getChildControl( Panel_Lord_Controller, "StaticText_FishRate" )	-- ë¬¼ê³ ê¸°ëŸ‰ % ?œì‹œ

-- ÅëÄ¡¸Ş´º(¸í·É)
PlantControlButton		= UI.getChildControl( Panel_Lord_Controller, "Button_PlantControl" )	-- ?ˆì¢…ê°œëŸ‰
FishControlButton		= UI.getChildControl( Panel_Lord_Controller, "Button_FishControl" )	-- ì¹˜ì–´ë°©ë¥˜
RainControlButton		= UI.getChildControl( Panel_Lord_Controller, "Button_RainControl" )	-- ê¸°ìš°??

CloseButton:addInputEvent("Mouse_LUp", "FGlobal_LordManagerClose()");

function FGlobal_LordManagerClose()
		Panel_Lord_Controller:SetShow(false);
end

