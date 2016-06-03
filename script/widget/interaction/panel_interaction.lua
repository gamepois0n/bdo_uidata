local UI_Color		= Defines.Color
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM 		= CppEnums.TextMode

-- Panel_CharacterInterAction:setMaskingChild(true)
---------------------------
-- Local Variables
---------------------------
local _needCollectTool = UI.getChildControl( Panel_Interaction, "Static_Cant" )	-- 채집 도구가 필요할 때 버튼에 X 표시를 해준다

local _background = UI.getChildControl( Panel_Interaction, "Static_Background" )
_background:setGlassBackground(true)

local _houseDescBG		= UI.getChildControl ( Panel_Interaction_House, "Static_BuyHouse_DescBG" )
local _houseDesc		= UI.getChildControl ( Panel_Interaction_House, "StaticText_BuyHouse_Desc" )
local _contribute_Help 	= UI.getChildControl ( Panel_Interaction_House, "StaticText_ContHelp" )
local _globalGuide		= UI.getChildControl ( Panel_Interaction, "StaticText_Purpose" )

Panel_Interaction:RegisterShowEventFunc( true, 'Panel_Interaction_ShowAni()' )
Panel_Interaction:RegisterShowEventFunc( false, 'Panel_Interaction_HideAni()' )

function Panel_Interaction_ShowAni()
end

function Panel_Interaction_HideAni()
end

local eInteractionTypeMax = CppEnums.InteractionType.InteractionType_Count -- 코드의 InteractionType (미니게임타입을 제외한) 과 갯수가 맞아야한다.
local preUIMode = nil

local DESC_TEXT = {}
for ii = 0, eInteractionTypeMax-1 do
	DESC_TEXT[ii] = PAGetString( Defines.StringSheet_GAME,  "INTERACTION_TEXT"..tostring(ii));
end

INETRACTION_BUTTON_TEXT = {}
for ii = 0, eInteractionTypeMax-1 do
	INETRACTION_BUTTON_TEXT[ii] = PAGetString( Defines.StringSheet_GAME,  "INTERACTION_MENU"..tostring(ii));
end

local BUTTON_ID =
{
	[0] = "Button_GamePlay",					--	0
	"Button_CharInfo",							--	1
	"Button_Exchange",							--	2
	"Button_Party_Invite",						--	3	
	"Button_Dialog",							--	4
	"Button_Ride",								--	5
	"Button_Control",							--	6
	"Button_Looting",							--	7
	"Button_Collect",							--	8
	"Button_OpenDoor",							--	9
	"Button_OpenWarehouseInTent",				--	10
	"Button_ReBuildTent",						--	11
	"Button_InstallationMode",					--	12
	"Button_ViewHouseInfo",						--	13
	"Button_Havest",							--	14
	"Button_ParkingHorse",						--	15
	"Button_EquipInstallation",					--	16
	"Button_UnequipInstallation",				--	17
	"Button_OpenInventory",						--	18
	"Button_HorseInfo",							--	19
	"Button_Bussiness",							--	20
	"Button_Guild_Invite",						--	21
	"Button_Guild_Alliance_Invite",				--	22
	"Button_UseItem",							--	23
	"Button_UnbuildPersonalTent",				--	24
	"Button_Manufacture",						--  25
	"Button_Greet",								--	26
	"Button_Steal",								--	27
	"Button_Lottery",							-- 	28
	"Button_HarvestSeed",						--  29
	"Button_TopHouse",							--  30
	"Button_HouseRank",							--  31
	"Button_Lop",		    					--  32
	"Button_KillBug",							--  33
	"Button_UninstallTrap",						--	34
	"Button_Sympathetic",						--	35
	"Button_Observe",							--	36
	"Button_HarvestInformation",				--	37
	"Button_Clan_Invite",						--	38
	"Button_SiegeGateOpen",						--	39
	"Button_UnbuildKingOrLordTent",				--	40
	"Button_Eavesdrop",							--	41
	"Button_WaitComment",						--	42
	"Button_TakedownCannon",					--	43
	"Button_OpenWindow",						--	44
	"Button_ChangeLook",						--	45
	"Button_ChangeName",						--	46
	"Button_UninstallBarricade",				--	47
	"Button_RepairKingOrLordTent",				--  48
	"Button_UserIntroduction",					--  49
	"Button_FollowActor",						--  50
	"Button_BuildingUpgrade"					--  51
}

local UI_BUTTON = {}

-- 버튼 컨트롤 얻고, 헨들러 연결 해 준다.
for ii = 0, #BUTTON_ID do
	UI_BUTTON[ii] = UI.getChildControl( Panel_Interaction, BUTTON_ID[ii] )
	UI_BUTTON[ii]:addInputEvent( "Mouse_LUp", "Interaction_ButtonPushed(" .. ii .. ")" )
	UI_BUTTON[ii]:addInputEvent( "Mouse_On",  "Interaction_ButtonOver(" .. ii .. ", true)" )
	UI_BUTTON[ii]:addInputEvent( "Mouse_Out", "Interaction_ButtonOver(" .. ii .. ", false)" )
	UI_BUTTON[ii]:SetText( INETRACTION_BUTTON_TEXT[ ii ] )
	UI_BUTTON[ii]:SetFontAlpha( 1.0 );
	UI_BUTTON[ii]:SetShow( false )
end

local getDefaultButtonInfo = function(actor, index)
	return UI_BUTTON[index], INETRACTION_BUTTON_TEXT[index]
end

local interactionTargetUIList = {}
local interactionTargetTextList = {}

local otherUIList = {
	[CppEnums.InteractionType.InteractionType_HavestLop]			= UI.getChildControl( Panel_Interaction, "Button_KillBugs" ),
	[CppEnums.InteractionType.InteractionType_HavestKillBug]		= UI.getChildControl( Panel_Interaction, "Button_Feeding" ),
	[CppEnums.InteractionType.InteractionType_HarvestInformation]	= UI.getChildControl( Panel_Interaction, "Button_DomesticAnimalInfo" ),
}

