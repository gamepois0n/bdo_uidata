Panel_Window_PetInfoNew:SetShow( false )

local PetInfo = {
	BTN_Close	= UI.getChildControl( Panel_Window_PetInfoNew, "Button_Win_Close" ),

	petInfoBg		= UI.getChildControl( Panel_Window_PetInfoNew, "Static_BG" ),
	iconPet			= UI.getChildControl( Panel_Window_PetInfoNew, "Static_IconPet" ),
	petName			= UI.getChildControl( Panel_Window_PetInfoNew, "StaticText_PetName" ),
	progress_EXP	= UI.getChildControl( Panel_Window_PetInfoNew, "Static_Progress_EXP" ),
	level_Value		= UI.getChildControl( Panel_Window_PetInfoNew, "StaticText_Level_Value" ),
	progress_Hungry	= UI.getChildControl( Panel_Window_PetInfoNew, "Static_Progress_Hungry" ),
	icon_Lovely		= UI.getChildControl( Panel_Window_PetInfoNew, "Static_LovelyIcon" ),
	bg_Lovely		= UI.getChildControl( Panel_Window_PetInfoNew, "Static_Progress_Lovely_BG" ),
	progress_Lovely	= UI.getChildControl( Panel_Window_PetInfoNew, "Static_Progress_Lovely" ),
	action			= {
		[0] = UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_1" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_2" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_3" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_4" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_5" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_6" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_7" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_8" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_9" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_Specificity_10" ),
	},
	actionSlot		= {
		[0] = UI.getChildControl( Panel_Window_PetInfoNew, "Static_1" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_2" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_3" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_4" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_5" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_6" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_7" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_8" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_9" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_10" ),
	},
	skillBg = UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillBg" ),
	skillSlotBg		= {
		[0] = UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillBg_1" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillBg_2" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillBg_3" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillBg_4" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillBg_5" ),
	},
	skillSlot		= {
		[0] = UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillSlot_1" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillSlot_2" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillSlot_3" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillSlot_4" ),
		UI.getChildControl( Panel_Window_PetInfoNew, "Static_SkillSlot_5" ),
	},
	
	baseSkill_1	= UI.getChildControl( Panel_Window_PetInfoNew, "StaticText_Skill_1" ),
	baseSkill_2	= UI.getChildControl( Panel_Window_PetInfoNew, "StaticText_Skill_2" ),
	
	PetNo		= 0,
	currentPetLv = {},
}
local 	_buttonQuestion			= UI.getChildControl( Panel_Window_PetInfoNew, "Button_Question" )						-- 물음표 버튼
	_buttonQuestion:		addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Pet\" )" )						-- 물음표 좌클릭
	_buttonQuestion:		addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"Pet\", \"true\")" )					-- 물음표 마우스오버
	_buttonQuestion:		addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"Pet\", \"false\")" )				-- 물음표 마우스아웃

local petIcon = false

