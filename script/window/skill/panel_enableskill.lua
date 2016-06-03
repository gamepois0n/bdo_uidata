local UIMode 		= Defines.UIMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_classType	= CppEnums.ClassType

Panel_EnableSkill:SetShow( false )
Panel_EnableSkill:RegisterShowEventFunc( true, 'EnableSkill_ShowAni()' )
Panel_EnableSkill:RegisterShowEventFunc( false, 'EnableSkill_HideAni()' )
Panel_EnableSkill:ActiveMouseEventEffect( true )
Panel_EnableSkill:setGlassBackground( true )
Panel_EnableSkill:SetDragAll( true )

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 프레임부터 가져온다
local _closeButton		 		= UI.getChildControl ( Panel_EnableSkill, "Button_Close" )

local _buttonQuestion 			= UI.getChildControl( Panel_EnableSkill, "Button_Question" )			-- 물음표 버튼

local _frameBG 					= UI.getChildControl ( Panel_EnableSkill, "Static_FrameBG" )
local _slide 					= UI.getChildControl ( Panel_EnableSkill, "VerticalScroll" )
local _slideBtn 				= UI.getChildControl ( _slide, "VerticalScroll_CtrlButton" )

local skillEmptyText			= UI.getChildControl ( Panel_EnableSkill, "StaticText_EmptySkill" )

-- 카피할 녀석들의 베이스 컨트롤
local CopyUI =
{
	_base_SkillBG 				= UI.getChildControl ( Panel_EnableSkill, "Static_C_SkillBG" ),
	_base_SkillBlueBG			= UI.getChildControl ( Panel_EnableSkill, "Static_C_SkillBlueBG" ),
	_base_SkillIcon 			= UI.getChildControl ( Panel_EnableSkill, "Static_C_SkillIcon" ),
	_base_SkillName 			= UI.getChildControl ( Panel_EnableSkill, "StaticText_C_SkillName" ),
	_base_SkillNeedSP			= UI.getChildControl ( Panel_EnableSkill, "StaticText_C_NeedSP" ),
	_base_LearnButton			= UI.getChildControl ( Panel_EnableSkill, "Button_LearnSkill" ),
}

local enableSkillList_MaxCount = 8		-- 반드시 8개까지만 보여준다.
local uiData = {}
local slideIndex = 0
local maxIndex = 0
local skillNumber = {}
local skillRow = {}
local skillColumn = {}
local Panel_EnableSkill_Value_elementCount = 0
local recommendSkillCount = 0			-- 추천 스킬 수
local isSkillLearnTutorialClick = false