otherUIList[32]:addInputEvent( "Mouse_LUp", "Interaction_ButtonPushed(" .. 32 .. ")" )
otherUIList[32]:addInputEvent( "Mouse_On",  "Interaction_ButtonOver(" .. 32 .. ", true)" )
otherUIList[32]:addInputEvent( "Mouse_Out", "Interaction_ButtonOver(" .. 32 .. ", false)" )
otherUIList[32]:SetShow( false )
otherUIList[33]:addInputEvent( "Mouse_LUp", "Interaction_ButtonPushed(" .. 33 .. ")" )
otherUIList[33]:addInputEvent( "Mouse_On",  "Interaction_ButtonOver(" .. 33 .. ", true)" )
otherUIList[33]:addInputEvent( "Mouse_Out", "Interaction_ButtonOver(" .. 33 .. ", false)" )
otherUIList[33]:SetShow( false )
otherUIList[37]:addInputEvent( "Mouse_LUp", "Interaction_ButtonPushed(" .. 37 .. ")" )
otherUIList[37]:addInputEvent( "Mouse_On",  "Interaction_ButtonOver(" .. 37 .. ", true)" )
otherUIList[37]:addInputEvent( "Mouse_Out", "Interaction_ButtonOver(" .. 37 .. ", false)" )
otherUIList[37]:SetShow( false )


