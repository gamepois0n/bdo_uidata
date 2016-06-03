local UI_TM = CppEnums.TextMode

Panel_FirstLogin:SetShow( false )
Panel_FirstLogin:setGlassBackground(true)
Panel_FirstLogin:RegisterShowEventFunc( true, 'Panel_FirstLogin_ShowAni()' )
Panel_FirstLogin:RegisterShowEventFunc( false, 'Panel_FirstLogin_HideAni()' )

function Panel_FirstLogin_ShowAni()
	-- body
end
function Panel_FirstLogin_HideAni()
	-- body
end

local FirstLogin = {
	blockBG							= UI.getChildControl ( Panel_FirstLogin, "Static_blockBG" ),
	BTN_Next						= UI.getChildControl ( Panel_FirstLogin, "Button_Next" ),

	RecommendBG_Low					= UI.getChildControl ( Panel_FirstLogin, "Static_RecommendBG_Low" ),
	RecommendBG_Normal				= UI.getChildControl ( Panel_FirstLogin, "Static_RecommendBG_Normal" ),
	RecommendBG_High				= UI.getChildControl ( Panel_FirstLogin, "Static_RecommendBG_High" ),

	Slider_Control					= UI.getChildControl ( Panel_FirstLogin, "Slider_Control" ),
	Slider_0						= UI.getChildControl ( Panel_FirstLogin, "StaticText_Slider_0" ),
	Slider_50						= UI.getChildControl ( Panel_FirstLogin, "StaticText_Slider_50" ),
	Slider_100						= UI.getChildControl ( Panel_FirstLogin, "StaticText_Slider_100" ),
	Slider_DescBG					= UI.getChildControl ( Panel_FirstLogin, "Static_ContentBG" ),
	Slider_Desc						= UI.getChildControl ( Panel_FirstLogin, "StaticText_ContentDesc" ),
	
	Text_Title						= UI.getChildControl ( Panel_FirstLogin, "StaticText_ContentTitle" ),
	RadioBTN_AllRound				= UI.getChildControl ( Panel_FirstLogin, "RadioButton_Taste_AllRound" ),
	RadioBTN_Combat					= UI.getChildControl ( Panel_FirstLogin, "RadioButton_Taste_Combat" ),
	RadioBTN_Product				= UI.getChildControl ( Panel_FirstLogin, "RadioButton_Taste_Product" ),
	RadioBTN_Fishing				= UI.getChildControl ( Panel_FirstLogin, "RadioButton_Taste_Fishing" ),
	Text_RadioBTN_Title				= UI.getChildControl ( Panel_FirstLogin, "StaticText_Taste_All_Title" ),
	Text_RadioBTN_Desc				= UI.getChildControl ( Panel_FirstLogin, "StaticText_Taste_All_Desc" ),

	RadioBTN_None					= UI.getChildControl( Panel_FirstLogin, "RadioButton_NavGuideNone"),
	RadioBTN_Arrow					= UI.getChildControl( Panel_FirstLogin, "RadioButton_NavGuideArrow"),
	RadioBTN_Effect					= UI.getChildControl( Panel_FirstLogin, "RadioButton_NavGuideEffect"),
	RadioBTN_Fairy					= UI.getChildControl( Panel_FirstLogin, "RadioButton_NavGuideFairy"),
	img_None						= UI.getChildControl( Panel_FirstLogin, "Static_None"),
	img_Arrow						= UI.getChildControl( Panel_FirstLogin, "Static_Arrow"),
	img_Effect						= UI.getChildControl( Panel_FirstLogin, "Static_Effect"),
	img_Fairy						= UI.getChildControl( Panel_FirstLogin, "Static_Fairy"),

	title_TexQuality				= UI.getChildControl( Panel_FirstLogin, "StaticText_TextureQuality"),
	Button_TextureLow				= UI.getChildControl( Panel_FirstLogin, "RadioButton_TextureLow"),
	Button_TextureNormal			= UI.getChildControl( Panel_FirstLogin, "RadioButton_TextureNormal"),
	Button_TextureHigh				= UI.getChildControl( Panel_FirstLogin, "RadioButton_TextureHigh"),

	Step1							= false,
	Step2							= false,
	Step3							= false,
	Step4							= false,

	characterSelect					= nil,

	TEXTURE_QUALITY_HIGH			= 0,
	TEXTURE_QUALITY_NORMAL			= 1,
	TEXTURE_QUALITY_LOW				= 2,
	TEXTURE_QUALITY_COUNT			= 3,

	GRAPHIC_OPTION_HIGH0			= 0,
	GRAPHIC_OPTION_HIGH1			= 1,
	GRAPHIC_OPTION_NORMAL0			= 2,
	GRAPHIC_OPTION_NORMAL1			= 3,
	GRAPHIC_OPTION_LOW0				= 4,
	GRAPHIC_OPTION_LOW1				= 5,
	GRAPHIC_OPTION_VERYLOW			= 6,
	GRAPHIC_OPTION_COUNT			= 7,

	currentTexGraphicOptionIdx		= 0,
	currentGraphicOptionIdx			= 0,

}
	FirstLogin.Slider_ControlBTN	= UI.getChildControl ( FirstLogin.Slider_Control, "Slider_Button" )
	FirstLogin._buttonQuestion		= UI.getChildControl ( Panel_FirstLogin, "Button_Question" )		-- 물음표 버튼
	FirstLogin._buttonQuestion		: SetShow( false )

