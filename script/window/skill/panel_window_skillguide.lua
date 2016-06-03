local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local IM			= CppEnums.EProcessorInputMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode

Panel_Window_SkillGuide:setMaskingChild( true )
Panel_Window_SkillGuide:ActiveMouseEventEffect( true )
Panel_Window_SkillGuide:setGlassBackground( true )
Panel_Window_SkillGuide:RegisterShowEventFunc( true, 'Panel_Window_SkillGuide_ShowAni()' )
Panel_Window_SkillGuide:RegisterShowEventFunc( false, 'Panel_Window_SkillGuide_HideAni()' )

Panel_Window_SkillGuide:SetShow( false )
----------------------------------------------------------------------------------------------------------------
local ui = {
	_mainListBox			= UI.getChildControl ( Panel_Window_SkillGuide, "Static_Box" ),
	
	_className				= UI.getChildControl ( Panel_Window_SkillGuide, "StaticText_ClassName" ),
	_btn_WinClose			= UI.getChildControl ( Panel_Window_SkillGuide, "Button_Win_Close" ),
	_btn_Close				= UI.getChildControl ( Panel_Window_SkillGuide, "Button_Close" ),
	_btn_Question			= UI.getChildControl ( Panel_Window_SkillGuide, "Button_Question" ),

	_verticalScroll			= UI.getChildControl ( Panel_Window_SkillGuide, "VerticalScroll" ),
}
ui._verticalScroll:SetShow( false )
local classBtn = {
	_btn_Class_0			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class0" ),	-- 워리어
	_btn_Class_1			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class1" ),	-- 레인저
	_btn_Class_2			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class2" ),	-- 소서러
	_btn_Class_3			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class3" ),	-- 자이언트
	_btn_Class_4			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class4" ),	-- 금수랑
	_btn_Class_5			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class5" ),	-- 무사
	_btn_Class_6			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class6" ),	-- 발키리
	_btn_Class_7			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class7" ),	-- 매화(여자 무사)
	_btn_Class_8			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class8" ),	-- 위치(여자 위자드)
	_btn_Class_9			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class9" ),	-- 위자드
	_btn_Class_10			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class10" ),	-- 쿠노이치
	_btn_Class_11			= UI.getChildControl( Panel_Window_SkillGuide, "RadioButton_Class11" ),	-- 쿠노이치
}

local _btn_ScrollBtn		= UI.getChildControl ( ui._verticalScroll, "VerticalScroll_CtrlButton" )

local copyUi = {
	_skillNameBG			= UI.getChildControl ( Panel_Window_SkillGuide, "Static_SkillList_BG" ),
	_btn_PlayButton			= UI.getChildControl ( Panel_Window_SkillGuide, "Button_MovieTooltip" ),
}

ui._btn_WinClose:addInputEvent( "Mouse_LUp", "Panel_Window_SkillGuide_ShowToggle()" )
ui._btn_Close:addInputEvent( "Mouse_LUp", "Panel_Window_SkillGuide_ShowToggle()" )

local NowTitleInterval			= 0
local MinTitleInterval			= 0
local MaxTitleInterval			= 0

--------------------------------------------------------
--		영상 추가될 때마다 단계 추가 해줘야한다!
local difficultyDesc_Warrior = 
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_Ranger = 
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_Sorcer = 
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_Giant = 
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_Tamer =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_BladeMaster =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_Valkyrie =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_BladeMasterWomen =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_Wizard =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_WizardWomen =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_NinjaWomen =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
local difficultyDesc_NinjaMan =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_LOW"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_MIDDLE"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGH"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_SKILLGUIDE_DEFFICULTYDESC_HIGHTOP"),
}
----------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--				켜고 꺼주는 애니메이션 함수
------------------------------------------------------------
function Panel_Window_SkillGuide_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_Window_SkillGuide, 0.0, 0.15 )
	
	local aniInfo1 = Panel_Window_SkillGuide:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Window_SkillGuide:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_SkillGuide:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_SkillGuide:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_SkillGuide:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_SkillGuide:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_Window_SkillGuide_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_SkillGuide, 0.0, 0.1 )
	aniInfo:SetHideAtEnd( true )
end


---------------------------------------------------------------------------------
-- 지역변수 설정
---------------------------------------------------------------------------------

