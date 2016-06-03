Panel_Window_Servant:SetShow(false, false)
Panel_Window_Servant:ActiveMouseEventEffect(true)
Panel_Window_Servant:SetDragEnable(false)
Panel_Window_Servant:setGlassBackground(true)

Panel_Window_Servant:RegisterShowEventFunc( true,	'ServantShowAni()' )
Panel_Window_Servant:RegisterShowEventFunc( false,	'ServantHideAni()' )
Panel_Window_Servant:SetPosX( 10 )
Panel_Window_Servant:SetPosY( Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15 )

local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local UI_VT			= CppEnums.VehicleType
local isContentsEnable = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 41 ) -- 말경주 컨텐츠 옵션.
function	ServantShowAni()
	local	self	= servantIcon
	UIAni.fadeInSCR_Down(Panel_Window_Servant)
end

function	ServantHideAni()
	Panel_Window_Servant:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Servant:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local servantIcon	= {
	config	=
	{
		slotStartX			= 0,
		slotStartY			= 0,
		slotGapX			= 60,
		
		hpStartX			= 10,
		hpStartY			= 61,
		mpStartX			= 10,
		mpStartY			= 69,
		
		hpStartXBackground	= 8,
		hpStartYBackground	= 57,
		mpStartXBackground	= 8,
		mpStartYBackground	= 67,

		slotCount			= 3
	},
	const	=
	{
		LandVehicle	= 0,
		SeaVehicle	= 1,
		TamerSummon	= 2,
		Elephant	= 3,
	},
	_baseIcon					= UI.getChildControl( Panel_Window_Servant, "Static_Icon_Horse"		),
	-- _baseLevel					= UI.getChildControl( Panel_Window_Servant, 'StaticText_ServantLevel'	),
	_baseStaticHp				= UI.getChildControl( Panel_Window_Servant, 'Static_Bar_BG'		),
	_baseStaticMp				= UI.getChildControl( Panel_Window_Servant, 'Static_StaminaBG'		),
	_baseProgressHp				= UI.getChildControl( Panel_Window_Servant, 'Progress2_HP'		),
	_baseProgressMp				= UI.getChildControl( Panel_Window_Servant, 'Progress2_SP'		),
	_statictext_MoveText		= UI.getChildControl( Panel_Window_Servant, "StaticText_servantText"	),
	_statictext_Help			= UI.getChildControl( Panel_Window_Servant, "StaticText_Helper"	),
	-- _statictext_Life			= UI.getChildControl( Panel_Window_Servant, "StaticText_LifeValue"	),
	_txt_AttackAlert			= UI.getChildControl( Panel_Window_Servant, "StaticText_AttackAlert"	),

	_slots						= Array.new(),
	
	posX 						= Panel_Window_Servant:GetPosX(),
	posY 						= Panel_Window_Servant:GetPosY(),
	
	
	-- Taming
	_isTaming					= false,
	_tamingLastNotifyTime		= 0,
	_tamingCurrentTime			= 0,
	
	_hitEffect					= nil,
	_less10Effect				= nil,
	
	_servant_BeforHP			= 0,

	_servant_SummonCount		= 4,
}

local horseRace		= {
	_RaceInfo_btn_Info			= UI.getChildControl( Panel_Window_Servant, "Race_Button_RaceInfo"	),

	_RaceInfo_static_MainBG		= UI.getChildControl( Panel_Window_Servant, "Race_MainBG"			),
	_RaceInfo_txt_Title			= UI.getChildControl( Panel_Window_Servant, "StaticText_RaceTitle"	),
	_RaceInfo_static_BG			= UI.getChildControl( Panel_Window_Servant, "Race_BG"				),

	_RaceInfo_txt_PlayerIcon	= UI.getChildControl( Panel_Window_Servant, "Race_Player_Icon"		),
	_RaceInfo_txt_PlayerTitle	= UI.getChildControl( Panel_Window_Servant, "Race_Player_Text"		),
	_RaceInfo_txt_PlayerValue	= UI.getChildControl( Panel_Window_Servant, "Race_Player_Value"		),

	_RaceInfo_txt_RemainIcon	= UI.getChildControl( Panel_Window_Servant, "Race_Time_Icon"		),
	_RaceInfo_txt_RemainTitle	= UI.getChildControl( Panel_Window_Servant, "Race_RemainTime_Text"	),
	_RaceInfo_txt_RemainValue	= UI.getChildControl( Panel_Window_Servant, "Race_RemainTime_Value"	),

	_RaceInfo_txt_Tier			= UI.getChildControl( Panel_Window_Servant, "Race_RegTier_Text"		),
	_RaceInfo_txt_TierValue		= UI.getChildControl( Panel_Window_Servant, "Race_RegTier_Value"	),

	_RaceInfo_txt_Stat			= UI.getChildControl( Panel_Window_Servant, "Race_RegStatus_Text"	),
	_RaceInfo_btn_Join			= UI.getChildControl( Panel_Window_Servant, "Race_Button_JoinRace"	),
	_RaceInfo_btn_Cancel		= UI.getChildControl( Panel_Window_Servant, "Race_Button_CancelRace"),

	_RaceInfo_txt_Desc			= UI.getChildControl( Panel_Window_Servant, "StaticText_Desc"		),
}
local raceRaedy = false