function FirstLogin:initialize()
	self.BTN_Next				:SetShow( false )

	self.Text_Title				:SetShow( false )
	self.Slider_Desc			:SetShow( false )

	self.Slider_Control			:SetShow( false )
	self.Slider_0				:SetShow( false )
	self.Slider_50				:SetShow( false )
	self.Slider_100				:SetShow( false )
	self.Slider_DescBG			:SetShow( false )

	self.RecommendBG_Low		:SetShow( false )
	self.RecommendBG_Normal		:SetShow( false )
	self.RecommendBG_High		:SetShow( false )

	self.RadioBTN_AllRound		:SetShow( false )
	self.RadioBTN_Combat		:SetShow( false )
	self.RadioBTN_Product		:SetShow( false )
	self.RadioBTN_Fishing		:SetShow( false )
	self.Text_RadioBTN_Title	:SetShow( false )
	self.Text_RadioBTN_Desc		:SetShow( false )

	self.RadioBTN_None			:SetShow( false )
	self.RadioBTN_Arrow			:SetShow( false )
	self.RadioBTN_Effect		:SetShow( false )
	self.RadioBTN_Fairy			:SetShow( false )
	self.img_None				:SetShow( false )
	self.img_Arrow				:SetShow( false )
	self.img_Effect				:SetShow( false )
	self.img_Fairy				:SetShow( false )

	self.title_TexQuality		:SetShow( false )
	self.Button_TextureLow		:SetShow( false )
	self.Button_TextureNormal	:SetShow( false )
	self.Button_TextureHigh		:SetShow( false )

	self.Text_RadioBTN_Desc		:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.Slider_Desc			:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.Slider_DescBG			:SetTextMode( UI_TM.eTextMode_AutoWrap )
end

