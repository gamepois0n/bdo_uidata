local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV			= CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE
local UCT			= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode
local UI_classType	= CppEnums.ClassType

--"Static_General"			일반
--"Static_Skill"			스킬교관
--"Static_Repair"			수리
--"Static_Store"			일반상점
--"Static_WareHouse"		창고?
--"Static_Trade"			무역상점
--"Static_WorkerShop"		--------- 일꾼 매매인 ( 지금 사용 x )
--"Static_Auction"			경매
--"Static_Inn"				여관
--"Static_Guild"			길드관련
--"Static_Intimacy"			지식인
--
--"Static_QuestIcon"		받을수있는 퀘스트 - 노랑 , 수행중인 퀘스트 - 파랑, 완료가능한 퀘스트 - 빨강 & 체크박스
--"Static_ImportantTalk"    중요대화 ( 말걸면 버튼을 눌러야 하는 대화 )
--"Static_FirstTalk"        대화안함 ( 한번 말걸면 없어짐 )

local ActorProxyType = {
	isActorProxy		= 0,
	isCharacter			= 1,
	isPlayer			= 2,
	isSelfPlayer		= 3,
	isOtherPlayer		= 4,
	isAlterego			= 5,
	isMonster			= 6,
	isNpc				= 7,
	isDeadBody			= 8,
	isVehicle			= 9,
	isGate				= 10,
	isHouseHold			= 11,
	isInstallationActor	= 12,
	isCollect			= 13,
	isInstanceObject	= 14,
}

-- 수정주의!! 
local actorProxyBufferSize = {
	--[ActorProxyType.isActorProxy]			= 0,
	--[ActorProxyType.isCharacter]			= 0,
	--[ActorProxyType.isPlayer]				= 0,
	[ActorProxyType.isSelfPlayer]			= 1,		-- 플레이어
	[ActorProxyType.isOtherPlayer]			= 300,		-- 다른 일반 플레이어
	--[ActorProxyType.isAlterego]				= 0,
	[ActorProxyType.isMonster]				= 150,		-- 몹
	[ActorProxyType.isNpc]					= 100,		-- NPC
	--[ActorProxyType.isDeadBody]				= 0,
	[ActorProxyType.isVehicle]				= 5,		-- 자기자신의 vehicle만 나오면 되니까 5개로해놓음
	--[ActorProxyType.isGate]					= 0,
	[ActorProxyType.isHouseHold]			= 30,		-- 집(문패)
	[ActorProxyType.isInstallationActor]	= 25,		-- 설치형
	--[ActorProxyType.isCollect]				= 0,
	[ActorProxyType.isInstanceObject]		= 50,		-- 임시 설치물
}

-- 수정주의!! 
local actorProxyCapacitySize = {
	--[ActorProxyType.isActorProxy]			= 0,
	--[ActorProxyType.isCharacter]			= 0,
	--[ActorProxyType.isPlayer]				= 0,
	[ActorProxyType.isSelfPlayer]			= 1,		-- 플레이어
	[ActorProxyType.isOtherPlayer]			= 50,		-- 다른 일반 플레이어
	--[ActorProxyType.isAlterego]				= 0,
	[ActorProxyType.isMonster]				= 25,		-- 몹
	[ActorProxyType.isNpc]					= 25,		-- NPC
	--[ActorProxyType.isDeadBody]				= 0,
	[ActorProxyType.isVehicle]				= 1,		-- 자기자신의 vehicle만 나오면 되니까 5개로해놓음
	--[ActorProxyType.isGate]					= 0,
	[ActorProxyType.isHouseHold]			= 5,		-- 집(문패)
	[ActorProxyType.isInstallationActor]	= 2,		-- 설치형
	--[ActorProxyType.isCollect]				= 0,
	[ActorProxyType.isInstanceObject]		= 4,		-- 임시 설치물
}

local basePanel = {
	--[ActorProxyType.isActorProxy]			= Panel_Copy_CharacterTag,
	--[ActorProxyType.isCharacter]			= Panel_Copy_CharacterTag,
	--[ActorProxyType.isPlayer]				= Panel_Copy_CharacterTag,
	[ActorProxyType.isSelfPlayer]			= Panel_Copy_SelfPlayer,
	[ActorProxyType.isOtherPlayer]			= Panel_Copy_OtherPlayer,
	--[ActorProxyType.isAlterego]				= Panel_Copy_CharacterTag,
	[ActorProxyType.isMonster]				= Panel_Copy_Monster,
	[ActorProxyType.isNpc]					= Panel_Copy_Npc,
	--[ActorProxyType.isDeadBody]				= Panel_Copy_CharacterTag,
	[ActorProxyType.isVehicle]				= Panel_Copy_Vehicle,
	--[ActorProxyType.isGate]					= Panel_Copy_CharacterTag,
	[ActorProxyType.isHouseHold]			= Panel_Copy_HouseHold,
	[ActorProxyType.isInstallationActor]	= Panel_Copy_Installation,
	--[ActorProxyType.isCollect]				= Panel_Copy_CharacterTag,
	[ActorProxyType.isInstanceObject]		= Panel_Copy_Installation,
}

-- 생활레벨 아이콘 텍스처
-- 0 : 채집, 1 : 낚시, 2 : 수렵, 3 : 요리, 4 : 연금, 5 : 가공, 6 : 조련, 7 : 무역, 8 : 재배, 9 전투, 10 재화, 11 붉은전장, 12 3:3매치(결투장)
local lifeContentCount = 13
local lifeContent =
{
	gathering	= 0,
	fishing		= 1,
	hunting		= 2,
	cook		= 3,
	alchemy		= 4,
	manufacture	= 5,
	horse		= 6,
	trade		= 7,
	growth		= 8,
	combat		= 9,
	money		= 10,
	battleField	= 11,
	match		= 12,
}

local lifeRankSetTexture = {}
for i = 0, lifeContentCount -1 do
	lifeRankSetTexture[i]	= {}
end

for index = 0, lifeContentCount -1 do
	for rankIndex = 1, 5 do
		lifeRankSetTexture[index][rankIndex] = { x1, y1, x2, y2 }
		lifeRankSetTexture[index][rankIndex].x1 = 2 + index * 38
		lifeRankSetTexture[index][rankIndex].y1 = 2 + (rankIndex-1) * 34
		lifeRankSetTexture[index][rankIndex].x2 = 39 + index * 38
		lifeRankSetTexture[index][rankIndex].y2 = 35 + (rankIndex-1) * 34
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 초기화
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local init = function()
	for _, value in pairs(ActorProxyType) do
		if( basePanel[value] ) then
		ToClient_SetNameTagPanel( value, basePanel[value]);
		if ( nil ~= actorProxyBufferSize[value] ) and ( nil ~= actorProxyCapacitySize[value] ) then
			ToClient_InitializeOverHeadPanelPool( value, actorProxyBufferSize[value], actorProxyCapacitySize[value] )
		end
	end
	end
end
init()


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--각종 도움 함수들
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local getControlProperty = function( panel, index )
	if ( index == CppEnums.SpawnType.eSpawnType_SkillTrainer ) then     --스킬트레이너
		return UI.getChildControl( panel, "Static_Skill" )
	
	elseif ( index == CppEnums.SpawnType.eSpawnType_ShopMerchant ) then --기본상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Potion ) then       --물약상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Weapon ) then       --무기상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Jewel ) then        --보석상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Furniture ) then    --가구상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Collect ) then      --재료상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Fish ) then         --물고기상인
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Worker ) then       --작업감독관
		return UI.getChildControl( panel, "Static_Store" )

	elseif ( index == CppEnums.SpawnType.eSpawnType_Alchemy ) then      --연금술사
		return UI.getChildControl( panel, "Static_Store" )
		
	elseif ( index == CppEnums.SpawnType.eSpawnType_Stable ) then       --마굿간
		return UI.getChildControl( panel, "Static_Stable" )
		
	elseif ( index == CppEnums.SpawnType.eSpawnType_WareHouse ) then    --창고지기
		return UI.getChildControl( panel, "Static_WareHouse" )
		
--	elseif ( index == CppEnums.SpawnType.eSpawnType_NormalNpc ) then    --기본NPC
--		return UI.getChildControl( panel, "Static_WorkerShop" )
	
	elseif ( index == CppEnums.SpawnType.eSpawnType_auction ) then      --경매인
		return UI.getChildControl( panel, "Static_Auction" )
		
	elseif ( index == CppEnums.SpawnType.eSpawnType_inn ) then          --여관주인
		return UI.getChildControl( panel, "Static_Inn" )
		
	elseif ( index == CppEnums.SpawnType.eSpawnType_guild ) then        --길드관리인
		return UI.getChildControl( panel, "Static_Guild" )
	
	elseif ( index == CppEnums.SpawnType.eSpawnType_intimacy ) then     --친밀도쌓을수있는NPC
		return UI.getChildControl( panel, "Static_Intimacy" )
	else
		return nil
	end
end

local sortCenterX = function( insertedArray )
	local size = {}
	local fullSize = 0
	local scaleBuffer = nil
	for key, value in pairs(insertedArray) do
		if ( value:GetShow() ) then
			scaleBuffer = value:GetScale()
			value:SetScale(1,1)
			local aSize = value:GetSizeX()
			size[key] = aSize
			fullSize = fullSize + aSize
		end
	end

	local leftSize = - fullSize / 2

	for key, value in pairs(insertedArray) do
		if ( value:GetShow() ) then
			leftSize = leftSize + size[key] /2
			value:SetSpanSize( leftSize, value:GetSpanSize().y)
			value:SetScale(scaleBuffer.x, scaleBuffer.y)
			leftSize = leftSize + size[key] /2
		end
	end
end

local guildMarkInit = function( guildMark)
	guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
	local x1, y1, x2, y2 = setTextureUV_Func( guildMark, 183, 1, 188, 6 )
	guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
	guildMark:setRenderTexture(guildMark:getBaseTexture())
end


-- 레벨당 몬스터 이름 색 바꾸기
local monsterLevelNameColor =
{
	4287993237,		-- -5 이하	0xFF959595
	4285643008,		-- -4		0xFF71B900
	4287816466,		-- -3		0xFF92E312
	4290966896,		-- -2		0xFFC2F570
	4292540333,		-- -1		0xFFDAF7AD
	4294967295,		--  0		0xFFFFFFFF
	4294954702,		-- 	1		0xFFFFCECE
	4294943137,		-- 	2		0xFFFFA1A1
	4294927717,		-- 	3		0xFFFF6565
	4294901760,		-- 	4		0xFFFF0000
	4287579626,		-- 	5 이상	0xFF8F45EA
}
local monsterLevelNameColorText = 
{
	"FF959595",
	"FF71B900",
	"FF92E312",
	"FFC2F570",
	"FFDAF7AD",
	"FFFFFFFF",
	"FFFFCECE",
	"FFFFA1A1",
	"FFFF6565",
	"FFFF0000",
	"FF8F45EA",
}
local playerlevelColor =
{
	"FFC8FFC8",		-- 0~9
	"FFC8FFC8",		-- 10~19
	"FFFFFFFF",		-- 20~29
	"FFFFE8BB",		-- 30~39
	"FFFFC960",		-- 40~49
	"FFFFAD10",		-- 50~59
	"FFFF8A00",		-- 60~69
	"FFFF6C00",		-- 70~79
	"FFFF4E00",		-- 80~89
	"FFE10000",		-- 90~99
}
local getColorBySelfPlayerLevel = function( level )
	if ( level < 0 ) then
		return playerlevelColor[1]
	elseif ( 100 <= level ) then
		return playerlevelColor[10]
	else
		return playerlevelColor[math.floor(level / 10) + 1]
	end
end

local getColorByMonsterLevel = function( playerLevel, monsterLevel )
	local levelDiff = (monsterLevel - playerLevel) + 6
	levelDiff = math.max( levelDiff, 1 )
	levelDiff = math.min( levelDiff, 11 )
	return monsterLevelNameColorText[levelDiff]
end

local setMonsterNameColor = function( playerLevel, monsterLevel, nameStatic, isDarkSpiritMonster )
	if ( isDarkSpiritMonster ) then
		nameStatic:SetFontColor( Defines.Color.C_FF6A0000 )
		return
	end

	-- 플레이어와 Monster 의 레벨차에 따라 몬스터 이름의 색상을 변경해준다!
	-- --5 레벨 ~ 5 레벨까지 존재한다! color 값을 배열에 넣었고, 배열의 범위가 1 ~ 11 이므로 이 범위내의 값이 되도록 한다
	local levelDiff = (monsterLevel - playerLevel) + 6
	levelDiff = math.max( levelDiff, 1 )
	levelDiff = math.min( levelDiff, 11 )
	nameStatic:SetFontColor( monsterLevelNameColor[levelDiff] )
end

local hideTimeType = 
{
	overHeadUI			= 0,
	preemptiveStrike	= 1,
	bubbleBox			= 2,
	murdererEnd			= 3,
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NameTag쪽에 show, text등을 설정하는 직접적인 함수들
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local settingName = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local nameTag = nil
	local actorProxy = actorProxyWrapper:get()
	if (nil == actorProxy) then
		return
	end
	if actorProxy:isKingOrLordTent() then
		nameTag = UI.getChildControl( targetPanel, "KingsCharacterName" )
	else
		nameTag = UI.getChildControl( targetPanel, "CharacterName" )
	end

	if ( nil == nameTag ) then
		return
	end
	
	local characterActorProxyWrapper = getCharacterActor( actorKeyRaw )
	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	
	local isShowForAlli = false
	if (actorProxy:isPlayer() and true == playerActorProxyWrapper:get():isHideCharacterName()) and (true == playerActorProxyWrapper:get():isShowNameWhenCamouflage()) and (getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey()) then
		isShowForAlli = true
	end	
	
	if (actorProxy:isPlayer() and characterActorProxyWrapper:get():isClientAI()) or ( actorProxy:isHiddenName() and false == actorProxy:isVehicle() and false == actorProxy:isFlashBanged() ) or true == isShowForAlli then
		nameTag:SetShow(false)
		return
	end	

	if actorProxy:isHouseHold() then
		local houseActorWarpper = getHouseHoldActor( actorKeyRaw )
		local isMine 	= houseActorWarpper:get():isOwnedBySelfPlayer()
		local isMyGuild = houseActorWarpper:get():isOwnedBySelfPlayerGuild()
		
		local isPersonalTent	= houseActorWarpper:get():isPersonalTent();
		local isSiegeTent		= houseActorWarpper:get():isKingOrLordTent();
		
		if( isMine and isPersonalTent) then
			local tentWrapper = getTemporaryInformationWrapper():getSelfTentWrapperByActorKeyRaw( actorKeyRaw )
			if	(nil ~= tentWrapper) then
				local expireTime = tentWrapper:getSelfTentExpiredTime_s64();
				local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime));
			
				textName = getHouseHoldName( actorProxy ) .. " " .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_HOUSEHOLDNAME", "lefttimeText", lefttimeText ) -- ( <PAColor0xFFffe157>철거까지 남은 시간 : <PAColor0xFFff8787>" .. lefttimeText .. " <PAOldColor>)"
				targetPanel:Set3DRotationY( actorProxy:getRotation() )
			end
		
		elseif( isMyGuild and isSiegeTent ) then
				local expireTime	= houseActorWarpper:get():getExpiredTime();
				local lefttimeText	= convertStringFromDatetime(getLeftSecond_TTime64(expireTime));
				local builddingInfo = ToClient_getBuildingInfo(actorKeyRaw)
				local buildProgress	= builddingInfo:getBuildingProgress()
				if buildProgress < 1 then
					textName = getHouseHoldName( actorProxy ) .. " " .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_HOUSEHOLDNAME", "lefttimeText", lefttimeText ) -- ( <PAColor0xFFffe157>철거까지 남은 시간 : <PAColor0xFFff8787>" .. lefttimeText .. " <PAOldColor>)"
				else
					textName = getHouseHoldName( actorProxy )
				end
				targetPanel:Set3DRotationY( actorProxy:getRotation() )
		else
			textName = getHouseHoldName( actorProxy )
			targetPanel:Set3DRotationY( actorProxy:getRotation() )
		end
		
	elseif actorProxy:isInstallationActor() then
		textName = actorProxy:getStaticStatusName()

		local installationActorWrapper = getInstallationActor( actorKeyRaw )
		if( toInt64(0, 0) ~= installationActorWrapper:getOwnerHouseholdNo_s64() ) then	
			if installationActorWrapper:isHavestInstallation() then
				local rate = installationActorWrapper:getHarvestTotalGrowRate() * 100.0;
				
				if (rate < 0.0) then
					rate = 0.0					
				end				
				
				textName = installationActorWrapper:get():getStaticStatusName() .. " - (<PAColor0xFFffd429>" .. tostring( math.floor(rate) ) .. "%<PAOldColor>)"
			end
		end

	elseif isNpcWorker(actorProxy) then
		textName = getNpcWorkerOwnerName( actorProxy )
	elseif actorProxy:isSelfPlayer() then
		local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)

		if ( false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() ) then
			nameTag:SetMonoTone(true)
		else
			nameTag:SetMonoTone(false)
		end		
		
		local level = playerActorProxyWrapper:get():getLevel()
		--textName = "<PAColor0x".. getColorBySelfPlayerLevel(level) ..">Lv".. playerActorProxyWrapper:get():getLevel() .. ".<PAOldColor> " .. playerActorProxyWrapper:getName()
		textName = playerActorProxyWrapper:getName()

	elseif actorProxy:isPlayer() then
		local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)

		if ( false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() ) then
			nameTag:SetMonoTone(true)
		else
			nameTag:SetMonoTone(false)
		end		

		local level = playerActorProxyWrapper:get():getLevel()

		local selfPlayerLevel = getSelfPlayer():get():getLevel()
		
		--textName = "<PAColor0x".. getColorBySelfPlayerLevel(level) ..">Lv".. playerActorProxyWrapper:get():getLevel() .. ".<PAOldColor> " .. playerActorProxyWrapper:getName()
		textName = actorProxyWrapper:getName()
	elseif actorProxy:isInstanceObject() then
		if actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isTrap() then
			nameTag:SetShow(false)
			return;
		end
		textName = actorProxyWrapper:getName()
	elseif actorProxy:isNpc() then
		textName = actorProxyWrapper:getName()
		
		-- 모닥불일 경우 자신과 팀 번호가 같으면 자신의 것 혹은 파티의 것이다.
		local isFusionCore = actorProxy:getCharacterStaticStatus():isFusionCore() 
		if ( true == isFusionCore ) then		
			local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
			if ( npcActorProxyWrapper:getTeamNo_s64() == getSelfPlayer():getTeamNo_s64() ) then
				textName = textName
			else
				textName = "" -- 남의 것은 이름을 보여주지 않는다.
			end
		end
		
	else
		textName = actorProxyWrapper:getName()
	end

	nameTag:SetText( textName )
	nameTag:SetShow(true)