local onIndex = -1		--background mouse over index

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--추천 스킬[직업][스킬번호]
local maxRecommendCount = 99
local recommendSkill = {}
recommendSkill[UI_classType.ClassType_Warrior] = {						-- 워리어
	[0]		= 1021,
	[1]		= 1127,
	[2]		= 1128,
	[3]		= 1129,

	[4]		= 1024,
	[5]		= 1078,
	[6]		= 1079,

	[7]		= 349,
	[8]		= 350,
	[9]		= 351,
	[10]	= 705,

	[11]	= 1023,
	[12]	= 1133,
	[13]	= 1134,
	[14]	= 1135, 
}
recommendSkill[UI_classType.ClassType_Ranger] = {						-- 레인저
	[0]		= 1006,
	[1]		= 1091,
	[2]		= 1092,
	[3]		= 1093,
	
	[4]		= 1007,
	[5]		= 1095,
	[6]		= 1096,
	[7]		= 1097,
	[8]		= 1098,

	[9]		= 1009,
	[10]	= 1103,
	[11]	= 1104,
	[12]	= 1105,
	
	[13]	= 1012,
	[14]	= 1127,
	[15]	= 1253,
	        
	[16]	= 1015,
	[17]	= 1113,
	[18]	= 1114,
	[19]	= 1115,
	[20]	= 318,
	        
	[21]	= 1363,
	[22]	= 1364,
	[23]	= 1365,
	[24]	= 1366,
	[25]	= 1367,
	        
	[26]	= 322,
	[27]	= 323,
	[28]	= 324,
}
recommendSkill[UI_classType.ClassType_Sorcerer] = {						-- 소서러
	[0]		= 310,
	[1]		= 311,
	[2]		= 312,
	
	[3]		= 1056,
	[4]		= 1202,
	[5]		= 1203,
	
	[6]		= 1430,
	[7]		= 1431,
	[8]		= 1432,
	
	[9]		= 1055,
	[10]	= 1201,
	
	[11]	= 380,	
	[12]	= 171,
	
	[13]	= 1353,	
	[14]	= 1354,
	[15]	= 1355,
	
	[16]	= 585,	
	[17]	= 586,
	[18]	= 587,
	[19]	= 588,
}
recommendSkill[UI_classType.ClassType_Giant] = {						-- 자이언트
	[0]		= 1044,
	[1]		= 1175,
	[2]		= 1176,
	[3]		= 1177,
	[4]		= 1178,
	[5]		= 1179,
	
	[6]		= 1042,
	[7]		= 1167,
	[8]		= 1168,
	[9]		= 1169,
	[10]	= 1170,
	[11]	= 1171,

	[12]	= 1057,
	[13]	= 1180,
	[14]	= 1181,
	[15]	= 1290,
	[16]	= 102,
	[17]	= 103,
	[18]	= 104,
	[19]	= 105,
	[20]	= 106,
	[21]	= 107,

	[22]	= 1032,
	[23]	= 1149,
	[24]	= 1150,

	[25]	= 1036,
	[26]	= 1157,
	[27]	= 1158,
}
recommendSkill[UI_classType.ClassType_Tamer] = {						-- 금수랑
	[0]		= 11,
	[1]		= 12,
	[2]		= 13,
	[3]		= 14,
	
	[4]		= 15,
	[5]		= 16,
	[6]		= 17,
	
	[7]		= 1070,
	[8]		= 1232,
	[9]		= 1233,
	[10]	= 1234,
	
	[11]	= 1073,
	[12]	= 1241,
	[13]	= 1242,
	[14]	= 1243,
	[15]	= 1244,
	[16]	= 1245,
	
	[17]	= 1065,
	[18]	= 1220,
	[19]	= 1221,
	
	[20]	= 84,
	[21]	= 228,
	
	[22]	= 1068,
	[23]	= 1227,
	[24]	= 1228,
	[25]	= 1229,
}
recommendSkill[UI_classType.ClassType_BladeMaster] = {					-- 무사
	[0]		= 1455,
	[1]		= 1456,
	[2]		= 1457,

	[3]		= 1279,
	[4]		= 1280,
	[5]		= 1281,
	[6]		= 1282,

	[7]		= 1445,
	[8]		= 1446,
	[9]		= 1447,
	[10]	= 396,
	[11]	= 1465,

	[12]	= 401,
	[13]	= 402,
	[14]	= 403,
	[15]	= 415,
	[16]	= 416,
	[17]	= 423,

	[18]	= 404,
	[19]	= 405,
	[20]	= 406,

	[21]	= 1273,
	[22]	= 394,
}
recommendSkill[UI_classType.ClassType_BladeMasterWomen] = {					-- 여자 무사
	[0]		= 1591,
	[1]		= 1592,
	[2]		= 1593,

	[3]		= 1539,
	[4]		= 1540,
	[5]		= 1541,
	[6]		= 1542,

	[7]		= 1572,
	[8]		= 1573,
	[9]		= 1574,
	[10]	= 1575,
	[11]	= 1576,

	[12]	= 1582,
	[13]	= 1583,
	[14]	= 1584,
	[15]	= 1585,
	[16]	= 1586,
	[17]	= 1587,

	[18]	= 1588,
	[19]	= 1589,
	[20]	= 1590,

	[21]	= 1529,
	[22]	= 1533,
}
recommendSkill[UI_classType.ClassType_Valkyrie] = {						-- 발키리
	[0]		= 744,
	[1]		= 745,
	[2]		= 746,

	[3]		= 732,
	[4]		= 733,
	[5]		= 734,
	[6]		= 735,
	[7]		= 770,

	[8]		= 762,
	[9]		= 763,
	[10]	= 764,

	[11]	= 772,
	[12]	= 773,
	[13]	= 774,
	
	[14]	= 765,
	[15]	= 766,
	[16]	= 767,
	[17]	= 768,
	[18]	= 775,
}
recommendSkill[UI_classType.ClassType_Wizard] = {						-- 위자드
	[0]		= 834,
	[1]		= 835,
	[2]		= 836,
	[3]		= 837,
	[4]		= 838,

	[5]		= 822,
	[6]		= 823,
	[7]		= 824,
	[8]		= 825,
	[9]		= 826,

	[10]	= 847,
	[11]	= 848,
	[12]	= 849,

	[13]	= 904,
	[14]	= 905,
	[15]	= 906,
	[16]	= 907,
	[17]	= 908,

	[18]	= 909,
	[19]	= 910,
	[20]	= 911,

	[21]	= 868,
	[22]	= 869,
	[23]	= 870,
	[24]	= 871,

	[25]	= 786,
	[26]	= 787,
	[27]	= 788,
	[28]	= 789,
}
recommendSkill[UI_classType.ClassType_WizardWomen] = {					-- 위치(위자드 여자)
	[0]		= 834,
	[1]		= 835,
	[2]		= 836,
	[3]		= 837,
	[4]		= 838,

	[5]		= 822,
	[6]		= 823,
	[7]		= 824,
	[8]		= 825,
	[9]		= 826,

	[10]	= 847,
	[11]	= 848,
	[12]	= 849,

	[13]	= 904,
	[14]	= 905,
	[15]	= 906,
	[16]	= 907,
	[17]	= 908,

	[18]	= 909,
	[19]	= 910,
	[20]	= 911,

	[21]	= 868,
	[22]	= 869,
	[23]	= 870,
	[24]	= 871,

	[25]	= 786,
	[26]	= 787,
	[27]	= 788,
	[28]	= 789,
}
recommendSkill[UI_classType.ClassType_NinjaWomen] = {						-- 쿠노이치.
	[0]		= 949,
	[1]		= 950,
	[2]		= 951,
	[3]		= 1624,
	[4]		= 1625,

	[5]		= 958,
	[6]		= 959,
	[7]		= 960,
	[8]		= 961,

	[9]		= 966,
	[10]	= 967,
	[11]	= 968,
	[12]	= 969,
	[13]	= 970,

	[14]	= 972,
	[15]	= 973,
	[16]	= 974,

	[17]	= 1654,
	[18]	= 1655,
	[19]	= 1656,
	[20]	= 1657,
	[21]	= 1658,
}
recommendSkill[UI_classType.ClassType_NinjaMan] = {
	[0]		= 949,
	[1]		= 950,
	[2]		= 951,
	[3]		= 1624,
	[4]		= 1625,

	[5]		= 958,
	[6]		= 959,
	[7]		= 960,
	[8]		= 961,

	[9]		= 966,
	[10]	= 967,
	[11]	= 968,
	[12]	= 969,
	[13]	= 970,

	[14]	= 972,
	[15]	= 973,
	[16]	= 974,

	[17]	= 1698,
	[18]	= 1699,
	[19]	= 1700,
}
---------------------------
--		나오는 애니
function EnableSkill_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_EnableSkill, 0.0, 0.15 )
	
	local aniInfo1 = Panel_EnableSkill:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_EnableSkill:GetSizeX() / 2
	aniInfo1.AxisY = Panel_EnableSkill:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_EnableSkill:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_EnableSkill:GetSizeX() / 2
	aniInfo2.AxisY = Panel_EnableSkill:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
