local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_GuildWarInfo:ActiveMouseEventEffect(true)
Panel_GuildWarInfo:setGlassBackground(true)
Panel_GuildWarInfo:SetShow( false, false )

Panel_GuildWarInfo:RegisterShowEventFunc( true, "Panel_GuildWarInfo_ShowAni()" )
Panel_GuildWarInfo:RegisterShowEventFunc( false, "Panel_GuildWarInfo_HideAni()" )

function Panel_GuildWarInfo_ShowAni()
end
function Panel_GuildWarInfo_HideAni()
end

local territoryName =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_0"), -- "발레노스 자치령",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_1"), -- "세렌디아 자치령",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_2"), -- "칼페온 직할령",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_3"), -- "메디아 직할령",
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_4"), -- "발렌시아 직할령",
}
local selectTerritoy = 0				-- 기본 선택 영지
local siegingAreaCount = 3				-- 점령전이 가능한 영지 수

local isCalpheon, isMedia, isValencia = 2, 3, 4
if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isValencia ) then			-- 발렌시아 오픈?
	siegingAreaCount = 5
elseif ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isMedia ) then		-- 메디아 오픈?
	siegingAreaCount = 4
elseif ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isCalpheon ) then		-- 칼페온 오픈?
	siegingAreaCount = 3
else
	siegingAreaCount = 2
end

local guildWarInfo_ShowCheck = false

local siegeType =
{
	[0]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_DEAD"), 				-- "죽음",						-- eSiegeImportantTypeDeath,			// 죽음
	[1]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_SIEGESYMBOLDESTROY"),	-- "지휘소를 파괴했습니다.",	-- eSiegeImportantTypeSiegeSymbol,		// 공성탑
	[2]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_SIEGETENTDESTROY"),		-- "성채를 파괴했습니다.",		-- eSiegeImportantTypeSiegeTent,		// 성채
	[3]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_LORDKILL"),				-- "군주를 처치했습니다.",		-- eSiegeImportantTypeLord,				// 군주(연합길드장)
	[4]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_GUILDMASTERKILL"),		-- "대장을 처치했습니다.",		-- eSiegeImportantTypeGuildMaster,		// 길마
	[5]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_CASTLEGATEDESTROY"),	-- "성문을 파괴했습니다.",		-- eSiegeImportantTypeCastleGate,		// 성문
	[6]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_SQUADCAPTAINKILL"),		-- "부대장을 처치했습니다.",	-- eSiegeImportantTypeSquadCaptain,		// 분대장
	[7]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_GUILDMEMBERKILL"),		-- "상대 길드원을 처치했습니다.",-- eSiegeImportantTypeSquadMember,		// 분대원
	[8]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_HELP"),					-- "도움을 줬습니다.",			-- eSiegeImportantTypeAssist,			// 도움행위
	[9]		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_SUMMONKILL"),			-- "소환물을 처치했습니다.",	-- eSiegeImportantTypeSummon,			// 소환수
	[10]	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_INSTALLKILL"),			-- "설치물을 파괴했습니다.",	-- eSiegeImportantTypeInstallation,		// 설치물
	[11]	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SIEGETYPE_IGNORE"),				-- "무시",						-- eSiegeImportantTypeCount
}

local warInfo_Main =
{
	btn_Close				= UI.getChildControl( Panel_GuildWarInfo, "Button_Win_Close" ),
	btn_Question			= UI.getChildControl( Panel_GuildWarInfo, "Button_Question" ),
	comboBox_Territory		= UI.getChildControl( Panel_GuildWarInfo, "Combobox_Territory" ),
	
	frame_SiegeInfo			= UI.getChildControl( Panel_GuildWarInfo, "Frame_SiegeInfo" ),
	subTitle				= UI.getChildControl( Panel_GuildWarInfo, "StaticText_TitleBar" ),
}

local comboxList = UI.getChildControl( warInfo_Main.comboBox_Territory, "Combobox_List" )
comboxList:SetSize( comboxList:GetSizeX(), 20 * siegingAreaCount + 5 )

warInfo_Main.btn_Question:SetShow( false )
warInfo_Main.btn_Close:addInputEvent( "Mouse_LUp", "Panel_GuildWarInfo_Hide()" )

warInfo_Main.comboBox_Territory:SetText( territoryName[0] )
warInfo_Main.comboBox_Territory:addInputEvent( "Mouse_LUp", "HandleClicked_Territory()" )
warInfo_Main.comboBox_Territory:GetListControl():addInputEvent( "Mouse_LUp", "GuildWarInfo_Set_Territory()"  )
Panel_GuildWarInfo:SetChildIndex(warInfo_Main.comboBox_Territory, 9999 )

local warInfo_Content =
{
	frame_content			= UI.getChildControl( warInfo_Main.frame_SiegeInfo, "Frame_1_Content" ),
	_scroll					= UI.getChildControl( warInfo_Main.frame_SiegeInfo, "VerticalScroll" ),

	contentBg				= UI.getChildControl( Panel_GuildWarInfo, "Static_GuildWarInfoBg" ),
	guildMarkBg				= UI.getChildControl( Panel_GuildWarInfo, "Static_GuildIconBg" ),
	guildMark				= UI.getChildControl( Panel_GuildWarInfo, "Static_GuildIcon" ),
	guildName				= UI.getChildControl( Panel_GuildWarInfo, "StaticText_GuildName" ),
	guildMaster				= UI.getChildControl( Panel_GuildWarInfo, "StaticText_GuildMaster" ),
	lordCrownIcon			= UI.getChildControl( Panel_GuildWarInfo, "Static_LordIcon" ),
	
	guildWarIconBg			= UI.getChildControl( Panel_GuildWarInfo, "Static_GuildWarIconBg" ),
	siegeEnduranceIcon		= UI.getChildControl( Panel_GuildWarInfo, "Static_SiegeEnduranceIcon" ),
	siegeEnduranceValue		= UI.getChildControl( Panel_GuildWarInfo, "StaticText_SiegeEnduranceValue" ),
	destroySiegeCountIcon	= UI.getChildControl( Panel_GuildWarInfo, "Static_DestroySiegeCountIcon" ),
	destroySiegeCountValue	= UI.getChildControl( Panel_GuildWarInfo, "StaticText_DestroySiegeCountValue" ),
	killCountIcon			= UI.getChildControl( Panel_GuildWarInfo, "Static_KillCountIcon" ),
	killCountValue			= UI.getChildControl( Panel_GuildWarInfo, "StaticText_KillCountValue" ),
	deathCountIcon			= UI.getChildControl( Panel_GuildWarInfo, "Static_DeathCountIcon" ),
	deathCountValue			= UI.getChildControl( Panel_GuildWarInfo, "StaticText_DeathCountValue" ),
	cannonCountIcon			= UI.getChildControl( Panel_GuildWarInfo, "Static_CanonCountIcon" ),
	cannonCountValue		= UI.getChildControl( Panel_GuildWarInfo, "StaticText_CanonCountValue" ),
	
	moraleIcon				= UI.getChildControl( Panel_GuildWarInfo, "Static_MoraleIcon" ),
	moraleProgressBg		= UI.getChildControl( Panel_GuildWarInfo, "Static_Morale_ProgressBg" ),
	moraleProgress			= UI.getChildControl( Panel_GuildWarInfo, "Progress2_Morale" ),
	
	btn_CurrentInfo			= UI.getChildControl( Panel_GuildWarInfo, "Button_CurrentInfo" ),
	btn_Cheer				= UI.getChildControl( Panel_GuildWarInfo, "Button_Cheer" ),
	
	cheerPoint				= UI.getChildControl( Panel_GuildWarInfo, "StaticText_CheerPoint" ),
	
	setFree					= UI.getChildControl( Panel_GuildWarInfo, "StaticText_SetFree" ),
	setFreeDesc				= UI.getChildControl( Panel_GuildWarInfo, "StaticText_SetFreeDesc" ),

	_tooltip				= UI.getChildControl( Panel_GuildWarInfo, "StaticText_Help" ),
	
	_battleGuildText		= UI.getChildControl( Panel_GuildWarInfo, "StaticText_SiegeGuildCount" ),
}

local progressBarHead		= UI.getChildControl( warInfo_Content.moraleProgress, "Progress2_Morale_Bar_Head" )
progressBarHead:SetShow( false )

for v, control in pairs( warInfo_Content ) do
	control:SetShow(false)
end

local warInfo_Log =
{
	frame_SiegeLog			= UI.getChildControl( Panel_GuildWarInfo, "Frame_SiegeLog" ),
	textLog					= UI.getChildControl( Panel_GuildWarInfo, "StaticText_GuildWar_Log" ),
	isGuildMasterBg			= UI.getChildControl( Panel_GuildWarInfo, "Static_LogBg" )
}

local log_Content =
{
	frame_content			= UI.getChildControl( warInfo_Log.frame_SiegeLog, "Frame_1_Content" ),
	_scroll					= UI.getChildControl( warInfo_Log.frame_SiegeLog, "VerticalScroll" ),
	textLog					= {},
	isGuildMasterBg			= {}
}
log_Content._scroll:SetShow( false )


-- 변수 초기화
local battleGuildCount	= {}
local warInfoContent	= {}
local guildMpCheck		= {}
for territoryIndex = 0, siegingAreaCount - 1 do
	battleGuildCount[territoryIndex]	= -1
	warInfoContent[territoryIndex]		= {}
	guildMpCheck[territoryIndex]		= {}
end