function horseRace:Init()
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_Title			)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_static_BG			)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_PlayerIcon	)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_PlayerTitle	)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_PlayerValue	)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_RemainIcon	)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_RemainTitle	)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_RemainValue	)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_Tier			)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_TierValue		)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_Stat			)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_btn_Join			)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_btn_Cancel		)
	self._RaceInfo_static_MainBG	:AddChild( self._RaceInfo_txt_Desc			)

	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_Title		)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_static_BG		)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_PlayerIcon	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_PlayerTitle	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_PlayerValue	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_RemainIcon	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_RemainTitle	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_RemainValue	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_Tier			)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_TierValue	)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_Stat			)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_btn_Join			)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_btn_Cancel		)
	Panel_Window_Servant			:RemoveControl( self._RaceInfo_txt_Desc			)

	self._RaceInfo_static_BG		:SetSpanSize( 33, 50	)

	self._RaceInfo_txt_PlayerIcon	:SetSpanSize( 50, 55	)
	self._RaceInfo_txt_PlayerTitle	:SetSpanSize( 75, 55	)
	self._RaceInfo_txt_PlayerValue	:SetSpanSize( 155, 55	)
	self._RaceInfo_txt_RemainIcon	:SetSpanSize( 50, 75	)
	self._RaceInfo_txt_RemainTitle	:SetSpanSize( 75, 75	)
	self._RaceInfo_txt_RemainValue	:SetSpanSize( 155, 75	)
	self._RaceInfo_txt_Tier			:SetSpanSize( 75, 95 	)
	self._RaceInfo_txt_TierValue	:SetSpanSize( 155, 95 	)
	self._RaceInfo_txt_Stat			:SetSpanSize( 75, 115 	)
	self._RaceInfo_btn_Join			:SetSpanSize( 63, 170 	)
	self._RaceInfo_btn_Cancel		:SetSpanSize( 143, 170 	)
	self._RaceInfo_txt_Desc			:SetSpanSize( 60, 210 	)

	self._RaceInfo_btn_Info			:addInputEvent( "Mouse_LUp", "HandelClicked_RaceInfo_Toggle()" )
	self._RaceInfo_btn_Join			:addInputEvent( "Mouse_LUp", "HandelClicked_RaceInfo_Join()" )
	self._RaceInfo_btn_Cancel		:addInputEvent( "Mouse_LUp", "HandelClicked_RaceInfo_Cancel()" )
end

horseRace:Init()
horseRace._RaceInfo_static_MainBG	:SetShow( false )


function HandelClicked_RaceInfo_Toggle()
	local isRaceChannel = ToClient_IsHorseRaceChannel()
	if isRaceChannel then
		if horseRace._RaceInfo_static_MainBG:GetShow() then
			FGlobal_RaceInfo_Hide()
		else
			ToClient_RequestMatchInfo( CppEnums.MatchType.Race )	
		end
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_MAINCHANNEL_HORSERACE") ) -- "말 경주는 각 채널의 1채널에서만 진행 가능합니다." )
	end
end

function FGlobal_RaceInfo_Hide()
	horseRace._RaceInfo_static_MainBG:SetShow( false )
end

function HandelClicked_RaceInfo_Join()
	ToClient_RegisterRaceMatch()
	ToClient_RequestMatchInfo( CppEnums.MatchType.Race )
end

function HandelClicked_RaceInfo_Cancel()
	ToClient_UnRegisterRaceMatch()
	ToClient_RequestMatchInfo( CppEnums.MatchType.Race )
end