---------------------------
--		사라지는 애니
function EnableSkill_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_EnableSkill, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

---------------------------------------------------------------
--					스킬 데이터를 받아오는 곳
---------------------------------------------------------------
function enableSkill_UpdateData()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local cellTable = nil
	if nil ~= selfPlayer then
		local classType = selfPlayer:getClassType()
		if 0 <= classType then
			cellTable = getCombatSkillTree( classType )
		else
			return
		end
	end
	
	local cols = cellTable:capacityX()
	local rows = cellTable:capacityY()
	
	Panel_EnableSkill_Value_elementCount = 0
	recommendSkillCount = 0
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			local cell = cellTable:atPointer( col, row )
			local skillNo = cell._skillNo

			if (cell:isSkillType()) then
				local skillLevelInfo = getSkillLevelInfo( skillNo )
				
				if ( skillLevelInfo._learnable ) then
					local recommendCheck = false
					for i = 0, maxRecommendCount -1 do
						if ( skillNo == recommendSkill[selfPlayer:getClassType()][i] ) then					-- 추천 스킬인지 체크
							for ii = Panel_EnableSkill_Value_elementCount+1, recommendSkillCount, -1 do		-- 추천 스킬이면 앞으로 보낸다
								if recommendSkillCount == ii then
									skillNumber[ii] = skillNo
									skillRow[ii] = row
									skillColumn[ii] = col
								else
									skillNumber[ii] = skillNumber[ii-1]
									skillRow[ii] = skillRow[ii-1]
									skillColumn[ii] = skillColumn[ii-1]
								end
							end
							recommendSkillCount = recommendSkillCount + 1
							Panel_EnableSkill_Value_elementCount = Panel_EnableSkill_Value_elementCount + 1
							recommendCheck = true
						end
					end
					
					if not recommendCheck then
						skillNumber[Panel_EnableSkill_Value_elementCount] = skillNo
						skillRow[Panel_EnableSkill_Value_elementCount] = row
						skillColumn[Panel_EnableSkill_Value_elementCount] = col
						Panel_EnableSkill_Value_elementCount = Panel_EnableSkill_Value_elementCount + 1
					end
				end
			end
		end
	end
	
	if Panel_EnableSkill_Value_elementCount < 9 then
		_slide:SetShow(false)
	else
		_slide:SetShow(true)
	end
	
	if Panel_EnableSkill_Value_elementCount == 0 then
		skillEmptyText:SetShow( true )
	else
		skillEmptyText:SetShow( false )
	end
	
	for index = 0, enableSkillList_MaxCount - 1, 1 do
		if (slideIndex + index) < Panel_EnableSkill_Value_elementCount then
			local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNumber[slideIndex + index] )
			if skillTypeStaticWrapper:isValidLocalizing() then
				uiData[index]:SetData( skillTypeStaticWrapper, skillNumber[slideIndex + index] )
				if (slideIndex + index) < recommendSkillCount then			-- 추천 스킬 부분에 효과 적용해야 함!
					uiData[index]._RecommendBG:SetShow(true)
					-- uiData[index]._RecommendBG:ResetVertexAni()
					uiData[index]._RecommendBG:SetVertexAniRun("Ani_Color_New", true)
					uiData[index]._IconBG:SetShow(false)
				else
					uiData[index]._RecommendBG:SetShow(false)
					uiData[index]._RecommendBG:ResetVertexAni()
					uiData[index]._IconBG:SetShow(true)
				end
				--uiData[index]._IconBG:SetShow(true)
				--uiData[index]._RecommendBG:SetShow(false)
				uiData[index]._skillIcon:SetShow(true)
				uiData[index]._skillName:SetShow(true)
				uiData[index]._needSp:SetShow(true)
				uiData[index]._learnButton:SetShow(true)
			end
		else
			uiData[index]._IconBG:SetShow(false)
			uiData[index]._RecommendBG:SetShow(false)
			uiData[index]._skillIcon:SetShow(false)
			uiData[index]._skillName:SetShow(false)
			uiData[index]._needSp:SetShow(false)
			uiData[index]._learnButton:SetShow(false)
		end
	end
	