function FirstLogin:SetStep1()
	self.blockBG:SetSize( getScreenSizeX(), getScreenSizeY() )
	self.blockBG:ComputePos()

	self.Step1	= true
	self.Step2	= false
	self.Step3	= false
	self.Step4	= false

	self.Text_Title	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE1") ) -- "[Step 1/2] 화면 떨림 효과를 설정합니다."
	self.Slider_DescBG:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPDESC1") ) -- - 전투시 타격감을 조절합니다.\n- 다양한 상황에서 타격 및 피격 효과를 극대화 합니다.\n(효과가 너무 과하면 어지러움 및 눈에 피로를 줄 수 있습니다.)
	self.Slider_Control			:SetControlPos(50)

	self.BTN_Next				:SetShow( true )

	self.Text_Title				:SetShow( true )
	self.Slider_Desc			:SetShow( false )

	self.Slider_Control			:SetShow( true )
	self.Slider_0				:SetShow( true )
	self.Slider_50				:SetShow( true )
	self.Slider_100				:SetShow( true )
	self.Slider_DescBG			:SetShow( true )

	self.RecommendBG_Low		:SetShow( true )
	self.RecommendBG_Normal		:SetShow( true )
	self.RecommendBG_High		:SetShow( true )

	self.RadioBTN_AllRound		:SetShow( false )
	self.RadioBTN_Combat		:SetShow( false )
	self.RadioBTN_Product		:SetShow( false )
	self.RadioBTN_Fishing		:SetShow( false )
	self.Text_RadioBTN_Title	:SetShow( false )
	self.Text_RadioBTN_Desc		:SetShow( false )

	self.RadioBTN_None			:SetShow( false )
	self.RadioBTN_Arrow			:SetShow( false )
	self.RadioBTN_Effect		:SetShow( false )
	self.RadioBTN_Fairy			:SetShow( false )
	self.img_None				:SetShow( false )
	self.img_Arrow				:SetShow( false )
	self.img_Effect				:SetShow( false )
	self.img_Fairy				:SetShow( false )

	self.title_TexQuality		:SetShow( false )
	self.Button_TextureLow		:SetShow( false )
	self.Button_TextureNormal	:SetShow( false )
	self.Button_TextureHigh		:SetShow( false )
end
function FirstLogin:SetStep2()
	self.Step1	= false
	self.Step2	= true
	self.Step3	= false
	self.Step4	= false

	self.Text_Title	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE2") ) -- "[Step 2/2] 카메라 잔상 효과를 설정합니다."
	self.Slider_DescBG:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPDESC2") ) -- "- 화면 이동시 부드러운 시선 이동효과를 줍니다.\n- 캐릭터의 기술 및 연출 효과를 극대화 합니다.\n(효과가 너무 과하면 어지러움 및 눈에 피로를 줄 수 있습니다.)"
	-- self.BTN_Next				:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_CONFIRM") ) -- "완료"
	self.Slider_Control			:SetControlPos(50)

	self.BTN_Next				:SetShow( true )

	self.Text_Title				:SetShow( true )
	self.Slider_Desc			:SetShow( false )

	self.Slider_Control			:SetShow( true )
	self.Slider_0				:SetShow( true )
	self.Slider_50				:SetShow( true )
	self.Slider_100				:SetShow( true )
	self.Slider_DescBG			:SetShow( true )

	self.RecommendBG_Low		:SetShow( true )
	self.RecommendBG_Normal		:SetShow( true )
	self.RecommendBG_High		:SetShow( true )

	self.RadioBTN_AllRound		:SetShow( false )
	self.RadioBTN_Combat		:SetShow( false )
	self.RadioBTN_Product		:SetShow( false )
	self.RadioBTN_Fishing		:SetShow( false )
	self.Text_RadioBTN_Title	:SetShow( false )
	self.Text_RadioBTN_Desc		:SetShow( false )

	self.RadioBTN_None			:SetShow( false )
	self.RadioBTN_Arrow			:SetShow( false )
	self.RadioBTN_Effect		:SetShow( false )
	self.RadioBTN_Fairy			:SetShow( false )
	self.img_None				:SetShow( false )
	self.img_Arrow				:SetShow( false )
	self.img_Effect				:SetShow( false )
	self.img_Fairy				:SetShow( false )

	self.title_TexQuality		:SetShow( false )
	self.Button_TextureLow		:SetShow( false )
	self.Button_TextureNormal	:SetShow( false )
	self.Button_TextureHigh		:SetShow( false )
end

function FirstLogin:SetStepEnd()
	self.Step1	= false
	self.Step2	= false
	self.Step3	= false
	self.Step4	= false

	local QuestListInfo = ToClient_GetQuestList()
	QuestListInfo:setQuestSelectType(0, true) -- 0은 무조건 선택
	QuestListInfo:setQuestSelectType(1, true)
	-- 패널을 끈다.
	Panel_FirstLogin:SetShow( false, false )
	selectCharacter( FirstLogin.characterSelect )
end

