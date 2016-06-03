local UIMode 		= Defines.UIMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE

Panel_SkillAwaken:RegisterShowEventFunc( true, 'SkillAwaken_ShowAni()' )
Panel_SkillAwaken:RegisterShowEventFunc( false, 'SkillAwaken_HideAni()' )

Panel_SkillAwaken:ActiveMouseEventEffect( true )
Panel_SkillAwaken:setGlassBackground( true )


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

local _frame_SkillList 			= UI.getChildControl ( Panel_Frame_AwkSkillList, "Frame_SkillList" )
local _content_SkillList 		= UI.getChildControl ( _frame_SkillList, "Frame_1_Content" )
local _sld_content_SkillList	= UI.getChildControl ( _frame_SkillList, "Frame_1_VerticalScroll" )
local _sldBtn_content_SkillList	= UI.getChildControl ( _sld_content_SkillList, "Frame_1_VerticalScroll_CtrlButton" )

local _skillListSizeY			= _content_SkillList:GetSizeY()

local _frame_OptionList			= UI.getChildControl ( Panel_Frame_AwkOptions, "Frame_OptionList" )
local _content_OptionList		= UI.getChildControl ( _frame_OptionList, "Frame_2_Content" )
local _isReAwaken				= false
local _isAwakenRest				= false

_frame_OptionList:SetShow( false )

local ui =
	{
		_txt_Title 				= UI.getChildControl ( Panel_SkillAwaken, "StaticText_Title" ),
		_txt_canAwaken			= UI.getChildControl ( Panel_SkillAwaken, "StaticText_SkillList" ),
		_txt_OptionList 		= UI.getChildControl ( Panel_SkillAwaken, "StaticText_OpList" ),
		_awakenPoint 			= UI.getChildControl ( Panel_SkillAwaken, "StaticText_AwakePoint" ),

		_btn_Close 				= UI.getChildControl ( Panel_SkillAwaken, "Button_Close" ),
		_btn_CloseWin 			= UI.getChildControl ( Panel_SkillAwaken, "Button_CloseWindow" ),
		_btn_SwapWin			= UI.getChildControl ( Panel_SkillAwaken, "Button_WindowSwapisRewaken" ),
		
		_btn_doAwaken 			= UI.getChildControl ( Panel_SkillAwaken, "Button_Awaken" ),

		_circle 				= UI.getChildControl ( Panel_SkillAwaken, "Static_Circle" ),
		_circleEff 				= UI.getChildControl ( Panel_SkillAwaken, "Static_CircleEff" ),
		_circle_IconBG 			= UI.getChildControl ( Panel_SkillAwaken, "Static_SkillIcon_BG" ),
		_circle_Icon 			= UI.getChildControl ( Panel_SkillAwaken, "Static_SkillIcon" ),
		_circle_IconOff 		= UI.getChildControl ( Panel_SkillAwaken, "Static_SkillIcon_Off" ),
		_circle_IconOn 			= UI.getChildControl ( Panel_SkillAwaken, "Static_SkillIcon_On" ),

		_txt_SkillAwakenDesc	= UI.getChildControl ( Panel_SkillAwaken, "StaticText_SkillAwakenDesc" ),
		
		_circle_progress		= UI.getChildControl ( Panel_SkillAwaken, "CircularProgress_Awk" ),
		
		_buttonQuestion			= UI.getChildControl ( Panel_SkillAwaken, "Button_Question" ),		--물음표 버튼
}

local result = {
	_awakenResult_BG		= UI.getChildControl ( Panel_SkillAwaken_ResultOption, "Static_AcquireBG" ),		-- 각성한 내용
	_awakenTitle			= UI.getChildControl ( Panel_SkillAwaken_ResultOption, "StaticText_AwakenTitle" ),
	_awakenOption			= UI.getChildControl ( Panel_SkillAwaken_ResultOption, "StaticText_AwakenOption" ),
}

local copyUI = 
	{
		_copy_IconBG 			= UI.getChildControl ( _content_SkillList, "Button_C_SkIconBG_0" ),
		_copy_Icon 				= UI.getChildControl ( _content_SkillList, "Static_C_SkIcon_0" ),
		_copy_SkillName 		= UI.getChildControl ( _content_SkillList, "StaticText_C_SkName_0" ),
		_copy_AwakenLv 			= UI.getChildControl ( _content_SkillList, "StaticText_C_AwkLv_0" ),
		_copy_AwakenOption 		= UI.getChildControl ( _content_SkillList, "StaticText_C_AwkOp_0" ),
	}

local getStr_SkillAwaken = 
{
	[0] = PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_TITLE" ),				--[[ 기술 각성 ]]
	[1] = PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_AWAKENLIST" ),		--[[ 현재 각성 가능한 스킬 수 : ]]
	[2] = PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_OPTIONLIST" ),		--[[ 각성 시 추가 기능 목록 ]]
}

local AwakenMng = 
{
	_buttonCount 		= 50,		-- 각성기술 노출 갯수를 증가시킬려면 이 숫자를 바꾸면된다.
	_uiButtonAwkList 	= {}
}

