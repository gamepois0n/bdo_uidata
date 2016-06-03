Panel_DeadNodeSelect:SetShow( false )
Panel_DeadNodeSelect:setIgnoreFlashPanel( true )

-------------------------------------------
-- 컨트롤 설정
-------------------------------------------
local _deadBlackHole				= UI.getChildControl ( Panel_DeadMessage, "deadBlackHole" )
local _deadMessage					= UI.getChildControl ( Panel_DeadMessage, "Static_DeadText" )
local _button_MoveTown				= UI.getChildControl ( Panel_DeadMessage, "Button_MoveTown" )
local _button_MoveExploration		= UI.getChildControl ( Panel_DeadMessage, "Button_MoveExploration" )
local _button_Immediate				= UI.getChildControl ( Panel_DeadMessage, "Button_Immediate" )	-- formatString="DEADMESSAGE_BTN_IMMEDIATE" 
local _button_AdvancedBase			= UI.getChildControl ( Panel_DeadMessage, "Button_AdvancedBase" )
local _button_LocalWar				= UI.getChildControl ( Panel_DeadMessage, "Button_LocalWar" )
local _text_ImmediateCount			= UI.getChildControl ( Panel_DeadMessage, "StaticText_ImmediateCount" )
local _text_reviveNotify			= UI.getChildControl ( Panel_DeadMessage, "StaticText_reviveNotify" )
local _button_SiegeIng				= UI.getChildControl ( Panel_DeadMessage, "Button_Siegeing" )
local _regenTime					= UI.getChildControl ( Panel_DeadMessage, "ResurrectionTime" )
local _useCashItemBG				= UI.getChildControl ( Panel_DeadMessage, "Static_UseCasheItemBG" )
local _checkBoxUseCache				= UI.getChildControl ( Panel_DeadMessage, "CheckBox_UseCacheItem" )
local _tooltip						= UI.getChildControl ( Panel_DeadMessage, "StaticText_Tooltip" )

-- Panel_DeadNodeSelect
local reviveBG						= UI.getChildControl ( Panel_DeadNodeSelect, "Static_AllBG" )	-- 부활 거점 리스트 BG
local reviveScroll					= UI.getChildControl ( Panel_DeadNodeSelect, "Scroll_List" )	-- 부활 거점 리스트 스크롤
local _deadNodeSelectClose			= UI.getChildControl( Panel_DeadNodeSelect, "Button_Close" )

reviveScroll:SetShow( false )
reviveScroll:SetShow( false )

_deadNodeSelectClose:addInputEvent( "Mouse_LUp",	"deadNodeSelectClose()" )

local STATIC_DROP_ITEM = {}
for ii = 0, 9 do
	STATIC_DROP_ITEM[ii] = UI.getChildControl( Panel_DeadMessage, "Static_DropItem_" .. ii )
end

local UI_ANI_ADV 			= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 				= Defines.Color
local UI_PUCT       		= CppEnums.PA_UI_CONTROL_TYPE
local CPP_slotNoString 		= CppEnums.EquipSlotNoString

enRespawnType =
{
	respawnType_None				= 0,
	respawnType_Immediate 			= 1,
	respawnType_ByOtherPlayer 		= 2,
	respawnType_Exploration			= 3,
	respawnType_NearTown			= 4,
	respawnType_TimeOver			= 5,
	respawnType_InSiegeingFortress	= 6,
	respawnType_LocalWar			= 7,
	respawnType_AdvancedBase		= 8,
	
	respawnType_Count				= 9,
}


-------------------------------------------
-- Local Variable 설정.
-------------------------------------------
local revivalTime				= 600
local DROP_ITEM_COUNT			= 1
local startTimer				= false
local isEnableImmediateRevival	= false			-- 즉시 부활 disable 표시 여부
-- 마을로 복귀시키는 타임 발동
local ResurrectionTime			= revivalTime
local CurrentTime				= 0
local revivalCacheItemCount		= 0
local isHasRestoreExperience 	= false
-------------------------------------------
-- 부활 거점 관련 변수
-------------------------------------------
local reviveStartIdx			= 0
local reviveListPool			= {}
local reviveListCount			= 5

-------------------------------------------
-- 함수들
-------------------------------------------
local deadMessage_ClearDropItems = function()
	for ii = 0, #STATIC_DROP_ITEM do							-- 초기화
		STATIC_DROP_ITEM[ii]:SetShow( false )
	end	
	DROP_ITEM_COUNT = 1;
end

local create_reviveList = function()	-- 부활 거점 배열 생성 reviveListPool[idx].
	for idx = 0, reviveListCount -1 do
		local slot = {}
		slot.bg		= UI.createAndCopyBasePropertyControl( Panel_DeadNodeSelect, "Static_Channel_BG",		reviveBG,	"DeadNodeSelect_SlotBG_"		.. idx )
		slot.text	= UI.createAndCopyBasePropertyControl( Panel_DeadNodeSelect, "StaticText_ChannelName",	slot.bg	,	"DeadNodeSelect_Slot_"			.. idx )
		slot.btn	= UI.createAndCopyBasePropertyControl( Panel_DeadNodeSelect, "Button_Select",			slot.bg	,	"DeadNodeSelect_Slot_Count_"	.. idx )
		slot.btn:addInputEvent( "Mouse_LUp",	"deadNodeSelect( " .. idx .. " )" )

		slot.bg		:SetPosX( 5 )
		slot.bg		:SetPosY( 5 + ( (slot.bg:GetSizeY() + 5 ) * idx ) )
		slot.text	:SetPosX( 10 )
		slot.text	:SetPosY( (slot.bg:GetSizeY()/2) - (slot.text:GetSizeY()/2) )
		slot.btn	:SetPosX( slot.bg:GetSizeX() - (slot.btn:GetSizeX() + 5) )
		slot.btn	:SetPosY( (slot.bg:GetSizeY()/2) - (slot.btn:GetSizeY()/2) )
		
		function slot:showControl( isVisible )
			slot.bg:SetShow( isVisible )
			slot.text:SetShow( isVisible )
			slot.btn:SetShow( isVisible )
		end
		
		function slot:SetRegionText( regionText )
			slot.text:SetText( regionText )
		end
		
		function slot:clear()
			slot.showControl( false )
			slot.setDisable( true )
			slot.text:SetText( "" )
		end
		
		function slot:setDisable( isDisable )
			if isDisable then
				slot.btn:SetShow( false )
			else
				slot.btn:SetShow( true )
			end
			
			slot.bg:SetDisableColor( isDisable )
			slot.text:SetDisableColor( isDisable )
		end

		reviveListPool[idx] = slot
	end