local WarInfoUI_Init = function( territoryKey )
	-- 점령전 중인지 체크
	if false == isSiegeBeing( territoryKey ) then
		
	end
	
	-- 점령전 진행중인 길드 수
	battleGuildCount[territoryKey] = ToClient_SiegeGuildCount( territoryKey )
	local battleGuildCountIndex = 0
	if 0 >= battleGuildCount[territoryKey] then
		battleGuildCountIndex = 1
	else
		battleGuildCountIndex = battleGuildCount[territoryKey]
	end
	
	for index = 0, battleGuildCountIndex do						-- 해방 및 점령전 콘트롤이 들어갈 수 있어 실제 길드수보다 하나 많게 세팅해둠!!
		warInfoContent[territoryKey][index]	= {}
		guildMpCheck[territoryKey][index] = {}
	end
	for index = 0, battleGuildCountIndex do
		warInfoContent[territoryKey][index]	= 
		{ 
			_guildNo				= nil,
			_guildName				= nil,
			_guildMaster			= nil,
			_siegeEnduranceValue	= 100,
			_destroySiegeCountValue	= 0,
			_killCountValue			= 0,
			_deathCountValue		= 0,
			_cannonCountValue		= 0,
			_guildMp				= 0,
		}
		guildMpCheck[territoryKey][index] = 0
	end
end

function BattleGuildCount_Update()
	for territoryIndex = 0, siegingAreaCount - 1 do
		WarInfoUI_Init( territoryIndex )
	end
	SiegeStatusUpdate()
end