local buttonAwakenList		= UI.getChildControl(Panel_SkillAwaken, "Button_AwakenA")		-- 각성 목록
local buttonAwakenClearList	= UI.getChildControl(Panel_SkillAwaken, "Button_ResetAwaken")	-- 초기화 목록
local textNoSkills			= UI.getChildControl(Panel_SkillAwaken, "StaticText_NoSkills")
	
	
	
-- 기본 설정
ui._btn_doAwaken:SetIgnore(true)
ui._btn_doAwaken:SetMonoTone(true)
ui._circle_IconOn:SetShow(false)
ui._circleEff:SetShow(false)

copyUI._copy_IconBG:SetShow(false)
copyUI._copy_Icon:SetShow(false)
copyUI._copy_SkillName:SetShow(false)
copyUI._copy_AwakenLv:SetShow(false)
copyUI._copy_AwakenOption:SetShow(false)

Panel_SkillAwaken:SetShow( false )

Panel_SkillAwaken:MoveChilds(Panel_SkillAwaken:GetID(), Panel_Frame_AwkSkillList)
Panel_SkillAwaken:MoveChilds(Panel_SkillAwaken:GetID(), Panel_Frame_AwkOptions)
deletePanel(Panel_Frame_AwkSkillList:GetID())
deletePanel(Panel_Frame_AwkOptions:GetID())
Panel_Frame_AwkSkillList = nil
Panel_Frame_AwkOptions = nil


-- 변수 모음
local listSizeY = 0
local skillIndex = -1
local copyIndex = -1

-- 원형 게이지바 가자!
local isStartAwaken = false
local isEndCircular = false
local currentTimer 	= 0
local currentRate 	= 0
local _endCircular 	= 100	-- 꽉 차있는 놈
local endTime 		= 2.0
local tmpValue 		= _endCircular/endTime

-- 게이바가 다 찼다!
local isCompleteCircular = false

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

ui._btn_Close:addInputEvent( "Mouse_LUp", "SkillAwaken_HideAni()" )
ui._btn_CloseWin:addInputEvent( "Mouse_LUp", "SkillAwaken_HideAni()" )
ui._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelSkillAwaken\" )" )																							-- 물음표 좌클릭
ui._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelSkillAwaken\", \"true\")" )				-- 물음표 마우스오버
ui._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelSkillAwaken\", \"false\")" )			-- 물음표 마우스아웃
ui._btn_SwapWin:addInputEvent( "Mouse_LUp", "HandleClicked_SwapWindow()" )
-- 창 끄고 켜기
function SkillAwaken_ShowAni()
	Panel_SkillAwaken:SetShow( true )
	UIAni.fadeInSCR_Down( Panel_SkillAwaken )
	UIAni.AlphaAnimation( 1, ui._circle_progress, 0.0, 0.2 )
	UIAni.AlphaAnimation( 1, ui._circleEff, 0.0, 0.2 )
	ui._circleEff:SetVertexAniRun( "Ani_Color_Off", true )
	
	Panel_SkillAwaken_ResultOption:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_SkillAwaken_ResultOption, 0.0, 0.3 )
	aniInfo:SetHideAtEnd(true)
	
	-- 각성 도중에 스킬 변경을 방지를위해 막았던것 풀어준다.
	local self = AwakenMng
	for index = 0, self._buttonCount-1, 1 do
		self._uiButtonAwkList[index]._Icon:SetIgnore( false )
		self._uiButtonAwkList[index]._IconBG:SetIgnore( false )
	end
end


function SkillAwaken_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_SkillAwaken, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)
	
	local aniInfo1 = UIAni.AlphaAnimation( 0, ui._circle_progress, 0.0, 0.2 )
	aniInfo1:SetHideAtEnd(true)

	local aniInfo3 = UIAni.AlphaAnimation( 0, ui._circleEff, 0.0, 0.2 )
	aniInfo3:SetHideAtEnd(true)
	
	_isReAwaken = false
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


local awakening = {}