local UI_classType = CppEnums.ClassType
local tempSkillGuide = {
	_skillListBG			= UI.getChildControl( Panel_Window_SkillGuide, "Static_SkillList_BG" ),
	_playButton				= UI.getChildControl( Panel_Window_SkillGuide, "Button_MovieTooltip" ),
}

-- maxMovieCount 가 실제 영상 개수 ( 0부터 카운트 되므로 -1 을 해준다! ) ※ 영상 추가할 때 마다 count 값 올려줘야함
local classType	= {
	[UI_classType.ClassType_Warrior			]	= { _maxMovieCount = 5 - 1, _currentPos = 0, _interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WARRIOR")		},
	[UI_classType.ClassType_Ranger			]	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RANGER")		},
	[UI_classType.ClassType_Sorcerer		] 	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_SORCERER")		},
	[UI_classType.ClassType_Giant			]	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_GIANT")		},
	[UI_classType.ClassType_Tamer			]	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_TAMER")		},
	[UI_classType.ClassType_BladeMaster		]	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTER")	},
	[UI_classType.ClassType_Valkyrie		]	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_VALKYRIE")		},
	[UI_classType.ClassType_BladeMasterWomen]	= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTERWOMAN")		},
	[UI_classType.ClassType_Wizard]				= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARD")		},
	[UI_classType.ClassType_WizardWomen]		= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARDWOMAN")	},
	[UI_classType.ClassType_NinjaWomen]			= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAWOMEN")	},
	[UI_classType.ClassType_NinjaMan]			= { _maxMovieCount = 5 - 1, _currentPos = 0,_interval = 0,	_name=" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAMAN")	},
}

local maxCount = 9			-- 한 페이지에 보여줄 수 있는 최대 값
local skillMovieList	= {}
local currentSelectedClass = UI_classType.ClassType_Warrior;

