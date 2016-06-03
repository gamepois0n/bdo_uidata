Panel_CoolTime_Effect:SetShow( false, false )

local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE

-- Show 하자마자 일정 시간 후에 자동으로 Hide 되도록 해 놓은 Ani. Hide 동작을 하지만, Show 의 Ani 에 등록하는게 맞다! - 성경
Panel_CoolTime_Effect:RegisterShowEventFunc( true, 'SkillCoolTime_Effect_HideAni()' )

function SkillCoolTime_Effect_HideAni()
	Panel_CoolTime_Effect:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local coolTime = Panel_CoolTime_Effect:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	coolTime:SetStartColor( UI_color.C_FFFFFFFF )
	coolTime:SetEndColor( UI_color.C_00FFFFFF )
	coolTime:SetStartIntensity( 3.0 )
	coolTime:SetEndIntensity( 1.0 )
	coolTime.IsChangeChild = true
	coolTime:SetHideAtEnd(true)
	coolTime:SetDisableWhileAni(true)
end

local skillCooltime =
{
	config =
	{
		slotGapX = 50,
		slotGapY = 50,
		screenPosX = 0.33,
		screenPosY = 0.42
	},
	slotConfig =
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon = true,
		createEffect = false,
		createFG = false,
		createFGDisabled = false,
		createLevel = false,
		createLearnButton = false,
		createCooltime = true,
		createCooltimeText = true
	},
	slots = {},					-- map<TSkillKey, IconSlot>
	slots_description = {},		-- map<TSkillKey, datagroup>
	slotPool = Array.new(),		-- vector<IconSlot>
	slotPool_desc = Array.new(),		-- vector<control:staticText>
	slotCount = 0,
	slotCount_desc = 0,
	
	textRemainTime = 1.5,
	textTemplate = UI.getChildControl( Panel_SkillCooltime , "StaticText_CoolTimeTitle"),
}

local showToggle = true;

-- 새 아이콘 슬롯을 만든다
function skillCooltime:createNewSlot()
	self.slotCount = self.slotCount + 1
	local slot = {}
	SlotSkill.new( slot, self.slotCount, Panel_SkillCooltime, self.slotConfig )
	slot.icon:SetIgnore(true)
	slot.iconBg 	= UI.createAndCopyBasePropertyControl( Panel_SkillCooltime, "Static_Icon_GuildSkillBG",	slot.icon,	"GuildSkillCoolTimeBG_"	.. self.slotCount )
	slot.iconBg:SetPosX( slot.icon:GetPosX() -6 )
	slot.iconBg:SetPosY( slot.icon:GetPosY() -6 )
	-- slot.iconBg:SetShow( false )
	return slot
end



-- 새 텍스트 슬롯을 만든다
function skillCooltime:createNewSlot_Desc()
	self.slotCount_desc = self.slotCount_desc + 1
	local slot = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_SkillCooltime, 'StaticText_description_' .. tostring(self.slotCount_desc) )
	CopyBaseProperty( self.textTemplate, slot )
	slot:SetIgnore(true)
	return slot
end

-- 풀에 남은 슬롯이 있으면 리턴한다.
-- 풀이 비어있으면, 새로운 슬롯을 생성한다.
function skillCooltime:getSlot()
	if 0 < self.slotPool:length() then
		return self.slotPool:pop_back()
	else
		return self:createNewSlot()
	end
end

function skillCooltime:getSlotDesc()
	if 0 < self.slotPool_desc:length() then
		return self.slotPool_desc:pop_back()
	else
		return self:createNewSlot_Desc()
	end
end

local skillReuseTime = nil
function SkillCooltime_Add( TSkillKey, TSkillNo )
	local self = skillCooltime

	local slot = self.slots[ TSkillKey ]
	if nil == slot then
		slot = self:getSlot()
		self.slots[ TSkillKey ] = slot
	end
	
	local slotDesc = self.slots_description[ TSkillKey ]
	if nil == slotDesc then
		slotDesc = { control = self:getSlotDesc(), remainTime = self.textRemainTime, skillNo = TSkillNo }
		self.slots_description[ TSkillKey ] = slotDesc
		slotDesc.control:SetShow(false)
	end
	
	local skillTypeStaticWrapper = getSkillTypeStaticStatus( TSkillNo )

	local isGuildSkill = skillTypeStaticWrapper:isGuildSkill()

	if true == isGuildSkill then
		slot.iconBg:SetShow( true )
	else
		slot.iconBg:SetShow( false )
	end

	local level = getLearnedSkillLevel(skillTypeStaticWrapper)
	local skillSS = getSkillStaticStatus(TSkillNo, level)
	skillReuseTime = skillSS:get()._reuseCycle / 1000

	slot:clearSkill()
	slot:setSkillTypeStatic( skillTypeStaticWrapper )
	
	slotDesc.remainTime = self.textRemainTime
	slotDesc.control:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SKILLCOOLTIME_SlotDesc", "skillName", skillTypeStaticWrapper:getName() ) )
	slotDesc.control:SetShow(false)
	slotDesc.control:SetAlpha(1)

	-- 하나도 없을때는 Show 가 false 이다. 무조건 Show 로 바꿔주자.
	-- 그럼 다음 Frame 에 Update 때에, 값이 세팅될 것이다!
	if( false == showToggle ) then
		Panel_SkillCooltime:SetShow( false, false )
	else
		Panel_SkillCooltime:SetShow( true, false )
	end
	
end