local gapY = 5
local eliminatedGuildCount = 0
local _currentTerritoryKey = 0
local controlReGenerate = nil
function FromClient_WarInfoContent_Set( territoryKey )	
	if false == Panel_GuildWarInfo:GetShow() then
		return
	end
	
	local isSiegeChannel	= ToClient_doMinorSiegeInTerritory(territoryKey)
	
	local self = warInfo_Content
	if nil == territoryKey then
		territoryKey = selectTerritoy
	end
	
	if nil == controlReGenerate then						-- 아직 콘트롤이 생성된 게 없다면,
		controlReGenerate = true
		self.frame_content:DestroyAllChild()
	elseif _currentTerritoryKey ~= territoryKey then		-- 다른 영지를 눌렀다면,
		self.frame_content:DestroyAllChild()
		controlReGenerate = true
	else													-- 같은 영지의 업데이트라면,
		controlReGenerate = false
	end
	self.frame_content:SetShow( true )
	
	-- 점령전 시작/종료 시 들어오는 테리토리키(-1)
	if -1 == territoryKey then
		territoryKey = selectTerritoy
	end
	_currentTerritoryKey = territoryKey
	
	-- 점령전 진행중인 길드 수가 0 : 해방 상태
	if 0 >= battleGuildCount[territoryKey] then
		if true == controlReGenerate then
			local index = 0

			local contentBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.frame_content, "Static_WarInfoContent_" .. index )
			CopyBaseProperty( self.contentBg, contentBg )
			warInfoContent[territoryKey][index].contentBg = contentBg
			warInfoContent[territoryKey][index].contentBg:SetPosX( 10 )
			warInfoContent[territoryKey][index].contentBg:SetPosY( gapY )
			warInfoContent[territoryKey][index].contentBg:SetShow( true )

			local setFree = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_setFree_" .. index )
			CopyBaseProperty( self.setFree, setFree )
			warInfoContent[territoryKey][index].setFree = setFree
			warInfoContent[territoryKey][index].setFree:SetShow( true )
			warInfoContent[territoryKey][index].setFree:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE", "selectTerritoy", territoryName[territoryKey] ) ) -- "<PAColor0xFFC1FFC2><" .. territoryName[selectTerritoy] .. "><PAOldColor>이 해방되었습니다!" )
			
			local setFreeDesc = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_setFreeDesc_" .. index )
			CopyBaseProperty( self.setFreeDesc, setFreeDesc )
			warInfoContent[territoryKey][index].setFreeDesc = setFreeDesc
			warInfoContent[territoryKey][index].setFreeDesc:SetShow( true )
			warInfoContent[territoryKey][index].setFreeDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC") ) -- "점령 길드가 없어 지난 주의 세율이 그대로 유지됩니다." )
			
			warInfo_Content._battleGuildText:SetShow( isSiegeBeing(territoryKey) )
			warInfo_Main.frame_SiegeInfo:UpdateContentPos()
			self._scroll:SetControlTop()
			self._scroll:SetShow( false )
		end
		return
	
	-- 점령전 진행중인 길드 수가 1 : 남은 길드가 해당 영지 차지함(점령전이 끝난 걸로 판단. 점령전이 끝나고 리로드 돼도 같음)
	elseif 1 == battleGuildCount[territoryKey] then
		local isOccupyGuild = true
		local guildWrapper = ToClient_GetOccupyGuildWrapper( territoryKey )
		if nil == guildWrapper then
			guildWrapper = ToClient_SiegeGuildAt( territoryKey, 0 )
			isOccupyGuild = false
			-- return
		end
		
		if true == controlReGenerate then
			local index = 0
			-- 점령 지역 설명
			local contentBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.frame_content, "Static_WarInfoContent_" .. index )
			CopyBaseProperty( self.contentBg, contentBg )
			warInfoContent[territoryKey][index].contentBg = contentBg
			warInfoContent[territoryKey][index].contentBg:SetPosX( 10 )
			warInfoContent[territoryKey][index].contentBg:SetPosY( gapY )
			warInfoContent[territoryKey][index].contentBg:SetShow( true )
			
			local setFree = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_setFree_" .. index )
			CopyBaseProperty( self.setFree, setFree )
			warInfoContent[territoryKey][index].setFree = setFree
			warInfoContent[territoryKey][index].setFree:SetShow( true )
			-- warInfoContent[territoryKey][index].setFree:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END", "selectTerritoy", territoryName[territoryKey] ) ) -- "<PAColor0xFFC1FFC2><" .. territoryName[selectTerritoy] .. "><PAOldColor> 점령전 종료!!" )
			
			local setFreeDesc = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_setFreeDesc_" .. index )
			CopyBaseProperty( self.setFreeDesc, setFreeDesc )
			warInfoContent[territoryKey][index].setFreeDesc = setFreeDesc
			warInfoContent[territoryKey][index].setFreeDesc:SetShow( true )
			-- warInfoContent[territoryKey][index].setFreeDesc:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC_END", "getName", guildWrapper:getName() ) ) -- "다음 점령전까지 [" .. guildWrapper:getName() .. "] 길드의 관리를 받습니다." )
			
			-- 점령 길드 내역
			index = 1
			
			local contentBg1 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.frame_content, "Static_WarInfoContent_" .. index )
			CopyBaseProperty( self.contentBg, contentBg1 )
			warInfoContent[territoryKey][index].contentBg = contentBg1
			warInfoContent[territoryKey][index].contentBg:SetPosY(( warInfoContent[territoryKey][index].contentBg:GetSizeY() + gapY ) * index + gapY )
			warInfoContent[territoryKey][index].contentBg:SetShow( true )

			local occupyGuildBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.frame_content, "Static_WarInfoContentBg_" .. index )
			CopyBaseProperty( self.contentBg, occupyGuildBg )
			warInfoContent[territoryKey][index].occupyGuildBg = occupyGuildBg
			warInfoContent[territoryKey][index].occupyGuildBg:SetPosX( 10 )
			warInfoContent[territoryKey][index].occupyGuildBg:SetPosY(( warInfoContent[territoryKey][0].contentBg:GetSizeY() + gapY ) * battleGuildCount[selectTerritoy] + gapY )
			warInfoContent[territoryKey][index].occupyGuildBg:SetShow( true )
			
			local guildMarkBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_GuildMarkBg_" .. index )
			CopyBaseProperty( self.guildMarkBg, guildMarkBg )
			warInfoContent[territoryKey][index].guildMarkBg = guildMarkBg
			warInfoContent[territoryKey][index].guildMarkBg:SetShow( true )
			
			local guildMark = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_GuildMark_" .. index )
			CopyBaseProperty( self.guildMark, guildMark )
			warInfoContent[territoryKey][index].guildMark = guildMark
			warInfoContent[territoryKey][index].guildMark:SetShow( true )
			
			local guildName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_GuildName_" .. index )
			CopyBaseProperty( self.guildName, guildName )
			warInfoContent[territoryKey][index].guildName = guildName
			warInfoContent[territoryKey][index].guildName:SetShow( true )
			
			local lordCrownIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_LordIcon" )
			CopyBaseProperty( self.lordCrownIcon, lordCrownIcon )
			warInfoContent[territoryKey][index].lordCrownIcon = lordCrownIcon
			warInfoContent[territoryKey][index].lordCrownIcon:SetShow( false )
			
			local guildMaster = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_GuildMaster_" .. index )
			CopyBaseProperty( self.guildMaster, guildMaster )
			warInfoContent[territoryKey][index].guildMaster = guildMaster
			warInfoContent[territoryKey][index].guildMaster:SetShow( true )
			
			local guildWarIconBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_GuildWarIconBg_" .. index )
			CopyBaseProperty( self.guildWarIconBg, guildWarIconBg )
			warInfoContent[territoryKey][index].guildWarIconBg = guildWarIconBg
			warInfoContent[territoryKey][index].guildWarIconBg:SetShow( true )
			
			local destroySiegeCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_DestroySiegeCountIcon_" .. index )
			CopyBaseProperty( self.destroySiegeCountIcon, destroySiegeCountIcon )
			warInfoContent[territoryKey][index].destroySiegeCountIcon = destroySiegeCountIcon
			warInfoContent[territoryKey][index].destroySiegeCountIcon:SetShow( true )
			
			local destroySiegeCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_DestroySiegeCountValue_" .. index )
			CopyBaseProperty( self.destroySiegeCountValue, destroySiegeCountValue )
			warInfoContent[territoryKey][index].destroySiegeCountValue = destroySiegeCountValue
			warInfoContent[territoryKey][index].destroySiegeCountValue:SetShow( true )
			
			local killCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_KillCountIcon_" .. index )
			CopyBaseProperty( self.killCountIcon, killCountIcon )
			warInfoContent[territoryKey][index].killCountIcon = killCountIcon
			warInfoContent[territoryKey][index].killCountIcon:SetShow( true )
			
			local killCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_KillCountValue_" .. index )
			CopyBaseProperty( self.killCountValue, killCountValue )
			warInfoContent[territoryKey][index].killCountValue = killCountValue
			warInfoContent[territoryKey][index].killCountValue:SetShow( true )
			
			local deathCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_DeathCountIcon_" .. index )
			CopyBaseProperty( self.deathCountIcon, deathCountIcon )
			warInfoContent[territoryKey][index].deathCountIcon = deathCountIcon
			warInfoContent[territoryKey][index].deathCountIcon:SetShow( true )
			
			local deathCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_DeathCountValue_" .. index )
			CopyBaseProperty( self.deathCountValue, deathCountValue )
			warInfoContent[territoryKey][index].deathCountValue = deathCountValue
			warInfoContent[territoryKey][index].deathCountValue:SetShow( true )
			
			local cannonCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_CannonCountIcon_" .. index )
			CopyBaseProperty( self.cannonCountIcon, cannonCountIcon )
			warInfoContent[territoryKey][index].cannonCountIcon = cannonCountIcon
			warInfoContent[territoryKey][index].cannonCountIcon:SetShow( true )
			
			local cannonCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_CannonCountValue_" .. index )
			CopyBaseProperty( self.cannonCountValue, cannonCountValue )
			warInfoContent[territoryKey][index].cannonCountValue = cannonCountValue
			warInfoContent[territoryKey][index].cannonCountValue:SetShow( true )
			
			local moraleIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_MoraleIcon_" .. index )
			CopyBaseProperty( self.moraleIcon, moraleIcon )
			warInfoContent[territoryKey][index].moraleIcon = moraleIcon
			warInfoContent[territoryKey][index].moraleIcon:SetShow( true )
			
			local moraleProgressBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].occupyGuildBg, "Static_MoraleProgressBg_" .. index )
			CopyBaseProperty( self.moraleProgressBg, moraleProgressBg )
			warInfoContent[territoryKey][index].moraleProgressBg = moraleProgressBg
			warInfoContent[territoryKey][index].moraleProgressBg:SetShow( true )
			
			local moraleProgress = UI.createControl( UI_PUCT.PA_UI_CONTROL_PROGRESS2, warInfoContent[territoryKey][index].occupyGuildBg, "Progress2_MoraleProgress_" .. index )
			CopyBaseProperty( self.moraleProgress, moraleProgress )
			warInfoContent[territoryKey][index].moraleProgress = moraleProgress
			warInfoContent[territoryKey][index].moraleProgress:SetShow( true )

			
			local btn_CurrentInfo = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, warInfoContent[territoryKey][index].occupyGuildBg, "Button_CurrentInfo_" .. index )
			CopyBaseProperty( self.btn_CurrentInfo, btn_CurrentInfo )
			warInfoContent[territoryKey][index].btn_CurrentInfo = btn_CurrentInfo
			warInfoContent[territoryKey][index].btn_CurrentInfo:SetShow( true )
			if (isSiegeChannel) then
				warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( false )
			else
				warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( true )	
			end
			
			local btn_Cheer = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, warInfoContent[territoryKey][index].occupyGuildBg, "Button_Cheer_" .. index )
			CopyBaseProperty( self.btn_Cheer, btn_Cheer )
			warInfoContent[territoryKey][index].btn_Cheer = btn_Cheer
			warInfoContent[territoryKey][index].btn_Cheer:SetShow( true )
			warInfoContent[territoryKey][index].btn_Cheer:SetIgnore( true )
			
			local cheerPoint = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].occupyGuildBg, "StaticText_CheerPoint_" .. index )
			CopyBaseProperty( self.cheerPoint, cheerPoint )
			warInfoContent[territoryKey][index].cheerPoint = cheerPoint
			warInfoContent[territoryKey][index].cheerPoint:SetShow( true )
			
		end

		warInfoContent[territoryKey][0].setFree:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END", "selectTerritoy", territoryName[territoryKey] ) ) -- "<PAColor0xFFC1FFC2><" .. territoryName[selectTerritoy] .. "><PAOldColor> 점령전 종료!!" )
		if isOccupyGuild then
			warInfoContent[territoryKey][0].setFreeDesc:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC_END", "getName", guildWrapper:getName() ) ) -- "다음 점령전까지 [" .. guildWrapper:getName() .. "] 길드의 관리를 받습니다." )
		else
			warInfoContent[territoryKey][0].setFreeDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC") )
		end
		
		local index = 1
		warInfoContent[territoryKey][index]._guildNo		= guildWrapper:getGuildNo_s64()
		warInfoContent[territoryKey][index]._guildName		= guildWrapper:getName()
		warInfoContent[territoryKey][index]._guildMaster	= guildWrapper:getGuildMasterName()

		local currentGuildWrapper = ToClient_GetGuildInfoWrapperByGuildNo( guildWrapper:getGuildNo_s64() )
		
		-- 한국 이외의 국가는 아직 점령전 코드가 모두 적용된 게 아니라 따로 구분해준다!
		if isGameTypeKorea() then
			warInfoContent[territoryKey][index]._destroySiegeCountValue = currentGuildWrapper:getTotalSiegeCount(0)
			warInfoContent[territoryKey][index]._killCountValue			= currentGuildWrapper:getTotalSiegeCount(1)
			warInfoContent[territoryKey][index]._deathCountValue		= currentGuildWrapper:getTotalSiegeCount(2)
			warInfoContent[territoryKey][index]._cannonCountValue		= currentGuildWrapper:getTotalSiegeCount(3)
		else
			for gmIndex = 0, currentGuildWrapper:getMemberCount() -1 do
				local guildMemberData = currentGuildWrapper:getMember( gmIndex )
				warInfoContent[territoryKey][index]._destroySiegeCountValue		= warInfoContent[territoryKey][index]._destroySiegeCountValue + guildMemberData:commandPostCount() + guildMemberData:towerCount() + guildMemberData:gateCount()
				warInfoContent[territoryKey][index]._killCountValue				= warInfoContent[territoryKey][index]._killCountValue + guildMemberData:guildMasterCount() + guildMemberData:squadLeaderCount() + guildMemberData:squadMemberCount()
				warInfoContent[territoryKey][index]._deathCountValue			= warInfoContent[territoryKey][index]._deathCountValue + guildMemberData:deathCount()
				warInfoContent[territoryKey][index]._cannonCountValue			= warInfoContent[territoryKey][index]._cannonCountValue + guildMemberData:summonedCount()
			end
		end
		
		warInfoContent[territoryKey][index].guildMaster:SetText( warInfoContent[territoryKey][index]._guildMaster )
		warInfoContent[territoryKey][index]._guildMp = currentGuildWrapper:getGuildMp()
		
		local isSet = setGuildTextureByGuildNo( warInfoContent[territoryKey][index]._guildNo, warInfoContent[territoryKey][index].guildMark )
		if ( false == isSet ) then
			warInfoContent[territoryKey][index].guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( warInfoContent[territoryKey][index].guildMark, 183, 1, 188, 6 )
			warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
			warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())
		else	
			warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
			warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())
		end
		
		warInfoContent[territoryKey][index].guildName:SetText( warInfoContent[territoryKey][index]._guildName )
	
		-- 점령길드라면 왕관 아이콘 표시
		occupyGuildWrapper = ToClient_GetOccupyGuildWrapper( territoryKey )
		if nil ~= occupyGuildWrapper then
			if ( warInfoContent[territoryKey][index]._guildNo == occupyGuildWrapper:getGuildNo_s64() ) then
				warInfoContent[territoryKey][index].lordCrownIcon:SetShow( true )
				warInfoContent[territoryKey][index].guildName:SetPosX( warInfoContent[territoryKey][index].lordCrownIcon:GetPosX() + warInfoContent[territoryKey][index].lordCrownIcon:GetSizeX() + 5 )
				warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( false )
			end
		else
			warInfoContent[territoryKey][index].guildMaster:SetText( "??????" )
			warInfoContent[territoryKey][index].guildName:SetText( "????????" )
			warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( true )
			warInfoContent[territoryKey][index].guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( warInfoContent[territoryKey][index].guildMark, 183, 1, 188, 6 )
			warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
			warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())
		end
		
		warInfoContent[territoryKey][index].destroySiegeCountValue:SetText( warInfoContent[territoryKey][index]._destroySiegeCountValue )
		warInfoContent[territoryKey][index].killCountValue:SetText( warInfoContent[territoryKey][index]._killCountValue )
		warInfoContent[territoryKey][index].deathCountValue:SetText( warInfoContent[territoryKey][index]._deathCountValue )
		warInfoContent[territoryKey][index].cannonCountValue:SetText( warInfoContent[territoryKey][index]._cannonCountValue )

		local currentGuildMp = currentGuildWrapper:getGuildMp()
		if warInfoContent[territoryKey][index]._guildMp ~= currentGuildMp then
			warInfoContent[territoryKey][index]._guildMp = currentGuildMp
		end
		warInfoContent[territoryKey][index].moraleProgress:SetAniSpeed(0)
		warInfoContent[territoryKey][index].moraleProgress:SetProgressRate( warInfoContent[territoryKey][index]._guildMp / 1500 * 100 )
		
		local msg = GuildMp_Check( 0, territoryKey )
		warInfoContent[territoryKey][index].cheerPoint:SetText( msg )
		warInfoContent[territoryKey][index].cheerPoint:SetPosX( warInfoContent[territoryKey][index].moraleIcon:GetPosX() + warInfoContent[territoryKey][index].moraleIcon:GetSizeX() + 5 )
		
		self.frame_content:SetSize( self.frame_content:GetSizeX(), warInfo_Main.frame_SiegeInfo:GetSizeY() )
		warInfo_Main.frame_SiegeInfo:UpdateContentScroll()
		self._scroll:SetControlTop()
		warInfo_Main.frame_SiegeInfo:UpdateContentPos()
		self._scroll:SetShow( false )

		warInfo_Content._battleGuildText:SetShow( isSiegeBeing(territoryKey) )
		warInfo_Main.frame_SiegeInfo:UpdateContentPos()
		self._scroll:SetControlTop()
		self._scroll:SetShow( false )

		warInfoContent[territoryKey][index].destroySiegeCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(" .. territoryKey .. ", " .. index .. ", " .. 1 .. ")" )
		warInfoContent[territoryKey][index].destroySiegeCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
		warInfoContent[territoryKey][index].killCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(" .. territoryKey .. ", " .. index .. ", " .. 2 .. ")" )
		warInfoContent[territoryKey][index].killCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
		warInfoContent[territoryKey][index].deathCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(" .. territoryKey .. ", " .. index .. ", " .. 3 .. ")" )
		warInfoContent[territoryKey][index].deathCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
		warInfoContent[territoryKey][index].cannonCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(" .. territoryKey .. ", " .. index .. ", " .. 4 .. ")" )
		warInfoContent[territoryKey][index].cannonCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
		warInfoContent[territoryKey][index].moraleIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(" .. territoryKey .. ", " .. index .. ", " .. 5 .. ")" )
		warInfoContent[territoryKey][index].moraleIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
		warInfoContent[territoryKey][index].btn_CurrentInfo:addInputEvent( "Mouse_LUp", "HandleClicked_GuildScore(" .. territoryKey .. ", " .. index .. ")" )
		warInfoContent[territoryKey][index].btn_Cheer:addInputEvent( "Mouse_LUp", "HandleClicked_Cheer(" .. territoryKey .. ", " .. index .. ")" )

		return
	
	-- 점령전 진행중인 길드 수가 1 초과 : 모든 길드 표시. 단, 점령전 진행중이 아닐 경우 점령 길드 표시
	elseif 1 < battleGuildCount[territoryKey] then
		local index			= 0
		local startIndex	= 0
		local lastIndex		= battleGuildCount[territoryKey]
		-- local _isSiegeBeing = isSiegeBeing( 0 ) or isSiegeBeing( 1 ) or isSiegeBeing( 2 ) or isSiegeBeing( 3 )		-- 모든 지역의 점령전이 끝났는지 체크
		if true == controlReGenerate then
			if false == isSiegeBeing( territoryKey ) then				-- 점령전이 끝나면 결과창을 띄워준다
				local index = 0
				local contentBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.frame_content, "Static_WarInfoContent_" .. index )
				CopyBaseProperty( self.contentBg, contentBg )
				warInfoContent[territoryKey][index].contentBg = contentBg
				-- warInfoContent[territoryKey][index].contentBg:SetPosX( 10 )
				warInfoContent[territoryKey][index].contentBg:SetPosY( gapY )
				warInfoContent[territoryKey][index].contentBg:SetShow( true )
				local setFree = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_setFree_" .. index )
				CopyBaseProperty( self.setFree, setFree )
				warInfoContent[territoryKey][index].setFree = setFree
				warInfoContent[territoryKey][index].setFree:SetShow( true )
				
				local setFreeDesc = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_setFreeDesc_" .. index )
				CopyBaseProperty( self.setFreeDesc, setFreeDesc )
				warInfoContent[territoryKey][index].setFreeDesc = setFreeDesc
				warInfoContent[territoryKey][index].setFreeDesc:SetShow( true )
				local guildWrapper = ToClient_GetOccupyGuildWrapper( territoryKey )
				if nil == guildWrapper then
					warInfoContent[territoryKey][index].setFree:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE", "selectTerritoy", territoryName[territoryKey] ) ) -- "<PAColor0xFFC1FFC2><" .. territoryName[selectTerritoy] .. "><PAOldColor>이 해방되었습니다!" )
					warInfoContent[territoryKey][index].setFreeDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC") ) -- "점령 길드가 없어 지난 주의 세율이 그대로 유지됩니다." )
				else
					warInfoContent[territoryKey][index].setFree:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END", "selectTerritoy", territoryName[territoryKey] ) ) -- "<PAColor0xFFC1FFC2><" .. territoryName[selectTerritoy] .. "><PAOldColor> 점령전 종료!!" )
					warInfoContent[territoryKey][index].setFreeDesc:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC_END", "getName", guildWrapper:getName() ) ) -- "다음 점령전까지 [" .. guildWrapper:getName() .. "] 길드의 관리를 받습니다." )
				end
			
				startIndex = 1
				lastIndex = battleGuildCount[territoryKey] + 1
				if 3 >= lastIndex then
					warInfoContent[territoryKey][index].contentBg:SetPosX( 10 )
				end
			end
			
			for index = startIndex, lastIndex - 1 do
				local contentBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.frame_content, "Static_WarInfoContent_" .. index )
				CopyBaseProperty( self.contentBg, contentBg )
				warInfoContent[territoryKey][index].contentBg = contentBg
				-- warInfoContent[index].contentBg:SetSize( warInfoContent[index].contentBg:GetSizeX(), 120 )
				warInfoContent[territoryKey][index].contentBg:SetPosY(( warInfoContent[territoryKey][index].contentBg:GetSizeY() + gapY ) * index + gapY )
				warInfoContent[territoryKey][index].contentBg:SetShow( false )
				if 4 > lastIndex then
					warInfoContent[territoryKey][index].contentBg:SetPosX( 10 )
				end
				
				local guildMarkBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_GuildMarkBg_" .. index )
				CopyBaseProperty( self.guildMarkBg, guildMarkBg )
				warInfoContent[territoryKey][index].guildMarkBg = guildMarkBg
				warInfoContent[territoryKey][index].guildMarkBg:SetShow( true )
				
				local guildMark = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_GuildMark_" .. index )
				CopyBaseProperty( self.guildMark, guildMark )
				warInfoContent[territoryKey][index].guildMark = guildMark
				warInfoContent[territoryKey][index].guildMark:SetShow( true )
				
				local guildName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_GuildName_" .. index )
				CopyBaseProperty( self.guildName, guildName )
				warInfoContent[territoryKey][index].guildName = guildName
				warInfoContent[territoryKey][index].guildName:SetShow( true )
				
				local lordCrownIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "StaticText_LordIcon" )
				CopyBaseProperty( self.lordCrownIcon, lordCrownIcon )
				warInfoContent[territoryKey][index].lordCrownIcon = lordCrownIcon
				warInfoContent[territoryKey][index].lordCrownIcon:SetShow( false )
				
				local guildMaster = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_GuildMaster_" .. index )
				CopyBaseProperty( self.guildMaster, guildMaster )
				warInfoContent[territoryKey][index].guildMaster = guildMaster
				warInfoContent[territoryKey][index].guildMaster:SetShow( true )
				
				local guildWarIconBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_GuildWarIconBg_" .. index )
				CopyBaseProperty( self.guildWarIconBg, guildWarIconBg )
				warInfoContent[territoryKey][index].guildWarIconBg = guildWarIconBg
				warInfoContent[territoryKey][index].guildWarIconBg:SetShow( true )
				
				local siegeEnduranceIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_SiegeEnduranceIcon_" .. index )
				CopyBaseProperty( self.siegeEnduranceIcon, siegeEnduranceIcon )
				warInfoContent[territoryKey][index].siegeEnduranceIcon = siegeEnduranceIcon
				warInfoContent[territoryKey][index].siegeEnduranceIcon:SetShow( true )
				
				local siegeEnduranceValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_SiegeEnduranceValue_" .. index )
				CopyBaseProperty( self.siegeEnduranceValue, siegeEnduranceValue )
				warInfoContent[territoryKey][index].siegeEnduranceValue = siegeEnduranceValue
				warInfoContent[territoryKey][index].siegeEnduranceValue:SetShow( true )
				
				local destroySiegeCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_DestroySiegeCountIcon_" .. index )
				CopyBaseProperty( self.destroySiegeCountIcon, destroySiegeCountIcon )
				warInfoContent[territoryKey][index].destroySiegeCountIcon = destroySiegeCountIcon
				warInfoContent[territoryKey][index].destroySiegeCountIcon:SetShow( true )
				
				local destroySiegeCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_DestroySiegeCountValue_" .. index )
				CopyBaseProperty( self.destroySiegeCountValue, destroySiegeCountValue )
				warInfoContent[territoryKey][index].destroySiegeCountValue = destroySiegeCountValue
				warInfoContent[territoryKey][index].destroySiegeCountValue:SetShow( true )
				
				local killCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_KillCountIcon_" .. index )
				CopyBaseProperty( self.killCountIcon, killCountIcon )
				warInfoContent[territoryKey][index].killCountIcon = killCountIcon
				warInfoContent[territoryKey][index].killCountIcon:SetShow( true )
				
				local killCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_KillCountValue_" .. index )
				CopyBaseProperty( self.killCountValue, killCountValue )
				warInfoContent[territoryKey][index].killCountValue = killCountValue
				warInfoContent[territoryKey][index].killCountValue:SetShow( true )
				
				local deathCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_DeathCountIcon_" .. index )
				CopyBaseProperty( self.deathCountIcon, deathCountIcon )
				warInfoContent[territoryKey][index].deathCountIcon = deathCountIcon
				warInfoContent[territoryKey][index].deathCountIcon:SetShow( true )
				
				local deathCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_DeathCountValue_" .. index )
				CopyBaseProperty( self.deathCountValue, deathCountValue )
				warInfoContent[territoryKey][index].deathCountValue = deathCountValue
				warInfoContent[territoryKey][index].deathCountValue:SetShow( true )
				
				local cannonCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_CannonCountIcon_" .. index )
				CopyBaseProperty( self.cannonCountIcon, cannonCountIcon )
				warInfoContent[territoryKey][index].cannonCountIcon = cannonCountIcon
				warInfoContent[territoryKey][index].cannonCountIcon:SetShow( true )
				
				local cannonCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_CannonCountValue_" .. index )
				CopyBaseProperty( self.cannonCountValue, cannonCountValue )
				warInfoContent[territoryKey][index].cannonCountValue = cannonCountValue
				warInfoContent[territoryKey][index].cannonCountValue:SetShow( true )
				
				local moraleIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_MoraleIcon_" .. index )
				CopyBaseProperty( self.moraleIcon, moraleIcon )
				warInfoContent[territoryKey][index].moraleIcon = moraleIcon
				warInfoContent[territoryKey][index].moraleIcon:SetShow( true )
				
				local moraleProgressBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, warInfoContent[territoryKey][index].contentBg, "Static_MoraleProgressBg_" .. index )
				CopyBaseProperty( self.moraleProgressBg, moraleProgressBg )
				warInfoContent[territoryKey][index].moraleProgressBg = moraleProgressBg
				warInfoContent[territoryKey][index].moraleProgressBg:SetShow( true )
				
				local moraleProgress = UI.createControl( UI_PUCT.PA_UI_CONTROL_PROGRESS2, warInfoContent[territoryKey][index].contentBg, "Progress2_MoraleProgress_" .. index )
				CopyBaseProperty( self.moraleProgress, moraleProgress )
				warInfoContent[territoryKey][index].moraleProgress = moraleProgress
				warInfoContent[territoryKey][index].moraleProgress:SetShow( true )
				warInfoContent[territoryKey][index].moraleProgress:SetAniSpeed(0)
				warInfoContent[territoryKey][index].moraleProgress:SetProgressRate( 0 )
				
				local btn_CurrentInfo = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, warInfoContent[territoryKey][index].contentBg, "Button_CurrentInfo_" .. index )
				CopyBaseProperty( self.btn_CurrentInfo, btn_CurrentInfo )
				warInfoContent[territoryKey][index].btn_CurrentInfo = btn_CurrentInfo
				warInfoContent[territoryKey][index].btn_CurrentInfo:SetShow( true )
				if (isSiegeChannel) then
					warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( false )
				else
					warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( true )	
				end
				
				local btn_Cheer = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, warInfoContent[territoryKey][index].contentBg, "Button_Cheer_" .. index )
				CopyBaseProperty( self.btn_Cheer, btn_Cheer )
				warInfoContent[territoryKey][index].btn_Cheer = btn_Cheer
				warInfoContent[territoryKey][index].btn_Cheer:SetShow( true )
				
				local cheerPoint = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, warInfoContent[territoryKey][index].contentBg, "StaticText_CheerPoint_" .. index )
				CopyBaseProperty( self.cheerPoint, cheerPoint )
				warInfoContent[territoryKey][index].cheerPoint = cheerPoint
				warInfoContent[territoryKey][index].cheerPoint:SetShow( true )
				warInfoContent[territoryKey][index].cheerPoint:SetPosX( warInfoContent[territoryKey][index].moraleIcon:GetPosX() + warInfoContent[territoryKey][index].moraleIcon:GetSizeX() + 5 )
				
			end
		end
		
		if false == isSiegeBeing( territoryKey ) then				-- 점령전이 끝나면 결과창을 띄워준다
			startIndex = 1
			lastIndex = battleGuildCount[territoryKey] + 1
		else
			startIndex = 0
			lastIndex = battleGuildCount[territoryKey]
		end

		eliminatedGuildCount = 0
		local siegeGuildIndex = 0
		for index = startIndex, lastIndex - 1 do
			local guildWrapper = ToClient_SiegeGuildAt( territoryKey, siegeGuildIndex )
			local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt( territoryKey, siegeGuildIndex )

			if nil == guildWrapper then
				return
			end
			
			-- 점령전 탈락 길드면 맨 뒤에서부터 정렬(점령전이 끝나면 의미 없어지므로, 점령전일 때만 체크)
			if false == siegeBuildingInfo:isEnterSiege() then
				index = lastIndex - 1 - eliminatedGuildCount
				eliminatedGuildCount = eliminatedGuildCount + 1
			else
				index = index - eliminatedGuildCount
			end
			
			local _destroySiegeCountValue	= 0
			local _killCountValue			= 0
			local _deathCountValue			= 0
			local _cannonCountValue			= 0
			local destroySiegeCountEffect	= false
			local killCountEffect			= false
			local deathCountEffect			= false
			local cannonCountEffect			= false
				
			warInfoContent[territoryKey][index]._guildNo		= guildWrapper:getGuildNo_s64()
			warInfoContent[territoryKey][index]._guildName		= guildWrapper:getName()
			warInfoContent[territoryKey][index]._guildMaster	= guildWrapper:getGuildMasterName()
			warInfoContent[territoryKey][index]._siegeEnduranceValue = siegeBuildingInfo:getRemainHp() / 10000

			local currentGuildWrapper	= ToClient_GetGuildInfoWrapperByGuildNo( guildWrapper:getGuildNo_s64() )
			
			-- 한국 이외의 국가는 아직 점령전 코드가 모두 적용된 게 아니라 따로 구분해준다!
			if isGameTypeKorea() then
				_destroySiegeCountValue = currentGuildWrapper:getTotalSiegeCount(0)
				_killCountValue			= currentGuildWrapper:getTotalSiegeCount(1)
				_deathCountValue		= currentGuildWrapper:getTotalSiegeCount(2)
				_cannonCountValue		= currentGuildWrapper:getTotalSiegeCount(3)
			else
				for gmIndex = 0, currentGuildWrapper:getMemberCount() -1 do
					local guildMemberData	= currentGuildWrapper:getMember( gmIndex )
					_destroySiegeCountValue	= _destroySiegeCountValue + guildMemberData:commandPostCount() + guildMemberData:towerCount() + guildMemberData:gateCount()
					_killCountValue			= _killCountValue + guildMemberData:guildMasterCount() + guildMemberData:squadLeaderCount() + guildMemberData:squadMemberCount()
					_deathCountValue		= _deathCountValue + guildMemberData:deathCount()
					_cannonCountValue		= _cannonCountValue + guildMemberData:summonedCount()
				end
			end

			if _destroySiegeCountValue ~= warInfoContent[territoryKey][index]._destroySiegeCountValue then
				warInfoContent[territoryKey][index]._destroySiegeCountValue = _destroySiegeCountValue
				destroySiegeCountEffect	= true
			end
			if _killCountValue ~= warInfoContent[territoryKey][index]._killCountValue then
				warInfoContent[territoryKey][index]._killCountValue = _killCountValue
				killCountEffect	= true
			end
			if _deathCountValue ~= warInfoContent[territoryKey][index]._deathCountValue then
				warInfoContent[territoryKey][index]._deathCountValue = _deathCountValue
				deathCountEffect = true
			end
			if _cannonCountValue ~= warInfoContent[territoryKey][index]._cannonCountValue then
				warInfoContent[territoryKey][index]._cannonCountValue = _cannonCountValue
				cannonCountEffect = true
			end
			
			local isSet = setGuildTextureByGuildNo( warInfoContent[territoryKey][index]._guildNo, warInfoContent[territoryKey][index].guildMark )
			if ( false == isSet ) then
				warInfoContent[territoryKey][index].guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
				local x1, y1, x2, y2 = setTextureUV_Func( warInfoContent[territoryKey][index].guildMark, 183, 1, 188, 6 )
				warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
				warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())
			else	
				warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
				warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())
			end
			
			warInfoContent[territoryKey][index].guildName:SetText( warInfoContent[territoryKey][index]._guildName )
			warInfoContent[territoryKey][index].guildMaster:SetText( warInfoContent[territoryKey][index]._guildMaster )
			-- 전주 점령길드 표시하자!
			local occupyGuildWrapper = ToClient_GetOccupyGuildWrapper( territoryKey )
			warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( false )
			if nil ~= occupyGuildWrapper then
				if ( warInfoContent[territoryKey][index]._guildNo == occupyGuildWrapper:getGuildNo_s64() ) then
					warInfoContent[territoryKey][index].lordCrownIcon:SetShow( true )
					warInfoContent[territoryKey][index].guildName:SetPosX( warInfoContent[territoryKey][index].lordCrownIcon:GetPosX() + warInfoContent[territoryKey][index].lordCrownIcon:GetSizeX() + 5 )
				else
					if false == isSiegeBeing( territoryKey ) then
						warInfoContent[territoryKey][index].guildName:SetText( "????????" )
						warInfoContent[territoryKey][index].guildMaster:SetText( "??????" )
						warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( true )
						warInfoContent[territoryKey][index].guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
						local x1, y1, x2, y2 = setTextureUV_Func( warInfoContent[territoryKey][index].guildMark, 183, 1, 188, 6 )
						warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
						warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())					end
				end
			else
				if false == isSiegeBeing( territoryKey ) then
					warInfoContent[territoryKey][index].guildName:SetText( "????????" )
					warInfoContent[territoryKey][index].guildMaster:SetText( "??????" )
					warInfoContent[territoryKey][index].btn_CurrentInfo:SetIgnore( true )
					warInfoContent[territoryKey][index].guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( warInfoContent[territoryKey][index].guildMark, 183, 1, 188, 6 )
					warInfoContent[territoryKey][index].guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
					warInfoContent[territoryKey][index].guildMark:setRenderTexture(warInfoContent[territoryKey][index].guildMark:getBaseTexture())				end
			end
			
			warInfoContent[territoryKey][index].siegeEnduranceValue:SetText( string.format( "%.1f", warInfoContent[territoryKey][index]._siegeEnduranceValue ) .. "%" )

			if true == destroySiegeCountEffect then
				warInfoContent[territoryKey][index].destroySiegeCountIcon:EraseAllEffect()
				warInfoContent[territoryKey][index].destroySiegeCountIcon:AddEffect("UI_GuildWar_ArrowMark01", false, 0.0, 0.0)
			end
			warInfoContent[territoryKey][index].destroySiegeCountValue:SetText( _destroySiegeCountValue )
			
			if true == killCountEffect then
				warInfoContent[territoryKey][index].killCountIcon:EraseAllEffect()
				warInfoContent[territoryKey][index].killCountIcon:AddEffect("UI_GuildWar_ArrowMark01", false, 0.0, 0.0)
			end
			warInfoContent[territoryKey][index].killCountValue:SetText( _killCountValue )
			
			if true == deathCountEffect then
				warInfoContent[territoryKey][index].deathCountIcon:EraseAllEffect()
				warInfoContent[territoryKey][index].deathCountIcon:AddEffect("UI_GuildWar_ArrowMark01", false, 0.0, 0.0)
			end
			warInfoContent[territoryKey][index].deathCountValue:SetText( _deathCountValue )
			
			if true == cannonCountEffect then
				warInfoContent[territoryKey][index].cannonCountIcon:EraseAllEffect()
				warInfoContent[territoryKey][index].cannonCountIcon:AddEffect("UI_GuildWar_ArrowMark01", false, 0.0, 0.0)
			end
			warInfoContent[territoryKey][index].cannonCountValue:SetText( _cannonCountValue )
		
			local currentGuildMp = currentGuildWrapper:getGuildMp()
			
			if warInfoContent[territoryKey][index]._guildMp ~= currentGuildMp then
				warInfoContent[territoryKey][index]._guildMp = currentGuildMp
			end
			warInfoContent[territoryKey][index].moraleProgress:SetProgressRate( warInfoContent[territoryKey][index]._guildMp / 1500 * 100 )
			-- 점령전 중이 아니거나, 점령전에 탈락했거나, 이미 길드를 응원했으면 이그노어, 모노톤
			if ( false == isSiegeEnd() and false == siegeBuildingInfo:isEnterSiege()) or ToClient_IsCheerGuild() or false == isSiegeBeing( territoryKey ) then
				warInfoContent[territoryKey][index].btn_Cheer:SetIgnore( true )
			else
				warInfoContent[territoryKey][index].btn_Cheer:SetIgnore( false )
			end
			
			warInfoContent[territoryKey][index].contentBg:SetShow( true )
			
			local msg = GuildMp_Check( siegeGuildIndex, territoryKey )
			warInfoContent[territoryKey][index].cheerPoint:SetText( msg )
			-- 점령전 진행중일 때, 길드 건물이 없으면 모노톤 아니면 풀어줌 >> 점령전이 끝나도 모노톤 유지
			-- if true == _isSiegeBeing and false == siegeBuildingInfo:isEnterSiege() then					-- and true == isSiegeBeing( territoryKey ) then
			if false == siegeBuildingInfo:isEnterSiege() then
				warInfoContent[territoryKey][index].contentBg:SetMonoTone( true )
				warInfoContent[territoryKey][index].siegeEnduranceValue:SetText( string.format( "%.1f", 0 ) .. "%" )
			else
				warInfoContent[territoryKey][index].contentBg:SetMonoTone( false )
			end
					
			warInfoContent[territoryKey][index].siegeEnduranceIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(".. territoryKey .. ", " .. index .. ", " .. 0 .. ")" )
			warInfoContent[territoryKey][index].siegeEnduranceIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
			warInfoContent[territoryKey][index].destroySiegeCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(".. territoryKey .. ", " .. index .. ", " .. 1 .. ")" )
			warInfoContent[territoryKey][index].destroySiegeCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
			warInfoContent[territoryKey][index].killCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(".. territoryKey .. ", " .. index .. ", " .. 2 .. ")" )
			warInfoContent[territoryKey][index].killCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
			warInfoContent[territoryKey][index].deathCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(".. territoryKey .. ", " .. index .. ", " .. 3 .. ")" )
			warInfoContent[territoryKey][index].deathCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
			warInfoContent[territoryKey][index].cannonCountIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(".. territoryKey .. ", " .. index .. ", " .. 4 .. ")" )
			warInfoContent[territoryKey][index].cannonCountIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
			warInfoContent[territoryKey][index].moraleIcon:addInputEvent ( "Mouse_On", "Panel_GuildWarInfo_Icon_ToolTip_Show(".. territoryKey .. ", " .. index .. ", " .. 5 .. ")" )
			warInfoContent[territoryKey][index].moraleIcon:addInputEvent ( "Mouse_Out", "Panel_GuildWarInfo_Icon_ToolTip_Show()" )
			warInfoContent[territoryKey][index].btn_CurrentInfo:addInputEvent( "Mouse_LUp", "HandleClicked_GuildScore(" .. territoryKey .. ", " .. index .. ")" )
			warInfoContent[territoryKey][index].btn_Cheer:addInputEvent( "Mouse_LUp", "HandleClicked_Cheer(" .. territoryKey .. ", " .. index .. ")" )

			siegeGuildIndex = siegeGuildIndex + 1
		
		end
		
		warInfo_Main.frame_SiegeInfo:UpdateContentScroll()
		if true == guildWarInfo_ShowCheck then
			self._scroll:SetControlTop()
			guildWarInfo_ShowCheck = false
		end
		warInfo_Main.frame_SiegeInfo:UpdateContentPos()
	
		if ( 3 < lastIndex ) then
			self._scroll:SetShow( true )
			self.frame_content:SetSize( self.frame_content:GetSizeX(), self.contentBg:GetSizeY() + warInfoContent[territoryKey][lastIndex-1].contentBg:GetPosY() + gapY )
		else
			self._scroll:SetShow( false )
			self.frame_content:SetSize( self.frame_content:GetSizeX(), warInfo_Main.frame_SiegeInfo:GetSizeY() )
			self.frame_content:SetPosY( 0 )
			self._scroll:SetControlTop()
		end

		local leftGuildCount = battleGuildCount[territoryKey] - eliminatedGuildCount
		warInfo_Content._battleGuildText:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_LEFT_GUILD_COUNT", "leftGuildCount", leftGuildCount ) )
	end
	
	warInfo_Content._battleGuildText:SetShow( isSiegeBeing(territoryKey) )