end

local settingAlias = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	if nil == playerActorProxyWrapper then
		return
	end

	local aliasInfo = UI.getChildControl( targetPanel, "CharacterAlias" )	-- 타이틀로 사용.
	if nil == aliasInfo then
		return
	end
	
	local actorProxy = playerActorProxyWrapper:get()
	if nil == actorProxy then
		return
	end
	
	if actorProxy:isPlayer() then
		if playerActorProxyWrapper:checkToTitleKey() then
			aliasInfo:SetText(playerActorProxyWrapper:getTitleName())
			
			if ( false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() ) then
				aliasInfo:SetMonoTone(true)
			else
				aliasInfo:SetMonoTone(false)
			end	
			
			local isShowForAlli = false
			if (true == actorProxy:isHideCharacterName()) and (true == actorProxy:isShowNameWhenCamouflage()) and (getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey()) then
				isShowForAlli = true
			end
			
			if actorProxy:isHideCharacterName() and false == actorProxy:isFlashBanged() or true == isShowForAlli then
				aliasInfo:SetShow(false)
			else
				aliasInfo:SetShow(true)
				aliasInfo:SetFontColor( 4282695908 )
				aliasInfo:useGlowFont( true, "BaseFont_10_Glow", 4278456421 )	-- GLOW:칭호
			end
		else
			aliasInfo:SetShow(false)
		end
	else
		aliasInfo:SetShow(false)
	end
end

local settingTitle = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local actorProxy = actorProxyWrapper:get()
	if ( false == actorProxy:isPlayer() ) and ( false == actorProxy:isMonster() ) and ( false == actorProxy:isNpc() ) then
		return
	end

	local nickName = UI.getChildControl( targetPanel, "CharacterTitle" )

	if ( nil  == nickName ) then
		return 
	end
	
	nickName:SetShow( false )
	
	if actorProxy:isPlayer() then
		local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
		if ( nil == playerActorProxyWrapper ) then
			return 
		end
		
		if ( false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() ) then
			nickName:SetMonoTone(true)
		else
			nickName:SetMonoTone(false)
		end				
		
		local isShowForAlli = false
		if true == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
			isShowForAlli = true
		end
		
		if ( playerActorProxyWrapper:get():isHideCharacterName() and false == playerActorProxyWrapper:get():isFlashBanged() or true == isShowForAlli ) then
			return
		end
		
		local vectorC = {x, y, z, w}
		vectorC = playerActorProxyWrapper:getAllyPlayerColor()
		local allyColor = 256*256*256*255 + math.floor(256*256*255*vectorC.x) + math.floor(256*255*vectorC.y) + math.floor(255*vectorC.z)

		if ( string.len( playerActorProxyWrapper:getUserNickname() ) > 0 ) then			
			if vectorC.w > 0 then
				nickName:SetFontColor( 4293914607 )
				nickName:useGlowFont( false )
				nickName:useGlowFont( true, "BaseFont_10_Glow", allyColor )	-- GLOW:가문이름
			else
				nickName:SetFontColor( 4293914607 )
				nickName:useGlowFont( false )
				nickName:useGlowFont( true, "BaseFont_10_Glow", 4278190080 )	-- GLOW:가문이름
			end
			nickName:SetText( playerActorProxyWrapper:getUserNickname() )
			nickName:SetShow( true )
			-- nickName:useGlowFont( true, "BaseFont_10_Glow", 4278190080 )	-- GLOW:가문이름
		end
	else
		if ( string.len( actorProxyWrapper:getCharacterTitle() ) > 0 ) then
			nickName:SetText( actorProxyWrapper:getCharacterTitle() )
			nickName:SetSpanSize( 0, 20 )
			nickName:SetShow( true )
			nickName:useGlowFont( false )
		end
	end
end

