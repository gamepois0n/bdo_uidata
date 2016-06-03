Panel_Window_PetMarketRegist:SetShow(false, false)									-- 가급적 꺼두고 시작
Panel_Window_PetMarketRegist:setMaskingChild(true)									-- 자식까지 masking 할지 여부 설정(masking 사용 시 true)
Panel_Window_PetMarketRegist:ActiveMouseEventEffect(true)								-- 패널에 마우스 가져갈 때 이펙트 줄지 설정
Panel_Window_PetMarketRegist:setGlassBackground( true )								-- 패널의 반투명 설정(뒤가 보임), 기본적으로 true
Panel_Window_PetMarketRegist:RegisterShowEventFunc( true, 'PetMarketRegist_ShowAni()' )			-- 패널이 show 될 때 애니메이션
Panel_Window_PetMarketRegist:RegisterShowEventFunc( false, 'PetMarketRegist_HideAni()' )			-- 패널이 hide 될 때 애니메이션

local auctionInfo = RequestGetAuctionInfo()

function PetMarketRegist_ShowAni()
end
function PetMarketRegist_HideAni()
end

local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local PetMarketRegist =
{
	btnClose			= UI.getChildControl( Panel_Window_PetMarketRegist, "Button_Win_Close" ),
	btnQuestion			= UI.getChildControl( Panel_Window_PetMarketRegist, "Button_Question" ),
	
	petIcon				= UI.getChildControl( Panel_Window_PetMarketRegist,	"Static_Icon" ),
	tier				= UI.getChildControl( Panel_Window_PetMarketRegist, "StaticText_TierValue" ),
	level				= UI.getChildControl( Panel_Window_PetMarketRegist, "StaticText_LevelValue" ),
	base				= UI.getChildControl( Panel_Window_PetMarketRegist, "StaticText_BaseValue" ),
	special				= UI.getChildControl( Panel_Window_PetMarketRegist, "StaticText_SpecialValue" ),
	
	maxPrice			= UI.getChildControl( Panel_Window_PetMarketRegist, "StaticText_MaxValue" ),
	minPrice			= UI.getChildControl( Panel_Window_PetMarketRegist, "StaticText_MinValue" ),
	
	actionSlotBg		= UI.getChildControl( Panel_Window_PetMarketRegist, "Static_ActionSlotBg" ),
	actionSlot			= UI.getChildControl( Panel_Window_PetMarketRegist, "Static_ActionSlot" ),
	skillSlotBg			= UI.getChildControl( Panel_Window_PetMarketRegist, "Static_SkillSlotBg" ),
	skillSlot			= UI.getChildControl( Panel_Window_PetMarketRegist, "Static_SkillSlot" ),
	
	btnNextPage			= UI.getChildControl( Panel_Window_PetMarketRegist, "Button_NextPage" ),
	btnPrevPage			= UI.getChildControl( Panel_Window_PetMarketRegist, "Button_PrevPage" ),
	
	editPriceValue		= UI.getChildControl( Panel_Window_PetMarketRegist, "Edit_Price" ),
	
	btnRegist			= UI.getChildControl( Panel_Window_PetMarketRegist, "Button_Yes" ),
	btnCancel			= UI.getChildControl( Panel_Window_PetMarketRegist, "Button_No" ),
	
	_slots				= Array.new(),
	_maxSlotCount		= 5,
	_slotGap			= 5,
	_maxValue			= toInt64(0, 0),
	_minValue			= toInt64(0, 0),
	_registPrice		= toInt64(0, 0),
	_nextPage			= false,
	_currentPetNo		= nil,
}