function SkillCooltime_OnResize()
	local self = skillCooltime
	local sizeX = getScreenSizeX() - 20
	local sizeY = getScreenSizeY()

	Panel_SkillCooltime:SetPosX( sizeX * self.config.screenPosX )
	Panel_SkillCooltime:SetPosY( sizeY * self.config.screenPosY )
end

------------------------------------------------------------
-- 						Update 함수
------------------------------------------------------------
function SkillCooltime_UpdatePerFrame(deltaTime)
	if( false == showToggle ) then
		return;
	end
	-- 여기에서 쿨타임을 체크해서
	local self = skillCooltime
	local remainTime = 0
	local row = 0
	local col = 0
	local count = 0
	local readyCount = 0
	
	for tSkillKey,slot_desc in pairs(self.slots_description) do
		local slot = self.slots[ tSkillKey ]
		remainTime = getSkillCooltime( tSkillKey ) 
		local realRemainTime = 0
		local intRemainTime = 0
		local skillReuseTime = 0
		
		local skillStaticWrapper = getSkillStaticStatus( slot_desc.skillNo, 1 )
		if ( nil ~= skillStaticWrapper ) then	
			skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
		end
		
		if ( 0 < slot_desc.remainTime ) then
			row = count % 2
			col = math.floor(count / 2)
		end
		if 0 < remainTime and nil ~= slot then
			-- 쿨타임이 있으면 보여주고
			slot.icon:SetShow( true )
			-- slot.iconBg:SetPos( col * self.config.slotGapX, row * self.config.slotGapY )
			slot.cooltime:UpdateCoolTime( remainTime )
			slot.cooltime:SetShow( true )
			realRemainTime = remainTime * skillReuseTime
			intRemainTime = realRemainTime- realRemainTime % 1 + 1
			slot.cooltimeText:SetText( Time_Formatting_ShowTop(intRemainTime) )
			if ( intRemainTime <= skillReuseTime ) then
				slot.cooltimeText:SetShow( true )
			else
				slot.cooltimeText:SetShow( false )
			end

			slot:setPos( col * self.config.slotGapX, row * self.config.slotGapY )
		elseif ( nil ~= slot ) then
			-- 쿨타임이 끝나는 처리 코드!
			slot.icon:SetShow( false )
			local slotPosX = slot.icon:GetParentPosX()
			local slotPosY = slot.icon:GetParentPosY()
			
			-- ♬ 쿨타임이 종료됐을 때 사운드 추가
			audioPostEvent_SystemUi(02,01)
			
			Panel_CoolTime_Effect:SetShow( true, true )
			Panel_CoolTime_Effect:SetIgnore(true)
			Panel_CoolTime_Effect:AddEffect( "fUI_Light", false, 0.0, 0.0 )
			Panel_CoolTime_Effect:SetPosX( slotPosX - 5 )
			Panel_CoolTime_Effect:SetPosY( slotPosY - 5 )
			
			-- 없으면, pool 에 반납해야 한다!
			slot:clearSkill()
			self.slotPool:push_back( slot )
			self.slots[ tSkillKey ] = nil
			
			slot_desc.control:SetShow(true)
		end
		
		if ( nil == self.slots[ tSkillKey ] ) then
			slot_desc.remainTime = slot_desc.remainTime - deltaTime
			local rate = slot_desc.remainTime / self.textRemainTime
			if ( rate <= 0.5 ) then
				slot_desc.control:SetFontAlpha( slot_desc.remainTime / (self.textRemainTime / 2) )
				slot_desc.control:SetAlpha( slot_desc.remainTime / (self.textRemainTime / 2) )
			else
				slot_desc.control:SetFontAlpha( 1 )
				slot_desc.control:SetAlpha( 1 )
			end
		else
			slot_desc.control:SetPosX(slot.icon:GetPosX() + slot.icon:GetSizeX() / 2 - slot_desc.control:GetSizeX() / 2 )
			slot_desc.control:SetPosY(slot.icon:GetPosY() + slot.icon:GetSizeY() / 2 - slot_desc.control:GetSizeY() / 2 )

		end
		
		if ( 0 < slot_desc.remainTime ) then
			count = count + 1
		else
			slot_desc.control:SetShow(false)
		end
	end

	-- 하나도 없으면 감춘다.
	if 0 == count then
		Panel_SkillCooltime:SetShow( false, false )
	end
end

function SkillCooltime_Reload()
	local coolTimeSkillList = getCoolTimeSkillList()
	if nil ~= coolTimeSkillList then
		for index=0, coolTimeSkillList:size()-1 do
			local skillInfo = coolTimeSkillList:atPointer(index)
			local skillKey = skillInfo._skillKey:get()
			local skillNo = skillInfo._skillKey:getSkillNo()

			SkillCooltime_Add(skillKey, skillNo)
		end
	end	
end

function skillCooltime:registEventHandler()
	Panel_SkillCooltime:RegisterUpdateFunc("SkillCooltime_UpdatePerFrame")
end

function skillCooltime:registMessageHandler()
	registerEvent("EventSkillCooltime",			"SkillCooltime_Add")
	registerEvent("onScreenResize",				"SkillCooltime_OnResize")
end

SkillCooltime_Reload()
skillCooltime:registEventHandler()
skillCooltime:registMessageHandler()

function Panel_SkillCooltime_ShowToggle()
	local isShow = Panel_SkillCooltime:IsShow();

	if isShow then
		showToggle = false;
		Panel_SkillCooltime:SetShow(false, false)
	else
		showToggle = true;
		Panel_SkillCooltime:SetShow(true, true);
	end
end
