local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE


Panel_BuyDrink:SetShow( false )
Panel_BuyDrink:setMaskingChild( true )
Panel_BuyDrink:ActiveMouseEventEffect( true )
Panel_BuyDrink:setGlassBackground( true )

Panel_BuyDrink:RegisterShowEventFunc( true, 'BuyDrinkShowAni()' )
Panel_BuyDrink:RegisterShowEventFunc( false, 'BuyDrinkHideAni()' )

function BuyDrinkShowAni()
	UIAni.fadeInSCR_Down(Panel_BuyDrink)
	audioPostEvent_SystemUi(01,00)
end

function BuyDrinkHideAni()
	Panel_BuyDrink:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_BuyDrink:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( Defines.Color.C_FFFFFFFF )
	aniInfo1:SetEndColor( Defines.Color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	audioPostEvent_SystemUi(01,01)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ui =
{
	_btn_WinClose			= UI.getChildControl ( Panel_BuyDrink, "Button_Close" ),
	_btn_Close				= UI.getChildControl ( Panel_BuyDrink, "Button_CloseWindow" ),
	
	_buttonQuestion			= UI.getChildControl ( Panel_BuyDrink, "Button_Question" ),	-- 물음표 버튼
	
	_titleImage				= UI.getChildControl ( Panel_BuyDrink, "StaticText_TitleImage" ),
	_descBG					= UI.getChildControl ( Panel_BuyDrink, "Static_DescBG" ),
	_frameBuyDrink			= UI.getChildControl ( Panel_BuyDrink, "Frame_BuyDrink" ),
	_frameScroll,--			= UI.getChildControl ( _frameBuyDrink, 	"VerticalScroll" ),
	_frameContent,	--		= UI.getChildControl ( _frameBuyDrink, 	"Frame_1_Content" ),
	_txt_Desc,		--		= UI.getChildControl ( _frameContent, "StaticText_Desc" ),
	
	_txt_FindWay			= UI.getChildControl ( Panel_BuyDrink, "StaticText_FindWay_Title" ),
	_base_Way				= UI.getChildControl ( Panel_BuyDrink, "Button_C_WayPoint" ),
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------
--			변수 모음
local findWay_StartY = 0
local findWayBtn_StartY = 0
local getBottom = 0
local test_Category = 2
local knowledgeCount = 6
local totalPanelSizeY = 0


------------------------------------------------------------------------
--				descBG의 하단 위치를 알기위한 함수
------------------------------------------------------------------------
local GetBottomPos = function(control)
	if ( nil == control ) then
		UI.ASSERT(false, "GetBottomPos(control) , control nil")
		return
	end
	return control:GetPosY() + control:GetSizeY()
end

------------------------------------------------------------------------
--							초기화 함수
------------------------------------------------------------------------
function Panel_BuyDrink_Initialize()
	ui._frameScroll = UI.getChildControl ( ui._frameBuyDrink, 	"VerticalScroll" )
	ui._frameContent	= UI.getChildControl ( ui._frameBuyDrink, 	"Frame_1_Content" )
	ui._txt_Desc = UI.getChildControl ( ui._frameContent, "StaticText_Desc" )
	
	ui._frameScroll:SetControlPos(0)
	
	ui._btn_WinClose:addInputEvent( "Mouse_LUp", "Panel_BuyDrink_ShowToggle()" )
	ui._btn_Close:addInputEvent( "Mouse_LUp", "Panel_BuyDrink_ShowToggle()" )
	
	ui._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelBuyDrink\" )" )						-- 물음표 좌클릭
	ui._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelBuyDrink\", \"true\")" )			--물음표 마우스오버
	ui._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelBuyDrink\", \"false\")" )		--물음표 마우스아웃
	
	Panel_BuyDrink_UpdateFunc()
	
	ui._frameBuyDrink:UpdateContentScroll()		-- 스크롤 감도 동일하게
end