function PetMarketRegist:EventHandler()
	PetMarketRegist.btnClose	:addInputEvent(	"Mouse_LUp",	"PetMarketRegist_Close()" )
	PetMarketRegist.btnQuestion	:addInputEvent(	"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"Pet\" )" )						-- 물음표 좌클릭
	PetMarketRegist.btnQuestion	:addInputEvent(	"Mouse_On",		"HelpMessageQuestion_Show( \"Pet\", \"true\")" )				-- 물음표 마우스오버
	PetMarketRegist.btnQuestion	:addInputEvent(	"Mouse_Out",	"HelpMessageQuestion_Show( \"Pet\", \"false\")" )				-- 물음표 마우스아웃
	PetMarketRegist.btnRegist	:addInputEvent( "Mouse_LUp",	"PetMarketRegist_Confirm()" )
	PetMarketRegist.btnCancel	:addInputEvent( "Mouse_LUp",	"PetMarketRegist_Close()" )
	
	registerEvent("FromClient_RegisterPetInAuction", "FromClient_RegisterPetInAuction" )			-- 등록 완료!
end
PetMarketRegist:EventHandler()

function PetMarketRegist:Init()
	for index = 0, self._maxSlotCount - 1 do
		local temp = {}
		local actionSlotBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetMarketRegist, "Static_ActionSlotBg_" .. index )
		CopyBaseProperty( self.actionSlotBg, actionSlotBg )
		actionSlotBg:SetPosX( self.actionSlotBg:GetPosX() + ( self.actionSlotBg:GetSizeX() + self._slotGap ) * index )
		
		temp.actionSlot = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, actionSlotBg, "Static_ActionSlot_" .. index )
		CopyBaseProperty( self.actionSlot, temp.actionSlot )
		
		local skillSlotBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_PetMarketRegist, "Static_SkillSlotBg_" .. index )
		CopyBaseProperty( self.skillSlotBg, skillSlotBg )
		skillSlotBg:SetPosX( self.skillSlotBg:GetPosX() + ( self.skillSlotBg:GetSizeX() + self._slotGap ) * index )
		
		temp.skillSlot = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, skillSlotBg, "Static_SkillSlot_" .. index )
		CopyBaseProperty( self.skillSlot, temp.skillSlot )
		
		self._slots[index] = temp
	end
	
	self.actionSlotBg	:SetShow( false )
	self.actionSlot		:SetShow( false )
	self.skillSlotBg	:SetShow( false )
	self.skillSlot		:SetShow( false )
end