--	if ( -1 ~= onIndex ) then
--		enableSkill_BackgroundOverEvent( onIndex, true )
--	end

	UIScroll.SetButtonSize( _slide, enableSkillList_MaxCount, Panel_EnableSkill_Value_elementCount )		-- 스크롤 컨트롤들 , UI에서 보여주는 최대개수 , 실제 리스트의 수

end

function FGlobal_EnableSkillReturn()
	--enableSkill_UpdateData()
	return Panel_EnableSkill_Value_elementCount
end

---------------------------------------------------------------
-- 						창 끄고 켜준다
---------------------------------------------------------------
function EnableSkillShowFunc()
	if ( Panel_Window_Skill:IsShow() == true ) then
		Panel_EnableSkill:SetShow( true, true )
		_slide:SetControlPos(0)
		slideIndex = 0
		enableSkill_UpdateData()
		Panel_EnableSkill_SetPosition()
		EnableSkill_LearnBtn_Effect()
	else
		Panel_EnableSkill:SetShow ( false, true )
	end
end

function EnableSkill_LearnBtn_Effect()
	if ( true == uiData[0]._learnButton:GetShow()) then
		if ( nil ~= isSkillLearnTutorial()) and ( true == isSkillLearnTutorial()) then
			isSkillLearnTutorialClick = true
			uiData[0]._learnButton:AddEffect("UI_Tuto_Skill_Learn_1",true,-1,1.5)
			uiData[0]._learnButton:AddEffect("UI_Tuto_Skill_C_Learn_1",true,-1,1.5)
			uiData[0]._learnButton:AddEffect("fUI_Tuto_Skill_Learn_01A",true, -1,1.5)
		else
			isSkillLearnTutorialClick = false
		end
	end