function FirstLogin:SetStep3()
	self.Step1	= false
	self.Step2	= false
	self.Step3	= true
	self.Step4	= false

	self.Text_Title				:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE3") ) -- "앞으로 진행할 의뢰 종류를 선택해주세요."
	-- self.BTN_Next				:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_CONFIRM") ) -- "완료"
	self.Slider_DescBG			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEP3_DESC") )
	-- FirstLogin_FavorQuestType( -1 )
	self.RadioBTN_Arrow:SetCheck( true )

	self.BTN_Next				:SetShow( true )

	self.Text_Title				:SetShow( true )
	self.Slider_Desc			:SetShow( false )

	self.Slider_Control			:SetShow( false )
	self.Slider_0				:SetShow( false )
	self.Slider_50				:SetShow( false )
	self.Slider_100				:SetShow( false )
	self.Slider_DescBG			:SetShow( true )

	self.RecommendBG_Low		:SetShow( false )
	self.RecommendBG_Normal		:SetShow( false )
	self.RecommendBG_High		:SetShow( false )

	self.RadioBTN_AllRound		:SetShow( false )
	self.RadioBTN_Combat		:SetShow( false )
	self.RadioBTN_Product		:SetShow( false )
	self.RadioBTN_Fishing		:SetShow( false )
	self.Text_RadioBTN_Title	:SetShow( false )
	self.Text_RadioBTN_Desc		:SetShow( false )

	self.RadioBTN_None			:SetShow( true )
	self.RadioBTN_None			:SetCheck( false )
	self.RadioBTN_Arrow			:SetShow( true )
	self.RadioBTN_Arrow			:SetCheck( true )
	self.RadioBTN_Effect		:SetShow( true )
	self.RadioBTN_Effect		:SetCheck( false )
	self.RadioBTN_Fairy			:SetShow( true )
	self.RadioBTN_Fairy			:SetCheck( false )
	self.img_None				:SetShow( true )
	self.img_Arrow				:SetShow( true )
	self.img_Effect				:SetShow( true )
	self.img_Fairy				:SetShow( true )

	self.title_TexQuality		:SetShow( false )
	self.Button_TextureLow		:SetShow( false )
	self.Button_TextureNormal	:SetShow( false )
	self.Button_TextureHigh		:SetShow( false )
end

function FirstLogin:SetStep4()
	self.Step1	= false
	self.Step2	= false
	self.Step3	= false
	self.Step4	= true

	self.Text_Title				:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE4") )
	self.BTN_Next				:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_CONFIRM") ) -- "완료"
	self.Slider_DescBG			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEP4_DESC") )
	-- FirstLogin_FavorQuestType( -1 )

	self.BTN_Next				:SetShow( true )

	self.Text_Title				:SetShow( true )
	self.Slider_Desc			:SetShow( false )

	self.Slider_Control			:SetShow( false )
	self.Slider_0				:SetShow( false )
	self.Slider_50				:SetShow( false )
	self.Slider_100				:SetShow( false )
	self.Slider_DescBG			:SetShow( true )

	self.RecommendBG_Low		:SetShow( false )
	self.RecommendBG_Normal		:SetShow( false )
	self.RecommendBG_High		:SetShow( false )

	self.RadioBTN_AllRound		:SetShow( false )
	self.RadioBTN_Combat		:SetShow( false )
	self.RadioBTN_Product		:SetShow( false )
	self.RadioBTN_Fishing		:SetShow( false )
	self.Text_RadioBTN_Title	:SetShow( false )
	self.Text_RadioBTN_Desc		:SetShow( false )

	self.RadioBTN_None			:SetShow( false )
	self.RadioBTN_Arrow			:SetShow( false )
	self.RadioBTN_Effect		:SetShow( false )
	self.RadioBTN_Fairy			:SetShow( false )
	self.img_None				:SetShow( false )
	self.img_Arrow				:SetShow( false )
	self.img_Effect				:SetShow( false )
	self.img_Fairy				:SetShow( false )

	self.title_TexQuality		:SetShow( true )
	self.Button_TextureLow		:SetShow( true )
	self.Button_TextureLow		:SetCheck( false )
	self.Button_TextureNormal	:SetShow( true )
	self.Button_TextureNormal	:SetCheck( true )
	self.Button_TextureHigh		:SetShow( true )
	self.Button_TextureHigh		:SetCheck( false )