end

-- 모든 지역이 점령전이 끝났는지 체크
function isSiegeEnd()
	local _isSiegeBeing = false
	for territoryIndex = 0, siegingAreaCount - 1 do
		_isSiegeBeing = _isSiegeBeing or isSiegeBeing( territoryIndex )
	end
	
	return not _isSiegeBeing
end

local _logIndex				= 0
local _logCount				= 0
local viewalbeCount			= 9				-- 한 화면에 표시 가능한 로그 수
local maxLogCount			= 50			-- 최대 저장할 로그 수
local textGap				= 15			-- 로그 줄 간격
local defaultLogFrameSize	= log_Content.frame_content:GetSizeY()

function GuildMp_Check( index, territoryKey )
	local msg = ""
	local guildMpGrade = 0
	local guildWrapper = ToClient_SiegeGuildAt( territoryKey, index )

	if nil ~= guildWrapper then
		local guildMp = guildWrapper:getGuildMp()
		
		if guildMp < 300 then
			guildMpGrade = 0
		elseif 300 <= guildMp and guildMp < 600 then
			guildMpGrade = 1
		elseif 600 <= guildMp and guildMp < 900 then
			guildMpGrade = 2
		elseif 900 < guildMp and guildMp < 1200 then
			guildMpGrade = 3
		elseif 1200 < guildMp and guildMp < 1500 then
			guildMpGrade = 4
		elseif 1500 <= guildMp then
			guildMpGrade = 5
		end
	end
	
	if nil ~= guildMpCheck[territoryKey][index] then
		if  guildMpGrade < guildMpCheck[territoryKey][index] then
			guildMpCheck[territoryKey][index] = guildMpGrade
		elseif guildMpGrade > guildMpCheck[territoryKey][index] then
			guildMpCheck[territoryKey][index] = guildMpGrade
		end
	end

	msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_GUILDMPCHECK_MSG", "guildMpGrade", guildMpGrade ) -- "(사기 " .. guildMpGrade .. "단계)"

	return msg