local otherTextList = {
	[CppEnums.InteractionType.InteractionType_HavestLop]			= PAGetString( Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_4" ), -- "먹이관리",
	[CppEnums.InteractionType.InteractionType_HavestKillBug]		= PAGetString( Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_5" ), -- "기생충잡기",
	[CppEnums.InteractionType.InteractionType_HarvestInformation]	= PAGetString( Defines.StringSheet_GAME, "LUA_INTERACTIONBUTTON_NAME_DOMESTICANIMALINFO" ), -- "가축정보보기",
}

local otherFunctionList = {
	[32] = function(actor, index) --[["Button_Lop"]] 
		--if ( "고급 재배용 후추" == actor:get():getStaticStatusName() ) then
		--	return otherUIList._livestock_info, otherTextList._livestock_info
		--end

		if ( nil == actor ) then
			return getDefaultButtonInfo(actor, index)
		end
		local installationActorWrapper = getInstallationActorByProxy( actor:get() )
		if ( nil == installationActorWrapper ) then
			return getDefaultButtonInfo(actor, index)
		end
		local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()

		if ( CppEnums.InstallationType.eType_LivestockHarvest ~= installationType ) then
			return getDefaultButtonInfo(actor, index)
		end

		if ( nil == otherUIList[index] ) or ( nil == otherTextList[index] ) then
			return getDefaultButtonInfo(actor, index)
		end
		
		return otherUIList[CppEnums.InteractionType.InteractionType_HavestLop], otherTextList[CppEnums.InteractionType.InteractionType_HavestLop]
	end,
	[33] = function(actor, index) --[["Button_KillBug"]] 
		--if ( "고급 재배용 후추" == actor:get():getStaticStatusName() ) then
		--	return otherUIList._livestock_info, otherTextList._livestock_info
		--end

		if ( nil == actor ) then
			return getDefaultButtonInfo(actor, index)
		end
		local installationActorWrapper = getInstallationActorByProxy( actor:get() )
		if ( nil == installationActorWrapper ) then
			return getDefaultButtonInfo(actor, index)
		end
		local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()

		if ( CppEnums.InstallationType.eType_LivestockHarvest ~= installationType ) then
			return getDefaultButtonInfo(actor, index)
		end

		if ( nil == otherUIList[index] ) or ( nil == otherTextList[index] ) then
			return getDefaultButtonInfo(actor, index)
		end
		
		return otherUIList[CppEnums.InteractionType.InteractionType_HavestKillBug], otherTextList[CppEnums.InteractionType.InteractionType_HavestKillBug]
	end,
	[37] = function(actor, index) --[["Button_HarvestInformation"]] 
		--if ( "고급 재배용 후추" == actor:get():getStaticStatusName() ) then
		--	return otherUIList._livestock_info, otherTextList._livestock_info
		--end

		if ( nil == actor ) then
			return getDefaultButtonInfo(actor, index)
		end
		local installationActorWrapper = getInstallationActorByProxy( actor:get() )
		if ( nil == installationActorWrapper ) then
			return getDefaultButtonInfo(actor, index)
		end
		local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()

		if ( CppEnums.InstallationType.eType_LivestockHarvest ~= installationType ) then
			return getDefaultButtonInfo(actor, index)
		end

		if ( nil == otherUIList[index] ) or ( nil == otherTextList[index] ) then
			return getDefaultButtonInfo(actor, index)
		end
		
		return otherUIList[CppEnums.InteractionType.InteractionType_HarvestInformation], otherTextList[CppEnums.InteractionType.InteractionType_HarvestInformation]
	end,
}

local getButtonInfo = function(actor, index)
	if ( nil ~= otherFunctionList[index] ) then
		return otherFunctionList[index](actor, index)
	end
	return getDefaultButtonInfo(actor, index)
end

local updateButtonList = function(actor)
	for key, value in pairs(interactionTargetUIList) do
		value:SetShow(false)
	end
	interactionTargetUIList = {}
	interactionTargetTextList = {}
	for ii = 0, #UI_BUTTON do
		interactionTargetUIList[ii], interactionTargetTextList[ii] = getButtonInfo(actor, ii)
	end
end

--수렵 조련 버튼 감추기
UI.getChildControl( Panel_Interaction, "Button_Hunting" ):SetShow(false);
UI.getChildControl( Panel_Interaction, "Button_VehicleTraining" ):SetShow(false);

local UI_NAME = UI.getChildControl( Panel_Interaction, "Static_Text_CharacterName" )
local UI_DESC = UI.getChildControl( Panel_Interaction, "Static_Icon_Font" )

local INTERACTABLE_ACTOR_KEY	= 0
local INTERACTABLE_FRAG			= 0

local SHOW_BUTTON_COUNT			= 0
local ANIMATING_BUTTON			= false
local BUTTON_UPDATE_TIME		= 0

local basicInteractionType		= 0;
local focusInteractionType		= 0;
local isFocusInteractionType	= false;

local isTargetNpc				= false  

---------------------------
-- Functions
---------------------------

--인터렉션을 보여줄수있는 상태인지 체크하는 함수
local interactionShowableCheck = function(actor)
	if ( nil == actor ) then
		return
	end
	--if ( actor:get():isNpc() ) then
	--	local characterActor = getCharacterActor( actor:getActorKey() )
	--	if ( false == characterActor:hasDialog() ) then
	--		return false
	--	end
	--end
	return true;
end


local interactionTutorial = true
-- 매 프레임 업데이트 되는 함수임
function Interaction_Update( deltaTime )
	local selfPlayer = getSelfPlayer()
	
	if (selfPlayer == nil) or selfPlayer:isDead() or Panel_Looting:GetShow() or true == Panel_Window_Exchange:GetShow() or Defines.UIMode.eUIMode_Default ~= GetUIMode() then
		Interaction_Close()
		return
	end

	local actor				= interaction_getInteractable()
	local actorKey			= 0
	local interactableFrag	= nil

	if actor ~= nil then
		actorKey			= actor:getActorKey()
		interactableFrag	= actor:getInteractableFrag()
	end

	if (actorKey ~= INTERACTABLE_ACTOR_KEY) or (interactableFrag ~= INTERACTABLE_FRAG) then
		INTERACTABLE_ACTOR_KEY	= actorKey
		INTERACTABLE_FRAG		= interactableFrag

		if (interactionShowableCheck(actor)) then
			Interaction_Show( actor )
		else
			Interaction_Close()
			return
		end
	end

	if nil ~= actor then
		Interaction_PositionUpdate( actor )
		
		if Panel_Interaction:GetShow() and ANIMATING_BUTTON then
			Interaction_ButtonPositionUpdate( deltaTime )
		end
	end
	
	Interaction_UpdatePerFrame_Desc();
end

function interaction_Forceed()
	local actor				= interaction_getInteractable()
	local actorKey			= 0
	local interactableFrag	= 0

	if  nil ~= actor then
		actorKey				= actor:getActorKey()
		interactableFrag		= actor:getInteractableFrag()

		INTERACTABLE_ACTOR_KEY	= actorKey
		INTERACTABLE_FRAG		= interactableFrag

		if (interactionShowableCheck(actor)) then
			Interaction_Show( actor )
		else
			Interaction_Close()
		end
		Interaction_PositionUpdate( actor )
		Interaction_ButtonPositionUpdate( 0 )
	else
		return
	end
end

------------------------------------------------------
--				하단부 사이즈 가져오기
------------------------------------------------------
local GetBottomPos = function(control)
	if ( nil == control ) then
		UI.ASSERT(false, "GetBottomPos(control) , control nil")
		return
	end
	return control:GetPosY() + control:GetSizeY()
end


-- 인터랙션 대상이 바뀌었을때만 호출된다.
-- 매 프레임 호출되지 않으니 안심...
local YSize = 0
local linkButtonAction = {}

function Interaction_Show( actor )
	-- ♬ 인터렉션이 떴을 때 사운드 추가
	audioPostEvent_SystemUi(01,05)
	
	local firstInteractionType = actor:getSettedFirstInteractionType()
	basicInteractionType = firstInteractionType;
	focusInteractionType = firstInteractionType;
	
	if DESC_TEXT[ firstInteractionType ] == nil then
		--UI.debugMessage( "Interaction 불가 캐릭터" )
		return
	end
	
	-- 다른 플레이어 들이 모두 안보여지는 경우 인터랙션 메뉴도 안 보여준다.
	--local visibleMode = getVisibleCharacterMode();
	--if( CppEnums.VisibleCharacterMode.eVisibleCharacterMode_Housing == visibleMode ) then
	--	if( actor:get():isPlayer() ) then
	--		return;
	--	end
	--end
	
	------------------------------------------------------------
	-- 				구매할 수 있는 집일 경우
	local houseShow = false
	if ( actor:get():isHouseHold() ) then
		local houseHoldActor = getHouseHoldActor( actor:getActorKey() )
		-- local houseName = houseHoldActor:get():getHouseholdName()
			-- UI.debugMessage("houseName : " .. tostring(houseName) )
		
		if ( houseHoldActor:get():isBuyable() ) then
			audioPostEvent_SystemUi(01,05)
			
			houseShow = true
		end
	end
	Panel_Interaction_House:SetShow( houseShow )
	Panel_Interaction:SetShow( true )
	--------------------------------------------------------------------------------
	-- 			레벨이 낮은 녀석에겐 상호작용 하는 법을 가르쳐줘야겠지?
	local actor				= interaction_getInteractable()
	local actorKey			= 0
	local interactableFrag	= 0
	

	local actorName = actor:getName()
	
	--	시체 설치 수집물은 따로 표시
	if (actor:get():isInstallationActor() or actor:get():isDeadBody() or actor:get():isCollect()) then
		if (not actor:get():isMonster()) then
			actorName = actor:get():getStaticStatusName()
		end
		isTargetNpc = false
	elseif actor:get():isNpc() then
		local npcTitle = actor:getCharacterTitle()
		if nil == npcTitle or "" == npcTitle then
			actorName = actor:getName()
		else
			actorName = npcTitle .. "\n" .. actor:getName()
		end
		
		isTargetNpc = true
	elseif actor:get():isHouseHold() then
		if( actor:getCharacterStaticStatusWrapper():getObjectStaticStatus():isPersonalTent() ) then
			actorName = actor:getCharacterStaticStatusWrapper():getName()
		else
			actorName = actor:getAddress()
		end
		isTargetNpc = false
	end
	
	if actorName then
		if isTargetNpc then
			UI_NAME		:SetSize( 130, UI_NAME:GetSizeY() )
			UI_NAME		:SetPosX( -65 )
		else
			UI_NAME		:SetSize( 100, UI_NAME:GetSizeY() )
			UI_NAME		:SetPosX( -56 )
		end
		UI_NAME:SetTextHorizonCenter()
		UI_NAME:SetTextVerticalTop()
		UI_NAME:SetAutoResize( true )
		UI_NAME:SetText( actorName )
		
		-- UI_NAME:SetPosY( _background:GetPosY() + ( _background:GetSizeY()/2) - ( 15 * ( math.floor(UI_NAME:GetLineCount()/2 + 0.5)) ) )
	else
		UI.ASSERT( false, "Interaction_Show // Actor Name is Nil!!!!" )
	end
	
	UI_DESC:SetText( DESC_TEXT[ firstInteractionType ] )

	-- 보여야할 버튼만 보여주고 개수를 센다
	updateButtonList(actor)
	SHOW_BUTTON_COUNT = 0
	for ii = 0, #interactionTargetUIList do
		local isShow = actor:isSetInteracatbleFrag( ii )

		interactionTargetUIList[ii]:SetShow( isShow )

		if( isShow ) then
			-- 인터랙션 메뉴의 텍스트를 변경해야할 경우 이렇게 해본다(?)
			if( CppEnums.InteractionType.InteractionType_Observer == ii ) then	
				local isLean = "LEAN_BACK_ING"
				if ToClient_SelfPlayerCheckAction( isLean ) then
					FGlobal_Tutorial_RequestLean()
				end

				local isSitDown = "SIT_DOWN_ING"
				if ToClient_SelfPlayerCheckAction( isSitDown ) then
					FGlobal_Tutorial_RequestSitDown()
				end
			end

			local shortcuts = SHOW_BUTTON_COUNT
			if 0 == SHOW_BUTTON_COUNT then
				if CppEnums.InteractionType.InteractionType_InvitedParty == ii or CppEnums.InteractionType.InteractionType_GuildInvite == ii or CppEnums.InteractionType.InteractionType_ExchangeItem == ii then
					interactionTargetUIList[ii]:SetText( interactionTargetTextList[ii] ) 
				else
					interactionTargetUIList[ii]:SetText( interactionTargetTextList[ii] .. " <PAColor0xFFFFD543>(" .. keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ) .. ")<PAOldColor>" ) 	
				end
				
				interactionTargetUIList[ii]:SetFontColor( UI_Color.C_FFEFEFEF )
			else
				interactionTargetUIList[ii]:SetText( interactionTargetTextList[ii] .. " <PAColor0xFFFFD543>(F" .. shortcuts .. ")<PAOldColor>" ) 
				interactionTargetUIList[ii]:SetFontColor( UI_Color.C_FF999999 )
			end
			linkButtonAction[SHOW_BUTTON_COUNT] = ii	-- 글로벌 키바인더 다른 단축키용 저장.
			
			SHOW_BUTTON_COUNT = SHOW_BUTTON_COUNT + 1
		end
	end
	
	-- 인터랙션 튜토리얼 체크용(인터랙션 튜토리얼 했냐? 대화 버튼이 켜져 있냐? 7레벨 이하냐? 인터랙션 튜토리얼을 보여줄거냐?)
	if ( true == interactionTutorial ) and ( true == actor:isSetInteracatbleFrag( 4 )) and ( 7 > getSelfPlayer():get():getLevel()) and ( true == isInteractionTutorial()) then
		FGlobal_InteractionTutorialShow()
		interactionTutorial = false
	end
	
	-- 완료한 퀘스트 아이콘이 떠있을 경우, 대화 버튼 텍스처를 바꿔준다.
	local npcActorProxyWrapper = getNpcActor(actor:getActorKey())
	if nil ~= npcActorProxyWrapper then
		local currentType = npcActorProxyWrapper:get():getOverHeadQuestInfoType()
		if ( true == actor:isSetInteracatbleFrag( 4 )) and ( 3 == currentType ) then
			interactionTargetUIList[4]:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Interaction/Interaction_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( interactionTargetUIList[4], 1, 106, 35, 140 )
			interactionTargetUIList[4]:getBaseTexture():setUV( x1, y1, x2, y2 )
			interactionTargetUIList[4]:setRenderTexture(interactionTargetUIList[4]:getBaseTexture())
			UI_NAME:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "INTERACTION_TEXT_COMPLETE_QUEST", "actionInputType", keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ) ) ) -- "<" .. keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ) .. ">키를 눌러 의뢰를\n완료하세요." )
		else
			interactionTargetUIList[4]:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/Interaction/Interaction_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( interactionTargetUIList[4], 1, 1, 35, 35 )
			interactionTargetUIList[4]:getBaseTexture():setUV( x1, y1, x2, y2 )
			interactionTargetUIList[4]:setRenderTexture(interactionTargetUIList[4]:getBaseTexture())
		end
	end
	
	------------------------------------------------------------
	-- 		상호작용 이벤트가 있을 경우 표시해준다!
	------------------------------------------------------------
	_globalGuide:SetPosX( 60 )
	_globalGuide:SetPosY( Panel_Interaction:GetSizeY() * 0.5 - _globalGuide:GetSizeY() * 0.5 )

	_needCollectTool:SetShow( false )
	
	-- 채집
	Interaction_UpdateDesc( firstInteractionType );
	
	-- 버튼 위치 초기화
	ANIMATING_BUTTON = true	
	BUTTON_UPDATE_TIME = 0
	Interaction_ButtonPositionUpdate( 0 )

	isReloadState = false

	--가구 인터랙션 체크
	local actorKeyRaw = actor:get():getActorKeyRaw()
	Furniture_Check( actorKeyRaw )