end


function FirstLogin:SetStep3End()
	self.Step1	= false
	self.Step2	= false
	self.Step3	= false
	self.Step4	= false
	
	-- 퀘스트 세팅 값을 저장한다.
	local selectType = -1
	if self.RadioBTN_AllRound:IsCheck() then
		selectType = 0
	elseif self.RadioBTN_Combat:IsCheck() then
		selectType = 1
	elseif self.RadioBTN_Product:IsCheck() then
		selectType = 2
	elseif self.RadioBTN_Fishing:IsCheck() then
		selectType = 3
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_STEPTITLE3") )
		self:SetStep3()
		return
	end
	
	QuestWidget_ShowSelectQuestFavorType(selectType)
	
	-- 패널을 끈다.
	Panel_FirstLogin:SetShow( false, false )
end


function FirstLogin_SetStepData()
	local self = FirstLogin
	local step = nil
	if true == self.Step4 then
		step = 4
	elseif true == self.Step3 then
		step = 3
	elseif true == self.Step2 then
		step = 2
	elseif true == self.Step1 then
		step = 1
	end

	local volume = FirstLogin.Slider_Control:GetControlPos()

	if 1 == step then
		setLoginOptionCameraShake( volume )
		saveGameOption(false)
		FirstLogin:SetStep2()
	elseif 2 == step then
		setLoginOptionMotionBlur( volume )
		saveGameOption(false)
		FirstLogin:SetStep3()
	elseif 3 == step then
		local isCheck = 1
		local isNoneCheck		= self.RadioBTN_None:IsCheck()
		local isArrowCheck		= self.RadioBTN_Arrow:IsCheck()
		local isEffectCheck		= self.RadioBTN_Effect:IsCheck()
		local isFairyCheck		= self.RadioBTN_Fairy:IsCheck()
		if isNoneCheck then
			isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_None
		elseif isArrowCheck then
			isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_Arrow
		elseif isEffectCheck then
			isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_PathEffect
		elseif isFairyCheck then
			isCheck = CppEnums.NavPathEffectType.eNavPathEffectType_Fairy
		end

		setLoginOptionNavPathEffectType( isCheck )
		saveGameOption( false )
		FirstLogin:SetStep4()
	elseif 4 == step then
		local isGraphicCheck	= 3
		local isLowCheck		= self.Button_TextureLow:IsCheck()
		local isNormalCheck		= self.Button_TextureNormal:IsCheck()

		local isHighCheck		= self.Button_TextureHigh:IsCheck()
		if isLowCheck then
			isGraphicCheck = 5
		elseif isNormalCheck then
			isGraphicCheck = 3
		elseif isHighCheck then
			isGraphicCheck = 0
		else
			isGraphicCheck = 3
		end

		-- setLoginOptionTextureQuality(  )
		setLoginOptionGraphicOption( isGraphicCheck )
		FirstLogin:SetStepEnd()
	end
	
	-- if 3 == step then
	-- 	FirstLogin:SetStep3End()
	-- end
end

function FirstLogin_FavorQuestType( questType )
	local self	= FirstLogin
	local title = nil
	local desc	= nil
	if 0 == questType then
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE1") -- 전체
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE1") -- - 게임에서 제공하는 모든 의뢰를 진행할 수 있습니다.\n- 매우 천천히 자신만의 이야기를 만들어 나갈 모험가에게 추천합니다.
	elseif 1 == questType then
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE2") -- 전투
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE2") -- - 스토리, 필수, 사냥 의뢰를 중심으로 게임이 진행됩니다.\n- 빠른 성장을 좋아하는 모험가에게 추천합니다.
	elseif 2 == questType then
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE3") -- 채집과 제작
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE3") -- - 스토리, 필수, 채집, 가공, 요리, 제작 의뢰를 중심으로 게임이 진행됩니다.\n- 느긋하게 생활형 컨텐츠를 즐기고자 하는 모험가에게 추천합니다.
	elseif 3 == questType then
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE4") -- 낚시
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPETITLE4") -- - 스토리, 필수, 낚시 의뢰를 중심으로 게임이 진행됩니다.\n- 낚시를 좋아하는 인내심 있는 모험가에게 추천합니다.
	else
		title	= ""
		desc	= ""
	end

	desc	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_FIRSTLOGIN_QUESTTYPE_MSG", "desc", desc )
	self.Text_RadioBTN_Title	:SetText( title )
	self.Text_RadioBTN_Desc		:SetText( desc )
