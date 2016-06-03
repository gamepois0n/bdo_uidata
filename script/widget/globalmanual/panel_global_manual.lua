IsChecked_WeaponOut = false

local UI_TM			= CppEnums.TextMode
local UI_color 		= Defines.Color
local autoFishingEnalbe = getSelfPlayer():get():isAutoFishingable()

local ui = 
{
		_obsidian 				= UI.getChildControl ( Panel_Global_Manual, "Static_Obsidian" ),
		_obsidian_B 			= UI.getChildControl ( Panel_Global_Manual, "Static_Obsidian_B" ),
		_obsidian_Text 			= UI.getChildControl ( Panel_Global_Manual, "StaticText_Obsidian_B" ),

		_purposeText 			= UI.getChildControl ( Panel_Global_Manual, "StaticText_Purpose" ),
		_purposeText2 			= UI.getChildControl ( Panel_Global_Manual, "MultilineText_Purpose" ),

		_button_Q 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Q" ),
		
		_button_W 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_W" ),
		_button_A 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_A" ),
		_button_S				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_S" ),
		_button_D 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_D" ),

		_button_E 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_E" ),
		_button_F 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_F" ),

		_button_Tab 			= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Tab" ),
		_button_Shift 			= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Shift" ),
		_button_Space 			= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Space" ),

		_m0 					= UI.getChildControl ( Panel_Global_Manual, "StaticText_M0" ),
		_m1 					= UI.getChildControl ( Panel_Global_Manual, "StaticText_M1" ),
		_mBody 					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Mouse_Body" ),
		
		_horse_Icon				= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Horse_0" ),
		
		_horse_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Horse_Title" ),
		_fish_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Fish_Title" ),
		_cart_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Cart_Title" ),
		_flute_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Flute_Title" ),
		_steal_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Steal_Title" ),
		_milky_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Milky_Title" ),
}

local uiPress = 
{
	_button_Q 					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Q_2" ),

	_button_W 					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_W_2" ),
	_button_A					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_A_2" ),
	_button_S					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_S_2" ),
	_button_D					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_D_2" ),

	_button_E					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_E_2" ),
	_button_F					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_F_2" ),

	_button_Tab					= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Tab_2" ),
	_button_Shift				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Shift_2" ),
	_button_Space 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Btn_Space_2" ),

	_m0 						= UI.getChildControl ( Panel_Global_Manual, "StaticText_M0_2" ),
	_m1 						= UI.getChildControl ( Panel_Global_Manual, "StaticText_M1_2" ),
}

local fishUi = 
{
	_fishBG 					= UI.getChildControl ( Panel_Global_Manual, "Static_OnlyFishBG" ),
	_fishPercent 				= UI.getChildControl ( Panel_Global_Manual, "StaticText_OnlyFish" ),
	_fishComment				= UI.getChildControl ( Panel_Global_Manual, "StaticText_OnlyFishComment" ),
	_fishWpDesc					= UI.getChildControl ( Panel_Global_Manual, "StaticText_OnlyFishWpDesc" ),
	_fishCheckBtn				= UI.getChildControl ( Panel_Global_Manual, "CheckBox_DropTrash" ),
}

fishUi._fishCheckBtn:addInputEvent( "Mouse_LUp", "HandleClicked_FishCheck()" )

local gameOptionActionKey = {
	Forward		= 0,
	Back		= 1,
	Left		= 2,
	Right		= 3,
	Attack		= 4,
	SubAttack	= 5,
	Dash		= 6,
	Jump		= 7,
}

--------------------------------
--			변수 모음
local ui_Value = 
{
	isFirstTime_Manual_Timing_0 = true,
	isFirstTime_Manual_Timing_1 = true,
	isFirstTime_Manual_Timing_2 = true,

	isFirstTime_Manual_Fishing_Start = true,
	isFirstTime_Manual_Fishing_0 = true,
	isFirstTime_Manual_Fishing_1 = true,
	isFirstTime_Manual_Fishing_2 = true,
	isFirstTime_Manual_Fishing_3 = true,
	
	isFirstTime_Manual_Cart_0 = true,
	
	isFirstTime_Manual_Horse_Rope_0 = true,
	isFirstTime_Manual_HorseDrop_0 = true,
	
	isFirstTime_Manual_Flute_0 = true,
	isFirstTime_Manual_Flute_1 = true,
	
	isFirstTime_Manual_HerbMachine_0 = true,
	isFirstTime_Manual_HerbMachine_1 = true,
	isFirstTime_Manual_HerbMachine_2 = true,
	isFirstTime_Manual_HerbMachine_3 = true,
	isFirstTime_Manual_HerbMachine_4 = true,
	isFirstTime_Manual_HerbMachine_5 = true,
	
	isFirstTime_Manual_Milky_0 = true,
	isFirstTime_Manual_Milky_1 = true,
	isFirstTime_Manual_Milky_2 = true,
	isFirstTime_Manual_Milky_3 = true,
	
	isFirstTime_Manual_Jaksal_0 = true,
	isFirstTime_Manual_Jaksal_1 = true,
	isFirstTime_Manual_Jaksal_2 = true,
	isFirstTime_Manual_Jaksal_3 = true,
	isFirstTime_Manual_Jaksal_4 = true,
	isFirstTime_Manual_Jaksal_5 = true,

	isFirstTime_Manual_Drum_0 = true,
	isFirstTime_Manual_Drum_1 = true,
}

MiniGame_Manual_Value_FishingStart = false 	-- 낚시 중에는 가공할 수 없도록 체크하는 변수 ( 전역으로 사용하자 )