------------------------------------------------------------
--				최초 셋팅해주는 함수
------------------------------------------------------------
function Panel_Window_SkillGuide_Initialize()
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end
	
	local UI_classType = CppEnums.ClassType
	local myClassType = getSelfPlayer():getClassType() 

	local guideStartY	= 5
	local guideGapY		= 49

	for idx = 0, maxCount - 1, 1 do
		
		local createSkillListBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, ui._mainListBox, 'StaticText_SkillGuide_' .. idx )
		CopyBaseProperty( copyUi._skillNameBG, createSkillListBG )
		createSkillListBG:SetPosX( 5 )
		createSkillListBG:SetPosY( guideStartY )
		createSkillListBG:SetShow( true )
		
		local createPlayButton = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, createSkillListBG, 'Button_PlayButton_' .. idx )
		CopyBaseProperty( copyUi._btn_PlayButton, createPlayButton )
		createPlayButton:SetPosX( createSkillListBG:GetSizeX() - createPlayButton:GetSizeX() - 10 )
		createPlayButton:SetShow( true )
		
		skillMovieList[idx] = {}
		skillMovieList[idx]._bg = createSkillListBG;
		skillMovieList[idx]._btn = createPlayButton;
		
		ui._mainListBox:addInputEvent("Mouse_DownScroll", "Panel_SkillGuide_ScrollEventFunc( false )")
		ui._mainListBox:addInputEvent("Mouse_UpScroll", "Panel_SkillGuide_ScrollEventFunc( true )")
		skillMovieList[idx]._bg:addInputEvent("Mouse_DownScroll", "Panel_SkillGuide_ScrollEventFunc( false )")
		skillMovieList[idx]._bg:addInputEvent("Mouse_UpScroll", "Panel_SkillGuide_ScrollEventFunc( true )")
		skillMovieList[idx]._btn:addInputEvent("Mouse_DownScroll", "Panel_SkillGuide_ScrollEventFunc( false )")
		skillMovieList[idx]._btn:addInputEvent("Mouse_UpScroll", "Panel_SkillGuide_ScrollEventFunc( true )")

		guideStartY				= guideStartY + guideGapY
	end
	
	for _, v in pairs(classBtn) do
		v:SetCheck( false )
	end
	
	classBtn._btn_Class_0:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Warrior.. ")" )
	classBtn._btn_Class_1:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Ranger .. ")" )
	classBtn._btn_Class_2:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Sorcerer .. ")" )
	classBtn._btn_Class_3:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Giant .. ")" )
	classBtn._btn_Class_4:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Tamer .. ")" )
	classBtn._btn_Class_5:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_BladeMaster .. ")" )
	classBtn._btn_Class_6:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Valkyrie .. ")" )
	classBtn._btn_Class_7:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_BladeMasterWomen .. ")" )
	classBtn._btn_Class_8:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_Wizard .. ")" )
	classBtn._btn_Class_9:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_WizardWomen .. ")" )
	classBtn._btn_Class_10:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_NinjaWomen .. ")" )
	classBtn._btn_Class_11:addInputEvent( "Mouse_LUp", "Panel_SkillGuide_ClassClicked(" .. UI_classType.ClassType_NinjaMan .. ")" )
	
	classBtn._btn_Class_0:SetCheck( true )
	if isGameTypeRussia() then
		classBtn._btn_Class_6:SetShow( false ) -- 발키리 미출시로 미노출.
		classBtn._btn_Class_7:SetShow( false ) -- 매화 미출시 미노출.
		classBtn._btn_Class_8:SetShow( false ) -- 위치, 위자드 미출시 미노출.
		classBtn._btn_Class_9:SetShow( false ) -- 위자드 미출시 미노출.
		classBtn._btn_Class_10:SetShow( false ) -- 쿠노이치 미출시 미노출.
		classBtn._btn_Class_11:SetShow( false ) -- 닌자 미출시 미노출.
	elseif isGameTypeEnglish() then
		classBtn._btn_Class_9:SetShow( false ) -- 위치 미출시 미노출.
		classBtn._btn_Class_10:SetShow( false ) -- 쿠노이치 미출시 미노출.
		classBtn._btn_Class_11:SetShow( false ) -- 닌자 미출시 미노출.
	end
	classBtn._btn_Class_0:ResetVertexAni()
	classBtn._btn_Class_0:SetVertexAniRun( "Ani_Color", true )

	if UI_classType.ClassType_Warrior == myClassType then
		classBtn._btn_Class_0:SetCheck( true )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Warrior)
	elseif UI_classType.ClassType_Ranger == myClassType then
		classBtn._btn_Class_1:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Ranger)
	elseif UI_classType.ClassType_Sorcerer == myClassType then
		classBtn._btn_Class_2:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Sorcerer)
	elseif UI_classType.ClassType_Giant == myClassType then
		classBtn._btn_Class_3:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Giant)
	elseif UI_classType.ClassType_Tamer == myClassType then
		classBtn._btn_Class_4:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )		
		classBtn._btn_Class_5:SetCheck( false )		
		classBtn._btn_Class_6:SetCheck( false )	
		classBtn._btn_Class_7:SetCheck( false )	
		classBtn._btn_Class_8:SetCheck( false )	
		classBtn._btn_Class_9:SetCheck( false )	
		classBtn._btn_Class_10:SetCheck( false )	
		classBtn._btn_Class_11:SetCheck( false )	
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Tamer)
	elseif UI_classType.ClassType_BladeMaster == myClassType then
		classBtn._btn_Class_5:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_BladeMaster)
	elseif UI_classType.ClassType_Valkyrie == myClassType then
		classBtn._btn_Class_6:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Valkyrie)
	elseif UI_classType.ClassType_BladeMasterWomen == myClassType then
		classBtn._btn_Class_7:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_BladeMasterWomen)
	elseif UI_classType.ClassType_Wizard == myClassType then
		classBtn._btn_Class_8:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Wizard)
	elseif UI_classType.ClassType_WizardWomen == myClassType then
		classBtn._btn_Class_9:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_WizardWomen)
	elseif UI_classType.ClassType_NinjaWomen == myClassType then
		classBtn._btn_Class_10:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_NinjaWomen)
	elseif UI_classType.ClassType_NinjaMan == myClassType then
		classBtn._btn_Class_11:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_NinjaMan)
	end
end