function PetInfo:Update()
	local petNo				= self.PetNo
	local petCount			= ToClient_getPetUnsealedList()
	if petCount == 0 then
		return
	end
	
	for index = 0, petCount - 1 do
		local PcPetData = ToClient_getPetUnsealedDataByIndex( index )
		if nil == PcPetData then
			return
		end
		
		if petNo == PcPetData:getPcPetNo() then
			
			local petStaticStatus	= PcPetData:getPetStaticStatus()
			local patName			= PcPetData:getName()
			local petNum_s64		= PcPetData:getPcPetNo()
			local petNum_S32		= Int64toInt32(petNum_s64)
			local petLevel			= PcPetData:getLevel()

			local petExp_s64		= PcPetData:getExperience()
			local petExp_s32		= Int64toInt32(petExp_s64)
			local petMaxExp_s64		= PcPetData:getMaxExperience()
			local petMaxExp_s32		= Int64toInt32(petMaxExp_s64)
			local petExpPercent		= ( petExp_s32 / petMaxExp_s32 ) * 100

			local petLovely 		= PcPetData:getLovely()
			local petMaxLovely		= 100
			local petLovelyPercent	= (petLovely / petMaxLovely) * 100
			local petHungry			= PcPetData:getHungry()
			local petMaxHungry		= petStaticStatus._maxHungry
			local petHungryPercent	= (petHungry / petMaxHungry) * 100
			local iconPath			= PcPetData:getIconPath()
			local petTier			= petStaticStatus:getPetTier() + 1		-- 0세대부터 시작하므로 +1을 해준다
			
			local petSkillType = function( param )
				local skillParam	= PcPetData:getSkillParam( param )
				local paramText		= ""
				if 1 == skillParam._type then				-- 루팅
					paramText = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_ITEMGETTIME", "itemGetTime", string.format("%.1f", skillParam:getParam(0) / 1000) ) -- "줍기(" .. skillParam:getParam(0) / 1000 .. "초마다 행동)"
				elseif 2 == skillParam._type then			-- 채집물 추적
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDGATHER") -- 채집물 찾기" -- (거리 : "	.. skillParam:getParam(0) / 100 .. ")"
				elseif 3 == skillParam._type then			-- 카오 추적
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPK") -- 적대적인 모험가 감지" -- (거리 : "		.. skillParam:getParam(0) / 100 .. ")"
				elseif 4 == skillParam._type then			-- 위치 발견
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPLACE") -- 위치 발견" -- (거리 : "		.. skillParam:getParam(0) / 100 .. ")"
				elseif 5 == skillParam._type then			-- 어그로 획득
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_MOBAGGRO") -- 몬스터 도발" -- (쿨타임 : "	.. skillParam:getParam(0) / 1000 .. "초)"
				elseif 6 == skillParam._type then			-- 엘리트 몬스터 찾기
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDRAREMONSTER") -- "희귀 몬스터 찾기" -- 몬스터 도발" -- (쿨타임 : "	.. skillParam:getParam(0) / 1000 .. "초)"
				elseif 7 == skillParam._type then			-- 자동 낚시 시간 감소
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REDUCEAUTOFISHINGTIME") -- "자동 낚시 시간 감소" -- 몬스터 도발" -- (쿨타임 : "	.. skillParam:getParam(0) / 1000 .. "초)"
				elseif 8 == skillParam._type then			-- 사막 질병 저항
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REGISTILL") -- "사막 질병 저항"
				elseif 9 == skillParam._type then			-- 호미 채집
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_AUTOGETHERING") -- "자동 채집"
				elseif 10 == skillParam._type then			-- 호미 채집
					paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_GETHERINGINCREASE") -- "채집량 증가"
				else										-- 배운 게 없음
					if 0 == param then
						self.baseSkill_1:SetShow( false )
					elseif 1 == param then
						self.baseSkill_2:SetShow( false )
					end
					return
				end
			
				if 0 == param then
					self.baseSkill_1:SetShow( true )
					self.baseSkill_1:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PETINFO_BASESKILL", "paramText", paramText ) ) -- "기본 : " .. paramText )
				elseif 1 == param then
					self.baseSkill_2:SetShow( true )
					self.baseSkill_2:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PETINFO_SPECIALSKILL", "paramText", paramText ) ) -- "특기 : " .. paramText )
				end
			end
			
			petSkillType( 0 )
			petSkillType( 1 )

			local actionMaxCount	= ToClient_getPetActionMax()
			local uiIdx				= 0
			for action_idx = 0, actionMaxCount -1 do
				self.actionSlot[action_idx]:SetShow( false )
				local actionStaticStatus	= ToClient_getPetActionStaticStatus( action_idx )
				local isLearn				= PcPetData:isPetActionLearned( action_idx )
				if true == isLearn then
					self.actionSlot[uiIdx]:SetShow( true )
					self.actionSlot[uiIdx]:ChangeTextureInfoName( "Icon/" .. actionStaticStatus:getIconPath() )
					-- 툴팁 처리를 하자.
					self.actionSlot[uiIdx]:addInputEvent( "Mouse_On",	"_PetInfo_ShowActionToolTip( " .. action_idx .. ", " .. uiIdx .. " )" )
					self.actionSlot[uiIdx]:addInputEvent( "Mouse_Out",	"_PetInfo_HideActionToolTip( " .. action_idx .. " )" )
					uiIdx = uiIdx + 1
				end
			end
			
			local skillMaxCount = ToClient_getPetEquipSkillMax()
			-- local skillMaxCount = 5
			
			PetInfo_SkillSlot_Show( true )
			for i = 0, 4 do
				self.skillSlot[i]:SetShow( false )
				self.skillSlot[i]:SetIgnore( true )
				self.skillSlot[i]:ChangeTextureInfoName("")
			end
			uiIdx = 0
			for skill_idx = 0, skillMaxCount - 1 do
				local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus( skill_idx )
				local isLearn = PcPetData:isPetEquipSkillLearned( skill_idx )
				if true == isLearn and nil ~= skillStaticStatus then
					local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
					if nil ~= skillTypeStaticWrapper then
						local skillNo = skillStaticStatus:getSkillNo()
						self.skillSlot[uiIdx]:SetShow( true )
						self.skillSlot[uiIdx]:SetIgnore( false )
						self.skillSlot[uiIdx]:ChangeTextureInfoName( "Icon/" .. skillTypeStaticWrapper:getIconPath() )
						self.skillSlot[uiIdx]:addInputEvent( "Mouse_On",	"PetInfo_ShowSkillToolTip( " .. skill_idx .. ", " .. uiIdx .. " )" )
						self.skillSlot[uiIdx]:addInputEvent( "Mouse_Out",	"PetInfo_HideSkillToolTip()" )
						
						Panel_SkillTooltip_SetPosition(skillNo, self.skillSlot[uiIdx], "PetSkill")
					end

					uiIdx = uiIdx + 1
				end
			end
			if 0 < uiIdx then
				Panel_Window_PetInfoNew:SetSize( Panel_Window_PetInfoNew:GetSizeX(), 410 )
				self.petInfoBg:SetSize( self.petInfoBg:GetSizeX(), 355 )
			else
				Panel_Window_PetInfoNew:SetSize( Panel_Window_PetInfoNew:GetSizeX(), 335 )
				self.petInfoBg:SetSize( self.petInfoBg:GetSizeX(), 280 )
				PetInfo_SkillSlot_Show( false )
			end
			
			

			if nil == self.currentPetLv[petNum_S32] then
				self.currentPetLv[petNum_S32] = petLevel
			end

			if self.currentPetLv[petNum_S32] ~= petLevel and self.currentPetLv[petNum_S32] ~= nil then -- 레벨업 체크
				if petLevel ~= 0 and petLevel ~= 1 and self.currentPetLv[petNum_S32] ~= 0 and self.currentPetLv[petNum_S32] ~= 1 then -- 현재레벨에 0이 찍히므로 예외처리.
					Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PETINFO_PETLEVELUP_ACK", "patName", patName ) ) -- patName .. "이(가) 레벨업을 하였습니다.")
				end
				self.currentPetLv[petNum_S32] = petLevel
			end

			self.iconPet			:ChangeTextureInfoName( iconPath )
			self.petName			:SetText( patName .. " (" .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petTier) .. ")" )
			self.progress_EXP		:SetProgressRate( petExpPercent )
			self.level_Value		:SetText( petLevel )
			self.progress_Hungry	:SetProgressRate( petHungryPercent )
			self.progress_Lovely	:SetProgressRate( petLovelyPercent )
			self.icon_Lovely		:SetShow( false )
			self.bg_Lovely			:SetShow( false )
			self.progress_Lovely	:SetShow( false )
		end
	end
