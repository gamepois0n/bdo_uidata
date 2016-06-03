local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color

local posIndex = 0							-- 위치 인덱스


local _maxNoticeCount = 3;
local noticePanelList = {}
local noticeAlertList = {}

local createNoticeMsg = function()
	local _text_Msg = UI.getChildControl( Panel_NoticeAlert, "StaticText_NoticeAlert_Text" )
	_text_Msg:SetShow ( false )
	local _bg_Msg = UI.getChildControl( Panel_NoticeAlert, "Static_NoticeAlertBG" )
	_bg_Msg:SetShow ( false )

	local getScrX = getScreenSizeX()
	
	
	for index = 1, _maxNoticeCount, 1 do
		local noticePanel = UI.createPanel("Panel_NoticeAlert"..index, Defines.UIGroup.PAGameUIGroup_GameSystemMenu)
		noticePanel:SetSize( Panel_NoticeAlert:GetSizeX(), Panel_NoticeAlert:GetSizeY());
		noticePanel:SetIgnore(true);
		noticePanel:SetShow(false, false);
		noticePanel:ChangeTextureInfoName("")
		
		local bgMsg = UI.createControl( UCT.PA_UI_CONTROL_STATIC, noticePanel, "NoticeAlertBG_"..index )
		CopyBaseProperty( _bg_Msg, bgMsg );
		bgMsg:SetShow(true)
		
		local textMsg = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, noticePanel, "NoticeAlert_Text_"..index )
		CopyBaseProperty( _text_Msg, textMsg );
		textMsg:SetShow(true)
		
		noticePanelList[index] = noticePanel
		
		local noticeAlert = {}
		noticeAlertList[index] = noticeAlert
		noticeAlert.textMsg = textMsg;
		noticeAlert.bgMsg = bgMsg;
		
	end	
end

createNoticeMsg()

-- 애니메이션
local MessageOpen = function(panel)
	-- ♬ 시스템 메시지가 나올 때 사운드 추가
	audioPostEvent_SystemUi(04,04)
	
	panel:SetShow(true, false)	
	panel:ResetVertexAni()
	panel:SetScaleChild( 1, 1 )

	-- 켜기
	local aniInfo = panel:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = panel:addScaleAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartScale(0.85)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.IsChangeChild = true

	-- 남아있고
	local aniInfo2 = panel:addScaleAnimation( 0.25, 7.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = panel:addColorAnimation( 7.0, 8.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true
	
	local aniInfo4 = panel:addScaleAnimation( 8.0, 8.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(0)
	aniInfo4.IsChangeChild = true
end

local updatePosition = function()
	local centerPos = (getScreenSizeX() / 2) - (Panel_NoticeAlert:GetSizeX() / 2)

	--한칸씩 위로 올림.
	for index = 1, _maxNoticeCount, 1 do
		local realIndex = ( index - posIndex + 5 ) % _maxNoticeCount + 1

		local panel = noticePanelList[index]
		if (panel:IsShow()) then
			panel:SetPosX( centerPos )	
			panel:SetPosY( (Panel_NoticeAlert:GetSizeY() * realIndex) + 5 )	
		end
	end
end

function Proc_NoticeAlert_Ack(message, noticeType, noticeValue)
	-- 고래 메시지 전용
	if ( CppEnums.EChatNoticeType.HuntingStart == noticeType ) or ( CppEnums.EChatNoticeType.HuntingEnd == noticeType ) then
		if nil ~= message then 
			WhaleHuntingEvent( message, noticeType, noticeValue )
		end
		return
	end
	
	-- 크자카/누베르 메시지 전용
	if ( CppEnums.EChatNoticeType.Kzarka == noticeType ) or ( CppEnums.EChatNoticeType.Nuberu == noticeType ) then
		if nil ~= message then 
			FGlobal_WorldBossShow( message, noticeType, noticeValue )
		end
		return
	end
	
	posIndex = (posIndex % _maxNoticeCount ) + 1
	noticeAlertList[posIndex].textMsg:SetFontColor(Chatting_MessageColor(CppEnums.ChatType.Notice, noticeType))
	noticeAlertList[posIndex].textMsg:SetText ( message )

	MessageOpen(noticePanelList[posIndex])
	updatePosition()
end

function NoticeAlert_Resize()
	updatePosition()
end

--[[ *************************** 메시지 처리 *************************** --]]
registerEvent("EventNotifyAlertMessage",	"Proc_NoticeAlert_Ack")
registerEvent("onScreenResize",				"NoticeAlert_Resize")