function Panel_SkillGuide_Update()
	local UI_classType	= CppEnums.ClassType
	local myClassType	= getSelfPlayer():getClassType() 
	local iconPosX		= 15
	local iconPosY		= 48

	if UI_classType.ClassType_Warrior == myClassType then
		classBtn._btn_Class_0:SetCheck( true )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Warrior)
	elseif UI_classType.ClassType_Ranger == myClassType then
		classBtn._btn_Class_1:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Ranger)
	elseif UI_classType.ClassType_Sorcerer == myClassType then
		classBtn._btn_Class_2:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Sorcerer)
	elseif UI_classType.ClassType_Giant == myClassType then
		classBtn._btn_Class_3:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Giant)
	elseif UI_classType.ClassType_Tamer == myClassType then
		classBtn._btn_Class_4:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Tamer)
	elseif UI_classType.ClassType_BladeMaster == myClassType then
		classBtn._btn_Class_5:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_BladeMaster)
	elseif UI_classType.ClassType_Valkyrie == myClassType then
		classBtn._btn_Class_6:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Valkyrie)
	elseif UI_classType.ClassType_BladeMasterWomen == myClassType then
		classBtn._btn_Class_7:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_BladeMasterWomen)
	elseif UI_classType.ClassType_Wizard == myClassType then
		classBtn._btn_Class_8:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_Wizard)
	elseif UI_classType.ClassType_WizardWomen == myClassType then
		classBtn._btn_Class_9:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		classBtn._btn_Class_11:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_WizardWomen)
	elseif UI_classType.ClassType_NinjaMan == myClassType then
		classBtn._btn_Class_11:SetCheck( true )
		classBtn._btn_Class_0:SetCheck( false )
		classBtn._btn_Class_1:SetCheck( false )
		classBtn._btn_Class_2:SetCheck( false )
		classBtn._btn_Class_3:SetCheck( false )
		classBtn._btn_Class_4:SetCheck( false )
		classBtn._btn_Class_5:SetCheck( false )
		classBtn._btn_Class_6:SetCheck( false )
		classBtn._btn_Class_7:SetCheck( false )
		classBtn._btn_Class_8:SetCheck( false )
		classBtn._btn_Class_9:SetCheck( false )
		classBtn._btn_Class_10:SetCheck( false )
		Panel_SkillGuide_ClassClicked(UI_classType.ClassType_NinjaMan)
	end
	
	if classBtn._btn_Class_0:GetShow() then
		classBtn._btn_Class_0:SetPosX( iconPosX )
		classBtn._btn_Class_0:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_0:GetSizeX() + 5
	end
	if classBtn._btn_Class_1:GetShow() then
		classBtn._btn_Class_1:SetPosX( iconPosX )
		classBtn._btn_Class_1:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_1:GetSizeX() + 5
	end
	if classBtn._btn_Class_2:GetShow() then
		classBtn._btn_Class_2:SetPosX( iconPosX )
		classBtn._btn_Class_2:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_2:GetSizeX() + 5
	end
	if classBtn._btn_Class_3:GetShow() then
		classBtn._btn_Class_3:SetPosX( iconPosX )
		classBtn._btn_Class_3:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_3:GetSizeX() + 5
	end
	if classBtn._btn_Class_4:GetShow() then
		classBtn._btn_Class_4:SetPosX( iconPosX )
		classBtn._btn_Class_4:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_4:GetSizeX() + 5
	end
	if classBtn._btn_Class_5:GetShow() then
		classBtn._btn_Class_5:SetPosX( iconPosX )
		classBtn._btn_Class_5:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_5:GetSizeX() + 5
	end
	if classBtn._btn_Class_6:GetShow() then
		classBtn._btn_Class_6:SetPosX( iconPosX )
		classBtn._btn_Class_6:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_6:GetSizeX() + 5
	end
	if classBtn._btn_Class_7:GetShow() then
		classBtn._btn_Class_7:SetPosX( iconPosX )
		classBtn._btn_Class_7:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_7:GetSizeX() + 5
	end
	if classBtn._btn_Class_8:GetShow() then
		classBtn._btn_Class_8:SetPosX( iconPosX )
		classBtn._btn_Class_8:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_8:GetSizeX() + 5
	end
	if classBtn._btn_Class_9:GetShow() then
		classBtn._btn_Class_9:SetPosX( iconPosX )
		classBtn._btn_Class_9:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_9:GetSizeX() + 5
	end
	if classBtn._btn_Class_10:GetShow() then
		classBtn._btn_Class_10:SetPosX( iconPosX )
		classBtn._btn_Class_10:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_10:GetSizeX() + 5
	end
	if classBtn._btn_Class_11:GetShow() then
		classBtn._btn_Class_11:SetPosX( iconPosX )
		classBtn._btn_Class_11:SetPosY( iconPosY )
		iconPosX = iconPosX + classBtn._btn_Class_11:GetSizeX() + 5
	end
end