end

function PetInfo_SkillSlot_Show( isShow )
	local self = PetInfo
	self.skillBg:SetShow( isShow )
	for v, control in pairs ( self.skillSlotBg ) do
		control:SetShow( isShow )
	end
	for v, control in pairs ( self.skillSlot ) do
		control:SetShow( isShow )
	end
end

function PetInfo:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_Window_PetInfoNew:GetSizeX()
	local panelSizeY 	= Panel_Window_PetInfoNew:GetSizeY()

	Panel_Window_PetInfoNew:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_Window_PetInfoNew:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

function _PetInfo_ShowActionToolTip( action_idx, uiIdx )
	local self = PetInfo
	local actionStaticStatus	= ToClient_getPetActionStaticStatus( action_idx )
	if nil == actionStaticStatus then
		return
	end

	local actionIconPath		= actionStaticStatus:getIconPath()
	local actionName			= actionStaticStatus:getName()
	local actionDesc			= actionStaticStatus:getDescription()
	local uiBase				= self.actionSlot[uiIdx]

	if "" == actionDesc then
		actionDesc = nil
	end

	TooltipSimple_Show( uiBase, actionName, actionDesc )
	-- TooltipCommon_Show( action_idx, uiBase, actionIconPath, actionName, actionName, actionDesc )