local matchStateMemo	= "-"
local matchStateTime	= "0"
local matchPlayer		= "0"
local matchTier			= "- "
function FGlobal_RaceInfo_Open( isRegister, registerCount, remainedMinute, matchState, param1 )
	horseRace._RaceInfo_static_MainBG:SetShow( true )
	local color = Defines.Color.C_FF888888
	-- _PA_LOG("정태곤", "isRegister : " .. tostring(isRegister) .. " / registerCount : " .. tostring(registerCount) .. " / remainedMinute : " .. tostring(remainedMinute) .. " / matchState : " .. tostring(matchState) .. " / param1 : " .. tostring(param1))
	-- matchState(준비중(0), 등록중(1), 이동준비중(2) 로딩중(3) 경기중(4)
	if 0 == matchState then
		matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_1") .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
		matchStateTime	= remainedMinute+1
		matchPlayer		= "- "
		matchTier		= "- "
	elseif 1 == matchState then
		matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_2") .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_POSSIBLE")
		matchStateTime = remainedMinute+1
		matchPlayer		= registerCount
		matchTier		= param1
	elseif 2 == matchState then
		matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_3") .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
		matchStateTime = remainedMinute+1
		matchPlayer		= "- "
		matchTier		= "- "
	elseif 3 == matchState then
		matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_4") .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
		matchStateTime = "0"
		matchPlayer		= "- "
		matchTier		= "- "
	elseif 4 == matchState then
		matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_5") .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
		matchStateTime = "0"
		matchPlayer		= "- "
		matchTier		= "- "
	end

	if isRegister then
		raceRaedy = true
		horseRace._RaceInfo_static_MainBG	:SetShow( true )
		horseRace._RaceInfo_txt_PlayerValue	:SetText( tostring(registerCount) .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_PEOPLE") ) -- "명"
		horseRace._RaceInfo_txt_RemainValue	:SetText( matchStateTime .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_MINUTE") ) -- "분"
		horseRace._RaceInfo_txt_TierValue	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_GENERATION", "param", param1 ) ) -- "<PAColor0xFF00C0D7>" .. param1 .. "세대<PAOldColor>" )
		horseRace._RaceInfo_txt_Stat		:SetText( matchStateMemo )
		horseRace._RaceInfo_txt_Stat		:SetSpanSize( 65, 120 )
		horseRace._RaceInfo_btn_Join		:SetShow( true )
		horseRace._RaceInfo_btn_Join		:SetMonoTone( false )
		horseRace._RaceInfo_btn_Join		:SetIgnore( false )
		horseRace._RaceInfo_btn_Join		:SetFontColor( Defines.Color.C_FFEFEFEF )
		horseRace._RaceInfo_btn_Cancel		:SetShow( true )
		horseRace._RaceInfo_btn_Cancel		:SetMonoTone( false )
		horseRace._RaceInfo_btn_Cancel		:SetIgnore( false )
		horseRace._RaceInfo_btn_Cancel		:SetFontColor( Defines.Color.C_FFEFEFEF )
	else
		raceRaedy = false
		horseRace._RaceInfo_static_MainBG	:SetShow( true )
		horseRace._RaceInfo_txt_PlayerValue	:SetText( matchPlayer .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_PEOPLE") )
		horseRace._RaceInfo_txt_RemainValue	:SetText( matchStateTime .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_MINUTE") )
		horseRace._RaceInfo_txt_TierValue	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_GENERATION", "param", param1 ) )
		horseRace._RaceInfo_txt_Stat		:SetSpanSize( 65, 120 )
		horseRace._RaceInfo_txt_Stat		:SetText( matchStateMemo )
		horseRace._RaceInfo_btn_Join		:SetShow( true )
		horseRace._RaceInfo_btn_Join		:SetMonoTone( true )
		horseRace._RaceInfo_btn_Join		:SetIgnore( true )
		horseRace._RaceInfo_btn_Join		:SetFontColor( color )
		horseRace._RaceInfo_btn_Cancel		:SetShow( true )
		horseRace._RaceInfo_btn_Cancel		:SetMonoTone( true )
		horseRace._RaceInfo_btn_Cancel		:SetIgnore( true )
		horseRace._RaceInfo_btn_Cancel		:SetFontColor( color )
	end
end

function FGlobal_RaceInfo_MessageManager( msgType )
	if 0 == msgType then		-- 매칭 등록 성공
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_HORSERACE_COMPLETE") ) -- "경주 출전 신청이 완료됐습니다." )
	elseif 1 == msgType then	-- 매칭 등록 취소
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_HORSERACE_CANCEL") ) -- "경주 출전 신청이 취소됐습니다." )
	end
end



local iconPosY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 20
function	servantIcon:init()
	Panel_Window_Servant:SetPosX( 10 )
	Panel_Window_Servant:SetPosY( iconPosY )

	UI.ASSERT( nil ~= self._baseIcon			and	'number' ~= type(self._baseIcon),			"Static_Icon_Horse"		)
	UI.ASSERT( nil ~= self._baseStaticHp		and	'number' ~= type(self._baseStaticHp),		"Static_Bar_BG"		)
	UI.ASSERT( nil ~= self._baseStaticMp		and	'number' ~= type(self._baseStaticMp),		"Static_StaminaBG"		)
	UI.ASSERT( nil ~= self._baseProgressHp		and	'number' ~= type(self._baseProgressHp),		"Progress2_HP"		)
	UI.ASSERT( nil ~= self._baseProgressMp		and	'number' ~= type(self._baseProgressMp),		"Progress2_SP"			)	
	
	for	ii=0, self.config.slotCount	do
		local	slot	= {}
		slot.icon			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		Panel_Window_Servant,	"ServantIcon_Icon_"				.. ii )
		slot.hpBackground	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		slot.icon,				"ServantIcon_HpBackground_"		.. ii )
		slot.mpBackground	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		slot.icon,				"ServantIcon_MpBackground_"		.. ii )
		slot.hp				= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2,	slot.icon,				"ServantIcon_Hp_"				.. ii )
		slot.mp				= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2,	slot.icon,				"ServantIcon_Mp_"				.. ii )	
		
		CopyBaseProperty( self._baseIcon,				slot.icon			)
		CopyBaseProperty( self._baseStaticHp,			slot.hpBackground	)
		CopyBaseProperty( self._baseStaticMp,			slot.mpBackground	)
		CopyBaseProperty( self._baseProgressHp,			slot.hp			 	)
		CopyBaseProperty( self._baseProgressMp,			slot.mp			 	)

		slot.icon:SetPosX( self.config.slotStartX + self.config.slotGapX * ii )
		slot.icon:SetPosY( self.config.slotStartY )
		slot.hp:SetPosX( self.config.hpStartX )
		slot.hp:SetPosY( self.config.hpStartY )
		slot.mp:SetPosX( self.config.mpStartX )
		slot.mp:SetPosY( self.config.mpStartY )
		slot.hpBackground:SetPosX( self.config.hpStartXBackground )
		slot.hpBackground:SetPosY( self.config.hpStartYBackground )
		slot.mpBackground:SetPosX( self.config.mpStartXBackground )
		slot.mpBackground:SetPosY( self.config.mpStartYBackground )
		
		slot.icon:ActiveMouseEventEffect(true)
		
		slot.icon:SetIgnore(false)
		slot.hp:SetIgnore(true)
		slot.mp:SetIgnore(true)
		
		slot.hp:SetShow(true)
		slot.mp:SetShow(true)
		slot.hpBackground:SetShow(true)
		slot.mpBackground:SetShow(true)
		slot.icon:SetShow(false)
		
		-- slot.icon:addInputEvent( 	"Mouse_On",		"Servant_CallHelp( " .. slot.icon:GetPosX() .. ", " .. slot.icon:GetPosY() .. ", " .. ii .. ")" )
		-- slot.icon:addInputEvent( 	"Mouse_Out",	"Servant_CallHelpout()" )
		slot.icon:addInputEvent(	"Mouse_On",		"Servant_SimpleTooltip( true, " .. ii .. " )")
		slot.icon:addInputEvent(	"Mouse_Out",	"Servant_SimpleTooltip( false )")
		slot.icon:addInputEvent( 	"Mouse_LUp",	"Servant_Call(" .. ii .. ")" )
		slot.icon:addInputEvent( 	"Mouse_RUp",	"Servant_Navi(" .. ii .. ")" )
		
		self._slots[ii]	= slot
	end

	-- Panel_Window_Servant:SetSize( 54, 54 )	
end