function awakening.createSlot(index)
	local ui 	= {}
	
	-- 각성 컨트롤 리스트 맹글기 ( BG )
	ui._IconBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, _content_SkillList, 'Button_AwakenBG_' .. index )
	CopyBaseProperty( copyUI._copy_IconBG,	ui._IconBG )
	ui._IconBG:SetShow(true)
	ui._IconBG:addInputEvent( "Mouse_LUp", "event_AwakenSkill("..index..")" )
	-- ui._IconBG:SetPosY( index * ( ui._IconBG:GetSizeY() + 15 ) )

	--각성 컨트롤 리스트 맹글기 ( 스킬 아이콘 )
	ui._Icon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, _content_SkillList, 'Static_C_SkillIcon_' .. index )
	CopyBaseProperty( copyUI._copy_Icon, ui._Icon )
	ui._Icon:SetShow(true)
	ui._Icon:addInputEvent( "Mouse_LUp", "event_AwakenSkill( "..index.." )" )
	-- ui._Icon:SetPosY( ui._IconBG:GetPosY() + 8 )
	
	-- 각성 컨트롤 리스트 맹글기 ( 스킬 이름 )
	ui._SkillName 	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, _content_SkillList, 'StaticText_C_SkillName_' .. index )
	CopyBaseProperty( copyUI._copy_SkillName,	ui._SkillName )
	ui._SkillName:SetShow(true)
	-- ui._SkillName:SetPosY( ui._IconBG:GetPosY() + 12 )
	
	-- 각성 컨트롤 리스트 맹글기 ( 각성 레벨 )
	ui._AwakenLv 	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, _content_SkillList, 'StaticText_C_AwknLv_' .. index )
	CopyBaseProperty( copyUI._copy_AwakenLv,	ui._AwakenLv )
	ui._AwakenLv:SetShow(true)
	ui._AwakenLv:SetAutoResize( true )
	ui._AwakenLv:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- ui._AwakenLv:SetPosY( ui._IconBG:GetPosY() + 35 )
	
	-- 각성 컨트롤 리스트 맹글기 ( 각성 옵션 )
	ui._AwakenOption 	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, _content_SkillList, 'StaticText_C_AwknOp_' .. index )
	CopyBaseProperty( copyUI._copy_AwakenOption,	ui._AwakenOption )
	ui._AwakenOption:SetShow(true)
	-- ui._AwakenOption:SetPosY( ui._IconBG:GetPosY() + 55 )
	ui._AwakenOption:SetAutoResize( true )
	ui._AwakenOption:SetTextMode( UI_TM.eTextMode_AutoWrap )
		
	-- Content 의 사이즈를 결정한다!
	listSizeY = ( index * ( ui._IconBG:GetSizeY() + 35 ) )
	
	_content_SkillList:SetSize( _content_SkillList:GetSizeX(), listSizeY + 50 )
	
	function ui:SetShow( isShow )
		ui._IconBG:SetShow( isShow )
		ui._Icon:SetShow( isShow )
		ui._SkillName:SetShow( isShow )
		ui._AwakenLv:SetShow( isShow )
		ui._AwakenOption:SetShow( isShow )
	end
	
	function ui:SetData( skillWrapper, posY, tabType )
		local skillTypeSSW = skillWrapper:getSkillTypeStaticStatusWrapper()
		local skillNo = skillWrapper:getSkillNo()

		skillNoCache = skillNo
		
		if not tabType then
			ui._IconBG:SetPosY( posY )
			ui._Icon:SetPosY( ui._IconBG:GetPosY() + 8 )
			ui._SkillName:SetPosY( ui._IconBG:GetPosY() + 12 )
			ui._AwakenLv:SetPosY( ui._IconBG:GetPosY() + 35 )
			ui._AwakenOption:SetPosY( ui._IconBG:GetPosY() + 55 )

			ui._SkillName:SetText( skillWrapper:getName() )
			ui._Icon:ChangeTextureInfoName( "Icon/"..skillTypeSSW:getIconPath() )
			ui._AwakenOption:SetText( skillTypeSSW:getDescription() )
			ui._IconBG:SetSize( ui._IconBG:GetSizeX(), ui._Icon:GetSizeY() + ui._AwakenOption:GetTextSizeY() + 30 )
		else
			ui._IconBG:SetPosY( posY )
			ui._Icon:SetPosY( ui._IconBG:GetPosY() + 8 )
			ui._SkillName:SetPosY( ui._IconBG:GetPosY() + 12 )
			ui._AwakenLv:SetPosY( ui._IconBG:GetPosY() + 35 )
			ui._AwakenOption:SetPosY( ui._IconBG:GetPosY() + ui._AwakenLv:GetTextSizeY() + 55 )

			ui._SkillName:SetText( skillWrapper:getName() )
			ui._Icon:ChangeTextureInfoName( "Icon/"..skillTypeSSW:getIconPath() )
			ui._AwakenOption:SetText( skillTypeSSW:getDescription() )
			ui._IconBG:SetSize( ui._IconBG:GetSizeX(), ui._Icon:GetSizeY() + ui._AwakenLv:GetTextSizeY() + ui._AwakenOption:GetTextSizeY() + 30 )			
		end


		-------------------------------------------------------
		-- 					툴팁 띄우기
		-- self._IconBG:addInputEvent( "Mouse_On", 	"SkillAwaken_OverEvent(" .. skillNo .. ", \"SkillAwaken\")" )
		-- self._IconBG:addInputEvent( "Mouse_Out", 	"SkillAwaken_OverEventHide(" .. skillNo .. ",\"SkillAwaken\")" )
		self._Icon:addInputEvent( "Mouse_On", 		"SkillAwaken_OverEvent(" .. skillNo .. ", \"SkillAwaken\")" )
		self._Icon:addInputEvent( "Mouse_Out", 		"SkillAwaken_OverEventHide(" .. skillNo .. ",\"SkillAwaken\")" )
		Panel_SkillTooltip_SetPosition( skillNo, self._Icon, "SkillAwaken" )
		return ui._IconBG:GetPosY() + ui._IconBG:GetSizeY() + 5
	end
	return ui