end

function FGlobal_InteractionButtonCount()
	return SHOW_BUTTON_COUNT
end

function FGlobal_InteractionButtonActionRun( keyIdx )
	Interaction_ButtonPushed( linkButtonAction[keyIdx] )
end

function Panel_Interaction_GetGlobalGuidePosX()
	return   Panel_Interaction:GetPosX() + _globalGuide:GetPosX()
end

function Panel_Interaction_GetGlobalGuidePosY()
	return Panel_Interaction:GetPosY() +  _globalGuide:GetPosY()
end

function Interaction_Close()
	--if Panel_Window_ServantInventory:GetShow() then
	--	FGlobal_ServantInventory_Hide()
	--end

	--UI.debugMessage( "Interaction 감추기!!" )
	if Panel_Interaction:IsShow() or Panel_Interaction_House:IsShow() then
		-- ♬ 인터렉션이 사라졌을 때 사운드 추가
		
		Panel_Interaction:SetShow( false )
		Panel_Interaction_House:SetShow( false )
		INTERACTABLE_ACTOR_KEY = 0
		INTERACTABLE_FRAG = 0
		_globalGuide:SetShow( false )
		
		Panel_Interaction_HouseRanke_Close()
		FriendHouseRank_Close()
	end
	
	Funiture_Endurance_Hide()
