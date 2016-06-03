local UIGroup			= Defines.UIGroup
isLuaLoadingComplete	= false
local isGrandOpen		= true;

function loadLogoUI()
	loadUI("UI_Data/UI_Lobby/UI_Logo.xml","Panel_Logo", UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)
	
	runLua("UI_Data/Script/Panel_Logo.lua")
	runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
end

function loadLoginUI()
	loadUI("UI_Data/UI_Lobby/UI_TermsofGameUse.XML","Panel_TermsofGameUse", UIGroup.PAGameUIGroup_Movie)
	loadUI("UI_Data/UI_Lobby/UI_Login.xml","Panel_Login", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/UI_Lobby/UI_Login_Password.XML","Panel_Login_Password",UIGroup.PAGameUIGroup_GameSystemMenu)
	loadUI("UI_Data/UI_Lobby/UI_Login_Nickname.XML","Panel_Login_Nickname",UIGroup.PAGameUIGroup_GameSystemMenu)
	loadUI("UI_Data/Window/MessageBox/UI_Win_System.XML","Panel_Win_System",UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/HelpMessage/Panel_HelpMessage.xml",		"Panel_HelpMessage",		UIGroup.PAGameUIGroup_GameMenu)
	
	runLua("UI_Data/Script/Panel_TermsofGameUse.lua")
	runLua("UI_Data/Script/Panel_Login.lua")
	runLua("UI_Data/Script/Panel_Login_Password.lua")			-- 2차비밀번호
	runLua("UI_Data/Script/Panel_Login_Nickname.lua")			-- 닉네임 설정
	runLua("UI_Data/Script/Window/MessageBox/MessageBox.lua")
	
	runLua("UI_Data/Script/globalKeyBinderNotPlay.lua")
	runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
	runLua("UI_Data/Script/Widget/HelpMessage/Panel_HelpMessage.lua")
	
	preLoadGameOptionUI()
	loadGameOptionUI()
end

function loadServerSelectUI()
	loadUI("UI_Data/UI_Lobby/UI_ServerSelect_New.xml","Panel_ServerSelect", UIGroup.PAGameUIGroup_Windows)
	--loadUI("UI_Data/UI_Lobby/UI_ServerSelect_New.XML","Panel_ServerSelect_New", UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/MessageBox/UI_Win_System.XML","Panel_Win_System",UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)
	
	runLua("UI_Data/Script/Panel_ServerSelect.lua")
	runLua("UI_Data/Script/Window/MessageBox/MessageBox.lua")
	runLua("UI_Data/Script/globalKeyBinderNotPlay.lua")
	runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
end

function loadLoadingUI()

	loadUI("UI_Data/UI_Loading/UI_Loading_Progress.xml","Panel_Loading", UIGroup.PAGameUIGroup_GameSystemMenu)
	
	runLua("UI_Data/Script/Panel_Loading.lua")
	if isGrandOpen then
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeName.XML",					"Panel_NodeName",					UIGroup.PAGameUIGroup_Interaction)
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_InSideNode.XML",			"Panel_NodeMenu",					UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_InSideNode_Guild.XML",		"Panel_NodeOwnerInfo",				UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 내 점령정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeSiegeTooltip.XML",			"Panel_NodeSiegeTooltip",			UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 거점전 정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_WarInfo.XML",					"Panel_Win_Worldmap_WarInfo",		UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeWarInfo.XML",				"Panel_Win_Worldmap_NodeWarInfo",	UIGroup.PAGameUIGroup_WorldMap_Popups) -- 거점전
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_NavigationButton.XML",		"Panel_NaviButton",					UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 내비 버튼
	else
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeName.XML",					"Panel_NodeName",					UIGroup.PAGameUIGroup_WorldMap)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_nodeMenu.XML",					"Panel_NodeMenu",					UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_nodeGuildWarMenu.XML",			"Panel_NodeGuildWarMenu",			UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 내 점령정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeSiegeTooltip.XML",			"Panel_NodeSiegeTooltip",			UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 거점전 정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_WarInfo.XML",					"Panel_Win_Worldmap_WarInfo",		UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeWarInfo.XML",				"Panel_Win_Worldmap_NodeWarInfo",	UIGroup.PAGameUIGroup_WorldMap_Popups) -- 거점전
	end

	loadUI("UI_Data/Widget/WarInfoMessage/Panel_WarInfoMessage.XML",				"Panel_WarInfoMessage", UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전 메시지
	loadUI("UI_Data/Widget/WarInfoMessage/Panel_TerritoryWarKillingScore.XML",		"Panel_TerritoryWarKillingScore", UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전 킬데스 메시지
	loadUI("UI_Data/Window/HouseInfo/Panel_WolrdHouseInfo.XML",		"Panel_WolrdHouseInfo", UIGroup.PAGameUIGroup_WorldMap_Popups) -- 테스트용
	loadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)

	ToClient_initializeWorldMap("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_Base.XML")
	
	if isGrandOpen then
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_PopupManager.lua")				-- Worldmap Popup 관리
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap.lua")								-- 월드맵 루아
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_HouseHold.lua")					-- 월드맵 House 관련 루아( 생산, 제작은 따로 분리 )
		runLua("UI_Data/Script/Window/WorldMap_Grand/Grand_WorldMap_NodeMenu.lua")					-- Worldmap core
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Knowledge.lua")					-- 지식
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Delivery.lua")					-- 운송정보(아이콘)				-- independent
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_PinGuide.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WarInfo.lua")						-- 점령전 현황판
	else
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_PopupManager.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_HouseHold.lua")						-- 월드맵 House 관련 루아( 생산, 제작은 따로 분리 )
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Node.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Knowledge.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Delivery.lua")			-- 운송정보(아이콘)
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_PinGuide.lua")
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_WarInfo.lua")			-- 점령전 정보
	end
	
	runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
	
	ToCleint_openWorldMapForLoading()
--
	
end

function preloadCustomizationUI()
		loadUI("UI_Data/Customization/UI_Customization_Common_Decoration.xml",	"Panel_Customization_Common_Decoration",	UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Main.XML",				"Panel_CustomizationMain",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Transform.xml",			"Panel_CustomizationTransform",				UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_TransformHair.xml",		"Panel_CustomizationTransformHair",			UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_TransformBody.xml",		"Panel_CustomizationTransformBody",			UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_CustomizationTest.xml",				"Panel_CustomizationTest",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Control.xml",			"Panel_Customization_Control",				UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Mesh.xml",				"Panel_CustomizationMesh",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Motion.xml",				"Panel_CustomizationMotion",				UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Expression.xml",			"Panel_CustomizationExpression",			UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Cloth.xml",				"Panel_CustomizationCloth",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_PoseEditor.xml",			"Panel_CustomizationPoseEdit",				UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Frame.xml",				"Panel_CustomizationFrame",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Skin.xml",				"Panel_CustomizationSkin",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Static.xml",				"Panel_CustomizationStatic",				UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Message.xml",			"Panel_CustomizationMessage",				UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_Voice.xml", 				"Panel_CustomizationVoice",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_TextureMenu.xml",		"Panel_CustomizationTextureMenu",			UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Customization/UI_Customization_ImagePreset.xml",		"Panel_CustomizationImage",					UIGroup.PAGameUIGroup_Windows)
		loadUI("UI_Data/Window/FileExplorer/FileExplorer.XML", "Panel_FileExplorer", UIGroup.PAGameUIGroup_Windows)
end

function loadCustomizationUI()

		runLua("UI_Data/Script/Customization/Customization_Common.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_HairShape.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_Common_Decoration.lua")
		
		runLua("UI_Data/Script/Customization/Panel_Customization_UiFrame.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_Mesh.lua")
	
		runLua("UI_Data/Script/Customization/Panel_Customization_FaceBone.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_BodyBone.lua")	
		runLua("UI_Data/Script/Customization/Panel_Customization_Skin.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_Pose.lua")	
		runLua("UI_Data/Script/Customization/Panel_Customization_Palette.lua")
		runLua("UI_Data/Script/Customization/Panel_CharacterCreation_Main.lua")
		runLua("UI_Data/Script/Customization/Panel_Action_Expression.lua")
		runLua("UI_Data/Script/Customization/Panel_Action_Cloth.lua")
		runLua("UI_Data/Script/Customization/Panel_Action_Pose.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_Voice.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_TextureMenu.lua")
		runLua("UI_Data/Script/Customization/Panel_Customization_Image.lua")
		runLua("UI_Data/Script/Window/FileExplorer/FileExplorer.lua")
		runLua("UI_Data/Script/Window/FileExplorer/FileExplorer_Customization.lua")
end


function loadLobbyUI()
	loadUI("UI_Data/UI_Lobby/UI_Startl.xml",						"Panel_Start", 						UIGroup.PAGameUIGroup_Windows)

	--loadUI("UI_Data/UI_Lobby/UI_Customization_MainSlide.XML","Panel_CustomizationMainSlide", UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/UI_Lobby/UI_CharacterSelect.xml",				"Panel_CharacterSelect", 			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/UI_Lobby/UI_CharacterSelectNew.xml",			"Panel_CharacterSelectNew", 		UIGroup.PAGameUIGroup_Windows)
	
	loadUI("UI_Data/UI_Lobby/UI_CharacterCreate_SelectClass.xml",	"Panel_CharacterCreateSelectClass", UIGroup.PAGameUIGroup_Windows) -- 클래스 선택창 추가
	loadUI("UI_Data/UI_Lobby/UI_CharacterCreate.xml",				"Panel_CharacterCreate", 			UIGroup.PAGameUIGroup_Windows)
	
	loadUI("UI_Data/Window/MessageBox/UI_Win_System.XML",			"Panel_Win_System",					UIGroup.PAGameUIGroup_ModalDialog)

	-- 첫 옵션
	loadUI("UI_Data/Window/FirstLogin/Panel_FirstLogin.XML",		"Panel_FirstLogin", 				UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Widget/NoticeAlert/NoticeAlert.XML",			"Panel_NoticeAlert", 				UIGroup.PAGameUIGroup_GameSystemMenu)
	loadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)

	-- 공통 UI Mode  ----------------------------------------------------------
	runLua("UI_Data/Script/Common/Common_UIMode.lua")
	
	preloadCustomizationUI()
	loadCustomizationUI()
	
	runLua("UI_Data/Script/Widget/Lobby/Panel_Lobby_Main.lua")
	runLua("UI_Data/Script/Widget/Lobby/Panel_Lobby_SelectCharacter.lua")
	
	-- 캐릭터 생성 main
	
	--runLua("UI_Data/Script/Panel_CharacterCreation_MainSlide.lua")
	runLua("UI_Data/Script/Window/MessageBox/MessageBox.lua")
	runLua("UI_Data/Script/globalKeyBinderNotPlay.lua")

	runLua("UI_Data/Script/Window/FirstLogin/Panel_FirstLogin.lua")	-- 첫 옵션
	runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
	
----------------------------------------------------------
		-- 공지 사항 --------------------------------------------------------------------------------------------------
	runLua("UI_Data/Script/Widget/NoticeAlert/NoticeAlert.lua")
end

function preLoadGameUI()
	debug = nil
	----------------------------------------------------------
		-- ● 영상 보기  ----------------------------------------------------------
	loadUI( "UI_Data/Window/Movie/Panel_MovieTheater_MessageBox.XML",		"Panel_MovieTheater_MessageBox",		UIGroup.PAGameUIGroup_Movie )
	loadUI( "UI_Data/Window/Movie/UI_IntroMovie.xml",						"Panel_IntroMovie",						UIGroup.PAGameUIGroup_Movie )
	loadUI( "UI_Data/Window/Movie/Panel_MovieTheater_320.XML",				"Panel_MovieTheater_320",				UIGroup.PAGameUIGroup_Movie )
	loadUI( "UI_Data/Window/Movie/Panel_MovieTheater_640.XML",				"Panel_MovieTheater_640",				UIGroup.PAGameUIGroup_Movie )
	loadUI( "UI_Data/Window/Movie/Panel_MovieTheater_LowLevel.XML",			"Panel_MovieTheater_LowLevel",			UIGroup.PAGameUIGroup_Movie )
	loadUI( "UI_Data/Window/Movie/Panel_MovieTheater_SkillGuide_640.XML",	"Panel_MovieTheater_SkillGuide_640",	UIGroup.PAGameUIGroup_Movie )
		
	-- WebUI용 IME 다른 웹 UI들 보다 먼저 로드
----------------------------------------------------------------------------------------------
	loadUI("UI_Data/Window/Panel_IME.XML",						"Panel_IME", 				UIGroup.PAGameUIGroup_WorldMap_Popups)
	loadUI("UI_Data/Window/Mail/Panel_Mail_InputText.XML",		"Panel_Mail_InputText", 	UIGroup.PAGameUIGroup_WorldMap_Popups)
	loadUI("UI_Data/Window/WebHelper/Panel_WebControl.XML",		"Panel_WebControl",			UIGroup.PAGameUIGroup_DeadMessage)
	loadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)
	

	-- 스킬용 특수 UI
	-- 도움말 버튼 툴팁 ----------------------------------------------------------
	loadUI("UI_Data/Widget/HelpMessage/Panel_HelpMessage.xml",		"Panel_HelpMessage",		UIGroup.PAGameUIGroup_GameMenu)
----------------------------------------------------------
	-- 첫 옵션
	loadUI("UI_Data/Window/FirstLogin/Panel_FirstLogin.XML",		"Panel_FirstLogin", 		UIGroup.PAGameUIGroup_Windows )
	
	-- 엘프 : 스나이핑 ----------------------------------------------------------
	loadUI("UI_Data/InGame/XML/PEW/Panel_Skill_Elf_Snipe.XML",		"Panel_Skill_Elf_Snipe", 	UIGroup.PAGameUIGroup_MainUI)
-------------------------------------------------------------------------------
	-- 카운터 어택 ----------------------------------------------------------
	loadUI("UI_Data/InGame/XML/CounterAttack.XML",					"Panel_CounterAttack", 		UIGroup.PAGameUIGroup_MainUI)
-------------------------------------------------------------------------------
	-- 글로벌 메뉴얼 ( 미니게임 등 ) ----------------------------------------------------------
	loadUI( "UI_Data/Widget/GlobalManual/Panel_Global_Manual.xml",	"Panel_Global_Manual",		UIGroup.PAGameUIGroup_MainUI )
-------------------------------------------------------------------------------

--[[ *********************WINDOW************************ --]]
	-- 점령전 정보
	loadUI("UI_Data/Window/GuildWarInfo/Panel_GuildWarInfo.XML",					"Panel_GuildWarInfo", 				UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/GuildWarInfo/Panel_GuildWarScore.XML",					"Panel_GuildWarScore", 				UIGroup.PAGameUIGroup_Windows)

	-- 경매
	loadUI("UI_Data/Window/Auction/Panel_House_Auction.xml",						"Panel_Auction", 					UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Auction/Panel_GuildHouse_Auction.XML",					"Panel_GuildHouse_Auction", 		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Auction/Panel_Villa_Auction.XML",						"Panel_Villa_Auction",		 		UIGroup.PAGameUIGroup_Windows)
	
	-- 영지 무역 입찰 ----------------------------------------------------------
	loadUI("UI_Data/Window/TerritoryTrade/Panel_Territory_authority.xml",			"Panel_TerritoryAuth_Auction",		UIGroup.PAGameUIGroup_Windows)
	-- loadUI("UI_Data/Window/TerritoryTrade/Panel_TerritoryAuth_Message.xml",			"Panel_TerritoryAuth_Message",		UIGroup.PAGameUIGroup_ModalDialog)
----------------------------------------------------------
	-- 플레이어 정보----------------------------------------------------------
	loadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Basic.xml",		"Panel_Window_CharInfo_BasicStatus",UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Title.xml",		"Panel_Window_CharInfo_TitleInfo",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_History.XML",		"Panel_Window_CharInfo_HistoryInfo",UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo_Challenge.XML",	"Panel_Window_Challenge",			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/CharacterInfo/UI_Window_CharacterInfo.xml",				"Panel_Window_CharInfo_Status",		UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
	-- 생활랭킹 정보----------------------------------------------------------
	loadUI("UI_Data/Window/LifeRanking/Panel_LifeRanking.xml", "Panel_LifeRanking", UIGroup.PAGameUIGroup_Windows)
	
	loadUI("UI_Data/Window/Recommand/Panel_Window_Recommand.xml", "Panel_RecommandName", UIGroup.PAGameUIGroup_Windows)
	
----------------------------------------------------------
	-- 붉은 전장 현황판----------------------------------------------------------
	loadUI("UI_Data/Window/LocalWar/Panel_LocalWarInfo.xml", "Panel_LocalWarInfo", UIGroup.PAGameUIGroup_Windows)
	----------------------------------------------------------
		-- 루팅 ----------------------------------------------------------
	loadUI("UI_Data/Window/Looting/UI_Window_Looting.XML","Panel_Looting", UIGroup.PAGameUIGroup_Windows)
	
	-- 염색 하기 ----------------------------------------------------------
	-- loadUI("UI_Data/Window/Dye/Panel_Dye.XML",							"Panel_Dye",			UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Window/Dye/Panel_DyePreview.XML",					"Panel_DyePreview",					UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Window/Dye/Panel_Dye_New.XML",						"Panel_Dye_New",					UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Window/Dye/Panel_DyeNew_CharacterController.XML",	"Panel_DyeNew_CharacterController",	UIGroup.PAGameUIGroup_Housing)
	loadUI("UI_Data/Window/Dye/Panel_DyePalette.XML",					"Panel_DyePalette",					UIGroup.PAGameUIGroup_Windows)	-- 팔레트

	loadUI("UI_Data/Window/Dye/Panel_ColorBalance.XML",					"Panel_ColorBalance",				UIGroup.PAGameUIGroup_Window_Progress)
	-- 게임 메뉴 보다 높아야 함.
	
	
----------------------------------------------------------
		-- 인벤토리 ----------------------------------------------------------
	loadUI( "UI_Data/Window/Inventory/UI_Window_Inventory.xml",							"Panel_Window_Inventory",					UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Inventory/UI_Inventory_SkillCooltime_Effect_Item_Slot.XML",	"Panel_Inventory_CoolTime_Effect_Item_Slot",UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Widget/Popup/UI_Popup_Inventory.XML",								"Panel_Popup_MoveItem",						UIGroup.PAGameUIGroup_GameMenu )
	loadUI( "UI_Data/Window/MessageBox/UI_Win_UseItem.xml",								"Panel_UseItem",							UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Inventory/UI_Inventory_Manufacture_Note.XML",				"Panel_Invertory_Manufacture_BG",			UIGroup.PAGameUIGroup_Window_Progress )
	loadUI( "UI_Data/Window/Inventory/UI_Inventory_ExchangeItemButton.XML",				"Panel_Invertory_ExchangeButton",			UIGroup.PAGameUIGroup_Window_Progress )
----------------------------------------------------------
		-- 장착 ----------------------------------------------------------
	loadUI("UI_Data/Window/Equipment/UI_Window_Equipment.XML","Panel_Equipment", UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------

	-- 만료 기간 연장 ---------------------------------------------------------------
	loadUI("UI_Data/Window/ExtendExpiration/Panel_ExtendExpiration.XML",		"Panel_ExtendExpiration",		UIGroup.PAGameUIGroup_Window_Progress)

		-- 영주 메뉴 ----------------------------------------------------------
	loadUI("UI_Data/Window/LordMenu/Panel_LordMenu_Territory.XML",				"Panel_LordMenu_Territory",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/LordMenu/Panel_LordMenu_PayInfo.XML",				"Panel_LordMenu_PayInfo",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/LordMenu/Panel_LordMenu_TaxControl.XML",				"Panel_LordMenu_TaxControl",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/LordMenu/Panel_LordMenu_Main.XML",					"Panel_LordMenu",				UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/LordMenu/Panel_Lord_Controller.XML",					"Panel_Lord_Controller",		UIGroup.PAGameUIGroup_WorldMap_Popups)
	loadUI("UI_Data/Window/LordMenu/Panel_LordMenu_TerritoryTex_Message.XML",	"Panel_TerritoryTex_Message",	UIGroup.PAGameUIGroup_WorldMap_Popups)
----------------------------------------------------------
		-- 거점전 메뉴 ----------------------------------------------------------
	loadUI("UI_Data/Window/NodeWarMenu/Panel_NodeWarMenu_Main.XML",				"Panel_NodeWarMenu",			UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
		-- 스킬창 ----------------------------------------------------------
	loadUI("UI_Data/Window/Skill/UI_Window_Skill.xml",						"Panel_Window_Skill",				UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Skill/UI_Window_SkillGuide.xml",					"Panel_Window_SkillGuide",			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Skill/Panel_EnableSkill.XML",					"Panel_EnableSkill",				UIGroup.PAGameUIGroup_Windows)		-- 배울 수 있는 스킬을 표시
	loadUI("UI_Data/Window/SkillAwaken/UI_Frame_SkillAwaken_List.xml",		"Panel_Frame_AwkSkillList",			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/SkillAwaken/UI_Frame_SkillAwaken_Options.xml",	"Panel_Frame_AwkOptions",			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/SkillAwaken/UI_Window_SkillAwaken.xml",			"Panel_SkillAwaken",				UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/SkillAwaken/Panel_SkillAwaken_ResultOption.xml",	"Panel_SkillAwaken_ResultOption",	UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
		-- 출석 체크 ----------------------------------------------------------
	loadUI("UI_Data/Window/DailyStamp/UI_Window_DailyStamp.XML",			"Panel_Window_DailyStamp",			UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
		-- 흑정령의 모험 -------------------------------------------------------
	loadUI("UI_Data/Window/BlackSpiritAdventure/Panel_Window_BlackSpiritAdventure.XML",		"Panel_Window_BlackSpiritAdventure",	UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
		-- 퀘스트 History----------------------------------------------------------
	loadUI("UI_Data/Window/Quest/UI_Window_Quest_New.xml","Panel_Window_Quest_New",UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Quest/UI_Window_Quest_History.xml","Panel_Window_Quest_History",UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
	-- 주점 술 사기 ----------------------------------------------------------
	loadUI("UI_Data/Window/BuyDrink/Panel_BuyDrink.XML","Panel_BuyDrink", UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
	-- 상점 ----------------------------------------------------------
	loadUI("UI_Data/Window/Shop/UI_Win_Npc_Shop.xml","Panel_Window_NpcShop", UIGroup.PAGameUIGroup_Windows)
	-- 일꾼 고용창 ----------------------------------------------------------
	loadUI("UI_Data/Window/Worldmap/WorkerRandomSelect/UI_New_WorkerRandomSelect.XML","Panel_Window_WorkerRandomSelect", UIGroup.PAGameUIGroup_Windows)
	-- 랜덤 아이템 ----------------------------------------------------------
	loadUI("UI_Data/Window/Worldmap/UnKnowItemSelect/UI_New_UnKnowItemSelect.XML","Panel_Window_UnknownRandomSelect", UIGroup.PAGameUIGroup_Windows)
	----------------------------------------------------------
		-- 강화창 ----------------------------------------------------------
	loadUI("UI_Data/Window/Enchant/UI_Win_Enchant.XML","Panel_Window_Enchant", UIGroup.PAGameUIGroup_Windows)
	----------------------------------------------------------
		-- 보석 홈 ----------------------------------------------------------
	loadUI("UI_Data/Window/Socket/UI_Win_Enchant_Socket.XML","Panel_Window_Socket", UIGroup.PAGameUIGroup_Windows)
	----------------------------------------------------------
	-- 주거지 ----------------------------------------------------------
	loadUI("UI_Data/Window/HouseInfo/Panel_MyHouseNavi.XML","Panel_MyHouseNavi", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Housing/Panel_HousingList.XML",	"Panel_HousingList",UIGroup.PAGameUIGroup_Windows)		-- 내 주거지 목록
	loadUI("UI_Data/Widget/Housing/Panel_HarvestList.XML",	"Panel_HarvestList",UIGroup.PAGameUIGroup_Windows)		-- 내 텃밭 목록
	----------------------------------------------------------
	-- 말 ----------------------------------------------------------
	loadUI("UI_Data/Window/Inventory/UI_Window_ServantInventory.XML",	"Panel_Window_ServantInventory",UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/UI_TopIcon_Servant.XML",			"Panel_Window_Servant",			UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Window/Servant/UI_HorseMp.XML",					"Panel_HorseMp",				UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Window/Servant/UI_HorseHp.XML",					"Panel_HorseHp",				UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Window/Servant/UI_ServantInfo.xml",				"Panel_Window_ServantInfo",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/UI_CarriageInfo.xml",			"Panel_CarriageInfo",			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/UI_LinkedHorse_Skill.XML",		"Panel_LinkedHorse_Skill",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/UI_ShipInfo.xml",				"Panel_ShipInfo",				UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Panel_GuildServantList.xml",		"Panel_GuildServantList",		UIGroup.PAGameUIGroup_Windows)
	----------------------------------------------------------

	-- 대포 --------------------------------------------------------
	loadUI("UI_Data/Window/Servant/UI_Cannon.XML",					"Panel_Cannon",					UIGroup.PAGameUIGroup_Widget)
	----------------------------------------------------------------


	-- 창고 --------------------------------------------------
	loadUI("UI_Data/Window/WareHouse/UI_Window_WareHouse.XML", 		"Panel_Window_Warehouse",		UIGroup.PAGameUIGroup_WorldMap_Contents)
----------------------------------------------------------
	-- 운송 --------------------------------------------------
	loadUI("UI_Data/Window/Delivery/UI_Window_Delivery_Request.XML",		"Panel_Window_Delivery_Request",				UIGroup.PAGameUIGroup_WorldMap_Contents)
	loadUI("UI_Data/Window/Delivery/UI_Window_Delivery_Information.XML",	"Panel_Window_Delivery_Information",			UIGroup.PAGameUIGroup_WorldMap_Contents)
	loadUI("UI_Data/Window/Delivery/UI_Window_Delivery_InformationView.XML","Panel_Window_Delivery_InformationView",		UIGroup.PAGameUIGroup_WorldMap_Contents)
	loadUI("UI_Data/Window/Delivery/UI_Window_Carriage_Information.XML",	"Panel_Window_Delivery_CarriageInformation",	UIGroup.PAGameUIGroup_WorldMap_Popups)
------------------------------------------------------------------------------------------------------------------------------------------------------
	--- 마구간 ---------------------------------------------------------------------------------------------------------------------------------------
	loadUI("UI_Data/Window/MessageBox/UI_Win_Check.XML",						"Panel_Win_Check",				UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Function.XML",		"Panel_Window_StableFunction",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Register.XML",		"Panel_Window_StableRegister",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_List.XML",			"Panel_Window_StableList",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Info.XML",			"Panel_Window_StableInfo",		UIGroup.PAGameUIGroup_Party)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Equipment.XML",		"Panel_Window_StableEquipInfo",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Shop.XML",			"Panel_Window_StableShop",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Breed.XML",			"Panel_Window_StableMating",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Market.XML",			"Panel_Window_StableMarket",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_ConfirmMarket.XML",	"Panel_Servant_Market_Input",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_Mix.XML",			"Panel_Window_StableMix",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_AddToCarriage.XML",	"Panel_AddToCarriage",			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Stable/UI_Window_Stable_LookChange.XML",		"Panel_Window_HorseLookChange",	UIGroup.PAGameUIGroup_Windows)
------------------------------------------------------------------------------------------------------------------------------------------------------
	--- 길드 마구간 ---------------------------------------------------------------------------------------------------------------------------------------
	loadUI("UI_Data/Window/Servant/GuildStable/UI_Window_GuildStable_Function.XML",	"Panel_Window_GuildStableFunction",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/GuildStable/UI_Window_GuildStable_List.XML",		"Panel_Window_GuildStable_List",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/GuildStable/UI_Window_GuildStable_Info.XML",		"Panel_Window_GuildStable_Info",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/GuildStable/UI_Window_GuildStable_Register.XML",	"Panel_Window_GuildStableRegister",		UIGroup.PAGameUIGroup_Windows)
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 	--- 선착장 ---------------------------------------------------------------------------------------------------------------------------------------
	loadUI("UI_Data/Window/Servant/Wharf/UI_Window_Wharf_Function.XML",		"Panel_Window_WharfFunction",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Wharf/UI_Window_Wharf_Register.XML",		"Panel_Window_WharfRegister",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Wharf/UI_Window_Wharf_List.XML",			"Panel_Window_WharfList",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Servant/Wharf/UI_Window_Wharf_Info.XML",			"Panel_Window_WharfInfo",		UIGroup.PAGameUIGroup_Windows)

------------------------------------------------------------------------------------------------------------------------------------------------------
	--- 펫관리 ---------------------------------------------------------------------------------------------------------------------------------------
	-- loadUI("UI_Data/Window/Servant/Pet/UI_Window_Pet_Function.XML",		"Panel_Window_PetFunction",	UIGroup.PAGameUIGroup_Windows)
	-- loadUI("UI_Data/Window/Servant/Pet/UI_Window_Pet_Register.XML",		"Panel_Window_PetRegister",	UIGroup.PAGameUIGroup_Windows)
	-- loadUI("UI_Data/Window/Servant/Pet/UI_Window_Pet_List.XML",			"Panel_Window_PetList",		UIGroup.PAGameUIGroup_Windows)
	-- loadUI("UI_Data/Window/Servant/Pet/UI_Window_Pet_Info.XML",			"Panel_Window_PetInfo",		UIGroup.PAGameUIGroup_Windows)
	-- loadUI("UI_Data/Window/Servant/Pet/UI_Window_Pet_Mating.XML",		"Panel_Window_PetMating",	UIGroup.PAGameUIGroup_Windows)
	-- loadUI("UI_Data/Window/Servant/Pet/UI_Window_Pet_Market.XML",		"Panel_Window_PetMarket",	UIGroup.PAGameUIGroup_Windows)

	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetRegister.XML",		"Panel_Window_PetRegister",	UIGroup.PAGameUIGroup_Windows) -- 펫등록
	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetInfo.XML",			"Panel_Window_PetInfoNew",	UIGroup.PAGameUIGroup_Windows) -- 펫정보
	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetListNew.XML",		"Panel_Window_PetListNew",	UIGroup.PAGameUIGroup_Windows) -- 펫리스트
	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetLookChange.XML",		"Panel_Window_PetLookChange",	UIGroup.PAGameUIGroup_Windows) -- 펫 외형변경
	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetControl.XML",		"Panel_Window_PetControl",	UIGroup.PAGameUIGroup_Widget) -- 펫액션
	loadUI("UI_Data/Window/PetInfo/Panel_Window_NoPetIcon.XML",			"Panel_Window_PetIcon",		UIGroup.PAGameUIGroup_Widget) -- 펫 안찾았을 때
	loadUI("UI_Data/Window/PetInfo/Panel_Window_Compose.XML",			"Panel_Window_PetCompose",	UIGroup.PAGameUIGroup_InstanceMission) -- 펫 합성
	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetMarket.XML",			"Panel_Window_PetMarket",	UIGroup.PAGameUIGroup_Windows) -- 펫 거래소
	loadUI("UI_Data/Window/PetInfo/Panel_Window_PetMarketRegister.XML",		"Panel_Window_PetMarketRegist",	UIGroup.PAGameUIGroup_Windows) -- 펫 거래소
------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 메이드(★) ---------------------------------------------------------------------
	loadUI("UI_Data/Widget/Maid/Panel_Icon_Maid.XML",					"Panel_Icon_Maid",			UIGroup.PAGameUIGroup_Widget)	-- 메이드 아이콘
	loadUI("UI_Data/Widget/Maid/Panel_Window_MaidList.XML",				"Panel_Window_MaidList",	UIGroup.PAGameUIGroup_Windows)	-- 메이드 리스트
	-- loadUI("UI_Data/Widget/Maid/Panel_Maid_ChangeName.XML",				"Panel_Maid_ChangeName",	UIGroup.PAGameUIGroup_Windows)	-- 메이드 이름 변경
------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 개인 거래 ---------------------------------------------------------------------
	loadUI("UI_Data/Window/Exchange/UI_Window_Exchange.XML",	"Panel_Window_Exchange", UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
		-- 키 패드----------------------------------------------------------
	loadUI("UI_Data/Window/Exchange/UI_Window_Exchange_Number.XML", "Panel_Window_Exchange_Number", UIGroup.PAGameUIGroup_ModalDialog)
------------------------------------------------------------
		-- 페이드 스크린 ----------------------------------------------------------
	loadUI("UI_Data/Window/FadeScreen/UI_Fade_Screen.XML", "Panel_Fade_Screen", UIGroup.PAGameUIGroup_FadeScreen)
----------------------------------------------------------
		-- 우편 ---------------------------------------------------
	loadUI("UI_Data/Widget/UIcontrol/UI_Main_NewMail_Alarm.XML",		"Panel_NewMail_Alarm",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Mail/Panel_Mail.xml",						"Panel_Mail_Main", 			UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Mail/Panel_Mail_Popup.xml",					"Panel_Mail_Detail", 		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Mail/Panel_Mail_Send.xml",					"Panel_Mail_Send", 			UIGroup.PAGameUIGroup_Windows)
------------------------------------------------------------
	
-- 월드 맵 ---------------------------------------------------------------------
-- ----------------------------------------- Grand Open ------------------------------------------------------------------
	if isGrandOpen then
		--loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_Base.XML",					"Panel_WorldMap",					UIGroup.PAGameUIGroup_WorldMap_Popups)
		--PanelWorldMap은 코드쪽에서 로드합니다 : ToClient_initializeWorldMap안쪽에서 로드함.
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_OutSideNode.XML",			"Panel_WorldMap_Main",				UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_InSideNode.XML",			"Panel_NodeMenu",					UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_MovieTooltip.XML",			"Panel_WorldMap_MovieGuide",		UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 월드맵 무비 팝업
		loadUI("UI_Data/Window/Worldmap/Panel_HouseIcon.XML", 							"Panel_HouseIcon",					UIGroup.PAGameUIGroup_WorldMap_Popups)	-- Worldmap Icon Template
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeName.XML",					"Panel_NodeName",					UIGroup.PAGameUIGroup_Interaction)
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_InSideNode_Guild.XML",		"Panel_NodeOwnerInfo",				UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 내 점령정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeSiegeTooltip.XML",			"Panel_NodeSiegeTooltip",			UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 거점전 정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_nodeHouseFilter.XML",			"Panel_NodeHouseFilter",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_House.XML",			"Panel_RentHouse_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_House_SelectBox.XML","Panel_Select_Inherit",				UIGroup.PAGameUIGroup_WorldMap_Contents)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_LargeCraft.XML",		"Panel_LargeCraft_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Building.XML",		"Panel_Building_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Plant.XML",			"Panel_Plant_WorkManager",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Harvest.XML",		"Panel_Harvest_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Finance.XML",		"Panel_Finance_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_WarInfo.XML",					"Panel_Win_Worldmap_WarInfo",		UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeWarInfo.XML",				"Panel_Win_Worldmap_NodeWarInfo",	UIGroup.PAGameUIGroup_WorldMap_Popups) -- 거점전
		loadUI("UI_Data/Widget/WarInfoMessage/Panel_WarInfoMessage.XML",				"Panel_WarInfoMessage",				UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전 메시지
		loadUI("UI_Data/Widget/WarInfoMessage/Panel_TerritoryWarKillingScore.XML",		"Panel_TerritoryWarKillingScore",	UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전 킬데스 메시지
		loadUI("UI_Data/Window/HouseInfo/Panel_WolrdHouseInfo.XML",						"Panel_WolrdHouseInfo",				UIGroup.PAGameUIGroup_WorldMap_Popups) -- 테스트용
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_Territory.XML",					"Panel_Worldmap_Territory",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_WorldMap_Tooltip.XML",					"Panel_WorldMap_Tooltip",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/WorldMap/UI_New_Worldmap_PartyMemberTooltip.XML", 		"Panel_WorldMap_PartyMemberTooltip",UIGroup.PAGameUIGroup_WorldMap_Popups)
		-- loadUI("UI_Data/Window/Worldmap/UI_New_WorldMap_Information.XMl",				"Panel_Worldmap_Information", 		UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 새 버전에서는 필요 없다.
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_town_manageWorker.XML",				"Panel_manageWorker",				UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_Working_Progress.XML", 				"Panel_Working_Progress",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_TentInfo.XML", 					"Panel_Worldmap_TentInfo",			UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 텐트 정보 창
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_TradeNpcItemInfo.XML", 				"Panel_TradeNpcItemInfo",			UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 텐트 정보 창
		loadUI("UI_Data/Window/Worldmap/FishEncyclopedia/Panel_FishEncyclopedia.XML", 	"Panel_FishEncyclopedia",			UIGroup.PAGameUIGroup_Windows)			-- 어류도감
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeStable.XML", 				"Panel_NodeStable",					UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 월드맵 축사 정보창
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeStableInfo.XML", 			"Panel_NodeStableInfo",				UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 월드맵 축사 정보창
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_QuestInfo.XML",						"Panel_QuestInfo",					UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 퀘스트 정보
		loadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_NavigationButton.XML",		"Panel_NaviButton",					UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 내비 버튼
	else
-- -----------------------------------------------------------------------------------------------------------------------
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeName.XML",					"Panel_NodeName",					UIGroup.PAGameUIGroup_Interaction)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_nodeGuildWarMenu.XML",			"Panel_NodeGuildWarMenu",			UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 내 점령정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeSiegeTooltip.XML",			"Panel_NodeSiegeTooltip",			UIGroup.PAGameUIGroup_WorldMap_Popups) -- 노드 거점전 정보
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_nodeMenu.XML",					"Panel_NodeMenu",					UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_nodeHouseFilter.XML",			"Panel_NodeHouseFilter",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_House.XML",			"Panel_RentHouse_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_House_SelectBox.XML","Panel_Select_Inherit",				UIGroup.PAGameUIGroup_WorldMap_Contents)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_LargeCraft.XML",		"Panel_LargeCraft_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Building.XML",		"Panel_Building_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Plant.XML",			"Panel_Plant_WorkManager",			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Harvest.XML",		"Panel_Harvest_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_manageWork_Finance.XML",		"Panel_Finance_WorkManager",		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_WarInfo.XML",					"Panel_Win_Worldmap_WarInfo",		UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeWarInfo.XML",				"Panel_Win_Worldmap_NodeWarInfo",	UIGroup.PAGameUIGroup_WorldMap_Popups) -- 거점전
		loadUI("UI_Data/Widget/WarInfoMessage/Panel_WarInfoMessage.XML",				"Panel_WarInfoMessage",				UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전 메시지
		loadUI("UI_Data/Widget/WarInfoMessage/Panel_TerritoryWarKillingScore.XML",		"Panel_TerritoryWarKillingScore",	UIGroup.PAGameUIGroup_WorldMap_Popups) -- 점령전 킬데스 메시지
		loadUI("UI_Data/Window/HouseInfo/Panel_WolrdHouseInfo.XML",						"Panel_WolrdHouseInfo",				UIGroup.PAGameUIGroup_WorldMap_Popups) -- 테스트용
		loadUI("UI_Data/Window/Worldmap/UI_New_WorldMap_Panel.XML",						"Panel_WorldMap",					UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_Territory.XML",					"Panel_Worldmap_Territory", 		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_WorldMap_Tooltip.XML",					"Panel_WorldMap_Tooltip", 			UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/WorldMap/UI_New_Worldmap_PartyMemberTooltip.XML",		"Panel_WorldMap_PartyMemberTooltip",UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_WorldMap_Information.XMl",				"Panel_Worldmap_Information", 		UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_town_manageWorker.XML", 			"Panel_manageWorker", 				UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_Working_Progress.XML", 				"Panel_Working_Progress", 			UIGroup.PAGameUIGroup_WorldMap_Popups)
--		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_nodeUpgradeWindow.XML", "Panel_nodeUpgrade", UIGroup.PAGameUIGroup_WorldMap_Popups)
--		loadUI("UI_Data/Window/Worldmap/UI_WorldMap_Tooltip_House.XML", 	"Panel_WorldMapTooltipHouse", UIGroup.PAGameUIGroup_WorldMap_Popups)
--		loadUI("UI_Data/Window/Worldmap/UI_WorldMap_Tooltip_NeedItem.XML", 	"Panel_Win_Tooltip_NeedItem", UIGroup.PAGameUIGroup_WorldMap_Popups)
--		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_CastleInfo.XML", 		"Panel_CastleInfo", UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/Panel_HouseIcon.XML", 							"Panel_HouseIcon", 					UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_TentInfo.XML", 					"Panel_Worldmap_TentInfo", 			UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 텐트 정보 창
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_TradeNpcItemInfo.XML", 				"Panel_TradeNpcItemInfo", 			UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 텐트 정보 창
		loadUI("UI_Data/Window/Worldmap/FishEncyclopedia/Panel_FishEncyclopedia.XML", 	"Panel_FishEncyclopedia", 			UIGroup.PAGameUIGroup_Windows)			-- 어류도감
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeStable.XML",				"Panel_NodeStable", 				UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 월드맵 축사 정보창
		loadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeStableInfo.XML",			"Panel_NodeStableInfo", 			UIGroup.PAGameUIGroup_WorldMap_Popups)	-- 월드맵 축사 정보창

		-- 퀘스트 정보 ---------------------------------------------------------
		loadUI("UI_Data/Window/Worldmap/UI_Worldmap_QuestInfo.XML","Panel_QuestInfo", UIGroup.PAGameUIGroup_WorldMap_Popups)
	end	
--------------------------------------------------------------------------

	-- 길드 하우스 제작 관련
		loadUI("UI_Data/Window/Worldmap_Grand/WordMap_Craft/Worldmap_Grand_GuildCraft.XML",					"Worldmap_Grand_GuildCraft", UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap_Grand/WordMap_Craft/Worldmap_Grand_GuildHouseControl.XML",			"Worldmap_Grand_GuildHouseControl", UIGroup.PAGameUIGroup_WorldMap_Popups)
		loadUI("UI_Data/Window/Worldmap_Grand/WordMap_Craft/Worldmap_Grand_GuildCraft_ChangeWorker.XML",	"Worldmap_Grand_GuildCraft_ChangeWorker", UIGroup.PAGameUIGroup_WorldMap_Contents)

	-- 길드 Window ----------------------------------------------------------
	loadUI("UI_Data/Window/Guild/Frame_Guild_History.XML", 			"Panel_Guild_History", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Frame_Guild_List.XML", 			"Panel_Guild_List", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Frame_Guild_Quest.XML", 			"Panel_Guild_Quest", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Frame_Guild_Warfare.XML", 			"Panel_Guild_Warfare", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Frame_Guild_Skill.XML", 			"Panel_Guild_Skill", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Frame_Guild_Recruitment.XML", 		"Panel_Guild_Recruitment", 		UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Frame_Guild_CraftInfo.XML", 		"Panel_Guild_CraftInfo", 		UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_Guild.XML", 					"Panel_Window_Guild", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_Guild_Create.XML", 			"Panel_CreateGuild", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_Guild_Manager.XML", 			"Panel_GuildManager", 			UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_GuildTentAttackedMsg.XML",	"Panel_GuildTentAttackedMsg", 	UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_Guild_Declaration.XML", 		"Panel_Guild_Declaration", 		UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_Guild_Duel.XML", 			"Panel_GuildDuel", 				UIGroup.PAGameUIGroup_Window_Progress )

	-- loadUI("UI_Data/Widget/WarRecord/Panel_WarRecord.XML",			"Panel_WarRecord", 				UIGroup.PAGameUIGroup_Siege )	-- 점령전/거점전 내 스코어
	

	loadUI("UI_Data/Window/Guild/Panel_CreateClan.XML",				"Panel_CreateClan", 			UIGroup.PAGameUIGroup_Windows )	-- 클랜/길드 생성
	loadUI("UI_Data/Window/Guild/Panel_ClanToGuild.XML",			"Panel_ClanToGuild", 			UIGroup.PAGameUIGroup_Windows )	-- 클랜->길드 전환
	loadUI("UI_Data/Window/Guild/Panel_AgreementGuild.XML",			"Panel_AgreementGuild", 		UIGroup.PAGameUIGroup_Window_Progress )	-- 길드 고용 계약서
	loadUI("UI_Data/Window/Guild/Panel_AgreementGuild_Master.XML",	"Panel_AgreementGuild_Master", 	UIGroup.PAGameUIGroup_Window_Progress )	-- 대장 전용 계약서 작성
	loadUI("UI_Data/Window/Guild/Panel_GuildIncentive.XML",			"Panel_GuildIncentive", 		UIGroup.PAGameUIGroup_Window_Progress )	-- 인센티브 주기.
	loadUI("UI_Data/Window/Guild/Panel_Guild_Incentive.XML",		"Panel_Guild_IncentiveOption", 	UIGroup.PAGameUIGroup_Window_Progress )	-- 인센티브 주기.

	loadUI("UI_Data/Window/Guild/Panel_ClanList.XML", 				"Panel_ClanList", 				UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Guild/Panel_Guild_Journal.XML",			"Panel_Guild_Journal",			UIGroup.PAGameUIGroup_Windows ) -- 길드 연혁(일지)
	loadUI("UI_Data/Window/Guild/Panel_Guild_Rank.XML",				"Panel_Guild_Rank",				UIGroup.PAGameUIGroup_Windows )	-- 길드랭크
	loadUI("UI_Data/Window/Guild/Panel_GuildWebInfo.XML",			"Panel_GuildWebInfo",			UIGroup.PAGameUIGroup_Windows )	-- 길드정보

------------------------------------------------------------------------
		-- 게임 옵션 -----------------------------------------------------------
	loadUI("UI_Data/Window/Option/UI_GameOption.XML", 						"Panel_Window_Option", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Display.XML", 		"Panel_GameOption_Display", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Sound.XML", 			"Panel_GameOption_Sound", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Game.XML", 			"Panel_GameOption_Game", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_KeyConfig.XML", 		"Panel_GameOption_Key", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_KeyConfig_UI.XML", 	"Panel_GameOption_Key_UI", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Language.XML", 		"Panel_GameOption_Language", UIGroup.PAGameUIGroup_Windows )

	loadUI("UI_Data/Window/Option/Panel_SetShortCut.XML", 					"Panel_SetShortCut", UIGroup.PAGameUIGroup_Windows )	-- 종합 키 설정

----------------------------------------------------------
		-- 메시지 박스 ----------------------------------------------------------
	loadUI("UI_Data/Window/MessageBox/UI_Win_System.XML","Panel_Win_System",UIGroup.PAGameUIGroup_FadeScreen)
--------------------------------------------------------------------------
		-- 지식 ( 신버전 ) ----------------------------------------------------------
	loadUI("UI_Data/Window/Knowledge/Panel_Knowledge_Info.XML","Panel_Knowledge_Info", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Window/Knowledge/Panel_Knowledge_List.XML","Panel_Knowledge_List", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Window/Knowledge/Panel_Knowledge_Main.XML","Panel_Knowledge_Main", UIGroup.PAGameUIGroup_MainUI)
------------------------------------------------------------------------
		-- 지식 게임 ----------------------------------------------------------
	loadUI("UI_Data/Window/MentalKnowledge/MentalGame_Base.XML","Panel_MentalGame_Base", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/MentalKnowledge/MentalGame_Left.XML","Panel_MentalGame_Left", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/MentalKnowledge/MentalGame_Select.XML","Panel_MentalGame_Select", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/MentalKnowledge/MentalGame_Tooltip.XML","Panel_MentalGame_Tooltip", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/MentalKnowledge/MentalGame_Center.XML","Panel_MentalGame_Center", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/MentalKnowledge/MentalGame_Right_List.XML","Panel_MentalGame_Right", UIGroup.PAGameUIGroup_Dialog)
------------------------------------------------------------------------
		-- 데미지 템플릿 ----------------------------------------------------------
	loadUI("UI_Data/Widget/Damage/UI_Damage.XML","Panel_Damage", UIGroup.PAGameUIGroup_Dialog)
------------------------------------------------------------------------
		-- Field Quest 템플릿 ----------------------------------------------------------
	loadUI("UI_Data/Widget/QuestList/Field_QuestIcon.XML","Panel_fieldQuest", UIGroup.PAGameUIGroup_Dialog)
------------------------------------------------------------------------
		-- 내구도창 ----------------------------------------------------------
	loadUI("UI_Data/Widget/Enduarance/UI_Endurance.XML",			"Panel_Endurance",			UIGroup.PAGameUIGroup_MainUI)				-- PC			장비 내구도
	loadUI("UI_Data/Widget/Enduarance/UI_HorseEndurance.XML",		"Panel_HorseEndurance",		UIGroup.PAGameUIGroup_MainUI)				-- 탑승물(말)	장비 내구도
	loadUI("UI_Data/Widget/Enduarance/UI_CarriageEndurance.XML",	"Panel_CarriageEndurance",	UIGroup.PAGameUIGroup_MainUI)				-- 탑승물(마차) 장비 내구도
	loadUI("UI_Data/Widget/Enduarance/UI_ShipEndurance.XML",		"Panel_ShipEndurance",		UIGroup.PAGameUIGroup_MainUI)				-- 탑승물(배)	장비 내구도
------------------------------------------------------------------------
		-- 수리관련 ----------------------------------------------------------
	loadUI("UI_Data/Window/Repair/UI_Window_Repair_Function.XML",	"Panel_Window_Repair",		UIGroup.PAGameUIGroup_Windows)
	-- 내구도 수리 ----------------------------------------------------------
	loadUI("UI_Data/Window/Repair/Panel_FixEquip.XML",				"Panel_FixEquip", 			UIGroup.PAGameUIGroup_Window_Progress)
	loadUI("UI_Data/Window/Repair/Panel_LuckyRepair_Result.XML",	"Panel_LuckyRepair_Result",	UIGroup.PAGameUIGroup_Windows)
-----------------------------------------------------------------------------
		-- 추출 관련 ----------------------------------------------------------
	loadUI("UI_Data/Window/Extraction/UI_Window_Extraction_Function.XML",		"Panel_Window_Extraction",				UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Extraction/UI_Window_Extraction_Crystal.XML",		"Panel_Window_Extraction_Crystal",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Extraction/UI_Window_Extraction_EnchantStone.XML",	"Panel_Window_Extraction_EnchantStone",	UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Extraction/UI_Window_Extraction_Cloth.XML",			"Panel_Window_Extraction_Cloth",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Window/Extraction/UI_Window_Extraction_Result.XML",			"Panel_Window_Extraction_Result",		UIGroup.PAGameUIGroup_Alert)
-----------------------------------------------------------------------------
		-- 강화실패 수치 추출 ----------------------------------------------------------
	loadUI("UI_Data/Window/Enchant/UI_Window_SpiritEnchant_Extraction.XML",		"Panel_EnchantExtraction",				UIGroup.PAGameUIGroup_Window_Progress)
-----------------------------------------------------------------------------
	
------------------------------------------------------------------------

--[[ *********************WIDGET************************ --]]
--[[ ●●●●● BOTTOM ●●●●● --]]
		-- 플레이어 메인 UI ----------------------------------------------------------
	loadUI("UI_Data/Widget/MainStatus/UI_SelfPlayer_Main_Slot_User_Bar.XML",	"Panel_MainStatus_User_Bar", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/MainStatus/UI_SelfPlayerExp.XML",					"Panel_SelfPlayerExpGage", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/MainStatus/UI_SelfPlayer_Main_Slot_Casting_Bar.XML",	"Panel_Casting_Bar", UIGroup.PAGameUIGroup_MainUI)	-- LUA 작업 안됨	-- 캐스팅 UI
	loadUI("UI_Data/Widget/MainStatus/PvpMode_Button.XML",						"Panel_PvpMode", UIGroup.PAGameUIGroup_MainUI)							-- PVP 모드
	loadUI("UI_Data/Widget/MainStatus/Panel_ClassResource.XML",					"Panel_ClassResource", UIGroup.PAGameUIGroup_MainUI)					-- 소서러 어둠의 조각 카운트 표시
	loadUI("UI_Data/Widget/MainStatus/Panel_Adrenallin.XML",					"Panel_Adrenallin", UIGroup.PAGameUIGroup_MainUI)						-- 아드레날린
	loadUI("UI_Data/Widget/MainStatus/Panel_GuardGauge.XML",					"Panel_GuardGauge", UIGroup.PAGameUIGroup_MainUI)						-- 워리어 가드게이지
	
	loadUI("UI_Data/Widget/MainStatus/Panel_MovieGuideButton.XML",				"Panel_MovieGuideButton", UIGroup.PAGameUIGroup_Widget)					-- 쪼렙용 동영상 가이드
	loadUI("UI_Data/Window/MovieGuide/Panel_MovieGuide.XML",					"Panel_MovieGuide", UIGroup.PAGameUIGroup_MainUI)						-- 쪼렙용 동영상 가이드
	loadUI("UI_Data/Widget/MainStatus/UI_Widget_Button_HuntingAlert.XML",		"Panel_HuntingAlertButton", UIGroup.PAGameUIGroup_Widget)				-- 수렵 아이콘
	loadUI("UI_Data/Widget/MainStatus/UI_Widget_Button_AutoTraining.XML",		"Panel_AutoTraining", UIGroup.PAGameUIGroup_Widget)						-- 자동 수련 아이콘
	loadUI("UI_Data/Widget/MainStatus/UI_Widget_Button_BusterCall.XML",			"Panel_BusterCall", UIGroup.PAGameUIGroup_Widget)						-- 버스터콜 아이콘
----------------------------------------------------------
		-- 중요한 지식 표시 ----------------------------------------------------------
	loadUI("UI_Data/Widget/ImportantKnowledge/Panel_ImportantKnowledge.XML","Panel_ImportantKnowledge", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/ImportantKnowledge/Panel_Knowledge_Main.XML","Panel_NewKnowledge", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/ImportantKnowledge/Panel_NormalKnowledge.XML","Panel_NormalKnowledge", UIGroup.PAGameUIGroup_MainUI)
----------------------------------------------------------
		-- 더 좋은 장비 표시 ----------------------------------------------------------
	loadUI("UI_Data/Widget/NewEquip/Panel_NewEquip.XML","Panel_NewEquip", UIGroup.PAGameUIGroup_MainUI)
----------------------------------------------------------
		-- 시스템 메시지----------------------------------------------------------
	loadUI("UI_Data/Widget/NakMessage/NakMessage.XML","Panel_NakMessage", UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/NakMessage/RewardSelect_NakMessage.XML","Panel_RewardSelect_NakMessage", UIGroup.PAGameUIGroup_Chatting)
	
	loadUI("UI_Data/Widget/UIcontrol/UI_Challenge_Reward_Alarm.XML",			"Panel_ChallengeReward_Alert",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Widget/UIcontrol/UI_Challenge_SpecialReward_Alarm.XML",		"Panel_SpecialReward_Alert",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Widget/UIcontrol/UI_NewEventProduct_Alarm.XML",				"Panel_NewEventProduct_Alarm",		UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Widget/CraftLevInfo/UI_Widget_CraftLevInfo.XML",			"Panel_Widget_CraftLevInfo",		UIGroup.PAGameUIGroup_ProgressBar)
	loadUI("UI_Data/Widget/PotenGradeInfo/UI_Widget_PotenGradeInfo.xml", 		"Panel_Widget_PotenGradeInfo",		UIGroup.PAGameUIGroup_ProgressBar)
----------------------------------------------------------
		-- 채팅창----------------------------------------------------------
	loadUI("UI_Data/Widget/Chatting/UI_Window_Chat.XML",					"Panel_Chat",						UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Widget/Chatting/UI_Window_ChatOption.XML",				"Panel_ChatOption",					UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Widget/Chatting/UI_Window_Chatting_Input.XML",			"Panel_Chatting_Input",				UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/Chatting/Panel_Chatting_Filter.XML",				"Panel_Chatting_Filter",			UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/Chatting/Panel_Chatting_Macro.XML",				"Panel_Chatting_Macro",				UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/Chatting/Panel_Chat_SocialMenu.XML",				"Panel_Chat_SocialMenu",			UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/Chatting/Panel_Chat_SubMenu.XML",				"Panel_Chat_SubMenu",				UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Widget/Chatting/Panel_Chatting_Block_GoldSeller.XML",	"Panel_Chatting_Block_GoldSeller",	UIGroup.PAGameUIGroup_ModalDialog)
----------------------------------------------------------
		-- 게임 팁 --------------------------------------------------------------------------------------------------
	loadUI("UI_Data/Widget/GameTips/UI_Widget_GameTips.XML",		"Panel_GameTips",			UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Widget/GameTips/UI_Widget_GameTipsMask.XML",	"Panel_GameTipMask",		UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Window/GameTips/UI_Window_GameTips.XML",		"Panel_Window_GameTips",	UIGroup.PAGameUIGroup_WorldMap_Contents)

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------
		-- 공지 사항 --------------------------------------------------------------------------------------------------
	loadUI("UI_Data/Widget/NoticeAlert/NoticeAlert.XML","Panel_NoticeAlert", UIGroup.PAGameUIGroup_GameSystemMenu)
----------------------------------------------------------------------------------------------------------------
		-- 퀵 슬롯----------------------------------------------------------
	loadUI("UI_Data/Widget/QuickSlot/UI_Panel_QuickSlot.XML","Panel_QuickSlot",		UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/QuickSlot/Panel_NewQuickSlot.XML","Panel_NewQuickSlot",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯

	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_0.XML",	"Panel_NewQuickSlot_0",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_1.XML",	"Panel_NewQuickSlot_1",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_2.XML",	"Panel_NewQuickSlot_2",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_3.XML",	"Panel_NewQuickSlot_3",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_4.XML",	"Panel_NewQuickSlot_4",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_5.XML",	"Panel_NewQuickSlot_5",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_6.XML",	"Panel_NewQuickSlot_6",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_7.XML",	"Panel_NewQuickSlot_7",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_8.XML",	"Panel_NewQuickSlot_8",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_9.XML",	"Panel_NewQuickSlot_9",		UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_10.XML",	"Panel_NewQuickSlot_10",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_11.XML",	"Panel_NewQuickSlot_11",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_12.XML",	"Panel_NewQuickSlot_12",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_13.XML",	"Panel_NewQuickSlot_13",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_14.XML",	"Panel_NewQuickSlot_14",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_15.XML",	"Panel_NewQuickSlot_15",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_16.XML",	"Panel_NewQuickSlot_16",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_17.XML",	"Panel_NewQuickSlot_17",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_18.XML",	"Panel_NewQuickSlot_18",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
	loadUI("UI_Data/Widget/QuickSlot/NewQuickSlot/Panel_NewQuickSlot_19.XML",	"Panel_NewQuickSlot_19",	UIGroup.PAGameUIGroup_MainUI)	-- 새 퀵슬롯
----------------------------------------------------------------------------------------------------------------
		-- 스킬 쿨타임----------------------------------------------------------
	loadUI("UI_Data/Widget/QuickSlot/UI_SkillCooltime_QuickView.XML","Panel_SkillCooltime", UIGroup.PAGameUIGroup_MainUI)
----------------------------------------------------------
		-- 스태미너 게이지----------------------------------------------------------
	loadUI("UI_Data/Widget/Stamina/Stamina.XML","Panel_Stamina",UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Widget/Stamina/CannonGauge.XML","Panel_CannonGauge",UIGroup.PAGameUIGroup_Widget)
----------------------------------------------------------
	--하우징설치, 내 집 목록----------------------------------------------------------
	loadUI("UI_Data/Widget/Housing/UI_Panel_Housing.XML",					"Panel_Housing",						UIGroup.PAGameUIGroup_Housing)
	loadUI("UI_Data/Widget/Housing/Panel_HouseName.XML",					"Panel_HouseName",						UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Housing/Panel_Housing_FarmInfo_New.XML", 		"Panel_Housing_FarmInfo_New",			UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Housing/Panel_InstallationMode_FarmInfo.XML", 	"Panel_InstallationMode_FarmInfo",		UIGroup.PAGameUIGroup_MainUI)

	loadUI("UI_Data/Window/Housing/Panel_House_InstallationMode.XML",		"Panel_House_InstallationMode", 		UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Window/Housing/Panel_House_InstallationMode_ObjectControl.XML",	"Panel_House_InstallationMode_ObjectControl", 	UIGroup.PAGameUIGroup_MainUI)	-- 가구 메뉴
	loadUI("UI_Data/Window/Housing/Panel_House_InstallationMode_Cart.XML",	"Panel_House_InstallationMode_Cart", 	UIGroup.PAGameUIGroup_MainUI)
	
	loadUI("UI_Data/Window/ChangeName/UI_Change_Nickname.XML",				"Panel_ChangeNickname", 				UIGroup.PAGameUIGroup_Windows)
	
----------------------------------------------------------
		-- 프로그레스 바----------------------------------------------------------
	-- 추후에 하나의 파일로 합친다.
	loadUI("UI_Data/Widget/ProgressBar/UI_Win_Collect_Bar.XML",	"Panel_Collect_Bar", UIGroup.PAGameUIGroup_Window_Progress)
	loadUI("UI_Data/Widget/ProgressBar/UI_Win_Product_Bar.XML",	"Panel_Product_Bar", UIGroup.PAGameUIGroup_Window_Progress)
	loadUI("UI_Data/Widget/ProgressBar/UI_Win_Enchant_Bar.XML",	"Panel_Enchant_Bar", UIGroup.PAGameUIGroup_Window_Progress)
----------------------------------------------------------
		-- 다이얼로그 ----------------------------------------------------------
	loadUI("UI_Data/Widget/Dialogue/UI_Win_Npc_Dialog.xml",		"Panel_Npc_Dialog",UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Dialogue/UI_Win_Npc_Quest_Reward.xml","Panel_Npc_Quest_Reward",UIGroup.PAGameUIGroup_Window_Progress)
	loadUI("UI_Data/Widget/Dialogue/UI_Npc_Dialog_Scene.xml", 	"Panel_Dialog_Scene", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Dialogue/Dialog_Itemtake.xml", 		"Panel_Dialogue_Itemtake", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Dialogue/UI_DetectPlayer.xml", 		"Panel_DetectPlayer", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Dialogue/UI_Win_Npc_Exchange_Item.xml", 		"Panel_Exchange_Item", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Dialogue/UI_Win_Interest_Knowledge.XML", 	"Panel_Interest_Knowledge", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Dialogue/Panel_Knowledge_Management.XML", 	"Panel_KnowledgeManagement", UIGroup.PAGameUIGroup_Window_Progress)
----------------------------------------------------------
		-- UI 컨트롤바 (하단 메뉴) ----------------------------------------------------------
	loadUI("UI_Data/Widget/UIcontrol/UI_Main_Control.xml",			"Panel_UIControl",		UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/UIcontrol/UI_Main_Normal.xml",			"Panel_UIMain",			UIGroup.PAGameUIGroup_Widget)

	loadUI("UI_Data/Widget/QuestList/NewQuest.XML",					"Panel_NewQuest",		UIGroup.PAGameUIGroup_Chatting)
	loadUI("UI_Data/Widget/UIcontrol/UI_Main_NewQuest_Alarm.xml",	"Panel_NewQuest_Alarm",	UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
	-- 위젯 메뉴 ----------------------------------------------------------
	loadUI("UI_Data/Widget/Menu/Panel_Menu.XML","Panel_Menu",UIGroup.PAGameUIGroup_Windows)
----------------------------------------------------------
	-- 스킬 로그 ----------------------------------------------------------
	loadUI("UI_Data/Widget/SkillLog/Panel_Widget_SkillLog.XML","Panel_Widget_SkillLog",UIGroup.PAGameUIGroup_Widget)
----------------------------------------------------------



--[[ ●●●●● TOP ●●●●● --]]
		-- 레벨업----------------------------------------------------------
	loadUI("UI_Data/Widget/LvUpMessage/UI_Levelup_Reward.XML", "Panel_Levelup_Reward", UIGroup.PAGameUIGroup_Chatting)
----------------------------------------------------------
		-- 습득 메시지----------------------------------------------------------
	loadUI("UI_Data/Widget/Acquire/Acquire.XML","Panel_Acquire",UIGroup.PAGameUIGroup_Chatting)
	loadUI("UI_Data/Widget/Acquire/Acquire_QuestDirect.XML","Panel_QuestDirect",UIGroup.PAGameUIGroup_Chatting)
----------------------------------------------------------
		-- TargetInfo----------------------------------------------------------
	loadUI("UI_Data/Widget/EnemyGauge/EnemyGauge.XML","Panel_Monster_Bar", UIGroup.PAGameUIGroup_Windows)
------------------------------------------------------------------------
		-- 지역 메시지----------------------------------------------------------
	loadUI("UI_Data/Widget/Region/Region.XML","Panel_Region",UIGroup.PAGameUIGroup_Widget)
----------------------------------------------------------
		-- 인첸트 결과
	-- loadUI("UI_Data/Widget/EnchantMessage/UI_Win_Enchant_Message.XML", "Panel_Enchant_Message", UIGroup.PAGameUIGroup_Alert)
----------------------------------------------------------
		-- 잠재력 업
	loadUI("UI_Data/Widget/PotencialUp/UI_Potencial_Up.xml", "Panel_Potencial_Up", UIGroup.PAGameUIGroup_Chatting)
----------------------------------------------------------

--[[ ●●●●● LEFT ●●●●● --]]
	-- 파티 상태창----------------------------------------------------------
	loadUI("UI_Data/Widget/Party/UI_Party.xml","Panel_Party", UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/Party/Panel_PartyOption.xml","Panel_PartyOption", UIGroup.PAGameUIGroup_Chatting)
	loadUI("UI_Data/Window/Inventory/UI_Window_PartyInventory.XML", "Panel_Window_PartyInventory", UIGroup.PAGameUIGroup_Quest )
	loadUI("UI_Data/Widget/UIcontrol/UI_WhereUseTargetItem.XML", "Panel_WhereUseItemDirection", UIGroup.PAGameUIGroup_Widget)
	loadUI("UI_Data/Widget/Party/Panel_Party_ItemList.XML", "Panel_Party_ItemList", UIGroup.PAGameUIGroup_Widget )
	----------------------------------------------------------

--[[ ●●●●● RIGHT ●●●●● --]]
	-- 퀘스트 위젯----------------------------------------------------------
	loadUI("UI_Data/Widget/QuestList/ProgressGuildQuest.XML","Panel_Current_Guild_Quest",UIGroup.PAGameUIGroup_Dialog)
	loadUI("UI_Data/Widget/QuestList/Panel_CheckedQuestInfo.XML","Panel_CheckedQuestInfo",UIGroup.PAGameUIGroup_Windows)
	loadUI("UI_Data/Widget/QuestList/Panel_CheckedQuest.XML","Panel_CheckedQuest",UIGroup.PAGameUIGroup_QuestLog)
----------------------------------------------------------
	-- 버프 리스트----------------------------------------------------------
	--loadUI("UI_Data/Widget/Buff/UI_BuffPanel.xml",			"Panel_AppliedBuffList", UIGroup.PAGameUIGroup_MainUI)
----------------------------------------------------------
	-- 레이더 ----------------------------------------------------------
	--loadRadarUI("UI_Data/Widget/Rader/Rader.XML",				"Panel_Radar", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Rader/Rader.XML",				"Panel_Radar", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Rader/RaderTimeBarNumber.XML",	"Panel_TimeBarNumber", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Rader/RaderTimeBar.XML",			"Panel_TimeBar", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/Rader/Rader_NightAlert.XML",		"Panel_Rader_NightAlert", UIGroup.PAGameUIGroup_GameMenu)
----------------------------------------------------------
	-- 말 테이밍 후 안내 프레임 단위 루프 체크용
	loadUI("UI_Data/Widget/MainStatus/Panel_FrameLoop_Widget.XML",	"Panel_FrameLoop_Widget", UIGroup.PAGameUIGroup_MainUI)	
----------------------------------------------------------
	-- NPC 네비게이션 ----------------------------------------------------------
	loadUI("UI_Data/Widget/NpcNavigation/NpcNavigation.XML",		"Panel_NpcNavi", UIGroup.PAGameUIGroup_Housing)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_NpcNavigation.XML", 	"Panel_Tooltip_NpcNavigation", UIGroup.PAGameUIGroup_WorldMap_Contents)
	loadUI("UI_Data/Widget/NaviPath/Panel_NaviPath.XML",			"Panel_NaviPath", UIGroup.PAGameUIGroup_MainUI)
----------------------------------------------------------
	-- NPC 네비게이션 ----------------------------------------------------------
	loadUI("UI_Data/Widget/TownNpcNavi/Panel_Widget_TownNpcNavi.XML",			"Panel_Widget_TownNpcNavi", UIGroup.PAGameUIGroup_Housing)
----------------------------------------------------------

--[[ ●●●●● 전체 ●●●●● --]]
		-- 대화 버블창----------------------------------------------------------
	loadUI("UI_Data/Widget/Bubble/Bubble.XML","Panel_Bubble",UIGroup.PAGameUIGroup_Widget)
----------------------------------------------------------------------------------
		-- 인터렉션----------------------------------------------------------
	loadUI("UI_Data/Widget/Interaction/UI_Character_InterAction.XML","Panel_Interaction",UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Widget/Interaction/Panel_Interaction_HouseRank.XML","Panel_Interaction_HouseRank",UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Widget/Interaction/Panel_Interaction_FriendHouseList.XML","Panel_Interaction_FriendHouseList",UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Widget/Interaction/Panel_Interaction_House.XML","Panel_Interaction_House",UIGroup.PAGameUIGroup_Interaction)
	loadUI("UI_Data/Widget/Interaction/Panel_WatchingCommand.XML","Panel_WatchingMode",UIGroup.PAGameUIGroup_Interaction)
----------------------------------------------------------------------------------
		-- 툴팁----------------------------------------------------------
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill.XML",						"Panel_Tooltip_Skill", 						UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill_forLearning.XML",			"Panel_Tooltip_Skill_forLearning", 			UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item.XML",						"Panel_Tooltip_Item", 						UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_chattingLinkedItem.XML",		"Panel_Tooltip_Item_chattingLinkedItem", 	UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_equipped.XML",				"Panel_Tooltip_Item_equipped", 				UIGroup.PAGameUIGroup_GameMenu)
	-- loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Option.XML",						"Panel_Tooltip_Option", 					UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Guild_Introduce.XML",				"Panel_Tooltip_Guild_Introduce", 			UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Common.XML",						"Panel_Tooltip_Common", 					UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Worker.XML", 						"Panel_Worker_Tooltip", 					UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Work.XML", 						"Panel_Tooltip_Work",						UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_SimpleText.XML", 					"Panel_Tooltip_SimpleText", 				UIGroup.PAGameUIGroup_ModalDialog)
----------------------------------------------------------------------------------
		-- 자기소개 툴팁----------------------------------------------------------
	loadUI("UI_Data/Widget/Introduction/Panel_Widget_Introduction.XML",			"Panel_Introduction", 						UIGroup.PAGameUIGroup_GameMenu)
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
		-- 퀵슬롯 쿨타임 --------------------------------------------------------------
	loadUI("UI_Data/Widget/QuickSlot/UI_SkillCooltime_Effect.XML",			"Panel_CoolTime_Effect", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/QuickSlot/UI_SkillCooltime_Effect_Slot.XML",		"Panel_CoolTime_Effect_Slot", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/QuickSlot/UI_SkillCooltime_Effect_Item.XML",		"Panel_CoolTime_Effect_Item", UIGroup.PAGameUIGroup_MainUI)
	loadUI("UI_Data/Widget/QuickSlot/UI_SkillCooltime_Effect_Item_Slot.XML","Panel_CoolTime_Effect_Item_Slot", UIGroup.PAGameUIGroup_MainUI)
----------------------------------------------------------------------------------
		-- 죽었을 때! ----------------------------------------------------------
	loadUI("UI_Data/Window/DeadMessage/DeadMessage.XML", 				"Panel_DeadMessage", 			UIGroup.PAGameUIGroup_ModalDialog)
	loadUI("UI_Data/Window/DeadMessage/Panel_Cash_Revival_BuyItem.XML", "Panel_Cash_Revival_BuyItem", 	UIGroup.PAGameUIGroup_FadeScreen)
	loadUI("UI_Data/Window/DeadMessage/Panel_DeadNodeSelect.XML", 		"Panel_DeadNodeSelect", 		UIGroup.PAGameUIGroup_FadeScreen)
	
	
----------------------------------------------------------
		-- HP 부족할 때  --------------------------------------------------------------------
	loadUI("UI_Data/Window/DeadMessage/DangerAlert.XML", "Panel_Danger", UIGroup.PAGameUIGroup_ScreenEffect )
----------------------------------------------------------
		-- 교역 ----------------------------------------------------------
	loadUI( "UI_Data/Window/TradeMarket/UI_Win_Npc_TradeMarket.xml", "Panel_Npc_Trade_Market", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/TradeMarket/UI_Win_Npc_TradeMarket_BuyItemList_Panel.xml", "Panel_Trade_Market_BuyItemList", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/TradeMarket/UI_Win_Npc_TradeMarket_SellItemList_Panel.xml", "Panel_Trade_Market_Sell_ItemList", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/TradeMarket/UI_Win_Npc_TradeMarket_GraphPanel.xml", "Panel_Trade_Market_Graph_Window", UIGroup.PAGameUIGroup_WorldMap_Popups )
	-- loadUI( "UI_Data/Window/TradeMarket/Panel_Trade_EventMsg_Npc.XML", "Panel_Trade_EventMsg_Npc", UIGroup.PAGameUIGroup_WorldMap_Popups )
	-- loadUI( "UI_Data/Window/TradeMarket/Panel_Trade_EventMsg_Territory.XML", "Panel_Trade_EventMsg_Territory", UIGroup.PAGameUIGroup_WorldMap_Popups )
	loadUI( "UI_Data/Window/TradeMarket/UI_Win_Npc_TradeGame.xml", "Panel_TradeGame", UIGroup.PAGameUIGroup_WorldMap_Popups )
	loadUI( "UI_Data/Window/TradeMarket/UI_Win_Npc_TradeMarket_Event.xml", "Panel_TradeMarket_EventInfo", UIGroup.PAGameUIGroup_WorldMap_Popups )
----------------------------------------------------------
		-- 연금술 ----------------------------------------------------------
	loadUI( "UI_Data/Window/Alchemy/Panel_Alchemy.xml",		"Panel_Alchemy",		UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Alchemy/Panel_RecentCook.xml",	"Panel_RecentCook",		UIGroup.PAGameUIGroup_Windows )
----------------------------------------------------------
		-- 친구목록 ----------------------------------------------------------
	loadUI( "UI_Data/Window/Friend/Friend.xml", 				"Panel_FriendList", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Friend/Panel_Friend_Messanger.xml", "Panel_Friend_Messanger", UIGroup.PAGameUIGroup_Windows )
----------------------------------------------------------
		-- 가공 ----------------------------------------------------------
	loadUI( "UI_Data/Window/Alchemy/Panel_Manufacture.xml", 		"Panel_Manufacture", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Alchemy/Panel_Manufacture_Notify.XML", 	"Panel_Manufacture_Notify", UIGroup.PAGameUIGroup_Windows )
----------------------------------------------------------
		-- 필드 카메라 조절 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/FieldViewMode/UI_FieldViewMode.xml", 	"Panel_FieldViewMode", UIGroup.PAGameUIGroup_InstanceMission )
----------------------------------------------------------
		-- 게임 종료 ----------------------------------------------------------
	loadUI( "UI_Data/Window/GameExit/Panel_GameExit.xml", 			"Panel_GameExit",				UIGroup.PAGameUIGroup_WorldMap_Contents )
	loadUI( "UI_Data/Window/GameExit/Panel_ExitConfirm.xml", 		"Panel_ExitConfirm",			UIGroup.PAGameUIGroup_GameMenu )
	loadUI( "UI_Data/Window/GameExit/Panel_ChannelSelect.XML",		"Panel_ChannelSelect",			UIGroup.PAGameUIGroup_GameMenu )
	

	-- 지난 기억 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/RecentMemory/Panel_RecentMemory.XML", 	"Panel_RecentMemory", UIGroup.PAGameUIGroup_WorldMap_Contents )
----------------------------------------------------------
		-- 사망 경고 표시 ----------------------------------------------------------
	loadUI( "UI_Data/Window/DeadMessage/UI_NoAccessibleArea_Alert.xml", "Panel_NoAceessArea_Alert", UIGroup.PAGameUIGroup_ScreenEffect )
----------------------------------------------------------
	-- 제작 노트 ----------------------------------------------------------
	loadUI( "UI_Data/Window/ProductNote/Panel_ProductNote.XML", 		"Panel_ProductNote", UIGroup.PAGameUIGroup_WorldMap_Contents )
	loadUI( "UI_Data/Window/KeyboardHelp/Panel_KeyboardHelp.XML",		"Panel_KeyboardHelp", UIGroup.PAGameUIGroup_WorldMap_Contents ) -- 키보드 도움말
	--loadUI( "UI_Data/Window/ProductNote/Panel_ProductNote_Item.XML", 	"Panel_ProductNote_Item", UIGroup.PAGameUIGroup_WorldMap_Contents )
	----------------------------------------------------------
	-- 1:1문의 노트 ----------------------------------------------------------
	loadUI( "UI_Data/Window/QnAWebLink/Panel_QnAWebLink.XML", 		"Panel_QnAWebLink", UIGroup.PAGameUIGroup_WorldMap_Contents )
	----------------------------------------------------------
		-- ● 미니게임 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Gradient.xml", 		"Panel_Minigame_Gradient", UIGroup.PAGameUIGroup_MainUI )		-- 기울기
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_SinGauge.xml", 		"Panel_SinGauge", UIGroup.PAGameUIGroup_MainUI )				-- SIN 게이지
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Command.xml", 		"Panel_Command", UIGroup.PAGameUIGroup_MainUI )					-- 커맨드 입력
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Rhythm.xml", 			"Panel_RhythmGame", UIGroup.PAGameUIGroup_MainUI )				-- 리듬게임
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Rhythm_Drum.xml", 	"Panel_RhythmGame_Drum", UIGroup.PAGameUIGroup_MainUI )			-- 리듬게임 (드럼용)
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_BattleGauge.xml", 	"Panel_BattleGauge", UIGroup.PAGameUIGroup_MainUI )				-- 배틀 게이지
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_FillGauge.xml", 		"Panel_FillGauge", UIGroup.PAGameUIGroup_MainUI )				-- 채우기 게이지
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_GradientY.xml", 		"Panel_MiniGame_Gradient_Y", UIGroup.PAGameUIGroup_MainUI )		-- 기울기 Y축
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Timing.xml", 			"Panel_MiniGame_Timing", UIGroup.PAGameUIGroup_MainUI )			-- 타이밍 게임
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Steal.xml",			"Panel_MiniGame_Steal", UIGroup.PAGameUIGroup_MainUI )			-- 슬램가 훔치기
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_PowerControl.xml",	"Panel_MiniGame_PowerControl", UIGroup.PAGameUIGroup_MainUI )	-- 소 젖짜기
	loadUI( "UI_Data/Widget/MiniGame/MiniGame_Jaksal.xml",			"Panel_MiniGame_Jaksal", UIGroup.PAGameUIGroup_MainUI )			-- 낚시 작살
	-- loadUI( "UI_Data/Widget/MiniGame/MiniGame_Drag.xml", "Panel_MiniGame_Drag", UIGroup.PAGameUIGroup_MainUI )					-- 원형 따라가기
----------------------------------------------------------
		-- ● 커맨드 가이드 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/SkillCommand/UI_SkillCommand.xml", "Panel_SkillCommand", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- ● 조사 하기  ----------------------------------------------------------
	loadUI( "UI_Data/Widget/Search/UI_Dialog_Search.xml", "Panel_Dialog_Search", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- ● 키 입력 뷰어 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/Tutorial/Panel_Movie_KeyViewer.xml", "Panel_Movie_KeyViewer", UIGroup.PAGameUIGroup_MainUI )					-- 키 입력 보여주기
----------------------------------------------------------
		-- ● 튜토리얼  ----------------------------------------------------------
	
	loadUI( "UI_Data/Widget/Tutorial/UI_Masking_Tutorial_Quest.XML", 	"Panel_Masking_Tutorial", UIGroup.PAGameUIGroup_Window_Progress )
	loadUI( "UI_Data/Widget/Tutorial/Welcome_to_BlackDesert.xml", 	"Panel_Tutorial", UIGroup.PAGameUIGroup_Alert )								-- 최초 튜토리얼
	loadUI( "UI_Data/Widget/Tutorial/UI_ButtonHelp.xml", 			"Panel_ButtonHelp", UIGroup.PAGameUIGroup_Movie )
	loadUI( "UI_Data/Widget/Tutorial/UI_KeyTutorial.xml", 			"Panel_KeyTutorial", UIGroup.PAGameUIGroup_Movie )
----------------------------------------------------------
		-- ● 자동 판매 위탁 판매 사업  ------------------------------------------
	loadUI( "UI_Data/Window/HouseInfo/Panel_Housing_VendingMachineList.xml", 		"Panel_Housing_VendingMachineList", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/HouseInfo/Panel_Housing_SettingVendingMachine.xml", 	"Panel_Housing_SettingVendingMachine", UIGroup.PAGameUIGroup_Window_Progress )
	loadUI( "UI_Data/Window/HouseInfo/Panel_Housing_ConsignmentSale.xml", 			"Panel_Housing_ConsignmentSale", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/HouseInfo/Panel_Housing_SettingConsignmentSale.xml", 	"Panel_Housing_SettingConsignmentSale", UIGroup.PAGameUIGroup_Window_Progress )
	loadUI( "UI_Data/Window/HouseInfo/Panel_Housing_RegisterConsignmentSale.xml", 	"Panel_Housing_RegisterConsignmentSale", UIGroup.PAGameUIGroup_Window_Progress )
	loadUI( "UI_Data/Window/HouseInfo/Panel_MyVendor_List.xml", 					"Panel_MyVendor_List", UIGroup.PAGameUIGroup_Window_Progress )
	
		-- ● 집 정보 표시  ------------------------------------------------
	loadUI( "UI_Data/Window/HouseInfo/Panel_HouseControl_Main.XML", 				"Panel_HouseControl", UIGroup.PAGameUIGroup_WorldMap_Popups)--PAGameUIGroup_Housing)			-- 하우스 구매 (new)
	loadUI( "UI_Data/Window/HouseInfo/Panel_House_SellBuy_Condition.XML",			"Panel_House_SellBuy_Condition", UIGroup.PAGameUIGroup_WorldMap_Contents)--PAGameUIGroup_Housing)			-- 하우스 구매 (new)
--------------------------------------------------------------------------
		-- ● Scroll 버튼  ----------------------------------------------------------
	loadUI("UI_Data/Widget/Scroll/UI_Scroll.xml",					"Panel_Scroll",UIGroup.PAGameUIGroup_GameSystemMenu)
----------------------------------------------------------
		-- ● 숨게이지 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/BreathGauge/Panel_BreathGauge.XML", 	"Panel_BreathGauge", UIGroup.PAGameUIGroup_Widget )
----------------------------------------------------------
		-- ● PC 운송 ----------------------------------------------------------
	loadUI( "UI_Data/Window/Delivery/UI_Window_Delivery_Person.XML", "Panel_Window_DeliveryForPerson", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Delivery/UI_Window_Delivery_GameExit.XML", "Panel_Window_DeliveryForGameExit", UIGroup.PAGameUIGroup_GameMenu )
----------------------------------------------------------
		-- ● 지식 관련 위치 알아내기 ----------------------------------------------------------
	loadUI( "UI_Data/Widget/Dialogue/Panel_AskKnowledge.XML", "Panel_AskKnowledge", UIGroup.PAGameUIGroup_Windows )
----------------------------------------------------------
		-- 도움말 ----------------------------------------------------------
	-- loadUI( "UI_Data/Window/Help/Panel_Help.XML", "Panel_Help", UIGroup.PAGameUIGroup_Movie )
----------------------------------------------------------
		-- 컷씬(맥스에서 작업한 연출) ----------------------------------------------------------
	loadUI( "UI_Data/Window/Cutscene/Panel_CutsceneMovie.XML", "Panel_Cutscene", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- NameTag ----------------------------------------------------------
--	loadUI( "UI_Data/Actor/UI_Actor_NameTag.XML", "Panel_Copy_CharacterTag", UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_HouseHold.XML", 		"Panel_Copy_HouseHold", 	UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_Installation.XML", 		"Panel_Copy_Installation",	UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_Monster.XML", 			"Panel_Copy_Monster", 		UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_Npc.XML", 				"Panel_Copy_Npc", 			UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_OtherPlayer.XML", 		"Panel_Copy_OtherPlayer", 	UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_SelfPlayer.XML", 		"Panel_Copy_SelfPlayer", 	UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Actor/UI_Actor_NameTag_Vehicle.XML", 			"Panel_Copy_Vehicle", 		UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- BubbleBox ----------------------------------------------------------
	loadUI( "UI_Data/Actor/UI_Actor_BubbleBox.XML", "Panel_Copy_BubbleBox", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- HumanRelation ----------------------------------------------------------
	loadUI( "UI_Data/Widget/HumanRelation/HumanRelation.XML", "Panel_Copy_HumanRelation", UIGroup.PAGameUIGroup_MainUI )
	loadUI( "UI_Data/Widget/HumanRelation/HumanRelationIcon.XML", "Panel_Copy_HumanRelationIcon", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- WaitComment ----------------------------------------------------------
	loadUI( "UI_Data/Actor/UI_Actor_WaitComment.XML", "Panel_Copy_WaitComment", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------
		-- WaitComment ----------------------------------------------------------
	loadUI( "UI_Data/Widget/NaviPath/Panel_NaviPath.XML", "Panel_Copy_NaviPath", UIGroup.PAGameUIGroup_MainUI )
----------------------------------------------------------

	-- 메시지 히스토리
	loadUI( "UI_Data/Widget/MessageHistory/Panel_MessageHistory.XML",		"Panel_MessageHistory", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Widget/MessageHistory/Panel_MessageHistory_BTN.XML",	"Panel_MessageHistory_BTN", UIGroup.PAGameUIGroup_Windows )

	-- 캐시샵	
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop.XML",						"Panel_IngameCashShop", 						UIGroup.PAGameUIGroup_Interaction )			-- 펄 상점창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_GoodsTooltip.XML",			"Panel_IngameCashShop_GoodsTooltip", 			UIGroup.PAGameUIGroup_Siege )			-- 펄 상점 상품 툴팁창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_GoodsDetailInfo.XML",		"Panel_IngameCashShop_GoodsDetailInfo", 		UIGroup.PAGameUIGroup_Window_Progress )	-- 펄 상점 상품 정보창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_SetEquip.XML",				"Panel_IngameCashShop_SetEquip",				UIGroup.PAGameUIGroup_Window_Progress )	-- 펄 상점 상품 장착창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_Controller.XML",			"Panel_IngameCashShop_Controller",				UIGroup.PAGameUIGroup_Interaction )			-- 펄 상점 라이트, 시간 제어창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_BuyOrGift.XML",				"Panel_IngameCashShop_BuyOrGift",				UIGroup.PAGameUIGroup_Window_Progress )	-- 펄 상점 상품 구입창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_Password.XML",				"Panel_IngameCashShop_Password",				UIGroup.PAGameUIGroup_GameSystemMenu )			-- 펄상점 2차 비밀번호 입력
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_NewCart.XML",				"Panel_IngameCashShop_NewCart",					UIGroup.PAGameUIGroup_InstanceMission )	-- 펄상점 장바구니
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_ChargeDaumCash.XML",		"Panel_IngameCashShop_ChargeDaumCash",			UIGroup.PAGameUIGroup_GameSystemMenu )			-- 펄상점 다음캐쉬 충전
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_TermsofDaumCash.XML",		"Panel_IngameCashShop_TermsofDaumCash",			UIGroup.PAGameUIGroup_GameSystemMenu )			-- 펄상점 다음캐쉬 이용약관
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_MakePaymentsFromCart.XML",	"Panel_IngameCashShop_MakePaymentsFromCart",	UIGroup.PAGameUIGroup_Siege )	-- 캐시 카트 구매 확인 창
	loadUI( "UI_Data/Window/IngameCashShop/Panel_IngameCashShop_BuyPearlBox.XML",			"Panel_IngameCashShop_BuyPearlBox",				UIGroup.PAGameUIGroup_WorldMap_Contents ) -- 캐시 펄 상자 구매창
	
	
	
	-- 캐시 커마
	loadUI( "UI_Data/Window/Cash_Customization/Panel_Cash_Customization.XML",			"Panel_Cash_Customization",				UIGroup.PAGameUIGroup_Windows )	-- 캐시 커마 우측 메뉴
	loadUI( "UI_Data/Window/Cash_Customization/Panel_Cash_Customization_BuyItem.XML",	"Panel_Cash_Customization_BuyItem",		UIGroup.PAGameUIGroup_Windows )	-- 캐시 커마 이용권 사용 확인

	-- 아이템 거래 시장
	loadUI( "UI_Data/Window/ItemMarket/Panel_Window_ItemMarket_Function.XML",			"Panel_Window_ItemMarket_Function",		UIGroup.PAGameUIGroup_WorldMap_Contents )	-- 아이템 거래시장 컨트롤 창
	loadUI( "UI_Data/Window/ItemMarket/Panel_Window_ItemMarket.XML",					"Panel_Window_ItemMarket",				UIGroup.PAGameUIGroup_WorldMap_Contents )	-- 아이템 거래시장 리스트 창
	loadUI( "UI_Data/Window/ItemMarket/Panel_Window_ItemMarket_ItemSet.XML",			"Panel_Window_ItemMarket_ItemSet",		UIGroup.PAGameUIGroup_GameMenu )	-- 아이템 거래시장 등록 아이템 관리
	loadUI( "UI_Data/Window/ItemMarket/Panel_Window_ItemMarket_RegistItem.XML",			"Panel_Window_ItemMarket_RegistItem",	UIGroup.PAGameUIGroup_GameMenu )	-- 아이템 거래시장 등록창
	loadUI( "UI_Data/Window/ItemMarket/Panel_Window_ItemMarket_BuyConfirm.XML",			"Panel_Window_ItemMarket_BuyConfirm",	UIGroup.PAGameUIGroup_GameMenu ) -- 아이템 몇개 구입할지 확인 창
	loadUI( "UI_Data/Window/ItemMarket/Panel_Window_ItemMarket_BuyConfirm_Secure.XML",	"Panel_Window_ItemMarket_BuyConfirmSecure",	UIGroup.PAGameUIGroup_GameMenu ) -- 아이템 몇개 구입할지 확인 창 - 보안코드 창
	loadUI( "UI_Data/Window/ItemMarket/Panel_ItemMarket_AlarmList.XML",					"Panel_ItemMarket_AlarmList",	UIGroup.PAGameUIGroup_GameMenu ) -- 최저가 아이템 등록 알림 리스트
	loadUI( "UI_Data/Window/ItemMarket/Panel_ItemMarket_Alarm.XML",						"Panel_ItemMarket_Alarm",	UIGroup.PAGameUIGroup_GameMenu ) -- 최저가 아이템 등록 알림창
	----------------------------------------------------------

	-- PC방 가챠 상자!
	loadUI( "UI_Data/Window/RandomBoxSelect/Panel_RandomBoxSelect.XML",			"Panel_RandomBoxSelect", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Widget/Gacha_Roulette/Panel_Gacha_Roulette.XML",			"Panel_Gacha_Roulette",	UIGroup.PAGameUIGroup_Chatting ) -- PC방 가챠!
	-----------------------------------------------------------------------------

	-- 파워 게이지
	loadUI( "UI_Data/Widget/PowerGauge/Panel_PowerGauge.XML",					"Panel_PowerGauge",	UIGroup.PAGameUIGroup_Window_Progress ) -- PC방 가챠!
	-----------------------------------------------------------------------------

	-- PC방 혜택 안내
	loadUI( "UI_Data/Window/PcRoomNotify/Panel_PcRoomNotify.XML",				"Panel_PcRoomNotify",	UIGroup.PAGameUIGroup_Windows ) -- PC방 혜택 안내
	-----------------------------------------------------------------------------
	
	-- 이벤트
	loadUI( "UI_Data/Window/EventNotify/Panel_EventNotify.XML",				"Panel_EventNotify",			UIGroup.PAGameUIGroup_Windows )	-- 진행중인 이벤트 안내
	loadUI( "UI_Data/Window/EventNotify/Panel_EventNotifyContent.XML",		"Panel_EventNotifyContent",		UIGroup.PAGameUIGroup_Windows )	-- 진행중인 이벤트 뷰페이지
	-- loadUI( "UI_Data/Window/Beginner/Panel_BeginnerReward.XML",				"Panel_BeginnerReward",			UIGroup.PAGameUIGroup_Windows )	-- 신규 유저를 보상
	loadUI( "UI_Data/Window/Event/Panel_Event_100Day.XML",					"Panel_Event_100Day",			UIGroup.PAGameUIGroup_ModalDialog )	-- 대장정 100일 기념 폭풍지원 프로젝트s
	-- loadUI( "UI_Data/Window/DailyLogin/Panel_DailyLogin.XML",				"Panel_DailyLogin",	UIGroup.PAGameUIGroup_Windows )			-- 출석체크 마일리지
	-----------------------------------------------------------------------------
	
	-- 커마
	preloadCustomizationUI()

	-- 도전과제 ----------------------------------------------------------		
	loadUI( "UI_Data/Window/ChallengePresent/Panel_ChallengePresent.XML", "Panel_ChallengePresent", UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------
	-- 각인 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/CarveSeal/Panel_CarveSeal.XML", "Panel_CarveSeal", UIGroup.PAGameUIGroup_Windows )	
	loadUI( "UI_Data/Window/CarveSeal/Panel_ResetSeal.XML", "Panel_ResetSeal", UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------
	-- 각인 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/ClearVested/Panel_ClearVested.XML", "Panel_ClearVested", UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------

	-- UI편집모드 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/UI_Setting/Panel_UI_Setting.XML",		"Panel_UI_Setting",		UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------------

	-- 일꾼 관리 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/WorkerManager/UI_WorkerManager.XML",		"Panel_WorkerManager",		UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/WorkerManager/UI_WorkerRestoreAll.XML",		"Panel_WorkerRestoreAll",	UIGroup.PAGameUIGroup_Windows )	
	loadUI( "UI_Data/Window/WorkerManager/UI_WorkerChangeSkill.XML",	"Panel_WorkerChangeSkill",	UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------------

	-- 일꾼 거래소 --------------------------------------------------------
	loadUI( "UI_Data/Window/Auction/Panel_Worker_Auction.XML",			"Panel_Worker_Auction",			UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Auction/Panel_WorkerList_Auction.XML",		"Panel_WorkerList_Auction",		UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Window/Auction/Panel_WorkerResist_Auction.XML",	"Panel_WorkerResist_Auction",	UIGroup.PAGameUIGroup_Window_Progress )
	
	-----------------------------------------------------------------------
	
	-- 생활 경험치 이전 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/TransferLifeExperience/Panel_TransferLifeExperience.XML",	"Panel_TransferLifeExperience",	UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------------

	-- 의상 변경 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/ChangeItem/Panel_ChangeItem.XML",	"Panel_ChangeItem",	UIGroup.PAGameUIGroup_Windows )
	-- 무기 교환 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/ChangeItem/Panel_ChangeWeapon.XML",	"Panel_ChangeWeapon",	UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------------

	--loadUI( "UI_Data/Window/DebugPanel.XML",	"Panel_Debug", UIGroup.PAGameUIGroup_Windows );
--	loadUI("UI_Data/Window/test.XML","Panel_Debug",UIGroup.PAGameUIGroup_ModalDialog)
	
	-- 파티, 말 경주 매치 결과창 ------------------------------------------------------
	loadUI( "UI_Data/Widget/Party/Panel_MatchResult.XML",	"Panel_MatchResult", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Widget/MainStatus/Panel_RaceTimeAttack.XML",	"Panel_RaceTimeAttack", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Widget/MainStatus/Panel_RaceFinishTime.XML",	"Panel_RaceFinishTime", UIGroup.PAGameUIGroup_Windows )
	loadUI( "UI_Data/Widget/Party/Panel_RaceResult.XML",	"Panel_RaceResult", UIGroup.PAGameUIGroup_Windows )
	--------------------------------------------------------------------------

	-- 연금석 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/Alchemy/Panel_AlchemyStone.XML",	"Panel_AlchemyStone",	UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------------
	
	-- 선수상 ----------------------------------------------------------	
	loadUI( "UI_Data/Window/Alchemy/Panel_AlchemyFigureHead.XML",	"Panel_AlchemyFigureHead",	UIGroup.PAGameUIGroup_Windows )
	------------------------------------------------------------------------
	
	-- 대회 순위  ------------------------------------------------------------
	loadUI( "UI_Data/Window/RallyRanking/Panel_RallyRanking.XML", "Panel_RallyRanking", UIGroup.PAGameUIGroup_Windows )
	--------------------------------------------------------------------------

	-- 국지전  ------------------------------------------------------------
	loadUI( "UI_Data/Widget/LocalWar/Panel_LocalWar.XML",		"Panel_LocalWar",		UIGroup.PAGameUIGroup_Widget )
	loadUI( "UI_Data/Widget/LocalWar/Panel_LocalWarTeam.XML",	"Panel_LocalWarTeam",	UIGroup.PAGameUIGroup_Widget )
	--------------------------------------------------------------------------

	-- 참전  ------------------------------------------------------------
	loadUI( "UI_Data/Window/Join/Panel_Window_Join.XML", "Panel_Join", UIGroup.PAGameUIGroup_Windows )
	--------------------------------------------------------------------------
	
	loadUI("UI_Data/Widget/WarInfoMessage/Panel_TerritoryWar_Caution.XML", "Panel_TerritoryWar_Caution", UIGroup.PAGameUIGroup_Widget) -- 점령전 비참여 메시지
end


function loadOceanUI()
--컷씬(맥스에서 작업한 연출) ----------------------------------------------------------
	loadUI( "UI_Data/Window/Cutscene/Panel_CutsceneMovie.XML", "Panel_Cutscene", UIGroup.PAGameUIGroup_MainUI )
	loadUI("UI_Data/Widget/Acquire/Acquire.XML","Panel_Acquire", UIGroup.PAGameUIGroup_MainUI )
	loadUI("UI_Data/Widget/Acquire/Acquire_QuestDirect.XML","Panel_QuestDirect",UIGroup.PAGameUIGroup_ModalDialog)
	
	runLua("UI_Data/Script/Widget/Acquire/Acquire.lua")
	runLua("UI_Data/Script/CutScene_Ocean.lua")
	runLua("UI_Data/Script/Widget/Acquire/Acquire_QuestDirect.lua")
end


function preLoadGameOptionUI()
	loadUI("UI_Data/Window/WebHelper/Panel_WebControl.XML",					"Panel_WebControl",			UIGroup.PAGameUIGroup_DeadMessage)	-- 도움말

	loadUI("UI_Data/Window/Option/UI_GameOption.XML", 						"Panel_Window_Option", 		UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Display.XML", 		"Panel_GameOption_Display", UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Sound.XML", 			"Panel_GameOption_Sound", 	UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Game.XML", 			"Panel_GameOption_Game", 	UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_KeyConfig.XML", 		"Panel_GameOption_Key", 	UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_KeyConfig_UI.XML", 	"Panel_GameOption_Key_UI", 	UIGroup.PAGameUIGroup_Windows )
	loadUI("UI_Data/Window/Option/UI_GameOption_Frame_Language.XML", 		"Panel_GameOption_Language",UIGroup.PAGameUIGroup_Windows )
	 
	 -- tooltip
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill.XML",						"Panel_Tooltip_Skill", 						UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Skill_forLearning.XML",			"Panel_Tooltip_Skill_forLearning", 			UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item.XML",						"Panel_Tooltip_Item", 						UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_chattingLinkedItem.XML",		"Panel_Tooltip_Item_chattingLinkedItem", 	UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Item_equipped.XML",				"Panel_Tooltip_Item_equipped", 				UIGroup.PAGameUIGroup_GameMenu)
	-- loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Option.XML",						"Panel_Tooltip_Option", 					UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Guild_Introduce.XML",				"Panel_Tooltip_Guild_Introduce", 			UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Common.XML",						"Panel_Tooltip_Common", 					UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Worker.XML", 						"Panel_Worker_Tooltip", 					UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_Work.XML", 						"Panel_Tooltip_Work",						UIGroup.PAGameUIGroup_GameMenu)
	loadUI("UI_Data/Widget/Tooltip/UI_Tooltip_SimpleText.XML", 					"Panel_Tooltip_SimpleText", 				UIGroup.PAGameUIGroup_ModalDialog)
	 
end


function loadGameOptionUI()
	runLua("UI_Data/Script/Window/Option/UI_GameOption.lua")
	runLua("UI_Data/Script/globalKeyBinder.lua")
	runLua("UI_Data/Script/Tutorial/Panel_WebControl.lua")	-- 도움말
	
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Skill.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Item.lua")
	-- runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Option.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Guild_Introduce.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Common.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_SimpleText.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_New_Worker.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_New_Work.lua")
end

function loadGameUI()

--WebIME UI 일단 다른 WebUI보다 먼저 로드한다
----------------------------------------------------------------------
	runLua("UI_Data/Script/Panel_Ime.lua")
	runLua("UI_Data/Script/Tutorial/Panel_WebControl.lua")
	---------------------------------------------------------------------------------
	-- lua Script 파일 읽기!
	---------------------------------------------------------------------------------
--	runLua("UI_Data/Script/Panel_Debug.lua")
		-- 일단 실행은 따로 한다.
	runLua("UI_Data/Script/DragManager.lua")
	runLua("UI_Data/Script/Fullsizemode.lua")
	runLua("UI_Data/Script/globalPreloadUI.lua")
		-- 글로벌 : 액션차트에서 루아 이벤트를 검사한다 ------------------------------------------------
	runLua("UI_Data/Script/global_fromActionChart_LuaEvent.lua")
	runLua("UI_Data/Script/Widget/GlobalManual/Panel_Global_Manual.lua")
-------------------------------------------------------------------------------	

	runLua("UI_Data/Script/Window/FirstLogin/Panel_FirstLogin.lua")	-- 첫 옵션

-------------------------------------------------------------------------------	
	runLua("UI_Data/Script/NpcWorker/workerLuaWrapper.lua")

	
	-- 먼저 정의 되어야하는 함수들을 포함한 스크립트 ( init 함수에서 호출되는 글로벌함수 ) ----------------
	runLua("UI_Data/Script/Widget/Rader/Radar_GlobalValue.lua")
	
	-- ● 스킬용 특수 UI
		-- 엘프 : 스나이프 ----------------------------------------------------------
	runLua("UI_Data/InGame/Script/PEW/Panel_Skill_Elf_Snipe.lua")
----------------------------------------------------------
		-- 점령전 정보 ---------------------------------------------------
	runLua("UI_Data/Script/Window/GuildWarInfo/GuildWarInfo.lua")
	runLua("UI_Data/Script/Window/GuildWarInfo/GuildWarScore.lua")
		-- 경매 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Auction/Panel_House_Auction.lua")
	runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction.lua")
	runLua("UI_Data/Script/Window/Auction/Panel_TerritoryAuthority_Auction.lua")
	runLua("UI_Data/Script/Window/Auction/Panel_Worker_Auction.lua")
	runLua("UI_Data/Script/Window/Auction/Panel_WorkerList_Auction.lua")
	runLua("UI_Data/Script/Window/Auction/Panel_WorkerResist_Auction.lua")
	runLua("UI_Data/Script/Window/Auction/Panel_Villa_Auction.lua")
	
	-- runLua("UI_Data/Script/Window/Auction/Panel_TerritoryAuth_Message.lua")
	
	runLua("UI_Data/Script/Window/ChangeNickName/Panel_Change_Nickname.lua")
---------------------------------------------------------------------------
		-- UI Mode  ----------------------------------------------------------
	runLua("UI_Data/Script/Common/Common_UIMode.lua")
---------------------------------------------------------------------------
		-- 흑정령   ----------------------------------------------------------
	runLua("UI_Data/Script/Common/Common_BlackSpirit.lua")
---------------------------------------------------------------------------	
		-- Web   ----------------------------------------------------------
	runLua("UI_Data/Script/Common/Common_Web.lua")
---------------------------------------------------------------------------
		-- 카운터 어택 ----------------------------------------------------------
	runLua("UI_Data/InGame/Script/CounterAttack.lua")
----------------------------------------------------------
		-- 영주 메뉴 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/LordMenu/Panel_LordMenu.lua")
	runLua("UI_Data/Script/Window/LordMenu/TerritoryTex_Message.lua")
----------------------------------------------------------
		-- 거점전 메뉴 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/NodeWarMenu/Panel_NodeWarMenu.lua")
----------------------------------------------------------
		-- 필드 카메라 조절 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/FieldViewMode/FieldViewMode.lua")
----------------------------------------------------------
		-- ● 채팅창 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Chatting/Panel_ChatNew.lua")						-- 14.06.12
	runLua("UI_Data/Script/Widget/Chatting/Panel_ChatOption.lua")					-- 14.06.17
	runLua("UI_Data/Script/Widget/Chatting/Panel_Chatting_Input.lua")
	runLua("UI_Data/Script/Widget/Chatting/Panel_Chatting_Filter.lua")
	runLua("UI_Data/Script/Widget/Chatting/Panel_Chatting_Macro.lua")
	runLua("UI_Data/Script/Widget/Chatting/Panel_SocialAction.lua")
	runLua("UI_Data/Script/Widget/Chatting/Panel_ChatNew_ReportGoldSeller.lua")		-- 리포트 골드 셀러
	
		----------------------------------------------------------	
		-- 툴팁 ---------------------------------------------------------------------
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Skill.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Item.lua")
	-- runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Option.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Guild_Introduce.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_Common.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_SimpleText.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_New_Worker.lua")
	runLua("UI_Data/Script/Widget/ToolTip/Panel_Tooltip_New_Work.lua")
----------------------------------------------------------
	-- 자기소개 툴팁 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Introduction/Panel_Introduction.lua")
----------------------------------------------------------
	-- 위젯 메뉴 ----------------------------------------------------------
	runLua( "UI_Data/Script/Widget/Menu/Panel_Menu.lua")
----------------------------------------------------------
	-- 사용 스킬 표시 ---------------------------------------------------------------------
	runLua( "UI_Data/Script/Widget/SkillLog/Widget_SkillLog.lua")
----------------------------------------------------------
	-- 시스템 메시지 ---------------------------------------------------------------------
	runLua("UI_Data/Script/Widget/NakMessage/NakMessage.lua")
	runLua("UI_Data/Script/Widget/NakMessage/RewardSelect_NakMessage.lua")
----------------------------------------------------------
	-- 스태미너 ---------------------------------------------------------------------
	runLua("UI_Data/Script/Widget/Stamina/Stamina.lua")
----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Acquire/Acquire.lua")
	runLua("UI_Data/Script/Widget/Acquire/Acquire_QuestDirect.lua")
	runLua("UI_Data/Script/Widget/Region/Region.lua")
	runLua("UI_Data/Script/Window/Enchant/SpiritEnchant.lua")					-- 강화
	runLua("UI_Data/Script/Window/Socket/Socket.lua")							-- 소켓
	runLua("UI_Data/Script/Window/DeadMessage/DeadMessage.lua")
	runLua("UI_Data/Script/Window/Looting/Panel_Looting.lua")
	runLua("UI_Data/Script/Widget/PotencialUp/Panel_Potencial_Up.lua")			-- 잠재력업
	runLua("UI_Data/Script/Window/CharacterInfo/UI_CharacterInfo_Title.lua")	-- 내정보(타이틀)
	runLua("UI_Data/Script/Window/CharacterInfo/UI_CharacterInfo_History.lua")	-- 내정보(연혁)
	runLua("UI_Data/Script/Window/CharacterInfo/Panel_Challenge.lua")				-- 도전 과제
	runLua("UI_Data/Script/Window/CharacterInfo/UI_Lua_SelfCharacterInfo.lua")	-- 내정보
	runLua("UI_Data/Script/Widget/CraftLevInfo/UI_Lua_CraftLevInfo.lua")		-- 생활 레벨 정보
	runLua("UI_Data/Script/Widget/PotenGradeInfo/UI_Lua_PotenGradeInfo.lua")	-- 잠재력 레벨 정보
	runLua("UI_Data/Script/Window/Inventory/Panel_Window_Inventory.lua")		-- 인벤
	runLua("UI_Data/Script/Window/Inventory/Panel_Window_PartyInventory.lua")	-- 파티 가방
	runLua("UI_Data/Script/Widget/Popup/Panel_Popup_MoveItem.lua")				-- 아이템 이동 팝업창.
	runLua("UI_Data/Script/Window/Equipment/Panel_Window_Equiment.lua")			-- 장착
	runLua("UI_Data/Script/Window/MessageBox/Panel_UseItem.lua")				-- 아이템 분해 사용
	--runLua("UI_Data/Script/Window/Challenge/Panel_Challenge.lua")				-- 도전 과제
	runLua("UI_Data/Script/Window/ExtendExpiration/Panel_ExtendExpiration.lua")	-- 아이템 기간 연장

----------------------------------------------------------
	-- ● 교환 아이템 위젯  -----------------------------------------------------
	runLua("UI_Data/Script/Widget/UIcontrolBar/Panel_WhereUseItemDirection.lua") -- 교환 아이템 위젯
----------------------------------------------------------
	-- ● 생활 랭킹  -----------------------------------------------------
	runLua("UI_Data/Script/Window/LifeRanking/Panel_LifeRanking.lua")	-- 생활랭킹
----------------------------------------------------------
	-- ● 붉은전장 현황판  -----------------------------------------------------
	runLua("UI_Data/Script/Window/LocalWar/Panel_LocalWarInfo.lua")	-- 붉은 전장 현황판
----------------------------------------------------------
	-- ● ???????  -----------------------------------------------------
	runLua("UI_Data/Script/Window/Recommand/Panel_RecommandName.lua")	-- ?????
----------------------------------------------------------
	-- ● 출석 체크  -----------------------------------------------------
	runLua("UI_Data/Script/Window/DailyStamp/Panel_Window_DailyStamp.lua") -- 생활랭킹
----------------------------------------------------------
	-- ● 흑정령의 모험  --------------------------------------------------
	runLua("UI_Data/Script/Window/BlackSpiritAdventure/Panel_BlackSpiritAdventure.lua")
----------------------------------------------------------
	-- ● 스킬  ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Skill/Panel_Window_Skill.lua")				-- 스킬
	runLua("UI_Data/Script/Window/Skill/Panel_Window_SkillGuide.lua")			-- 스킬 영상 가이드 창
	runLua("UI_Data/Script/Window/SkillAwaken/Panel_Window_SkillAwaken.lua")	-- 스킬	각성 (New)
	runLua("UI_Data/Script/Window/Skill/Panel_EnableSkill.lua")					-- 새로운 스킬
----------------------------------------------------------
	-- ● 창고  ----------------------------------------------------------
	runLua("UI_Data/Script/Window/WareHouse/Panel_Window_Warehouse.lua")
----------------------------------------------------------
	-- ● 창고  ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
	runLua("UI_Data/Script/Window/Servant/ServantCommon.lua")							-- 공통 함수.
	--- 마구간 ---------------------------------------------------------------------------------------------------------------------------------------
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableFunction.lua")		-- 이벤트
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableRegister.lua")		-- 등록
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableInfo.lua")			-- 기본 정보
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableList.lua")			-- 리스트
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableEquipInfo.lua")		-- 장비 정보
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableShop.lua")			-- 상점
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableMating.lua")		-- 교배
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableMarket.lua")		-- 시장
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableMix.lua")			-- 합성
	runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_StableAddCarriage.lua")	-- 말 붙이기/떼기
	
	-- runLua("UI_Data/Script/Window/Servant/Stable/Panel_Window_ConfirmMarket.lua")		-- 마 시장, 교배 시장 등록 입력 창

---- ● 길드 마구간 -----------------------------------------------------------------
	runLua("UI_Data/Script/Window/Servant/GuildStable/Panel_Window_GuildStableFunction.lua")
	runLua("UI_Data/Script/Window/Servant/GuildStable/Panel_Window_GuildStableInfo.lua")
	runLua("UI_Data/Script/Window/Servant/GuildStable/Panel_Window_GuildStableList.lua")
	runLua("UI_Data/Script/Window/Servant/GuildStable/Panel_Window_GuildStableRegister.lua")

------------------------------------------------------------------------------------------------------------------------------------------------------	
	--- 선착장 ---------------------------------------------------------------------------------------------------------------------------------------
	runLua("UI_Data/Script/Window/Servant/Wharf/Panel_Window_WharfFunction.lua")		-- 이벤트
	runLua("UI_Data/Script/Window/Servant/Wharf/Panel_Window_WharfRegister.lua")		-- 등록
	runLua("UI_Data/Script/Window/Servant/Wharf/Panel_Window_WharfList.lua")			-- 리스트
	runLua("UI_Data/Script/Window/Servant/Wharf/Panel_Window_WharfInfo.lua")			-- 기본 정보
	
	-- 탑승물 ---------------------------------------------------------------------
	runLua("UI_Data/Script/Window/Servant/Panel_Window_Servant.lua")					-- 말&마차 아이콘 버튼
	runLua("UI_Data/Script/Window/Servant/Panel_Window_ServantInfo.lua")				-- 말  정보
	runLua("UI_Data/Script/Window/Servant/Panel_Window_ServantInfo_Carriage.lua")		-- 마차  정보
	runLua("UI_Data/Script/Window/Servant/Panel_Window_ServantInfo_Ship.lua")			-- 배  정보
	runLua("UI_Data/Script/Window/Servant/HorseMp.lua")									-- 탑승물 HP
	runLua("UI_Data/Script/Window/Servant/HorseHp.lua")									-- 탑승물 MP
	runLua("UI_Data/Script/Window/Inventory/Panel_Window_ServantInventory.lua")			-- 탈것 인벤열기
	runLua("UI_Data/Script/Window/Servant/Panel_Window_GuildServantList.lua")			-- 길드 탑승물 목록 열기
	----------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------

	runLua("UI_Data/Script/Window/HouseInfo/Panel_MyHouseNavi.lua")				-- 주거지 네비게이숀
	-- 14.12.30 return_ServantIconNums 함수 호출 때문에 Panel_Window_Servant 보다 먼저 선언되어야 한다.
	runLua("UI_Data/Script/Widget/Housing/Panel_HousingList.lua")				-- 내 주거지 목록
	runLua("UI_Data/Script/Widget/Housing/Panel_HarvestList.lua")				-- 내 텃밭 목록

------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 메이드(★) ---------------------------------------------------------------------
	runLua("UI_Data/Script/Widget/Maid/Panel_Icon_Maid.lua")							-- 메이드
	-- runLua("UI_Data/Script/Widget/Maid/Panel_Maid_Interaction.lua")						-- 메이드 인터랙션 이벤트
	
--------------------------------------------------------------------------------------------------------------------------------------------------
	--- 펫관리 ---------------------------------------------------------------------------------------------------------------------------------------
	-- runLua("UI_Data/Script/Window/Servant/Pet/Panel_Window_PetFunction.lua")			-- 이벤트
	-- runLua("UI_Data/Script/Window/Servant/Pet/Panel_Window_PetRegister.lua")			-- 등록
	-- runLua("UI_Data/Script/Window/Servant/Pet/Panel_Window_PetList.lua")				-- 리스트
	-- runLua("UI_Data/Script/Window/Servant/Pet/Panel_Window_PetInfo.lua")				-- 기본 정보
	-- runLua("UI_Data/Script/Window/Servant/Pet/Panel_Window_PetMating.lua")				-- 교배
	-- runLua("UI_Data/Script/Window/Servant/Pet/Panel_Window_PetMarket.lua")				-- 시장

	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetRegister.lua")				-- 펫 등록
	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetInfo.lua")					-- 펫 정보
	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetControl.lua")					-- 펫 액션
	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetList.lua")					-- 펫 리스트
	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetLookChange.lua")				-- 펫 외형변경
	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetMarket.lua")					-- 펫 거래소
	runLua("UI_Data/Script/Window/PetInfo/Panel_Window_PetMarketRegist.lua")			-- 펫 거래소 등록창
	
	-- 메시지 히스토리
	runLua("UI_Data/Script/Widget/MessageHistory/Panel_MessageHistory.lua")
	
	-- 대포 --------------------------------------------------------
	runLua("UI_Data/Script/Window/Servant/Panel_Cannon.lua")							-- 대포 쿨타임/조작
----------------------------------------------------------------
	runLua("UI_Data/Script/Widget/QuestList/Panel_NewQuest.lua")
	runLua("UI_Data/Script/Widget/UIControlBar/Panel_UIControl.lua") 			-- UI 컨트롤바
	runLua("UI_Data/Script/Widget/UIControlBar/Panel_UIMain.lua")
	runLua("UI_Data/Script/Widget/QuickSlot/Panel_QuickSlot.lua")
	runLua("UI_Data/Script/Widget/QuickSlot/Panel_NewQuickSlot.lua")			-- 새 퀵슬롯
	runLua("UI_Data/Script/Widget/QuickSlot/Panel_SkillCooltime.lua")

	-- ● 플레이어 정보 위젯들	----------------------------------------------------------
	-- runLua("UI_Data/Script/Widget/MainStatus/Panel_SelfPlayerBriefInfo.lua")
	runLua("UI_Data/Script/Widget/MainStatus/Panel_MainStatus_User_Bar.lua")
	runLua("UI_Data/Script/Widget/MainStatus/Panel_SelfPlayerExpGage.lua")
	runLua("UI_Data/Script/Widget/MainStatus/PvpMode_Button.lua")
	runLua("UI_Data/Script/Widget/MainStatus/Panel_ClassResource.lua")
	runLua("UI_Data/Script/Widget/MainStatus/SelfPlayer_HpCheck.lua")
	runLua("UI_Data/Script/Widget/MainStatus/Panel_Adrenallin.lua")
	runLua("UI_Data/Script/Widget/MainStatus/Panel_GuardGauge.lua")
	
	runLua("UI_Data/Script/Window/MovieGuide/Panel_MovieGuide.lua")
----------------------------------------------------------
	-- ● 중요한 지식 표시 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/ImportantKnowledge/Panel_ImportantKnowledge.lua")
----------------------------------------------------------	
	-- ● 더 좋은 장비 표시 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/NewEquip/Panel_NewEquip.lua")
----------------------------------------------------------	
	runLua("UI_Data/Script/Widget/NoticeAlert/NoticeAlert.lua")
	runLua("UI_Data/Script/Widget/Damage/UI_Lua_Damage.lua")
	runLua("UI_Data/Script/Widget/CharacterNameTag/Panel_CharacterNameTag.lua")
	runLua("UI_Data/Script/Widget/CharacterNameTag/Panel_BubbleBox.lua")
	runLua("UI_Data/Script/Widget/CharacterNameTag/Panel_WaitComment.lua")
	runLua("UI_Data/Script/Widget/CharacterNameTag/Panel_Navigation.lua")
	runLua("UI_Data/Script/Widget/HumanRelations/HumanRelations.lua")
	runLua("UI_Data/Script/Window/Keypad/Panel_Window_Number.lua")
----------------------------------------------------------
	-- ● 주점 술 사기 -------------------------------------------------
	runLua("UI_Data/Script/Window/BuyDrink/Panel_BuyDrink.lua")
----------------------------------------------------------
	-- ● 다이얼로그 -------------------------------------------------
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Main.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Reward.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Itemtake.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Window_NpcShop.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Scene.lua")							-- npc dialog Scene
	runLua("UI_Data/Script/Widget/Dialogue/Panel_DetectPlayer.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_ButtonType.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_InterestKnowledge.lua")
	runLua("UI_Data/Script/Widget/Dialogue/Panel_KnowledgeManagement.lua")					-- 지식 관리
	runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Exchange_Item.lua")					-- 교환 아이템 목록
	runLua("UI_Data/Script/Window/Worldmap/WorkerRandomSelect/UI_New_WorkerRandomSelect.lua")				-- 고용일꾼 상점
	runLua("UI_Data/Script/Window/Worldmap/UnKnowItemSelect/UI_New_UnKnowItemSelect.lua")					-- 랜덤 상점
----------------------------------------------------------
	-- ● 도움말 버튼 툴팁----------------------------------------------------------
	runLua("UI_Data/Script/Widget/HelpMessage/Panel_HelpMessage.lua")
-----------------------------------------------------------------------
	-- ● 지식보기 / 게임 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Dialogue/Panel_MentalKnowledge_Base.lua")
   	runLua("UI_Data/Script/Widget/Dialogue/Panel_MentalGame.lua")
-----------------------------------------------------------------------
	-- ● 지식 ( 신버전 ) ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Knowledge/Panel_Knowledge_Main.lua")
-----------------------------------------------------------------------

-- ● 영상 보기  ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Movie/Panel_IntroMovie.lua")
	runLua("UI_Data/Script/Window/Movie/Panel_MovieTheater_320.lua")
	runLua("UI_Data/Script/Window/Movie/Panel_MovieTheater_640.lua")
	runLua("UI_Data/Script/Window/Movie/Panel_MovieTheater_LowLevel.lua")
	runLua("UI_Data/Script/Window/Movie/Panel_MovieTheater_SkillGuide_640.lua")
------------------------------------------------------------------------

-- ● 최초 튜토리얼  ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Tutorial/Panel_Tutorial.lua")
	runLua("UI_Data/Script/Widget/Tutorial/Panel_Movie_KeyViewer.lua")
----------------------------------------------------------
	-- ● 퀘스트 목록 -----------------------------------------------
	runLua("UI_Data/Script/Widget/QuestList/Panel_CheckedQuest.lua")
	runLua("UI_Data/Script/Widget/QuestList/Panel_QuestInfo.lua")
----------------------------------------------------------
	-- ● 파티 리스트 -----------------------------------------------------
	runLua("UI_Data/Script/Widget/Party/Panel_PartyCombat.lua")	-- 파티 결투 (글로벌 함수때문에 Party 파일보다 위)
	runLua("UI_Data/Script/Widget/RaceMatch/Panel_RaceMatch.lua")	-- 말 경주
	runLua("UI_Data/Script/Widget/Party/Panel_Party.lua")
	runLua("UI_Data/Script/Widget/Party/Panel_PartyItemList.lua")
	----------------------------------------------------------
	-- ● 버프 리스트 --------------------------------------------------
	runLua("UI_Data/Script/Widget/Buff/Panel_AppliedBuffList.lua")
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
	-- ● 월드맵 ---------------------------------------------------
	runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Request.lua")				-- 운송 요청 창
	runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Information.lua")			-- 운송 정보 창
	runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_InformationView.lua")		-- 운송 정보 창
	runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_CarriageInformation.lua")	-- 마차 운송중인 아이템 정보 창	
	
	runLua("UI_Data/Script/Window/WorldMap/FishEncyclopedia/Panel_FishEncyclopedia.lua")	-- 어류도감


----------------------------------------------------------------------
	-- 길드 --------------------------------------------------
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_History.lua")
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_List.lua")
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_Quest.lua")
	-- runLua("UI_Data/Script/Window/Guild/Frame_Guild_Quest_Sub.lua")
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_Warfare.lua")
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_Recruitment.lua")
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_CraftInfo.lua")
	runLua("UI_Data/Script/Window/Guild/Frame_Guild_Skill.lua")
	runLua("UI_Data/Script/Window/Guild/Panel_Guild.lua")
	runLua("UI_Data/Script/Window/Guild/Panel_GuildDuel.lua")
	runLua("UI_Data/Script/Window/Guild/Guild_Popup.lua")
	runLua("UI_Data/Script/Window/Guild/Panel_AgreementGuild.lua")	-- 길드 고용 계약서
	runLua("UI_Data/Script/Window/Guild/Panel_AgreementGuild_Master.lua")	-- 길드 초대
	runLua("UI_Data/Script/Window/Guild/Panel_Guild_Incentive.lua")	-- 길드 인센티브 설정
	runLua("UI_Data/Script/Window/Guild/Panel_GuildRank.lua")		-- 길드랭크
	runLua("UI_Data/Script/Window/Guild/Panel_GuildWebInfo.lua")	-- 길드웹정보

	runLua("UI_Data/Script/Window/Guild/Panel_ClanList.lua")			-- 클랜용 리스트

	-- runLua("UI_Data/Script/Widget/WarRecord/Panel_WarRecord.lua")		-- 점령전/거점전 내 스코어
	

----------------------------------------------------------------------
	-- 레벨업 ---------------------------------------------------
	runLua("UI_Data/Script/Widget/LevelUpMessage/Panel_Levelup_Reward.lua")
-----------------------------------------------------------------------
	-- Fade Screen --------------------------------------------------
	runLua("UI_Data/Script/Widget/FadeScreen/Panel_Fade_Screen.lua")
----------------------------------------------------------------------
	-- 인터렉션 --------------------------------------------------
	runLua("UI_Data/Script/Widget/Interaction/Panel_Interaction.lua")
	runLua("UI_Data/Script/Widget/Interaction/Panel_Interaction_FriendHouseList.lua")	-- 친구집
	runLua("UI_Data/Script/Widget/Interaction/Panel_Interaction_HouseRank.lua")
	runLua("UI_Data/Script/Widget/Interaction/Panel_WatchingMode.lua")
------------------------------------------------------------------------
	--하우징설치, 집목록 --------------------------------------------------
	runLua("UI_Data/Script/Widget/Housing/Panel_Housing_FarmInfo.lua")			-- 텐트 채집물 정보
	runLua("UI_Data/Script/Widget/Housing/Panel_InstallationMode_FarmGuide.lua")		-- 텃밭 가이드
	runLua("UI_Data/Script/Widget/Housing/Panel_Housing.lua")					-- 하우징 컨트롤러
	runLua("UI_Data/Script/Widget/Housing/Panel_HouseName.lua")					-- 현재 누구 집이냐?
	runLua("UI_Data/Script/Widget/Housing/AlertInstallation.lua")	            -- 설치물 경고
	-- runLua("UI_Data/Script/Window/HouseInfo/Panel_MyHouseNavi.lua")				-- 주거지 네비게이숀
	runLua("UI_Data/Script/Window/HouseInfo/Panel_House_SellBuy_Condition.lua")	-- 하우스 구매/매각 조건

	runLua("UI_Data/Script/Window/Housing/Panel_House_InstallationMode.lua")					-- 하우징 가구 설치 모드
	runLua("UI_Data/Script/Window/Housing/Panel_House_InstallationMode_ObjectControl.lua")		-- 하우징 가구 설치 메뉴
	runLua("UI_Data/Script/Window/Housing/Panel_House_InstallationMode_Cart.lua")				-- 하우징 가구 설치 모드 카트
	

	runLua("UI_Data/Script/Window/HouseInfo/Panel_New_HouseControl.lua")			-- 하우스 메뉴
----------------------------------------------------------------------
	--하우징 사업 --------------------------------------------------
	runLua("UI_Data/Script/Widget/Housing/HousingVendingMachine.lua")
	runLua("UI_Data/Script/Widget/Housing/HousingConsignmentSale.lua")
	runLua("UI_Data/Script/Widget/Housing/MyVendorList.lua")
----------------------------------------------------------------------
	-- 프로그래스바 관련 --------------------------------------------------
	runLua("UI_Data/Script/Widget/ProgressBar/Panel_ProgressBar.lua")
----------------------------------------------------------------------
	-- 타겟 정보 (EnemyGauge) --------------------------------------------------
	runLua("UI_Data/Script/Widget/EnemyGauge/Panel_RecentTargetInfo.lua")
----------------------------------------------------------------------
	-- 개인 거래 --------------------------------------------------
	runLua("UI_Data/Script/Window/Exchange/Panel_ExchangeWithPC.lua")
----------------------------------------------------------------------
	-- 레이더 (미니맵) --------------------------------------------------
	--runLua("UI_Data/Script/Widget/Rader/Radar_GlobalValue.lua")
	runLua("UI_Data/Script/Widget/Rader/Rader_Background.lua")
	runLua("UI_Data/Script/Widget/Rader/Radar_Pin.lua")
	runLua("UI_Data/Script/Widget/Rader/Rader.lua")
----------------------------------------------------------------------
	-- 메시지 박스 --------------------------------------------------
	runLua("UI_Data/Script/Window/MessageBox/MessageBox.lua")
	runLua("UI_Data/Script/Window/MessageBox/MessageBoxCheck.lua")
----------------------------------------------------------------------
	-- 교역 --------------------------------------------------
	runLua("UI_Data/Script/Window/TradeMarket/Panel_Window_TradeMarket.lua")					-- dialogTrade
	runLua("UI_Data/Script/Window/TradeMarket/Panel_TradeMarket_BuyList.lua")					-- 구매 목록
	runLua("UI_Data/Script/Window/TradeMarket/Panel_TradeMarket_SellList.lua")					-- 판매 목록
	runLua("UI_Data/Script/Window/TradeMarket/Panel_Window_TradeMarket_Graph.lua")
	-- runLua("UI_Data/Script/Window/TradeMarket/Panel_Trade_EventMsg.lua")
	runLua("UI_Data/Script/Window/TradeMarket/Panel_TradeGame.lua")
	runLua("UI_Data/Script/Window/TradeMarket/Panel_TradeEventNotice.lua")
	
----------------------------------------------------------------------
	-- 연금술 --------------------------------------------------
	runLua("UI_Data/Script/Window/Alchemy/Panel_Alchemy.lua")
----------------------------------------------------------------------
	-- 친구 목록 --------------------------------------------------
	runLua("UI_Data/Script/Window/Friend/Panel_Friends.lua")
----------------------------------------------------------------------
	-- 가공 --------------------------------------------------
	runLua("UI_Data/Script/Window/Alchemy/Panel_Manufacture.lua")
----------------------------------------------------------------------
	-- 우편 --------------------------------------------------
	runLua("UI_Data/Script/Window/Mail/Panel_Mail.lua")
	runLua("UI_Data/Script/Window/Mail/Panel_Mail_Detail.lua")
	runLua("UI_Data/Script/Window/Mail/Panel_Mail_Send.lua")
----------------------------------------------------------------------
	-- 게임 옵션 -----------------------------------------
	runLua("UI_Data/Script/Window/Option/UI_GameOption.lua")
	runLua("UI_Data/Script/Window/Option/Attacked_ClosePanel.lua")
	runLua("UI_Data/Script/Window/Option/Panel_SetShortCut.lua")
----------------------------------------------------------	
	-- ● 커맨드 가이드  ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/SkillCommand/UI_Widget_SkillCommand.lua")
----------------------------------------------------------------------
	-- 제작 노트 -----------------------------------------
	runLua("UI_Data/Script/Window/ProductNote/Panel_ProductNote.lua")
	runLua("UI_Data/Script/Window/KeyboardHelp/Panel_Window_KeyboardHelp.lua")
	--runLua("UI_Data/Script/Window/ProductNote/Panel_ProductNote_Item.lua")
----------------------------------------------------------------------
	-- 1:1 문의 -----------------------------------------
	runLua("UI_Data/Script/Window/QnAWebLink/Panel_QnAWebLink.lua")
	-- 염색 하기 -----------------------------------------
	-- runLua("UI_Data/Script/Window/Dye/Panel_Dye.lua")
	runLua("UI_Data/Script/Window/Dye/Panel_ColorBalance.lua")
	runLua("UI_Data/Script/Window/Dye/Panel_DyePreview.lua")
	runLua("UI_Data/Script/Window/Dye/Panel_DyeNew_CharacterController.lua")
	runLua("UI_Data/Script/Window/Dye/Panel_Dye_New.lua")
	runLua("UI_Data/Script/Window/Dye/Panel_DyePalette.lua")

----------------------------------------------------------	
		-- 게임팁 ---------------------------------------------------------------------
	runLua("UI_Data/Script/Widget/GameTips/Panel_GameTips.lua")
	runLua("UI_Data/Script/Widget/GameTips/Panel_GameTips_Frame.lua")

----------------------------------------------------------------------
	-- NPC 네비게이션 -----------------------------------------
	runLua("UI_Data/Script/Widget/NpcNavigation/NpcNavigation.lua")
----------------------------------------------------------------------
	-- ● 미니게임 Main ( 미니게임들보다 이후에 로딩되어야 한다! )
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Main.lua")
----------------------------------------------------------------------
	-- ● 미니게임 ----------------------------------------------------------
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Gradient.lua")				-- 기울기
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_SinGauge.lua")				-- SIN 게이지
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Command.lua")				-- 커맨드
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Rhythm.lua")				-- 리듬 게임
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Rhythm_Drum.lua")		-- 리듬 게임 (액션용)
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_BattleGauge.lua")			-- 배틀 게이지
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_FillGauge.lua")				-- 채우기 게이지
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_GradientY.lua")				-- 기울기 Y축
    runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Timing.lua")				-- 타이밍 게임
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_HerbMachine.lua")			-- 타이밍 게임
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Steal.lua")					-- 주머니 도둑
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Buoy.lua")					-- 부표 게임
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_PowerControl.lua")			-- 소 젖짜기
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Jaksal.lua")				-- 낚시 작살
    -- runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Drag.lua")				-- 원형 따라가기
	runLua("UI_Data/Script/Widget/MiniGame/MiniGame_Clear.lua")					
------------------------------------------------------------------------
	-- ● 조사 하기  ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Search/Panel_Dialog_Search.lua")
----------------------------------------------------------
	-- ● 게임 종료 패널 ----------------------------------------------------------
    runLua("UI_Data/Script/Window/GameExit/Panel_GameExit.lua")
    runLua("UI_Data/Script/Window/GameExit/Panel_GameExitServerSelect.lua")
------------------------------------------------------------------------
	-- ● 사망 경고 표시 ----------------------------------------------------------
    runLua("UI_Data/Script/Window/DeadMessage/Panel_NoAccessArea_Alert.lua")
	-- ● 즉시 부활  ----------------------------------------------------------
   runLua("UI_Data/Script/Window/DeadMessage/Panel_Cash_Revival_BuyItem.lua")
------------------------------------------------------------------------

	-- ● 내구도창 ----------------------------------------------------------
    runLua("UI_Data/Script/Widget/Enduarance/Enduarance.lua")
    runLua("UI_Data/Script/Widget/Enduarance/Servant_Endurance.lua")						-- 탑승물 내구도
------------------------------------------------------------------------
	-- ● 숨게이지 ----------------------------------------------------------
    runLua("UI_Data/Script/Widget/BreathGauge/Panel_BreathGauge.lua")
------------------------------------------------------------------------
	-- ● 수리관련 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Repair/Panel_Window_Repair.lua")							-- 수리관련
	runLua("UI_Data/Script/Window/Repair/Panel_FixEquip.lua")								-- 내구도 수리
------------------------------------------------------------------------
	-- ● 추출관련 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Extraction/Panel_Window_Extraction.lua")					-- 추출 메인
	runLua("UI_Data/Script/Window/Extraction/Panel_Window_Extraction_Crystal.lua")			-- 수정 추출
	runLua("UI_Data/Script/Window/Extraction/Panel_Window_Extraction_EnchantStone.lua")		-- 강화석 추출
	runLua("UI_Data/Script/Window/Extraction/Panel_Window_Extraction_Cloth.lua")			-- 의상 추출
------------------------------------------------------------------------
	-- ● 강화실패 수치 추출 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Enchant/Panel_EnchantExtraction.lua")					-- 강화실패 추출
------------------------------------------------------------------------
	-- ● Scroll 관련 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Scroll/Panel_Scroll.lua")
------------------------------------------------------------------------
	-- ● 튜토리얼 ----------------------------------------------------------
	runLua("UI_Data/Script/Tutorial/TutorialMain.lua")
------------------------------------------------------------------------
	-- ● PC 운송 ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_Person.lua")
	runLua("UI_Data/Script/Window/Delivery/Panel_Window_Delivery_GameExit.lua")
------------------------------------------------------------------------
	-- 퀘스트 History ----------------------------------------------------------
	runLua("UI_Data/Script/Window/Quest/Panel_Quest_Window.lua")		-- 14.06.08
	runLua("UI_Data/Script/Window/Quest/Panel_Quest_History_New.lua")
	
------------------------------------------------------------------------
	-- 지식 정보 얻기 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/Dialogue/Panel_AskKnowledge.lua")
------------------------------------------------------------------------
	-- ● 도움말  ----------------------------------------------------------
	-- runLua("UI_Data/Script/Window/Help/Panel_Help.lua")
----------------------------------------------------------
	-- ● NaviPath 관련 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/NaviPath/NaviPath.lua")
----------------------------------------------------------
	-- ● 내비 아이콘 ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/TownNpcNavi/Panel_Widget_TownNpcNavi.lua")
----------------------------------------------------------
	-- ● 컷씬 UI ----------------------------------------------------------
	runLua("UI_Data/Script/CutScene.lua")

----------------------------------------------------------
	-- ● ingameCustomize UI ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/InGameCustomize/InGameCustomize.lua")
----------------------------------------------------------
	-- ● recent Memory UI ----------------------------------------------------------
	runLua("UI_Data/Script/Widget/RecentMemory/RecentMemory.lua")
----------------------------------------------------------
	ToClient_initializeWorldMap("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_Base.XML")
	------------grandopen
	if isGrandOpen then
		-- { core
			runLua("UI_Data/Script/Window/WorldMap_Grand/Grand_WorldMap_NodeMenu.lua")					-- Worldmap core
			runLua("UI_Data/Script/Window/WorldMap_Grand/Grand_WorldMap_MenuPanel.lua")					-- Worldmap core
			runLua("UI_Data/Script/Window/WorldMap_Grand/Grand_WorldMap_MainPanel.lua")					-- Worldmap core
		-- }

		runLua("UI_Data/Script/Window/Worldmap_Grand/Grand_WorldMap_NodeName.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_HouseNavi.lua")					-- 월드맵 집 찾기
		runLua("UI_Data/Script/Window/Worldmap_Grand/Grand_WorldMap_MovieTooltip.lua")
		runLua("UI_Data/Script/Widget/WarInfoMessage/Panel_WarInfoMessage.lua")						-- 점령전 정보 메시지
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WarInfo.lua")						-- 점령전 현황판
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_NodeWarInfo.lua")					-- 거점전 현황판
		runLua("UI_Data/Script/Window/Worldmap_Grand/Grand_WorldMap_NodeOwnerInfo.lua")				-- 소유 정보
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_QuestTooltip.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_TerritoryTooltip.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_ActorTooltip.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_PopupManager.lua")				-- Worldmap Popup 관리
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap.lua")								-- 월드맵 루아
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_HouseHold.lua")					-- 월드맵 House 관련 루아( 생산, 제작은 따로 분리 )
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WorkManager_House.lua")			-- 하우스 제작 (일반)
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WorkManager_LargeCraft.lua")		-- 하우스 제작 (대규모)
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WorkManager_Building.lua")		-- 성채(?)
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WorkManager_Plant.lua")			-- 생산거점
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WorkManager_Harvest.lua")			-- 텃밭
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WorkManager_Finance.lua")			-- 금융 상품
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Knowledge.lua")					-- 지식
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Town_WorkerManage.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_QuestTooltip.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Working_Progress.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_LordManager.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Delivery.lua")					-- 운송정보(아이콘)				-- independent
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_TerritoryTooltip.lua")
		-- runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Information.lua")				-- 새 버전에서는 필요 없다(통합됨)
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_ActorTooltip.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WroldMap_TradeNpcItemInfo.lua")			-- 황실 납품 정보
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_TradeNpcList.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Tent.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_PinGuide.lua")
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_NodeStable.lua")					-- 월드맵 축사 정보창
		runLua("UI_Data/Script/Window/Worldmap_Grand/New_Worldmap_NodeStableInfo.lua")				-- 월드맵 축사 정보창
	else
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_PopupManager.lua")					-- Worldmap Popup 관리
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap.lua")								-- 월드맵 루아
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_HouseNavi.lua")						-- 월드맵 집 찾기
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_Panel.lua")							-- 월드맵 패널( 체크, 렌더 변경 )
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Node.lua")							-- 월드맵 노드 관련 루아
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_HouseHold.lua")						-- 월드맵 House 관련 루아( 생산, 제작은 따로 분리 )
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_WorkManager_House.lua")				-- 하우스 제작 (일반)
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_WorkManager_LargeCraft.lua")		-- 하우스 제작 (대규모)
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_WorkManager_Building.lua")			-- 성채(?)
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_WorkManager_Plant.lua")				-- 생산거점
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_WorkManager_Harvest.lua")			-- 텃밭
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_WorkManager_Finance.lua")			-- 금융 상품
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Knowledge.lua")						-- 지식
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Town_WorkerManage.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_QuestTooltip.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Working_Progress.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_LordManager.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_Delivery.lua")						-- 운송정보(아이콘)				-- independent
		runLua("UI_Data/Script/Window/WorldMap/New_WorldMap_TerritoryTooltip.lua")
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_Information.lua")
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_ActorTooltip.lua")
		runLua("UI_Data/Script/Window/WorldMap/New_WroldMap_TradeNpcItemInfo.lua")			-- 황실 납품 정보
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_TradeNpcList.lua")
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_Tent.lua")
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_PinGuide.lua")
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_WarInfo.lua")	-- 점령전 정보
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_NodeWarInfo.lua")	-- 점령전 정보
		runLua("UI_Data/Script/Widget/WarInfoMessage/Panel_WarInfoMessage.lua")	-- 점령전 정보 메시지
		runLua("UI_Data/Script/Window/Worldmap/New_WorldMap_NodeStable.lua")			-- 월드맵 축사 정보창
		runLua("UI_Data/Script/Window/Worldmap/New_Worldmap_NodeStableInfo.lua")		-- 월드맵 축사 정보창
	end

	-- 길드 하우스 제작
	runLua("UI_Data/Script/Window/Worldmap_Grand/WordMap_Craft/Worldmap_Grand_GuildCraft.lua")				-- 길드 하우스 제작
	runLua("UI_Data/Script/Window/Worldmap_Grand/WordMap_Craft/Worldmap_Grand_GuildHouseControl.lua")		-- 길드 하우스 제작
	runLua("UI_Data/Script/Window/Worldmap_Grand/WordMap_Craft/Worldmap_Grand_GuildCraft_ChangeWorker.lua")	-- 길드 하우스 제작/일꾼 변경

	-- { 펄 상점
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_Cart.lua")				-- 펄 상점 장바구니
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_MakePaymentsFromCart.lua")-- 펄 상점 장바구니 구입 확인 창

		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop.lua")						-- 펄 상점
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_GoodsTooltip.lua")		-- 펄 상점 상품 툴팁
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_GoodsDetailInfo.lua")		-- 펄 상점 상품 정보
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_SetEquip.lua")			-- 펄 상점 장착창
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_BuyOrGift.lua")			-- 펄 상점 상품 구입창
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_PaymentPassword.lua")		-- 결제 비밀 번호
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_ChargeDaumCash.lua")		-- 다음캐시 충전
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_TermsofDaumCash.lua")		-- 다음캐시 이용 약관
		runLua("UI_Data/Script/Window/IngameCashShop/Panel_IngameCashShop_BuyPearlBox.lua")			-- 펄 상자 구매창
	-- }

	
	-- 캐시 커마
	runLua("UI_Data/Script/Window/Cash_Customization/Panel_Cash_Customization.lua")				-- 캐시 커마 우측 메뉴
	
	-- 아이템 거래 시장
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket_Function.lua")				-- 아이템 거래 시장 컨트롤창
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket_ItemSet.lua")				-- 아이템 거래 시장 등록 아이템 관리
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket.lua")						-- 아이템 거래 시장 리스트
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket_RegistItem.lua")			-- 아이템 거래 시장 등록창
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket_BuyConfirm.lua")			-- 아이템 거래 시장 구입 갯수 확인창
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket_AlarmList.lua")			-- 아이템 거래 시장 최저가 등록 알림 리스트
	runLua("UI_Data/Script/Window/ItemMarket/Panel_Window_ItemMarket_Alarm.lua")				-- 아이템 거래 시장 최저가 등록 알림
		
	runLua("UI_Data/Script/Window/ChallengePresent/Panel_ChallengePresent.lua")					-- 도전과제 달성 정보
	runLua("UI_Data/Script/Window/ChallengePresent/Panel_Special_Reward.lua")					-- 도전과제 달성/특별 보상 알림 및 메시지
	
	-- PC방 가챠 상자!
	runLua("UI_Data/Script/Widget/Gacha_Roulette/Panel_Gacha_Roulette.lua")						-- PC방 가챠!
	-----------------------------------------------------------------------------

	-- -- 파워 게이지
	runLua("UI_Data/Script/Widget/PowerGauge/Panel_PowerGauge.lua")								-- 파워 게이지
	runLua("UI_Data/Script/Widget/PowerGauge/CannonGuage.lua")									-- 캐논 게이지
	-----------------------------------------------------------------------------

	-- PC방 혜택 안내
	runLua("UI_Data/Script/Window/PcRoomNotify/Panel_PcRoomNotify.lua")							-- PC방 혜택 안내
	-----------------------------------------------------------------------------
	
	-- 이벤트
	runLua("UI_Data/Script/Window/EventNotify/Panel_EventNotify.lua")							-- 진행중인 이벤트안내
	runLua("UI_Data/Script/Window/EventNotify/Panel_EventNotifyContent.lua")					-- 진행중인 이벤트 뷰페이지
	-- runLua("UI_Data/Script/Window/Beginner/Panel_BeginnerReward.lua")							-- 신규 유저를 보상
	runLua("UI_Data/Script/Window/Event/Panel_Event_100Day.lua")								-- 대장정 100일 기념 폭풍지원 프로젝트s
	-- runLua("UI_Data/Script/Window/DailyLogin/Panel_DailyLogin.lua")								-- 출석체크 마일리지
	-----------------------------------------------------------------------------

	runLua("UI_Data/Script/Window/CarveSeal/Panel_CarveSeal.lua")	-- 각인
	runLua("UI_Data/Script/Window/CarveSeal/Panel_ResetSeal.lua")	-- 각인 해제
	
	runLua("UI_Data/Script/Window/ClearVested/Panel_ClearVested.lua")	-- 귀속 해제

	runLua("UI_Data/Script/Window/UI_Setting/Panel_UI_Setting.lua")	-- UI편집모드

	runLua("UI_Data/Script/Window/WorkerManager/Panel_WorkerManager.lua")					-- 일꾼관리
	runLua("UI_Data/Script/Window/WorkerManager/Panel_WorkerRestoreAll.lua")				-- 일꾼 전체 회복 관리
	runLua("UI_Data/Script/Window/WorkerManager/Panel_WorkerChangeSkill.lua")				-- 일꾼 스킬 변경

	runLua("UI_Data/Script/Window/TransferLifeExperience/Panel_TransferLifeExperience.lua")	-- 생활 경험치 이전
	runLua("UI_Data/Script/Window/ChangeItem/Panel_ChangeItem.lua")							-- 의상 변경
	runLua("UI_Data/Script/Window/ChangeItem/Panel_ChangeWeapon.lua")						-- 무기 교환
	runLua("UI_Data/Script/Window/Alchemy/Panel_AlchemyStone.lua")							-- 연금석
	runLua("UI_Data/Script/Window/Alchemy/Panel_AlchemyFigureHead.lua")						-- 선수상

	
	runLua("UI_Data/Script/Window/RallyRanking/Panel_RallyRanking.lua")				-- 대회순위
	runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
	runLua("UI_Data/Script/Widget/LocalWar/Panel_LocalWar.lua")						-- 국지전
	runLua("UI_Data/Script/Window/Join/Panel_Window_Join.lua")						-- 참전
	runLua("UI_Data/Script/Widget/WarInfoMessage/Panel_TerritoryWar_Alert.lua")		-- 점령전 비참여
	
	loadCustomizationUI()
	
----------------------------------------------------------
----------------------------------------------------------
	-- 반드시 루아 파일 로딩은 이 윗부분에 추가 바랍니다!!!!!
	runLua("UI_Data/Script/globalUIManager.lua")		--
	runLua("UI_Data/Script/globalKeyBinder.lua");
	isLuaLoadingComplete = true		-- lua 로딩이 끝났다.

end

function WorldMapWindow_Update_ExplorePoint()
end
-- function DeliveryRequestWindow_Close()
-- end
-- function DeliveryInformationWindow_Close()
-- end