------------------------------------------------------------------------
--					글로벌 메뉴얼 초기화 함수
------------------------------------------------------------------------
local Global_Manual_Initialize = function()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_Global_Manual:SetSize ( scrX, scrY )
	Panel_Global_Manual:SetPosX(0)
	Panel_Global_Manual:SetPosY(50)
	
	-- UI.debugMessage('resize : ' .. scrX .. " / " .. scrY )
	

	for _, v in pairs ( ui ) do
		v:SetShow( false )
		v:ComputePos()
	end
	
	for _, v in pairs ( uiPress ) do
		v:SetShow( false )
		v:ComputePos()
	end
	
	for _, v in pairs ( fishUi ) do
		v:SetShow( false )
		v:ComputePos()
	end
end
------------------------------------------------------------------------
--					글로벌 메뉴얼 화면 리사이즈 함수
function Panel_GlobalManual_ScreenResize()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_Global_Manual:SetSize ( scrX, scrY )
	Panel_Global_Manual:SetPosX(0)
	Panel_Global_Manual:SetPosY(50)
	
	for _, v in pairs ( ui ) do
		v:SetShow( false )
		v:ComputePos()
	end
	
	for _, v in pairs ( uiPress ) do
		v:SetShow( false )
		v:ComputePos()
	end
	
	for _, v in pairs ( fishUi ) do
		v:SetShow( false )
		v:ComputePos()
	end
end



------------------------------------------------------------------------
--				●미니게임 TIMING, BATTLE (말) 메뉴얼 
------------------------------------------------------------------------
local MiniGame_Manual_Timing_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Timing_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_0") )		-- 말을 사로잡기 위해 말에게 조준 후 <PAColor0xFFFFD649>'좌클릭'<PAOldColor>을 이용해 로프를 던지세요
		
		------------------------------------
		--	말 아이콘 위치를 지정해준다
		ui._horse_Icon_Title:SetShow( true )
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._m0:SetShow( true )
		ui._m1:SetShow( true )
		ui._mBody:SetShow( true )
		
		ui_Value.isFirstTime_Manual_Timing_0 = false
	end
end