end

-- 길드 스코어 저장용 배열 생성
local guildScore = {}
for territoryIndex = 0, siegingAreaCount -1 do
	guildScore.destroyBuildCount[territoryIndex]	= {}		-- 공성 빌딩 파괴 카운트
	guildScore.killPlayerCount[territoryIndex]		= {}		-- 킬 카운트
	guildScore.deathCount[territoryIndex]			= {}		-- 데스 카운트
	guildScore.killServantCount[territoryIndex]		= {}		-- 구조물 파괴 카운트
	guildScore.guildMp[territoryIndex]				= {}		-- 길드 사기
end

function Panel_GuildWarInfo_Icon_ToolTip_Show( territoryKey, index, iconType )
	if ( nil == index ) then
		warInfo_Content._tooltip:SetShow( false )
		return
	end
	
	local msg = ""
	local posX = 0
	local posY = 0
	if 5 < iconType then
		posX = warInfo_Content.frame_content:GetPosX() + warInfoContent[territoryKey][index].occupyGuildBg:GetPosX()
		posY = warInfo_Content.frame_content:GetPosY() + warInfoContent[territoryKey][index].occupyGuildBg:GetPosY()
	else
		posX = warInfo_Content.frame_content:GetPosX() + warInfoContent[territoryKey][index].contentBg:GetPosX()
		posY = warInfo_Content.frame_content:GetPosY() + warInfoContent[territoryKey][index].contentBg:GetPosY()
	end
	
	
	if 0 == iconType or 6 == iconType then
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TOOLTIP_0") -- "성채/지휘소 내구도"
		warInfo_Content._tooltip:SetPosX( warInfoContent[territoryKey][index].siegeEnduranceIcon:GetPosX() + posX + 5 )
		warInfo_Content._tooltip:SetPosY( warInfoContent[territoryKey][index].siegeEnduranceIcon:GetPosY() + posY + 70 )
	elseif 1 == iconType or 7 == iconType then
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TOOLTIP_1") -- "성채/지휘소/성문 파괴 횟수"
		warInfo_Content._tooltip:SetPosX()
		warInfo_Content._tooltip:SetPosY()
		warInfo_Content._tooltip:SetPosX( warInfoContent[territoryKey][index].destroySiegeCountIcon:GetPosX() + posX + 5 )
		warInfo_Content._tooltip:SetPosY( warInfoContent[territoryKey][index].destroySiegeCountIcon:GetPosY() + posY + 70 )
	elseif 2 == iconType or 8 == iconType then
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TOOLTIP_2") -- "적 처치 횟수"
		warInfo_Content._tooltip:SetPosX()
		warInfo_Content._tooltip:SetPosY()
		warInfo_Content._tooltip:SetPosX( warInfoContent[territoryKey][index].killCountIcon:GetPosX() + posX + 5 )
		warInfo_Content._tooltip:SetPosY( warInfoContent[territoryKey][index].killCountIcon:GetPosY() + posY + 70 )
	elseif 3 == iconType or 9 == iconType then
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TOOLTIP_3") -- "사망 횟수"
		warInfo_Content._tooltip:SetPosX()
		warInfo_Content._tooltip:SetPosY()
		warInfo_Content._tooltip:SetPosX( warInfoContent[territoryKey][index].deathCountIcon:GetPosX() + posX + 5 )
		warInfo_Content._tooltip:SetPosY( warInfoContent[territoryKey][index].deathCountIcon:GetPosY() + posY + 70 )
	elseif 4 == iconType or 10 == iconType then
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TOOLTIP_4") -- "말/대포 처치 횟수"
		warInfo_Content._tooltip:SetPosX()
		warInfo_Content._tooltip:SetPosY()
		warInfo_Content._tooltip:SetPosX( warInfoContent[territoryKey][index].cannonCountIcon:GetPosX() + posX + 5 )
		warInfo_Content._tooltip:SetPosY( warInfoContent[territoryKey][index].cannonCountIcon:GetPosY() + posY + 70 )
	elseif 5 == iconType or 11 == iconType then
		msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TOOLTIP_5") -- "길드 사기"
		warInfo_Content._tooltip:SetPosX()
		warInfo_Content._tooltip:SetPosY()
		warInfo_Content._tooltip:SetPosX( warInfoContent[territoryKey][index].moraleIcon:GetPosX() + posX + 5 )
		warInfo_Content._tooltip:SetPosY( warInfoContent[territoryKey][index].moraleIcon:GetPosY() + posY + 70 )
	
	else
		warInfo_Content._tooltip:SetShow( false )
		return
	end
	
	warInfo_Content._tooltip:SetShow( true )
	warInfo_Content._tooltip:SetAutoResize( true )
	warInfo_Content._tooltip:SetTextMode( UI_TM.eTextMode_None )
	warInfo_Content._tooltip:SetText( msg )
	warInfo_Content._tooltip:SetSize( warInfo_Content._tooltip:GetTextSizeX() + 10, warInfo_Content._tooltip:GetTextSizeY() )