end


function Panel_EnableSkill_SetPosition()
	Panel_EnableSkill:SetPosX( Panel_Window_Skill:GetPosX() + Panel_Window_Skill:GetSizeX() - 20 )
	Panel_EnableSkill:SetPosY( Panel_Window_Skill:GetPosY() + 40 )
end

---------------------------------------------------------------
--			컨트롤을 생성해주는 함수 (최대 4개까지)
---------------------------------------------------------------
function enableSkill_MakeControl( index )
	local ui = {}
	
	-- 배울 수 있는 스킬 리스트 맹글기 ( BG )
	ui._IconBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_EnableSkill, 'Static_SkillBG_' .. index )
	CopyBaseProperty( CopyUI._base_SkillBG, ui._IconBG )
	ui._IconBG:SetShow(false)
	ui._IconBG:SetIgnore(false)
	ui._IconBG:SetPosY( 70 + index * ( ui._IconBG:GetSizeY() + 13 ) )
	
	-- 배울 수 있는 추천스킬 리스트 맹글기 ( BG )
	ui._RecommendBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_EnableSkill, 'Static_SkillBlueBG_' .. index )
	CopyBaseProperty( CopyUI._base_SkillBlueBG, ui._RecommendBG )
	ui._RecommendBG:SetShow(false)
	ui._RecommendBG:SetIgnore(false)
	ui._RecommendBG:SetPosY( 70 + index * ( ui._IconBG:GetSizeY() + 13 ) )
	
	-- 배울 수 있는 스킬 리스트 맹글기 ( Icon )
	ui._skillIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_EnableSkill, 'Static_SkillIcon_' .. index )
	CopyBaseProperty( CopyUI._base_SkillIcon, ui._skillIcon )
	ui._skillIcon:SetShow(false)
	ui._skillIcon:SetPosY( 72 + index * ( ui._IconBG:GetSizeY() + 13 ) )
	
	-- 배울 수 있는 스킬 리스트 맹글기 ( Name )
	ui._skillName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_EnableSkill, 'StaticText_SkillName_' .. index )
	CopyBaseProperty( CopyUI._base_SkillName, ui._skillName )
	ui._skillName:SetShow(false)
	ui._skillName:SetIgnore(true)
	ui._skillName:SetPosY( 75 + index * ( ui._IconBG:GetSizeY() + 13 ) )
	
	-- 배울 수 있는 스킬 리스트 맹글기 ( Need SP )
	ui._needSp = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_EnableSkill, 'StaticText_SkillNeedSP_' .. index )
	CopyBaseProperty( CopyUI._base_SkillNeedSP, ui._needSp )
	ui._needSp:SetShow(false)
	ui._needSp:SetIgnore(true)
	ui._needSp:SetPosY( 90 + index * ( ui._IconBG:GetSizeY() + 13 ) )
	
	-- 배울 수 있는 스킬 리스트 맹글기 ( 배우기 버튼 )
	ui._learnButton = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Panel_EnableSkill, 'StaticText_LearnButton_' .. index )
	CopyBaseProperty( CopyUI._base_LearnButton, ui._learnButton )
	ui._learnButton:SetShow(false)
	ui._learnButton:SetIgnore(false)
	ui._learnButton:ComputePos()
	ui._learnButton:SetPosY( 72 + index * ( ui._IconBG:GetSizeY() + 13 ) )

	function ui:SetData( skillTypeSSW, skillNo )
		-------------------------------------------------------
		--			필요 스킬 포인트 가져오기
		local skillStaticWrapper = getSkillStaticStatus( skillNo, 1 )
		local needSp = skillStaticWrapper:get()._needSkillPointForLearning
		
		self._skillIcon:ChangeTextureInfoName( "Icon/"..skillTypeSSW:getIconPath() )
		local recommendCheck = false
		for i = 0, 3 do
			if ( skillNo == recommendSkill[getSelfPlayer():getClassType()][i] ) then
				recommendCheck = true
			end
		end
		
		if ( true == recommendCheck ) then
			self._skillName:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ENABLESKILL_RECOMMAND", "getName", skillTypeSSW:getName() ) ) -- "[추천] " .. skillTypeSSW:getName() )
		else
			self._skillName:SetText( skillTypeSSW:getName() )
		end
			
		self._needSp:SetText( PAGetString( Defines.StringSheet_GAME,"MAINSTATUS_NEWSKILL") .." <PAColor0xffbcf281>"..  needSp .. "<PAOldColor>" )
		
		-------------------------------------------------------
		-- 					툴팁 띄우기
		self._skillIcon:addInputEvent( "Mouse_On", 	"enableSkill_OverEvent(" .. skillNo .. ",false, \"MainStatusSkill\")" )
		self._skillIcon:addInputEvent( "Mouse_Out", "enableSkill_OverEventHide(" .. skillNo .. ",\"MainStatusSkill\")" )
		self._skillIcon:addInputEvent( "Mouse_LUp", "HandleMLUp_SkillWindow_LearnButtonClick(".. skillNo ..")" )
		self._learnButton:addInputEvent( "Mouse_LUp", "HandleMLUp_SkillWindow_LearnButtonClick(".. skillNo ..")" )
			-- UI.debugMessage("배우기 가능 : "..skillNo )
		Panel_SkillTooltip_SetPosition( skillNo, self._skillIcon, "MainStatusSkill" )
	end

	ui._IconBG:addInputEvent( "Mouse_On", 				"enableSkill_BackgroundOverEvent(" .. index .. ",true)" )
	ui._IconBG:addInputEvent( "Mouse_Out", 				"enableSkill_BackgroundOverEvent(" .. index .. ",false)" )
	ui._IconBG:addInputEvent( "Mouse_UpScroll",			"enableSkill_Scroll( true )"	)
	ui._IconBG:addInputEvent( "Mouse_DownScroll",		"enableSkill_Scroll( false )"	)
	ui._RecommendBG:addInputEvent( "Mouse_On", 			"enableSkill_BackgroundOverEvent(" .. index .. ",true)" )
	ui._RecommendBG:addInputEvent( "Mouse_Out", 		"enableSkill_BackgroundOverEvent(" .. index .. ",false)" )
	ui._RecommendBG:addInputEvent( "Mouse_UpScroll",	"enableSkill_Scroll( true )"	)
	ui._RecommendBG:addInputEvent( "Mouse_DownScroll",	"enableSkill_Scroll( false )"	)
	ui._skillIcon:addInputEvent( "Mouse_UpScroll",		"enableSkill_Scroll( true )"	)
	ui._skillIcon:addInputEvent( "Mouse_DownScroll",	"enableSkill_Scroll( false )"	)
	return ui