local MiniGame_Manual_Timing_1 = function( actorKeyRaw, isSelf )
	-- UI.debugMessage('202')
	
	if ( ui_Value.isFirstTime_Manual_Timing_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_1") )	-- 말이 앞발을 들어올리는 행동을 하면 <PAColor0xFFFFD649>'스페이스 바'<PAOlcColor>를 눌러 힘겨루기를 시작하세요

		------------------------------------
		--		말 아이콘을 켜준다
		ui._horse_Icon_Title:SetShow( true )
		ui._horse_Icon:SetShow( false )
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		uiPress._button_Space:SetAlpha(0)
		uiPress._button_Space:SetFontAlpha(0)
		
		UIAni.AlphaAnimation( 1, uiPress._button_Space, 0.5, 0.75 )
		
		ui_Value.isFirstTime_Manual_Timing_1 = false
	end
end

local MiniGame_Manual_Timing_2 = function( actorKeyRaw, isSelf )
	-- UI.debugMessage('203')
	
	if ( ui_Value.isFirstTime_Manual_Timing_2 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_2") )	-- 말에게 완전히 접근할 때 까지 계속해서 힘겨루기를 하세요

		------------------------------------
		--	말 아이콘 위치를 지정해준다
		ui._horse_Icon_Title:SetShow( true )
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_W:SetShow( true )
		ui._button_A:SetShow( true )
		ui._button_S:SetShow( true )
		ui._button_D:SetShow( true )
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_Timing_2 = false
	end
end



------------------------------------------------------------------------
--					● 낚시 - 어장 자원량 표시해주기
------------------------------------------------------------------------
function setFishingResourcePool_text()
	-- fishUi._fishBG:SetShow( true )
	-- fishUi._fishBG:setGlassBackground( true )
	local fishComment_head = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_HEAD")
	-- fishUi._fishPercent:SetShow( true )
	local fishingPercent = math.floor( ToClient_CurrentFishingData() * 100 )
	if ( 71 <= fishingPercent ) and ( fishingPercent <= 100 ) then
		fishUi._fishPercent:SetFontColor( UI_color.C_FF00C0D7 )
		fishComment = fishComment_head .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_1")	-- 풍부
	elseif ( 46 <= fishingPercent  ) and ( fishingPercent <= 70 ) then
		fishUi._fishPercent:SetFontColor( UI_color.C_FFC8FFC8 )
		fishComment = fishComment_head .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_2")	-- 보통
	elseif ( 15 <= fishingPercent ) and ( fishingPercent <= 45 ) then
		fishUi._fishPercent:SetFontColor( UI_color.C_FFEE7001 )
		fishComment = fishComment_head .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_3")	-- 부족
	elseif ( fishingPercent <= 14 ) and ( 0 <= fishingPercent ) then
		fishUi._fishPercent:SetFontColor( UI_color.C_FFF26A6A )
		fishComment = fishComment_head .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FISH_POOL_VALUE_4")	-- 고갈
	end
	
	fishUi._fishPercent:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_FISHERY_RESOURCE", "FISHERY" , fishComment )	)-- 현재 어장 자원량 : x%
	
	-- fishUi._fishComment:SetShow( true )
	fishUi._fishComment:SetAutoResize( true )
	fishUi._fishComment:SetTextMode( UI_TM.eTextMode_AutoWrap )
	fishUi._fishComment:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_FISHERY_COMMENT" ) )	-- <PAColor0x00FFCE22>어장 자원량이 낮을 수록 낚시의 시간이 길어집니다.\n떡밥을 이용하면 낚시의 시간을 단축시킬 수 있습니다.<PAOldColor>

	local itemWrapper = getEquipmentItem( 0 )	-- 주무기 슬롯 체크
	if nil == itemWrapper then	-- todo 장비창 우클릭으로 하면 함수가 늦게 온다. 강제로 setFishingResourcePool_text()를 장비창에서 실행한다. 바꿔야 함.
		fishUi._fishWpDesc:SetShow( false )
		fishUi._fishCheckBtn:SetShow( false )
		return
	end

	local equipType = itemWrapper:getStaticStatus():getEquipType()
	if 44 == equipType then
		fishUi._fishWpDesc:SetShow( true )
		fishUi._fishCheckBtn:SetShow( true )
		HandleClicked_FishCheck()
	elseif 48 == equipType then
		fishUi._fishWpDesc:SetShow( false )
		fishUi._fishCheckBtn:SetShow( false )
	end
end
registerEvent("selfPlayer_regionChanged", "setFishingResourcePool_text")

local MiniGame_Manual_Fishing_Start = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Fishing_Start == true  and Defines.UIMode.eUIMode_NpcDialog ~= GetUIMode() and not getCustomizingManager():isShow() ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		
		local actionString = "";
		if getGamePadEnable() then
			actionString = keyCustom_GetString_ActionPad( gameOptionActionKey.Jump );
		else
			actionString = keyCustom_GetString_ActionKey( gameOptionActionKey.Jump );
		end
		
		ui._purposeText:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_START", "key", actionString ) )	-- 물가에서 <PAColor0xFFFFD649>'{key}'<PAOldColor> 를 눌러 낚시를 시작하세요
		uiPress._button_Space:SetShow( true )
		uiPress._button_Space:SetText( actionString )
		uiPress._button_Space:SetPosY( 150 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		------------------------------------
		--	물고기 아이콘 위치를 지정해준다
		ui._fish_Icon_Title:SetShow( true )

		ui_Value.isFirstTime_Manual_Fishing_Start = false
		MiniGame_Manual_Value_FishingStart = true	-- 가공 처리용.
	end
end

local MiniGame_Manual_Fishing_0 = function( actorKeyRaw, isSelf )
	FGlobal_PowerGauge_Close()
	if ( ui_Value.isFirstTime_Manual_Fishing_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_0" ) )	-- 물고기를 낚는 중입니다. 반응이 올 때까지 기다리세요
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )		
		------------------------------------
		--	물고기 아이콘 위치를 지정해준다
		ui._fish_Icon_Title:SetShow( true )
		fishUi._fishWpDesc:SetShow( false )
		ui_Value.isFirstTime_Manual_Fishing_0 = false
	end
end

local MiniGame_Manual_Fishing_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Fishing_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		
		
		local actionString = "";
		if getGamePadEnable() then
			actionString = keyCustom_GetString_ActionPad( gameOptionActionKey.Jump );
		else
			actionString = keyCustom_GetString_ActionKey( gameOptionActionKey.Jump );
		end
		
		ui._purposeText:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_1", "key", actionString ) )	-- 3번의 기회 안에 <PAColor0xFFFFD649>'{key}'<PAOldColor>를 이용해 물고기를 낚으세요
		
		if autoFishingEnalbe then
			fishUi._fishWpDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC" ))
		else
			fishUi._fishWpDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC_2" ))
		end
		
		------------------------------------
		--	물고기 아이콘 위치를 지정해준다
		ui._fish_Icon_Title:SetShow( true )

		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		uiPress._button_Space:SetText( actionString )
		uiPress._button_Space:SetAlpha(0)
		uiPress._button_Space:SetFontAlpha(0)
		uiPress._button_Space:SetPosY( 150 )

		
		fishUi._fishWpDesc:SetShow( false )

		UIAni.AlphaAnimation( 1, uiPress._button_Space, 0.75, 1.0 )
		
		ui_Value.isFirstTime_Manual_Fishing_1 = false
	end
end

local MiniGame_Manual_Fishing_2 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Fishing_2 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		-- 버튼 색을 바꾸자.
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_2") )	-- 시간 내에 키를 입력해 표시되는 키들과 일치시키세요
		fishUi._fishWpDesc:SetShow( false )
		------------------------------------
		--	물고기 아이콘 위치를 지정해준다
		ui._fish_Icon_Title:SetShow( true )
		
		uiPress._button_Space:SetShow( false )
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_W:SetShow( true )
		uiPress._button_A:SetShow( true )
		uiPress._button_S:SetShow( true )
		uiPress._button_D:SetShow( true )
		uiPress._button_W:SetText( gameOptionActionKey.Forward )
		uiPress._button_A:SetText( gameOptionActionKey.Left )
		uiPress._button_S:SetText( gameOptionActionKey.Back )
		uiPress._button_D:SetText( gameOptionActionKey.Right )
		uiPress._button_W:SetAlpha(0)
		uiPress._button_A:SetAlpha(0)
		uiPress._button_S:SetAlpha(0)
		uiPress._button_D:SetAlpha(0)
		uiPress._button_W:SetFontAlpha(0)
		uiPress._button_A:SetFontAlpha(0)
		uiPress._button_S:SetFontAlpha(0)
		uiPress._button_D:SetFontAlpha(0)
		
		UIAni.AlphaAnimation( 1, uiPress._button_W, 0.5, 0.75 )
		UIAni.AlphaAnimation( 1, uiPress._button_A, 0.5, 0.75 )
		UIAni.AlphaAnimation( 1, uiPress._button_S, 0.5, 0.75 )
		UIAni.AlphaAnimation( 1, uiPress._button_D, 0.5, 0.75 )
		
		ui_Value.isFirstTime_Manual_Fishing_2 = false
	end
end

local MiniGame_Manual_Fishing_3 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Fishing_3 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end

		-- ♬ 물고기가 잡혔당 사운드
		audioPostEvent_SystemUi(11,06)
		local leftTimeForAuto = math.floor(Int64toInt32(getSelfPlayer():get():getFishingAutoLeftTime()) / 1000)
		local leftMinute
		if 0 < math.floor(leftTimeForAuto/60) then
			leftMinute = " (" .. PAGetString( Defines.StringSheet_RESOURCE, "PANEL_PARTY_MATCH_TIME" ) .. " " .. PAGetStringParam1( Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", math.floor(leftTimeForAuto/60)) .. ")"
		else
			leftMinute = " (" .. PAGetString( Defines.StringSheet_RESOURCE, "PANEL_PARTY_MATCH_TIME" ) .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_UNDER_ONEMINUTE" ) .. ")"
		end
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		
		local actionString = "";
		if getGamePadEnable() then
			actionString = keyCustom_GetString_ActionPad( gameOptionActionKey.Jump );
		else
			actionString = keyCustom_GetString_ActionKey( gameOptionActionKey.Jump );
		end
		
		ui._purposeText:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_3", "key", actionString ) )	-- 무언가 걸렸습니다! <PAColor0xFFFFD649>'{key}'<PAOldColor> 을 이용해 시작하세요
		
		------------------------------------
		--	물고기 아이콘 위치를 지정해준다
		ui._fish_Icon_Title:SetShow( true )
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		uiPress._button_Space:SetText( actionString )
		uiPress._button_Space:SetAlpha(0)
		uiPress._button_Space:SetFontAlpha(0)
		uiPress._button_Space:SetPosY( 150 )
		
		-- fishUi._autoFishLeftTime:SetShow( true )
		if autoFishingEnalbe then
			fishUi._fishWpDesc:SetShow( true )
			fishUi._fishWpDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC" ) .. leftMinute )
		else
			fishUi._fishWpDesc:SetShow( false )
			fishUi._fishWpDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC_2" ))
		end
		UIAni.AlphaAnimation( 1, uiPress._button_Space, 0.5, 0.75 )
		
		ui_Value.isFirstTime_Manual_Fishing_2 = false
	end
end

local MiniGame_Manual_Fishing_Auto = function()
	-- for _, v in pairs ( ui ) do
		-- v:SetShow( false )
		-- v:ComputePos()
	-- end
	
	for _, v in pairs ( uiPress ) do
		v:SetShow( false )
		v:ComputePos()
	end
		if autoFishingEnalbe then
			fishUi._fishWpDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC" ))
		else
			fishUi._fishWpDesc:SetText( PAGetString( Defines.StringSheet_RESOURCE, "PANEL_GLOBAL_MANUAL_ONLYFISHWPDESC_2" ))
		end
	-- fishUi._autoFishLeftTime:SetShow( false )
end

local MiniGame_Manual_CommonGaugeOpen = function()
	if not Panel_PowerGauge:GetShow() then
		FGlobal_PowerGauge_Open()
	end
end

function FGlobal_MiniGame_FishingCheck()
	-- Space체크.
--{ Global_Manual에서는 컨트롤 안되는 부분이 있어서 이 부분에서 수정한다.}
	ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_FISHING_2") )	-- 3번의 기회 안에 <PAColor0xFFFFD649>'{key}'<PAOldColor>를 이용해 
	uiPress._button_Space:SetShow( false )
--}
end

function MiniGame_FishingDescInit()
	fishUi._fishWpDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	fishUi._fishWpDesc:SetSize( fishUi._fishWpDesc:GetTextSizeX()+10, fishUi._fishWpDesc:GetTextSizeY()+10 )
end
MiniGame_FishingDescInit()

function HandleClicked_FishCheck()
	local itemGrade = 0
	if fishUi._fishCheckBtn:IsCheck() then
		itemGrade = 1
	else
		itemGrade = 0
	end
	getSelfPlayer():setFishingAutoItemGrade( itemGrade )
end

------------------------------------------------------------------------
--			●미니게임 GRADIENT (손수레) 메뉴얼
------------------------------------------------------------------------
local MiniGame_Manual_Cart_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Cart_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		Panel_Global_Manual:SetShow( true )
		-- Panel_Global_Manual:SetFontAlpha(0)
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText2:SetShow( true )
		ui._purposeText2:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_CART_TITLE") ) -- "{KeyBind:MoveFront}키를 눌러 앞으로 이동합니다.\n마우스 좌, 우클릭을 통해 균형을 맞춥니다.\n{KeyBind:Interaction}키를 눌러 수레에서 내릴 수 있습니다." )
		
		------------------------------------
		--			손수레 아이콘
		ui._cart_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_W:SetShow( true )
		uiPress._button_A:SetShow( true )
		ui._button_S:SetShow( true )
		uiPress._button_D:SetShow( true )
		uiPress._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Cart_0 = false
	end
end



------------------------------------------------------------------------
--				●미니게임 말 포획 중 메시지
------------------------------------------------------------------------
local MiniGame_Manual_Horse_Rope_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Horse_Rope_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HORSEROPE_0") )		-- <PAColor0xFFDB2B2B>길들이기에 실패했습니다<PAOldColor>
		
		------------------------------------
		--			말머리 아이콘
		ui._horse_Icon_Title:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Horse_Rope_0 = false
	end
end



------------------------------------------------------------------------
--			●미니게임 GRADIENT Y(낙마) 메뉴얼
------------------------------------------------------------------------
local MiniGame_Manual_HorseDrop_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HorseDrop_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HORSEDROP_0") )		-- <PAColor0xFFFFD649>'위, 아래 방향키'<PAOldColor>를 이용하여 말의 자세를 바로 잡으세요
		
		------------------------------------
		--			말머리 아이콘
		ui._horse_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_W:SetShow( true )
		ui._button_A:SetShow( true )
		uiPress._button_S:SetShow( true )
		ui._button_D:SetShow( true )
	
		ui_Value.isFirstTime_Manual_HorseDrop_0 = false
	end
end



------------------------------------------------------------------------
--			●미니게임 RHYTHM(피리) 메뉴얼
------------------------------------------------------------------------
local MiniGame_Manual_Flute_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Flute_0 == true and Defines.UIMode.eUIMode_NpcDialog ~= GetUIMode() and not getCustomizingManager():isShow() ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_0") )		-- <PAColor0xFFFFD649>'마우스 좌클릭'<PAOldColor>으로 피리 연주를 시작할 수 있습니다
		
		------------------------------------
		--			음표 아이콘
		ui._flute_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		ui._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Flute_0 = false
	end
end

local MiniGame_Manual_Flute_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Flute_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_1") )		-- <PAColor0xFFFFD649>'마우스 좌클릭, 우클릭'<PAOldColor>으로 내려오는 음표를 피해 연주를 유지하세요
		
		------------------------------------
		--			음표 아이콘
		ui._flute_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Flute_0 = true
		ui_Value.isFirstTime_Manual_Flute_1 = false
	end
end

------------------------------------------------------------------------
--			●미니게임 DRUM(드럼) 메뉴얼
------------------------------------------------------------------------
local MiniGame_Manual_Drum_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Drum_0 == true and Defines.UIMode.eUIMode_NpcDialog ~= GetUIMode() and not getCustomizingManager():isShow() ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DRUM_0") )		-- <PAColor0xFFFFD649>'마우스 좌클릭'<PAOldColor>으로 피리 연주를 시작할 수 있습니다
		
		------------------------------------
		--			음표 아이콘
		ui._flute_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Drum_0 = false
		ui_Value.isFirstTime_Manual_Drum_1 = true
	end
end

local MiniGame_Manual_Drum_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Drum_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_1") )		-- <PAColor0xFFFFD649>'마우스 좌클릭, 우클릭'<PAOldColor>으로 내려오는 음표를 피해 연주를 유지하세요
		
		------------------------------------
		--			음표 아이콘
		ui._flute_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Drum_0 = true
		ui_Value.isFirstTime_Manual_Drum_1 = false
	end
end

local MiniGame_Manual_Instrument_0 = function( actorKeyRaw, isSelf )
	if ( Defines.UIMode.eUIMode_NpcDialog ~= GetUIMode() and not getCustomizingManager():isShow() ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( "<PAColor0xFFFFD649>'SPACE BAR'<PAOldColor>로 악기 연주를 시작합니다" )
		
		------------------------------------
		--			음표 아이콘
		ui._flute_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
	end
end

------------------------------------------------------------------------
--				●미니게임 약초 기계 (점프) 메뉴얼 
------------------------------------------------------------------------
local MiniGame_Manual_HerbMachine_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HerbMachine_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .." ".. "(0/5)" )		-- 타이밍에 맞춰 점프 5회를 성공해야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_HerbMachine_0 = false
	end
end

local MiniGame_Manual_HerbMachine_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HerbMachine_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .." ".. "(1/5)" )		-- 타이밍에 맞춰 점프 5회를 성공해야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_HerbMachine_1 = false
	end