end

function HandleClicked_Territory()
	warInfo_Main.comboBox_Territory:DeleteAllItem()
	for ii = 0, siegingAreaCount - 1  do
		warInfo_Main.comboBox_Territory:AddItem( territoryName[ii], ii )
	end
	
	warInfo_Main.comboBox_Territory:ToggleListbox()
end

function GuildWarInfo_Set_Territory( index )
	if nil == index then
		warInfo_Main.comboBox_Territory:SetSelectItemIndex(warInfo_Main.comboBox_Territory:GetSelectIndex())
	else
		warInfo_Main.comboBox_Territory:SetSelectItemIndex( index )
	end
	
	local territoryKey = warInfo_Main.comboBox_Territory:GetSelectIndex()
	warInfo_Main.comboBox_Territory:SetText( territoryName[territoryKey] )
	warInfo_Main.comboBox_Territory:ToggleListbox()
	
	warInfo_Main.frame_SiegeInfo:UpdateContentScroll()
	warInfo_Content._scroll:SetControlTop()
	warInfo_Main.frame_SiegeInfo:UpdateContentPos()
	
	selectTerritoy = territoryKey
	FromClient_WarInfoContent_Set( territoryKey )
end

function HandleClicked_GuildScore( territoryKey, index )
	local guildNo_s64 = warInfoContent[territoryKey][index]._guildNo
	if nil == guildNo_s64 then
		return
	end
	local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo( guildNo_s64 )

	if nil ~= guildWrapper then
		FGlobal_GuildWarScore_ShowToggle( guildNo_s64 )
	end