end

function FGlobal_FirstLogin_Open( characterSelect )
	FirstLogin.characterSelect = characterSelect
	FirstLogin:SetStep1()
	Panel_FirstLogin:SetShow( true, true )
end

function FGlobal_FirstLogin_InGameOpen( )
	FirstLogin:SetStep3()
	Panel_FirstLogin:SetShow( true, true )
end

function FGlobal_FirstLogin_InGameClose()
	QuestWidget_ShowSelectQuestFavorType(1)
	-- 패널을 끈다.
	Panel_FirstLogin:SetShow( false, false )
end

function FirstLogin_SetCurrentGraphicOption( graphicOptionIdx )
	if graphicOptionIdx >= 0 and graphicOptionIdx < FirstLogin.GRAPHIC_OPTION_COUNT then
		FirstLogin.currentGraphicOptionIdx = graphicOptionIdx
		FirstLogin_SetGraphicOptionText( graphicOptionIdx )
	end
end

function FirstLogin_SetCurrentTexGraphicOption( graphicOptionIdx )
	if graphicOptionIdx >= 0 and graphicOptionIdx < FirstLogin.GRAPHIC_OPTION_COUNT then
		FirstLogin.currentTexGraphicOptionIdx = graphicOptionIdx
		FirstLogin_SetTexGraphicOptionText( graphicOptionIdx )
	end
end

function FirstLogin_ClickedImage( imgType )
	local self = FirstLogin
	if 0 == imgType then
		self.RadioBTN_None:SetCheck( true )
		self.RadioBTN_Arrow:SetCheck( false )
		self.RadioBTN_Effect:SetCheck( false )
		self.RadioBTN_Fairy:SetCheck( false )
	elseif 1 == imgType then
		self.RadioBTN_None:SetCheck( false )
		self.RadioBTN_Arrow:SetCheck( true )
		self.RadioBTN_Effect:SetCheck( false )
		self.RadioBTN_Fairy:SetCheck( false )
	elseif 2 == imgType then
		self.RadioBTN_None:SetCheck( false )
		self.RadioBTN_Arrow:SetCheck( false )
		self.RadioBTN_Effect:SetCheck( true )
		self.RadioBTN_Fairy:SetCheck( false )
	elseif 3 == imgType then
		self.RadioBTN_None:SetCheck( false )
		self.RadioBTN_Arrow:SetCheck( false )
		self.RadioBTN_Effect:SetCheck( false )
		self.RadioBTN_Fairy:SetCheck( true )
	end
end

function FirstLogin:registEventHandler()
	self.BTN_Next				:addInputEvent("Mouse_LUp", "FirstLogin_SetStepData()")
	self.RadioBTN_AllRound		:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 0 .. " )")
	self.RadioBTN_Combat		:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 1 .. " )")
	self.RadioBTN_Product		:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 2 .. " )")
	self.RadioBTN_Fishing		:addInputEvent("Mouse_LUp", "FirstLogin_FavorQuestType( " .. 3 .. " )")

	self.img_None				:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 0 .. ")")
	self.img_Arrow				:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 1 .. ")")
	self.img_Effect				:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 2 .. ")")
	self.img_Fairy				:addInputEvent("Mouse_LUp", "FirstLogin_ClickedImage(" .. 3 .. ")")
end

function FirstLogin:registMessageHandler()

end


FirstLogin:initialize()
FirstLogin:registEventHandler()
FirstLogin:registMessageHandler()