end

local MiniGame_Manual_HerbMachine_2 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HerbMachine_2 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .." ".. "(2/5)" )		-- 타이밍에 맞춰 점프 5회를 성공해야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_HerbMachine_2 = true
	end
end

local MiniGame_Manual_HerbMachine_3 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HerbMachine_3 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .." ".. "(3/5)" )		-- 타이밍에 맞춰 점프 5회를 성공해야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_HerbMachine_3 = true
	end
end

local MiniGame_Manual_HerbMachine_4 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HerbMachine_4 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .." ".. "(4/5)" )		-- 타이밍에 맞춰 점프 5회를 성공해야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_HerbMachine_4 = true
	end
end

local MiniGame_Manual_HerbMachine_5 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_HerbMachine_5 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		FGlobal_MiniGame_HerbMachine();
		ToClient_MinigameResult(2, true)
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_1") )						-- 5회 성공 하였습니다!
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_HerbMachine_5 = true
	end
end

local MiniGame_Manual_HerbMachine = function()
	Panel_Minigame_HerbMachine_ResetCount()
end



------------------------------------------------------------------------
--				●미니게임 부표 밀기 메뉴얼 
------------------------------------------------------------------------
local MiniGame_Manual_Buoy_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Buoy_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0").. " " .. "(0/3)" )		-- 타이밍에 맞춰 추출기를 3회 흔들어야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_Buoy_0 = false
	end
	