end
function _PetInfo_HideActionToolTip( action_idx )
	TooltipSimple_Hide()
end

function PetInfo_ShowSkillToolTip( skill_idx, uiIdx )
	local skillStaticStatus			= ToClient_getPetEquipSkillStaticStatus( skill_idx )
	local skillTypeStaticWrapper	= skillStaticStatus:getSkillTypeStaticStatusWrapper()
	local petSkillNo				= skillStaticStatus:getSkillNo()
	local uiBase					= PetInfo.skillSlot[uiIdx]

	Panel_SkillTooltip_Show(petSkillNo, false, "PetSkill")
end

function PetInfo_HideSkillToolTip()
	Panel_SkillTooltip_Hide()
end

function FGlobal_PetInfoNew_Open( petNo, isShow )
	local self		= PetInfo
	local petNo_s32 = petNo
	
	self.PetNo	= petNo_s32
	petIcon = isShow

	self:SetPosition()
	self:Update()
	Panel_Window_PetInfoNew:SetShow( true )
	FGlobal_PetListNew_Close()
end
function FGlobal_PetInfoNew_Close()
	Panel_Window_PetInfoNew:SetShow( false )
	if true ~= petIcon then
		FGlobal_PetListNew_Open()
		petIcon = false
	end
end

function FromClient_PetInfoHungryUpdate()
	PetInfo:Update()
end

function PetInfo:registEventHandler()
	self.BTN_Close  :addInputEvent("Mouse_LUp",		"FGlobal_PetInfoNew_Close()")
end
function PetInfo:registMessageHandler()
	registerEvent("FromClient_PetAddList",		"FromClient_PetInfoHungryUpdate")
	registerEvent("FromClient_PetInfoChanged",	"FromClient_PetInfoHungryUpdate")
end

PetInfo:registEventHandler()
PetInfo:registMessageHandler()

-- getPetSealedList : 맡겨져있는 펫 리스트데이타 (리턴 : 갯수)
-- getPetSealedDataByIndex : 인덱스로 실제 데이터 뺴오기(리턴 PetSealData : _characterKey)
-- getPetUnsealedList : 찾아져있는 펫리스트(리턴:갯수)
-- getPetUnsealedDataByIndex : 인덱스에 해당하는 찾아져있는 펫 데이터(리턴 : PcPetData)
-- PcPetData : getCharacterKey()
-- getPetStaticStatus()
-- getCharacterStaticStatus()
-- getPcPetNo()
-- getLevel()
-- getExperience()
-- getMaxExperience()
-- getLovely() - 애정도
-- getHungry() - 배고픔
-- isPetActionLearned(0~9) 까지 펫 고유액션 배웠는지여부

-- - PetStaticStatus : 
--  _type, 
--  _level
--  isPassiveSkill()
--  getCoolTime()
 
-- requestPetUnegister(petNo) : 방생
-- requestPetSeal(petNo) : 맡기기
-- requestPetUnseal(petNo) : 찾기

-- ToClient_callHandlerToPet("handleDefenceMode") 이런식으로... 

-- 따라와,     (handlePetFollowMaster)
-- 기다려      (handlePetWaitMaster)
-- 주워,      (handlePetGetItemOn)
-- 주워,      (handlePetGetItemOff)
-- 찾아,      (handlePetFindThatOn)
-- 찾아,      (handlePetFindThatOff)