local servantIconCount = 0
function	servantIcon:update()
	if( isFlushedUI() ) then
    	return
    end

	local icon_PosX = 0
	self._slots[0].icon:SetShow(false)
	self._slots[1].icon:SetShow(false)
	self._slots[2].icon:SetShow(false)
	self._slots[3].icon:SetShow(false)
	horseRace._RaceInfo_btn_Info:SetShow( false )

	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	landVehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
	if	(nil~=landVehicleWrapper)	then
		self._slots[0].icon:ChangeTextureInfoName("New_UI_Common_forLua/Window/Horse/servant_icon_01.dds")
		-- Panel_Window_Servant:SetSize( self._slots[0].icon:GetSizeX() + 18, Panel_Window_Servant:GetSizeY())
		-- 말이면 아이콘을 바꾼다.
		if ( UI_VT.Type_Horse == landVehicleWrapper:getVehicleType() ) then
			local x1, y1, x2, y2 = 0, 0, 0, 0
			if doHaveContentsItem( 16, UI_VT.Type_Horse ) then
				-- 말피리가 있다면,
				x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 62, 62, 122, 122 )
				self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
			else
				-- 말피리가 없다면,
				x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 62, 1, 122, 61 )
				self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
			end
			if isContentsEnable then -- and (not ToClient_isSiegeChannel()) then -- 공성 채널인지 체크. 하지만 뺀다.
				horseRace._RaceInfo_btn_Info:SetShow( true ) -- 경주 정보 버튼을 말일 경우에만 보여준다.
			else
				horseRace._RaceInfo_btn_Info:SetShow( false )
			end
		elseif ( UI_VT.Type_Camel == landVehicleWrapper:getVehicleType() ) then
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 1, 62, 61, 122 )
			self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		elseif ( UI_VT.Type_Donkey == landVehicleWrapper:getVehicleType() ) then
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 123, 1, 183, 61 )
			self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		elseif ( UI_VT.Type_Elephant == landVehicleWrapper:getVehicleType() ) or ( UI_VT.Type_BabyElephant == landVehicleWrapper:getVehicleType() ) then
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 184, 1, 244, 61 )
			self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		elseif ( (UI_VT.Type_Carriage == landVehicleWrapper:getVehicleType())
			or (UI_VT.Type_CowCarriage == landVehicleWrapper:getVehicleType()) ) then
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 62, 123, 122, 183 )
			self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		else
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[0].icon, 1, 1, 43, 43 )
			self._slots[0].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		end

		self._slots[0].icon:setRenderTexture(self._slots[0].icon:getBaseTexture())
		self._slots[0].hp:SetProgressRate( landVehicleWrapper:getHp() / landVehicleWrapper:getMaxHp() * 100 )
		self._slots[0].mp:SetProgressRate( landVehicleWrapper:getMp() / landVehicleWrapper:getMaxMp() * 100 )
		self._slots[0].icon:SetShow(true)
		--Panel_Window_Servant:SetShow(true, true)

		-- 말이 맞으면 이팩트를 뿌려주자.(안전지역이 아닐때만 뿌려준다.)
		local servantInfo		= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		local regionInfo 		= getRegionInfoByPosition( servantInfo:getPosition() )
		if false == regionInfo:get():isSafeZone() then
			Servant_HP_Chk( landVehicleWrapper:getHp(), landVehicleWrapper:getMaxHp(), landVehicleWrapper:getVehicleType() )
		end

		-- if landVehicleWrapper:getHp() == 0 then
		-- 	Proc_ShowMessage_Ack( "탑승물이 치명상을 입었습니다." )
		-- 	Proc_ShowMessage_Ack( "해당 탑승물을 찾은 마구간에서 찾을 수 있습니다." )
		-- end

		self._slots[0].icon:SetPosX( icon_PosX )
		icon_PosX = icon_PosX + self._slots[0].icon:GetSizeX()

		local selfProxy			= getSelfPlayer():get()
		if nil == selfProxy then
			return
		end
		local	actorKeyRaw		= selfProxy:getRideVehicleActorKeyRaw()
		local	unsealCacheData	= getServantInfoFromActorKey( actorKeyRaw )
		if nil ~= unsealCacheData	then
			HorseHP_OpenByInteraction()
			HorseMP_OpenByInteraction()
		else
			Panel_HorseHp:SetShow( false )
			Panel_HorseMp:SetShow( false )
		end

	end

	local	seaVehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
	if	( nil ~= seaVehicleWrapper )	then
	-- 배일 경우 배 아이콘으로 바꿔준다
		
		self._slots[1].icon:ChangeTextureInfoName("New_UI_Common_forLua/Window/Horse/servant_icon_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( self._slots[1].icon, 123, 123, 183, 183 )
		self._slots[1].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._slots[1].icon:setRenderTexture(self._slots[1].icon:getBaseTexture())
		
		self._slots[1].hp:SetProgressRate( seaVehicleWrapper:getHp() / seaVehicleWrapper:getMaxHp() * 100 )
		self._slots[1].mp:SetProgressRate( seaVehicleWrapper:getMp() / seaVehicleWrapper:getMaxMp() * 100 )
		self._slots[1].mpBackground:SetShow(true)
		self._slots[1].mp:SetShow(true)
		self._slots[1].icon:SetShow(true)
		-- Panel_Window_Servant:SetShow(true, true)
		-- Panel_UIMain_CheckBtnVisibility()		-- 메인 컨트롤의 정보창 갱신을 위해

		self._slots[1].icon:SetPosX( icon_PosX )
		icon_PosX = icon_PosX + self._slots[1].icon:GetSizeX()

		local selfProxy			= getSelfPlayer():get()
		if nil == selfProxy then
			return
		end

		if selfProxy:doRideMyVehicle()	then
			HorseHP_OpenByInteraction()
			HorseMP_OpenByInteraction()
		else
			Panel_HorseHp:SetShow( false )
			Panel_HorseMp:SetShow( false )
		end
	end

	-- 테이머용도로 쓴다.
	local summonCount			= getSelfPlayer():getSummonListCount()
	local summonInfo	 		= nil
	local summonWrapper			= nil

	for summon_idx = 0, summonCount -1 do
		summonInfo	= getSelfPlayer():getSummonDataByIndex( summon_idx )
		
		if ((60028 <= summonInfo:getCharacterKey() ) and ( summonInfo:getCharacterKey() <= 60037)) or (60068 == summonInfo:getCharacterKey()) then	-- todo 이 방법은 별로!
			summonWrapper	= summonInfo:getActor()
			local hpRate = 0
			local mpRate = 0

			if nil == summonWrapper then
				hpRate	= 100
				mpRate	= 100
			else
				local hp		= summonWrapper:get():getHp()
				local maxHp		= summonWrapper:get():getMaxHp()
				hpRate	= hp / maxHp * 100

				local mp		= summonWrapper:get():getMp()
				local maxMp		= summonWrapper:get():getMaxMp()
				mpRate	= mp / maxMp * 100
			end

			self._slots[2].icon:ChangeTextureInfoName("New_UI_Common_forLua/Window/Horse/servant_icon_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[2].icon, 1, 1, 61, 61 )
			self._slots[2].icon:getBaseTexture():setUV( x1, y1, x2, y2 )
			self._slots[2].icon:setRenderTexture(self._slots[2].icon:getBaseTexture())
			
			self._slots[2].hpBackground:SetShow( true )
			self._slots[2].hp:SetShow( true )
			self._slots[2].hp:SetProgressRate( hpRate )

			self._slots[2].mpBackground:SetShow( true )
			self._slots[2].mp:SetShow( true )
			self._slots[2].mp:SetProgressRate( mpRate )

			self._slots[2].icon:SetShow(true)
			self._slots[2].icon:SetPosX( icon_PosX )

			icon_PosX = icon_PosX + self._slots[2].icon:GetSizeX()
			break
		end
	end

	-- 코끼리
	local elephantCount		= guildstable_getUnsealGuildServantCount() -- 소환된 코끼리 갯수
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
	for index=0, elephantCount-1 do
		local servantWrapper	= guildStable_getUnsealGuildServantAt( index )
		local vehicleType		= servantWrapper:getVehicleType()
		if (UI_VT.Type_Elephant == vehicleType) and ( isGuildMaster or isGuildSubMaster ) then
			self._slots[3].icon:ChangeTextureInfoName("New_UI_Common_forLua/Window/Horse/servant_icon_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[3].icon, 184, 1, 244, 61 )
			self._slots[3].icon:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self._slots[3].icon:setRenderTexture(self._slots[3].icon:getBaseTexture())
			
			self._slots[3].hp:SetShow( false )
			self._slots[3].mp:SetShow( false )
			self._slots[3].hpBackground:SetShow( false )
			self._slots[3].mpBackground:SetShow( false )
			self._slots[3].icon:SetShow(true)

			self._slots[3].icon:SetPosX( icon_PosX )
			icon_PosX = icon_PosX + self._slots[3].icon:GetSizeX()
			break
		end
	end

	-- 패널 사이즈
	if 0 == icon_PosX then
		icon_PosX = 60
	end

	-- 서번트 아이콘 개수
	servantIconCount = 0
	if self._slots[0].icon:GetShow() then	servantIconCount = servantIconCount + 1	end
	if self._slots[1].icon:GetShow() then	servantIconCount = servantIconCount + 1	end
	if self._slots[2].icon:GetShow() then	servantIconCount = servantIconCount + 1	end
	if self._slots[3].icon:GetShow() then	servantIconCount = servantIconCount + 1	end
	Panel_Window_Servant:SetSize( 60 *servantIconCount , Panel_Window_Servant:GetSizeY())

	if 0 < servantIconCount then
		Panel_Window_Servant:SetShow(true, true)
	else
		Panel_Window_Servant:SetShow(false, false)
	end
	-- servantIconCount = servantIcons
	if servantIconCount > 0 and Panel_MyHouseNavi:GetShow() then
		Panel_MyHouseNavi_PositionReset()
	end
	-- return_ServantIconNums( servantIcons )	-- Panel_MyHouseNavi.lua로 아이콘 갯수 넘겨줌
	FGlobal_Window_Servant_ColorBlindUpdate()
	FGlobal_PetListNew_NoPet()				-- 서번트 아이콘이 로드될 때 펫 아이콘도 돌려준다
end

function FGlobal_ServantIconCount()
	return servantIconCount
end

function	servantIcon:registMessageHandler()
	registerEvent("EventSelfServantUpdate",				"Panel_Window_Servant_Update")
	registerEvent("FromClient_SummonChanged",			"Panel_Window_Servant_Update")
	registerEvent("FromClient_SummonAddList",			"Panel_Window_Servant_Update")
	registerEvent("FromClient_SummonDelList",			"Panel_Window_Servant_Update")

	registerEvent("EventSelfServantClose",				"ServantIcon_Close")
	registerEvent("FromClient_ServantTaming",			"ServantIcon_TamingSuccess")
	registerEvent("onScreenResize",						"ServantIcon_Resize")
end

function	servantIcon:registEventHandler()
	Panel_Window_Servant:addInputEvent( "Mouse_On",			"Servant_ChangeTexture_On()" )
	Panel_Window_Servant:addInputEvent( "Mouse_Out",		"Servant_ChangeTexture_Off()" )
	Panel_Window_Servant:addInputEvent( "Mouse_PressMove",	"PanelWindowServant_RefreshPosition()" )
	Panel_Window_Servant:addInputEvent( "Mouse_LUp",		"ResetPos_WidgetButton()" )
end

function	ServantIcon_Resize()
	local	self	= servantIcon
	screenX = getScreenSizeX()
	screenY = getScreenSizeY()
	
	if not changePositionBySever(Panel_Window_Servant, CppEnums.PAGameUIType.PAGameUIPanel_ServantWindow, true, true, false) then
		Panel_Window_Servant:SetPosX( 10 )
		Panel_Window_Servant:SetPosY( Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15 )
	end

	-- Panel_MyHouseNavi_PositionReset()
end

----------------------------------------------------------------------------------------------------
-- Button Function
local isCheckLandNavi	= false
local isCheckSeaNavi	= false
local isCheckPetNavi	= false

function	Servant_Call( index )
	-- 위젯 모드일 때 해당 기능 막기
	if	Panel_UIControl:GetShow()	then
		return
	end
	
	if	(servantIcon.const.SeaVehicle == index)	then
		return
	end

	if servantIcon.const.TamerSummon == index then
		return
	end

	if servantIcon.const.Elephant == index then
		FGlobal_GuildServantList_Open()
		return
	end
	 
	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	servantInfo	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
	if	(nil == servantInfo)	then
		return
	end
	
	servant_callServant()
end

function	Servant_Navi( index )
	-- 위젯 모드일 때 해당 기능 막기
	if	Panel_UIControl:GetShow()	then
		return
	end

	if servantIcon.const.TamerSummon == index then
		return
	end
	 
	local	temporaryWrapper= getTemporaryInformationWrapper()
	ToClient_DeleteNaviGuideByGroup(0);
	
	if	(servantIcon.const.SeaVehicle== index) and (isCheckSeaNavi == false) then
		local	seaVehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
		if	(nil==seaVehicleWrapper)	then
			return
		end
		-- 여기에서 네비 포인트를 찍는다.
		local position = float3(seaVehicleWrapper:getPositionX(), seaVehicleWrapper:getPositionY(), seaVehicleWrapper:getPositionZ());
		
		-- 네비 고!
		worldmapNavigatorStart( position, NavigationGuideParam(), false, true, true)
		-- ♬ "서번트 아이콘을 마우스 오른쪽 버튼으로 누를 때 나는 소리~"
		audioPostEvent_SystemUi(00,14)

		isCheckSeaNavi = true
		isCheckLandNavi = false
		isCheckPetNavi = false
		
	elseif (servantIcon.const.LandVehicle== index) and (isCheckLandNavi == false) then
		local	servantInfo	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		if	(nil==servantInfo)	then
			return
		end
		
		-- 여기에서 네비 포인트를 찍는다.
		local position = float3(servantInfo:getPositionX(), servantInfo:getPositionY(), servantInfo:getPositionZ());
		
		-- 네비 고!
		worldmapNavigatorStart( position, NavigationGuideParam(), false, true, true)
		-- ♬ "서번트 아이콘을 마우스 오른쪽 버튼으로 누를 때 나는 소리~"
		audioPostEvent_SystemUi(00,14)
		
		isCheckLandNavi = true
		isCheckSeaNavi = false
		isCheckPetNavi = false

	elseif (servantIcon.const.Pet == index) and (isCheckPetNavi == false) then
		local	servantInfo	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Pet )
		if	(nil==servantInfo)	then
			return
		end
		
		-- 여기에서 네비 포인트를 찍는다.
		local position = float3(servantInfo:getPositionX(), servantInfo:getPositionY(), servantInfo:getPositionZ());
		
		-- 네비 고!
		worldmapNavigatorStart( position, NavigationGuideParam(), false, true, true)
		-- ♬ "서번트 아이콘을 마우스 오른쪽 버튼으로 누를 때 나는 소리~"
		audioPostEvent_SystemUi(00,14)
		
		isCheckLandNavi = false
		isCheckSeaNavi = false
		isCheckPetNavi = true
		
	elseif (servantIcon.const.SeaVehicle == index) and (isCheckSeaNavi == true) then
		ToClient_DeleteNaviGuideByGroup(0);
		isCheckSeaNavi = false
		isCheckLandNavi = false
		isCheckPetNavi = false
		
	elseif (servantIcon.const.LandVehicle == index) and (isCheckLandNavi == true) then
		ToClient_DeleteNaviGuideByGroup(0);
		isCheckLandNavi = false
		isCheckSeaNavi = false
		isCheckPetNavi = false
		
	elseif (servantIcon.const.Pet == index) and (isCheckPetNavi == true) then
		ToClient_DeleteNaviGuideByGroup(0);
		isCheckLandNavi = false
		isCheckSeaNavi = false
		isCheckPetNavi = false
	end
end

function	HandleClicked_Servant_VehicleInfoToggle( servantType )
	local temporaryWrapper= getTemporaryInformationWrapper()
	local vehicleWrapper	= temporaryWrapper:getUnsealVehicle( servantType )
	if	(nil == vehicleWrapper)	then
		return
	end

	local actorKeyRaw = vehicleWrapper:getActorKeyRaw()

	local nearVehicle	= getVehicleActor( actorKeyRaw )
	if	(nil == nearVehicle)	then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_ICON_TOOFAR") )	-- 대상이 너무 멀리 있습니다.
		return
	end

	local targetType = vehicleWrapper:getVehicleType()
	if UI_VT.Type_Horse == targetType or UI_VT.Type_Camel == targetType or UI_VT.Type_Donkey == targetType or UI_VT.Type_Elephant == targetType then
		ServantInfo_OpenByActorKeyRaw( actorKeyRaw )
	elseif UI_VT.Type_Carriage == targetType or UI_VT.Type_CowCarriage == targetType then
		CarriageInfo_OpenByActorKeyRaw( actorKeyRaw )
	elseif UI_VT.Type_Boat == targetType or UI_VT.Type_Raft == targetType or UI_VT.Type_FishingBoat == targetType or UI_VT.Type_SailingBoat == targetType then
		ShipInfo_OpenByActorKeyRaw( actorKeyRaw )
	else
		CarriageInfo_OpenByActorKeyRaw( actorKeyRaw )
	end
end

-- 위젯 이동 위치 값 저장
function PanelWindowServant_RefreshPosition()
	servantIcon.posX = Panel_Window_Servant:GetPosX()
	servantIcon.posY = Panel_Window_Servant:GetPosY()
end

function Panel_Window_Servant_ShowToggle()
	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	servantInfo			= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
	local	seaVehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
	
	if	(nil==servantInfo) and (nil==seaVehicleWrapper)	then
		return
	end

	if	Panel_Window_Servant:GetShow()	then
		Panel_Window_Servant:SetShow( false, false )
		-- Panel_WidgetControl_Toggle("Panel_Window_Servant", false)
	else
		Panel_Window_Servant:SetShow( true, true )
		-- Panel_WidgetControl_Toggle("Panel_Window_Servant", true)
	end
end

function	Panel_Window_Servant_Update()
	local	self	= servantIcon
	self:update()
end
UI.addRunPostRestorFunction( Panel_Window_Servant_Update )	-- 플러시를 나올 때, Show체크를 다시 해야 한다. 펄상점/뷰티샵에서 스케일 조정을 하기 때문.

function FGlobal_Window_Servant_Update()
	local	self	= servantIcon
	self:update()
end

function FGlobal_Window_Servant_ColorBlindUpdate()
	local self = servantIcon
	local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)

	for index=0, self._servant_SummonCount-1 do
		if (0 == isColorBlindMode) then
			-- HP
			self._slots[index].hp:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( self._slots[index].hp, 1, 49, 232, 54 )
			self._slots[index].hp:getBaseTexture():setUV( x1, y1, x2, y2 )
			self._slots[index].hp:setRenderTexture(self._slots[index].hp:getBaseTexture())

			-- MP
			self._slots[index].mp:SetColor( UI_color.C_FFFFCE22 )
		elseif (1 == isColorBlindMode) then
			-- HP
			self._slots[index].hp:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
			local xx1, yy1, xx2, yy2 = setTextureUV_Func( self._slots[index].hp, 1, 226, 256, 234 )
			self._slots[index].hp:getBaseTexture():setUV( xx1, yy1, xx2, yy2 )
			self._slots[index].hp:setRenderTexture(self._slots[index].hp:getBaseTexture())

			-- MP
			self._slots[index].mp:SetColor( UI_color.C_FFEE9900 )
		elseif(2 == isColorBlindMode) then
			-- HP
			self._slots[index].hp:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
			local xx1, yy1, xx2, yy2 = setTextureUV_Func( self._slots[index].hp, 1, 226, 256, 234 )
			self._slots[index].hp:getBaseTexture():setUV( xx1, yy1, xx2, yy2 )
			self._slots[index].hp:setRenderTexture(self._slots[index].hp:getBaseTexture())

			-- MP
			self._slots[index].mp:SetColor( UI_color.C_FFEE9900 )
		end
	end
end

-- 말을 마구간에서 바꾸면 HP를 리셋하자.
function	reset_ServantHP( BeforHP )
	local	self= servantIcon
	self._servant_BeforHP = BeforHP
end

function	Servant_HP_Chk( currentHp, currentMaxHp, vehicleType )
	local	self = servantIcon
	-- 전 보다 HP가 감소 했다면, 이팩트를 띄운다.
	
	local isNowEquipCheck = IsNowEquipCheck()	-- 탑승물 아이템 장착 해제 체크
	IsNowEquipCheck()
	local	currentHp	= currentHp
	local	remainHp	= (currentHp / currentMaxHp * 100)
	if	( (currentHp < servantIcon._servant_BeforHP) and (nil ~= servantIcon._servant_BeforHP) and isNowEquipCheck == false )	then
		-- ♬ "탑승물이 맞을 때 나는 소리"
		if	nil ~= self._hitEffect	then
			self._slots[0].icon:EraseEffect(self._hitEffect)
		end
		self._hitEffect = self._slots[0].icon:AddEffect( "fUI_Alarm_HorseAttack04", false, -0.1, -0.15 )

		-- 메시지를 보낸다.
		local sendMsg = {main = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SERVANT_ATTACK"), sub = "", addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( sendMsg, 2, 25 )
	end

	-- 값 설정.q
	servantIcon._servant_BeforHP = currentHp

	-- HP가 10% 미만이라면 이팩트를 띄운다.
	if	( nil ~= self._less10Effect)	then
		self._slots[0].icon:EraseEffect(self._less10Effect)
	end
	
	local	effectName
	if	(remainHp <= 10)	then
		-- 탑승물 종류에 따른 HP 10% 미만 이팩트 적용용 변수 
  		-- 탑승물 종류에 따라 이팩트를 바꾼다.
		if ( 0 == vehicleType ) then	-- 말이면.
			effectName = "fUI_Alarm_HorseAttack05"
		elseif ( 2 == vehicleType ) then	-- 낙타면.
			effectName = "fUI_Alarm_CamelAttack01"
		elseif ( 3 == vehicleType ) then	-- 당나귀면.
			effectName = "fUI_Alarm_DonkeyAttack01"
		elseif ( 4 == vehicleType ) then	-- 코끼리면.
			effectName = "fUI_Alarm_ElephantAttack01"
		elseif ( 9 == vehicleType ) then	-- 마차면.
			effectName = "fUI_Alarm_HorseAttack05"
		else	-- 이도저도 아니면
			effectName = "fUI_Alarm_HorseAttack05"
		end
		if	( nil ~= effectName )	then
			self._less10Effect = self._slots[0].icon:AddEffect( effectName, false, -0.1, -0.15 )
		end
	end
	
end

-- 0번 아이콘에 이펙트 적용/해제
function FGlobal_ServantIcon_IsNearMonster_Effect( _addEffect )
	if servantIcon._slots[0].icon:GetShow() then
		if true == _addEffect then
			servantIcon._slots[0].icon:EraseAllEffect()
			servantIcon._slots[0].icon:AddEffect( "fUI_Alarm_HorseAttack04", false, 0, 0 )
		else
			servantIcon._slots[0].icon:EraseAllEffect()
		end
	end
end

-- 말 아이콘 오버 시 안내 툴팁
function	Servant_CallHelp( posX, posY, slotNo )
	if 0 == slotNo then
		servantIcon._statictext_Help:SetShow(true)
		servantIcon._statictext_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
		servantIcon._statictext_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SERVANT_ICONHELP" ))
		-- 좌클릭 : 동물형 탑승물 호출\n우클릭 : 탑승물 위치 찾기
		servantIcon._statictext_Help:SetPosX( posX )
		servantIcon._statictext_Help:SetPosY( posY + 60 )
		
		if getEnableSimpleUI() then		
			Servant_UpdateSimpleUI(true);
		end
	end
end

function	Servant_CallHelpout()
	servantIcon._statictext_Help:SetShow(false)
	
	if getEnableSimpleUI() then
		Servant_UpdateSimpleUI(false);
	end
end

function Servant_SimpleTooltip( isShow, tipType )
	local temporaryWrapper	= getTemporaryInformationWrapper()
	if temporaryWrapper == nil then
		return TooltipSimple_Hide()
	end
	local vehicleWrapper	= temporaryWrapper:getUnsealVehicle( tipType )
	if vehicleWrapper == nil then
		return TooltipSimple_Hide()
	end


	local targetType = vehicleWrapper:getVehicleType()
	if UI_VT.Type_Horse == targetType or UI_VT.Type_Camel == targetType or UI_VT.Type_Donkey == targetType or UI_VT.Type_Elephant == targetType or UI_VT.Type_Carriage == targetType or UI_VT.Type_CowCarriage == targetType then
		ServantDesc = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SERVANT_ICONHELP" )
	else	-- 이도저도 아니면(배인경우.)
		ServantDesc = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SHIP_ICONHELP" )
	end

	if tipType == nil then
		return TooltipSimple_Hide()
	end

	name		= PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SERVANT") -- "탑승물"
	desc		= ServantDesc
	uiControl	= servantIcon._slots[tipType].icon


	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
		if getEnableSimpleUI() then		
			Servant_UpdateSimpleUI(true);
		end
	else
		TooltipSimple_Hide()
		if getEnableSimpleUI() then		
			Servant_UpdateSimpleUI(false);
		end
	end
end

local _servantSimpleUIAlpha = 0.7;
function Servant_UpdateSimpleUI( isOver )
	_servantSimpleUIAlpha = 0.7;
	if isOver then
		_servantSimpleUIAlpha = 1.0;
	end
end
function Servant_UpdateSimpleUI_Force_Out()
	Servant_UpdateSimpleUI(false);
end
function Servant_UpdateSimpleUI_Force_Over()
	Servant_UpdateSimpleUI(true);
	
	for	ii=0, servantIcon.config.slotCount	do
		if servantIcon._slots[ii].icon:GetShow() then
			 servantIcon._slots[ii].icon			: SetAlpha(1.0);
			 -- servantIcon._slots[ii].level		: SetAlpha(1.0);
			 servantIcon._slots[ii].hpBackground	: SetAlpha(1.0);
			 servantIcon._slots[ii].mpBackground	: SetAlpha(1.0);
			 servantIcon._slots[ii].hp				: SetAlpha(1.0);
			 servantIcon._slots[ii].mp				: SetAlpha(1.0);
		end
	end
end
registerEvent( "EventSimpleUIEnable",			"Servant_UpdateSimpleUI_Force_Out")
registerEvent( "EventSimpleUIDisable",			"Servant_UpdateSimpleUI_Force_Over")

function Servant_SimpleUIUpdatePerFrame( deltaTime )
	for	ii=0, servantIcon.config.slotCount	do
		if servantIcon._slots[ii].icon:GetShow() then
			UIAni.perFrameAlphaAnimation(_servantSimpleUIAlpha, 	 servantIcon._slots[ii].icon,			2.8 * deltaTime);
			-- UIAni.perFrameAlphaAnimation(_servantSimpleUIAlpha, 	 servantIcon._slots[ii].level,			2.8 * deltaTime);
			UIAni.perFrameAlphaAnimation(_servantSimpleUIAlpha, 	 servantIcon._slots[ii].hpBackground,	2.8 * deltaTime);
			UIAni.perFrameAlphaAnimation(_servantSimpleUIAlpha, 	 servantIcon._slots[ii].mpBackground,	2.8 * deltaTime);
			UIAni.perFrameAlphaAnimation(_servantSimpleUIAlpha, 	 servantIcon._slots[ii].hp,				2.8 * deltaTime);
			UIAni.perFrameAlphaAnimation(_servantSimpleUIAlpha, 	 servantIcon._slots[ii].mp,				2.8 * deltaTime);
		end
	end
end
registerEvent( "SimpleUI_UpdatePerFrame",		"Servant_SimpleUIUpdatePerFrame")

function	Servant_ChangeTexture_On()
	local	self	= servantIcon
	
	Panel_Window_Servant:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	self._statictext_MoveText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_ICON_UI_MOVE") )	--탑승물\n드래그해서 옮기세요.
end

function	Servant_ChangeTexture_Off()
	local	self	= servantIcon
	
	if Panel_UIControl:GetShow() then
		Panel_Window_Servant:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
		self._statictext_MoveText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_ICON_UI") )	--"탑승물"
	else
		Panel_Window_Servant:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end	
end

----------------------------------------------------------------------------------------------------
-- Taming
function	ServantIcon_TamingSuccess( isTaming )
	local	self	= servantIcon
	
	-- UI_Data\Script\Window\Stable\Panel_Window_StableRegister.lua의 StableRegister_Register() 할 때, _tamingSuccess를 0으로 초기화 시킨다.
	self._isTaming				= isTaming
	
	if	( isTaming )	then

		-- 여기에서 메인 UI에 프레임 체크를 위한 빈 판넬을 띄워준다.
		ServantIcon_TamingNotify()
		
		-- 프레임 단위 루프 체크용 판넬 띄운다.
		Panel_FrameLoop_Widget:SetShow(true)
	else		
		ServantIcon_TamingServant_Registed()
	end
	
end

function	ServantIcon_TamingNotify()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_TAMING_NOTIFY") )
end

function	ServantIcon_TamingServant_Registed()
	local	self	= servantIcon
	_isTaming	= false
	
	Panel_FrameLoop_Widget:SetShow( false )
end

-- 테이밍한 시간부터 한 번 나오고,  20초 쉰다. 반복.
--TamingServant_Time 콜은 아래에 붙어 있다.
function	TamingServant_Time( DeltaTime )
	local	self	= servantIcon
	
	if	( not self._tamingSuccess )	then
		return
	end
	
	self._tamingCurrentTime	= self._tamingCurrentTime + DeltaTime
	if	(self._tamingCurrentTime < (self._tamingLastNotifyTime + 20) )	then
		ServantIcon_TamingNotify()
		self._tamingLastNotifyTime	= currentTime
	end
end
----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	ServantIcon_Open()
	if( Defines.UIMode.eUIMode_NpcDialog == GetUIMode() )	then
		return
	end
	
	local	temporaryWrapper	= getTemporaryInformationWrapper()
	local	landVehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
	local	seaVehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
	local	petWrapper			= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Pet )

	--if	not Panel_Window_Servant:GetShow() and ( (nil ~= landVehicleWrapper) or (nil ~= seaVehicleWrapper) or (nil ~= petWrapper) ) 	then
	if	( (nil ~= landVehicleWrapper) or (nil ~= seaVehicleWrapper) or (nil ~= petWrapper) ) 	then
		Panel_Window_Servant:SetShow(true, true)
		servantIcon:update()
		FGlobal_ServantEnduaranceInfo_PerFrameUpdate()
	end	
end

function	ServantIcon_Close()
	-- if	Panel_Window_Servant:GetShow()	then
		-- Panel_Window_Servant:SetShow(false)
	-- end
	local	temporaryWrapper= getTemporaryInformationWrapper()
	
	local	isShow	= false
	if	(nil ~= temporaryWrapper)	then
		for	ii=0, servantIcon.config.slotCount	do
			local	servantInfo	= temporaryWrapper:getUnsealVehicle( ii )
			if	(nil == servantInfo)	then
				servantIcon._slots[ii].icon:SetShow(false)
			else
				isShow	= true
			end
		end
	end

	if	( not isShow )	then
		Panel_Window_Servant:SetShow(false, false)
	end
	-- Panel_UIMain_CheckBtnVisibility()			-- -- 메인 컨트롤의 정보창 갱신을 위해
	servantIcon:update()						-- 서번트가 죽어서 없어질 때 아이콘 개수 및 위치 초기화용
end


----------------------------------------------------------------------------------------------------
-- Init
servantIcon:init()
servantIcon:registEventHandler()
servantIcon:registMessageHandler()
FGlobal_Window_Servant_ColorBlindUpdate()
ServantIcon_Resize()

changePositionBySever(Panel_Window_Servant, CppEnums.PAGameUIType.PAGameUIPanel_ServantWindow, true, true, false)
FGlobal_PanelMove(Panel_Window_Servant, true)

-- Panel_FrameLoop_Widget이 떠 있으면, TamingServant_Time 를 매 초마다 실행한다.
Panel_FrameLoop_Widget:RegisterUpdateFunc("TamingServant_Time")
