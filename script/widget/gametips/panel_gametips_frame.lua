local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PUCT 			= CppEnums.PA_UI_CONTROL_TYPE

Panel_Window_GameTips:SetShow( false, false )
Panel_Window_GameTips:setGlassBackground( true )
Panel_Window_GameTips:setMaskingChild( true )
Panel_Window_GameTips:SetDragAll( true )
Panel_Window_GameTips:ActiveMouseEventEffect(true)

Panel_Window_GameTips:RegisterShowEventFunc( true, 'Panel_GameTips_ShowAni()' )
Panel_Window_GameTips:RegisterShowEventFunc( false, 'Panel_GameTips_HideAni()' )

------------------------------------------------------------
--				켜고 꺼주는 애니메이션 함수
------------------------------------------------------------
function Panel_GameTips_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_Window_GameTips, 0.0, 0.15 )
	
	local aniInfo1 = Panel_Window_GameTips:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.08)
	aniInfo1.AxisX = Panel_Window_GameTips:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_GameTips:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_GameTips:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.08)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_GameTips:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_GameTips:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_GameTips_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_GameTips, 0.0, 0.1 )
	aniInfo:SetHideAtEnd( true )
end

local msgCnt = 319 -- 엑셀 관련 컬럼 마지막 번호를 넣습니다.
local MessageData = {}

function GameTips_FrameSetData()
	for idx=1, msgCnt do
		MessageData[idx] = idx .. ". " .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMETIPS_MESSAGE" .. idx )
	end
end
GameTips_FrameSetData()

local gameTipsUIPool = {}

local gameTipsWindow = {
	Frame		= UI.getChildControl( Panel_Window_GameTips, "Frame_GameTips" ),
	FrameBG		= UI.getChildControl( Panel_Window_GameTips, "Static_GameTipsBG" ),
	closeX		= UI.getChildControl( Panel_Window_GameTips, "Button_Win_Close" ),
	helpBTN		= UI.getChildControl( Panel_Window_GameTips, "Button_Help" ),
	closeBTN	= UI.getChildControl( Panel_Window_GameTips, "Button_Close" ),
}
	gameTipsWindow.FrameContent		= UI.getChildControl( gameTipsWindow.Frame,			"Frame_1_Content" )
	gameTipsWindow.FrameScroll		= UI.getChildControl( gameTipsWindow.Frame,			"Frame_1_VerticalScroll" )
	gameTipsWindow.FrameScrollBTN	= UI.getChildControl( gameTipsWindow.FrameScroll,	"Frame_1_VerticalScroll_CtrlButton" )

local MSGTxt		= UI.getChildControl( Panel_Window_GameTips, "Template_StaticText_GameTipsMSG" )

function GameTipsInit()
	
	for index=1, #MessageData, 1 do
		local gameTipsMSGList = {}
		gameTipsMSGList.gameTipsList = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	gameTipsWindow.FrameContent, "gameTipsMSG_" .. index )
		CopyBaseProperty( MSGTxt, gameTipsMSGList.gameTipsList )
		gameTipsMSGList.gameTipsList:SetShow( true )
		gameTipsUIPool[index] = gameTipsMSGList
	end

	local frameContentSizeY = 0
	for tipsIdx = 1, #MessageData, 1 do
		gameTipsUIPool[tipsIdx].gameTipsList:SetAutoResize( true )
		gameTipsUIPool[tipsIdx].gameTipsList:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
		gameTipsUIPool[tipsIdx].gameTipsList:SetText( MessageData[tipsIdx] )
		gameTipsUIPool[tipsIdx].gameTipsList:SetSize( gameTipsUIPool[tipsIdx].gameTipsList:GetSizeX() + 5, 50 )
		gameTipsUIPool[tipsIdx].gameTipsList:SetPosY( frameContentSizeY )

		frameContentSizeY = frameContentSizeY + gameTipsUIPool[tipsIdx].gameTipsList:GetSizeY() + ( MSGTxt:GetSizeY() / 5)
	end

	gameTipsWindow.Frame:SetShow( true )
	gameTipsWindow.FrameContent:SetSize( gameTipsWindow.FrameBG:GetSizeX(), frameContentSizeY  )

	-- local frameContentSize	= gameTipsWindow.FrameBG:GetSizeY() + 1300
	-- local frameSize			= gameTipsWindow.Frame:GetSizeY()
	-- local scrollButtonSize	= frameContentSize / frameSize * 100

	-- gameTipsWindow.FrameScrollBTN:SetSize( gameTipsWindow.FrameScrollBTN:GetSizeX(), scrollButtonSize )
end

function FGlobal_GameTipsShow()
	Panel_Window_GameTips:SetShow( true, true )
	audioPostEvent_SystemUi(01,00)
	gameTipsWindow.Frame:UpdateContentPos()
	gameTipsWindow.Frame:SetContentSpanSize(0, 5)
end

function FGlobal_GameTipsHide()
	GameTipsHide()
end

function GameTipsHide()
	Panel_Window_GameTips:SetShow( false, true )
	gameTipsWindow.Frame:UpdateContentPos()
	gameTipsWindow.Frame:UpdateContentScroll()
	gameTipsWindow.FrameScroll:SetControlTop()
end



function gameTipsWindow:registEventHandler()
	self.closeBTN		:addInputEvent( "Mouse_LUp", "GameTipsHide()" )
	self.closeX			:addInputEvent( "Mouse_LUp", "GameTipsHide()" )
	self.helpBTN		:addInputEvent( "Mouse_LUp", "FGlobal_Panel_WebHelper_ShowToggle()")
end

GameTipsInit()
gameTipsWindow:registEventHandler()