end

local MiniGame_Manual_Buoy_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Buoy_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0").. " " .. "(1/3)" )		-- 타이밍에 맞춰 추출기를 3회 흔들어야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_Buoy_1 = false
		
		
		
		Panel_MiniGame_Buoy_WaitInitMode()
	end
end

local MiniGame_Manual_Buoy_2 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Buoy_2 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0").. " " .. "(2/3)" )		-- 타이밍에 맞춰 추출기를 3회 흔들어야 합니다.
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_Buoy_2 = true
		
		Panel_MiniGame_Buoy_WaitInitMode()
	end
end

local MiniGame_Manual_Buoy_3 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Buoy_3 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_1") )		-- 3회 성공 하였습니다!
		
		------------------------------------
		--			해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
		
		ui_Value.isFirstTime_Manual_Buoy_3 = true
		
		Panel_MiniGame_Buoy_WaitInitMode()
	end
end

local MiniGame_Manual_Reset_Buoy = function()
	Panel_Minigame_Buoy_ResetCount()
end



------------------------------------------------------------------------
--			●미니게임 POWER CONTROL(젖짜기) 메뉴얼
------------------------------------------------------------------------
local MiniGame_Manual_Milky_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Milky_0 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end

		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_READY1"))		-- <PAColor0xFFFFD649>'마우스 좌클릭'<PAOldColor>으로 젖짜기를 시작할 수 있습니다
		
		------------------------------------
		--			음표 아이콘
		ui._milky_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		ui._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Milky_0 = false
	end
