Panel_Mail_Main:ActiveMouseEventEffect( true )
Panel_Mail_Main:setGlassBackground( true )
Panel_Mail_Main:RegisterShowEventFunc( true, 'Mail_ShowAni()' )
Panel_Mail_Main:RegisterShowEventFunc( false, 'Mail_HideAni()' )

-- Panel_Mail_Main:SetShow( true )		--삭제해야함 테스트용

local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local IM 			= CppEnums.EProcessorInputMode

function Mail_ShowAni()
	UIAni.fadeInSCR_Left( Panel_Mail_Main )
	
	local aniInfo1 = Panel_Mail_Main:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Mail_Main:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Mail_Main:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Mail_Main:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Mail_Main:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Mail_Main:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Mail_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Mail_Main, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

-----------------------------------------------------------------------------------
------------------------------------- 초기화 --------------------------------------
-----------------------------------------------------------------------------------

local	defalut_Control	= {
	_mail = 
	{
		_buttonClose	= UI.getChildControl(Panel_Mail_Main, "Button_Win_Close"),
		_buttonQuestion = UI.getChildControl( Panel_Mail_Main, "Button_Question" ),	
		_BG				= UI.getChildControl(Panel_Mail_Main, "Static_MailList_BG"),
		_NoMail			= UI.getChildControl(Panel_Mail_Main, "StaticText_NoMail"),
		
		_page_Count		= UI.getChildControl(Panel_Mail_Main, "StaticText_PageCount"),
		_Btn_pre_page	= UI.getChildControl(Panel_Mail_Main, "Button_Pre_Page"),
		_Btn_Nxt_page	= UI.getChildControl(Panel_Mail_Main, "Button_Next_Page"),

		_Btn_QnA		= UI.getChildControl(Panel_Mail_Main, "Button_QNA"),
		_Btn_SelectAll	= UI.getChildControl(Panel_Mail_Main, "Button_SelectAll"),
		_Btn_SelectDel	= UI.getChildControl(Panel_Mail_Main, "Button_SelectDelete"),
		
		_List_BG		= {},
		_checkBtn		= {},
		_Sender_Name	= {},
		_Mail_Title		= {},
		_Mail_Num		= {},
		_mailNo			= {},
		_mail_GetItem	= {},
		_mail_GetDate	= {},

		isSelectAll 	= false,
			
		_Template =	
		{	
			_List_BG		= UI.getChildControl(Panel_Mail_Main, "RadioButton_MailList"),
			_checkBtn		= UI.getChildControl(Panel_Mail_Main, "CheckButton_Mail"),
			_Sender_Name	= UI.getChildControl(Panel_Mail_Main, "StaticText_Sender"),
			_Mail_Title		= UI.getChildControl(Panel_Mail_Main, "StaticText_Mail_Title"),
			_Mail_Num		= UI.getChildControl(Panel_Mail_Main, "StaticText_Mail_Num"),
			_mail_GetItem	= UI.getChildControl(Panel_Mail_Main, "Static_GetItem"),
			
			_rowMax = 8,
			_row_PosY_Gap = 2,
		},	
	},
}

local _btn_Mail = UI.getChildControl(Panel_UIMain, "Button_Mail")

function defalut_Control:Init_Control()
	self._mail._Template._Sender_Name	:SetTextMode( UI_TM.eTextMode_LimitText )
	self._mail._Template._Mail_Title	:SetTextMode( UI_TM.eTextMode_LimitText )
	self._mail._Template._Mail_Num		:SetTextMode( UI_TM.eTextMode_LimitText )
	
	FGlobal_Set_Table_Control(self._mail, "_List_BG", 		"_List_BG", true, false)
	FGlobal_Set_Table_Control(self._mail, "_checkBtn", 		"_List_BG", true, false)
	FGlobal_Set_Table_Control(self._mail, "_Sender_Name", 	"_List_BG", true, false)
	FGlobal_Set_Table_Control(self._mail, "_Mail_Title", 	"_List_BG", true, false)
	FGlobal_Set_Table_Control(self._mail, "_Mail_Num",  	"_List_BG", true, false)
	FGlobal_Set_Table_Control(self._mail, "_mail_GetItem", 	"_List_BG", true, false)

	local isCommercial = FGlobal_IsCommercialService()
	self._mail._Btn_QnA:SetShow( isCommercial )