end

-- 인터랙션 UI 패널 자체의 위치를 업데이트 하는 함수
-- 인터랙션 가능한 액터가 있으면 매 프레임 호출됨
function Interaction_PositionUpdate( actor )

	local pos2d = actor:get2DPosForInterAction();
	if ( pos2d.x < 0 ) and ( pos2d.y < 0 ) then
		if ( Panel_Interaction_House:IsShow() ) then
			Panel_Interaction_House:SetPosX( -1000 )
			Panel_Interaction_House:SetPosY( -1000 )
		end
		Panel_Interaction:SetPosX( -1000 )
		Panel_Interaction:SetPosY( -1000 )
	else
		if ( Panel_Interaction_House:IsShow() ) then
			Panel_Interaction_House:SetPosX( pos2d.x - Panel_Interaction_House:GetSizeX() / 2 )
			Panel_Interaction_House:SetPosY( pos2d.y + 100 )
		end
		Panel_Interaction:SetPosX( pos2d.x + 0 )
		Panel_Interaction:SetPosY( pos2d.y - 100 )
	end
end

-- 버튼 위치를 업데이트
-- 인터랙션 패널이 보이고 설정한 애니메이션 시간 동안에만 업데이트 됨
function Interaction_ButtonPositionUpdate( deltaTime )

	local ANIMATION_TIME	= 0.35					-- 애니메이션이 돌아가는 시간(초)

	local BUTTON_OFFSET_X	= 0					-- 원의 중심 위치 X
	local BUTTON_OFFSET_Y	= 0					-- 원의 중심 위치 Y
	local CIRCLE_RADIUS		= 0					-- 원의 반지름

	
	if isTargetNpc then								-- NPC 일 때만 크게 보인다.
		_background	:SetSize( 140, 140 )
		BUTTON_OFFSET_X		= -18.0					-- 원의 중심 위치 X
		BUTTON_OFFSET_Y		= 42.0					-- 원의 중심 위치 Y
		CIRCLE_RADIUS		= 60.0					-- 원의 반지름
	else
		_background	:SetSize( 128, 128 )
		BUTTON_OFFSET_X		= -25.0					-- 원의 중심 위치 X
		BUTTON_OFFSET_Y		= 35.0					-- 원의 중심 위치 Y
		CIRCLE_RADIUS		= 50.0					-- 원의 반지름
	end
	-- 크기에 대한 정렬 때문에 이곳에서 사이즈를 설정한다.

	UI_NAME:SetPosY( _background:GetPosY() + ( _background:GetSizeY()/2) - UI_NAME:GetSizeY()*0.5 )-- ( 15 * ( math.floor(UI_NAME:GetLineCount()/2 + 0.5)) ) )

	local ANGLE_OFFSET		= math.pi * -0.5		-- 처음 버튼이 시작되는 위치(현재 설정값이 12시 방향임, 0이면 3시 방향)


	if BUTTON_UPDATE_TIME > ANIMATION_TIME then
		ANIMATING_BUTTON = false
	else

		BUTTON_UPDATE_TIME = BUTTON_UPDATE_TIME + deltaTime
		local aniRate = BUTTON_UPDATE_TIME / ANIMATION_TIME
		if aniRate > 1 then
			aniRate = 1
		end

		local actor = interaction_getInteractable()

		-- 버튼의 위치를 결정한다.
		local jj = 0
		for ii = 0, #interactionTargetUIList do
			local isShow = actor:isSetInteracatbleFrag( ii )
			--local isShow = true
			--local isShow = ii == 1 or ii == 2 or ii == 3 or ii == 4 or ii == 5

			if isShow then
				local div = jj / SHOW_BUTTON_COUNT
				local buttonPosX = BUTTON_OFFSET_X + ( ( CIRCLE_RADIUS * aniRate ) * math.cos( ( math.pi * 2 * div * aniRate ) + ANGLE_OFFSET ) )
				local buttonPosY = BUTTON_OFFSET_Y + ( ( CIRCLE_RADIUS * aniRate ) * math.sin( ( math.pi * 2 * div * aniRate ) + ANGLE_OFFSET ) )

				interactionTargetUIList[ii]:SetPosX( buttonPosX )
				interactionTargetUIList[ii]:SetPosY( buttonPosY )
				interactionTargetUIList[ii]:SetAlpha( aniRate )
				_needCollectTool:SetPosX( buttonPosX +2 )
				_needCollectTool:SetPosY( buttonPosY +2)

				local verticalSize	= interactionTargetUIList[ii]:GetSizeY()
				if buttonPosY < BUTTON_OFFSET_Y then
					verticalSize = verticalSize * -(1/2)
				end
				interactionTargetUIList[ii]:SetTextSpan( 0, verticalSize )

				if math.floor(buttonPosX) == math.floor(BUTTON_OFFSET_X) then
					interactionTargetUIList[ii]:SetTextHorizonCenter()
				elseif buttonPosX < BUTTON_OFFSET_X then
					interactionTargetUIList[ii]:SetTextHorizonRight()
				elseif BUTTON_OFFSET_X < buttonPosX then
					interactionTargetUIList[ii]:SetTextHorizonLeft()
				end

				jj = jj + 1
			end
		end
	
	end

end

function Interaction_Reset()

	INTERACTABLE_ACTOR_KEY = 0

end