------------------------------------------------------------------------
--							업데이트 함수
------------------------------------------------------------------------
function Panel_BuyDrink_UpdateFunc(message)
	ui._btn_Close:SetShow( true )
	ui._txt_FindWay:SetShow( false )
	ui._base_Way:SetShow( false )

	if ( test_Category == 0 ) then		-- 팁
		ui._titleImage:ChangeTextureInfoName ( "new_ui_common_forlua/window/buydrink/buydrink_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( ui._titleImage, 1, 145, 347, 180 )
		ui._titleImage:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui._titleImage:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_TIP" ) )	-- 중요한 팁

		ui._txt_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		ui._txt_Desc:SetAutoResize( true )
		ui._txt_Desc:SetText( "TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP TIP " )
		ui._txt_Desc:SetSize( ui._txt_Desc:GetSizeX(), ui._txt_Desc:GetSizeY() )
		ui._descBG:SetSize( ui._descBG:GetSizeX(), ui._txt_Desc:GetSizeY() + 10 )
			getBottom = GetBottomPos( ui._descBG ) + 10
		
		ui._btn_Close:SetShow( true )
		ui._btn_Close:SetPosY( getBottom )
			getBottom = GetBottomPos( ui._btn_Close ) + 7
		
			Panel_BuyDrink:SetSize( Panel_BuyDrink:GetSizeX(), getBottom )
		
	elseif ( test_Category == 1 ) then	-- 소문
		ui._titleImage:ChangeTextureInfoName ( "new_ui_common_forlua/window/buydrink/buydrink_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( ui._titleImage, 1, 37, 347, 72 )
		ui._titleImage:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui._titleImage:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_RUMOR" ) )	-- 소 문

		ui._txt_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		ui._txt_Desc:SetAutoResize( true )
		ui._txt_Desc:SetText( "자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와자와" )
		ui._txt_Desc:SetSize( ui._txt_Desc:GetSizeX(), ui._txt_Desc:GetSizeY() )
		ui._descBG:SetSize( ui._descBG:GetSizeX(), ui._txt_Desc:GetSizeY() + 10 )
			getBottom = GetBottomPos( ui._descBG ) + 10
		
		ui._btn_Close:SetShow( true )
		ui._btn_Close:SetPosY( getBottom )
			getBottom = GetBottomPos( ui._btn_Close ) + 7
		
			Panel_BuyDrink:SetSize( Panel_BuyDrink:GetSizeX(), getBottom )
		
	elseif ( test_Category == 2 ) then	-- 지식
		ui._titleImage:ChangeTextureInfoName ( "new_ui_common_forlua/window/buydrink/buydrink_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( ui._titleImage, 1, 73, 347, 108 )
		ui._titleImage:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui._titleImage:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_KNOWLEDGE" ) )	-- 지 식
		
		ui._txt_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		ui._txt_Desc:SetAutoResize( true )
		ui._txt_Desc:SetText( message )
		
		if 110 < ui._txt_Desc:GetSizeY() then
			ui._frameScroll:SetShow(true)
		else
			ui._frameScroll:SetShow(false)
		end
		ui._frameScroll:SetControlPos(0)
		ui._frameContent:SetSize( ui._frameContent:GetSizeX(), ui._txt_Desc:GetSizeY() )
		
	--	ui._txt_Desc:SetSize( ui._txt_Desc:GetSizeX(), ui._txt_Desc:GetSizeY() )
	--	ui._descBG:SetSize( ui._descBG:GetSizeX(), ui._txt_Desc:GetSizeY() + 10 ) 
	--		getBottom = GetBottomPos( ui._descBG ) + 10
		
		ui._btn_Close:SetShow( true )
	--	ui._btn_Close:SetPosY( getBottom )
	--		getBottom = GetBottomPos( ui._btn_Close ) + 7
		
	--		Panel_BuyDrink:SetSize( Panel_BuyDrink:GetSizeX(), getBottom )
		
	elseif ( test_Category == 3 ) then	-- 위치
		ui._titleImage:ChangeTextureInfoName ( "new_ui_common_forlua/window/buydrink/buydrink_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( ui._titleImage, 1, 1, 347, 36 )
		ui._titleImage:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui._titleImage:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_LOCATION" ) )	-- 위 치
		
		ui._txt_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		ui._txt_Desc:SetAutoResize( true )
		ui._txt_Desc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_LOCATION_DESC") ) -- 술을 사준 것에 대한 보답으로 선택한 주제의 해당 위치를 알려준다. 마을에서 처음 만나는 주민들은 모험가들에게 쉽게 이야기를 해주지 않는다. 벨리아와 같은 시골 마을은 다른 주민들과 이야기를 하다보면 유명한 마을 주민들과도 쉽게 친해질 수 있지만 칼페온과 같은 대도시에서 사람과 친해지기는 쉽지 않다.
		ui._txt_Desc:SetSize( ui._txt_Desc:GetSizeX(), ui._txt_Desc:GetSizeY() )
		ui._descBG:SetSize( ui._descBG:GetSizeX(), ui._txt_Desc:GetSizeY() + 10 )
		findWay_StartY = GetBottomPos( ui._descBG ) + 10
		
		------------------------------------------------
		--		요놈만 다른놈들과 다르다!!!!!!!!
		ui._btn_Close:SetShow( false )
		ui._txt_FindWay:SetShow( true )
		ui._base_Way:SetShow( false )

		ui._txt_FindWay:SetPosY( findWay_StartY )
		findWayBtn_StartY = GetBottomPos( ui._txt_FindWay ) + 10
		
		for idx = 0, knowledgeCount - 1 do
			local _findWayButton = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_BuyDrink, 'Button_FindWay_' .. idx )
			CopyBaseProperty( ui._base_Way, _findWayButton )
			_findWayButton:SetPosY( findWayBtn_StartY + ( idx * 35 ) )
			_findWayButton:SetShow( true )
			_findWayButton:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_FINDWAY") ) -- 잉여인간
			
			totalPanelSizeY = GetBottomPos( _findWayButton ) + 15
		end
		
		Panel_BuyDrink:SetSize( Panel_BuyDrink:GetSizeX(), totalPanelSizeY )
		
	elseif ( test_Category == 4 ) then	-- 선물
		ui._titleImage:ChangeTextureInfoName ( "new_ui_common_forlua/window/buydrink/buydrink_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( ui._titleImage, 1, 109, 347, 144 )
		ui._titleImage:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui._titleImage:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_BUYDRINK_TITLE_PRESENT" ) )	-- 선 물
		
		ui._txt_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		ui._txt_Desc:SetAutoResize( true )
		ui._txt_Desc:SetText( message )
		ui._txt_Desc:SetSize( ui._txt_Desc:GetSizeX(), ui._txt_Desc:GetSizeY() )
		ui._descBG:SetSize( ui._descBG:GetSizeX(), ui._txt_Desc:GetSizeY() + 10 )
		getBottom = GetBottomPos( ui._descBG ) + 10
		
		ui._btn_Close:SetShow( true )
		ui._btn_Close:SetPosY( getBottom )
		getBottom = GetBottomPos( ui._btn_Close ) + 7
		
		Panel_BuyDrink:SetSize( Panel_BuyDrink:GetSizeX(), getBottom )
	end
	ui._titleImage:setRenderTexture(ui._titleImage:getBaseTexture())
	ui._frameBuyDrink:UpdateContentScroll()		-- 스크롤 감도 동일하게
end


------------------------------------------------------------------------
--						술한잔 사기 SHOW TOGGLE
------------------------------------------------------------------------
function Panel_BuyDrink_ShowToggle()
	local isOn = Panel_BuyDrink:IsShow()
	
	if ( isOn == true ) then
		Panel_BuyDrink:SetShow( false, true )
	else
		Panel_BuyDrink:SetShow( true, true )
	end
end


Panel_BuyDrink_Initialize()
registerEvent("FromClient_BuyDrinkResult", "FromClient_BuyDrinkResult")

function FromClient_BuyDrinkResult(message)
	Panel_BuyDrink:SetShow( true, true )
	Panel_BuyDrink_UpdateFunc(message)
end