end


-- 각성 아이콘 및 BG를 클릭하면
function event_AwakenSkill( index )
	-- ♬ 아이콘을 각성 창에 넣었을 때 사운드
	audioPostEvent_SystemUi(00,07)
	
	local skillWrapper = skillWindow_awakeningSkillAt( index )
	local skillTypeSSW = skillWrapper:getSkillTypeStaticStatusWrapper()
	
	ui._circleEff:ResetVertexAni()
	ui._circleEff:EraseAllEffect()
	ui._circleEff:SetVertexAniRun( "Ani_Color_On",true )
	ui._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	ui._circle_IconOff:SetShow(false)
	ui._circle_IconOn:SetShow(true)
	
	ui._circle_Icon:ChangeTextureInfoName("Icon/"..skillTypeSSW:getIconPath() )
	ui._circle_Icon:addInputEvent( "Mouse_LUp", "event_deleteCircleIcon()" )

	ui._btn_doAwaken:SetAlpha(1.0)
	ui._btn_doAwaken:SetFontAlpha(1.0)
	ui._btn_doAwaken:SetIgnore(false)
	ui._btn_doAwaken:SetMonoTone(false)
	
	ui._btn_doAwaken:EraseAllEffect()
	ui._btn_doAwaken:AddEffect( "UI_Shop_Button", true, 0, 0 )
	ui._circle_Icon:EraseAllEffect()
	ui._circle_Icon:AddEffect( "fUI_NewSkill_Loop01", true, 0, 0 )
	ui._circle_Icon:AddEffect( "fUI_SkillAwakenLight", false, 0, 0 )
	ui._circle_Icon:AddEffect( "fUI_SkillAwakenSpinSmoke", false, 0, 0 )
	
	--ui._btn_doAwaken:addInputEvent( "Mouse_LUp", "clickAwakeningSkill()" )
	skillIndex = index
	

	local doHaveAwakenResetItem = false
	local isAwakenable = false;
	
	if true == _isReAwaken then
		-- 스킬 재각성
		if ToClient_isPossibleReAwalening() then
			ui._btn_doAwaken:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_SKILLREAWAKEN_TITLE"))
			ui._btn_doAwaken:addInputEvent( "Mouse_LUp", "Awaken_MessageBox()" )
		else
			ui._btn_doAwaken:EraseAllEffect()
			ui._btn_doAwaken:SetAlpha(0.85)
			ui._btn_doAwaken:SetFontAlpha(0.85)
			ui._btn_doAwaken:SetIgnore(true)
			ui._btn_doAwaken:SetMonoTone(true)
		end
	elseif true == _isAwakenRest then
		-- 각성 초기화
		ui._btn_doAwaken:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_RESET"))
		ui._btn_doAwaken:addInputEvent( "Mouse_LUp", "clickAwakeningRest("..index..")" )
		
		doHaveAwakenResetItem = skillWindow_doHaveAwakenResetItem()
		if not doHaveAwakenResetItem then
			ui._btn_doAwaken:EraseAllEffect()
			ui._btn_doAwaken:SetIgnore(true)
			ui._btn_doAwaken:SetMonoTone(true)
		end
	else
		-- 스킬 각성
		ui._btn_doAwaken:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_TITLE"))
		ui._btn_doAwaken:addInputEvent( "Mouse_LUp", "clickAwakeningSkill()" )
		
		isAwakenable = skillWindow_isAwakenable()
		if not isAwakenable then
			ui._btn_doAwaken:EraseAllEffect()
			ui._btn_doAwaken:SetIgnore(true)
			ui._btn_doAwaken:SetMonoTone(true)
		end
	end
end

-- 동그라미 위에 올려진 놈이 클릭됐다! -- 다시 빼는거
function event_deleteCircleIcon()
	-- ♬ 스킬 아이콘을 다시 뺄 때 사운드
	audioPostEvent_SystemUi(00,11)
	
	ui._circleEff:ResetVertexAni()
	ui._circleEff:EraseAllEffect()
	ui._circleEff:SetVertexAniRun( "Ani_Color_Off",true )
	ui._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	ui._circle_IconOff:SetShow(true)
	ui._circle_IconOn:SetShow(false)
	ui._circle_Icon:ChangeTextureInfoName( "" )
	
	ui._circle_Icon:EraseAllEffect()
	ui._btn_doAwaken:EraseAllEffect()
	ui._btn_doAwaken:SetAlpha(0.85)
	ui._btn_doAwaken:SetFontAlpha(0.85)
	ui._btn_doAwaken:SetIgnore(true)
	ui._btn_doAwaken:SetMonoTone(true)
	
	skillIndex = -1
end



