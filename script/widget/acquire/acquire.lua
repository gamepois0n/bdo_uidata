local UI_VT				= CppEnums.VehicleType
---------------------------
-- Panel Init
---------------------------
Panel_Acquire:SetShow(false, false)				-- Default Show False!
Panel_Acquire:setGlassBackground(true)
Panel_Acquire:RegisterShowEventFunc( true, 'Acquire_ShowAni()' )

---------------------------
-- Local Variables
---------------------------

local TitleTable = {
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_1" ),--[['새로운 스킬을 배울 수 있습니다.',	]]	-- 1
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_2" ),--[['새로운 스킬을 배울 수 있습니다.',	]]	-- 2
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_3" ),--[['새로운 스킬을 배울 수 있습니다.',	]]	-- 3
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4" ),--[['새로운 스킬을 배웠습니다.',			]]	-- 4
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_5" ),--[['스킬을 배울 수 있게 되었습니다.',	]]	-- 5
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_6" ),--[['스킬의 진정한 능력을 깨우쳤습니다.',	]]	-- 6
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_7" ),--[['새로운 퀘스트를 시작합니다.',		]]	-- 7
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_8" ),--[['퀘스트 조건에 실패하였습니다.',		]]	-- 8
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_9" ),--[['퀘스트를 완료하였습니다.',			]]	-- 9
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_10"),--[['아이템을 획득하였습니다.',			]]	-- 10
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_11"),--[['새로운 지역을 발견하였습니다.',		]]	-- 11
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_12"),--[['업그레이드가 완료되었습니다.',		]]	-- 12
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_13"),--[['새로운 지식을 습득하였습니다.',		]]	-- 13
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_14"),--[['탑승물의 레벨이 상승하였습니다.',	]]	-- 14
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_15"),--[['공헌도를 획득하였습니다.',			]]	-- 15
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_16"),--[['조사를 완료했습니다.',			]]	-- 16
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_17"),--[['고블린과 계약했습니다.',				]]	-- 17	
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_18"),--[['요리를 수행했습니다.',				]]	-- 18
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_19"),--[['가공을 수행했습니다.',				]]	-- 19
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_20"),--[['길드스킬이 개방되었습니다.',			]]	-- 20
	'',																												-- 21
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_22"),--[['생산 레벨이 상승하였습니다.',		]]	-- 22
	'',	-- 23
	'',	-- 24
	'',	-- 25
	'',	-- 26
}
local objectMessage = {
	--'레벨 업',								-- 0
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_1" ),--[['생산 스킬포인트 획득',	]]-- 1
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_2" ),--[['전투 스킬포인트 획득',	]]-- 2
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_3" ),--[['길드 스킬포인트 획득',	]]-- 3
	'',																								  -- 4
	'',																								  -- 5
	'',																								  -- 6
	'',																								  -- 7
	'',																								  -- 8
	'',																								  -- 9
	'',																								  -- 10
	'',																								  -- 11
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_12"),--[['마을 발견',				]]-- 12
	'',																								  -- 13
	'',																								  -- 14
	'',																								  -- 15
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_16"),--[['Detedted',				]]-- 16
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_17"),--[['고블린과의 계약',		]]-- 17
	'',																								  -- 18
	'',																								  -- 19
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_20"),--[['길드스킬 획득',			]]-- 20
	'',																								  -- 21	
	'',																								  -- 22
	'',	-- 23
	'',	-- 24
	'',	-- 25
	''	-- 26
}


