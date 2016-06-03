Panel_UI_Setting:SetShow( false )

local UiSet	= {
	title		= UI.getChildControl ( Panel_UI_Setting, "StaticText_Title" ),
	btn_save	= UI.getChildControl ( Panel_UI_Setting, "Button_Save" ),
	btn_cancel	= UI.getChildControl ( Panel_UI_Setting, "Button_Cancel" ),
	btn_reset	= UI.getChildControl ( Panel_UI_Setting, "Button_Reset" ),

	btn_FieldView	= UI.getChildControl ( Panel_UI_Setting, "CheckButton_FieldView" ),
	txt_UISize		= UI.getChildControl ( Panel_UI_Setting, "StaticText_UISize" ),
	txt_UI_LOW		= UI.getChildControl ( Panel_UI_Setting, "StaticText_UI_LOW" ),
	txt_UI_HIGH		= UI.getChildControl ( Panel_UI_Setting, "StaticText_UI_HIGH" ),
	slider_UI_Scale	= UI.getChildControl ( Panel_UI_Setting, "Slider_UI_Scaling" ),

	panelCount	= 0,
	panelPool	= {},

	preScale			= 0,
	currentScale		= 100,
	minScale			= 50,
	maxScale			= 120,
	replaceScale		= 0,
	nowCurrentPercent	= 0,
	saveScale			= 100,
}
UiSet.btn_Scale = UI.getChildControl ( UiSet.slider_UI_Scale, "Slider_UI_Scaling_Button" ),

-- { 초기화 : 붙이기
	UiSet.title				:AddChild( UiSet.btn_save )
	UiSet.title				:AddChild( UiSet.btn_cancel )
	UiSet.title				:AddChild( UiSet.btn_reset )
	UiSet.title				:AddChild( UiSet.btn_FieldView )
	UiSet.title				:AddChild( UiSet.txt_UISize )
	UiSet.title				:AddChild( UiSet.txt_UI_LOW )
	UiSet.title				:AddChild( UiSet.txt_UI_HIGH )
	UiSet.title				:AddChild( UiSet.slider_UI_Scale )

	Panel_UI_Setting		:RemoveControl( UiSet.btn_save )
	Panel_UI_Setting		:RemoveControl( UiSet.btn_cancel )
	Panel_UI_Setting		:RemoveControl( UiSet.btn_reset )
	Panel_UI_Setting		:RemoveControl( UiSet.btn_FieldView )
	Panel_UI_Setting		:RemoveControl( UiSet.txt_UISize )
	Panel_UI_Setting		:RemoveControl( UiSet.txt_UI_LOW )
	Panel_UI_Setting		:RemoveControl( UiSet.txt_UI_HIGH )
	Panel_UI_Setting		:RemoveControl( UiSet.slider_UI_Scale )

	UiSet.title				:ComputePos()
	UiSet.btn_save			:ComputePos()
	UiSet.btn_cancel		:ComputePos()
	UiSet.btn_reset			:ComputePos()
	UiSet.btn_FieldView		:ComputePos()
	UiSet.txt_UISize		:ComputePos()
	UiSet.txt_UI_LOW		:ComputePos()
	UiSet.txt_UI_HIGH		:ComputePos()
	UiSet.slider_UI_Scale	:ComputePos()

	UiSet.btn_FieldView		:SetEnableArea( 0, 0, 80, UiSet.btn_FieldView:GetSizeY() )
-- }


local Template = {
	static_able			= UI.getChildControl ( Panel_UI_Setting, "Static_Able" ),
	static_disAble		= UI.getChildControl ( Panel_UI_Setting, "Static_DisAble" ),
	btn_close			= UI.getChildControl ( Panel_UI_Setting, "Button_Close" ),
}
Template.static_able	:SetShow( false )
Template.static_disAble	:SetShow( false )
Template.btn_close		:SetShow( false )

local original_MouseX 		= 0
local original_MouseY 		= 0
local original_controlPosX 	= 0
local original_controlPosY 	= 0
local posGapX 				= 0
local posGapY 				= 0