end
create_reviveList()

local fillFortressInfo = function()
	local	temporaryWrapper = getTemporaryInformationWrapper()
	local fortressSize = temporaryWrapper:getMyFortressSize()

	for idx = 0, reviveListCount -1 do
		reviveListPool[idx].clear()
	end
	
	for ii = 0, fortressSize do
		if ii < reviveListCount then
			local buildingInfo = temporaryWrapper:getMyfortressAt( ii )
			if nil ~= buildingInfo then
				local buildingRegionKey
				if ToClient_IsVillageSiegeBeing() then		-- true 면 거점전
					buildingRegionKey = buildingInfo:getBuildingRegionKey()
				else
					buildingRegionKey = buildingInfo:getAffiliatedRegionKey()
				end
				
				local regionInfo = getRegionInfoByRegionKey( buildingRegionKey )
				if nil ~= regionInfo then
					reviveListPool[ii]:showControl( true )
					
					local posi = buildingInfo:getPosition()
					local fortressToPlayerDistance = Util.Math.calculateDistance( posi, getSelfPlayer():get():getPosition() )
					fortressToPlayerDistance = fortressToPlayerDistance / 100		-- m로...
					local fortressToPlayerDistance2 = string.format( "%.1f", fortressToPlayerDistance )
					
					local linkSiegeWrapper	= ToClient_getVillageSiegeRegionInfoWrapperByPosition( posi )
					local explorationWrapper	= linkSiegeWrapper:getExplorationStaticStatusWrapper()
					local villageWarZone		= linkSiegeWrapper:get():isVillageWarZone()
					local warZoneName = ""
					if nil ~= explorationWrapper and true == villageWarZone then
						warZoneName = explorationWrapper:getName()
					else
						warZoneName = regionInfo:getAreaName()
					end
					
					_PA_LOG( "asdf", "buildingRegion " .. tostring( warZoneName ) .. " fortressToPlayerDistance : " .. tostring( fortressToPlayerDistance2 ) )
					
					if 100000.0 < fortressToPlayerDistance then
						--reviveListPool[ii]:setDisable( true )
						reviveListPool[ii].btn:SetShow( false )
					end

					reviveListPool[ii]:SetRegionText( warZoneName .. "\n" .. tostring( fortressToPlayerDistance2 ) .. "m" )
				end
			end
		end
	end
	
	-- getMyfortressAt 호출시 다시한번 성채/지휘소가 있는지 검사하게된다. 위에서 가져온 size와 다른수 있기에 다시한번 가져온다.
	fortressSize = temporaryWrapper:getMyFortressSize()
	Panel_DeadNodeSelect:SetShow( 0 < fortressSize )
	
	if 0 == fortressSize then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_NoPossibleRevivalPostion") )		--적절한 부활 장소가 없습니다.
	end
	
	if 1 == fortressSize then
		deadNodeSelect( 0 )
	end
end

function deadNodeSelect( idx )
	local	temporaryWrapper = getTemporaryInformationWrapper()
	local buildingInfo = temporaryWrapper:getMyfortressAt( idx )
	
	if nil ~= buildingInfo then
		local buildingRegionKey
		if ToClient_IsVillageSiegeBeing() then		-- true 면 거점전
			buildingRegionKey = buildingInfo:getBuildingRegionKey()
		else
			buildingRegionKey = buildingInfo:getAffiliatedRegionKey()
		end
		
		if 0 == buildingRegionKey:get() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_NoPossibleRevivalPostion") )		--적절한 부활 장소가 없습니다.
			return
		end
	
		deadMessage_Revival( enRespawnType.respawnType_InSiegeingFortress, 0xff, 0, buildingRegionKey )
		deadMessage_ClearDropItems()
		Panel_DeadNodeSelect:SetShow( false )
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_NoPossibleRevivalPostion") )		--적절한 부활 장소가 없습니다.
		return
	end
end

function deadNodeSelectClose()
	Panel_DeadNodeSelect:SetShow( false )
end

function deadMessage_Resize()
	local screenX = getScreenSizeX()
	local screenY = getScreenSizeY()
	Panel_DeadMessage:SetSize(screenX, screenY)
	
	_deadBlackHole:SetPosX ( (screenX/2) - (_deadBlackHole:GetSizeX()/2) )
	_deadBlackHole:SetPosY ( (screenY/2) - (_deadBlackHole:GetSizeY()/2) )
	
	_deadMessage:SetPosX ( screenX/2 - 25 )
	_deadMessage:SetPosY ( 100 )

	local buttonHalfSizeX = _button_Immediate:GetSizeX()/2
	local buttonSizeY = _button_Immediate:GetSizeY()
	_useCashItemBG:SetPosX( screenX/2 - (buttonHalfSizeX) )
	_useCashItemBG:SetPosY( screenY/2 + buttonSizeY*2.4 )
	_checkBoxUseCache:SetPosX( screenX/2 - (buttonHalfSizeX-5) )
	_checkBoxUseCache:SetPosY( screenY/2 + buttonSizeY*2.43 )

	_text_reviveNotify:SetPosX( screenX/2 - (_text_reviveNotify:GetSizeX()/2) )
	_text_reviveNotify:SetPosY( _checkBoxUseCache:GetPosY() - _text_reviveNotify:GetSizeY() - 20 )

	_button_Immediate:SetPosX( screenX/2 - buttonHalfSizeX )
	_button_Immediate:SetPosY( screenY/2 + buttonSizeY*2 + 50 )
	_text_ImmediateCount:SetPosX( screenX/2 - (_text_ImmediateCount:GetSizeX()/2) )
	_text_ImmediateCount:SetPosY( _button_Immediate:GetPosY() + 30 )
	
	_button_MoveTown:SetPosX( screenX/2 - buttonHalfSizeX )
	_button_MoveTown:SetPosY( screenY/2 + buttonSizeY*2 + 115 )
	
	_button_MoveExploration:SetPosX( screenX/2 - buttonHalfSizeX )
	_button_MoveExploration:SetPosY( screenY/2 + buttonSizeY*2 + 165 )
	
	_button_SiegeIng:SetPosX( _button_Immediate:GetPosX() )
	_button_SiegeIng:SetPosY( _button_Immediate:GetPosY() )
	
	_button_AdvancedBase:SetPosX( screenX/2 - buttonHalfSizeX )
	_button_AdvancedBase:SetPosY( screenY/2 + buttonSizeY*2 + 215 )
	
	_button_LocalWar:SetPosX( _button_Immediate:GetPosX() )
	_button_LocalWar:SetPosY( _button_Immediate:GetPosY() )
	
	_regenTime:SetPosX( screenX/2 - _regenTime:GetSizeX()/2 )
	_regenTime:SetPosY( _deadMessage:GetPosY() + 45 )
	
	local dropItemPosX = screenX/2 - STATIC_DROP_ITEM[0]:GetSizeX()/2
	local dropItemPosY = _regenTime:GetPosY() + 100
	for ii = 0, #STATIC_DROP_ITEM do
		STATIC_DROP_ITEM[ii]:SetShow( true )
		STATIC_DROP_ITEM[ii]:SetPosX( dropItemPosX )
		STATIC_DROP_ITEM[ii]:SetPosY( dropItemPosY + (ii*STATIC_DROP_ITEM[ii]:GetSizeY()) + (ii*40) )
	end	
	
	_checkBoxUseCache:SetCheck( false )