local productLevelUpObejctMessage = {
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_0"),--[['채집 레벨 상승',			]]-- 0
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_1"),--[['낚시 레벨 상승',			]]-- 1
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_2"),--[['수렵 레벨 상승',			]]-- 2
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_3"),--[['요리 레벨 상승',			]]-- 3
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_4"),--[['연금 레벨 상승',			]]-- 4
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_5"),--[['가공 레벨 상승',			]]-- 5
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_6"),--[['조련 레벨 상승',			]]-- 6
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_7"),--[['무역 레벨 상승',			]]-- 7
	PAGetString( Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_8"),-- 재배 레벨 상승
}


local Acquire_UI = {
	mainPanel			= Panel_Acquire,
	ArcText				= UI.getChildControl (Panel_Acquire, "ArchiveText"),
	titleText			= UI.getChildControl (Panel_Acquire, "TitleText"),
	iconBack			= UI.getChildControl (Panel_Acquire, "IconBack"),
	iconImage			= UI.getChildControl (Panel_Acquire, "IconSlot"),
	iconEtc				= UI.getChildControl (Panel_Acquire, "IconEtc"),
	iconGrade			= UI.getChildControl (Panel_Acquire, "IconGrade"),
	servantSkillIcon	= UI.getChildControl (Panel_Acquire, "Static_SkillIcon"),
	servantSkillName	= UI.getChildControl (Panel_Acquire, "StaticText_SkillName"),
	servantSkillgetHigh	= UI.getChildControl (Panel_Acquire, "StaticText_SkillGetHigh"),
}

local knowledge_Level = {
	UI.getChildControl (Panel_Acquire, "Static_Knowledge_Level1"),
	UI.getChildControl (Panel_Acquire, "Static_Knowledge_Level2"),
	UI.getChildControl (Panel_Acquire, "Static_Knowledge_Level3"),
	UI.getChildControl (Panel_Acquire, "Static_Knowledge_Level4"),
	UI.getChildControl (Panel_Acquire, "Static_Knowledge_Level5"),
}

local Acquire_ConstValue = {
	animationEndTime	= 3.5
}

--local itemGradeBorderTexture =
--{
--	[0] = "new_ui_common_forlua/default/UI_Window_Equipment_Icon_Normal.dds",
--	"UI_Win_Icon/UI_Window_Equipment_Icon_Magic.dds",
--	"UI_Win_Icon/UI_Window_Equipment_Icon_Lair.dds",
--	"UI_Win_Icon/UI_Window_Equipment_Icon_Unick.dds",
--	"UI_Win_Icon/UI_Window_Equipment_Icon_Epic.dds",
--}

local itemGradeBorderData = {
	[0] = { texture = "new_ui_common_forlua/default/default_etc_00.dds", x1=103, y1=176, x2=153, y2=226},
	[1] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=172, y1=44, x2=214, y2=86},
	[2] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=172, y1=1, x2=214, y2=43},
	[3] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=129, y1=1, x2=171, y2=43},
	[4] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=129, y1=44, x2=171, y2=86}
}

local Acquire_Enum = {
	LevelUp						= 0,	-- 레벨업
	GainProductSkillPoint		= 1,	-- 생산 기술 포인트 획득
	GainCombatSkillPoint		= 2,	-- 전투 기술 포인트 획득
	GainGuildSkillPoint			= 3,	-- 길드 기술 포인트 획득
	LearnSkill					= 4,	-- 기술 배움
	SkillLearnable				= 5,	-- 기술 배울 수 있음
	SkillAwakened				= 6,	-- 기술 각성
	QuestAccept					= 7,	-- 의뢰 수락?
	QuestFailed					= 8,	-- 의뢰 실패
	QuestComplete				= 9,	-- 의뢰 완료
	GetRareItem					= 10,	-- 레어 아이템 획득
	DiscoveryExplorationNode	= 11,	-- 거점 발견
	UpgradeExplorationNode		= 12,	-- 용도 변경
	LearnMentalCard				= 13,	-- 지식 얻음
	ServantLevelUp				= 14,	-- 말 레벨업
	GainExplorePoint			= 15,	-- 공헌도 획득
	Detected					= 16,	-- 찾음?
	AddNpcWorker				= 17,	-- 일꾼 고용
	GetAlchemy					= 18,	-- 연금 완료
	GetManufacture				= 19,	-- 가공 완료
	LearnGuildSkill				= 20,	-- 길드 기술 배움
	MentalThemeComplete         = 21,	-- 지식 카테고리 완료
	ProductLevelUp         		= 22,	-- 생산 레벨업
	GetFishEncyclopedia			= 23,	-- 의미있는 물고기 잡음
	UpdateFishLength			= 24,	-- 더 큰 물고기 잡음
	GetFish						= 25,	-- 물고기 잡음
	AcquiredTitle				= 26,	-- 타이틀 획득
	ServantLearnSkill			= 27,	-- 말 스킬 배움.
	ServantSkillMaster			= 28,	-- 말 스킬 마스터.
	
	Normal		= 0,
	Viliage		= 1,
	City		= 2,
	Gate		= 3,
	Farm		= 4,
	Filtration	= 5,
	Collect		= 6,
	Quarry		= 7,
	Logging		= 8,
	Deco_Tree	= 9,
}

local Acquire_Value = {
	elapsedTime			= Acquire_ConstValue.animationEndTime,
}

local isView = false
local preDefaultMsg = nil
local preArcObjectMsg = nil