function PetMarketRegist:SetPetInfo( petNo )
	local _petNo = tonumber64( petNo )
	local petCount = ToClient_getPetSealedList()
	if petCount == 0 then
		return
	end
	
	self._currentPetNo = petNo
	
	for ii = 0, self._maxSlotCount - 1 do
		self._slots[ii].actionSlot:ChangeTextureInfoName( "" )
		self._slots[ii].skillSlot:ChangeTextureInfoName( "" )
	end
	
	for index = 0, petCount - 1 do
		local petInfo = ToClient_getPetSealedDataByIndex( index )
		local petNo_s64 = petInfo._petNo
		if _petNo == petNo_s64 then
			local petStaticStatus	= petInfo:getPetStaticStatus()
			local iconPath			= petInfo:getIconPath()
			local petLevel			= petInfo._level
			local petTier			= petStaticStatus:getPetTier() + 1
			
			-- 임의 가격 레인지 세팅 : 바꿔줘야 함!!
			local basePrice			= Int64toInt32(petStaticStatus:getBasePrice())
			self._maxValue			= tonumber64(basePrice * petStaticStatus:getMaxPricePercent()/1000000)	-- toInt64( 0, 100000000 )
			self._minValue			= tonumber64(basePrice * petStaticStatus:getMinPricePercent()/1000000)	-- toInt64( 0, 10000 )
			
			self.maxPrice:SetText( makeDotMoney( self._maxValue ) )
			self.minPrice:SetText( makeDotMoney( self._minValue ) )
			
			self.petIcon:ChangeTextureInfoName( iconPath )
			self.tier:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petTier)) -- petTier .. "세대" )
			self.level:SetText( petLevel .. " Lv" )
			
			local petSkillType = function( param )
				local skillParam	= petInfo:getSkillParam( param )
				local paramText		= ""
				if 1 == skillParam._type then				-- 루팅
					paramText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_PICKUPTIME", "time", string.format("%.1f", skillParam:getParam(0)) / 1000) -- "줍기(" .. string.format("%.1f", skillParam:getParam(0)) / 1000 .. "초 주기)"
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
				end
			
				if 0 == param then
					self.base:SetText( paramText ) -- "기본 : " .. paramText )
				elseif 1 == param then
					self.special:SetText( paramText ) -- "특기 : " .. paramText )
				end
			end
			
			petSkillType( 0 )
			petSkillType( 1 )
			
			if self.btnNextPage:GetShow() then
				self._nextPage =  false
			end
			
			local actionMaxCount	= ToClient_getPetActionMax()
			local uiIdx				= 0
			local nextIndex			= 0
			for action_idx = 0, actionMaxCount -1 do
				local actionStaticStatus	= ToClient_getPetActionStaticStatus( action_idx )
				local isLearn				= petInfo:isPetActionLearned( action_idx )
				if true == isLearn then
					if not self._nextPage then
						if uiIdx < self._maxSlotCount then
							self._slots[uiIdx].actionSlot:ChangeTextureInfoName( "Icon/" .. actionStaticStatus:getIconPath() )
							
							-- 툴팁 처리를 하자.
							self._slots[uiIdx].actionSlot:addInputEvent( "Mouse_On",	"PetMarketRegist_ShowActionToolTip( " .. action_idx .. ", " .. uiIdx .. " )" )
							self._slots[uiIdx].actionSlot:addInputEvent( "Mouse_Out",	"PetMarketRegist_HideActionToolTip( " .. action_idx .. " )" )
							uiIdx = uiIdx + 1
						else
							self._nextPage = true
							self.btnNextPage:SetShow( true )
							self.btnNextPage:addInputEvent( "Mouse_LUp", "PetMarketRegist_NextAction_Show()" )
							break
						end
					else
						uiIdx = uiIdx + 1
						if self._maxSlotCount < uiIdx then
							self._slots[nextIndex].actionSlot:ChangeTextureInfoName( "Icon/" .. actionStaticStatus:getIconPath() )
							
							-- 툴팁 처리를 하자.
							self._slots[nextIndex].actionSlot:addInputEvent( "Mouse_On",	"PetMarketRegist_ShowActionToolTip( " .. action_idx .. ", " .. nextIndex .. " )" )
							self._slots[nextIndex].actionSlot:addInputEvent( "Mouse_Out",	"PetMarketRegist_HideActionToolTip( " .. action_idx .. " )" )
							nextIndex = nextIndex + 1
						end
					end
				end
			end
			
			local skillMaxCount = ToClient_getPetEquipSkillMax()
			uiIdx = 0
			for skill_idx = 0, skillMaxCount - 1 do
				local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus( skill_idx )
				local isLearn = petInfo:isPetEquipSkillLearned( skill_idx )
				if true == isLearn and nil ~= skillStaticStatus then
					local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
					if nil ~= skillTypeStaticWrapper then
						local skillNo = skillStaticStatus:getSkillNo()
						self._slots[uiIdx].skillSlot:ChangeTextureInfoName( "Icon/" .. skillTypeStaticWrapper:getIconPath() )
					
						-- 툴팁 처리를 하자.
						self._slots[uiIdx].skillSlot:addInputEvent( "Mouse_On",		"PetMarketRegist_ShowSkillToolTip( " .. skill_idx .. ", " .. uiIdx .. " )" )
						self._slots[uiIdx].skillSlot:addInputEvent( "Mouse_Out",	"PetMarketRegist_HideSkillToolTip()" )
						
						Panel_SkillTooltip_SetPosition(skillNo, self._slots[uiIdx].skillSlot, "PetSkill")
					end

					uiIdx = uiIdx + 1
				end
			end			
		end
	end
	
	PetMarketRegist.editPriceValue:SetEditText( PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_INPUTPRICE")) -- "가격을 입력해주세요." )
	PetMarketRegist.editPriceValue:addInputEvent( "Mouse_LUp",	"HandleClicked_PriceBox( \"" .. tostring(_petNo) .. "\" )" )

end

function PetMarketRegist_NextAction_Show()
	PetMarketRegist.btnNextPage:SetShow( false )
	PetMarketRegist.btnPrevPage:SetShow( true )
	PetMarketRegist.btnPrevPage:addInputEvent( "Mouse_LUp", "HandleClicked_NextAction_Show()" )
	PetMarketRegist:SetPetInfo( PetMarketRegist._currentPetNo )
end

function HandleClicked_NextAction_Show()
	PetMarketRegist.btnNextPage:SetShow( true )
	PetMarketRegist.btnPrevPage:SetShow( false )
	PetMarketRegist:SetPetInfo( PetMarketRegist._currentPetNo )
end

function HandleClicked_PriceBox( petNoStr )
	param =
	{
		[0] = petNoStr,
	}
	local maxPrice = PetMarketRegist._maxValue
	Panel_NumberPad_Show( true, maxPrice, param, PetMarket_SetEditBox )
end

function PetMarket_SetEditBox( inputNumber )
	local price = makeDotMoney( inputNumber )
	PetMarketRegist.editPriceValue:SetEditText( price )
	PetMarketRegist._registPrice = inputNumber
end

function PetMarketRegist_Confirm()
	PetMarket_Register_ConfirmFunction( PetMarketRegist._registPrice, param )
end

function PetMarket_Register_ConfirmFunction( inputNumber, param )
	if toInt64(0,0) == inputNumber then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_INPUTPRICE")) -- "가격을 입력해주세요." )
		return
	elseif inputNumber < PetMarketRegist._minValue then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_LOWPRICE")) -- "등록 가격이 너무 낮습니다." )
		return
	elseif PetMarketRegist._maxValue < inputNumber then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_HIGHPRICE")) -- "등록 가격이 너무 높습니다." )
		return
	end
	
	ToClient_registerPetInAuctionReq( tonumber64( param[0] ), inputNumber)
end

function PetMarketRegist_ShowActionToolTip( action_idx, uiIdx )
	local actionStaticStatus	= ToClient_getPetActionStaticStatus( action_idx )
	if nil == actionStaticStatus then
		return
	end

	local actionIconPath		= actionStaticStatus:getIconPath()
	local actionName			= actionStaticStatus:getName()
	local actionDesc			= actionStaticStatus:getDescription()
	local uiBase				= PetMarketRegist._slots[uiIdx].actionSlot

	if "" == actionDesc then
		actionDesc = nil
	end

	TooltipSimple_Show( uiBase, actionName, actionDesc )
end
function PetMarketRegist_HideActionToolTip( action_idx )
	TooltipSimple_Hide()
end

function PetMarketRegist_ShowSkillToolTip( skill_idx, uiIdx )
	local skillStaticStatus			= ToClient_getPetEquipSkillStaticStatus( skill_idx )
	local skillTypeStaticWrapper	= skillStaticStatus:getSkillTypeStaticStatusWrapper()
	local petSkillNo				= skillStaticStatus:getSkillNo()
	local uiBase					= PetMarketRegist._slots[uiIdx].skillSlot

	Panel_SkillTooltip_Show(petSkillNo, false, "PetSkill")
end

function PetMarketRegist_HideSkillToolTip()
	Panel_SkillTooltip_Hide()
end

function FGlobal_PetMarketRegist_Show( petNo )
	if nil == petNo then
		return
	end
	if not Panel_Window_PetMarketRegist:GetShow() then
		Panel_Window_PetMarketRegist:SetShow( true )
	end
	
	local self = PetMarketRegist
	self._currentPetNo = nil
	self._nextPage = false
	self.btnNextPage:SetShow( false )
	self.btnPrevPage:SetShow( false )
	self:SetPetInfo( petNo )
end

function PetMarketRegist_Close()
	if Panel_Window_PetMarketRegist:GetShow() then
		Panel_Window_PetMarketRegist:SetShow( false )
		PetMarketRegist._registPrice = toInt64( 0, 0 )
	end
	
	if not Panel_Window_PetListNew:GetShow() then
		FGlobal_PetListNew_Open()
	end
end

function FromClient_RegisterPetInAuction()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PETMARKETREGIST_REGISTCONFIRM")) -- "애완동물이 정상적으로 등록됐습니다." )
	PetMarketRegist_Close()
end

PetMarketRegist:Init()