end

function HandleClicked_Cheer( territoryKey, index )
	local guildNo_s64 = warInfoContent[territoryKey][index]._guildNo
	local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo( guildNo_s64 )
	if nil == guildWrapper then
		return
	end
	
	local applyGuildMp = function()
		ToClient_RequestCheerGuild(guildNo_s64)
	end
	
	local messageBoxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_CHEER_MESSAGEBOXMEMO", "getName", tostring(guildWrapper:getName()) ) -- "< " .. tostring(guildWrapper:getName()) .. " > 길드를 응원하시겠습니까?"
	local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_CHEER_MESSAGEBOXDATA"), content = messageBoxMemo, functionYes = applyGuildMp, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function FGlobal_GuildWarInfo_Show()
	if Panel_GuildWarInfo:GetShow() then
		Panel_GuildWarInfo:SetShow( false )
		return
	end
	
	if not Panel_GuildWarInfo:GetShow() then
		audioPostEvent_SystemUi(01,06)
		Panel_GuildWarInfo:SetShow( true, true )
		-- Panel_GuildWarInfo_RePos()
		guildWarInfo_ShowCheck = true
	end
	
	controlReGenerate = nil

	HandleClicked_Territory()
	GuildWarInfo_Set_Territory( selectTerritoy )			-- 창이 열릴 때 점령전 길드 정보 요청(처음엔 발레노스)
	FromClient_NotifySiegeScoreToLog()
end