end
defalut_Control:Init_Control()

function defalut_Control:Init_Function()
	self._mail._buttonQuestion	:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Panelmail\" )" )				-- 물음표 좌클릭
	self._mail._buttonQuestion	:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"Panelmail\", \"true\")" )		-- 물음표 마우스오버
	self._mail._buttonQuestion	:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"Panelmail\", \"false\")" )		-- 물음표 마우스아웃
	
	self._mail._buttonClose		:addInputEvent( "Mouse_LUp",	"Mail_Close()");
	
	self._mail._Btn_pre_page	:addInputEvent( "Mouse_LUp",	"MailList_Change_Page(false)")
	self._mail._Btn_Nxt_page	:addInputEvent( "Mouse_LUp",	"MailList_Change_Page(true)")

	self._mail._Btn_QnA			:addInputEvent( "Mouse_LUp",	"FGlobal_QnAWebLink_Open()")

	self._mail._Btn_SelectAll	:addInputEvent( "Mouse_LUp",	"MailList_SelectAll()")
	self._mail._Btn_SelectDel	:addInputEvent( "Mouse_LUp",	"MailList_SelectDelete()")

	self._mail._BG				:addInputEvent( "Mouse_DownScroll",	"MailList_Change_Page(true)" )
	self._mail._BG				:addInputEvent( "Mouse_UpScroll",	"MailList_Change_Page(false)" )
	
	for key, value in pairs (self._mail._List_BG) do
		value:addInputEvent( "Mouse_LUp",			"Mail_GetDetail(" .. tostring(key) .. ")" )
		value:addInputEvent( "Mouse_DownScroll",	"MailList_Change_Page(true)" )
		value:addInputEvent( "Mouse_UpScroll",		"MailList_Change_Page(false)" )
	end
end
defalut_Control:Init_Function()

-----------------------------------------------------------------------------------
------------------------------------ Data 처리 ------------------------------------
-----------------------------------------------------------------------------------

local _mail_Data 	= 
{
	_Page_Total 	= 0,
	_Page_Current 	= 0,
	_Selected		= {},
	_Data			= {},
}

function _mail_Data:setData()
	local mailCount	= RequestMail_mailCount()
	local SlotMax 	= defalut_Control._mail._Template._rowMax
	self._Data = {}
	local pageNo = 0
	for index = 1 , mailCount do
		if (index - 1) % SlotMax == 0 then
			pageNo = pageNo + 1
		end
		if self._Data[pageNo] == nil then
			self._Data[pageNo] = {}
		end
		local mail_Info 	= RequestMail_getMailAt(index - 1)
		-- defalut_Control._mail._mailNo[index] = mail_Info:getMailNo()

		local sender_Name 				= mail_Info:getSender()
		local mail_Title				= mail_Info:getTitle()
		local mail_No					= mail_Info:getMailNo()
		local mail_isExistItem			= mail_Info:isExistItem()			-- 첨부 아이템 획득 여부.
		local mail_getMailReceiveDate	= mail_Info:getMailReceiveDate()	-- 메일 받은 시간.
		local idx = ( index - 1 ) % SlotMax  + 1
		self._Data[pageNo][idx] = 
		{
			_indx 			= index - 1,
			_sender_Name 	= sender_Name,
			_mail_Title 	= mail_Title,
			_mail_No		= mail_No,
			_mail_GetItem	= mail_isExistItem,
			_mail_GetDate	= mail_getMailReceiveDate,
		}
	end
	self._Page_Total = pageNo
end	