end
---------------------------------------------------------------
-- 				마우스 이벤트 함수 모음
---------------------------------------------------------------

local skillNoCache = 0
local slotTypeCache = 0
local tooltipcacheCount = 0

function enableSkill_BackgroundOverEvent( index, isOn )
	if true == Panel_EnableSkill:isPlayAnimation() then
		return
	end
	
	local rowNumber = skillRow[index + slideIndex]
	local colNumber = skillColumn[index + slideIndex]
	local skillNoNumber = skillNumber[index + slideIndex]
	if ( isOn ) then
		onIndex = index
		PaGlobal_Skill:SkillWindowEffect( rowNumber, colNumber, skillNoNumber )
	else
		onIndex = -1
	end
end

function enableSkill_OverEventHide( skillNo, SlotType )
	if ( skillNoCache == skillNo ) and ( slotTypeCache == SlotType ) then
		tooltipcacheCount = tooltipcacheCount - 1
	else
		tooltipcacheCount = 0
	end

	if ( tooltipcacheCount <= 0 ) then
		Panel_SkillTooltip_Hide()
	end
end

function enableSkill_OverEvent( skillNo, isShowNextLevel, SlotType )
	if ( skillNoCache == skillNo ) and ( slotTypeCache == SlotType ) then
		tooltipcacheCount = tooltipcacheCount + 1
	else
		skillNoCache = skillNo
		slotTypeCache = SlotType
		tooltipcacheCount = 1
	end
	Panel_SkillTooltip_Show(skillNo, false, SlotType)