end

local deadMessage_Animation = function()
	-- 켜준다
	Panel_DeadMessage:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo1 = _deadBlackHole:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo1:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo1.IsChangeChild = false

	local aniInfo2 = _deadBlackHole:addScaleAnimation( 3, 15.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR_2	)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.5)
	aniInfo2.AxisX = 128
	aniInfo2.AxisY = 128
	aniInfo2.IsChangeChild = false

	-- 버튼 애니메이션
	-- 마을
	local aniInfo3 = _button_MoveTown:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo3.IsChangeChild = true
	aniInfo3:SetDisableWhileAni( true )

	local aniInfo3 = _button_MoveTown:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo3.IsChangeChild = true
	aniInfo3:SetDisableWhileAni( true )

	local aniInfo4 = _button_MoveTown:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartScale(0.5)
	aniInfo4:SetEndScale(1.0)
	aniInfo4.IsChangeChild = true
	aniInfo4:SetDisableWhileAni( true )


	-- 점령전 이탈
	local aniInfoNotify1 = _text_reviveNotify:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoNotify1:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoNotify1:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoNotify1.IsChangeChild = true
	aniInfoNotify1:SetDisableWhileAni( true )

	local aniInfoNotify2 = _text_reviveNotify:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoNotify2:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoNotify2:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoNotify2.IsChangeChild = true
	aniInfoNotify2:SetDisableWhileAni( true )

	local aniInfoNotify3 = _text_reviveNotify:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoNotify3:SetStartScale(0.5)
	aniInfoNotify3:SetEndScale(1.0)
	aniInfoNotify3.IsChangeChild = true
	aniInfoNotify3:SetDisableWhileAni( true )

	

	-- 탐험
	local aniInfoExplore3 = _button_MoveExploration:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoExplore3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoExplore3:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoExplore3.IsChangeChild = true
	aniInfoExplore3:SetDisableWhileAni( true )

	aniInfoExplore3 = _button_MoveExploration:addColorAnimation( 3.0, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoExplore3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoExplore3:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoExplore3.IsChangeChild = true
	aniInfoExplore3:SetDisableWhileAni( true )

	local aniInfoExplore4 = _button_MoveExploration:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoExplore4:SetStartScale(0.5)
	aniInfoExplore4:SetEndScale(1.0)
	aniInfoExplore4.IsChangeChild = true
	aniInfoExplore4:SetDisableWhileAni( true )
	
	-- 즉시 부활
	local aniInfoImmediate3 = _button_Immediate:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoImmediate3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoImmediate3:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoImmediate3.IsChangeChild = true
	aniInfoImmediate3:SetDisableWhileAni( true )

	aniInfoImmediate3 = _button_Immediate:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoImmediate3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoImmediate3:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoImmediate3.IsChangeChild = true
	aniInfoImmediate3:SetDisableWhileAni( true )

	local aniInfoImmediate4 = _text_ImmediateCount:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoImmediate4:SetStartScale(0.5)
	aniInfoImmediate4:SetEndScale(1.0)
	aniInfoImmediate4.IsChangeChild = true
	aniInfoImmediate4:SetDisableWhileAni( true )

	local aniInfoImmediate5 = _text_ImmediateCount:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoImmediate5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoImmediate5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoImmediate5.IsChangeChild = true
	aniInfoImmediate5:SetDisableWhileAni( true )

	aniInfoImmediate5 = _text_ImmediateCount:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoImmediate5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoImmediate5:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoImmediate5.IsChangeChild = true
	aniInfoImmediate5:SetDisableWhileAni( true )

	local aniInfoImmediate6 = _text_ImmediateCount:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoImmediate6:SetStartScale(0.5)
	aniInfoImmediate6:SetEndScale(1.0)
	aniInfoImmediate6.IsChangeChild = true
	aniInfoImmediate6:SetDisableWhileAni( true )

	-- 성채/지휘소 부활
	local aniInfoSiege3 = _button_SiegeIng:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoSiege3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoSiege3:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoSiege3.IsChangeChild = true

	aniInfoSiege3 = _button_SiegeIng:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoSiege3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoSiege3:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoSiege3.IsChangeChild = true

	local aniInfoSiege4 = _button_SiegeIng:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoSiege4:SetStartScale(0.5)
	aniInfoSiege4:SetEndScale(1.0)
	aniInfoSiege4.IsChangeChild = true
	
	-- 전진기지 부활
	local aniInfoAdvancedBase = _button_AdvancedBase:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoAdvancedBase:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoAdvancedBase:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoAdvancedBase.IsChangeChild = true

	aniInfoAdvancedBase = _button_AdvancedBase:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoAdvancedBase:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoAdvancedBase:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoAdvancedBase.IsChangeChild = true

	local aniInfoAdvancedBase2 = _button_AdvancedBase:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoAdvancedBase2:SetStartScale(0.5)
	aniInfoAdvancedBase2:SetEndScale(1.0)
	aniInfoAdvancedBase2.IsChangeChild = true

	-- LocalWar
	local aniInfoLocalWar = _button_LocalWar:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoLocalWar:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoLocalWar:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoLocalWar.IsChangeChild = true

	aniInfoLocalWar = _button_LocalWar:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoLocalWar:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoLocalWar:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoLocalWar.IsChangeChild = true

	local aniInfoLocalWar2 = _button_LocalWar:addScaleAnimation( 2.5, 3.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoLocalWar2:SetStartScale(0.5)
	aniInfoLocalWar2:SetEndScale(1.0)
	aniInfoLocalWar2.IsChangeChild = true
	
	-- 체크박스
	local aniInfoCheckBox5 = _checkBoxUseCache:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoCheckBox5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoCheckBox5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoCheckBox5.IsChangeChild = true

	aniInfoCheckBox5 = _checkBoxUseCache:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoCheckBox5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfoCheckBox5:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfoCheckBox5.IsChangeChild = true

	--체크박스 BG
	local aniInfoCheckBoxBG5 = _useCashItemBG:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfoCheckBoxBG5:SetStartColor( UI_color.C_00FFFFFF )
	aniInfoCheckBoxBG5:SetEndColor( UI_color.C_00FFFFFF )
	aniInfoCheckBoxBG5:SetDisableWhileAni( true )
	aniInfoCheckBoxBG5.IsChangeChild = true

	aniInfoCheckBoxBG5 = _useCashItemBG:addColorAnimation( 3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	aniInfoCheckBoxBG5:SetStartColor( UI_color.C_00FFFFFF )
	aniInfoCheckBoxBG5:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfoCheckBoxBG5.IsChangeChild = true

	-- 데드 메시지
	local aniInfo3 = _deadMessage:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo3.IsChangeChild = true

	local aniInfo7 = _deadMessage:addScaleAnimation( 0.7, 2.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo7:SetStartScale(0.5)
	aniInfo7:SetEndScale(1.0)
	aniInfo7.IsChangeChild = true

	local aniInfo8 = _deadMessage:addColorAnimation( 1.5, 2.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo8.IsChangeChild = true

	-- 귀환 타이머
	local aniInfo9 = _regenTime:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo9:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo9:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo9.IsChangeChild = true

	local aniInfo9 = _regenTime:addColorAnimation( 2.2, 2.7, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo9:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo9:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo9.IsChangeChild = true
	startTimer = true
	
	ResurrectionTime = revivalTime
end

function deadMessage_Show( attackerActorKeyRaw, isSkipDeathPenalty, isHasRestoreExp )
	SetUIMode( Defines.UIMode.eUIMode_DeadMessage )
	local selfProxy = getSelfPlayer()
	if nil == selfProxy then
		return
	end
	
	-- 붉은 전장일 경우 다른 부활은 필요 없다.
	if 0 ~= ToClient_GetMyTeamNoLocalWar() then
		_button_SiegeIng		:SetShow( false )
		_button_MoveExploration	:SetShow( false )
		_button_MoveTown		:SetShow( false )								-- 마을 부활
		_button_AdvancedBase	:SetShow( false )
		_text_reviveNotify		:SetShow( false )								-- 공성 지역 이탈 안내
		_button_Immediate		:SetShow( false )
		_useCashItemBG			:SetShow( false )
		_checkBoxUseCache		:SetShow( false )
		_text_ImmediateCount	:SetShow( false )
		_button_LocalWar 		:SetShow( true )								-- 붉은 전장

		Panel_DeadMessage		:SetShow(true, false)
		
		return
	end
	
	local regionInfo					= getRegionInfoByPosition( selfProxy:get():getPosition() )
	if	( regionInfo:isPrison() or goToPrison() )	then
		_button_SiegeIng		:SetShow( false )
		_button_MoveExploration	:SetShow( false )
		_button_MoveTown		:SetShow( false )								-- 마을 부활
		_button_AdvancedBase	:SetShow( false )
		_text_reviveNotify		:SetShow( false )								-- 공성 지역 이탈 안내
		_button_Immediate		:SetShow( false )
		_useCashItemBG			:SetShow( false )
		_checkBoxUseCache		:SetShow( false )
		_text_ImmediateCount	:SetShow( false )
		_button_LocalWar 		:SetShow( false )								-- 붉은 전장

		Panel_DeadMessage		:SetShow(true, false)
		
		ResurrectionTime	= 2
		return
	end
	
	ResurrectionTime		= revivalTime
	isHasRestoreExperience	= isHasRestoreExp

	local linkedSiegeRegionInfoWrapper	= ToClient_getVillageSiegeRegionInfoWrapperByPosition( selfProxy:get():getPosition() )
	--local isSiegeHasFortress			= deadMessage_isSiegingGuildInCurrentPosition()	-- isHasFortress()
	local isKingOrLordWarZone			= regionInfo:get():isKingOrLordWarZone()
	local isVillageWarZone				= linkedSiegeRegionInfoWrapper:get():isVillageWarZone()	
	local isSiegeBeing					= deadMessage_isSiegeBeingInCurrentPosition() -- regionInfo:get():isSiegeBeing()			-- 공성 중인지에 대한 변수
	local isArena						= regionInfo:get():isArenaArea()

	-- deadMessage_isSiegeBeingInCurrentPosition();		// 현재 지역에서 공성이 진행중인가
	-- deadMessage_isSiegingGuildInCurrentPosition();	// 현재 지역의 공성에 참여했는가?
	
	local freeRevivalLevel = FromClient_getFreeRevivalLevel()
	local isFreeArea = regionInfo:get():isFreeRevivalArea()	

	FGlobal_PopCloseWorldMap()
	-- 경험치가 0 이라면 레벨 다운이 없기 때문에 경험치 하락 메시지를 출력하지 않는다.
	local selfPlayerExp = selfProxy:get():getExp_s64()
	if isSkipDeathPenalty then
		local static = STATIC_DROP_ITEM[0]
		static:SetShow( true )
		static:SetText( PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_NoDeathPenalty" ) )
		--의상 세트효과에 의해 사망 패널티가 면제되었습니다.
	elseif Defines.s64_const.s64_0 < selfPlayerExp and false == isArena then
		deadMessage_ExpDown()
	end
	
	--deadMessage_ClearDropItems()
	Panel_DeadMessage:SetShow(true, false)
	deadMessage_Animation()
	
	-- 점령지역이고 성채및 지휘소가 있다면  성채/지휘소 부활 메시지를 띄워 주도록한다.	

	
	-- 공격자에 따른 메시지 설정
	local displayText = ""
	local attackerActorProxyWrapper = getActor(attackerActorKeyRaw)

	if attackerActorKeyRaw == selfProxy:getActorKey() then
		displayText = PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DisplayMsg" )		-- 자기 자신에 대한메시지
	elseif nil ~= attackerActorProxyWrapper then
    	displayText = PAGetStringParam1( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_KilledDisplayMsg", "attackerName", attackerActorProxyWrapper:getOriginalName() )	-- 숨겨진 캐릭명도 보여야한다.
	else
		displayText = PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DisplayMsg" )
	end
	
	_deadMessage:SetText( displayText )

	_button_SiegeIng		:SetShow( false )
	_button_MoveExploration	:SetShow( true )
	_button_MoveTown		:SetShow( true )								-- 마을 부활
	_button_AdvancedBase	:SetShow( false )
	_button_LocalWar 		:SetShow( false )
	_text_reviveNotify		:SetShow( false )								-- 공성 지역 이탈 안내
	
	if(FGlobal_IsCommercialService()) then
		_button_Immediate:SetShow( true )								-- 즉시 부활( 엘리언 눈물 소지시에만 enable )
		_useCashItemBG:SetShow( true )
		_checkBoxUseCache:SetShow( true )
		_button_Immediate:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_IMMEDIATE_RESURRECTION") ) -- "즉시 부활" )
		
		_text_ImmediateCount:SetShow( true )
		local setMessage		= ""
		local revivalItemCount	= ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
		
		if isFreeArea and selfProxy:get():getLevel() <= freeRevivalLevel then
			setMessage = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DEADMESSAGE_RESURRECTION_POSSIBLE", "freeRevivalLevel", freeRevivalLevel ) -- "Lv." .. freeRevivalLevel .. "이하 모험가 즉시부활 가능지역"
			--setMessage = PAGetStringParam1( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_FREEREVIVAL_MSG", "FreeRevivalLevel", freeRevivalLevel )
		elseif revivalItemCount <= 0 then
			setMessage = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_ITEM_RESURRECTION") -- "부활 아이템 구입 후 즉시 부활"
		else
			setMessage = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DEADMESSAGE_GET_ITEM_RESURRECTION", "revivalItemCount", revivalItemCount ) -- "부활 아이템 " .. revivalItemCount .. "종류 보유"
		end
		_text_ImmediateCount:SetText( setMessage )

	else
		if true == isArena then
			_button_Immediate:SetShow( true )
			_button_Immediate:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_IMMEDIATE_RESURRECTION") )
		else
			_button_Immediate:SetShow( false )
		end
		
		_text_ImmediateCount:SetShow( false )
		_useCashItemBG:SetShow( false )
		_checkBoxUseCache:SetShow( false )
	end
	
	local	temporaryWrapper = getTemporaryInformationWrapper()
	local fortressSize = temporaryWrapper:getMyFortressSize()
	local isMyChannelSiegeBeing = deadMessage_isSiegeBeingMyChannel()
	-- 점령전 시에는 탐험노드 부활을 허용하지 않는다.
	--if true == isMyChannelSiegeBeing and ( true == isKingOrLordWarZone or true == isVillageWarZone ) then		-- 메이저 공성 지역이거나 마이너 공성 지역이다.
		--if true == isSiegeBeing and true == isSiegeHasFortress then		-- 성채/지휘소를 가지고 점령전 지역에서 죽었을 경우( 즉시 부활: X, 성채/지휘소: O, 탐험노드: O, 마을: O )
	if true == isMyChannelSiegeBeing then
		if 0 < fortressSize then
			_button_Immediate:SetShow( false )							-- 즉시 부활
			_text_ImmediateCount:SetShow( false )
			_button_SiegeIng:SetShow( true )							-- 성채/지휘소 부활
		elseif true == isSiegeBeing then								-- 점령전 중인 지역에서 죽은 일반 유저( 즉시부활: X, 성채/지휘소: X, 탐험노드: O, 마을: O
			_button_Immediate:SetShow( false )
			_text_ImmediateCount:SetShow( false )
		elseif true == isHasFortress() and false == isSiegeBeing then	-- 성채/지휘소는 있지만, 공성 지역이 아닌 지역에서 죽은 경우
			-- 성채 부활 버튼이 나오지 않는다. 안내 문구만 나온다.
			_text_reviveNotify:SetShow( true )
		else															-- 그 외 가장 일반적인 죽음( 즉시 부활: O, 성채/지휘소:X, 탐험노드: O, 마을: O )
			if false == getNoAccessArea() then							-- 공성지역은 진입가능한 지역이다.( 위에 검사 안함 )
				_button_MoveTown:SetShow( false )
				_button_Immediate:SetShow( false )
				_text_ImmediateCount:SetShow( false )
			end
		end
		
		_button_Immediate:SetShow( false )
		_text_ImmediateCount:SetShow( false )
	else
		if false == getNoAccessArea() then							-- 공성지역은 진입가능한 지역이다.( 위에 검사 안함 )
			--_button_MoveTown:SetShow( false )						-- 진입 불가 지역도 마을 부활을 가능하게 한다.( juicepia:20141220 )
			_button_Immediate:SetShow( false )
			_text_ImmediateCount:SetShow( false )
		end		
	end
	
	if selfProxy:get():isGuildMember() and selfProxy:get():isAdvancedBaseActorKey() then
		_button_AdvancedBase:SetShow( true )
	end
	
	-- 공성 부활 룰의 변경 = 현재 위치한 채널이 공성중인 채널이라면 즉시 부활을 할 수 없다.
	-- 물에서는 즉시부활 되지 않는다.
	if true == isCurrentPositionInWater() then
	--if true == isCurrentPositionInWater() then
		if false == selfProxy:isCarrierCharacterScene() then
			_button_Immediate:SetShow( false )
			_text_ImmediateCount:SetShow( false )
		end
	end
	
	revivalCacheItemCount = ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
	--_PA_LOG( "asdf", " revivalCacheItemCount: " .. tostring( revivalCacheItemCount ) )
end

function deadMessage_UpdatePerFrame( deltaTime )
	local selfPlayer = getSelfPlayer()
	if ( nil == selfPlayer) or ( not selfPlayer:isDead() ) then
		Panel_DeadMessage:SetShow(false, false)
		return
	end
	
	if (0.0 < ResurrectionTime) then
		ResurrectionTime = ResurrectionTime - deltaTime
		local regenTime = math.floor( ResurrectionTime )

		if CurrentTime ~= regenTime then
			_regenTime:SetText ( PAGetStringParam1( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_TIME", "regenTime", tostring(regenTime) ) )			-- 실시간 초 받아오고 표시
			CurrentTime = regenTime

			if regenTime <= 0 then
				if	( goToPrison() )	then
					deadMessage_Revival( enRespawnType.respawnType_TimeOver, 0xff, 0, getSelfPlayer():getRegionKey() )
					SetUIMode( Defines.UIMode.eUIMode_Default )
					return
				end
				
				Panel_DeadMessage:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
				local aniInfo1 = Panel_DeadMessage:addColorAnimation( 0.0, 1.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
				aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
				aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
				aniInfo1.IsChangeChild = true
				aniInfo1:SetHideAtEnd(true)
				aniInfo1:SetDisableWhileAni(true)
				
				-- 자동으로 부활 하게 가까운 마을 탐험포인트로 이동
				-- 카오성향의 캐릭터도 탐험 포인터 부활로 자동으로 하게 한다.
				-- 자동 부활시 서버에서 결정해서 부활 시켜주도록 한다. (juicepia:20140819)
				-- if	(false == getNoAccessArea()) or (selfPlayer:get():getTendency() < 0)	then
					-- deadMessage_RevivalExploration_Confirm()
				-- else
				--_PA_LOG( "asdf", "enRespawnType.respawnType_TimeOver : " .. tostring( enRespawnType.respawnType_TimeOver ) .. " CppEnums.ItemWhereType.eCashInventory : " .. tostring( CppEnums.ItemWhereType.eCashInventory ) )
				deadMessage_ClearDropItems()
				deadMessage_Revival( enRespawnType.respawnType_TimeOver, 0xff, 0, getSelfPlayer():getRegionKey() )
				-- end
				
				SetUIMode( Defines.UIMode.eUIMode_Default )
			end
		end
	end
end

-- 클라이언트에서 오는 이벤트. Lua 에서 Client 로 Get 하면 안되나????
-- dropType  0 : 죽어서 드랍 1 : 삭제된 아이템
local undefinedEnchantLevel = 0
function deadMessage_AddDropItem( itemName, count, enchantLevel, dropType )
	-- UI.debugMessage( "DeadMessage 드랍 아이템 추가!!!!" .. itemName .. "[" .. count .. "]" )
	if #STATIC_DROP_ITEM < DROP_ITEM_COUNT then
		return
	end
	
	local strDropType = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_DRIPTYPE1") -- "떨어뜨림"
	if 1 == dropType then
		strDropType = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_DRIPTYPE2") -- "파괴됨"
	end

	local static = STATIC_DROP_ITEM[DROP_ITEM_COUNT]
	static:SetShow(true)
	
	if undefinedEnchantLevel ~= enchantLevel then
		static:SetText( "+" .. enchantLevel .. " " .. itemName .. "[" .. count .. "]" .. " (" .. strDropType .. ")" )
	else
		static:SetText( itemName .. "[" .. count .. "]" .. " (" .. strDropType .. ")" )
	end

	static:SetFontColor( UI_color.C_FFD20000 )									-- 아이템일 경우 빨간색
	
	--UI.debugMessage( "itemName : " .. itemName .. " count : " .. count )

	-- 떨어진 아이템
	local aniInfo5 = static:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5.IsChangeChild = true

	local aniInfo6 = static:addColorAnimation( 3.0, 3.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo6:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo6:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo6.IsChangeChild = true

	DROP_ITEM_COUNT = DROP_ITEM_COUNT + 1
end

function	deadMessage_WeakEquipCantPushinventory( notify )
	if #STATIC_DROP_ITEM < DROP_ITEM_COUNT then
		return
	end

	local static = STATIC_DROP_ITEM[DROP_ITEM_COUNT]
	DROP_ITEM_COUNT = DROP_ITEM_COUNT + 1
	
	static:SetText( notify )
	static:SetFontColor( UI_color.C_FF96D4FC )									-- 장비 하락일 경우 파란색
	static:SetShow(true)
	
	local aniInfo5 = static:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5.IsChangeChild = true

	local aniInfo6 = static:addColorAnimation( 3.0, 3.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo6:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo6:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo6.IsChangeChild = true
end

function	deadMessage_WeakEquip( slotNo )
	if #STATIC_DROP_ITEM < DROP_ITEM_COUNT then
		return
	end

	local static = STATIC_DROP_ITEM[DROP_ITEM_COUNT]
	DROP_ITEM_COUNT = DROP_ITEM_COUNT + 1
	static:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DownEnchantMsg", "enchantDownSlot", CPP_slotNoString[slotNo] ) )
	static:SetFontColor( UI_color.C_FF96D4FC )									-- 장비 하락일 경우 파란색
	static:SetShow(true)
	
	local aniInfo5 = static:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5.IsChangeChild = true

	local aniInfo6 = static:addColorAnimation( 3.0, 3.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo6:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo6:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo6.IsChangeChild = true

	--UI.debugMessage( "slotNo 내구도 떨어짐 : " .. slotNo )
end

function deadMessage_DestroyJewel( destoryJewel01, destoryJewel02, destoryJewel03, destoryJewel04, destoryJewel05  )
	if #STATIC_DROP_ITEM < DROP_ITEM_COUNT then
		return
	end
	
	local jewelKey = { [0] = destoryJewel01, [1] = destoryJewel02, [2] = destoryJewel03, [3] = destoryJewel04, [4] = destoryJewel05 }
	local jewelName = ""
	for idx = 0, #jewelKey, 1 do
		if "" ~= jewelName then
			if nil ~= jewelKey[idx] and 0 ~= jewelKey[idx] then
				local itemStaticStatus	= getItemEnchantStaticStatus( ItemEnchantKey(jewelKey[idx]) )
				local itemName			= itemStaticStatus:getName()
				jewelName = jewelName .. ", " .. itemName
			end
		else
			jewelName = getItemEnchantStaticStatus( ItemEnchantKey(jewelKey[idx]) ):getName()
		end
	end
	
	local static = STATIC_DROP_ITEM[DROP_ITEM_COUNT]
	static:SetShow(true)
	static:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_JEWELDESTROYED") .. " " .. jewelName )	-- PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DestroyJewel" )) -- 장비에 장착된 쥬얼이 파괴되었습니다.
	static:SetFontColor(  UI_color.C_FFD20000  )	-- 쥬얼 파괴시 빨간색
	
	local aniInfo5 = static:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5.IsChangeChild = true

	local aniInfo6 = static:addColorAnimation( 3.0, 3.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo6:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo6:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo6.IsChangeChild = true

	DROP_ITEM_COUNT = DROP_ITEM_COUNT + 1
	--UI.debugMessage( "slotNo 내구도 떨어짐 : " .. slotNo )

end

function deadMessage_ExpDown()
	local static = STATIC_DROP_ITEM[0]
--	static:SetShow(true)
--	static:SetText( PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_EXP_DOWN" ) )
	
	local aniInfo5 = static:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo5:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5:SetEndColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo5.IsChangeChild = true

	local aniInfo6 = static:addColorAnimation( 3.0, 3.4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo6:SetStartColor( UI_color.C_00FFFFFF )		-- 0x00FFFFFF
	aniInfo6:SetEndColor( UI_color.C_FFFFFFFF )		-- 0xFFFFFFFF
	aniInfo6.IsChangeChild = true

end

--[[ *************************** 메시지 처리 *************************** --]]
--Panel_DeadMessage:RegisterUpdateFunc("RegenTimerUpdate")

-- 버튼 핸들러
function deadMessage_ButtonPushed_MoveToVillage()
	local selfProxy = getSelfPlayer()
	if nil == selfProxy then
		return
	end

	local regionInfo					= getRegionInfoByPosition( selfProxy:get():getPosition() )
	local linkedSiegeRegionInfoWrapper	= ToClient_getVillageSiegeRegionInfoWrapperByPosition( selfProxy:get():getPosition() );
	local isVillageWarZone				= linkedSiegeRegionInfoWrapper:get():isVillageWarZone()
	local isSiegeHasFortress			= deadMessage_isSiegingGuildInCurrentPosition()							-- 성채를 갖고 있나?
	local isKingOrLordWarZone			= regionInfo:get():isKingOrLordWarZone()
	local isSiegeBeing					= deadMessage_isSiegeBeingInCurrentPosition()	-- regionInfo:get():isSiegeBeing()			-- 공성 중인지에 대한 변수

	local prevExp						= selfProxy:get():getPrevExp_s64()
	local currentExp					= selfProxy:get():getExp_s64()
	local isBadPlayer 					= false
	if selfProxy:get():getTendency() < 0 then
		isBadPlayer = true
	end

	local isCheck = _checkBoxUseCache:IsCheck()
	local isArena = regionInfo:get():isArenaArea()
	
	--_PA_LOG( "asdf", "vehillage isCheck : " .. tostring( isCheck ) .. " currentExp : " .. tostring( currentExp ) .. " prevExp : " .. tostring( prevExp ) .. " isHasRestoreExperience : " .. tostring(isHasRestoreExperience) )
	if isCheck and (false == isArena) and (isHasRestoreExperience or currentExp < prevExp) then
		useCheckCacheItem( enRespawnType.respawnType_NearTown )
	else
		local contentString = PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_TO_VILLAGE" )
		if isSiegeBeing and ( true == isKingOrLordWarZone or true == isVillageWarZone ) then
			contentString = contentString
		else
			if (isHasRestoreExperience or currentExp < prevExp) then
				contentString = contentString .. "\n" .. PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_EXP_DOWN" )	-- 공성중이라면 이 메시지는 없다.
			else
				contentString = contentString
			end
			
			--_PA_LOG( "asdf", " ToClient_IsOpendDesertPK() : " .. tostring( ToClient_IsOpendDesertPK() ) .. "regionInfo:getVillainRespawnWaypointKey() : " .. tostring( regionInfo:getVillainRespawnWaypointKey() .. " isBadPlayer : " .. tostring( isBadPlayer ) ) )
			if ToClient_IsOpendDesertPK() and true == isBadPlayer and 0 ~= regionInfo:getVillainRespawnWaypointKey() then
				contentString = contentString .. "\n" .. PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_BadPlayerMoveVillage" )
			end
		end
		
		local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_MB_TITLE" ), content = contentString, functionYes = deadMessage_RevivalVillage_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1}
		MessageBox.showMessageBox(messageboxData);	
	end

	deadMessage_ClearDropItems()
end

function deadMessage_RevivalVillage_Confirm()
	deadMessage_Revival( enRespawnType.respawnType_NearTown, 0xff, 0, getSelfPlayer():getRegionKey() )
	SetUIMode( Defines.UIMode.eUIMode_Default )
	--deadMessage_ClearDropItems()
end

function deadMessage_ButtonPushed_MoveExploration()
	local selfProxy = getSelfPlayer()
	if nil == selfProxy then
		return
	end
	local regionInfo					= getRegionInfoByPosition( selfProxy:get():getPosition() )
	local linkedSiegeRegionInfoWrapper	= ToClient_getVillageSiegeRegionInfoWrapperByPosition( selfProxy:get():getPosition() );
	local isVillageWarZone				= linkedSiegeRegionInfoWrapper:get():isVillageWarZone()
	--local isSiegeHasFortress			= deadMessage_isSiegingGuildInCurrentPosition()							-- 성채를 갖고 있나?
	local isKingOrLordWarZone			= regionInfo:get():isKingOrLordWarZone()
	local isSiegeBeing					= deadMessage_isSiegeBeingInCurrentPosition() --regionInfo:get():isSiegeBeing()			-- 공성 중인지에 대한 변수

	local prevExp						= selfProxy:get():getPrevExp_s64()
	local currentExp					= selfProxy:get():getExp_s64()
	local isCheck = _checkBoxUseCache:IsCheck()
	
	local isArena = regionInfo:get():isArenaArea()
	-- _PA_LOG( "asdf", "moveExploration isCheck : " .. tostring( isCheck ) .. " currentExp : " .. tostring( currentExp ) .. " prevExp : " .. tostring( prevExp ) )
	if isCheck and (false == isArena) and (isHasRestoreExperience or currentExp < prevExp) then
		useCheckCacheItem( enRespawnType.respawnType_Exploration )
	else
		local contentString = PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_TO_EXPLORE" )
		if isSiegeBeing and ( true == isKingOrLordWarZone or true == isVillageWarZone ) then
			contentString = contentString
		else
			if (isHasRestoreExperience or currentExp < prevExp) then
				contentString = contentString .. "\n" .. PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_EXP_DOWN" )	-- 공성중이라면 이 메시지는 없다.
			else
				contentString = contentString
			end
		end

		local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_MB_TITLE" ), content = contentString, functionYes = deadMessage_RevivalExploration_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1}
		MessageBox.showMessageBox(messageboxData);
	end
	deadMessage_ClearDropItems()
end

function deadMessage_RevivalExploration_Confirm()
	deadMessage_Revival( enRespawnType.respawnType_Exploration, 0xff, 0, getSelfPlayer():getRegionKey() )
	SetUIMode( Defines.UIMode.eUIMode_Default )	
	--deadMessage_ClearDropItems()
end

function deadMessage_ButtonPushed_Immediate()
	local revivalItemCount = 0
	revivalItemCount = ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
	
	local selfProxy = getSelfPlayer()
	if nil == selfProxy then
		return
	end
	
	local regionInfo = getRegionInfoByPosition( selfProxy:get():getPosition() )
	local isArena = regionInfo:get():isArenaArea()
	
	local freeRevivalLevel = FromClient_getFreeRevivalLevel()
	local isFreeArea = regionInfo:get():isFreeRevivalArea()
	if true == isArena then
		deadMessage_Revival( enRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey())
	elseif isFreeArea and selfProxy:get():getLevel() <= freeRevivalLevel then
		deadMessage_Revival( enRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey())
	else
		if (1 == revivalItemCount) then
			HandleClicked_Apply_CashRevivalItem( enRespawnType.respawnType_Immediate )
		elseif (1 < revivalItemCount) then
			CashRevivalBuy_Open( enRespawnType.respawnType_Immediate )
		else
			HandleClicked_Buy_CashRevivalItem( enRespawnType.respawnType_Immediate )
		end
	end
	FGlobal_ImmediatelyResurrection( 100 )
	deadMessage_ClearDropItems()
end

function deadMessage_ButtonPushed_SiegeIng()
	--local rv = deadMessage_sendSiegeingRevial()
	fillFortressInfo()
	deadMessage_ClearDropItems()
end

function deadMessage_ButtonPushed_AdvancedBase()
	deadMessage_Revival( enRespawnType.respawnType_AdvancedBase, 0xff, 0, getSelfPlayer():getRegionKey() )
end

function deadMessage_ButtonPushed_LocalWar()
	deadMessage_Revival( enRespawnType.respawnType_LocalWar, 0xff, 0, getSelfPlayer():getRegionKey() )
end

function useCheckCacheItem( respawnType )
	local revivalItemCount = 0
	revivalItemCount = ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
	
	local selfProxy = getSelfPlayer()
	if nil == selfProxy then
		return
	end
	
	--_PA_LOG( "Revival", "respawnType : " .. tostring( respawnType ) .. " revivalItemCount : " .. tostring( revivalItemCount ) )
	local regionInfo = getRegionInfoByPosition( selfProxy:get():getPosition() )
	local isArena = regionInfo:get():isArenaArea()
	if true == isArena and respawnType == enRespawnType.respawnType_Immediate then
		deadMessage_Revival( enRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey())
	else
		if (1 == revivalItemCount) then
			HandleClicked_Apply_CashRevivalItem( respawnType )
		elseif (1 < revivalItemCount) then
			CashRevivalBuy_Open( respawnType )
		else
			HandleClicked_Buy_CashRevivalItem( respawnType )
		end
	end
end

function deadMessage_SimpleTooltips( isShow )
	local uiControl, name, desc = nil, nil, nil

	name = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_TOOLTIP_NAME") -- "사용효과"
	desc = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_TOOLTIP_DESC") -- " - 즉시 부활\n - 일정량의 경험치를 복구하여 부활"
	uiControl = _useCashItemBG

	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)

	if isShow == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function deadMessage_registEventHandler()
	_button_MoveTown		:addInputEvent( "Mouse_LUp",	"deadMessage_ButtonPushed_MoveToVillage()" )
	_button_MoveExploration	:addInputEvent( "Mouse_LUp",	"deadMessage_ButtonPushed_MoveExploration()" )
	_button_Immediate		:addInputEvent( "Mouse_LUp",	"deadMessage_ButtonPushed_Immediate()" )
	_button_SiegeIng		:addInputEvent( "Mouse_LUp",	"deadMessage_ButtonPushed_SiegeIng()" )
	_button_AdvancedBase	:addInputEvent( "Mouse_LUp",	"deadMessage_ButtonPushed_AdvancedBase()" )
	_button_LocalWar		:addInputEvent( "Mouse_LUp",	"deadMessage_ButtonPushed_LocalWar()" )
	_useCashItemBG			:addInputEvent( "Mouse_On",		"deadMessage_SimpleTooltips( true )")
	_useCashItemBG			:addInputEvent( "Mouse_Out",	"deadMessage_SimpleTooltips( false )")
	_useCashItemBG			:setTooltipEventRegistFunc("deadMessage_SimpleTooltips( true )")
end
function deadMessage_registMessageHandler()
	-- 클라이언트로 부터 오는 이벤트 등록
	registerEvent( "EventSelfPlayerDead", 							"deadMessage_Show" );
	registerEvent( "Event_DeadMessage_AddDropItem", 				"deadMessage_AddDropItem" )
	registerEvent( "Event_DeadMessage_WeakEquip", 					"deadMessage_WeakEquip" )
	registerEvent( "Event_DeadMessage_WeakEquipCantPushInventory", 	"deadMessage_WeakEquipCantPushinventory" )
	registerEvent( "Event_DeadMessage_DestroyJewel", 				"deadMessage_DestroyJewel" )

	registerEvent( "onScreenResize",					"deadMessage_Resize" )
	--registerEvent( "Event_DeadMessage_ExpDown", "DeadMessage_ExpDown" )
end

-- 컨트롤 이벤트 등록


Panel_DeadMessage:RegisterUpdateFunc("deadMessage_UpdatePerFrame")

deadMessage_Resize()
deadMessage_registEventHandler()
deadMessage_registMessageHandler()