-- 버튼 핸들러
function Interaction_ButtonPushed( interactionType )

	--[[
	if BUTTON_ONCLICK_CLOSE[interactionType] then
		Interaction_Close()
	end
	]]
	preUIMode = GetUIMode()

	local isTakedownCannon = false
	local isTakedownCannonFuncPass = function()
		interaction_processInteraction( interactionType )
	end
	
	if CppEnums.InteractionType.InteractionType_TakedownCannon == interactionType then
		isTakedownCannon = true	-- 아래 조건문에서 걸리게 만든다.

	elseif ( CppEnums.InteractionType.InteractionType_Talk == interactionType ) then
		SetUIMode( Defines.UIMode.eUIMode_NpcDialog )   -- 컷신이나 대화시 월드맵을 열 경우 충돌이 나는 문제 수정을 위해 대화창은 여기서 모드를 변경한다.

	elseif CppEnums.InteractionType.InteractionType_InvitedParty == interactionType then
		local actor	= interaction_getInteractable()
		if ( nil == actor ) then
			return
		else
			local targetName	= actor:getName()
			Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INTERACTION_ACK_INVITE", "targetName", targetName ) ) -- targetName .. " 님을 파티에 초대했습니다.
		end

	elseif CppEnums.InteractionType.InteractionType_UseItem == interactionType and true == isCurrentPositionInWater() then
	   NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "LUA_USEITEM_INTERACTION_IN_WATER" ) )
	   return

	end

	if isTakedownCannon then
		local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
		local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "INTERACTION_TEXT_TAKEDOWN_CANNON") -- "대포 가방에 있는 아이템은 삭제됩니다. 이대로 회수하시겠습니까?"
		local messageBoxData = { title = messageTitle, content = messageBoxMemo, functionYes = isTakedownCannonFuncPass, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		interaction_processInteraction( interactionType )
	end
end

function FromClient_InteractionFail()
	--dialog_exitButton(false)
	SetUIMode( preUIMode )
end

function Interaction_ButtonOver( interactionType, isOver )
	local button = interactionTargetUIList[interactionType]
	button:ResetVertexAni()
	button:SetColor( UI_Color.C_FFFFFFFF )
	
	if( nil == button ) then
		return
	end

	if( isOver ) then
		-- ♬ 버튼에 마우스를 올려놓았을 때 사운드 추가
		audioPostEvent_SystemUi(00,13)
	
		button:SetVertexAniRun("Ani_Color_Light", true )
		button:SetFontAlpha( 1.0 )
	else
		-- ♬ 버튼에 마우스를 내려놓았을 때 사운드 추가
		-- audioPostEvent_SystemUi(00,00)
		
		button:ResetVertexAni()
		button:SetFontAlpha( 1.0 )
	end
	
	isFocusInteractionType = isOver;
	if isOver then
		focusInteractionType = interactionType;
		Interaction_UpdateDesc( interactionType );
	else
		focusInteractionType = basicInteractionType;
		Interaction_UpdateDesc( focusInteractionType );
	end
end

function Interaction_UpdatePerFrame_Desc ()
	if (focusInteractionType == CppEnums.InteractionType.InteractionType_Sympathetic) then
		Interaction_UpdateDesc(focusInteractionType);
	elseif (focusInteractionType == CppEnums.InteractionType.InteractionType_Observer) then
		Interaction_UpdateDesc(focusInteractionType);
	end
	
	local actor				= interaction_getInteractable();
	if actor == nil then
		return;
	end

	if actor:isSetInteracatbleFrag( CppEnums.InteractionType.InteractionType_Sympathetic ) then
		local vehicleWrapper = getVehicleActor( actor:get():getActorKeyRaw() );
		if vehicleWrapper ~= nil then
			isSympatheticEnable = vehicleWrapper:checkUsableSympathetic();
			interactionTargetUIList[ CppEnums.InteractionType.InteractionType_Sympathetic ]:SetMonoTone( not isSympatheticEnable );
			
			if false == isFocusInteractionType then
				if (not isSympatheticEnable) then
					if (focusInteractionType == basicInteractionType) then
						focusInteractionType = CppEnums.InteractionType.InteractionType_Sympathetic;
					end
				else
					focusInteractionType = basicInteractionType;
				end
			end
		end
	end
end

function Interaction_UpdateDesc ( indteractionType )
	local actor				= interaction_getInteractable();
	if actor == nil then
		return;
	end
	
	if not actor:isSetInteracatbleFrag( indteractionType ) then
		return;
	end
	
	local interactionDesc;
	if (indteractionType == basicInteractionType and (not actor:get():isPlayer() or actor:get():isSelfPlayer()) ) then
		interactionDesc = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INTERACTION_PURPOSE_0", "interactionkey", keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ), "interaction", interactionTargetTextList[indteractionType] )
	else
		interactionDesc = DESC_TEXT[indteractionType];
	end

	if (indteractionType == CppEnums.InteractionType.InteractionType_Collect) then	
		if( actor:get():isCollect() or  actor:get():isDeadBody() )then
			local collectWrapper = getCollectActor(actor:getActorKey())
			if( nil == collectWrapper ) then
				collectWrapper = getMonsterActor(actor:getActorKey());
				if( nil == collectWrapper ) then
					collectWrapper = getDeadBodyActor(actor:getActorKey());
					if( nil == collectWrapper ) then
						_PA_ASSERT(false, "채집인터랙션을 수행중인데 대상이 채집물이 아닙니다. 비정상임")
						return
					end
				end
			end			
			-- 채집 불가능할 경우 필요 채집 도구를 띄워준다.
			if( collectWrapper:isCollectable() and (false == collectWrapper:isCollectableUsingMyCollectTool()) ) then
				_needCollectTool:SetShow( true )
				
				interactionDesc = "";
				for loop = 0, CppEnums.CollectToolType.TypeCount, 1 do
					local isAble = collectWrapper:getCharacterStaticStatusWrapper():isCollectableToolType(loop)
					
					if( isAble ) then
						if( 0 < string.len(interactionDesc) )	then	
							interactionDesc = "<PAColor0xFFFFD649>'".. interactionDesc .."'<PAOldColor>, <PAColor0xFFFFD649>'" .. CppEnums.CollectToolTypeName[loop] .. "'<PAOldColor>"
						else
							interactionDesc = "<PAColor0xFFFFD649>'" .. CppEnums.CollectToolTypeName[loop] .. "'<PAOldColor>"
						end
					end
				end
				
				interactionDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_TEXT_NEEDGUIDE", "interactionDesc", interactionDesc) -- interactionDesc.." (이)가 필요합니다"
			end
		end	
	elseif (indteractionType == CppEnums.InteractionType.InteractionType_Sympathetic) then
		local isSympathetic = actor:isSetInteracatbleFrag( CppEnums.InteractionType.InteractionType_Sympathetic )
		if isSympathetic then
			local vehicleWrapper = getVehicleActor( actor:get():getActorKeyRaw() );
			if vehicleWrapper ~= nil then
				isSympatheticEnable = vehicleWrapper:checkUsableSympathetic();
				interactionTargetUIList[ CppEnums.InteractionType.InteractionType_Sympathetic ]:SetMonoTone( not isSympatheticEnable );
				
				if not isSympatheticEnable then
					local sympatheticCooltime = math.ceil(vehicleWrapper:getSympatheticCoolTime() / 1000.0) * 1000.0;
					interactionDesc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SYMPATHETIC_COOLTIME_DESC", "cooltime", convertStringFromMillisecondtime(toUint64(0,sympatheticCooltime)) ) --"교감을 다시 하려면 " .. sympatheticCooltime .. "초간 기다려야 합니다.."
				else
					interactionDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SYMPATHETIC_DESC");
				end
			end
		end
	elseif (indteractionType == CppEnums.InteractionType.InteractionType_Observer) then
		if isObserverMode() then
			if (indteractionType == basicInteractionType) then
				interactionDesc = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INTERACTION_PURPOSE_1", "interactionkey", keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ), "interaction", interactionTargetTextList[indteractionType] )
			else
				interactionDesc = DESC_TEXT[indteractionType];
			end
			-- Panel_WatchingMode:SetPosX( (getScreenSizeX() / 2) + 200 ) -- - (Panel_WatchingMode:GetSizeX() / 2) - 240 )
			-- Panel_WatchingMode:SetPosY( (getScreenSizeY() / 2) - (Panel_WatchingMode:GetSizeY()/2) ) -- - 150 )
			-- Panel_WatchingMode:SetShow( true )
			ShowCommandFunc()
			Panel_SkillCommand:SetShow( true, true )
		end
		Panel_SkillCommand:SetShow( false, false )
	end
	
	-- Panel_WatchingMode:ComputePos()
	_globalGuide:SetText( interactionDesc ) 
	_globalGuide:SetShow( true )