end

-- 스크롤을 이용함
function enableSkill_Scroll( isUp )
	slideIndex = UIScroll.ScrollEvent( _slide, isUp, enableSkillList_MaxCount, Panel_EnableSkill_Value_elementCount, slideIndex, 1 )
	enableSkill_UpdateData()
end

function isSkillLearnTutorialClick_check()
	return isSkillLearnTutorialClick
end
---------------------------------------------------------------
--				최초 데이터를 초기화 해준다
---------------------------------------------------------------
function enableSkill_Init()
	for index = 0, enableSkillList_MaxCount - 1 do
		uiData[index] = enableSkill_MakeControl( index )
	end

	-- 카페 베이스를 삭제한다
	Panel_EnableSkill:RemoveControl( CopyUI._base_SkillBG );		CopyUI._base_SkillBG = nil;
	Panel_EnableSkill:RemoveControl( CopyUI._base_SkillBlueBG );	CopyUI._base_SkillBlueBG = nil;
	Panel_EnableSkill:RemoveControl( CopyUI._base_SkillIcon );		CopyUI._base_SkillIcon = nil;
	Panel_EnableSkill:RemoveControl( CopyUI._base_SkillName );		CopyUI._base_SkillName = nil;
	Panel_EnableSkill:RemoveControl( CopyUI._base_SkillNeedSP );	CopyUI._base_SkillNeedSP = nil;
	
	UIScroll.InputEvent( _slide, "enableSkill_Scroll" )
	_frameBG:	addInputEvent( "Mouse_UpScroll",	"enableSkill_Scroll( true )"	)
	_frameBG:	addInputEvent( "Mouse_DownScroll",	"enableSkill_Scroll( false )"	)
	
	enableSkill_UpdateData()
end


enableSkill_Init()
_closeButton:addInputEvent( "Mouse_LUp", "EnableSkillShowFunc()" )
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelEnableSkill\" )" )						-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelEnableSkill\", \"true\")" )			-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelEnableSkill\", \"false\")" )			-- 물음표 마우스오버


function FromClient_EventSkillWindowUpdate()
	slideIndex = 0
	_slide:SetControlPos(0)
	enableSkill_UpdateData()
end

function FromClient_UseSkillAskFromOtherPlayer( fromName )
	local messageboxMemo	= "[<PAColor0xFFE49800>" .. fromName .. PAGetString( Defines.StringSheet_GAME, "LUA_ANSWERSKILL_QUESTTION" ) -- "님이 스킬을 사용하였습니다. 수락하시겠습니다."	--"님이 아이템을 사용하였습니다. 수락하시겠습니까?"
	local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_ANSWERSKILL_MESSAGEBOX_TITLE"), content = messageboxMemo, functionYes = UseSkillFromOtherPlayer_Yes, functionCancel = UseSkillFromOtherPlayer_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)
end

function UseSkillFromOtherPlayer_Yes()
	ToClient_AnswerUseSkill( true )
end

function UseSkillFromOtherPlayer_No()
	ToClient_AnswerUseSkill( false )
end

registerEvent("EventSkillWindowUpdate", "FromClient_EventSkillWindowUpdate")

registerEvent("FromClient_UseSkillAskFromOtherPlayer", "FromClient_UseSkillAskFromOtherPlayer")