local settingFirstTalk = function( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
	local firstTalk = UI.getChildControl( targetPanel, "Static_FirstTalk" )
	if ( nil == firstTalk ) then
		return
	end

	local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
	if ( nil == npcActorProxyWrapper ) then
		return
	end

	firstTalk:SetShow( npcActorProxyWrapper:get():getFirstTalkable() )
	insertedArray:push_back(firstTalk)
end

local settingImportantTalk = function( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
	local importantTalk = UI.getChildControl( targetPanel, "Static_ImportantTalk" )
	if ( nil == importantTalk ) then
		return
	end

	local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
	if ( nil == npcActorProxyWrapper ) then
		return
	end

	local isShow = npcActorProxyWrapper:get():getImportantTalk()
	importantTalk:SetShow( isShow )
	if ( isShow ) then
		insertedArray:push_back(importantTalk)
	end
end

local settingOtherHeadIcon = function( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
	local characterKeyRaw = actorProxyWrapper:getCharacterKeyRaw()

	local npcActorProxyWrapper = getNpcActor(actorKeyRaw)

	if ( nil == npcActorProxyWrapper ) then
		return;
	end

	

	local npcData = getNpcInfoByCharacterKeyRaw(characterKeyRaw, npcActorProxyWrapper:get():getDialogIndex())
	if (nil ~= npcData) then
		for index = 0 , CppEnums.SpawnType.eSpawnType_Count -1 do
			local aControl = getControlProperty( targetPanel, index )
			local isOn = npcData:hasSpawnType(index)
			if ( nil ~= aControl ) then
				aControl:SetShow(false)
				if ( isOn ) then
					aControl:SetShow(true)
					insertedArray:push_back(aControl)
				end
				
			end
		end
	end
end

-- 풀 로우풀	: 	FF0054FF =>	00,84,255 ->	255,255,255 =>	4278211839
-- 내츄럴		: 	FFCBCBCB => 				    			4291546059
-- 풀 카오틱	:	FFFF0000 => 255, 0, 0 ->	255,255,255  =>	4294901760
-- 성향은 -1,000,000 ~ +300,000
-- 255,0,0<- 255, 255, 255 -> 0,84,255

-- 길드성향 색변환
local guildTendencyColor = function( tendency )
	local r,g,b = 0,0,0
	local upValue = 300000
	local downValue = -1000000
	if 0 < tendency then
		local percents = tendency / upValue
		r = math.floor(255 -  255  * percents)
		g = math.floor(255 - (255-84) * percents)
		b = 255
	else
		local percents = tendency / downValue
		r = 255
		g = math.floor(255 - 255  * percents)
		b = math.floor(255 - 255  * percents)
	end
	local sumColorValue = 256 * 256 * 256 * 255 +  256 * 256  * r + 256 * g +  b
	return sumColorValue
end

-- 캐릭터명 색변환
local nameTendencyColor = function( tendency )
	local r,g,b = 0,0,0
	local upValue = 300000
	local downValue = -1000000
	if 0 < tendency then
		local percents = tendency / upValue
		r = math.floor(203 - 203 * percents)
		g = math.floor(203 - 203 * percents)
		b = math.floor(203 + 52 * percents)
	else
		local percents = tendency / downValue
		r = math.floor(203 + 52 * percents)
		g = math.floor(203 - 203 * percents)
		b = math.floor(203 - 203 * percents)
	end
	local sumColorValue = 256 * 256 * 256 * 255 +  256 * 256  * r + 256 * g +  b
	return sumColorValue
end

local settingGuildInfo = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	if nil == targetPanel then
		return
	end
	if ( false == actorProxyWrapper:get():isPlayer() ) then
		return
	end
	
	local guildName				= UI.getChildControl( targetPanel, "CharacterGuild" )
	local guildMark				= UI.getChildControl( targetPanel, "Static_GuildMark" )
	local guildOccupyIcon		= UI.getChildControl( targetPanel, "Static_Icon_GuildMaster" )
	-- local guildSubMasterIcon	= UI.getChildControl( targetPanel, "Static_Icon_GuildSubMaster" )
	local guildBack				= UI.getChildControl( targetPanel, "Static_GuildBackGround" )
	if ( nil == guildName ) or ( nil == guildMark ) or ( nil == guildOccupyIcon ) or ( nil == guildBack ) then
		return
	end

	guildOccupyIcon:SetIgnore(true)
	guildOccupyIcon:SetShow( false )
	local guildSpan = guildMark:GetSpanSize();
	guildOccupyIcon:SetSpanSize( guildSpan.x - (guildOccupyIcon:GetSizeX() / 2 ), 40)
	-- guildSubMasterIcon:SetIgnore(true)
	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	if ( nil == playerActorProxyWrapper ) then
		return 
	end
	local playerActorProxy = playerActorProxyWrapper:get()
	if ( nil == playerActorProxy ) then
		return 
	end
	
	local hasGuild		= (playerActorProxy:isGuildMember()) and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged() )
	
	if ( false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() ) then
		guildName:SetMonoTone(true)
		guildMark:SetMonoTone(true)
		guildBack:SetMonoTone(true)
	else
		guildName:SetMonoTone(false)
		guildMark:SetMonoTone(false)
		guildBack:SetMonoTone(false)
	end			
	
	local isShowForAlli = false
	if (true == playerActorProxyWrapper:get():isHideCharacterName()) and (true == playerActorProxyWrapper:get():isShowNameWhenCamouflage()) and (getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey()) then
		isShowForAlli = true
	end	
	
	if false == hasGuild or true == isShowForAlli then
		guildName:SetShow( false )
		guildMark:SetShow( false )
		guildBack:SetShow( false )
		return
	else
		guildName:SetShow( hasGuild )
		guildMark:SetShow( hasGuild )
		guildBack:SetShow( hasGuild )
	end	

	-- 테스트를 위해 남겨둡니다.
	if ( hasGuild ) then
		local guildNameText = playerActorProxyWrapper:getGuildName()

		guildName:useGlowFont( false )
		guildName:SetFontColor( 4293914607 )
		guildName:useGlowFont( true, "BaseFont_10_Glow", 4279004349 )	-- GLOW:길드 이름
		-- ★카오길드 색 변경 준비
		-- guildName:SetAutoResize( true )

		local guildGrade = ToClient_getGuildGrade(playerActorProxyWrapper:getGuildNo_s64())

		if ( CppEnums.GuildGrade.GuildGrade_Clan == guildGrade ) then
			-- guildName:SetFontColor( Defines.Color.C_FFC8FFC8 )
			guildMark:SetShow( false )
			guildBack:SetShow( false )
		else
			-- guildName:SetFontColor( guildTendencyColor( playerActorProxy:getGuildTendency():get() ) )
		end
		guildName:SetText( "<" .. guildNameText .. ">" )
		-- guildOccupyIcon:SetSpanSize( 0, guildName:GetSpanSize().y + guildOccupyIcon:GetSizeY() )

		local hasOccupyTerritory = playerActorProxy:isOccupyTerritory()
		if ( hasOccupyTerritory ) then
			guildOccupyIcon:SetShow( true )
			guildOccupyIcon:SetMonoTone( false )
		else
			local hasSiege	= ToClient_hasOccupyingMajorSiege( playerActorProxyWrapper:getGuildNo_s64() )-- ???
			if true == hasSiege then
				guildOccupyIcon:SetShow( true )
				guildOccupyIcon:SetMonoTone( true )
			else
				guildOccupyIcon:SetShow( false )
				guildOccupyIcon:SetMonoTone( false )
			end
		end

		local isSet = setGuildTexture( actorKeyRaw, guildMark )
		if ( false == isSet ) then
			guildMarkInit( guildMark )
		else
			guildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
			guildMark:setRenderTexture(guildMark:getBaseTexture())
		end

		if ( playerActorProxy:isGuildAllianceChair() ) then
			guildBack:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( guildBack, 1, 1, 43, 43 )
			guildBack:getBaseTexture():setUV(  x1, y1, x2, y2  )
			guildBack:setRenderTexture(guildBack:getBaseTexture())
		elseif ( playerActorProxy:isGuildMaster() ) then
			guildBack:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( guildBack, 87, 1, 129, 43 )
			guildBack:getBaseTexture():setUV(  x1, y1, x2, y2  )
			guildBack:setRenderTexture(guildBack:getBaseTexture())
		elseif ( playerActorProxy:isGuildSubMaster() ) then
			guildBack:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( guildBack, 44, 1, 86, 43 )
			guildBack:getBaseTexture():setUV(  x1, y1, x2, y2  )
			guildBack:setRenderTexture(guildBack:getBaseTexture())
		else
			guildBack:ChangeTextureInfoName("")
		end
	else
		guildOccupyIcon:SetShow( false )
		-- guildSubMasterIcon:SetShow( false )
		guildMarkInit( guildMark )
	end
end

local settingMonsterName = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local nameTag = UI.getChildControl( targetPanel, "CharacterName" )
	if ( nil == nameTag ) then
		return
	end

	-- 몬스터 이름 색을 바꿔주기 위한 조건 검사
	local monsterActorProxyWrapper = getMonsterActor( actorKeyRaw )
	if nil == monsterActorProxyWrapper then
		return
	end
		
	local monsterLevel = monsterActorProxyWrapper:get():getCharacterStaticStatus().level
	local selfPlayerLevel = getSelfPlayer():get():getLevel()
	setMonsterNameColor( selfPlayerLevel, monsterLevel, nameTag, monsterActorProxyWrapper:get():isDarkSpiritMonster() )
end

local settingLifeRankIcon = function( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
	if ( false == actorProxyWrapper:get():isPlayer() ) then
		return
	end
	if 0 < ToClient_GetMyTeamNoLocalWar() then	-- 붉은 전장에 참여 중이면 갱신하지 않는다.
		return
	end

	local lifeRankIcon = {}
	for i = 0, lifeContentCount -1 do
		lifeRankIcon[i] = nil
		lifeRankIcon[i] = UI.getChildControl( targetPanel, "Static_LifeRankIcon_" .. i )
		if ( nil == lifeRankIcon[i] ) then
			return
		end
		lifeRankIcon[i]:SetShow( false )
	end
	local iconSizeX = lifeRankIcon[0]:GetSizeX()
	local iconGap = 5

	local playerActorProxyWrapper = getPlayerActor( actorKeyRaw )
	if ( nil == playerActorProxyWrapper ) then
		return 
	end
	local playerActorProxy = playerActorProxyWrapper:get()
	if ( nil == playerActorProxy ) then
		return 
	end
	-- 라이프 레벨이 랭킹5에 들어있는지 체크
--{ 0~8
	local hasContentRank	= 0
	for lifeContentIndex = 0, lifeContent.growth do
		local hasRank	= FromClient_GetTopRankListForNameTag():hasRank( lifeContentIndex, actorKeyRaw )
		local rankNumer	= 0
		if FGlobal_LifeRanking_CheckEnAble( lifeContentIndex ) then
			if true == hasRank and lifeContentIndex < 9 then
				local rankNumer = FromClient_GetTopRankListForNameTag():getRank( lifeContentIndex, actorKeyRaw ) +1
				lifeContent[lifeContentIndex][rankNumer] = rankNumer
				
				lifeRankIcon[lifeContentIndex]:ChangeTextureInfoName( "new_ui_common_forlua/default/RankingIcon_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( lifeRankIcon[lifeContentIndex], lifeRankSetTexture[lifeContentIndex][rankNumer].x1, lifeRankSetTexture[lifeContentIndex][rankNumer].y1, lifeRankSetTexture[lifeContentIndex][rankNumer].x2, lifeRankSetTexture[lifeContentIndex][rankNumer].y2 )
				lifeRankIcon[lifeContentIndex]:getBaseTexture():setUV( x1, y1, x2, y2 )
				lifeRankIcon[lifeContentIndex]:setRenderTexture( lifeRankIcon[lifeContentIndex]:getBaseTexture())
				
				if ( false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() ) then
					lifeRankIcon[lifeContentIndex]:SetMonoTone(true)
				else
					lifeRankIcon[lifeContentIndex]:SetMonoTone(false)
				end
				
				local isShowForAlli = false
				if (true == playerActorProxy:isHideCharacterName()) and (true == playerActorProxy:isShowNameWhenCamouflage()) and (getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey()) then
					isShowForAlli = true
				end 
				
				if playerActorProxy:isPlayer() and playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() or true == isShowForAlli then
					lifeRankIcon[lifeContentIndex]:SetShow( false )
				else
					lifeRankIcon[lifeContentIndex]:SetShow( true )
				end

				insertedArray:push_back(lifeRankIcon[lifeContentIndex])
			end
		end
	end
--}
--{ 9: 레벨, 10: 재화, 11: 붉은 전장
	local rankerType = 0
	for lifeContentIndex = lifeContent.combat, lifeContent.battleField do
		hasContentRank = FromClient_GetTopRankListForNameTag():hasContentsRank(rankerType, actorKeyRaw)
		if FGlobal_LifeRanking_CheckEnAble( lifeContentIndex ) then
			if true == hasContentRank and 9 <= lifeContentIndex  then
				local rankNumer = FromClient_GetTopRankListForNameTag():getContentsRank( rankerType, actorKeyRaw ) +1
				lifeContent[lifeContentIndex][rankNumer] = rankNumer

				lifeRankIcon[lifeContentIndex]:ChangeTextureInfoName( "new_ui_common_forlua/default/RankingIcon_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( lifeRankIcon[lifeContentIndex], lifeRankSetTexture[lifeContentIndex][rankNumer].x1, lifeRankSetTexture[lifeContentIndex][rankNumer].y1, lifeRankSetTexture[lifeContentIndex][rankNumer].x2, lifeRankSetTexture[lifeContentIndex][rankNumer].y2 )
				lifeRankIcon[lifeContentIndex]:getBaseTexture():setUV( x1, y1, x2, y2 )
				lifeRankIcon[lifeContentIndex]:setRenderTexture( lifeRankIcon[lifeContentIndex]:getBaseTexture())
				
				if ( false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() ) then
					lifeRankIcon[lifeContentIndex]:SetMonoTone(true)
				else
					lifeRankIcon[lifeContentIndex]:SetMonoTone(false)
				end	
				
				local isShowForAlli = false
				if (true == playerActorProxy:isHideCharacterName()) and (true == playerActorProxy:isShowNameWhenCamouflage()) and (getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey()) then
					isShowForAlli = true
				end
				
				if playerActorProxy:isPlayer() and playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() or true == isShowForAlli then
					lifeRankIcon[lifeContentIndex]:SetShow( false )
				else
					lifeRankIcon[lifeContentIndex]:SetShow( true )
				end

				insertedArray:push_back(lifeRankIcon[lifeContentIndex])
			end
		end
		rankerType = rankerType + 1
	
	end
--}
--{ 0: 결투장, 1: 말레이스
	local matchType		= 0 -- 추후 matchType 1은 말레이스로 예약되어있다.....
	local hasMatchRank	= 0
	local isEnableContentsPvP = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 38 )
	hasMatchRank = FromClient_GetTopRankListForNameTag():hasMatchRank(matchType, actorKeyRaw)
	if true == hasMatchRank and isEnableContentsPvP then
		local rankNumer = FromClient_GetTopRankListForNameTag():getMatchRank( matchType, actorKeyRaw ) +1
		lifeContent[lifeContent.match][rankNumer] = rankNumer

		lifeRankIcon[lifeContent.match]:ChangeTextureInfoName( "new_ui_common_forlua/default/RankingIcon_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( lifeRankIcon[lifeContent.match], lifeRankSetTexture[lifeContent.match][rankNumer].x1, lifeRankSetTexture[lifeContent.match][rankNumer].y1, lifeRankSetTexture[lifeContent.match][rankNumer].x2, lifeRankSetTexture[lifeContent.match][rankNumer].y2 )
		lifeRankIcon[lifeContent.match]:getBaseTexture():setUV( x1, y1, x2, y2 )
		lifeRankIcon[lifeContent.match]:setRenderTexture( lifeRankIcon[lifeContent.match]:getBaseTexture())

		if ( false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() ) then
			lifeRankIcon[lifeContent.match]:SetMonoTone(true)
		else
			lifeRankIcon[lifeContent.match]:SetMonoTone(false)
		end		
		
		local isShowForAlli = false
		if (true == playerActorProxy:isHideCharacterName()) and (true == playerActorProxy:isShowNameWhenCamouflage()) and (getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey()) then
			isShowForAlli = true
		end		
		
		if playerActorProxy:isPlayer() and playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() or true == isShowForAlli then
			lifeRankIcon[lifeContent.match]:SetShow( false )
		else
			lifeRankIcon[lifeContent.match]:SetShow( true )
		end

		insertedArray:push_back(lifeRankIcon[lifeContent.match])
	end
--}
	local spanSizeY = 40
	local hasGuild		= (playerActorProxy:isGuildMember()) and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged())
	if ( hasGuild ) then
		spanSizeY = spanSizeY + 20
	end
	
	if playerActorProxy:isPlayer() then
		if playerActorProxyWrapper:checkToTitleKey() then
			spanSizeY = spanSizeY + 20
		end
	end
	sortCenterX(insertedArray)
end

local settingPlayerName = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local nameTag = UI.getChildControl( targetPanel, "CharacterName" )
	if ( nil == nameTag ) then
		return
	end

	-- 플레이어 이름 색을 바꿔주기 위한 조건 검사
	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	if nil == playerActorProxyWrapper then
		return
	end
	local playerActorProxy	= playerActorProxyWrapper:get()
	local playerTendency	= playerActorProxy:getTendency()
	-- playerActorProxy:getTendencyColorValue()

	if ( playerActorProxy:isPvpEnable() ) then
		nameTag:useGlowFont( false )
		nameTag:SetFontColor( 4293914607 )
		nameTag:useGlowFont( true, "BaseFont_10_Glow", nameTendencyColor( playerTendency ) )	-- GLOW:캐릭터 이름
	else
		nameTag:useGlowFont( false )
		nameTag:SetFontColor( 4294574047 )
		nameTag:useGlowFont( true, "BaseFont_10_Glow", 4283917312 )	-- GLOW:캐릭터 이름
	end
end

function isShowInstallationEnduranceType( installationType )

	if  (	(installationType == CppEnums.InstallationType.eType_Mortar) 
		or	(installationType == CppEnums.InstallationType.eType_Anvil)
		or	(installationType == CppEnums.InstallationType.eType_Stump)
		or	(installationType == CppEnums.InstallationType.eType_FireBowl)
		or	(installationType == CppEnums.InstallationType.eType_Buff)
		or	(installationType == CppEnums.InstallationType.eType_Alchemy)
		or	(installationType == CppEnums.InstallationType.eType_Havest)
		or	(installationType == CppEnums.InstallationType.eType_Bookcase)
		or	(installationType == CppEnums.InstallationType.eType_Cooking)
		or	(installationType == CppEnums.InstallationType.eType_Bed)
		) then
		return true;
	else 	
		return false;
	end
end

local isFourty = false
local isTwenty = false
local furnitureCheck = false

function ShowUseTab_Func()
	local targetPanel = getSelfPlayer():get():getUIPanel()
	if nil == targetPanel then
		return
	end
	local useTab	= UI.getChildControl( targetPanel, "StaticText_UseTab" )				-- TAB 누르세요

	if ( IsChecked_WeaponOut == true ) then
		useTab:SetShow( true )
	else
		useTab:SetShow( false )
	end
end

function HideUseTab_Func()
	local targetPanel = getSelfPlayer():get():getUIPanel()
	if nil == targetPanel then
		return
	end
	local useTab	= UI.getChildControl( targetPanel, "StaticText_UseTab" )				-- TAB 누르세요

	useTab:SetShow( false )
end

function FGlobal_ShowUseLantern( param )
	local targetPanel = getSelfPlayer():get():getUIPanel()
	if nil == targetPanel then
		return
	end
	local useLantern	= UI.getChildControl( targetPanel, "StaticText_UseLantern" )				-- 랜턴 사용하세요
	if true == param then
		useLantern:SetShow( true )
	else
		useLantern:SetShow( false )
	end
end

local settingHpBarInitState = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local actorProxy = actorProxyWrapper:get()
	if (nil == actorProxy) then
		return
	end

	local hpBack	= nil
	local hpLater	= nil
	local hpMain	= nil
	if actorProxy:isKingOrLordTent() then
		hpBack		= UI.getChildControl( targetPanel, "KingOrLordTentProgressBack" )		-- HP progress backStatic
		hpLater		= UI.getChildControl( targetPanel, "KingOrLordTentProgress2_HpLater" )	-- HP 따라오는 흰 게이지
		hpMain		= UI.getChildControl( targetPanel, "KingOrLordTentHPGageProgress" )		-- HP 게이지
	else
		hpBack		= UI.getChildControl( targetPanel, "ProgressBack" )						-- HP progress backStatic
		hpLater		= UI.getChildControl( targetPanel, "Progress2_HpLater" )				-- HP 따라오는 흰 게이지
		hpMain		= UI.getChildControl( targetPanel, "CharacterHPGageProgress" )			-- HP 게이지
	end

	local characterStaticStatus = actorProxy:getCharacterStaticStatus()

	if ( nil == hpBack ) or ( nil == hpLater ) or ( nil == hpMain ) or ( nil == characterStaticStatus ) then
		return
	end
	
	hpMain		:ResetVertexAni(true)
	hpLater		:ResetVertexAni(true)
	hpMain		:SetAlpha(1)
	hpLater		:SetAlpha(1)

	if( actorProxy:isSelfPlayer() ) then
		local hpAlert	= UI.getChildControl( targetPanel, "Static_nameTagGaugeAlert" )			-- Alert 게이지
		local usePotion	= UI.getChildControl( targetPanel, "StaticText_UsePotion" )				-- 물약 사용하세요

		hpAlert		:ResetVertexAni(true)
		hpAlert		:SetAlpha(1)
		usePotion	:SetShow( false )
	end
end

local settingHpBar = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local actorProxy = actorProxyWrapper:get()
	if (nil == actorProxy) then
		return
	end

	if false == ( actorProxy:isInstallationActor()
				or actorProxy:isMonster()
				or actorProxy:isSelfPlayer()
				or actorProxy:isPlayer()
				or actorProxy:isNpc()
				or actorProxy:isHouseHold()
				or actorProxy:isInstanceObject() ) then
		return
	end
	local isColorBlindMode	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)

	local hpBack	= nil
	local hpLater	= nil
	local hpMain	= nil
	if actorProxy:isKingOrLordTent() then
		hpBack		= UI.getChildControl( targetPanel, "KingOrLordTentProgressBack" )		-- HP progress backStatic
		hpLater		= UI.getChildControl( targetPanel, "KingOrLordTentProgress2_HpLater" )	-- HP 따라오는 흰 게이지
		hpMain		= UI.getChildControl( targetPanel, "KingOrLordTentHPGageProgress" )		-- HP 게이지
	else
		hpBack		= UI.getChildControl( targetPanel, "ProgressBack" )						-- HP progress backStatic
		hpLater		= UI.getChildControl( targetPanel, "Progress2_HpLater" )				-- HP 따라오는 흰 게이지
		hpMain		= UI.getChildControl( targetPanel, "CharacterHPGageProgress" )			-- HP 게이지
	end


	local characterStaticStatus = actorProxy:getCharacterStaticStatus()

	if ( nil == hpBack ) or ( nil == hpLater ) or ( nil == hpMain ) or ( nil == characterStaticStatus ) then
		return
	end

	-- 설비도구를 위한 임시 작업 todo: 설비도구의 isHiddenhp를 false로 설정한다.
	if ( characterStaticStatus._isHiddenHp and not actorProxy:isInstallationActor()) then
		hpBack	:SetShow(false)
		hpLater	:SetShow(false)
		hpMain	:SetShow(false)
		return
	end

	-- hpMain:SetColor( Defines.Color.C_FFF0EF9D )	-- HP 기본 색상 (노란)

	if actorProxy:isInstallationActor() then
		local installationActorWrapper = getInstallationActor( actorKeyRaw )
		
		hpBack	:SetShow(false)
		hpLater	:SetShow(false)
		hpMain	:SetShow(false)
				
		if Panel_Housing:IsShow() then
			return 
		end
		
		local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
		if false == isShowInstallationEnduranceType( installationType ) then
			return;
		end
		
		if( toInt64(0, 0) ~= installationActorWrapper:getOwnerHouseholdNo_s64() ) then	
			if installationActorWrapper:isHavestInstallation() then
				local prevRate = hpMain:GetProgressRate()								
				local rate = installationActorWrapper:getHarvestTotalGrowRate();
				
				if (rate > 1.0) then
					rate = 1.0		
				
				elseif (rate < 0.0) then
					rate = 0.0					
				end				
				
				rate = rate * 100.0;							
				
				local progressingInfo = installationActorWrapper:get():getInstallationProgressingInfo()
				local isWarning = false
				if ( nil ~= progressingInfo ) then
					isWarning = progressingInfo:getNeedLop() or progressingInfo:getNeedPestControl()
				end

				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
				local x1, y1, x2, y2
				if ( isWarning ) then
					x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )
				else
					x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 96, 255, 99 )
				end
				hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
				hpMain:setRenderTexture(hpMain:getBaseTexture())

				hpMain	:SetProgressRate( rate )
				hpLater	:SetProgressRate( rate )
				hpMain	:SetCurrentProgressRate( rate )
				hpLater	:SetCurrentProgressRate( rate )

				hpBack	:SetShow(true)
				hpLater	:SetShow(true)
				hpMain	:SetShow(true)
			else
				local curEndurance = installationActorWrapper:getEndurance()
				local maxEndurance = installationActorWrapper:getMaxEndurance()
			
				local prevRate = hpMain:GetProgressRate()
				local rate = curEndurance / maxEndurance * 100
				
				if ( rate < prevRate ) then
					hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
					hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
				elseif ( prevRate < rate ) then
					hpMain		:ResetVertexAni(true)
					hpLater		:ResetVertexAni(true)
					hpMain		:SetAlpha(1)
					hpLater		:SetAlpha(1)
				end

				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
				if ( rate < 5 ) then -- 5%보다 낮으면 빨간색으로 해준다.
					x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )
				else
					x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 96, 255, 99 )
				end

				hpMain	:SetProgressRate( rate )
				hpLater	:SetProgressRate( rate )
				
				if housing_isInstallMode() or ( true == furnitureCheck ) then
					hpBack	:SetShow(true)
					hpLater	:SetShow(true)
					hpMain	:SetShow(true)
				else
					hpBack	:SetShow(false)
					hpLater	:SetShow(false)
					hpMain	:SetShow(false)
				end
			end
		end			
	elseif actorProxy:isMonster() then
		local prevRate = hpMain:GetProgressRate()
		local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
		local characterActorProxyWrapper = getCharacterActor(actorKeyRaw)

		
		hpBack	:SetShow(true)
		hpLater	:SetShow(true)
		hpMain	:SetShow(true)

		if ( checkActiveCondition(characterActorProxyWrapper:getCharacterKey()) == true ) then			-- 몬스터에 대한 지식이 있을 경우 체크한다
			hpMain	:SetProgressRate( hpRate )
			hpLater	:SetProgressRate( hpRate )
			if ( hpRate < prevRate ) then
				hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
				hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
			elseif ( prevRate < hpRate ) then
				if ( hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() ) then
					hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
				end
				hpMain	:ResetVertexAni(true)
				hpLater	:ResetVertexAni(true)

				hpMain	:SetAlpha(1)
				hpLater	:SetAlpha(1)
			end

			hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 96, 255, 99 )
			hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
			hpMain:setRenderTexture(hpMain:getBaseTexture())
		else

			local x1, y1, x2, y2
			
			hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
			if ( hpRate > 75.0 ) then
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 96, 255, 99 )
			elseif ( hpRate > 50.0 ) then
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 100, 255, 103 )
			elseif ( hpRate > 25.0 ) then
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 104, 255, 107 )
			elseif ( hpRate > 10.0 ) then
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 108, 255, 111 )
			elseif ( hpRate > 5.0 ) then
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )
			else
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )
			end
			
			hpMain	:getBaseTexture():setUV(  x1, y1, x2, y2  )
			hpMain	:setRenderTexture(hpMain:getBaseTexture())
			hpMain	:SetProgressRate( 100 )
			hpLater	:SetProgressRate( 100 )
			hpMain	:SetCurrentProgressRate( 100 )
			hpLater	:SetCurrentProgressRate( 100 )
		end
	elseif actorProxy:isSelfPlayer() then
		
		local hpAlert	= UI.getChildControl( targetPanel, "Static_nameTagGaugeAlert" )			-- Alert 게이지
		local usePotion	= UI.getChildControl( targetPanel, "StaticText_UsePotion" )				-- 물약 사용하세요
		
		hpBack	:SetShow(true)
		hpLater	:SetShow(true)
		hpMain	:SetShow(true)

		hpMain:ChangeTextureInfoName( "New_UI_Common_forLua/Default/Default_Gauges.dds" )
		local x1, y1, x2, y2
		if ( 0 < RequestParty_getPartyMemberCount() ) then
			hpMain:ChangeTextureInfoName( "New_UI_Common_forLua/Default/Default_Gauges.dds" )
			x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 63, 233, 69 )
		else
			if (0 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "New_UI_Common_forLua/Default/Default_Gauges.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 96, 255, 99 )
			elseif (1 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			elseif (2 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			end
		end
		hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- hpMain:setRenderTexture(hpMain:getBaseTexture())
		
		local selfPlayerLevel = getSelfPlayer():get():getLevel()
		local prevRate = hpMain:GetProgressRate()
		local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
		if ( hpRate < prevRate ) then
			hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
			hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
		elseif ( prevRate < hpRate ) then
			hpMain	:ResetVertexAni(true)
			hpLater	:ResetVertexAni(true)
			hpMain	:SetAlpha(1)
			hpLater	:SetAlpha(1)
		end
		hpMain	:SetProgressRate( hpRate )
		hpLater	:SetProgressRate( hpRate )
		hpAlert	:ResetVertexAni(true)
		
		local x1, y1, x2, y2
		if 40 <= hpRate then
			if (0 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )	-- 원래 노란색	206, 96, 255, 99
			elseif (1 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			elseif (2 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			end
			hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )

			usePotion:SetShow( false )
			
			hpMain:ResetVertexAni(true)
			hpMain:SetAlpha( 1 )
			hpAlert:SetShow ( false )
			
		elseif 20 <= hpRate then
			if (0 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )	-- 원래 노란색	206, 96, 255, 99
			elseif (1 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			elseif (2 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			end
			hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )

			if ( 15 >= selfPlayerLevel ) then
				usePotion:SetShow( true )
			end
			
			hpMain	:SetVertexAniRun("Ani_Color_Damage_40", true)
			hpAlert:SetShow ( true )
			hpAlert:SetVertexAniRun ( "Ani_Color_nameTagAlertGauge0", true )
			
		else
			if (0 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )	-- 원래 노란색	206, 96, 255, 99
			elseif (1 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			elseif (2 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			end
			hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
			
			if ( 15 >= selfPlayerLevel ) then
				usePotion:SetShow( true )
			end
			
			hpMain	:SetVertexAniRun("Ani_Color_Damage_20", true)
			hpAlert:SetShow ( true )
			hpAlert:SetVertexAniRun ( "Ani_Color_nameTagAlertGauge1", true )
		end

		hpMain:setRenderTexture(hpMain:getBaseTexture())

	elseif actorProxy:isPlayer() then
		local prevRate	= hpMain:GetProgressRate()
		local isParty = Requestparty_isPartyPlayer(actorKeyRaw)
		local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
		local isArenaAreaOrZone = playerActorProxyWrapper:get():isArenaAreaRegion() or playerActorProxyWrapper:get():isArenaZoneRegion()
		local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()

		if ( hpRate < prevRate ) then
			hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
			hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
		elseif ( prevRate < hpRate ) then
			hpMain	:ResetVertexAni(true)
			hpLater	:ResetVertexAni(true)
			hpMain	:SetAlpha(1)
			hpLater	:SetAlpha(1)
		end

		hpMain	:SetProgressRate( hpRate )
		hpLater	:SetProgressRate( hpRate )

		local isShow = (false == actorProxy:isHideTimeOver(hideTimeType.overHeadUI)) or isParty or isArenaAreaOrZone
		hpMain:SetShow(true)
		hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
		hpMain:setRenderTexture(hpMain:getBaseTexture())

		hpBack	:SetShow(isShow)
		hpLater	:SetShow(isShow)
		hpMain	:SetShow(isShow)

		local x1, y1, x2, y2
		if ( isParty ) then
			hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
			x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 63, 233, 69 )		-- 푸른색
		else
			if (0 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 112, 255, 115 )	-- 원래 노란색	206, 96, 255, 99
			elseif (1 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			elseif (2 == isColorBlindMode) then
				hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
				x1, y1, x2, y2 = setTextureUV_Func( hpMain, 1, 247, 255, 250 )	-- 원래 노란색	206, 96, 255, 99
			end
			hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
		end
		hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
		hpMain:setRenderTexture(hpMain:getBaseTexture())

	elseif actorProxy:isNpc() then
		
		-- 모닥불일 경우 자신과 팀 번호가 같으면 자신의 것 혹은 파티의 것이다.
		local isShow = false;
		local isFusionCore = actorProxy:getCharacterStaticStatus():isFusionCore() 
		if ( true == isFusionCore ) then		
			local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
			if ( npcActorProxyWrapper:getTeamNo_s64() == getSelfPlayer():getTeamNo_s64() ) then
				isShow = true
			end
		end
		
		if ( isShow ) then
			local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
			local prevRate = hpMain:GetProgressRate()
			if ( hpRate < prevRate ) then
				hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
				hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
			elseif ( prevRate < hpRate ) then
				hpMain	:ResetVertexAni(true)
				hpLater	:ResetVertexAni(true)
				hpMain	:SetAlpha(1)
				hpLater	:SetAlpha(1)
			end
			hpMain	:SetProgressRate( hpRate )
			hpLater	:SetProgressRate( hpRate )
		end

		hpBack	:SetShow(isShow)
		hpLater	:SetShow(isShow)
		hpMain	:SetShow(isShow)
	elseif actorProxy:isHouseHold() then	-- 성채, 지휘소
		-- actorProxy:isKingOrLordTent() 성, 성채
		houseHoldActorWrapper = getHouseHoldActor( actorKeyRaw )
		if ( nil == houseHoldActorWrapper ) then
			return;
		end
		
		if false == ( houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isBarricade()
						or houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isKingOrLordTent() ) then
			return;
		end

		local prevRate = hpMain:GetProgressRate()
		local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
	
		if ( hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() ) then
			hpLater	:SetCurrentProgressRate( hpMain:GetCurrentProgressRate() )
			hpMain	:SetCurrentProgressRate( hpMain:GetCurrentProgressRate() )
		end

		if ( hpRate < prevRate ) then
			hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
			hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
		elseif ( prevRate < hpRate ) then
			hpMain	:ResetVertexAni(true)
			hpLater	:ResetVertexAni(true)
			hpMain	:SetAlpha(1)
			hpLater	:SetAlpha(1)
		end

		hpMain	:SetProgressRate( hpRate )
		hpLater	:SetProgressRate( hpRate )
		
		hpBack	:SetShow(true)
		hpLater	:SetShow(true)
		hpMain	:SetShow(true)
	elseif actorProxy:isInstanceObject() then
		if actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isBarricade() then
			local prevRate = hpMain:GetProgressRate()
			local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
			
			hpMain	:SetProgressRate( hpRate )
			hpLater	:SetProgressRate( hpRate )
			if ( hpRate < prevRate ) then
				hpMain	:SetVertexAniRun("Ani_Color_Damage_0", true)
				hpLater	:SetVertexAniRun("Ani_Color_Damage_White", true)
			elseif ( prevRate < hpRate ) then
				if ( hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() ) then
					hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
				end
				hpMain	:ResetVertexAni(true)
				hpLater	:ResetVertexAni(true)
				hpMain	:SetAlpha(1)
				hpLater	:SetAlpha(1)
			end

			--hpMain:ChangeTextureInfoName( "new_ui_common_forlua/default/default_gauges.dds" )
			--local x1, y1, x2, y2 = setTextureUV_Func( hpMain, 206, 96, 255, 99 )
			--hpMain:getBaseTexture():setUV(  x1, y1, x2, y2  )
			--hpMain:setRenderTexture(hpMain:getBaseTexture())
			
			hpBack	:SetShow(true)
			hpLater	:SetShow(true)
			hpMain	:SetShow(true)
		elseif actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isTrap() then
			hpBack	:SetShow(false)
			hpLater	:SetShow(false)
			hpMain	:SetShow(false)
		end
	else
		-- local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
		-- hpMain:SetProgressRate( hpRate )
		-- hpLater:SetProgressRate( hpRate )
	end
end

local settingMpBar = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local actorProxy = actorProxyWrapper:get()
	if (nil == actorProxy) then
		return
	end

	local isColorBlindMode	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
	local mpBack		= UI.getChildControl( targetPanel, "ProgressBack_ManaResource" )		-- HP progress backStatic
	local mpMain		= UI.getChildControl( targetPanel, "Character_ManaResource" )			-- HP 게이지

	if ( nil == mpBack ) or ( nil == mpMain ) then
		return
	end

	if actorProxy:isSelfPlayer() then
		local playerWrapper = getSelfPlayer()
		local mp	= playerWrapper:get():getMp()
		local maxMp = playerWrapper:get():getMaxMp()

		local mpRate = mp * 100 / maxMp

		mpMain	:SetProgressRate( mpRate )
		mpMain	:SetCurrentProgressRate( mpRate )

		local isEP_Character	= (UI_classType.ClassType_Ranger == playerWrapper:getClassType())
		local isFP_Character	= (UI_classType.ClassType_Warrior == playerWrapper:getClassType()) or  (UI_classType.ClassType_Giant == playerWrapper:getClassType())
			or (UI_classType.ClassType_BladeMaster == playerWrapper:getClassType()) or (UI_classType.ClassType_BladeMasterWomen == playerWrapper:getClassType())
			or (UI_classType.ClassType_NinjaWomen == playerWrapper:getClassType()) or (UI_classType.ClassType_NinjaMan == playerWrapper:getClassType())
		local isBP_Character	= (UI_classType.ClassType_Valkyrie == playerWrapper:getClassType())
		local isMP_Character	= (not isEP_Character) and (not isFP_Character) and (not isBP_Character)

		-- 정신력
		if isEP_Character then
			if (0 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFA3EF00 )
			elseif (1 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			elseif (2 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			end
		-- 투지
		elseif isFP_Character then
			if (0 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFFFCE22 )
			elseif (1 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			elseif (2 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			end
		-- MP
		elseif isBP_Character then	-- 발키리는 신성력이지만 투지 색상을 사용한다.
			if (0 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFFFCE22 )
			elseif (1 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			elseif (2 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			end
		elseif isMP_Character then
			if (0 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FF00A1FF )
			elseif (1 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			elseif (2 == isColorBlindMode) then
				mpMain:SetColor( Defines.Color.C_FFEE9900 )
			end
		end

		mpBack	:SetShow(true)
		mpMain	:SetShow(true)
	
	else
		mpBack	:SetShow(false)
		mpMain	:SetShow(false)
	end
end

local settingLocalWarCombatPoint = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	if nil == actorProxyWrapper then
		return
	end
	
	local actorProxy = actorProxyWrapper:get()
	if (nil == actorProxy) then
		return
	end
	
	if false == actorProxy:isPlayer() then
		return
	end

	local playerActorProxyWrapper	= getPlayerActor(actorKeyRaw)
	if ( nil == playerActorProxyWrapper ) then
		return 
	end

	local playerActorProxy = playerActorProxyWrapper:get()
	if ( nil == playerActorProxy ) then
		return 
	end

	local txt_WarPoint				= UI.getChildControl( targetPanel, "CharacterWarPoint" )	-- 없을 수 있다?
	local lifeIcon = {
		[0]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_0" ),
		[1]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_1" ),
		[2]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_2" ),
		[3]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_3" ),
		[4]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_4" ),
		[5]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_5" ),
		[6]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_6" ),
		[7]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_7" ),
		[8]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_8" ),
		[9]		= UI.getChildControl( targetPanel, "Static_LifeRankIcon_9" ),
		[10]	= UI.getChildControl( targetPanel, "Static_LifeRankIcon_10" ),
		[11]	= UI.getChildControl( targetPanel, "Static_LifeRankIcon_11" ),
		[12]	= UI.getChildControl( targetPanel, "Static_LifeRankIcon_12" ),
	}

	local warCombatPoint	= playerActorProxyWrapper:getLocalWarCombatPoint()
	if 0 < warCombatPoint then	-- 참가중이다.
		local hasTitle = false
		if playerActorProxyWrapper:checkToTitleKey() then
			if playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() then
				hasTitle = false
			else
				hasTitle = true
			end
		else
			hasTitle = false
		end

		local hasGuild	= (playerActorProxy:isGuildMember()) and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged() )
		local warPointPos = 0
		if true == hasTitle and true == hasGuild then
			warPointPos = 80
		elseif hasTitle ~= hasGuild then	-- (false == hasTitle and true == hasGuild) or (true == hasTitle and false == hasGuild)
			warPointPos = 60
		else
			warPointPos = 40
		end

		local nameColor			= nil
		if ( warCombatPoint < 50 ) then
			nameColor = UI_color.C_FFA1A1A1
		elseif ( warCombatPoint < 100 ) then
			nameColor = UI_color.C_FFFFFFFF
		elseif ( warCombatPoint < 150 ) then
			nameColor = UI_color.C_FFFFE050
		elseif ( warCombatPoint < 200 ) then
			nameColor = UI_color.C_FF75FF50
		elseif ( warCombatPoint < 250 ) then
			nameColor = UI_color.C_FF00FFD8
		elseif ( warCombatPoint < 300 ) then
			nameColor = UI_color.C_FFFF00D8
		elseif ( warCombatPoint < 350 ) then
			nameColor = UI_color.C_FFFF7200
		else
			nameColor = UI_color.C_FFFF0000
		end

		local scaleBuffer = txt_WarPoint:GetScale()
		txt_WarPoint:SetScale(1,1)
		txt_WarPoint:SetFontColor( nameColor )
		txt_WarPoint:SetText( "+" .. warCombatPoint )
		txt_WarPoint:SetShow( true )
		txt_WarPoint:SetSpanSize( txt_WarPoint:GetSpanSize().x, warPointPos )
		txt_WarPoint:SetScale(scaleBuffer.x, scaleBuffer.y)
		txt_WarPoint:ComputePos()
		for idx =0, 12 do
			lifeIcon[idx]:SetShow(false)
		end
	else
		txt_WarPoint:SetText( 0 )
		txt_WarPoint:SetShow( false )

		local insertedArray = Array.new()
		settingLifeRankIcon( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
	end
end

function FGlobal_SettingMpBarTemp()
	local selfPlayer = getSelfPlayer()
	if ( nil == selfPlayer ) then
		return
	end

	if ( nil == selfPlayer:get():getUIPanel() ) then
		return
	end
	settingMpBar( selfPlayer:get():getActorKeyRaw(), selfPlayer:get():getUIPanel(), selfPlayer )
end


local settingStun = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local stunBack		= UI.getChildControl( targetPanel, "ProgressBack_Stun" )			-- stun 게이지 background
	local stunProgress	= UI.getChildControl( targetPanel, "CharacterStunGageProgress" )	-- stun 게이지 progressbar
	
	if ( nil == stunBack ) or ( nil == stunProgress ) then
		return
	end
	local characterActorProxyWrapper = getCharacterActor(actorKeyRaw)
	if ( nil == characterActorProxyWrapper ) then
		return
	end
	local characterActorProxy = characterActorProxyWrapper:get()

	if ( characterActorProxy:hasStun() ) then
		local stun = characterActorProxy:getStun()
		local maxStun = characterActorProxy:getMaxStun()
		if ( 0 ~= stun ) then
			stunProgress:SetProgressRate( stun / maxStun * 100 )
			stunBack:SetShow(true)
			stunProgress:SetShow(true)
		else
			stunBack:SetShow(false)
			stunProgress:SetShow(false)
		end
	else
		stunBack:SetShow(false)
		stunProgress:SetShow(false)
	end
end

local settingGuildMarkAndPreemptiveStrike = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	if nil == targetPanel then
		return
	end
	if ( false == actorProxyWrapper:get():isPlayer() ) then
		return
	end
	if actorProxyWrapper:get():isPetProxy() or actorProxyWrapper:get():isHouseHold() then
		return
	end
	
	local preemptiveStrikeBeing	= UI.getChildControl( targetPanel, "Static_PreemptiveStrikeBeing" )
	local murdererMark			= UI.getChildControl( targetPanel, "Static_MurdererMark" )
	local guildBack				= UI.getChildControl( targetPanel, "Static_GuildBackGround" )
	local guildMark				= UI.getChildControl( targetPanel, "Static_GuildMark" )
	local guildMaster			= UI.getChildControl( targetPanel, "Static_Icon_GuildMaster" )

	local guildName				= UI.getChildControl( targetPanel, "CharacterGuild" )
	local nameTag				= UI.getChildControl( targetPanel, "CharacterName" )
	local title					= UI.getChildControl( targetPanel, "CharacterTitle" )
	local alias					= UI.getChildControl( targetPanel, "CharacterAlias" )

	if	   ( nil == guildName ) 
		or ( nil == guildBack ) 
		or ( nil == guildMark ) 
		or ( nil == nameTag ) 
		or ( nil == title ) 
		or ( nil == preemptiveStrikeBeing ) 
		or ( nil == murdererMark )
		or ( nil == actorProxyWrapper ) 
		or ( nil == alias ) 
		then

		return
	end
	
	local scaleBuffer = guildMark:GetScale()
	preemptiveStrikeBeing	:SetScale(1,1)
	murdererMark			:SetScale(1,1)
	guildMark				:SetScale(1,1)
	guildBack				:SetScale(1,1)
	guildMaster				:SetScale(1,1)
	guildName				:SetScale(1,1)
	nameTag					:SetScale(1,1)
	title					:SetScale(1,1)
	alias					:SetScale(1,1)

	local widthMax = guildName:GetTextSizeX()
	widthMax = math.max( widthMax, nameTag:GetTextSizeX() )
	widthMax = math.max( widthMax, title:GetTextSizeX() )
	if ( alias:GetShow() ) then
		widthMax = math.max( widthMax, alias:GetTextSizeX() )
	end

	local sizeMax = math.max( guildMark:GetSizeX(), guildBack:GetSizeX() ) / 2

	guildMark				:SetSpanSize( - widthMax / 2 - sizeMax, guildMark:GetSpanSize().y )
	guildBack				:SetSpanSize( - widthMax / 2 - sizeMax, guildBack:GetSpanSize().y )
	guildMaster				:SetSpanSize( - widthMax / 2 - sizeMax, guildMaster:GetSpanSize().y )
	preemptiveStrikeBeing	:SetSpanSize( widthMax / 2 + preemptiveStrikeBeing:GetSizeX() / 2 + 5, preemptiveStrikeBeing:GetSpanSize().y )

	local actorProxyWrapper = getActor(actorKeyRaw)
	local name				= actorProxyWrapper:getName()
	if ( preemptiveStrikeBeing:GetShow() ) then
		if "" ~= name then
			murdererMark		:SetSpanSize( (widthMax / 2) + murdererMark:GetSizeX() + (preemptiveStrikeBeing:GetSizeX() / 2) - 10, murdererMark:GetSpanSize().y )
		else
			murdererMark		:SetSpanSize( (widthMax / 2) - (murdererMark:GetSizeX()/2), murdererMark:GetSpanSize().y )
		end
	else
		if "" ~= name then
			murdererMark		:SetSpanSize( widthMax / 2 + murdererMark:GetSizeX() / 2 + 5, murdererMark:GetSpanSize().y )
		else
			murdererMark		:SetSpanSize( (widthMax / 2) - (murdererMark:GetSizeX()), murdererMark:GetSpanSize().y )
		end
	end


	preemptiveStrikeBeing	:SetScale(scaleBuffer.x, scaleBuffer.y)
	murdererMark			:SetScale(scaleBuffer.x, scaleBuffer.y)
	guildMark				:SetScale(scaleBuffer.x, scaleBuffer.y)
	guildBack				:SetScale(scaleBuffer.x, scaleBuffer.y)
	guildMaster				:SetScale(scaleBuffer.x, scaleBuffer.y)
	guildName				:SetScale(scaleBuffer.x, scaleBuffer.y)
	nameTag					:SetScale(scaleBuffer.x, scaleBuffer.y)
	title					:SetScale(scaleBuffer.x, scaleBuffer.y)
	alias					:SetScale(scaleBuffer.x, scaleBuffer.y)
end

-- 성향에 따른 pvp 아이콘 텍스처
local pvpIconTexture =
{
	[0] = { x1 = 4, y1 = 426, x2 = 36, y2 = 458 },
	[1] = { x1 = 37, y1 = 426, x2 = 69, y2 = 458 },
	[2] = { x1 = 70, y1 = 426, x2 = 102, y2 = 458 },
	[3] = { x1 = 103, y1 = 426, x2 = 135, y2 = 458 },
}
local preemptiveIconTexture =
{
	[0] = { x1 = 4, y1 = 391, x2 = 36, y2 = 423 },
	[1] = { x1 = 37, y1 = 391, x2 = 69, y2 = 423 },
	[2] = { x1 = 70, y1 = 391, x2 = 102, y2 = 423 },
	[3] = { x1 = 103, y1 = 391, x2 = 135, y2 = 423 },
}
local settingPreemptiveStrike = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local preemptiveStrikeBeing	= UI.getChildControl( targetPanel, "Static_PreemptiveStrikeBeing" )
	if ( nil == preemptiveStrikeBeing ) then
		return
	end

	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	if ( nil == playerActorProxyWrapper ) then
		return
	end
	
	-- 북미와 개발에서만 pvp 아이콘 다르게 표시
	local playerActorProxy = playerActorProxyWrapper:get()
	local isPvpModeOn = playerActorProxy:isPvPMode()
	local isShowPvpIcon = (playerActorProxy:isPreemptiveStrikeBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.preemptiveStrike)) or isPvpModeOn
	_PA_LOG("이문종", tostring(playerActorProxyWrapper:getName()) .. " : PvP 모드 - " .. tostring(isPvpModeOn) .. " / 선공 : " .. tostring((playerActorProxy:isPreemptiveStrikeBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.preemptiveStrike))))
	-- if isGameTypeEnglish() or isGameServiceTypeDev() then
		preemptiveStrikeBeing:SetShow( isShowPvpIcon )
		local tendencyColor = PvpIconColorByTendency( actorKeyRaw )
		if playerActorProxy:isPreemptiveStrikeBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.preemptiveStrike) then
			-- 텍스처 변경
			preemptiveStrikeBeing:ChangeTextureInfoName("New_UI_Common_ForLua/Default/Default_Buttons_02.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( preemptiveStrikeBeing, preemptiveIconTexture[tendencyColor].x1, preemptiveIconTexture[tendencyColor].y1, preemptiveIconTexture[tendencyColor].x2, preemptiveIconTexture[tendencyColor].y2 )
			preemptiveStrikeBeing:getBaseTexture():setUV( x1, y1, x2, y2 )
			preemptiveStrikeBeing:setRenderTexture(preemptiveStrikeBeing:getBaseTexture())
		else
			-- 텍스처 변경
			preemptiveStrikeBeing:ChangeTextureInfoName("New_UI_Common_ForLua/Default/Default_Buttons_02.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( preemptiveStrikeBeing, pvpIconTexture[tendencyColor].x1, pvpIconTexture[tendencyColor].y1, pvpIconTexture[tendencyColor].x2, pvpIconTexture[tendencyColor].y2 )
			preemptiveStrikeBeing:getBaseTexture():setUV( x1, y1, x2, y2 )
			preemptiveStrikeBeing:setRenderTexture(preemptiveStrikeBeing:getBaseTexture())
		end
	-- else
		-- preemptiveStrikeBeing:SetShow( playerActorProxy:isPreemptiveStrikeBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.preemptiveStrike) )
	-- end
	
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
end

function PvpIconColorByTendency( actorKeyRaw )
	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	if ( nil == playerActorProxyWrapper ) then
		return
	end
	
	local playerActorProxy = playerActorProxyWrapper:get()
	local tendency = playerActorProxy:getTendency()
	if 150000 <= tendency then
		tendencyColor = 0
	elseif 0 <= tendency and tendency < 150000 then
		tendencyColor = 1
	elseif -5000 <= tendency and tendency < 0 then
		tendencyColor = 2
	else
		tendencyColor = 3
	end
	
	return tendencyColor
end

local settingMurderer = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local murdererMark	= UI.getChildControl( targetPanel, "Static_MurdererMark" )
	if ( nil == murdererMark ) then
		return
	end

	local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
	if ( nil == playerActorProxyWrapper ) then
		return
	end
	local playerActorProxy = playerActorProxyWrapper:get()
	murdererMark:SetShow( playerActorProxy:isMurdererStateBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.murdererEnd) )
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
end

local settingGuildTextForAlias = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	if nil == targetPanel then
		return
	end

	local playerActorProxyWrapper	= getPlayerActor(actorKeyRaw)
	local guildName					= UI.getChildControl( targetPanel, "CharacterGuild" )
	local alias						= UI.getChildControl( targetPanel, "CharacterAlias" )
	local lifeRankIcon = {}
	for i = 0, lifeContentCount -1 do
		lifeRankIcon[i] = UI.getChildControl( targetPanel, "Static_LifeRankIcon_" .. i )
		if ( nil == lifeRankIcon[i] ) then
			return
		end
	end

	--nil 체크단계
	if	   ( nil == guildName ) 
		or ( nil == alias ) 
		or ( nil == playerActorProxyWrapper )
		then

		return
	end
	for i = 0, lifeContentCount -1 do
		if ( nil == lifeRankIcon[i] ) then
			return
		end
	end

	--스케일 조정단계
	local scaleBuffer = alias:GetScale()
	guildName	:SetScale(1,1)
	alias		:SetScale(1,1)
	for i = 0, lifeContentCount -1 do
		lifeRankIcon[i]:SetScale(1,1)
	end

	--스펜 대입단계
	local spanY = alias:GetSpanSize().y
	if playerActorProxyWrapper:checkToTitleKey() then
		spanY = spanY + alias:GetSizeY()
	end
	guildName	:SetSpanSize( guildName:GetSpanSize().x, spanY )

	if (playerActorProxyWrapper:get():isGuildMember()) and (false == playerActorProxyWrapper:get():isHideGuildName() or playerActorProxyWrapper:get():isFlashBanged()) then
		spanY = spanY + guildName:GetSizeY()
	end
	for i = 0, lifeContentCount -1 do
		lifeRankIcon[i]:SetSpanSize(lifeRankIcon[i]:GetSpanSize().x, spanY )
	end

	--스케일 원복단계
	guildName	:SetScale(scaleBuffer.x, scaleBuffer.y)
	alias		:SetScale(scaleBuffer.x, scaleBuffer.y)
	for i = 0, lifeContentCount -1 do
		lifeRankIcon[i]:SetScale(scaleBuffer.x, scaleBuffer.y)
	end
end

local settingQuestMark = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	local questMark = UI.getChildControl( targetPanel, "Static_Quest_Mark" )

	if ( nil == questMark ) then
		return
	end

	if isQuestMonsterByKey(actorKeyRaw) then
		questMark:SetShow(true)
	else
		questMark:SetShow(false)
	end

	-- local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
	-- if ( nil ~= gameOptionSetting ) then
	-- 	if ( not gameOptionSetting:getShowQuestActorColor() ) then
	-- 		questMark:SetShow(false)
	-- 	end
	-- end

end

local settingQuestMarkForce = function( isShow, targetPanel, actorProxyWrapper )
	local questMark = UI.getChildControl( targetPanel, "Static_Quest_Mark" )

	if ( nil == questMark ) then
		return
	end

	questMark:SetShow(isShow)

	-- local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
	-- if ( nil ~= gameOptionSetting ) then
	-- 	if ( not gameOptionSetting:getShowQuestActorColor() ) then
	-- 		questMark:SetShow(false)
	-- 	end
	-- end
	
	--RaderMap_ChangeQuestIcon(actorProxyWrapper)
end

function questIconOverTooltip( show, actorKeyRaw )
	local actorProxyWrapper			= getActor(actorKeyRaw)
	local npcActorProxyWrapper 		= getNpcActor(actorKeyRaw)
	local panel						= actorProxyWrapper:get():getUIPanel()
	local questStaticStatusWrapper	= npcActorProxyWrapper:getQuestStatisStatusWrapper()
	if nil == questStaticStatusWrapper then
		return
	end
	local questTitle				= questStaticStatusWrapper:getTitle()
	local questTitleTooltip			= UI.getChildControl( panel, "StaticText_QuestTooltip" )
	local questIcon					= UI.getChildControl( panel, "Static_QuestIcon" )

	if true == show then
		local prevScale = questIcon:GetScale()
		questTitleTooltip:SetScale(1,1)		
		questTitleTooltip:SetShow( true )
		questTitleTooltip:SetText( questTitle )
		questTitleTooltip:SetSize( questTitleTooltip:GetTextSizeX() + 20, questTitleTooltip:GetSizeY() )
		questTitleTooltip:SetSpanSize( questIcon:GetSpanSize().x , questTitleTooltip:GetSpanSize().y - 20 )
		questTitleTooltip:SetAlpha(1)
		questTitleTooltip:SetFontAlpha(1)
	else
		questTitleTooltip:SetShow( false )
	end
end

local currentTypeChangeCheck = {}			-- interaction 창이 열려 있는 상태에서 퀘스트가 완료로 바뀌었을 때, 변경된 상황을 체크하기 위한 변수. true면 interaction 창을 닫아 업데이트해준다.
local settingQuestUI = function( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
	local questIcon				= UI.getChildControl( targetPanel, "Static_QuestIcon" )
	local questBorder			= UI.getChildControl( targetPanel, "Static_QuestIconBorder" )
	local questClear			= UI.getChildControl( targetPanel, "Static_QuestClear" )
	local lookAtMe				= UI.getChildControl( targetPanel, "Static_LookAtMe" )
	local lookAtMe2				= UI.getChildControl( targetPanel, "Static_LookAtMe2" )
	local questType				= UI.getChildControl( targetPanel, "Static_QuestType" )

	local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
	if ( nil == questIcon ) or ( nil == questBorder ) or ( nil == questClear ) or ( nil == lookAtMe ) or ( nil == lookAtMe2 ) or ( nil == npcActorProxyWrapper ) then
		return
	end
	local questStaticStatusWrapper	= npcActorProxyWrapper:getQuestStatisStatusWrapper()
	if ( nil == questStaticStatusWrapper ) then
		questIcon:SetShow( false )
		questBorder:SetShow( false )
		questClear:SetShow( false )
		lookAtMe:SetShow( false )
		lookAtMe2:SetShow( false )
		questType:SetShow( false )
		return
	end

	local currentType = npcActorProxyWrapper:get():getOverHeadQuestInfoType()
	local isShow = ( 0 ~= currentType )
	local currentquestType	= questStaticStatusWrapper:getQuestType()

	questIcon:addInputEvent( "Mouse_On",	"questIconOverTooltip( true,	" .. actorKeyRaw .. " )" )
	questIcon:addInputEvent( "Mouse_Out",	"questIconOverTooltip( false,	" .. actorKeyRaw .. " )" )

	questIcon:ChangeTextureInfoName( questStaticStatusWrapper:getIconPath() )
	questIcon	:SetAlpha(1)
	questBorder	:SetAlpha(1)
	questClear	:SetAlpha(1)
	lookAtMe	:SetAlpha(1)
	lookAtMe2	:SetAlpha(1)
	questType	:SetAlpha(1)

	questIcon	:SetAlphaIgnore(true)	
	questBorder	:SetAlphaIgnore(true)
	questClear	:SetAlphaIgnore(true)
	lookAtMe	:SetAlphaIgnore(true)
	lookAtMe2	:SetAlphaIgnore(true)
	questType	:SetAlphaIgnore(true)
	
	questIcon	:SetScaleMinimum(0.5)	
	questBorder	:SetScaleMinimum(0.5)
	questClear	:SetScaleMinimum(0.5)
	lookAtMe	:SetScaleMinimum(0.5)
	lookAtMe2	:SetScaleMinimum(0.5)
	questType	:SetScaleMinimum(0.5)

	questIcon:SetShow( isShow )
	questBorder:SetShow( isShow )
	questClear:SetShow( 3 == currentType )
	lookAtMe:SetShow( isShow )
	lookAtMe2:SetShow( isShow )
	questType:SetShow( isShow )

	if ( isShow ) then
		local prevAlpha = questBorder:GetAlpha()
		questType:SetShow( false )
		
		if ( 3 == currentType ) then
			questBorder:SetColor(Defines.Color.C_FFFF0000)
			lookAtMe:SetShow( true )
			lookAtMe:SetColor(Defines.Color.C_FFF26A6A)
			lookAtMe2:SetShow( true )
			lookAtMe2:SetColor(Defines.Color.C_FFF26A6A)

			if Panel_Interaction:GetShow() and true ~= currentTypeChangeCheck[actorKeyRaw] then
				Interaction_Close()
			end
			currentTypeChangeCheck[actorKeyRaw] = true
			
		elseif ( 2 == currentType ) then
			questBorder:SetColor(Defines.Color.C_FF008AFF)
			lookAtMe:SetShow( true )
			lookAtMe:SetColor(Defines.Color.C_FF6DC6FF)
			lookAtMe2:SetShow( true )
			lookAtMe2:SetColor(Defines.Color.C_FF6DC6FF)
			currentTypeChangeCheck[actorKeyRaw] = false
			
		elseif ( 1 == currentType ) then
			questBorder:SetColor(Defines.Color.C_FFFFCE22)
			lookAtMe:SetShow( true )
			lookAtMe:SetColor(Defines.Color.C_FFFFEEA0)
			lookAtMe2:SetShow( true )
			lookAtMe2:SetColor(Defines.Color.C_FFFFEEA0)
			currentTypeChangeCheck[actorKeyRaw] = false
		end
		
		questBorder:SetAlpha( prevAlpha )

		local aControl = {
			questIcon	= questIcon,
			questBorder	= questBorder,
			questClear	= questClear,
			lookAtMe	= lookAtMe,
			lookAtMe2	= lookAtMe2,
			questType	= questType,
			
			GetSizeX = function()
				return questBorder:GetSizeX()	
			end,
			SetScale = function( self, x, y )
				questBorder	:SetScale( x, y )
				questIcon	:SetScale( x, y )
				questClear	:SetScale( x, y )
				lookAtMe	:SetScale( x, y )
				lookAtMe2	:SetScale( x, y )
				questType	:SetScale( x, y )
			end,
			SetSpanSize = function( self, x, y )
				questBorder	:SetSpanSize(x,y)
				questIcon	:SetSpanSize(x,y + 8)
				questClear	:SetSpanSize(x,y + 10)
				lookAtMe	:SetSpanSize(x,y + 4)
				lookAtMe2	:SetSpanSize(x,y)
				questType	:SetSpanSize(x, y + 40)
			end,
			GetSpanSize = function()
				return questBorder:GetSpanSize()
			end,
			GetScale = function()
				return questBorder:GetScale()
			end,
			GetShow = function()
				return questBorder:GetShow()
			end,
		}

		if ( 5 == currentquestType ) then					-- 생산 퀘스트면 아이콘 표시
			questBorder:SetColor(Defines.Color.C_FF88DF00)
			lookAtMe:SetShow( true )
			lookAtMe:SetColor(Defines.Color.C_FF88DF00)
			lookAtMe2:SetShow( true )
			lookAtMe2:SetColor(Defines.Color.C_FF88DF00)
			questType:SetShow( true )
			if ( 2 == currentType ) then
				questBorder:SetColor(Defines.Color.C_FF008AFF)
				lookAtMe:SetShow( true )
				lookAtMe:SetColor(Defines.Color.C_FF88DF00)
				lookAtMe2:SetShow( true )
				lookAtMe2:SetColor(Defines.Color.C_FF88DF00)
			else

			end
		end
		insertedArray:push_back(aControl)
	end
end

local settingBillBoardMode = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	houseHoldActorWrapper = getHouseHoldActor( actorKeyRaw )
	if ( nil ~= houseHoldActorWrapper and false == houseHoldActorWrapper:get():isTent() and false == houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isBarricade() ) then
		targetPanel:Set3DRenderType( 2 )	-- 0:None, 1:Billboard, 2:RotationY
		targetPanel:Set3DOffsetZ( 40 )		-- 앞으로 25cm 당기기
	end
end

local settingBubbleBox = function( actorKeyRaw, targetPanel, actorProxyWrapper, message )

	local targetStatic	= UI.getChildControl( targetPanel, "StaticText_BubbleBox" )
	local targetStaticBG= UI.getChildControl( targetPanel, "Static_BubbleBox" )
	bubbleBox.lastShowDeltaTime = 0
	
	targetStatic:SetScale(1,1)
	targetStaticBG:SetScale(1,1)
	targetStatic:SetSize( 210, 10 )

	targetStatic:SetText( message )


	local sizeY = targetStatic:GetSizeY() + 40

	local sizeY = targetStatic:GetSizeY() + 40

	if ( 210 < targetStatic:GetTextSizeX() ) then
		targetStatic:SetSize( targetStatic:GetSizeX(), sizeY )
		targetStaticBG:SetSize( targetStatic:GetSizeX() + 18, sizeY )
		targetStatic:SetSpanSize( targetStaticBG:GetSpanSize().x -10 , targetStaticBG:GetSpanSize().y )
	else
		targetStatic:SetSize( targetStatic:GetTextSizeX(), sizeY )
		targetStaticBG:SetSize( targetStatic:GetTextSizeX() + 27, sizeY )
		targetStatic:SetSpanSize( targetStaticBG:GetSpanSize().x -10 , targetStaticBG:GetSpanSize().y )
	end
		
	local time
	if #message < 5 then
		time = 2.22
	elseif #message < 10 then
		time = 2.72
	elseif #message < 15 then
		time = 3.22
	elseif #message < 20 then
		time = 3.72
	elseif #message < 25 then
		time = 4.22
	elseif #message < 30 then
		time = 4.72
	else
		time = 5.22
	end
	--최소치: 0.44이하로 내려가면 문제가 생긴다.
	ActorInsertShowTime( actorKeyRaw, hideTimeType.bubbleBox, time * 1000 )
	
end

local settingBubbleBoxShow = function( actorKeyRaw, targetPanel, actorProxyWrapper, isShow )
	local targetStatic	= UI.getChildControl( targetPanel, "StaticText_BubbleBox" )
	local targetStaticBG= UI.getChildControl( targetPanel, "Static_BubbleBox" )	
	
	targetStatic	:SetShow(isShow)
	targetStaticBG	:SetShow(isShow)
end

local settingWaitCommentLaunch = function( isShow )
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer = selfPlayerWrapper:get()
	
	
	local panel = selfPlayer:getWaitCommentPanel()
	if ( nil == panel ) then
		return
	end

	local targetBoard 				= UI.getChildControl ( panel, "Static_Board" )
	local targetPaper 				= UI.getChildControl ( panel, "Static_Paper" )
	local targetEditComment 		= UI.getChildControl ( panel, "Edit_Txt" )
	local targetPin_1 				= UI.getChildControl ( panel, "Static_Pin_1" )
	local targetPin_2 				= UI.getChildControl ( panel, "Static_Pin_2" )
	local targetPin_3 				= UI.getChildControl ( panel, "Static_Pin_3" )
	local targetPin_4 				= UI.getChildControl ( panel, "Static_Pin_4" )
	local targetRoll_L 				= UI.getChildControl ( panel, "Static_Roll_L" )
	local targetRoll_R 				= UI.getChildControl ( panel, "Static_Roll_R" )
	local targetPlayerID 			= UI.getChildControl ( panel, "StaticText_ID" )
	
	if (isShow) then
		local scaleBuffer = targetBoard:GetScale()
		targetBoard			:SetScale(1,1)
		targetEditComment	:SetScale(1,1)
		targetPaper			:SetScale(1,1)

		targetBoard:SetSize( 100, 110 )
		targetEditComment:SetSize ( 45, 56 )
		targetPaper:SetSize( 75, 56 )

		targetBoard			:SetScale(scaleBuffer.x, scaleBuffer.y)
		targetEditComment	:SetScale(scaleBuffer.x, scaleBuffer.y)
		targetPaper			:SetScale(scaleBuffer.x, scaleBuffer.y)
		
		local paperSizeX = targetPaper:GetSizeX()
		local paperPosX = targetPaper:GetPosX()

		targetEditComment:SetEditText ( "", false )
		targetEditComment:SetMaxInput( 20 )
		
		targetRoll_L:SetShow(true)
		targetRoll_R:SetShow(true)
		targetPaper:SetShow(true)
		targetEditComment:SetShow(true)
		targetPaper:SetIgnore(false)
		
		targetRoll_L:SetSpanSize( -paperSizeX / 2, targetRoll_L:GetSpanSize().y )
		targetRoll_R:SetSpanSize( paperSizeX / 2, targetRoll_R:GetSpanSize().y )
		
		targetPaper:addInputEvent("Mouse_LUp",		"settingWaitCommentReady()")
	else
		targetRoll_L:SetShow(false)
		targetRoll_R:SetShow(false)
		targetPaper:SetShow(false)
		targetEditComment:SetShow(false)
	end
	
	targetBoard:SetShow(false)
	targetPlayerID:SetShow(false)
	targetPin_1:SetShow(false)
	targetPin_2:SetShow(false)
	targetPin_3:SetShow(false)
	targetPin_4:SetShow(false)
	targetEditComment:SetIgnore(true)
end

function settingWaitCommentReady() 
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer = selfPlayerWrapper:get()
	
	local panel = selfPlayer:getWaitCommentPanel()
	if ( nil == panel ) then
		return
	end
	
	local targetBoard 				= UI.getChildControl ( panel, "Static_Board" )
	local targetPaper 				= UI.getChildControl ( panel, "Static_Paper" )
	local targetEditComment 		= UI.getChildControl ( panel, "Edit_Txt" )
	local targetPin_1 				= UI.getChildControl ( panel, "Static_Pin_1" )
	local targetPin_2 				= UI.getChildControl ( panel, "Static_Pin_2" )
	local targetPin_3 				= UI.getChildControl ( panel, "Static_Pin_3" )
	local targetPin_4 				= UI.getChildControl ( panel, "Static_Pin_4" )
	local targetRoll_L 				= UI.getChildControl ( panel, "Static_Roll_L" )
	local targetRoll_R 				= UI.getChildControl ( panel, "Static_Roll_R" )
	local targetPlayerID 			= UI.getChildControl ( panel, "StaticText_ID" )
	
	local scaleBuffer = targetEditComment:GetScale()
	targetEditComment	:SetScale(1,1)
	targetPaper			:SetScale(1,1)

	targetEditComment:SetSize ( 256, 56 )
	targetPaper:SetSize( 281, 56 )

	targetEditComment	:SetScale(scaleBuffer.x, scaleBuffer.y)
	targetPaper			:SetScale(scaleBuffer.x, scaleBuffer.y)
	
	targetEditComment:ComputePos()
	targetPaper:ComputePos()
	
	local paperSizeX = targetPaper:GetSizeX()
	local paperPosX = targetPaper:GetPosX()

	targetRoll_L:SetSpanSize( -paperSizeX / 2, targetRoll_L:GetSpanSize().y )
	targetRoll_R:SetSpanSize( paperSizeX / 2, targetRoll_R:GetSpanSize().y )
	
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit(targetEditComment)
	
	targetBoard:SetShow(false)
	targetPaper:SetShow(true)
	targetEditComment:SetShow( true )
	targetRoll_L:SetShow(true)
	targetRoll_R:SetShow(true)
	
	targetPlayerID:SetShow(false)
	targetPin_1:SetShow(false)
	targetPin_2:SetShow(false)
	targetPin_3:SetShow(false)
	targetPin_4:SetShow(false)
end

function settingWaitCommentConfirmReload()
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer = selfPlayerWrapper:get()
	if ( false == selfPlayer:isShowWaitComment() ) then
		return
	end

	local panel = selfPlayer:getWaitCommentPanel()
	if ( nil == panel ) then
		return
	end
	
	local targetEditComment 		= UI.getChildControl ( panel, "Edit_Txt" )
	
	targetEditComment:SetEditText( selfPlayer:getWaitComment(), true )
	settingWaitCommentConfirm()
end

function settingWaitCommentConfirm()
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
	ClearFocusEdit()
	
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer = selfPlayerWrapper:get()
	
	local panel = selfPlayer:getWaitCommentPanel()
	if ( nil == panel ) then
		return
	end
	
	local targetBoard 				= UI.getChildControl ( panel, "Static_Board" )
	local targetPaper 				= UI.getChildControl ( panel, "Static_Paper" )
	local targetEditComment 		= UI.getChildControl ( panel, "Edit_Txt" )
	local targetPin_1 				= UI.getChildControl ( panel, "Static_Pin_1" )
	local targetPin_2 				= UI.getChildControl ( panel, "Static_Pin_2" )
	local targetPin_3 				= UI.getChildControl ( panel, "Static_Pin_3" )
	local targetPin_4 				= UI.getChildControl ( panel, "Static_Pin_4" )
	local targetRoll_L 				= UI.getChildControl ( panel, "Static_Roll_L" )
	local targetRoll_R 				= UI.getChildControl ( panel, "Static_Roll_R" )
	local targetPlayerID 			= UI.getChildControl ( panel, "StaticText_ID" )

	targetPlayerID:SetText( "["..selfPlayerWrapper:getName().."]")
	 
	targetBoard:SetShow(true)
	targetPlayerID:SetShow(true)
	targetPin_1:SetShow(true)
	targetPin_2:SetShow(true)
	targetPin_3:SetShow(true)
	targetPin_4:SetShow(true)
	targetEditComment:SetShow( true )
	
	targetPin_1:AddEffect ( "fUI_Repair01", false, 0.0, 0.0 )
	targetPin_2:AddEffect ( "fUI_Repair01", false, 0.0, 0.0 )
	targetPin_3:AddEffect ( "fUI_Repair01", false, 0.0, 0.0 )
	targetPin_4:AddEffect ( "fUI_Repair01", false, 0.0, 0.0 )
	
	targetRoll_L:SetShow(false)
	targetRoll_R:SetShow(false)

	targetEditComment:SetIgnore(true)
	targetPaper:SetIgnore(false)
	
	updateWaitComment(targetEditComment:GetEditText())
	targetEditComment:SetEditText(chatting_filteredText(targetEditComment:GetEditText()), true)

	local sizeY = targetEditComment:GetSizeY()
	local scaleBuffer = targetEditComment:GetScale()
	targetEditComment	:SetScale(1,1)
	targetPaper			:SetScale(1,1)
	targetBoard			:SetScale(1,1)
	targetPlayerID		:SetScale(1,1)

	if ( 256 < targetEditComment:GetTextSizeX() ) then
		targetBoard:SetSize( targetEditComment:GetSizeX() + 50, sizeY + 65 )
		targetPaper:SetSize( targetEditComment:GetSizeX() + 25, sizeY + 10 )
	else
		targetEditComment:SetSize( targetEditComment:GetTextSizeX(), targetEditComment:GetSizeY() )
		targetPaper:SetSize( targetEditComment:GetTextSizeX() + 25, targetPaper:GetSizeY() )
		targetBoard:SetSize( targetEditComment:GetTextSizeX() + 60, targetBoard:GetSizeY())
	end
		
	targetPlayerID:SetSize( targetPaper:GetSizeX(), targetPlayerID:GetSizeY() )
	
	targetBoard			:SetScale(scaleBuffer.x, scaleBuffer.y)
	targetPaper			:SetScale(scaleBuffer.x, scaleBuffer.y)
	targetEditComment	:SetScale(scaleBuffer.x, scaleBuffer.y)
	targetPlayerID		:SetScale(scaleBuffer.x, scaleBuffer.y)

	targetBoard			:ComputePos()
	targetPaper			:ComputePos()
	targetEditComment	:ComputePos()
	targetPlayerID		:ComputePos()
	
	targetPin_1:SetSpanSize( targetPaper:GetPosX() + 5, targetPin_1:GetSpanSize().y )
	targetPin_2:SetSpanSize( targetPaper:GetPosX() + targetPaper:GetSizeX() - 15, targetPin_2:GetSpanSize().y )
	targetPin_3:SetSpanSize( targetPaper:GetPosX() + 5, targetPin_3:GetSpanSize().y )
	targetPin_4:SetSpanSize( targetPaper:GetPosX() + targetPaper:GetSizeX() - 15, targetPin_4:GetSpanSize().y )
end

function WaitComment_CheckCurrentUiEdit(targetUI)
	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer = selfPlayerWrapper:get()
	
	local panel = selfPlayer:getWaitCommentPanel()
	if ( nil == panel ) then
		return false
	end
	
	local targetEditComment 		= UI.getChildControl ( panel, "Edit_Txt" )
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == targetEditComment:GetKey() )
end

local settingWaitComment = function( actorKeyRaw, panel, actorProxyWrapper, isShow, isforce )
	local selfPlayer = getSelfPlayer()
	local selfActorKeyRaw = selfPlayer:getActorKey()
	if (actorKeyRaw == selfActorKeyRaw) and ( true ~= isforce ) then
		return
	end
	
	local targetPanel = panel
	if ( actorProxyWrapper:get():isSelfPlayer() ) then
		targetPanel = getSelfPlayer():get():getWaitCommentPanel()
	end

	local playerActorProxy = getPlayerActor(actorKeyRaw)
	if ( nil == playerActorProxy ) then
		return
	end
	
	local message = playerActorProxy:get():getWaitComment()


	local targetBoard 				= UI.getChildControl ( targetPanel, "Static_Board" )
	local targetPaper 				= UI.getChildControl ( targetPanel, "Static_Paper" )
	local targetEditComment 		= UI.getChildControl ( targetPanel, "Edit_Txt" )
	local targetPin_1 				= UI.getChildControl ( targetPanel, "Static_Pin_1" )
	local targetPin_2 				= UI.getChildControl ( targetPanel, "Static_Pin_2" )
	local targetPin_3 				= UI.getChildControl ( targetPanel, "Static_Pin_3" )
	local targetPin_4 				= UI.getChildControl ( targetPanel, "Static_Pin_4" )
	local targetPlayerID 			= UI.getChildControl ( targetPanel, "StaticText_ID" )
	
	if (isShow) and ( nil ~= message ) and ("" ~= message) then 
		targetBoard:SetShow(true)
		targetPaper:SetShow(true)
		targetEditComment:SetShow(true)
		targetPin_1:SetShow(true)
		targetPin_2:SetShow(true)
		targetPin_3:SetShow(true)
		targetPin_4:SetShow(true)
		targetPlayerID:SetShow(true)

		local scaleBuffer = targetEditComment:GetScale()
		targetEditComment	:SetScale(1,1)
		targetBoard			:SetScale(1,1)
		targetPaper			:SetScale(1,1)
		--targetPanel			:SetScale(1,1)
		targetPlayerID		:SetScale(1,1)

		targetEditComment:SetSize( 256, 56 )
		
		targetPlayerID:SetText( "["..playerActorProxy:getName().."]")
		
		targetEditComment:SetText( message )
		
		local sizeY = targetEditComment:GetSizeY()
		
		targetEditComment:SetSize( targetEditComment:GetTextSizeX(), targetEditComment:GetSizeY() )
		targetBoard:SetSize( targetEditComment:GetTextSizeX() + 60, targetBoard:GetSizeY())
		targetPaper:SetSize( targetEditComment:GetTextSizeX() + 25, targetPaper:GetSizeY())
		--targetPanel:SetSize(targetBoard:GetSizeX(), targetBoard:GetSizeY())
		targetPlayerID:SetSize( targetPaper:GetSizeX(), targetPlayerID:GetSizeY() )

		targetEditComment	:SetScale(scaleBuffer.x, scaleBuffer.y)
		targetBoard			:SetScale(scaleBuffer.x, scaleBuffer.y)
		targetPaper			:SetScale(scaleBuffer.x, scaleBuffer.y)
		--targetPanel			:SetScale(scaleBuffer.x, scaleBuffer.y)
		targetPlayerID		:SetScale(scaleBuffer.x, scaleBuffer.y)

		targetBoard:ComputePos()
		targetPaper:ComputePos()
		targetEditComment:ComputePos()
		targetPlayerID:ComputePos()
		
		targetPin_1:SetSpanSize( - targetEditComment:GetTextSizeX() / 2	, 40)
		targetPin_2:SetSpanSize(   targetEditComment:GetTextSizeX() / 2 , 40)
		targetPin_3:SetSpanSize(   targetEditComment:GetTextSizeX() / 2 , 5 )
		targetPin_4:SetSpanSize( - targetEditComment:GetTextSizeX() / 2	, 5 )
		
	else
		targetBoard:SetShow(false)
		targetPaper:SetShow(false)
		targetEditComment:SetShow(false)
		targetPin_1:SetShow(false)
		targetPin_2:SetShow(false)
		targetPin_3:SetShow(false)
		targetPin_4:SetShow(false)
		targetPlayerID:SetShow(false)
	end	
end

local settingSelfPlayerNameHelpText = function( actorKeyRaw, panel, actorProxyWrapper )
	-- panel:SetHelpText( "네 이름과 체력, 가문명, 그리고 길드명과 길드 마크가 표시되지. 캐릭터의 이름 색깔에 따라 선함과 악함이 표시되기도 하는데, 선할 수록 푸른 색으로 악할 수록 빨간 색으로 표시되지. 다른 이들을 죽이고 다녔다면 이름은 붉게 물들고 말거야. 만약 색깔이 연두색이라면, 아직은 다른 이로부터 공격을 받지 않는 초심자라고 생각하면 돼. 누구는 이걸 귀찮다고 게임 설정에서 꺼버리기도 하더라구." )
end

-- 액터가 가구인지 체크
local furnitureActorKeyRaw = nil
function Furniture_Check( actorKeyRaw )
	local actorProxyWrapper = getActor( actorKeyRaw )
	local actorProxy = actorProxyWrapper:get()
	local characterStaticStatus = actorProxy:getCharacterStaticStatus()
	furnitureActorKeyRaw = actorKeyRaw
	if ( nil == actorProxy ) or ( nil == characterStaticStatus ) or ( nil == actorKeyRaw ) then
		return
	end
	
	if actorProxy:isInstallationActor() then
		local installationActorWrapper = getInstallationActor( furnitureActorKeyRaw )
		
		if Panel_Housing:IsShow() then
			return 
		end
		
		local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
		if false == isShowInstallationEnduranceType( installationType ) then
			return
		end
		
		if( toInt64(0, 0) ~= installationActorWrapper:getOwnerHouseholdNo_s64() ) then	
			if installationActorWrapper:isHavestInstallation() then
			else
				furnitureCheck = true
			end
		end
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
end

function Funiture_Endurance_Hide()
	if true == furnitureCheck then
		if ( nil ~= furnitureActorKeyRaw ) then
			local actorProxyWrapper = getActor( furnitureActorKeyRaw )
			local panel = actorProxyWrapper:get():getUIPanel()
			if ( nil == panel ) then
				return
			end
			furnitureCheck = false
			settingHpBar( furnitureActorKeyRaw, panel, actorProxyWrapper )
		end
	end
	furnitureActorKeyRaw = nil
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create event가 처리되는 부분
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local TypeByLoadData = {
	[ActorProxyType.isActorProxy		] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isCharacter			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isPlayer			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		local insertedArray = Array.new()
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingPlayerName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingTitle( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildInfo( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingLifeRankIcon( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingStun( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildTextForAlias( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingLocalWarCombatPoint( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingMurderer( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildMarkAndPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isSelfPlayer		] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		local insertedArray = Array.new()
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingPlayerName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingAlias( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingTitle( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildInfo( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingLifeRankIcon( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingStun( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingSelfPlayerNameHelpText( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingWaitCommentConfirmReload()
		settingGuildTextForAlias( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingLocalWarCombatPoint( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingMurderer( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildMarkAndPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isOtherPlayer		] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		local insertedArray = Array.new()
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingPlayerName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingAlias( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingTitle( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildInfo( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingLifeRankIcon( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingStun( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingWaitComment( actorKeyRaw, targetPanel, actorProxyWrapper, true )
		settingGuildTextForAlias( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingLocalWarCombatPoint( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingMurderer( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingGuildMarkAndPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isAlterego			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isMonster			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingMonsterName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingTitle( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingQuestMark( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingStun( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isNpc				] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingTitle( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingQuestMark( actorKeyRaw, targetPanel, actorProxyWrapper )

		local insertedArray = Array.new()
		settingQuestUI( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		settingFirstTalk( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		settingImportantTalk( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		settingOtherHeadIcon( actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray )
		sortCenterX(insertedArray)

	end,
	[ActorProxyType.isDeadBody			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isVehicle			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingQuestMark( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isGate				] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isHouseHold			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingBillBoardMode( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isInstallationActor	] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isCollect			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		--settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
	[ActorProxyType.isInstanceObject			] = function( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingName( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBarInitState( actorKeyRaw, targetPanel, actorProxyWrapper )
		settingHpBar( actorKeyRaw, targetPanel, actorProxyWrapper )
	end,
}



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 이벤트 처리 및 이벤트 등록부분
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Panel_Copy_CharacterTag:SetPosX(-1000)
--Panel_Copy_CharacterTag:SetPosY(-1000)

function EventActorCreated_NameTag( actorKeyRaw, targetPanel, actorProxyType, actorProxyWrapper )
--	copyPanelChild( Panel_Copy_CharacterTag, targetPanel )

	--_PA_LOG("nametag", tostring( actorProxyType ) )
	if ( nil ~= TypeByLoadData[actorProxyType] ) then
		TypeByLoadData[actorProxyType]( actorKeyRaw, targetPanel, actorProxyWrapper )
	end
end

function FromClient_ChangeTopRankUser( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	local insertedArray = Array.new()
	settingLifeRankIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingGuildTextForAlias( actorKeyRaw, panel, actorProxyWrapper)
end

-- function FromClient_ChangeTopContentsRankUser( rankType, actorKey )
-- 	local actorProxyWrapper = getActor(actorKey)
-- 	if ( nil == actorProxyWrapper ) then
-- 		return
-- 	end

-- 	local panel = actorProxyWrapper:get():getUIPanel()
-- 	if ( nil == panel ) then
-- 		return
-- 	end
-- 	local insertedArray = Array.new()
-- 	settingLifeRankIcon( actorKey, panel, actorProxyWrapper, insertedArray )
-- 	settingGuildTextForAlias( actorKey, panel, actorProxyWrapper)
-- end

function FromClient_NameTag_TendencyChanged( actorKeyRaw, tendencyValue )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	settingPlayerName( actorKeyRaw, panel, actorProxyWrapper )
end

function EventActorFirsttalk( actorKeyRaw, isFirsttalkOn )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	local insertedArray = Array.new()
	settingQuestUI( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingFirstTalk( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingImportantTalk( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingOtherHeadIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	sortCenterX(insertedArray)
end

function EventActorImportantTalk( actorKeyRaw, isImportantTalk )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	local insertedArray = Array.new()
	settingQuestUI( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingFirstTalk( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingImportantTalk( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingOtherHeadIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	sortCenterX(insertedArray)
end

function EventActorChangeGuildInfo( actorKeyRaw, guildName )

	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	local insertedArray = Array.new()
	settingGuildInfo( actorKeyRaw, panel, actorProxyWrapper )
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	settingLifeRankIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingGuildTextForAlias( actorKeyRaw, panel, actorProxyWrapper )
	settingLocalWarCombatPoint( actorKeyRaw, panel, actorProxyWrapper )
end

function FromClient_EventActorUpdateTitleKey( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if (nil == actorProxyWrapper) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	local insertedArray = Array.new()
	settingAlias(actorKeyRaw, panel, actorProxyWrapper)
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	settingLifeRankIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingGuildTextForAlias( actorKeyRaw, panel, actorProxyWrapper )
	settingLocalWarCombatPoint( actorKeyRaw, panel, actorProxyWrapper )
end

function FromClient_EventActorChangeGuildInfo_HaveLand( actorProxyWrapper, Panel, isoccupyTerritory )
	local targetPanel = Panel
	if ( nil == actorProxyWrapper ) or ( nil == isoccupyTerritory ) then
		return
	end
	local actorKeyRaw = actorProxyWrapper:get():getActorKeyRaw()
	settingGuildInfo( actorKeyRaw, targetPanel, actorProxyWrapper )
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, targetPanel, actorProxyWrapper )
end

function EventActorPvpModeChange( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	if ( actorProxyWrapper:get():isPlayer() ) then
		settingPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	end
end

function EventActorChangeLevel( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	if ( actorProxyWrapper:get():isMonster() ) then
		settingMonsterName( actorKeyRaw, panel, actorProxyWrapper )
	elseif ( actorProxyWrapper:get():isPlayer() ) then
		settingPlayerName( actorKeyRaw, panel, actorProxyWrapper )
	end
end

function EventActorHpChanged( actorKeyRaw, hp, maxHp )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
end

function EventChangeCharacterName( actorKeyRaw, characterName )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end	

	local insertedArray = Array.new()
	settingName( actorKeyRaw, panel, actorProxyWrapper )
	settingAlias( actorKeyRaw, panel, actorProxyWrapper )
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	settingLifeRankIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	if ( actorProxyWrapper:get():isPlayer() ) then
		settingPlayerName( actorKeyRaw, panel, actorProxyWrapper )
		settingLocalWarCombatPoint(actorKeyRaw, panel, actorProxyWrapper)
	end
end

function FGlobal_ReSet_SiegeBuildingName( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end	

	settingName( actorKeyRaw, panel, actorProxyWrapper )
end

-- 파티원 hp 표시 추가
function insertPartyMemberGage( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
	
	if( getSelfPlayer():getActorKey() ~= actorKeyRaw ) then
		--파티 멤버 추가 메세지 출력
		local textName = actorProxyWrapper:getName()
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_PARTY_ACK", "textName", textName ) )-- textName .. "님이 파티원이 되었습니다.")
	end
end

-- 파티원 hp 표시 제거
function removePartyMemberGage(actorKeyRaw)
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
end

function EventActorAddDamage(actorKeyRaw, variedPoint, attackResult_IntValue, additionalDamageType, position )
	if	   ( 0 == attackResult_IntValue )
		or ( 1 == attackResult_IntValue )
		or ( 2 == attackResult_IntValue )
		or ( 3 == attackResult_IntValue )
		or ( 4 == attackResult_IntValue )
		or ( 5 == attackResult_IntValue )
		 then
		ActorInsertShowTime( actorKeyRaw, hideTimeType.overHeadUI, 0 )
	end
end

function EventShowProgressBar( actorKeyRaw, aHideTimeType )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end


	if ( hideTimeType.preemptiveStrike == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getUIPanel()
		if ( nil == panel ) then
			return
		end
		settingPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	elseif ( hideTimeType.overHeadUI == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getUIPanel()
		if ( nil == panel ) then
			return
		end
		settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
	elseif ( hideTimeType.bubbleBox == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getBubbleBoxUIPanel()
		if ( nil == panel ) then
			return
		end
		settingBubbleBoxShow( actorKeyRaw, panel, actorProxyWrapper, true )
	elseif ( hideTimeType.murdererEnd == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getUIPanel()
		if ( nil == panel ) then
			return
		end
		settingMurderer( actorKeyRaw, panel, actorProxyWrapper, true )
	end
end

function EventHideProgressBar( actorKeyRaw, aHideTimeType )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	if ( hideTimeType.preemptiveStrike == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getUIPanel()
		if ( nil == panel ) then
			return
		end
		settingPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	elseif ( hideTimeType.overHeadUI == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getUIPanel()
		if ( nil == panel ) then
			return
		end
		settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
	elseif ( hideTimeType.bubbleBox == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getBubbleBoxUIPanel()
		if ( nil == panel ) then
			return
		end
		settingBubbleBoxShow( actorKeyRaw, panel, actorProxyWrapper, false )
	elseif ( hideTimeType.murdererEnd == aHideTimeType ) then
		local panel = actorProxyWrapper:get():getUIPanel()
		if ( nil == panel ) then
			return
		end
		settingMurderer( actorKeyRaw, panel, actorProxyWrapper, true )
	end
end



function update_Changed_StunGage( actorKeyRaw, curStun, maxStun )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	local actorProxy =	actorProxyWrapper:get();

	if( false == ( actorProxy:isMonster() or actorProxy:isPlayer() ) ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	settingStun( actorKeyRaw, panel, actorProxyWrapper )
end

function EventActor_QuestUpdateInserted( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	settingQuestMarkForce( true, panel, actorProxyWrapper )
end

function EventActor_QuestUpdateDeleted( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	settingQuestMarkForce( false, panel, actorProxyWrapper )
end

function FromClient_preemptiveStrikeTimeChanged( targetActorKeyRaw )
	ActorInsertShowTime( attackerActorKey, hideTimeType.preemptiveStrike, 0 )
end

function EventActor_QuestUI_UpdateData( actorKeyRaw, currentType, iconPath )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	local insertedArray = Array.new()
	settingQuestUI( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingFirstTalk( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingImportantTalk( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	settingOtherHeadIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	sortCenterX(insertedArray)
end

function EventActor_EnduranceUpdate( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	settingName( actorKeyRaw, panel, actorProxyWrapper )
	settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
end

function EventActor_HouseHoldNearestDoorChanged( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	settingName( actorKeyRaw, panel, actorProxyWrapper )
end

function EventActor_OnChatMessageUpdate()
	local msg
	
	-- 각 Actor 별 마지막 메시지를 표시하기 위해, actorKey 로 한번 거른다.
	local totalSize = getNewChatMessageCount();
	for index = 0, totalSize -1 do
		msg = getNewChatMessage(index)
		if (nil ~= msg) and (CppEnums.ChatType.System ~= msg.chatType) and (msg.isSameChannel or CppEnums.ChatType.Client == msg.chatType) then
			local actorProxyWrapper = getActor(msg._actorKeyRaw)

			if ( nil ~= actorProxyWrapper ) then
				local panel = actorProxyWrapper:get():getBubbleBoxUIPanel()
				if ( nil ~= panel ) then
					settingBubbleBox( msg._actorKeyRaw, panel, actorProxyWrapper, msg:getContent() )
				end
			end
		end
	end
end

function EventSelfPlayerWaitCommentLaunch( )
	if ( nil == getSelfPlayer():get():getWaitCommentPanel() ) then
		return
	end

	settingWaitCommentLaunch( true )
	getSelfPlayer():get():showWaitComment();
end

function EventSelfPlayerWaitCommentClose()
	if ( nil == getSelfPlayer():get():getWaitCommentPanel() ) then
		return
	end
	
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
	ClearFocusEdit()
	settingWaitCommentLaunch( false )
	getSelfPlayer():get():hideWaitComment();
end

function EventOtherPlayerWaitCommentUpdate( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	settingWaitComment( actorKeyRaw, panel, actorProxyWrapper, true )
end


function EventOtherPlayerWaitCommentClose( actorKeyRaw )
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	settingWaitComment( actorKeyRaw, panel, actorProxyWrapper, false )
end

function FromClient_OverHeadUIShowChanged( actorKeyRaw, panel, actorProxyWrapper, isShow )
	--이곳에 켜질때의 이펙트를 넣으세요...
	--_PA_LOG("LUA", "FromClient_OverHeadUIShowChanged" .. tostring(isShow) )

	--local questBorder	= UI.getChildControl( panel, "Static_QuestIconBorder" )
	--if ( false == isShow ) then
	--	questBorder:EraseAllEffect()
	--else
	--	local npcActorProxyWrapper = getNpcActor( actorKeyRaw )
	--	if ( questBorder:GetShow() ) then
	--		local currentType = npcActorProxyWrapper:get():getOverHeadQuestInfoType()
	--		if ( 3 == currentType ) then
	--			questBorder:EraseAllEffect()
	--			questBorder:AddEffect( "fUI_QuestNotice01_Red", true, -0.75, -1.0 )
	--		elseif ( 2 == currentType ) then
	--			questBorder:EraseAllEffect()
	--			questBorder:AddEffect( "fUI_QuestNotice01_Blue", true, -0.75, -1.0 )
	--		elseif ( 1 == currentType ) then
	--			questBorder:EraseAllEffect()
	--			questBorder:AddEffect( "fUI_QuestNotice01_Yellow", true, -0.75, -1.0 )
	--		end
	--	end
	--end
end

function FromClient_GuildMemberGradeChanged( actorKeyRaw, panel, actorProxyWrapper, guildGrade )
	settingGuildInfo( actorKeyRaw, panel, actorProxyWrapper )
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
end

function EventPlayerNicknameUpdate(actorKeyRaw)
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	settingTitle( actorKeyRaw, panel, actorProxyWrapper )
end

function FromClient_NameTag_SelfPlayerLevelUp()
	local actorProxyWrapper = getSelfPlayer()
	if ( nil == actorProxyWrapper ) then
		return
	end

	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end

	settingName( actorProxyWrapper:getActorKey(), panel, actorProxyWrapper )
end

function FromClient_ActorInformationChanged( actorKeyRaw, panel, actorProxyWrapper )
	if ( nil == panel ) then
		return
	end

	if ( nil == actorProxyWrapper ) then
		return
	end

	settingName( actorKeyRaw, panel, actorProxyWrapper )
end

function FromClient_NotifyChangeGuildTendency( actorKeyRaw, panel, actorProxyWrapper )
	if ( nil == panel ) then
		return
	end

	if ( nil == actorProxyWrapper ) then
		return
	end

	settingGuildInfo( actorKeyRaw, panel, actorProxyWrapper )
end

function FromClient_ChangeArenaAreaAndZoneState( actorProxyWrapper, panel, isStateOn )
	if ( nil == actorProxyWrapper ) or ( nil == isStateOn ) or ( nil == panel ) then
		return
	end
	local actorKeyRaw = actorProxyWrapper:get():getActorKeyRaw()
	settingHpBar( actorKeyRaw, panel, actorProxyWrapper )
end

function FromClient_InstallationInfoWarningNameTag( warningType, tentPosition, characterSSW, progressingInfo, actorWrapper, addtionalValue1 )
	if ( nil == actorWrapper ) or ( nil == isStateOn ) then
		return
	end
	local actorKeyRaw = actorWrapper:get():getActorKeyRaw()
	local panel = actorWrapper:get():getUIPanel()
	settingHpBar( actorKeyRaw, panel, actorWrapper )
end

function FromClient_LocalWarCombatPoint( actorkeyRaw )
	if ( nil == actorkeyRaw ) then
		return
	end
	
	local playerActorWrapper = getPlayerActor(actorkeyRaw)
	if ( nil == playerActorWrapper ) then
		return
	end

	local panel = playerActorWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	settingLocalWarCombatPoint(actorkeyRaw, panel, playerActorWrapper)
end

function FromClient_FlashBangStateChanged(actorKeyRaw, isFlashBangOn)
	if ( nil == actorKeyRaw ) then
		return
	end
	
	local actorProxyWrapper = getActor(actorKeyRaw)
	if ( nil == actorProxyWrapper ) then
		return
	end
	
	local panel = actorProxyWrapper:get():getUIPanel()
	if ( nil == panel ) then
		return
	end
	
	local insertedArray = Array.new()
	settingName( actorKeyRaw, panel, actorProxyWrapper )
	settingAlias( actorKeyRaw, panel, actorProxyWrapper )
	settingGuildInfo( actorKeyRaw, panel, actorProxyWrapper )
	settingGuildMarkAndPreemptiveStrike( actorKeyRaw, panel, actorProxyWrapper )
	settingLifeRankIcon( actorKeyRaw, panel, actorProxyWrapper, insertedArray )
	if ( actorProxyWrapper:get():isPlayer() ) then
		settingPlayerName( actorKeyRaw, panel, actorProxyWrapper )
		settingLocalWarCombatPoint(actorKeyRaw, panel, actorProxyWrapper)
	end
	settingTitle( actorKeyRaw, panel, actorProxyWrapper )
end

registerEvent("EventActorCreated",							"EventActorCreated_NameTag")
registerEvent("FromClient_TendencyChanged",					"FromClient_NameTag_TendencyChanged")
registerEvent("EventFirstTalk" ,							"EventActorFirsttalk" )
registerEvent("EventImportantTalk" ,						"EventActorImportantTalk" )
registerEvent("EventChangeGuildInfo" ,						"EventActorChangeGuildInfo" )
registerEvent("EventMonsterLevelColorChanged" ,				"EventActorChangeLevel" )
registerEvent("EventPlayerPvPAbleChanged",					"EventActorChangeLevel" )
registerEvent("hpChanged",									"EventActorHpChanged")
registerEvent("EventChangeCharacterName",					"EventChangeCharacterName");
registerEvent("ResponseParty_insert",						"insertPartyMemberGage")
registerEvent("ResponseParty_RemovePatyNameTag",			"removePartyMemberGage")
registerEvent("addDamage",									"EventActorAddDamage")
registerEvent("EventShowProgressBar",						"EventShowProgressBar")
registerEvent("EventHideProgressBar",						"EventHideProgressBar")
registerEvent("stunChanged",								"update_Changed_StunGage")
registerEvent("EventQuestTargetActorInserted",				"EventActor_QuestUpdateInserted")
registerEvent("EventQuestTargetActorDeleted",				"EventActor_QuestUpdateDeleted")
registerEvent("FromClient_preemptiveStrikeTimeChanged",		"FromClient_preemptiveStrikeTimeChanged")
registerEvent("EventQuestUpdate",							"EventActor_QuestUI_UpdateData")
registerEvent("EventHousingUpdateInstallationEndurance",	"EventActor_EnduranceUpdate")
registerEvent("EventHouseHoldNearestDoorChanged",			"EventActor_HouseHoldNearestDoorChanged")
registerEvent("EventChattingMessageUpdate",					"EventActor_OnChatMessageUpdate")
registerEvent("EventSelfPlayerWaitCommentUpdate",			"EventSelfPlayerWaitCommentLaunch");
registerEvent("EventSelfPlayerWaitCommentClose",			"EventSelfPlayerWaitCommentClose");
registerEvent("EventOtherPlayerWaitCommentUpdate",			"EventOtherPlayerWaitCommentUpdate");
registerEvent("EventOtherPlayerWaitCommentClose",			"EventOtherPlayerWaitCommentClose");
--registerEvent("FromClient_OverHeadUIShowChanged",			"FromClient_OverHeadUIShowChanged");
registerEvent("FromClient_GuildMemberGradeChanged",			"FromClient_GuildMemberGradeChanged");
registerEvent("EventPlayerNicknameUpdate",					"EventPlayerNicknameUpdate");
registerEvent("EventSelfPlayerLevelUp",						"FromClient_NameTag_SelfPlayerLevelUp");
registerEvent("FromClient_ActorInformationChanged",			"FromClient_ActorInformationChanged");
registerEvent("FromClient_NotifyChangeGuildTendency",		"FromClient_NotifyChangeGuildTendency");
registerEvent("FromClient_ChangeOccupyTerritoryState",		"FromClient_EventActorChangeGuildInfo_HaveLand");
registerEvent("FromClient_ChangeArenaAreaRegion",			"FromClient_ChangeArenaAreaAndZoneState");
registerEvent("FromClient_ChangeArenaZoneRegion",			"FromClient_ChangeArenaAreaAndZoneState");
registerEvent("FromClient_InstallationInfoWarning",			"FromClient_InstallationInfoWarningNameTag");
registerEvent("FromClient_ChangeTopRankUser",				"FromClient_ChangeTopRankUser")
-- registerEvent("FromClient_ChangeTopContentsRankUser",	"FromClient_ChangeTopContentsRankUser")

registerEvent("FromClient_EventActorUpdateTitleKey",		"FromClient_EventActorUpdateTitleKey")
registerEvent("FromClient_LocalWarCombatPoint",				"FromClient_LocalWarCombatPoint")
registerEvent("FromClient_FlashBangStateChanged",			"FromClient_FlashBangStateChanged")

-- pvp mode를 켰을 때!
registerEvent("EventPvPModeChanged",						"EventActorPvpModeChange")