end

-- 관전모드 종료될 때 발생되는 이벤트
function FromClient_NotifyObserverModeEnd()
	Panel_WatchingMode:SetShow( false )
	Panel_SkillCommand:SetShow( true, true )
end

function FromClient_ConfirmInstallationBuff( currentEndurance )

	if MessageBox.isPopUp() then
		return;
	end

	local	messageBoxMemo	= PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_MSGBOX_MEMO_BUFF", "currentEndurance", tostring(currentEndurance)) -- "설비도구의 버프를 받으시겠습니까? \n 현재내구도(" ..tostring(currentEndurance).. ")";
	local	messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_MSGBOX_DATA_TITLE"), content = messageBoxMemo, functionYes = Interaction_InstallationBuff, functionNo = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end
function Interaction_InstallationBuff()
	toClient_RequestInstallationBuff()
end

registerEvent( "FromClient_InterAction_UpdatePerFrame", "Interaction_Update" )
registerEvent( "FromClient_ConfirmInstallationBuff", 	"FromClient_ConfirmInstallationBuff" )
registerEvent( "FromClient_InteractionFail",			"FromClient_InteractionFail" )
registerEvent( "FromClient_NotifyObserverModeEnd",		"FromClient_NotifyObserverModeEnd" )

----------------------------------------------------------------------------------------------------
--									HouseInterAction 추가에 따른 스테이트 고정
----------------------------------------------------------------------------------------------------
local isReloadState = true

local interactionReload = function()
	if ( false == isReloadState ) then
		Interaction_Close()
		return
	end

	local actor = interaction_getInteractable()
	if ( nil == actor ) then
		Interaction_Close()
		return
	end

	if ( actor:get():isHouseHold() ) then
		Panel_Interaction:SetShow( false )
		Panel_Interaction_House:SetShow( false )
		INTERACTABLE_ACTOR_KEY = 0
		INTERACTABLE_FRAG = 0
		_globalGuide:SetShow( false )
		if ( interactionShowableCheck(actor) ) then
			Interaction_Show( actor )
		else
			Interaction_Close()
		end
	end
end
UI.addRunPostRestorFunction( interactionReload )

function Interaction_SetReloadState()
	isReloadState = true;
	if ( false == isFlushedUI() ) then
		interactionReload()
	end
end

function FromClient_InteractionHarvest()
	--_PA_LOG("LUA", "FromClient_InteractionHarvest")
	interaction_setInteractingState(CppEnums.InteractionType.InteractionType_Havest)
end

function FromClient_InteractionSeedHarvest()
	--_PA_LOG("LUA", "FromClient_InteractionSeedHarvest")
	interaction_setInteractingState(CppEnums.InteractionType.InteractionType_SeedHavest)
end