function _mail_Data:clear()
	local SlotMax 		= defalut_Control._mail._Template._rowMax
	for index = 1, SlotMax	do
		defalut_Control._mail._List_BG[index]		:SetShow(false)
		defalut_Control._mail._checkBtn[index]		:SetShow(false)
		defalut_Control._mail._Sender_Name[index]	:SetShow(false)
		defalut_Control._mail._Mail_Title[index]	:SetShow(false)
		defalut_Control._mail._Mail_Num[index]		:SetShow(false)
		defalut_Control._mail._mail_GetItem[index]	:SetShow(false)
	end

	defalut_Control._mail._page_Count	:SetText("-- / --")
	defalut_Control._mail._Btn_pre_page	:SetShow(false)
	defalut_Control._mail._Btn_Nxt_page	:SetShow(false)
	defalut_Control._mail._NoMail		:SetShow(true)
end

function _mail_Data:Update_MailPage()
	local pageNo 		= self._Page_Current
	local pageNo_Total 	= self._Page_Total
	
	if pageNo_Total < pageNo then
		self._Page_Current 	= self._Page_Total
		pageNo				= self._Page_Current
	end
	
	local SlotMax 		= defalut_Control._mail._Template._rowMax

	for	index = 1, SlotMax	do
		defalut_Control._mail._checkBtn[index]:SetCheck( false )
	end

	_mail_Data:clear()
	for	index = 1, SlotMax	do
		if nil ~= self._Data[pageNo] then	
			if nil ~= self._Data[pageNo][index] then
				local _sender_Name 	= self._Data[pageNo][index]._sender_Name
				local _mail_Title 	= self._Data[pageNo][index]._mail_Title
				local _indx 		= self._Data[pageNo][index]._indx
				local _getItem 		= self._Data[pageNo][index]._mail_GetItem
				local _getDate 		= self._Data[pageNo][index]._mail_GetDate
				local _mail_num		= "No."..tostring(_indx + 1)
				defalut_Control._mail._Sender_Name[index]   :SetText(_sender_Name .. "(" .. _getDate .. ")")
				defalut_Control._mail._Mail_Title[index]   	:SetText(_mail_Title)
				defalut_Control._mail._Mail_Num[index]   	:SetText(_mail_num)
		
		
				if self._Selected._indx == _indx and self._Selected._sender_Name == _sender_Name and self._Selected._mail_Title == _mail_Title then
					defalut_Control._mail._List_BG[index]	:SetCheck(true)
				else
					defalut_Control._mail._List_BG[index]	:SetCheck(false)
				end		
				
				defalut_Control._mail._List_BG[index]		:SetShow(true)
				defalut_Control._mail._checkBtn[index]		:SetShow(true)
				defalut_Control._mail._Sender_Name[index]	:SetShow(true)
				defalut_Control._mail._Mail_Title[index]	:SetShow(true)
				defalut_Control._mail._Mail_Num[index]		:SetShow(true)
				defalut_Control._mail._mail_GetItem[index]	:SetShow(true)
				defalut_Control._mail._mail_GetItem[index]	:ChangeTextureInfoName("New_UI_Common_forLua/Window/Dye/Dye_New_01.dds")
				if true == _getItem then
					-- defalut_Control._mail._mail_GetItem[index]		:SetShow(true)
					local x1, y1, x2, y2 = setTextureUV_Func( defalut_Control._mail._mail_GetItem[index], 1, 433, 22, 455 )
					defalut_Control._mail._mail_GetItem[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					defalut_Control._mail._mail_GetItem[index]:setRenderTexture(defalut_Control._mail._mail_GetItem[index]:getBaseTexture())
				else
					local x1, y1, x2, y2 = setTextureUV_Func( defalut_Control._mail._mail_GetItem[index], 1, 457, 22, 479 )
					defalut_Control._mail._mail_GetItem[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					defalut_Control._mail._mail_GetItem[index]:setRenderTexture(defalut_Control._mail._mail_GetItem[index]:getBaseTexture())
				end
			end
		else
			defalut_Control._mail._List_BG[index]		:SetShow(false)
			defalut_Control._mail._checkBtn[index]		:SetShow(false)
			defalut_Control._mail._Sender_Name[index]	:SetShow(false)
			defalut_Control._mail._Mail_Title[index]	:SetShow(false)
			defalut_Control._mail._Mail_Num[index]		:SetShow(false)
			defalut_Control._mail._mail_GetItem[index]	:SetShow(false)
		end
	end
	
	if pageNo_Total == 1 or pageNo_Total < 1 then
		defalut_Control._mail._Btn_pre_page:SetShow(false)
		defalut_Control._mail._Btn_Nxt_page:SetShow(false)
	elseif pageNo == 1 then
		defalut_Control._mail._Btn_pre_page:SetShow(false)
		defalut_Control._mail._Btn_Nxt_page:SetShow(true)
	elseif pageNo == pageNo_Total then
		defalut_Control._mail._Btn_pre_page:SetShow(true)
		defalut_Control._mail._Btn_Nxt_page:SetShow(false)
	else
		defalut_Control._mail._Btn_pre_page:SetShow(true)
		defalut_Control._mail._Btn_Nxt_page:SetShow(true)
	end

	if pageNo_Total > 0 then
		local pageCount = tostring(pageNo) .. "/" .. tostring(pageNo_Total)
		defalut_Control._mail._page_Count	:SetText(pageCount)	
		defalut_Control._mail._NoMail		:SetShow(false)
	end
	
end

-----------------------------------------------------------------------------------
-------------------------------- Btn 관련 함수 ------------------------------------
-----------------------------------------------------------------------------------

function Mail_GetDetail(index)
	local pageNo = _mail_Data._Page_Current
	local SlotMax = defalut_Control._mail._Template._rowMax
	if pageNo < 1 then
		return
	end
		
	local realIndex = _mail_Data._Data[pageNo][index]._indx
	_mail_Data._Selected = 
	{
		_indx 			= _mail_Data._Data[pageNo][index]._indx,
		_sender_Name 	= _mail_Data._Data[pageNo][index]._sender_Name,
		_mail_Title 	= _mail_Data._Data[pageNo][index]._mail_Title,
	}

	RequestMail_getMailDetail(realIndex)
end

function MailList_Change_Page(isNext)
	local pageNo_Current	= _mail_Data._Page_Current
	local pageNo_Total 		= _mail_Data._Page_Total
	if true == isNext then
		if (pageNo_Current + 1) > pageNo_Total then
			return
		else
			_mail_Data._Page_Current = pageNo_Current + 1
		end
	elseif false == isNext then
		if (pageNo_Current - 1) < 1 then
			return
		else
			_mail_Data._Page_Current = pageNo_Current - 1
		end
	end
	
	defalut_Control._mail.isSelectAll = false
	
	_mail_Data:Update_MailPage()
end


function MailList_SelectAll()
	local self			= _mail_Data
	local SlotMax 		= defalut_Control._mail._Template._rowMax
	local stat_checkBtn = defalut_Control._mail.isSelectAll

	for	index = 1, SlotMax	do
		if defalut_Control._mail._checkBtn[index]:GetShow() then
			defalut_Control._mail._checkBtn[index]  	:SetCheck( not stat_checkBtn )
		end
	end

	defalut_Control._mail.isSelectAll = not stat_checkBtn
end

function MailList_SelectDelete()
	local self			= _mail_Data
	local pageNo 		= self._Page_Current
	local SlotMax 		= defalut_Control._mail._Template._rowMax
	local lastMailIndex = 0
	for	index = 1, SlotMax	do
		if defalut_Control._mail._checkBtn[index]:IsCheck() then
			lastMailIndex = index
		end
	end

	for	index = 1, SlotMax	do
		if defalut_Control._mail._checkBtn[index]:GetShow() and defalut_Control._mail._checkBtn[index]:IsCheck() then
			local mailNo = self._Data[pageNo][index]._mail_No
			RequestMail_removeMail( mailNo, index == lastMailIndex )
		end
	end
	
	defalut_Control._mail.isSelectAll = false
end

-----------------------------------------------------------------------------------
--------------------------------- 창 열기/닫기 ------------------------------------
-----------------------------------------------------------------------------------

function Mail_Open()
	if	not Panel_Mail_Main:IsShow()	then
		Panel_Mail_Main:SetShow(true, true)
	--	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	end
	
	if Panel_NewMail_Alarm:IsShow() then
		Panel_NewMail_Alarm:SetShow( false )
	end
	
	_mail_Data._Page_Current 	= 1
	_mail_Data._Page_Total 		= 0
	_mail_Data._Selected 		= {}
	
	_mail_Data:clear()
	RequestMail_requestMailList()
	RequestMail_setNewMailFlag( false )
end

function Mail_Close()
	if	Panel_Mail_Main:IsShow()	then
		Panel_Mail_Main:SetShow(false, true)
	--	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		Mail_Detail_Close()
	end
	
	HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
end

-----------------------------------------------------------------------------------
--------------------------------- NewMail_Alarm -----------------------------------
-----------------------------------------------------------------------------------
local newMailAlarm_icon = UI.getChildControl(Panel_NewMail_Alarm, "Static_MailIcon")
local newMailAlarm_call	= UI.getChildControl(Panel_NewMail_Alarm, "StaticText_CallingYou")
local newMailEffectIcon = UI.getChildControl(Panel_UIMain, "Button_Mail")
newMailAlarm_call:SetShow( false, false )
newMailEffectIcon:EraseAllEffect()
Panel_NewMail_Alarm:SetShow( false )
-- newMailAlarm_icon:SetEnableArea( 0, 0, newMailAlarm_icon:GetSizeX() + newMailAlarm_call:GetSizeX(), newMailAlarm_icon:GetSizeY() )
newMailAlarm_icon:addInputEvent( "Mouse_LUp", "Mail_Open()" )

function init_newMailAlarm()
	local bNewFlag = RequestMail_getNewMailFlag()
	-- if bNewFlag and not Panel_NewMail_Alarm:IsShow() then
		-- newMailAlarm_icon:EraseAllEffect()
		-- newMailAlarm_icon:AddEffect("fUI_Letter_01A", true, 0, 0)
		Panel_NewMail_Alarm:SetShow( false )
	-- end

	if bNewFlag then
		newMailEffectIcon:EraseAllEffect()
		newMailEffectIcon:AddEffect("fUI_Letter_01A", true, 0, 2.1)
	end
end

-----------------------------------------------------------------------------------
------------------------------- 이벤트 관련 함수 ----------------------------------
-----------------------------------------------------------------------------------

function Mail_UpdateList( isCheck )
	newMailEffectIcon:EraseAllEffect()	-- 메일을 읽었을 때 이펙트를 지워준다.

	_mail_Data:setData()
	_mail_Data:Update_MailPage()
end

function FromClient_NewMail()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "FROMCLIENT_NEWMAIL") )
	-- if false == Panel_NewMail_Alarm:IsShow() and false == Panel_Mail_Main:IsShow() then
	-- 	Panel_NewMail_Alarm:SetShow( true )

		newMailEffectIcon:EraseAllEffect()
		newMailEffectIcon:AddEffect("fUI_Letter_01A", true, 0, 2.1)
	-- end

	-- if Panel_NewMail_Alarm:IsShow() then
	-- 	newMailAlarm_icon:EraseAllEffect()
	-- 	newMailAlarm_icon:AddEffect("fUI_Letter_01A", true, 0, 0)
	-- end
end

function Mail_onScreenResize()
	Panel_Mail_Main:SetPosX( getScreenSizeX() -  Panel_Mail_Main:GetSizeX() )
	Panel_Mail_Main:SetPosY( (getScreenSizeY()/2) -  (Panel_Mail_Main:GetSizeY()/2) )
end

init_newMailAlarm()
registerEvent("ResponseMail_showList",	"Mail_UpdateList")
registerEvent("FromClient_NewMail",		"FromClient_NewMail")
registerEvent("onScreenResize", 		"Mail_onScreenResize" )