------------------------------------------------------------
--					스크롤 처리 함수
------------------------------------------------------------
function Panel_SkillGuide_ScrollEventFunc( UpDown )
	if( UpDown ) then
		classType[currentSelectedClass]._currentPos = classType[currentSelectedClass]._currentPos - 1;
		if( classType[currentSelectedClass]._currentPos < 0 ) then
			classType[currentSelectedClass]._currentPos = 0;
		end
	else
		classType[currentSelectedClass]._currentPos = classType[currentSelectedClass]._currentPos + 1;
		if( classType[currentSelectedClass]._currentPos > classType[currentSelectedClass]._interval ) then
			classType[currentSelectedClass]._currentPos = classType[currentSelectedClass]._interval
		end
	end
	
	ui._verticalScroll:SetControlPos(classType[currentSelectedClass]._currentPos/classType[currentSelectedClass]._interval)
	
	SetClassMovieInfo(currentSelectedClass)
end

function SetClassMovieInfo ( classNo )
	for index = 0, maxCount -1 do
		skillMovieList[index]._bg:SetShow(false);
	end
	
	local sizeY = ui._mainListBox:GetSizeY()
	local itemSizeY = skillMovieList[0]._bg:GetSizeY()
	
	local visibleItemCount = math.floor(sizeY / itemSizeY) - 1
	for index =	0, maxCount - 1 do
		if( classType[classNo]._maxMovieCount < index ) then
			break;
		end
		
		local movieindex =  index + classType[classNo]._currentPos
		if ( classNo == 0 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Warrior[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_Warrior[index] )
		elseif ( classNo == 4 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Ranger[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_Ranger[index] )
		elseif ( classNo == 8 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Sorcer[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_Sorcer[index] )
		elseif ( classNo == 12 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Giant[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_Giant[index] )
		elseif ( classNo == 16 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Tamer[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_Tamer[index] )
		elseif ( classNo == 20 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_BladeMaster[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		elseif ( classNo == 21 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_BladeMasterWomen[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		elseif ( classNo == 24 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Valkyrie[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		elseif ( classNo == 25 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_NinjaWomen[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		elseif ( classNo == 26 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_NinjaMan[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		elseif ( classNo == 28 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_Wizard[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		elseif ( classNo == 31 ) then
			skillMovieList[index]._bg:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SKILLGUIDE_SKILLGUIDEMOVIE", "name", classType[classNo]._name, "index", difficultyDesc_WizardWomen[index] ) ) -- classType[classNo]._name .. ": 기술 연계 가이드 영상 - " .. difficultyDesc_BladeMaster[index] )
		end
		
		skillMovieList[index]._btn:addInputEvent("Mouse_LUp", "Panel_MovieTheaterSkillGuide640_ShowToggle(" .. classNo .. ", " .. movieindex.. ")")
		
		if( visibleItemCount <= index )then
			skillMovieList[index]._bg:SetShow(false)
			skillMovieList[index]._btn:SetShow(false)
		else
			skillMovieList[index]._bg:SetShow(true)
			skillMovieList[index]._btn:SetShow(true)
		end
	end
end

function Panel_SkillGuide_ClassClicked( classNo )
	currentSelectedClass = classNo;
	for _, v in pairs( classBtn ) do
		v:ResetVertexAni()
	end
	
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end
	
	ui._className:SetText( "-" .. classType[classNo]._name)
	
	classType[classNo]._currentPos = 0;
	
	SetClassMovieInfo( classNo );
	
	local sizeY = ui._mainListBox:GetSizeY();
	
	ui._verticalScroll:SetShow( false )
	if( maxCount < classType[classNo]._maxMovieCount ) then
		classType[classNo]._interval = classType[classNo]._maxMovieCount - maxCount
		
		ui._verticalScroll:SetShow( true )
		ui._verticalScroll:SetInterval( classType[classNo]._maxMovieCount - maxCount )
		ui._verticalScroll:SetControlPos( 0 );
		_btn_ScrollBtn:SetSize( _btn_ScrollBtn:GetSizeX(), sizeY / ( classType[classNo]._interval + 1) );
	end	
end

Panel_Window_SkillGuide_Initialize()

function Panel_Window_SkillGuide_ShowToggle()
	local isShow = Panel_Window_SkillGuide:IsShow()
	if ( isShow == true ) then
		Panel_Window_SkillGuide:SetShow( false, true )
		FGlobal_Panel_MovieTheater_SkillGuide_640_UrlReset()
	else
		Panel_Window_SkillGuide:SetShow( true, true )
		Panel_MovieTheater_SkillGuide_640_Initialize()
		Panel_SkillGuide_Update()
	end
end