--------------------------------------------------------------------
-- 						스킬 툴팁 보여주기
--------------------------------------------------------------------
local skillNoCache = 0
local slotTypeCache = 0
local tooltipcacheCount = 0
function SkillAwaken_OverEvent( skillNo, SlotType )
	if ( skillNoCache == skillNo ) and ( slotTypeCache == SlotType ) then
		tooltipcacheCount = tooltipcacheCount + 1
	else
		skillNoCache = skillNo
		slotTypeCache = SlotType
		tooltipcacheCount = 1
	end
	
	Panel_SkillTooltip_Show(skillNo, false, SlotType)
end

function SkillAwaken_OverEventHide( skillNo, SlotType )
	if ( skillNoCache == skillNo ) and ( slotTypeCache == SlotType ) then
		tooltipcacheCount = tooltipcacheCount - 1
	else
		tooltipcacheCount = 0
	end

	if ( tooltipcacheCount <= 0 ) then
		Panel_SkillTooltip_Hide()
	end
end



--------------------------------------------------------------------
-- 					각성 원형 게이지가 돈다!
--------------------------------------------------------------------
function Update_CircularProgress( deltaTime, index )
	-- 현재 각성 가능한 스킬 개수를 보여준다
	ui._awakenPoint:SetText( getStr_SkillAwaken[1].." <PAColor0xffffa82c>"..tostring(copyIndex).."<PAOldColor>" )
	
	if ( isStartAwaken == true ) then
		
		if ( currentTimer < 3 ) and ( isCompleteCircular == false ) then
			currentTimer = currentTimer + deltaTime
			currentRate = currentRate + tmpValue * deltaTime
		
			ui._circle_progress:SetProgressRate( currentRate )
			
			if ( currentRate >= 100 ) then
				-- ♬ 각성이 완료될 때 사운드
				ui._circle_progress:EraseAllEffect()
				ui._circle_Icon:EraseAllEffect()
				
				ui._circle_progress:AddEffect( "UI_ItemInstall_BigRing", true, 0, 0 )
				ui._circle_Icon:	AddEffect( "UI_ItemInstall_Gold", true, 0, 0 )
				ui._circle_Icon:	AddEffect( "UI_SkillAwakeningShield", false, 0, 0 )
				ui._circle_Icon:	AddEffect( "fUI_SkillButton02", false, 0, 0 )
				ui._circle_Icon:	AddEffect( "fUI_NewSkill01", false, 0, 0 )
				ui._circle_Icon:	AddEffect( "UI_SkillAwakeningFinal", false, 0, 0 )
				ui._circle_Icon:	AddEffect( "fUI_SkillAwakenBoom", false, 0, 0 )

				currentTimer = 0
				isCompleteCircular = true
			end
		end
	end	

	-- 끝났다!
	if ( isCompleteCircular == true ) then
		currentTimer = currentTimer + deltaTime
		if ( currentTimer > 2 ) then
			-- 이펙트 추가 필요
			isStartAwaken = false
			isEndCircular = true
			isCompleteCircular = false
			_endCircular = 100
			currentTimer = 0
			currentRate = 0
			deltaTime = 0
						
			ui._circle_Icon:SetIgnore( false )
						
			Panel_SkillAwaken:SetShow( false, true )
			skillWindow_requestAwakenSkill( skillIndex )		-- 각성 시켜라
			skillIndex = -1
			
			buttonAwakenList:SetIgnore(false)
			buttonAwakenClearList:SetIgnore(false)
			FGlobal_ResetUrl_Tooltip_SkillForLearning()
			
		end
	end
end

---------------------------------------------
-- 				각성 시작!
---------------------------------------------
function clickAwakeningSkill()
	-- ♬ 각성이 시작되었을 때 사운드
	audioPostEvent_SystemUi(03,10)
		
	isStartAwaken = true
	
	ui._circle_Icon:SetIgnore( true )
	
	ui._btn_doAwaken:EraseAllEffect()
	ui._btn_doAwaken:SetAlpha(0.85)
	ui._btn_doAwaken:SetFontAlpha(0.85)
	ui._btn_doAwaken:SetIgnore(true)
	ui._btn_doAwaken:SetMonoTone(true)
	
	ui._circle_progress:AddEffect( "UI_ItemInstall_ProduceRing", true, 0, 0 )
	ui._circle_Icon:AddEffect( "UI_SkillAwakening01", false, 0, 0 )

	ui._circle_progress:SetShow( true )
	
	-- 각성 도중에 스킬 변경 금지
	local self = AwakenMng
	for index = 0, self._buttonCount-1, 1 do
		self._uiButtonAwkList[index]._Icon:SetIgnore( true )
		self._uiButtonAwkList[index]._IconBG:SetIgnore( true )
	end
	
	buttonAwakenList:SetIgnore( true )
	buttonAwakenClearList:SetIgnore( true )
end

function Awaken_MessageBox()
	-- local doAwakenOk = function()
	-- 	ToClient_AwakenSkillResetRequest(index)
	-- 	Panel_SkillAwaken:SetShow( false, true )
	-- end
	if true == _isReAwaken then
		local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLREAWAKEN_MSGBOX")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = clickAwakeningSkill, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		clickAwakeningSkill()
	end