---------------------------
-- Functions
---------------------------
local Acquire_Initialize = function()
	UI.ASSERT( nil ~= Acquire_UI.mainPanel	, "mainPanel	nil")
	UI.ASSERT( nil ~= Acquire_UI.ArcText	, "ArcText		nil")
	UI.ASSERT( nil ~= Acquire_UI.titleText	, "titleText	nil")
	UI.ASSERT( nil ~= Acquire_UI.iconBack	, "iconBack		nil")
	UI.ASSERT( nil ~= Acquire_UI.iconImage	, "iconImage	nil")
	UI.ASSERT( nil ~= Acquire_UI.iconEtc	, "iconEtc		nil")
	UI.ASSERT( nil ~= Acquire_UI.iconGrade	, "iconGrade	nil")

	Acquire_UI.iconImage:SetSize( 44, 44 )
	Acquire_UI.mainPanel:SetPosX( 0 )
	Acquire_UI.mainPanel:SetAlpha(1.0)
    while ( nil ~= Acquire_getNextData() ) do
        getAcquirePopFront()
    end
	Acquire_OnResize()
end

-- 보여지는 중에 매 Frame 호출. Alpha Ani Update
local Acquire_Animation = function()
	local alphaValue = 0.0
	local updateTime = Acquire_Value.elapsedTime						-- 3.5

	local hideToShowTime = 0.7	-- const
	local showTime = 3.0		-- const
	local showToHideTime = Acquire_ConstValue.animationEndTime			-- 3.5
	local ret = true

	if ( updateTime < hideToShowTime ) then
		alphaValue = updateTime / hideToShowTime
	elseif ( showToHideTime <= updateTime ) then
		alphaValue = 0
		Acquire_UI.mainPanel:SetShow( false, false )
		ret = false
	elseif ( showTime < updateTime ) then
		alphaValue = 1 - (updateTime - showTime) / ( showToHideTime - showTime)
	else
		alphaValue = 1.0
	end

	Acquire_UI.mainPanel			:SetAlphaChild(alphaValue)	-- SetAlphaChild 로 한방에 끝난다.
	Acquire_UI.ArcText				:SetFontAlpha(alphaValue)
	Acquire_UI.titleText			:SetFontAlpha(alphaValue)
	Acquire_UI.servantSkillgetHigh	:SetFontAlpha(alphaValue)
	
	return ret
end

-- 다음 유효한 알림 데이터를 가져온다!
function Acquire_getNextData()
	local notifyMsg = getAcquireFront()
	while nil ~= notifyMsg do
		if (Acquire_Enum.LevelUp == notifyMsg._msgType) or  (Acquire_Enum.QuestAccept == notifyMsg._msgType) or (Acquire_Enum.QuestFailed == notifyMsg._msgType) or (Acquire_Enum.QuestComplete == notifyMsg._msgType) then		-- 무시해야 하는 메시지
			getAcquirePopFront()
			notifyMsg = getAcquireFront()
		elseif ( Acquire_Enum.LearnSkill == notifyMsg._msgType ) or ( Acquire_Enum.SkillLearnable == notifyMsg._msgType ) then	-- 스킬은 로컬 세팅이 안되어 있으면 지운다.
			local skillSSW	= notifyMsg:getSkillStaticstatusWrapper()
			if ( nil ~= skillSSW ) then
				local skillTypeSSW	= skillSSW:getSkillTypeStaticStatusWrapper()
				local isEnable		= skillTypeSSW:isValidLocalizing()
				if not isEnable then
					getAcquirePopFront()
					notifyMsg = getAcquireFront()
				else	
					break;
				end
			else 	
				break;
			end
		else
			break
		end
	end
	return notifyMsg
end