end

local MiniGame_Manual_Milky_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Milky_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_READY2"))		-- <PAColor0xFFFFD649>'마우스 좌클릭, 우클릭'<PAOldColor>으로 젖이 떨어지지 않을 정도만 짜내세요
		
		------------------------------------
		--			음표 아이콘
		ui._milky_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Milky_0 = true
		ui_Value.isFirstTime_Manual_Milky_1 = false
	end
end

local MiniGame_Manual_Milky_2 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Milky_2 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_FAIL"))		-- 젖소가 도망쳤습니다! 다음 기회를 이용하세요
		
		------------------------------------
		--			음표 아이콘
		ui._milky_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Milky_0 = true
		ui_Value.isFirstTime_Manual_Milky_1 = false
		ui_Value.isFirstTime_Manual_Milky_2 = false
	end
end

local MiniGame_Manual_Milky_3 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Milky_3 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME__MILKCOW_SUCCESS"))		-- 젖짜기에 성공했습니다!
		
		------------------------------------
		--			음표 아이콘
		ui._milky_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Milky_0 = true
		ui_Value.isFirstTime_Manual_Milky_1 = false
		ui_Value.isFirstTime_Manual_Milky_2 = false
		ui_Value.isFirstTime_Manual_Milky_3 = false
	end
end



-- 배 위에서 SPACE BAR 를 눌러 작살 조준을 시작하세요.
-- 헤엄치는 물고기를 마우스로 조준하고, 붉은색으로 빛날 때 SPACE BAR 로 작살을 발사하세요.
-- 물고기 사냥에 성공했습니다!
-- 물고기 사냥에 실패했습니다.

------------------------------------------------------------------------
--					●미니게임 낚시 작살 메뉴얼
------------------------------------------------------------------------
local MiniGame_Manual_Jaksal_0 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Jaksal_0 == true and Defines.UIMode.eUIMode_NpcDialog ~= GetUIMode() and not getCustomizingManager():isShow() ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end

		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Use" ) )		-- 배 위에서 <PAColor0xFFFFD649>'SPACE BAR'<PAOldColor> 를 눌러 작살 조준을 시작하세요.
		
		------------------------------------
		--			물고기 아이콘
		ui._fish_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Jaksal_0 = false
	end
	MiniGame_Manual_Value_FishingStart = true
end

local MiniGame_Manual_Jaksal_1 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Jaksal_1 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Finding" ) )		-- 깊은 바닷속 물고기를 찾고 있습니다.
		
		------------------------------------
		--			물고기 아이콘
		ui._fish_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( false )
		ui._m0:SetShow( true )
		uiPress._m1:SetShow( true )
		ui._mBody:SetShow( true )
		ui_Value.isFirstTime_Manual_Jaksal_0 = true
		ui_Value.isFirstTime_Manual_Jaksal_1 = false
	end
end

local MiniGame_Manual_Jaksal_2 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Jaksal_2 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )		
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Find" ) )		-- 물고기를 발견했습니다! <PAColor0xFFFFD649>'SPACE BAR'<PAOldColor> 를 눌러 조준 자세를 취하세요!
		
		------------------------------------
		--			물고기 아이콘
		ui._fish_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Jaksal_0 = true
		ui_Value.isFirstTime_Manual_Jaksal_1 = false
		ui_Value.isFirstTime_Manual_Jaksal_2 = false
	end
end

local MiniGame_Manual_Jaksal_3 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Jaksal_3 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Sight") )		-- 헤엄치는 물고기를 <PAColor0xFFFFD649>'마우스'<PAOldColor>로 조준하고, 붉은색으로 빛날 때 <PAColor0xFFFFD649>'SPACE BAR'<PAOldColor> 로 작살을 발사하세요.
		
		------------------------------------
		--			물고기 아이콘
		ui._fish_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Jaksal_0 = true
		ui_Value.isFirstTime_Manual_Jaksal_1 = false
		ui_Value.isFirstTime_Manual_Jaksal_2 = false
		ui_Value.isFirstTime_Manual_Jaksal_3 = false
	end
end

local MiniGame_Manual_Jaksal_4 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Jaksal_4 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Success") )		-- 물고기 사냥에 성공했습니다!
		
		------------------------------------
		--			물고기 아이콘
		ui._fish_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Jaksal_0 = true
		ui_Value.isFirstTime_Manual_Jaksal_1 = false
		ui_Value.isFirstTime_Manual_Jaksal_2 = false
		ui_Value.isFirstTime_Manual_Jaksal_3 = false
		ui_Value.isFirstTime_Manual_Jaksal_4 = false
	end
end