end

---------------------------------------------
-- 				각성 초기화!
---------------------------------------------
function clickAwakeningRest( index )
	ToClient_AwakenSkillResetRequest(index)
	Panel_SkillAwaken:SetShow( false, true )
end


function AwakenMng:initialize()
	_frame_SkillList:UpdateContentScroll()
	_frame_SkillList:GetVScroll():SetControlTop()
	_frame_SkillList:UpdateContentPos()
	
	for index = 0, self._buttonCount-1, 1 do
		self._uiButtonAwkList[index] = awakening.createSlot( index )
		self._uiButtonAwkList[index]:SetShow(false)	
		copyIndex = index
	end
	_frame_SkillList:UpdateContentScroll()		-- 스크롤 감도 동일하게
	_frame_OptionList:UpdateContentScroll()		-- 스크롤 감도 동일하게
	
	buttonAwakenList:addInputEvent("Mouse_LUp", "HandleClicked_ButtonAwakenList()")
	buttonAwakenClearList:addInputEvent("Mouse_LUp", "HandleClicked_ButtonAwakenClearList()")
	--buttonAwakenClearList:SetIgnore(true)
	--buttonAwakenClearList:SetFontColor(4287137928)
	textNoSkills:SetShow(false)
end

-- 스킬 각성창 띄우기
function AwakenMng:SkillAwaken_Show()

	if Panel_Window_Enchant:GetShow() then			-- 다른 창들이 열려 있다면 닫아준다!
		FGlobalEnchant_Hide()
		ToClient_BlackspiritEnchantClose()
	elseif Panel_Window_Socket:GetShow() then
		Socket_WindowClose()
		ToClient_BlackspiritEnchantClose()
	end
	Panel_Join_Close()
	FGlobal_LifeRanking_Close()

	local count = skillWindow_awakeningSkillCount()
	local posY	= 0
	for index = 0, self._buttonCount-1, 1 do
		if( index < count ) then
			local classType = getSelfPlayer():getClassType()
			local cellTable = nil
			
			local skillWrapper = skillWindow_awakeningSkillAt( index )
			local _skillNo = skillWrapper:getSkillNo()
			local skillLevelInfo = getSkillLevelInfo( _skillNo )

			if nil ~= skillLevelInfo then		
				posY = self._uiButtonAwkList[index]:SetData( skillWrapper, posY, _isAwakenRest )
				self._uiButtonAwkList[index]:SetShow(true)
				if (true == _isAwakenRest) or ( false == _isAwakenRest and true == _isReAwaken ) then	-- 각성되어 있다.
					local skillSS = getSkillStaticStatus( _skillNo, 1 )
					local activeSkillSS = getActiveSkillStatus( skillSS )
					if nil ~= activeSkillSS then
						local awakeningDataCount = activeSkillSS:getSkillAwakenInfoCount()
						local awakeInfo = ""
						local realCount = 0
				    	for idx = 0, awakeningDataCount - 1 do
				    		local skillInfo = activeSkillSS:getSkillAwakenInfo(idx)
				    		if ( "" ~= skillInfo ) then
				    			if "" == awakeInfo then
				    				awakeInfo = skillInfo
				    			else
				    				awakeInfo = awakeInfo .. "\n" .. skillInfo
				    			end
				    			realCount = realCount +1
				    		end
				    	end
						self._uiButtonAwkList[index]._AwakenLv:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_AWAKENEFFECT", "awakeInfo", awakeInfo ) ) -- 각성효과 : " .. awakeInfo
					end
					-- "초기화 가능 스킬" PAGetString(Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_RESETPOSSIBLE")
				else	-- 각성 할 수 있다.
					self._uiButtonAwkList[index]._AwakenLv:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_POSSIBLE") ) -- "각성 가능 스킬"
				end
			end
		else
			self._uiButtonAwkList[index]:SetShow(false)
		end
		-- if not _isAwakenRest then
		-- 	self._uiButtonAwkList[index]._AwakenOption:SetPosY( self._uiButtonAwkList[index]._IconBG:GetPosY() + 55 )
		-- 	self._uiButtonAwkList[index]._IconBG:SetSize( self._uiButtonAwkList[index]._IconBG:GetSizeX(), self._uiButtonAwkList[index]._Icon:GetSizeY() + self._uiButtonAwkList[index]._AwakenOption:GetTextSizeY() + 30 )
		-- else
		-- 	self._uiButtonAwkList[index]._AwakenOption:SetPosY( self._uiButtonAwkList[index]._IconBG:GetPosY() + self._uiButtonAwkList[index]._AwakenLv:GetTextSizeY() + 55 )
		-- 	self._uiButtonAwkList[index]._IconBG:SetSize( self._uiButtonAwkList[index]._IconBG:GetSizeX(), self._uiButtonAwkList[index]._Icon:GetSizeY() + self._uiButtonAwkList[index]._AwakenLv:GetTextSizeY() + self._uiButtonAwkList[index]._AwakenOption:GetTextSizeY() + 30 )
		-- end
	end
	
	if false == _isAwakenRest then
		buttonAwakenList:SetCheck( true )
		buttonAwakenClearList:SetCheck( false )
	else
		buttonAwakenList:SetCheck( false )
		buttonAwakenClearList:SetCheck( true )
	end

	_content_SkillList:SetSize(_content_SkillList:GetSizeX() , posY)	-- 스킬 List에 맞춰 Scroll 조정
	UIScroll.SetButtonSize( _sld_content_SkillList, _frame_SkillList:GetSizeY(),  posY)
	_sld_content_SkillList:SetControlPos( 0 )
	
	Panel_SkillAwaken:SetShow( true, true )

	_frame_SkillList:UpdateContentScroll()
	_frame_SkillList:GetVScroll():SetControlTop()
	_frame_SkillList:UpdateContentPos()
	
	_content_SkillList:SetIgnore( true )
	ui._circle_progress:SetCurrentControlPos(0)
	ui._circle_progress:SetProgressRate(0)
	isStartAwaken = false
	isCompleteCircular = false
	currentRate = 0
	_endCircular = 100
	currentTimer = 0
	skillIndex = -1
	
	if 0 == count then
		textNoSkills:SetShow(true)
	else
		textNoSkills:SetShow(false)
	end
end

function SkillAwaken_Close()
	Panel_SkillAwaken:SetShow( false, false )
end

-----------------------------------------------------------------
-- 			각성 성공한 스킬의 옵션 보여주기
-----------------------------------------------------------------
function FromClient_SuccessSkillAwaken( skillNo, level )
	Panel_SkillAwaken_ResultOption:SetSize( getScreenSizeX(), getScreenSizeY() )
	Panel_SkillAwaken_ResultOption:SetPosX( 0 )
	Panel_SkillAwaken_ResultOption:SetPosY( 20 )
	
	local skillStatic = getSkillStaticStatus( skillNo, 1 )
	local activeSkillSS = nil
	
	if ( skillStatic:isActiveSkillHas() ) then
		activeSkillSS = getActiveSkillStatus( skillStatic )
		if ( nil == activeSkillSS ) then
			Panel_SkillAwaken_ResultOption:SetShow( false )
		else
			local awakeInfo = ""
			local awakeningDataCount = activeSkillSS:getSkillAwakenInfoCount() -1
			for index = 0, awakeningDataCount do
				local skillInfo = activeSkillSS:getSkillAwakenInfo( index )
				if ( "" ~= skillInfo ) then
					awakeInfo = awakeInfo .. "\n" .. skillInfo
				end
			end
			
			Panel_SkillAwaken_ResultOption:SetShow( true )
			Panel_SkillAwaken_ResultOption:SetAlpha( 0 )
			UIAni.AlphaAnimation( 1, Panel_SkillAwaken_ResultOption, 0.0, 0.3 )
			
			result._awakenOption:SetText( "<PAColor0xffdadada>" .. tostring(awakeInfo) .. "<PAOldColor>" )
			
			result._awakenResult_BG:SetPosX( 0 )
			result._awakenTitle:ComputePos()
			result._awakenOption:ComputePos()
			
			acquireSizeY = result._awakenTitle:GetSizeY() + result._awakenOption:GetTextSizeY() + 85
			result._awakenResult_BG:SetSize( getScreenSizeX(), acquireSizeY )
		end
	end
	
	-- 다이얼로그 리프레쉬
	ReqeustDialog_retryTalk()
end



-- 켜주기
function EventShowAwakenSkill( isRewaken )
	_isAwakenRest = false	-- 첫 화면은 무저건 각성 가능한 스킬만 보여줌
	ui._circle_progress:SetProgressRate( 0 )
	
	ui._circleEff:SetShow(true)
	ui._circleEff:ResetVertexAni()
	ui._circleEff:SetVertexAniRun( "Ani_Color_Off",true )
	ui._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	ui._circle_Icon:EraseAllEffect()
	ui._circle_Icon:ChangeTextureInfoName( "" )
	ui._circle_progress:EraseAllEffect()
	
	ui._circle_IconOff:SetShow(true)
	ui._circle_IconOn:SetShow(false)
	
	ui._btn_doAwaken:EraseAllEffect()
	ui._btn_doAwaken:SetAlpha(0.85)
	ui._btn_doAwaken:SetFontAlpha(0.85)
	ui._btn_doAwaken:SetIgnore(true)
	ui._btn_doAwaken:SetMonoTone(true)
	
	_isReAwaken = isRewaken
	
	AwakenMng:SkillAwaken_Show()
	
	local _AwakenTitle 	= PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_TITLE")
	if true == isRewaken then
		_AwakenTitle = PAGetString( Defines.StringSheet_GAME, "LUA_SKILLREAWAKEN_TITLE")
	end
	ui._txt_Title		:SetText(_AwakenTitle)
	ui._btn_doAwaken	:SetText(_AwakenTitle)
	
	-- 스킬 초기화 아이템이 있는지 검사
	-- 있으면 초기화 목록 버튼 활성화
	if ToClient_CheckAwakenResetItem() then
		buttonAwakenClearList:SetIgnore(false)
		buttonAwakenClearList:SetFontColor(4294962304)
	else
		buttonAwakenClearList:SetIgnore(true)
		buttonAwakenClearList:SetFontColor(4287137928)
	end
	
	-- 스킬 재각성일때 각성/초기화 리스트 버튼은 노출하지 않음
	ui._btn_SwapWin:SetShow( true )
	if isRewaken then
		buttonAwakenList:SetShow(false)
		buttonAwakenClearList:SetShow(false)
		ui._txt_SkillAwakenDesc:SetShow( true )
		ui._txt_canAwaken:SetShow( true )
		ui._btn_SwapWin:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_SKILLAWAKEN_TITLE") )
	else
		buttonAwakenList:SetShow(true)
		buttonAwakenClearList:SetShow(true)
		ui._txt_SkillAwakenDesc:SetShow( false )
		ui._txt_canAwaken:SetShow( false )
		ui._btn_SwapWin:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_SKILLREAWAKEN_TITLE") )
		if getSelfPlayer():get():getLevel() < 50 or 0 == ToClient_GetAwakenSkillCount() then		-- 50레벨이 안됐거나, 각성한 스킬이 없다면 재각성 버튼을 노출시키지 않는다!
			ui._btn_SwapWin:SetShow( false )
		end
	end
end

function HandleClicked_SwapWindow()
	if _isReAwaken then
		ToClient_UpdateAwakenList()
	else
		ToClient_UpdateAwakenClearList()
	end
	-- EventShowAwakenSkill( not _isRewaken )
	ToClient_SetShowAwakenSkill( not _isReAwaken )
end

---------------------------------------------------------------------------------------------------------
--									재각성용 각성 정보 가져오기
---------------------------------------------------------------------------------------------------------
function reAwaken_Func()
	Panel_SkillAwaken_ResultOption:SetSize( getScreenSizeX(), getScreenSizeY() )
	Panel_SkillAwaken_ResultOption:SetPosX( 0 )
	Panel_SkillAwaken_ResultOption:SetPosY( 20 )
	
	local isAwakeningData = false
	local activeSkillSS = nil
	
	if ( skillWrapper:isActiveSkillHas() ) then
		activeSkillSS = getActiveSkillStatus(skillWrapper)
		if ( nil == activeSkillSS ) then
			Panel_SkillAwaken_ResultOption:SetShow( false )
		else
			local awakeInfo = ""
			local awakeningDataCount = activeSkillSS:getSkillAwakenInfoCount() 
			local realCount = 0
			for idx = 0, awakeningDataCount do
				local skillInfo = activeSkillSS:getSkillAwakenInfo(idx)
				if ( "" ~= skillInfo ) then
					awakeInfo = awakeInfo .. "\n" .. skillInfo
					realCount = realCount +1
				end
			end

			Panel_SkillAwaken_ResultOption:SetShow( true )
			Panel_SkillAwaken_ResultOption:SetAlpha( 0 )
			UIAni.AlphaAnimation( 1, Panel_SkillAwaken_ResultOption, 0.0, 0.3 )
			
			result._awakenOption:SetText( "<PAColor0xffdadada>" .. awakeInfo .. "<PAOldColor>" )
			
			result._awakenResult_BG:SetPosX( 0 )
			result._awakenTitle:ComputePos()
			result._awakenOption:ComputePos()
			
			acquireSizeY = result._awakenTitle:GetSizeY() + result._awakenOption:GetTextSizeY() + 85
			result._awakenResult_BG:SetSize( getScreenSizeX(), acquireSizeY )
			
			isAwakeningData = ( 0 < realCount )
		end
	else
		Panel_SkillAwaken_ResultOption:SetShow( false )
	end
end

function HandleClicked_ButtonAwakenList()
	_isAwakenRest = false
	ToClient_UpdateAwakenList()
	AwakenMng:SkillAwaken_Show()
end

function HandleClicked_ButtonAwakenClearList()
	_isAwakenRest = true
	ToClient_UpdateAwakenClearList()
	FGlobal_SetUrl_Tooltip_SkillForLearning()	-- 안해주면 각성 초기화 툴팁에서 영상이 안나옴
	AwakenMng:SkillAwaken_Show()
end




-----------------------------------------------------------------------------------------------------------------------------------------------------
AwakenMng:initialize()
registerEvent("EventShowAwakenSkill", 			"EventShowAwakenSkill")
registerEvent("FromClient_SuccessSkillAwaken",	"FromClient_SuccessSkillAwaken")
Panel_SkillAwaken:RegisterUpdateFunc("Update_CircularProgress")
-- Panel_SkillAwaken_ResultOption:RegisterUpdateFunc("FromClient_SuccessSkillAwaken")

-- show_AskKnowledge({[0] = {_keyword='아하', _x=1, _y=1, _z=1}, {_keyword='아하', _x=12800, _y=0, _z=64000}})