-- 업그레이드를 할때 필요 아이템을 알려주면서, 확인창을 띄워준다.
local _buildingUpgradeActoKeyRaw = 0;
function FromClient_InteractionBuildingUpgrade( actorKeyRaw )
	
	local actorProxy = getActor( actorKeyRaw )
	if( nil == actorProxy ) then
		return;
	end
	
	local upgradeStaticWrapper = actorProxy:getCharacterStaticStatusWrapper():getBuildingUpgradeStaticStatus()
	if( nil == upgradeStaticWrapper ) then
		_PA_ASSERT(false, "FromClient_InteractionBuildingUpgrade --- upgradeStaticWrapper이 비어있습니다. " );
		return;
	end
	
	if( nil == upgradeStaticWrapper:getTargetCharacter() ) then
		_PA_ASSERT(false, "FromClient_InteractionBuildingUpgrade --- upgradeStaticWrapper:getTargetCharacter()이 비어있습니다. " );
		return;
	end
	
	local strNeedItems = upgradeStaticWrapper:getTargetCharacter():getName() .. "로 업그레이드하는데 "
	local	sourceItemCount = upgradeStaticWrapper:getSourceItemCount()
	for index = 0, sourceItemCount -1 do
		local iessw = upgradeStaticWrapper:getSourceItemEnchantStaticStatus(index)
		if(  nil ~= iessw ) then
			
			local name  = iessw:getName(); 
			local itemNeedCount = upgradeStaticWrapper:getSourceItemNeedCount(index)

			strNeedItems = strNeedItems .. " " .. name .. " " .. tostring(itemNeedCount) .. " " ;
		end
	end
	
	_buildingUpgradeActoKeyRaw	= actorKeyRaw
	
	local	messageBoxMemo	= strNeedItems .. "들이 업그레이드에 필요합니다. 진행하시겠습니까?"
	local	messageboxData	= { title = "업그레이드", content = messageBoxMemo, functionYes = InteractionBuildingUpgrade_Confirm, functionNo = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
	
end

function InteractionBuildingUpgrade_Confirm()
	toClient_RequestBuildingUpgrade( _buildingUpgradeActoKeyRaw )
end

registerEvent( "FromClient_ReceiveBuyHouse",		"Interaction_SetReloadState")
registerEvent( "FromClient_ReceiveChangeUseType",	"Interaction_SetReloadState")
registerEvent( "FromClient_ReceiveReturnHouse",		"Interaction_SetReloadState")
registerEvent( "FromClient_ReceiveSetMyHouse",		"Interaction_SetReloadState")
registerEvent( "FromClient_InteractionHarvest",		"FromClient_InteractionHarvest")
registerEvent( "FromClient_InteractionSeedHarvest",	"FromClient_InteractionSeedHarvest")

registerEvent( "FromClient_InteractionBuildingUpgrade",	"FromClient_InteractionBuildingUpgrade" )

------------------------------------------------------------------------
-- 						집 구매 버튼 출력용 함수
------------------------------------------------------------------------
local myContributeValue = Panel_Expgauge_MyContributeValue
local buyHouseButton = UI.getChildControl ( Panel_Interaction_House, "Button_BuyHouse" )
local houseInit = function()
	
	---------------------------------------
	-- 공헌도 0이면 집 구매를 할 수 없다
	if ( myContributeValue == 0 ) then
		buyHouseButton:SetFontColor( UI_Color.C_FFD20000 )
		buyHouseButton:addInputEvent( "Mouse_LUp", "" )
		buyHouseButton:addInputEvent( "Mouse_On", "Panel_Interaction_House_HelpDesc_Func( 0, true )" )
		buyHouseButton:addInputEvent( "Mouse_Out", "Panel_Interaction_House_HelpDesc_Func( 0, false )" )
	else
		buyHouseButton:SetFontColor( UI_Color.C_FFC4BEBE )
		buyHouseButton:addInputEvent( "Mouse_LUp", "FGlobal_OpenWorldMapWithHouse()" )
		buyHouseButton:addInputEvent( "Mouse_On", "Panel_Interaction_House_HelpDesc_Func( 1, true )" )
		buyHouseButton:addInputEvent( "Mouse_Out", "Panel_Interaction_House_HelpDesc_Func( 1, false )" )
	end
	
	_houseDesc:SetAutoResize( true )
	_houseDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_houseDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_HouseDesc") ) -- <PAColor0xFFFF9900>집 주소 : 벨리아 3번지<PAOldColor>\n
	_houseDescBG:SetSize( _houseDesc:GetSizeX()+ 13, _houseDesc:GetSizeY() + 10 )
	YSize = GetBottomPos( _houseDescBG )
	Panel_Interaction_House:SetSize( Panel_Interaction_House:GetSizeX(), YSize + 50 )
	buyHouseButton:ComputePos()
end

function Panel_Interaction_House_HelpDesc_Func( contribute, isOn )
	local mouse_posX = getMousePosX()
	local mouse_posY = getMousePosY()
	local panel_posX = Panel_Interaction_House:GetPosX()
	local panel_posY = Panel_Interaction_House:GetPosY()
	
	_contribute_Help:SetAlpha(0)
	if ( isOn == true ) and ( contribute == 0 ) then
		buyHouseButton:SetFontColor( UI_Color.C_FFF26A6A )
		_contribute_Help:SetAutoResize( true )
		_contribute_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_contribute_Help:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INTERACTION_ContributeHelp", "myContributeValue", myContributeValue ) )
		_contribute_Help:SetSize ( _contribute_Help:GetSizeX() + 5, _contribute_Help:GetSizeY() + 10 )
		
		-- _contribute_Help:SetPosX( mouse_posX - panel_posX  + 20 )
		_contribute_Help:SetPosY( Panel_Interaction_House:GetSizeY() )
		
		local aniInfo = UIAni.AlphaAnimation( 1, _contribute_Help, 0.0, 0.2 )
		_contribute_Help:SetShow(true)
	elseif ( isOn == false ) and ( contribute == 0 ) then
		buyHouseButton:SetFontColor( UI_Color.C_FFD20000 )
		_contribute_Help:SetSize ( 270, 100 )
		local aniInfo = UIAni.AlphaAnimation( 0, _contribute_Help, 0.0, 0.2 )
		aniInfo:SetHideAtEnd(true)
	end
	
	if ( isOn == true ) and ( contribute == 1 ) then
		buyHouseButton:SetFontColor( UI_Color.C_FFEFEFEF )
	elseif ( isOn == false ) and ( contribute == 1 ) then
		buyHouseButton:SetFontColor( UI_Color.C_FFC4BEBE )
	end
end


houseInit()