local MiniGame_Manual_Jaksal_5 = function( actorKeyRaw, isSelf )
	if ( ui_Value.isFirstTime_Manual_Jaksal_5 == true ) then
		for _, v in pairs ( ui ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( uiPress ) do
			v:SetShow( false )
			v:ComputePos()
		end
		
		for _, v in pairs ( fishUi ) do
			v:SetShow( false )
			v:ComputePos()
		end
	
		Panel_Global_Manual:SetShow( true )
		Panel_Global_Manual:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Panel_Global_Manual, 0.0, 0.22 )
		
		------------------------------------
		--		현재 어장 자원을 표시
		fishUi._fishBG:SetShow( true )
		fishUi._fishPercent:SetShow( true )
		fishUi._fishComment:SetShow( true )
		setFishingResourcePool_text()

		fishUi._fishBG:SetSize( fishUi._fishBG:GetSizeX(), fishUi._fishPercent:GetSizeY() + fishUi._fishComment:GetSizeY() + 10 )
		
		------------------------------------
		--			설명을 써준다
		ui._purposeText:SetShow( true )
		ui._purposeText:AddEffect( "UI_QustComplete01", false, 0, 0 )
		ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_Fishing_Fail") )		-- 물고기 사냥에 실패했습니다. 다음 기회를 이용하세요.
		
		------------------------------------
		--			물고기 아이콘
		ui._fish_Icon_Title:SetShow( true )
	
		------------------------------------
		--		해당 키를 켜준다
		uiPress._button_Space:SetShow( true )
	
		ui_Value.isFirstTime_Manual_Jaksal_0 = true
		ui_Value.isFirstTime_Manual_Jaksal_1 = false
		ui_Value.isFirstTime_Manual_Jaksal_2 = false
		ui_Value.isFirstTime_Manual_Jaksal_3 = false
		ui_Value.isFirstTime_Manual_Jaksal_4 = false
		ui_Value.isFirstTime_Manual_Jaksal_5 = false
	end
end



------------------------------------------------------------------------
-- 말 내리면 주차해 주세요! 안내
------------------------------------------------------------------------

function Parking_PLZ_Update( variableName, value )
	if variableName == "IsParking" and value == 0 then	-- IsParking 이 검출되면
		if true == isNearMonsterCheck() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_ISNEARMONSTERCHECK"), 4 )
			FGlobal_ServantIcon_IsNearMonster_Effect( true )
			audioPostEvent_SystemUi(08,14)
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_VEHICLE_PARKING_PLZ") )
		end
	end
end

function isNearMonsterCheck()
	-- 반경 30m 내에 선공 몬스터가 있는지 체크
	local distance = 3000.0
	local isNearMonsterCount = getNearMonsterCharacterKeyList(distance)
	
	if 0 < isNearMonsterCount then
		-- for i = 0, isNearMonsterCount - 1 do
			-- _PA_LOG("이문종", "몬스터키 == " .. tostring(getNearMonsterCharacterKeyByIndex(i)))
		-- end
		return true
	else
		return false
	end
	-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_VEHICLE_PARKING_PLZ") )
end

-- 말 내리면, 파킹하라고 안내하자.
registerEvent("EventChangedSelfPlayerActionVariable", "Parking_PLZ_Update")

-- 침대 이용 시
function playerUseBed( variableName, value )
	if variableName == "IsSleepingChk" and value == 1 then	-- IsParking 이 검출되면
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_USE_BED") )
	elseif variableName == "IsSleepingChk" and value == 0 then
		-- Proc_ShowMessage_Ack( "침대에서 일어났습니다." )
	else
		return
	end
end
registerEvent("EventChangedSelfPlayerActionVariable", "playerUseBed")

function FromAction_CheckedBasic()
	IsChecked_WeaponOut = true
	-- _PA_LOG("LUA", "여기까지 오지? IsChecked_WeaponOut : " .. tostring(IsChecked_WeaponOut))
	
	ShowUseTab_Func()
end


------------------------------------------------------------------------
--							꺼주는 함수
------------------------------------------------------------------------
local Panel_Global_Manual_End = function()
	-- if ( isPvpZone == false ) then
		-- Panel_Global_Manual:SetAlpha(1)
		-- local manualEndAni = UIAni.AlphaAnimation( 0, Panel_Global_Manual, 0.0, 0.35 )
		-- manualEndAni:SetHideAtEnd(true)
		uiPress._button_Space:ComputePos()
		Panel_Global_Manual:SetShow( false )
		ui_Value.isFirstTime_Manual_Timing_0 = true
		ui_Value.isFirstTime_Manual_Timing_1 = true
		ui_Value.isFirstTime_Manual_Timing_2 = true
		
		ui_Value.isFirstTime_Manual_Fishing_Start = true
		ui_Value.isFirstTime_Manual_Fishing_0 = true
		ui_Value.isFirstTime_Manual_Fishing_1 = true
		ui_Value.isFirstTime_Manual_Fishing_2 = true
		ui_Value.isFirstTime_Manual_Fishing_3 = true
		
		ui_Value.isFirstTime_Manual_Cart_0 = true
		
		ui_Value.isFirstTime_Manual_Horse_Rope_0 = true
		
		ui_Value.isFirstTime_Manual_HorseDrop_0 = true
		
		ui_Value.isFirstTime_Manual_Flute_0 = true
		ui_Value.isFirstTime_Manual_Flute_1 = true
		
		ui_Value.isFirstTime_Manual_HerbMachine_0 = true
		ui_Value.isFirstTime_Manual_HerbMachine_1 = true
		ui_Value.isFirstTime_Manual_HerbMachine_2 = true
		ui_Value.isFirstTime_Manual_HerbMachine_3 = true
		ui_Value.isFirstTime_Manual_HerbMachine_4 = true
		ui_Value.isFirstTime_Manual_HerbMachine_5 = true
		
		ui_Value.isFirstTime_Manual_Buoy_0 = true
		ui_Value.isFirstTime_Manual_Buoy_1 = true
		ui_Value.isFirstTime_Manual_Buoy_2 = true
		ui_Value.isFirstTime_Manual_Buoy_3 = true
		
		ui_Value.isFirstTime_Manual_Milky_0 = true
		ui_Value.isFirstTime_Manual_Milky_1 = true
		ui_Value.isFirstTime_Manual_Milky_2 = true
		ui_Value.isFirstTime_Manual_Milky_3 = true
		
		ui_Value.isFirstTime_Manual_Jaksal_0 = true
		ui_Value.isFirstTime_Manual_Jaksal_1 = true
		ui_Value.isFirstTime_Manual_Jaksal_2 = true
		ui_Value.isFirstTime_Manual_Jaksal_3 = true
		ui_Value.isFirstTime_Manual_Jaksal_4 = true
		ui_Value.isFirstTime_Manual_Jaksal_5 = true
		
		MiniGame_Manual_Value_FishingStart = false	-- 가공 시 처리용.

		ui_Value.isFirstTime_Manual_Drum_0 = true
		ui_Value.isFirstTime_Manual_Drum_1 = true
		
		IsChecked_WeaponOut = false
		ShowUseTab_Func()

		if Panel_PowerGauge:GetShow() then
			FGlobal_PowerGauge_Close()
		end

		if Panel_CannonGauge:GetShow() then
			FGlobal_CannonGauge_Close()
		end
	-- end