-- 데이터를 세팅!
local wpChangedPoint = 0
local Acquire_SetData = function( notifyMsg )
	FGlobal_StealMSG( notifyMsg )
	local arcType		= notifyMsg._msgType
	local defaultMsg	= TitleTable[arcType]
	local arcIconPath	= ""
	local arcObjectMsg	= ""
	local arcItemGrade	= 100		-- enum 보다 충분히 큰 임의의 수

	Acquire_UI.servantSkillIcon:SetShow( false )
	Acquire_UI.servantSkillName:SetShow( false )
	Acquire_UI.servantSkillgetHigh:SetShow( false )
	knowledge_Level[1]:SetShow( false )
	knowledge_Level[2]:SetShow( false )
	knowledge_Level[3]:SetShow( false )
	knowledge_Level[4]:SetShow( false )
	knowledge_Level[5]:SetShow( false )

	AcquireMessageTutorial( notifyMsg )

	if ( Acquire_Enum.GainProductSkillPoint == arcType ) or ( Acquire_Enum.GainCombatSkillPoint == arcType ) or ( Acquire_Enum.GainGuildSkillPoint == arcType ) or ( Acquire_Enum.LearnGuildSkill == arcType ) then
		
		arcObjectMsg = objectMessage[arcType]
		
		-- 스킬을 배울 수 있는 상태인지 체크하고 다른 UI 이벤트를 호출한다.
		UI_MAIN_checkSkillLearnable()
		
	elseif ( Acquire_Enum.LearnSkill == arcType ) or ( Acquire_Enum.SkillLearnable == arcType ) then
		local skillSSW		= notifyMsg:getSkillStaticstatusWrapper()
		if ( nil ~= skillSSW ) then
			local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
			if ( nil ~= skillTypeSSW ) then
				arcIconPath = skillTypeSSW:getIconPath()
				arcObjectMsg = skillTypeSSW:getName()
			end
		end
		
		-- 스킬을 배울 수 있는 상태인지 체크하고 다른 UI 이벤트를 호출한다.
		UI_MAIN_checkSkillLearnable()	
	elseif ( Acquire_Enum.SkillAwakened == arcType ) then
		local skillTypeSSW	= notifyMsg:getSkillTypeStaticStatusWrapper()
		if ( nil ~= skillTypeSSW ) then
			arcIconPath = skillTypeSSW:getIconPath()
			arcObjectMsg = skillTypeSSW:getName()
		end
	elseif ( Acquire_Enum.QuestAccept == arcType ) or ( Acquire_Enum.QuestFailed == arcType ) or ( Acquire_Enum.QuestComplete == arcType ) then
		local questSSW = notifyMsg:getQuestStaticStatusWrapper()
		if ( nil ~= questSSW ) then
			arcObjectMsg = questSSW:getTitle()
		end
	elseif ( Acquire_Enum.GetRareItem == arcType ) then
		local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
		if ( nil ~= itemEnchantSSW ) then
			arcIconPath = itemEnchantSSW:getIconPath()
			-- UI.debugMessage(arcIconPath)
			arcObjectMsg = itemEnchantSSW:getName()
			arcItemGrade = itemEnchantSSW:getGradeType()
			
			local item_type = itemEnchantSSW:getItemType()
			local isTradeItem = itemEnchantSSW:isTradeAble()
			if 2 == item_type and isTradeItem then
				arcObjectMsg = string.gsub( arcObjectMsg, "★ ", "" )		-- 황실무역품 이름에 ★이 들어있으므로 해당 문자열을 빼준다! / 부적절한 문자열 때문
			end
		end
	elseif ( Acquire_Enum.DiscoveryExplorationNode == arcType )then
		local explorationSSW = notifyMsg:getExplorationStaticStatusWrapper()
		if ( nil ~= explorationSSW ) then
			if ( explorationSSW:get():getRegion():isMainTown() ) and ( ( Acquire_Enum.Viliage == explorationSSW:get()._nodeType ) or ( Acquire_Enum.City == explorationSSW:get()._nodeType ) ) then
				-- 그냥 return 해버리면 다음 acquire메세지를 로드하지도 않고 pop도 하지 않기때문에 메세지가 뜨지않는다.
				AcquireUpdate(Acquire_ConstValue.animationEndTime)
				return false
			else
				arcObjectMsg = explorationSSW:getName()
			end
		end
	elseif ( Acquire_Enum.UpgradeExplorationNode == arcType ) then
		local explorationSSW = notifyMsg:getExplorationStaticStatusWrapper()
		if ( nil ~= explorationSSW ) then
			if ( Acquire_Enum.Viliage == explorationSSW:get()._nodeType ) or ( Acquire_Enum.City == explorationSSW:get()._nodeType ) then
				defaultMsg = objectMessage[arcType]
				arcObjectMsg = explorationSSW:getName()
			else
				arcObjectMsg = explorationSSW:getName()
			end
		end
	elseif ( Acquire_Enum.LearnMentalCard == arcType ) then
		local mentalCardSSW = notifyMsg:getMentalCardStaticStatusWrapper()
		if ( nil ~= mentalCardSSW ) then
			arcObjectMsg = mentalCardSSW:getName()
			if 10000 <= mentalCardSSW:getMainThemeKeyRaw() and mentalCardSSW:getMainThemeKeyRaw() <= 10399 then
				defaultMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_MONSTER_KNOWLEDGE")
			end
			arcIconPath = mentalCardSSW:getImagePath()

			local mentalLevel	= notifyMsg:getMentalCardLevel()
			if 0 < mentalLevel then
				knowledge_Level[mentalLevel]:SetShow( true )
			end
			
			UIMain_KnowledgeUpdate()
		end
	elseif ( Acquire_Enum.ServantLevelUp == arcType ) then
		-- local temporaryWrapper		= getTemporaryInformationWrapper()
		-- local servantWrapper		= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		
		local servantNo				= notifyMsg._Param2
		local servantWrapper		= stable_getServantByServantNo( servantNo )
		
		if nil == servantWrapper then
			return
		end
		
		local vehicleType			= servantWrapper:getVehicleType()
		if UI_VT.Type_Horse == vehicleType then
			Acquire_UI.servantSkillgetHigh:SetShow( true )
			Acquire_UI.servantSkillgetHigh:SetText( PAGetString(Defines.StringSheet_GAME, "ACQUIRE_SERVANTSKILLGETHIGH") ) -- 탑승물의 레벨이 증가하여 기술 습득 확률이 증가합니다.
		else
			Acquire_UI.servantSkillgetHigh:SetShow( false )
		end
		arcObjectMsg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_SERVANT_LVUP", "name", servantWrapper:getName(), "lv", servantWrapper:getLevel() )

	elseif ( Acquire_Enum.GainExplorePoint == arcType ) then
		arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_CONTRIBUTIVENESS")
	elseif ( Acquire_Enum.Detected == arcType ) then
		arcObjectMsg = PAGetString( Defines.StringSheet_GAME, "ACQUIRE_GETLETTER" )
		local npcCharacterKey = notifyMsg:getCharacterKey()
	elseif ( Acquire_Enum.AddNpcWorker == arcType ) then
		local characterSSW = notifyMsg:getCharacterStaticStatus()
		if ( characterSSW ~= nil ) then
			arcObjectMsg = characterSSW:getName()
		end

		local regionInfo = notifyMsg:getRegionInfo()
		if ( regionInfo ~= nil ) then
			arcObjectMsg = arcObjectMsg .."(".. regionInfo:getAreaName() .. ")"
		end
	elseif ( Acquire_Enum.GetAlchemy == arcType ) then
		local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
		local alchemyItemKey = itemEnchantSSW:get()._key:get()
		if ( nil ~= itemEnchantSSW ) then
			arcIconPath = itemEnchantSSW:getIconPath()
			arcObjectMsg = itemEnchantSSW:getName()
			arcItemGrade = itemEnchantSSW:getGradeType()
			if alchemyItemKey == 9707 or alchemyItemKey == 9708 then -- 연금 부산물, 요리 부산물을 획득하면 해당 아이템 획득 Acquire메시지를 띄워주지 않는다.
				return
			end
		end
	elseif ( Acquire_Enum.GetManufacture == arcType ) then
		local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
		if ( nil ~= itemEnchantSSW ) then
			arcIconPath = itemEnchantSSW:getIconPath()
			arcObjectMsg = itemEnchantSSW:getName()
			arcItemGrade = itemEnchantSSW:getGradeType()
		end
    elseif ( Acquire_Enum.MentalThemeComplete == arcType ) then
        local mentalThemeSSW = notifyMsg:getMentalThemeStaticStatus()
		local currentMaxWp = getSelfPlayer():getMaxWp()
        if ( nil ~= mentalThemeSSW ) then
   			arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_MENTALTHEMECOMPLETE_BODY", "wp", notifyMsg:getVariedWp() )
			defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_MENTALTHEMECOMPLETE_HEAD", "theme", mentalThemeSSW:getName() )
        end
	elseif ( Acquire_Enum.ProductLevelUp == arcType ) then
		local arcParam		= Int64toInt32(notifyMsg._Param) + 1
        arcObjectMsg = productLevelUpObejctMessage[arcParam]
	elseif ( Acquire_Enum.GetFishEncyclopedia == arcType) then	
		local fishEncyclopedia = notifyMsg:getEncyclopedia()
		if (nil ~= fishEncyclopedia) then
			local fishName = fishEncyclopedia:getName()
			local fishLength = fishEncyclopedia:getValue()
			arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_1" ) .. " : " .. fishName .. "(" .. fishLength .. ")"
			defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_2", "fishName", fishName )
			arcIconPath = ""
		end	
	elseif ( Acquire_Enum.UpdateFishLength == arcType ) then
		local fishEncyclopedia = notifyMsg:getEncyclopedia()
		if ( nil ~= fishEncyclopedia ) then
			local fishName = fishEncyclopedia:getName()
			local fishLength = fishEncyclopedia:getValue()
			arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_3" ) .. " : " .. fishName .. "(" .. fishLength .. ")"
			defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_4", "fishName", fishName )
			arcIconPath = ""
		end
	elseif ( Acquire_Enum.GetFish == arcType) then	
		local fishEncyclopedia = notifyMsg:getEncyclopedia()
		if (nil ~= fishEncyclopedia) then
			local fishName = fishEncyclopedia:getName()
			local fishLength = fishEncyclopedia:getValue()
			arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_5" )
			defaultMsg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_6", "fishName", fishName, "fishLen", fishLength )
			arcIconPath = ""
		end
	elseif ( Acquire_Enum.AcquiredTitle == arcType) then	
		arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_TITLE_1", "titleName", notifyMsg:getAcquiredTitle():getName() )
		defaultMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_TITLE_2" )
		arcIconPath = ""
	elseif ( Acquire_Enum.ServantLearnSkill == arcType ) then
		--local	temporaryWrapper		= getTemporaryInformationWrapper()
		--local	servantWrapper			= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		local	skillKey				= Int64toInt32(notifyMsg._Param)
		local	skillName				= vehicleSkillStaticStatus_getName( skillKey )
		--local	skillWrapper			= servantWrapper:getSkill( skillKey )
		if nil ~= skillKey then
			Acquire_UI.servantSkillIcon:SetShow( true )
			Acquire_UI.servantSkillName:SetShow( true )
			Acquire_UI.servantSkillIcon:ChangeTextureInfoName( "Icon/" .. vehicleSkillStaticStatus_getIconPath( skillKey ) )
			Acquire_UI.servantSkillName:SetText( skillName )
			Acquire_UI.servantSkillIcon:SetText( PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4") ) -- 새로운 스킬을 배웠습니다.
		end
		arcObjectMsg= PAGetStringParam1( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_26", "skillName", skillName )
		defaultMsg	= PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4")
	elseif ( Acquire_Enum.ServantSkillMaster == arcType ) then
		--local	temporaryWrapper		= getTemporaryInformationWrapper()
		--local	servantWrapper			= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		local	skillKey				= Int64toInt32(notifyMsg._Param)
		local	skillName				= vehicleSkillStaticStatus_getName( skillKey )
		--local	skillWrapper			= servantWrapper:getSkill( skillKey )
		if nil ~= skillWrapper then
			Acquire_UI.servantSkillIcon:SetShow( true )
			Acquire_UI.servantSkillName:SetShow( true )
			Acquire_UI.servantSkillIcon:ChangeTextureInfoName( "Icon/" .. vehicleSkillStaticStatus_getIconPath( skillKey ) )
			Acquire_UI.servantSkillName:SetText( skillName )
			-- Acquire_UI.servantSkillIcon:SetText( PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_23") ) -- 마지막 스킬을 배웠습니다.
			Acquire_UI.servantSkillIcon:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_24", "skillName", skillName ) ) -- skillName .. "기술을 완벽하게 숙련하였습니다.
		end
		-- arcObjectMsg= PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_23")
		-- defaultMsg	= PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_23" )
		arcObjectMsg= PAGetStringParam1( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_24", "skillName", skillName )
		defaultMsg	= PAGetStringParam1( Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_24", "skillName", skillName )
	end

	Acquire_UI.titleText:SetText ( defaultMsg )
	Acquire_UI.ArcText:SetText ( tostring(arcObjectMsg) )

	if ( Acquire_Enum.LearnMentalCard == arcType ) then
		local mentalCardSSW = notifyMsg:getMentalCardStaticStatusWrapper()
		if ( nil ~= mentalCardSSW ) then
			local mentalLevel	= notifyMsg:getMentalCardLevel()
			if 0 < mentalLevel then
				local spanSizeX = ( Acquire_UI.ArcText:GetTextSizeX() / 2 ) + knowledge_Level[mentalLevel]:GetSizeX()	-- Acquire_UI.ArcText:GetSpanSize().x + 
				local spanSizeY	= Acquire_UI.ArcText:GetSpanSize().y
				knowledge_Level[mentalLevel]:SetSpanSize( spanSizeX, spanSizeY )
			end
		end
	end

	if ( "" ~= arcIconPath ) and ( Acquire_Enum.LearnMentalCard == arcType ) then
		Acquire_UI.iconEtc:SetShow(false)
		Acquire_UI.iconBack:SetShow(false)
		Acquire_UI.iconImage:SetShow(true)
		Acquire_UI.iconImage:SetSize(100,100)
		Acquire_UI.iconImage:SetVerticalTop()
		Acquire_UI.iconImage:SetHorizonCenter()
		Acquire_UI.iconImage:SetSpanSize(0,-65)
		-- Acquire_UI.iconGrade:SetSize(100,100)
		-- Acquire_UI.iconGrade:SetVerticalTop()
		-- Acquire_UI.iconGrade:SetHorizonCenter()
		-- Acquire_UI.iconGrade:SetSpanSize(0,-65)
		Acquire_UI.iconGrade:SetShow(false)
		Acquire_UI.iconImage:ChangeTextureInfoName( arcIconPath )
	-- elseif ( "" ~= arcIconPath ) and ( Acquire_Enum.GainExplorePoint == arcType ) then
		-- Acquire_UI.iconEtc:SetShow(false)
		-- Acquire_UI.iconBack:SetShow(false)
		-- Acquire_UI.iconImage:SetShow(true)
		-- Acquire_UI.iconImage:SetSize(80,80)
		-- Acquire_UI.iconImage:SetVerticalTop()
		-- Acquire_UI.iconImage:SetHorizonCenter()
		-- Acquire_UI.iconImage:SetSpanSize(0,-55)
		-- Acquire_UI.iconGrade:SetShow(false)
		--if selfPlayerCurrentTerritory() == "세렌디아령" then
		-- Acquire_UI.iconImage:ChangeTextureInfoName("Icon/"..arcIconPath)
		--elseif selfPlayerCurrentTerritory() == "발레노스령" then
		--end
		
	elseif ( "" ~= arcIconPath ) then
		Acquire_UI.iconEtc:SetShow(false)
		Acquire_UI.iconBack:SetShow(true)
		Acquire_UI.iconImage:SetShow(true)
		Acquire_UI.iconGrade:SetShow(true)
		Acquire_UI.iconImage:SetSize(42,42)
		Acquire_UI.iconImage:SetVerticalTop()
		Acquire_UI.iconImage:SetHorizonCenter()
		Acquire_UI.iconImage:SetSpanSize(0,-17)
		Acquire_UI.iconImage:ChangeTextureInfoName( "icon/" .. arcIconPath )
		if 0 <= arcItemGrade and arcItemGrade <= 4 then
			Acquire_UI.iconGrade:ChangeTextureInfoName ( itemGradeBorderData[arcItemGrade].texture )
			local x1, y1, x2, y2 = setTextureUV_Func( Acquire_UI.iconGrade, itemGradeBorderData[arcItemGrade].x1, itemGradeBorderData[arcItemGrade].y1, itemGradeBorderData[arcItemGrade].x2, itemGradeBorderData[arcItemGrade].y2 )
			Acquire_UI.iconGrade:getBaseTexture():setUV(  x1, y1, x2, y2  )
			Acquire_UI.iconGrade:setRenderTexture(Acquire_UI.iconGrade:getBaseTexture())
		else
			Acquire_UI.iconGrade:ReleaseTexture()
			Acquire_UI.iconGrade:ChangeTextureInfoName("")
		end
	else
		Acquire_UI.mainPanel:SetShow ( false, false )
		Acquire_UI.iconEtc:SetShow(true)
		Acquire_UI.iconBack:SetShow(false)
		Acquire_UI.iconImage:SetShow(false)
		Acquire_UI.iconGrade:SetShow(false)
	end

	local aniIsPlaying = Acquire_Animation()
	if not aniIsPlaying then
		Acquire_UI.mainPanel:SetShow( true, true )
		Acquire_Value.elapsedTime = 0.0
	end
	
	if (preDefaultMsg ~= defaultMsg) or (preArcObjectMsg ~= arcObjectMsg) then
		chatting_sendMessage( "", defaultMsg , CppEnums.ChatType.System )
		if (nil ~= arcObjectMsg) and ("" ~= arcObjectMsg) then
			chatting_sendMessage( "", "[ "..tostring(arcObjectMsg).." ]" , CppEnums.ChatType.System )
		end
	end	
	
	preDefaultMsg = defaultMsg
	preArcObjectMsg = arcObjectMsg
	
	return true
end


function Acquire_ShowAni()
	-- 임시
end


function Acquire_ProcessMessage()
	if not Panel_Acquire:GetShow() then
		-- 그 다음 유효한 메시지를 가져온다
		local notifyMsg = Acquire_getNextData()
		
		if Panel_RewardSelect_NakMessage:GetShow() then
			Panel_RewardSelect_NakMessage:SetShow( false )
		end
		-- 그 다음 메시지가 있는 경우.
		-- 메시지가 유효한 메시지 이면, panel 을 다시 Show 해주고 데이터를 세팅해준다!
		if nil ~= notifyMsg then
			Acquire_SetData(notifyMsg)
			local arcType		= notifyMsg._msgType
			if arcType == Acquire_Enum.GainExplorePoint then
				audioPostEvent_SystemUi(03,17)
			else
				notifyMsg:playingAudio()
			end
		end

		if nil == notifyMsg and 0~= FGlobal_NakMessagePanel_CheckLeftMessageCount() then
			Panel_RewardSelect_NakMessage:SetShow(true, false)
		end
	end
	
	enableSkill_UpdateData()
end

_tutorialQuestNo = 0;
function getTutorialQuestNo()
	return _tutorialQuestNo;
end
function setTutorialQuestNo(questNo)
	_tutorialQuestNo = questNo
end

function AcquireMessageTutorial( notifyMsg )
	if notifyMsg._msgType == Acquire_Enum.QuestAccept then 
		local questSSW = notifyMsg:getQuestStaticStatusWrapper();

		local questNum = nil
		if questSSW:getQuestGroup() == 9005 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 90051
		elseif questSSW:getQuestGroup() == 101 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1011
		elseif questSSW:getQuestGroup() == 102 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1021
		elseif questSSW:getQuestGroup() == 103 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1031
		elseif questSSW:getQuestGroup() == 103 and  questSSW:getQuestGroupInNo() == 2 then
			questNum = 1032
		elseif questSSW:getQuestGroup() == 103 and  questSSW:getQuestGroupInNo() == 3 then
			questNum = 1033
		elseif questSSW:getQuestGroup() == 103 and  questSSW:getQuestGroupInNo() == 4 then
			questNum = 1034
		elseif questSSW:getQuestGroup() == 104 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1041
		elseif questSSW:getQuestGroup() == 105 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1051
		elseif questSSW:getQuestGroup() == 114 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1141
		elseif questSSW:getQuestGroup() == 115 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1151
		elseif questSSW:getQuestGroup() == 116 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1161
		elseif questSSW:getQuestGroup() == 117 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1171
		elseif questSSW:getQuestGroup() == 9006 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 90061
		elseif questSSW:getQuestGroup() == 152 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1521			
		end
		if ( nil ~= questNum ) then
			if(  -1 == _tutorialQuestNo ) then
				Tutorial_Quest(questNum)
				setTutorialQuestNo(0)
			else
				setTutorialQuestNo(questNum)
			end
		end
	end

	if notifyMsg._msgType == Acquire_Enum.QuestComplete then 
		local questSSW = notifyMsg:getQuestStaticStatusWrapper()
		local questNum = nil
		
		if questSSW:getQuestGroup() == 152 and  questSSW:getQuestGroupInNo() == 1 then
			questNum = 1521
		end
		
		if ( nil ~= questNum ) then
			if(  -1 == _tutorialQuestNo ) then
				Tutorial_Quest(questNum)
				setTutorialQuestNo(0)
			else
				setTutorialQuestNo(questNum)

			end
		end
	end
end

function AcquireUpdate(updateTime)
	-- Ani Update!
	Acquire_Value.elapsedTime = Acquire_Value.elapsedTime + updateTime;
	local aniIsPlaying = Acquire_Animation()
	if not aniIsPlaying then
		getAcquirePopFront()	-- 표시하던 메시지를 제거
		-- Ani 가 끝나면!
		-- 그 다음 유효한 메시지를 가져온다
		local notifyMsg = Acquire_getNextData()
		
		-- 그 다음 메시지가 있는 경우.
		-- 메시지가 유효한 메시지 이면, panel 을 다시 Show 해주고 데이터를 세팅해준다!
		if nil ~= notifyMsg then
			Acquire_SetData(notifyMsg)
			notifyMsg:playingAudio()
		end
		
		if nil == notifyMsg and 0~= FGlobal_NakMessagePanel_CheckLeftMessageCount() then
			Panel_RewardSelect_NakMessage:SetShow(true, false)
		end
	end
end

function Acquire_OnResize()
	Acquire_UI.mainPanel:SetSize( getScreenSizeX(), 100 )

	for _, control in pairs(Acquire_UI) do
		control:ComputePos()
	end

	for _, control in pairs(knowledge_Level) do
		control:ComputePos()
	end
	
end

function FGlobal_afterRestore()
	Panel_Acquire:SetShow(( Acquire_Value.elapsedTime < Acquire_ConstValue.animationEndTime ),false)
end

UI.addRunPostFlushFunction(FGlobal_afterRestore)
UI.addRunPostRestorFunction(FGlobal_afterRestore)

Acquire_Initialize()
Panel_Acquire:RegisterUpdateFunc("AcquireUpdate")
registerEvent("SelfPlayer_AcquireMessage", "Acquire_ProcessMessage")
registerEvent("onScreenResize", "Acquire_OnResize")