function FromClient_NotifySiegeScoreToLog()
	if false == Panel_GuildWarInfo:GetShow() then
		return
	end
	
	if ToClient_IsVillageSiegeBeing() then					-- 거점전(점령전 아님!) 중에 로그가 들어오면 무시한다!
		return
	end
	
	local logCount = ToClient_SiegeLogCount()				-- 점령전 중 작성된 로그 수
	if 0 == logCount then
		return
	end
	
	if logCount <= viewalbeCount then
		log_Content._scroll:SetShow( false )
		log_Content.frame_content:SetSize( log_Content.frame_content:GetSizeX(), defaultLogFrameSize )
	else
		log_Content._scroll:SetShow( true )
		log_Content.frame_content:SetSize( log_Content.frame_content:GetSizeX(), defaultLogFrameSize + (logCount - viewalbeCount) * textGap )
	end
	
	log_Content.frame_content:DestroyAllChild()
	local posYIndex = 0
	local msg = ""
	for logIndex = logCount, 1, -1 do
		
		local siegeGuildInfo	= ToClient_GetSiegeLogInfoAt( logIndex - 1 )
		if nil ~= siegeGuildInfo then
		
			local guildMasterCheck = false
			if true == siegeGuildInfo._isCheerUp then
				local guildName = siegeGuildInfo:getGuildName()
				local userName = siegeGuildInfo:getCharacterName()
				if nil ~= guildName and nil ~= userName then
					msg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_CHEERUP", "userName", userName, "guildName", guildName ) -- "<<PAColor0xffffe18e>" .. userName .. "<PAOldColor>>님이 [<PAColor0xFFC8FFC8>" .. guildName .. "<PAOldColor>> 길드를 응원하였습니다."
				
					local txtLog = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, log_Content.frame_content, "GuildWar_Log_" .. logIndex )
					CopyBaseProperty( warInfo_Log.textLog, txtLog )
					log_Content.textLog[logIndex] = txtLog
					log_Content.textLog[logIndex]:SetShow( true )
					
					local isGuildMasterBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, log_Content.frame_content, "GuildWar_LogBg_" .. logIndex )
					CopyBaseProperty( warInfo_Log.isGuildMasterBg, isGuildMasterBg )
					log_Content.isGuildMasterBg[logIndex] = isGuildMasterBg

					log_Content.textLog[logIndex]:SetText( msg )
					log_Content.textLog[logIndex]:SetPosY( log_Content.frame_content:GetSizeY() - (posYIndex+1) * textGap - 2 )
					log_Content.isGuildMasterBg[logIndex]:SetShow( guildMasterCheck )
					log_Content.isGuildMasterBg[logIndex]:SetPosY( log_Content.textLog[logIndex]:GetPosY() + 1 )
					log_Content.isGuildMasterBg[logIndex]:SetSize( log_Content.textLog[logIndex]:GetTextSizeX() + 5, 17)
					posYIndex = posYIndex + 1
				end

			elseif true == siegeGuildInfo._isKill then
				local guildWrapper		= ToClient_GetGuildInfoWrapperByGuildNo( siegeGuildInfo._guildNo )
				if nil == guildWrapper then
					return
				end
				
				local _guildname = guildWrapper:getName()
				
				local guildMemberInfo	= guildWrapper:getMemberByUserNo( siegeGuildInfo._userNo )
				if nil == guildMemberInfo then
					return
				end
				
				local _username = guildMemberInfo:getName()
				
				if nil ~= _guildname and nil ~= _username then
				
					local logType = siegeGuildInfo:getRecordType()
					if 5 == logType then
						msg = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_LOGTYPE_5", "_guildname", _guildname, "_username", _username, "logType", siegeType[siegeGuildInfo:getRecordType()] )
						-- local msg = "[<PAColor0xFFC8FFC8>" .. guildWrapper:getName() .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. guildMemberInfo:getName() .. "<PAOldColor>>님이 " .. siegeType[siegeGuildInfo:getRecordType()]
					
					elseif 3 == logType then
						_PA_LOG("이문종", "점령전 중 이 타입이 들어와선 안됩니다!!" )
					elseif 9 == logType or 10 == logType then
						msg = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_MSG", "guildName", guildWrapper:getName(), "memberName", guildMemberInfo:getName(), "getRecordType", siegeType[siegeGuildInfo:getRecordType()] ) -- "[<PAColor0xFFC8FFC8>" .. guildWrapper:getName() .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. guildMemberInfo:getName() .. "<PAOldColor>>님이 " .. siegeType[siegeGuildInfo:getRecordType()]
					elseif 0 <= logType and logType < 11 then
						local opponentGuildWrapper	= ToClient_GetGuildInfoWrapperByGuildNo( siegeGuildInfo._destGuildNo )
						if nil == opponentGuildWrapper then
							return
						end
						
						local opponentGuildMemInfo	= nil
						if 4 == logType or 6 == logType or 7 == logType then
							opponentGuildMemInfo	= opponentGuildWrapper:getMemberByUserNo( siegeGuildInfo._destUserNo )
						end
						
						guildMasterCheck = false
					
						if nil == opponentGuildMemInfo then
							msg = PAGetStringParam4( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_LOGTYPE_NIL", "_guildname", _guildname, "_username", _username, "opponentGuildName", opponentGuildWrapper:getName(), "logtype", siegeType[logType])
							-- msg = "[<PAColor0xFFC8FFC8>" .. _guildname .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. _username .. "<PAOldColor>>님이 [<PAColor0xFFC8FFC8>" .. opponentGuildWrapper:getName() .. "<PAOldColor>] 길드의 " .. siegeType[logType]
						elseif 4 == logType then
							msg = PAGetStringParam4( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_LOGTYPE_4", "_guildname", _guildname, "_username", _username, "opponentGuildName", opponentGuildWrapper:getName(), "name", opponentGuildMemInfo:getName())
							-- msg = "[<PAColor0xFFC8FFC8>" .. _guildname .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. _username .. "<PAOldColor>>님이 [<PAColor0xFFC8FFC8>" .. opponentGuildWrapper:getName() .. "<PAOldColor>] 길드의 대장 <<PAColor0xffffe18e>" .. opponentGuildMemInfo:getName() .. "<PAOldColor>>님을 처치했습니다."
							guildMasterCheck = true
						elseif 6 == logType then
							msg = PAGetStringParam4( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_LOGTYPE_6", "_guildname", _guildname, "_username", _username, "opponentGuildName", opponentGuildWrapper:getName(), "name", opponentGuildMemInfo:getName())
							-- msg = "[<PAColor0xFFC8FFC8>" .. _guildname .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. _username .. "<PAOldColor>>님이 [<PAColor0xFFC8FFC8>" .. opponentGuildWrapper:getName() .. "<PAOldColor>] 길드의 부대장 <<PAColor0xffffe18e>" .. opponentGuildMemInfo:getName() .. "<PAOldColor>>님을 처치했습니다."
						elseif 7 == logType then
							msg = PAGetStringParam4( Defines.StringSheet_GAME, "LUA_GUILDWARINFO_LOGTYPE_7", "_guildname", _guildname, "_username", _username, "opponentGuildName", opponentGuildWrapper:getName(), "name", opponentGuildMemInfo:getName())
							-- msg = "[<PAColor0xFFC8FFC8>" .. _guildname .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. _username .. "<PAOldColor>>님이 [<PAColor0xFFC8FFC8>" .. opponentGuildWrapper:getName() .. "<PAOldColor>] 길드의 <<PAColor0xffffe18e>" .. opponentGuildMemInfo:getName() .. "<PAOldColor>>님을 처치했습니다."
						end
					end
					
					local txtLog = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, log_Content.frame_content, "GuildWar_Log_" .. logIndex )
					CopyBaseProperty( warInfo_Log.textLog, txtLog )
					log_Content.textLog[logIndex] = txtLog
					log_Content.textLog[logIndex]:SetShow( true )
					
					local isGuildMasterBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, log_Content.frame_content, "GuildWar_LogBg_" .. logIndex )
					CopyBaseProperty( warInfo_Log.isGuildMasterBg, isGuildMasterBg )
					log_Content.isGuildMasterBg[logIndex] = isGuildMasterBg

					log_Content.textLog[logIndex]:SetText( msg )
					log_Content.textLog[logIndex]:SetPosY( log_Content.frame_content:GetSizeY() - (posYIndex+1) * textGap - 2 )
					log_Content.isGuildMasterBg[logIndex]:SetShow( guildMasterCheck )
					log_Content.isGuildMasterBg[logIndex]:SetPosY( log_Content.textLog[logIndex]:GetPosY() + 1 )
					log_Content.isGuildMasterBg[logIndex]:SetSize( log_Content.textLog[logIndex]:GetTextSizeX() + 5, 17)
					posYIndex = posYIndex + 1
				end
			end
		end
	end
	
	warInfo_Log.frame_SiegeLog:UpdateContentScroll()
	if true == guildWarInfo_ShowCheck then
		log_Content._scroll:SetControlPos(1)
		guildWarInfo_ShowCheck = false
	end
	warInfo_Log.frame_SiegeLog:UpdateContentPos()
	
	if logCount <= viewalbeCount then
		log_Content._scroll:SetShow( false )
		log_Content.frame_content:SetSize( log_Content.frame_content:GetSizeX(), defaultLogFrameSize )
	else
		log_Content._scroll:SetShow( true )
		log_Content.frame_content:SetSize( log_Content.frame_content:GetSizeX(), defaultLogFrameSize + (logCount - viewalbeCount) * textGap )
	end
	
end

function Panel_GuildWarInfo_Hide()
	Panel_GuildWarInfo:SetShow( false, false )
end

function Panel_GuildWarInfo_RePos()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	local posY = scrY/2 - Panel_GuildWarInfo:GetSizeY()/2 - 100
	if posY < 0 then
		posY = scrY/2 - Panel_GuildWarInfo:GetSizeY()/2
	end

	Panel_GuildWarInfo:SetPosX( 0 )
	Panel_GuildWarInfo:SetPosY( posY )
end

function SiegeStatusUpdate()
	FromClient_WarInfoContent_Set( -1 )
end

function FromClient_NotifyAttackedKingOrLordTentToScore( percent, territoryKey, guildNo )
	-- for index = 0, battleGuildCount[territoryKey] - 1 do
		-- if warInfoContent[territoryKey][index]._guildNo == guildNo then
			-- warInfoContent[territoryKey][index]._siegeEnduranceValue = percent / 10000
		-- end
	-- end
	
	if selectTerritoy == territoryKey then
		FromClient_WarInfoContent_Set( territoryKey )
	end
end




registerEvent( "Event_SiegeScoreUpdateData",						"FromClient_WarInfoContent_Set" )
registerEvent( "FromClient_KingOrLordTentCountUpdate",				"FromClient_WarInfoContent_Set" )
registerEvent( "FromClient_NotifyAttackedKingOrLordTentToScore",	"FromClient_NotifyAttackedKingOrLordTentToScore" )
registerEvent( "FromClient_NotifySiegeScoreToLog",					"FromClient_NotifySiegeScoreToLog" )
registerEvent( "FromClient_NotifySiegeGuildLoadComplete", 			"BattleGuildCount_Update" )
registerEvent( "onScreenResize",									"Panel_GuildWarInfo_RePos" )

-- registerEvent( "FromClient_OccupySiege",							"SiegeStatusUpdate" )					-- 점령 : 인자 regionKeyRaw, guildName
-- registerEvent( "FromClient_ReleaseSiege",						"SiegeStatusUpdate" )					-- 해방 : 인자 regionKeyRaw

-- registerEvent( "FromClient_NotifyStartSiege",					"SiegeStatusUpdate")					-- 점령전 시작 : 인자 msgtype(int), territoryKey(int)
-- registerEvent( "FromClient_KillOrDeathPlayer",					"FromClient_WarInfoContent_Set" )		-- Player 킬 변화
-- registerEvent( "FromClient_KingOrLordTentChange",				"FromClient_WarInfoContent_Set" )		-- 성채/지휘소 변화
-- registerEvent( "FromClient_ResponseSiegeWarScoreByGuildNo",		"FromClient_WarInfoContent_Set" )
-- registerEvent( "FromClient_ListSiegeGuild",						"FromClient_WarInfoContent_Set" )
-- registerEvent( "FromClient_ResponseSiegeWarScoreByGuildNo",		"FromClient_NotifySiegeScoreToLog" )


BattleGuildCount_Update()																					-- 해당 루아파일이 로딩되는 시점에 전 영지의 점령전 현황 UI 컨트롤들을 초기화
Panel_GuildWarInfo_RePos()