local panelID = {
	ExpGage			= 1,
	ServantIcon		= 2,
	Radar			= 3,
	Quest			= 4,
	Chat0			= 5,
	Chat1			= 6,
	Chat2			= 7,
	Chat3			= 8,
	Chat4			= 9,
	GameTip			= 10,
	QuickSlot		= 11,
	HPBar			= 12,
	Pvp				= 13,
	ClassResource	= 14,
	Adrenallin		= 15,
	UIMain			= 16,
	House			= 17,
	NewEquip		= 18,
	Party			= 19,
	TimeBar			= 20,
	ActionGuide		= 21,
	KeyGuide		= 22,
}

local panelControl = {
	[panelID.ExpGage]		= { control = Panel_SelfPlayerExpGage, 		posFixed=true,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_1"),	isShow = true	}, -- 레벨/포인트 정보
	[panelID.ServantIcon]	= { control = Panel_Window_Servant, 		posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_2"),	isShow = true	}, -- 탑승물
	[panelID.Radar]			= { control = Panel_Radar, 					posFixed=true,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_3"),	isShow = true	}, -- 미니맵
	[panelID.Quest]			= { control = Panel_CheckedQuest, 			posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_4"),	isShow = true	}, -- 의뢰 위젯
	[panelID.Chat0]			= { control = Panel_Chat0, 					posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_5"),	isShow = true	}, -- 대화창1
	[panelID.Chat1]			= { control = Panel_Chat1, 					posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_6"),	isShow = false	}, -- 대화창2
	[panelID.Chat2]			= { control = Panel_Chat2, 					posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_7"),	isShow = false	}, -- 대화창3
	[panelID.Chat3]			= { control = Panel_Chat3, 					posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_8"),	isShow = false	}, -- 대화창4
	[panelID.Chat4]			= { control = Panel_Chat4, 					posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_9"),	isShow = false	}, -- 대화창5
	[panelID.GameTip]		= { control = Panel_GameTips, 				posFixed=true,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_10"),isShow = true	}, -- 게임팁
	[panelID.QuickSlot]		= { control = Panel_QuickSlot, 				posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_11"),isShow = true	}, -- 퀵슬롯
	[panelID.HPBar]			= { control = Panel_MainStatus_User_Bar, 	posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_12"),isShow = false	}, -- 생명력바
	[panelID.Pvp]			= { control = Panel_PvpMode, 				posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_13"),isShow = true	}, -- PVP
	[panelID.ClassResource]	= { control = Panel_ClassResource, 			posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_14"),isShow = true	}, -- 어둠의 파편
	[panelID.Adrenallin]	= { control = Panel_Adrenallin, 			posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_15"),isShow = true	}, -- 흑정령의\n분노
	[panelID.UIMain]		= { control = Panel_UIMain, 				posFixed=true,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_16"),isShow = true	}, -- 메뉴 버튼
	[panelID.House]			= { control = Panel_MyHouseNavi, 			posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_17"),isShow = true	}, -- 주거지 배치 및 이사 안내
	[panelID.NewEquip]		= { control = Panel_NewEquip, 				posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_18"),isShow = true	}, -- 상위장비
	[panelID.Party]			= { control = Panel_Party, 					posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_19"),isShow = true	}, -- 파티
	[panelID.TimeBar]		= { control = Panel_TimeBar, 				posFixed=true,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_20"),isShow = true	}, -- 위치/시간 정보
	
	[panelID.ActionGuide]	= { control = Panel_SkillCommand, 			posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_21"),isShow = true	}, -- 액션 연계 가이드
	[panelID.KeyGuide]		= { control = Panel_Movie_KeyViewer, 		posFixed=false,	prePos = {x=0,y=0}, name = PAGetString(Defines.StringSheet_GAME, "LUA_PANELCONTROL_22"),isShow = false	}, -- 실시간 키 입력 표시
	
}
UiSet.panelCount = #panelControl

local BG_Texture = {
	{ 107,	1,		159,	53 },	-- off
	{ 1,	1,		53,		53 },	-- on enable
	{ 54,	1,		106,	53 },	-- on disable
}

function UiSet_Initialize()
	for idx = 1, UiSet.panelCount do
		local slot = {}
		local fixedType = ""
		if panelControl[idx].posFixed then
			fixedType	= "Static_DisAble"
		else
			fixedType	= "Static_Able"
		end

		slot.control = UI.createAndCopyBasePropertyControl( Panel_UI_Setting, fixedType,	Panel_UI_Setting, "UiSet_CreateControl_" .. idx  )
		slot.control:SetShow( true )
		slot.control:SetSize( panelControl[idx].control:GetSizeX(), panelControl[idx].control:GetSizeY() )
		slot.control:SetPosX( panelControl[idx].control:GetPosX() )
		slot.control:SetPosY( panelControl[idx].control:GetPosY() )
		slot.control:addInputEvent("Mouse_LDown",	"HandleClicked_UiSet_MoveControlSet_Start( " .. idx .. " )")
		slot.control:addInputEvent("Mouse_LPress",	"HandleClicked_UiSet_MoveControl( " .. idx .. " )")

		slot.close = UI.createAndCopyBasePropertyControl( Panel_UI_Setting, "Button_Close",	slot.control, "UiSet_Btn_CreateClose_" .. idx  )
		slot.close:SetShow( true )
		slot.close:SetPosX( slot.control:GetSizeX() - slot.close:GetSizeX() - 3 )
		slot.close:SetPosY( 3 )
		slot.close:addInputEvent("Mouse_LUp",		"HandleClicked_UiSet_ControlShowToggle( " .. idx .. " )")
		slot.close:SetCheck( panelControl[idx].control:GetShow() )
		UiSet.panelPool[idx] = slot

		panelControl[idx].isShow = panelControl[idx].control:GetShow()
		if panelControl[idx].isShow then
			if panelControl[idx].posFixed then
				slot.control:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_IMPOSSIBLE", "name", panelControl[idx].name ) ) -- panelControl[idx].name .. "[편집불가]" )
			else
				slot.control:SetText( panelControl[idx].name )
			end
		else
			slot.control:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_OFF", "name", panelControl[idx].name ) ) -- panelControl[idx].name .. "[꺼짐]" )
		end
		
		local stateValue = 0
		if not panelControl[idx].isShow then
			stateValue = 1
		else
			if panelControl[idx].posFixed then
				stateValue = 3
			else
				stateValue = 2
			end
		end
		UiSet_ChangeTexture_BG( idx, stateValue )
	end
end

function UiSet_update()
	-- 퍼센트로 반환해야 한다.
	UiSet.slider_UI_Scale	:SetControlPos( UiSet.nowCurrentPercent )
	local scaleText = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SCALETEXT", "currentScale", UiSet.currentScale ) -- "인터페이스 크기( " .. UiSet.currentScale .. "% )"
	UiSet.txt_UISize		:SetText( tostring(scaleText) )

	UiSet.txt_UI_LOW		:SetText( UiSet.minScale )
	UiSet.txt_UI_HIGH		:SetText( UiSet.maxScale )

	for idx = 1, UiSet.panelCount do
		local slot = UiSet.panelPool[idx]
		slot.control:SetScale( 1, 1 )
		slot.control:SetShow( true )
		--slot.control:SetSize( panelControl[idx].control:GetSizeX(), panelControl[idx].control:GetSizeY() )

		slot.originPosX = panelControl[idx].control:GetPosX()
		slot.originPosY = panelControl[idx].control:GetPosY()
		slot.originSizeX = panelControl[idx].control:GetSizeX();
		slot.originSizeY = panelControl[idx].control:GetSizeY();

		slot.control:SetPosX( slot.originPosX )
		slot.control:SetPosY( slot.originPosY )
		slot.control:SetSize( slot.originSizeX, slot.originSizeY )

		slot.close:SetScale( 1, 1 )
		slot.close:SetShow( true )
		slot.close:SetPosX( slot.control:GetSizeX() - slot.close:GetSizeX() - 3 )
		slot.close:SetPosY( 3 )
		slot.close:SetCheck( panelControl[idx].isShow )

		-- { 채팅 패널이 경우 분리 됐을때만 보이게.
			if idx == panelID.Chat0 or idx == panelID.Chat1 or idx == panelID.Chat2 or idx == panelID.Chat3 or idx == panelID.Chat4 then
				local chatPanel = ToClient_getChattingPanel( idx - panelID.Chat0 )
				if ( chatPanel:isOpen() ) then	-- 사용하는 채팅창인가.
					if idx == panelID.Chat0 then	-- 메인 채팅
						slot.control:SetShow( true )
						slot.close:SetShow( true )
					else
						if chatPanel:isCombinedToMainPanel() then	-- 붙은 채팅
							slot.control:SetShow( false )
							slot.close:SetShow( false )
						else
							slot.control:SetShow( true )
							slot.close:SetShow( true )
						end
					end
				else
					slot.control:SetShow( false )
					slot.close:SetShow( false )
				end
		-- }

		-- { 어둠의 파편은 소서러만 보이게 하자.
			elseif idx == panelID.ClassResource then
				if (CppEnums.ClassType.ClassType_Sorcerer == getSelfPlayer():getClassType()) then
					slot.control:SetShow( true )
					slot.close:SetShow( true )
				else
					slot.control:SetShow( false )
					slot.close:SetShow( false )
				end
		-- }
		-- { 액션연계가이드는 게임옵션에 따라 상태 변화
			elseif idx == panelID.ActionGuide then
				if true == isChecked_SkillCommand then
					UiSet_ChangeTexture_BG( idx, 2 )
				else
					UiSet_ChangeTexture_BG( idx, 1 )
				end
		-- }
		-- { 액션연계가이드는 게임옵션에 따라 상태 변화
			elseif idx == panelID.KeyGuide then
				if true == isChecked_KeyViewer then
					UiSet_ChangeTexture_BG( idx, 2 )
				else
					UiSet_ChangeTexture_BG( idx, 1 )
				end
		-- }		
		-- { 흑정령의 분노
			elseif idx == panelID.Adrenallin then
				if getSelfPlayer():isEnableAdrenalin() then
					slot.control:SetShow( true )
					slot.close:SetShow( true )
				else
					slot.control:SetShow( false )
					slot.close:SetShow( false )
				end
		-- }

		-- { PVP
			elseif idx == panelID.Pvp then
				if isPvpEnable() then
					slot.control:SetShow( true )
					slot.close:SetShow( true )
				else
					slot.control:SetShow( false )
					slot.close:SetShow( false )
				end
			end
		-- }

		-- { 고정할 위젯은 움직일 수 없다고 표시
			if panelControl[idx].isShow then
				if panelControl[idx].posFixed then
					slot.control:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_IMPOSSIBLE", "name", panelControl[idx].name ) ) -- panelControl[idx].name .. "[편집불가]" )
				else
					slot.control:SetText( panelControl[idx].name )
				end
			else
				slot.control:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_OFF", "name", panelControl[idx].name ) ) -- panelControl[idx].name .. "[꺼짐]" )
			end
		--}
		
		-- { 상태에 따라 텍스쳐를 바꾼다.
			local stateValue = 0
			if not panelControl[idx].isShow then
				stateValue = 1
			else
				if panelControl[idx].posFixed then
					stateValue = 3
				else
					stateValue = 2
				end
			end
			UiSet_ChangeTexture_BG( idx, stateValue )
		--}
	end
end

function HandleClicked_UiSet_MoveControlSet_Start( idx )
	if panelControl[idx].posFixed then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_POSFIXED_ACK") ) -- "고정형 위젯입니다.")
		return
	end

	original_MouseX			= getMousePosX()
	original_MouseY			= getMousePosY()
	local control			= UiSet.panelPool[idx].control
	original_controlPosX	= control:GetPosX()
	original_controlPosY	= control:GetPosY()
	posGapX					= original_MouseX - original_controlPosX
	posGapY					= original_MouseY - original_controlPosY
end
function HandleClicked_UiSet_MoveControl( idx )
	if panelControl[idx].posFixed then
		return
	end

	local mouseX		= getMousePosX()
	local mouseY		= getMousePosY()
	local control		= UiSet.panelPool[idx].control
	control:SetPosX( mouseX - posGapX )
	control:SetPosY( mouseY - posGapY )
end
function UiSet_MoveControlSet_End( idx )
	if panelControl[idx].posFixed then
		return
	end
end

function UiSet_ChangeTexture_BG( idx, state )
	local control		= UiSet.panelPool[idx].control
	control:ChangeTextureInfoName ( "New_UI_Common_forLua/Default/UIcontrolPanel.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, BG_Texture[state][1], BG_Texture[state][2], BG_Texture[state][3], BG_Texture[state][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture( control:getBaseTexture() )
end

function HandleClicked_UiSet_ControlShowToggle( idx )	-- 켜고 끄기
	if idx == panelID.Pvp and not isPvpEnable() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTYETPVP_ACK") ) -- "아직 PVP 자격 조건에 만족하지 않습니다.")
		UiSet.panelPool[idx].close:SetCheck( panelControl[idx].isShow )
		return
	
	elseif idx == panelID.Adrenallin and not getSelfPlayer():isEnableAdrenalin() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTYETSPRIT_ACK") ) -- "아직 흑정령의 분노 조건에 만족하지 않았습니다.")
		UiSet.panelPool[idx].close:SetCheck( panelControl[idx].isShow )
		return
	
	elseif idx == panelID.Chat0 or idx == panelID.Chat1 or idx == panelID.Chat2 or idx == panelID.Chat3 or idx == panelID.Chat4 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTCHATTINGUIHIDE_ACK") ) -- "대화창은 임의로 감출 수 없습니다.")
		UiSet.panelPool[idx].close:SetCheck( panelControl[idx].isShow )
		return
	
	elseif idx == panelID.ServantIcon or idx == panelID.House or idx == panelID.NewEquip or idx == panelID.Party or idx == panelID.QuickSlot or idx == panelID.Adrenallin then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTRANDOMHIDE_ACK") ) -- "임의로 켜고 끌 수 없는 위젯입니다.")
		UiSet.panelPool[idx].close:SetCheck( panelControl[idx].isShow )
		return

	else
		if panelControl[idx].isShow then	-- 켜있나다면 끄자.
			panelControl[idx].isShow = false
			UiSet_ChangeTexture_BG( idx, 1 )
			panelControl[idx].isShow = false
			UiSet.panelPool[idx].control:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SLOTCONTROL_OFF", "name", panelControl[idx].name ) ) -- panelControl[idx].name .. "[꺼짐]" )
		else	-- 원래대로 돌려 놓자.
			panelControl[idx].isShow = true
			if panelControl[idx].posFixed then
				UiSet_ChangeTexture_BG( idx, 3 )
			else
				UiSet_ChangeTexture_BG( idx, 2 )
			end
			panelControl[idx].isShow = true
			UiSet.panelPool[idx].control:SetText( panelControl[idx].name )
		end
	end
end

function HandleClicked_UiSet_ConfirmSetting( isReset )	-- 저장하고 닫기!
	SetUIMode(Defines.UIMode.eUIMode_Default)
	UI.restoreFlushedUI()
	local scale 		= UiSet.currentScale / 100
	local preScale		= UiSet.preScale

	local currentScreenSize = {
		x = getScreenSizeX(),
		y = getScreenSizeY(),
	}
	local preScreenSize = {
		x = currentScreenSize.x / preScale,
		y = currentScreenSize.y / preScale,
	}
	local changeScreenSize = {
		x = currentScreenSize.x / scale,
		y = currentScreenSize.y / scale,
	}

	-- 닫고 실행할 것 추가.
	for idx = 1, UiSet.panelCount do
		local controlPosX = UiSet.panelPool[idx].control:GetPosX()
		local controlPosY = UiSet.panelPool[idx].control:GetPosY()
		local slot =  UiSet.panelPool[idx].control;
		
		local posX = slot:GetPosX();
		local posY = slot:GetPosY();
		
		local rateX = posX / preScreenSize.x;
		local rateY = posY / preScreenSize.y;


		panelControl[idx].control:SetPosX( changeScreenSize.x * rateX )
		panelControl[idx].control:SetPosY( changeScreenSize.y * rateY )

		-- 조건에 따라 저장해야 한다. PVP, 아드레날린은 제외
		if idx == panelID.Pvp then
			if isPvpEnable() then	-- PVP가 가능한가.
				panelControl[idx].control:SetShow( panelControl[idx].isShow )
			end
		elseif idx == panelID.Adrenallin then
				panelControl[idx].control:SetShow( getSelfPlayer():isEnableAdrenalin() )
		elseif idx == panelID.GameTip then
			panelControl[idx].control	:SetShow( panelControl[idx].isShow )

			Panel_GameTipMask			:SetShow( panelControl[idx].isShow ) -- 마스크도 같이 처리해야 한다.
			Panel_GameTipMask			:SetPosX( (controlPosX + 15) )
			Panel_GameTipMask			:SetPosY( (controlPosY - 7 ) )
		elseif idx == panelID.ClassResource then -- 난 소서러인가? 어둠의 파편이 나와야하나?
			if (CppEnums.ClassType.ClassType_Sorcerer == getSelfPlayer():getClassType()) then
				panelControl[idx].control	:SetShow( panelControl[idx].isShow )
			end
		elseif idx == panelID.ActionGuide then -- 액션 연계 가이드 옵션 저장
			setShowSkillCmd( panelControl[idx].isShow )
			isChecked_SkillCommand = panelControl[idx].isShow
			panelControl[idx].control:SetShow( panelControl[idx].isShow )
			GameOption_UpdateOptionChanged()
		elseif idx == panelID.KeyGuide then -- 실시간 키 입력 표시
			if true == panelControl[idx].isShow then
				FGlobal_KeyViewer_Show()
			else
				FGlobal_KeyViewer_Hide()
			end
			isChecked_KeyViewer = panelControl[idx].isShow
			GameOption_UpdateOptionChanged()			
		else	-- 그 외 나머지.
			panelControl[idx].control:SetShow( panelControl[idx].isShow )	
		end
	end

	ToClient_SaveUiInfo( true )	-- 위치를 잡고 저장해야 한다.
	FGlobal_PetListNew_NoPet()	-- 임시 : 나중에 정리해야 한다!!! - 2015-03-27 이문종

	FGlobal_saveUIScale( UiSet.currentScale )
	setUIScale( scale )				-- 화면 적용
	GameOption_SetUIMode( scale )	-- 옵션 적용
	saveGameOption(false)
end

function UiSet_Panel_ShowValueUpdate()	-- 오픈 전 상태 저장
	for idx = 1, UiSet.panelCount do
		panelControl[idx].isShow	= panelControl[idx].control:GetShow()
		panelControl[idx].prePos.x	= panelControl[idx].control:GetPosX()
		panelControl[idx].prePos.y	= panelControl[idx].control:GetPosY()
	end
end

function HandleClicked_UiSet_FieldViewToggle()	-- 시점 조절 토글
	if UiSet.btn_FieldView:IsCheck() then
		FieldViewMode_ShowToggle( true )
	else
		FieldViewMode_ShowToggle( false )
	end
end

function HandleClicked_UiSet_ChangeSacle()
	local nowPercent	= UiSet.slider_UI_Scale:GetControlPos()
	local realPercent = math.ceil(((UiSet.replaceScale / 100) * ( nowPercent * 100 )) + UiSet.minScale)
	UiSet.currentScale = realPercent
	local scaleText = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UI_SETTING_SCALETEXT", "currentScale", realPercent ) -- "인터페이스 크기( " .. UiSet.currentScale .. "% )"
	UiSet.txt_UISize		:SetText( tostring(scaleText) )

	local scale 		= UiSet.currentScale / 100
	local preScale		= UiSet.preScale
	
	for idx = 1, UiSet.panelCount do	-- 각 컨트롤을 스케일링한다.
		local slot = UiSet.panelPool[idx]
		slot.control:SetSize( slot.originSizeX * (1/preScale) * scale, slot.originSizeY * (1/preScale) * scale )

		if idx == panelID.ExpGage then
			slot.control:SetHorizonLeft()
			slot.control:SetVerticalTop()
		elseif idx == panelID.Radar then
			slot.control:SetHorizonRight()
			slot.control:SetVerticalTop()
			slot.control:SetSpanSize( 0, 20 )
		elseif idx == panelID.GameTip then
			slot.control:SetHorizonLeft()
			slot.control:SetVerticalBottom()
		elseif idx == panelID.UIMain then
			slot.control:SetHorizonRight()
			slot.control:SetVerticalBottom()
		end
		slot.control	:ComputePos()
		slot.close		:ComputePos()
	end
end

function UiSet_ScaleSet()
	-- 스케일 정보를 받아온다.
	local scaleValue		= FGlobal_getUIScale()
	UiSet.minScale			= scaleValue.min						-- 스케일 최소값
	UiSet.maxScale			= scaleValue.max						-- 스케일 최대값.
	UiSet.currentScale		= FGlobal_returnUIScale() * 100			-- 현재 스케일
	UiSet.replaceScale		= UiSet.maxScale - UiSet.minScale		-- 스케일 가용 범위
	UiSet.preScale			= FGlobal_returnUIScale()

	UiSet.nowCurrentPercent	= math.ceil(((UiSet.currentScale - UiSet.minScale) / UiSet.replaceScale ) * 100)	-- 변환용 현재 스케일. 
end


function FGlobal_UiSet_Open()
	ToClient_SaveUiInfo( true )
	-- audioPostEvent_SystemUi(01,41)
	if not IsSelfPlayerWaitAction() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTCURRENTACTION_ACK") ) -- "현재 액션에서는 이용할 수 없습니다." )
		return
	end

	UiSet_Panel_ShowValueUpdate()	-- 닫기 전 내용을 저장해야 한다.

	SetUIMode(Defines.UIMode.eUIMode_UiSetting)
	UI.flushAndClearUI()
	
	-- 열고 실행할 것 추가.
	Panel_UI_Setting:SetShow( true )
	UiSet.btn_FieldView:SetCheck( false )
	audioPostEvent_SystemUi(01,41)
	UiSet_ScaleSet()	-- 스케일 정보 반영

	for idx = 1, UiSet.panelCount do	-- 각 컨트롤을 스케일링한다.
		local slot = UiSet.panelPool[idx]
		if idx == panelID.ExpGage then
			slot.control:SetHorizonLeft()
			slot.control:SetVerticalTop()
		elseif idx == panelID.TimeBar then
			slot.control:SetHorizonRight()
			slot.control:SetVerticalTop()
		elseif idx == panelID.Radar then
			slot.control:SetHorizonRight()
			slot.control:SetVerticalTop()
			slot.control:SetSpanSize( 0, 20 )
		elseif idx == panelID.GameTip then
			slot.control:SetHorizonLeft()
			slot.control:SetVerticalBottom()
		elseif idx == panelID.UIMain then
			slot.control:SetHorizonRight()
			slot.control:SetVerticalBottom()
		end
	end

	UiSet_update()
end
function FGlobal_UiSet_Close()
	if ( false == Panel_UI_Setting:IsShow() ) then
		return
	end

	SetUIMode(Defines.UIMode.eUIMode_Default)
	UI.restoreFlushedUI()
	-- 닫고 실행할 것 추가.


	Panel_UI_Setting:SetShow( false )
end

function UiSet_OnScreenEvent()
	Panel_UI_Setting:SetSize( getScreenSizeX(), getScreenSizeY() )
	UiSet.title			:ComputePos()
	UiSet.btn_save		:ComputePos()
	UiSet.btn_cancel	:ComputePos()
	UiSet.btn_reset		:ComputePos()
end

function UiSet_registEventHandler()
	UiSet.btn_save			:addInputEvent("Mouse_LUp",		"HandleClicked_UiSet_ConfirmSetting()")
	UiSet.btn_cancel		:addInputEvent("Mouse_LUp",		"FGlobal_UiSet_Close()")
	UiSet.btn_reset			:addInputEvent("Mouse_LUp",		"HandleClicked_Reset_UiSetting_Msg()" )
	UiSet.btn_Scale			:addInputEvent("Mouse_LPress",	"HandleClicked_UiSet_ChangeSacle()")
	UiSet.slider_UI_Scale	:addInputEvent("Mouse_LUp",		"HandleClicked_UiSet_ChangeSacle()")

	UiSet.btn_FieldView	:addInputEvent("Mouse_LUp",		"HandleClicked_UiSet_FieldViewToggle()")
end

function HandleClicked_Reset_UiSetting_Msg()
	local	reset_GameUI = function()
		local const_LowMaxScaleValue	= 90
		local const_MidleMaxScaleValue	= 100
		local const_HightMaxScaleValue	= 120
		local minScaleHeight = 720
		local midleScaleHeight = 900;
		local uiScale = 1
		local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
		local screenHeight = gameOptionSetting:getScreenResolutionHeight()
		if false == isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
			const_LowMaxScaleValue	= 100
		end

		if( screenHeight <= minScaleHeight) then
			maxScaleValue = const_LowMaxScaleValue;
		elseif( minScaleHeight < screenHeight and screenHeight <= midleScaleHeight ) then
			maxScaleValue = const_MidleMaxScaleValue;
		else
			maxScaleValue = const_HightMaxScaleValue;
		end
		uiScale = math.floor( uiScale * 100 ) / 100
		if( uiScale * 100 > maxScaleValue ) then
			uiScale = 0.8
		end
		UiSet.nowCurrentPercent = uiScale

		SetUIMode(Defines.UIMode.eUIMode_Default)
		UI.restoreFlushedUI()

		FGlobal_saveUIScale( uiScale * 100 )
		setUIScale( uiScale )				-- 화면 적용
		GameOption_SetUIMode( uiScale )	-- 옵션 적용


		for idx = 1, UiSet.panelCount do
			if		idx == panelID.ServantIcon 
				or	idx == panelID.House
				or	idx == panelID.NewEquip 
				or	idx == panelID.Party 
				or	idx == panelID.Adrenallin 
				or	idx == panelID.QuickSlot 
				then

			else
				panelControl[idx].isShow = true
			end
			if panelControl[idx].posFixed then
				UiSet_ChangeTexture_BG( idx, 3 )
			else
				UiSet_ChangeTexture_BG( idx, 2 )
			end
			--UiSet.panelPool[idx].control:SetText( panelControl[idx].name )
			if idx == panelID.Pvp then
				if isPvpEnable() then	-- PVP가 가능한가.
					panelControl[idx].control:SetShow( panelControl[idx].isShow )
				end
			elseif idx == panelID.Adrenallin then
				if getSelfPlayer():isEnableAdrenalin() then	-- 아드레날린이 있나.
					panelControl[idx].control:SetShow( panelControl[idx].isShow )
				end
			elseif idx == panelID.GameTip then
				panelControl[idx].control	:SetShow( panelControl[idx].isShow )

				Panel_GameTipMask			:SetShow( panelControl[idx].isShow ) -- 마스크도 같이 처리해야 한다.
				Panel_GameTipMask			:SetPosX( UiSet.panelPool[idx].control:GetPosX() + 15)
				Panel_GameTipMask			:SetPosY( UiSet.panelPool[idx].control:GetPosY() - 7 )
			elseif idx == panelID.ClassResource then -- 난 소서러인가? 어둠의 파편이 나와야하나?
				if (CppEnums.ClassType.ClassType_Sorcerer == getSelfPlayer():getClassType()) then
					panelControl[idx].control:SetShow( panelControl[idx].isShow )
				end
			elseif idx == panelID.QuickSlot then
				panelControl[idx].control:SetShow( panelControl[idx].isShow )

			elseif idx == panelID.ActionGuide then -- 액션연계가이드 옵션 저장
				setShowSkillCmd( panelControl[idx].isShow )
				isChecked_SkillCommand = panelControl[idx].isShow
				panelControl[idx].control:SetShow( panelControl[idx].isShow )
				GameOption_UpdateOptionChanged()
			elseif idx == panelID.KeyGuide then -- 액션연계가이드 옵션 저장
				panelControl[idx].isShow = false
				Panel_KeyViewer_Hide()
				PanelMovieKeyViewer_RestorePosition()
			else	-- 그 외 나머지.
				panelControl[idx].control:SetShow( true )	
			end
		end

		Panel_NewEquip_EffectLastUpdate()
		FGlobal_ResetRadarUI()
		FGlobal_PetListNew_NoPet()	-- 임시 : 나중에 정리해야 한다!!! - 2015-03-27 이문종
		PartyPanel_Repos()
		FGlobal_ChattingPanel_Reset()
		FGlobal_NewQuickSlot_InitPos(false)


		resetGameUI()
		UiSet_update()
		ToClient_SaveUiInfo( true )	-- 위치를 잡고 저장해야 한다.
	end
	
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_ALLINTERFACERESET_CONFIRM") -- "모든 인터페이스 설정을 초기 상태로 되돌립니다.\n계속하시겠습니까?"
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_ALLINTERFACERESET"), content = messageBoxMemo, functionYes = reset_GameUI, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

UiSet_Initialize()
UiSet_registEventHandler()

registerEvent( "onScreenResize", "UiSet_OnScreenEvent"	)