end


local MiniGame_Manual_CannonGaugeOpen = function()
	if not Panel_Stamina:GetShow() then
		FGlobal_CannonGauge_Open()
	end
end

local MiniGame_Manual_Instrument_1 = function( actorKeyRaw, isSelf )
	Panel_Global_Manual_End()
end


--------------------------------------------------------------------------------------------------------------
--											바인드 이벤트 모음

-- 말 게임
ActionChartEventBindFunction( 201, MiniGame_Manual_Timing_0 )
ActionChartEventBindFunction( 202, MiniGame_Manual_Timing_1 )
ActionChartEventBindFunction( 203, MiniGame_Manual_Timing_2 )

-- 코끼리 게임
-- ActionChartEventBindFunction( 206, MiniGame_Manual_Elephant_Timing_0 ) 
-- ActionChartEventBindFunction( 207, MiniGame_Manual_Elephant_Timing_1 )
-- ActionChartEventBindFunction( 208, MiniGame_Manual_Elephant_Timing_2 )


-- 낚시 게임
ActionChartEventBindFunction( 211, MiniGame_Manual_Fishing_0 )
ActionChartEventBindFunction( 212, MiniGame_Manual_Fishing_1 )
ActionChartEventBindFunction( 213, MiniGame_Manual_Fishing_2 )
ActionChartEventBindFunction( 214, MiniGame_Manual_Fishing_Start )
ActionChartEventBindFunction( 215, MiniGame_Manual_Fishing_3 )
ActionChartEventBindFunction( 216, MiniGame_Manual_CommonGaugeOpen )
ActionChartEventBindFunction( 217, MiniGame_Manual_CannonGaugeOpen )
ActionChartEventBindFunction( 218, MiniGame_Manual_Fishing_Auto )

-- 수레 게임
ActionChartEventBindFunction( 221, MiniGame_Manual_Cart_0 )

-- 낙마 게임
ActionChartEventBindFunction( 231, MiniGame_Manual_HorseDrop_0 )
ActionChartEventBindFunction( 232, MiniGame_Manual_Horse_Rope_0 )

-- 피리 게임
ActionChartEventBindFunction( 241, MiniGame_Manual_Flute_0 )
ActionChartEventBindFunction( 242, MiniGame_Manual_Flute_1 )

-- 약초 기계 게임 (점프)
ActionChartEventBindFunction( 251, MiniGame_Manual_HerbMachine )
ActionChartEventBindFunction( 252, MiniGame_Manual_HerbMachine_0 )
ActionChartEventBindFunction( 253, MiniGame_Manual_HerbMachine_1 )
ActionChartEventBindFunction( 254, MiniGame_Manual_HerbMachine_2 )
ActionChartEventBindFunction( 255, MiniGame_Manual_HerbMachine_3 )
ActionChartEventBindFunction( 256, MiniGame_Manual_HerbMachine_4 )
ActionChartEventBindFunction( 257, MiniGame_Manual_HerbMachine_5 )

-- 추출기 게임 (흔들기)
ActionChartEventBindFunction( 261, MiniGame_Manual_Reset_Buoy )
ActionChartEventBindFunction( 262, MiniGame_Manual_Buoy_0 )
ActionChartEventBindFunction( 263, MiniGame_Manual_Buoy_1 )
ActionChartEventBindFunction( 264, MiniGame_Manual_Buoy_2 )
ActionChartEventBindFunction( 265, MiniGame_Manual_Buoy_3 )

-- 젖짜기 게임
ActionChartEventBindFunction( 271, MiniGame_Manual_Milky_0 )
ActionChartEventBindFunction( 272, MiniGame_Manual_Milky_1 )
ActionChartEventBindFunction( 273, MiniGame_Manual_Milky_2 )
ActionChartEventBindFunction( 274, MiniGame_Manual_Milky_3 )

-- 작살 게임
ActionChartEventBindFunction( 281, MiniGame_Manual_Jaksal_0 )
ActionChartEventBindFunction( 282, MiniGame_Manual_Jaksal_1 )
ActionChartEventBindFunction( 283, MiniGame_Manual_Jaksal_2 )
ActionChartEventBindFunction( 284, MiniGame_Manual_Jaksal_3 )
ActionChartEventBindFunction( 285, MiniGame_Manual_Jaksal_4 )
ActionChartEventBindFunction( 286, MiniGame_Manual_Jaksal_5 )

-- 드럼 연주
ActionChartEventBindFunction( 291, MiniGame_Manual_Drum_0 )
ActionChartEventBindFunction( 292, MiniGame_Manual_Drum_1 )

-- 악기 연주
ActionChartEventBindFunction( 293, MiniGame_Manual_Instrument_0 )
ActionChartEventBindFunction( 294, MiniGame_Manual_Instrument_1 )

-- 전투 상태에서 뛰면 체크
ActionChartEventBindFunction( 9998, FromAction_CheckedBasic )

-- 모든걸 꺼버린다
ActionChartEventBindFunction( 9999, Panel_Global_Manual_End )

Global_Manual_Initialize()

registerEvent("onScreenResize", "Panel_GlobalManual_ScreenResize")
