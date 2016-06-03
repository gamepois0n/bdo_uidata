
local UI_color 	 = Defines.Color

---------------------------
-- Panel Init
---------------------------
--local UIMode 		= Defines.UIMode
Panel_Housing:SetShow(false, false)
Panel_Housing:ActiveMouseEventEffect(true)

---------------------------
-- Local Variables
---------------------------
local IM = CppEnums.EProcessorInputMode

local housing =
{
	_btnHousingMode,
	_textHarvestTime,
	
	-- _btnObjectRotateLeft,
	-- _btnObjectRotateRight,
	
	_btnObjectMove,
	_btnObjectFix,
	_btnObjectDelete,
	_btnObjectCancel,

	_staticHelp,
	_staticBackInstallations,
	_btnCheckAll,
	_btnCheckBottom,
	_btnCheckWall,
	_btnCheckTable,
	_btnCheckTop,
	_btnCheckCurtain,
	_btnCheckWallPaper,
	_btnCheckCapet,
	_imgHelpMouse,
	_btnCheckRotate,
	_btnCameraRotateLeft,
	_btnCameraRotateRight,
	
	_btnCheckIsShowInstalledObject,
	_btnDeleteAllObject,
	
	_staticBackFloor,
	_radioBtnFirstFloor,
	_radioBtnSecondFloor,
	_radioBtnThirdFloor,
	
	_installationSlots = {},
	_installationSlotShowCount = 0,
	_maxInstallationSlotCount = 10,
	
	_installationStartIndex = 0,
	_installationSelectIndex = -1,
	_selectIndexForInstalledObjectList = -1,
	
	_textInstallationcount,
	
	_isShow = false,
	_isMyHouse = true 	-- 자신의 집 설치모드인지?, 남의 집 꾸며주기 인지?
}

local housing_ViewControlValue = {
	startMousePosX	= 0,
	startMousePosY	= 0,
	lastMousePosX	= 0,
	lastMousePosY	= 0,
}

local IM = CppEnums.EProcessorInputMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE

local ScrX = getScreenSizeX()
local ScrY = getScreenSizeY()

local CURRENT_SHOWING_INSTALLATIONLIST	= {}
local CURRENT_SHOWING_INSTALLATION_COUNT = 0

-- 설치모드가 열릴때, 텐트에서 열리는지 ,고정집에서 열리는지.. 설비도구 설치할때만 사용하세요
local CURRENT_HOUSEACTOR_IS_FIXED = false;

---------------------------
-- Functions
---------------------------
-----------------------------------------------------------------------------
-- 지역 함수
-----------------------------------------------------------------------------
function housing:Init()
	-- 하우징 모드 버튼
	housing._btnHousingMode = UI.getChildControl(Panel_Housing, "Button_Housing")
	housing._btnHousingMode:addInputEvent( "Mouse_LUp", "Event_HousingCancelInstallModeMessageBox()" )
	housing._btnHousingMode:ActiveMouseEventEffect( true )
	
	
	--housing._btnHousingMode:SetShow(false)
	housing.FixingBG =  UI.getChildControl(Panel_Housing, "Static_FixingBG")
	housing.FixingBG:SetShow( false )
	
	-- 오브젝트 회전
	housing._btnObjectRotateLeft = UI.getChildControl(Panel_Housing, "Button_ObjectRotationLeft")
	housing._btnObjectRotateLeft:addInputEvent( "Mouse_LUp", "Panel_Housing_ObjectRotation_Click(1)" )

	housing._btnObjectRotateRight = UI.getChildControl(Panel_Housing, "Button_ObjectRotationRight")
	housing._btnObjectRotateRight:addInputEvent( "Mouse_LUp", "Panel_Housing_ObjectRotation_Click(2)" )
	
	-- 오브젝트 이동
	housing._btnObjectMove = UI.getChildControl(Panel_Housing, "Button_ObjectTranslation")
	housing._btnObjectMove:addInputEvent( "Mouse_LUp", "Panel_Housing_ObjectTranslation_Click()" )

	-- 오브젝트 설치
	housing._btnObjectFix = UI.getChildControl(Panel_Housing, "Button_ObjectFixing")
	housing._btnObjectFix:addInputEvent( "Mouse_LUp", "Panel_Housing_ObjectFixing_Click()" )

	-- 오브젝트 삭제
	housing._btnObjectDelete = UI.getChildControl(Panel_Housing, "Button_ObjectDelete")
	housing._btnObjectDelete:addInputEvent( "Mouse_LUp", "Panel_Housing_ObjectDelete_Click()" )
	
	-- 오브젝트 취소
	housing._btnObjectCancel = UI.getChildControl(Panel_Housing, "Button_ObjectCancel")
	housing._btnObjectCancel:addInputEvent( "Mouse_LUp", "Panel_Housing_ObjectCancel_Click()" )
			
	-- 오른쪽 배경
	housing._staticBackInstallations =  UI.getChildControl(Panel_Housing, "Static_Installations")
	housing._staticBackInstallations:addInputEvent("Mouse_UpScroll",	"Panel_Housing_Static_Back_Installations_ScrollUp()")
	housing._staticBackInstallations:addInputEvent("Mouse_DownScroll",	"Panel_Housing_Static_Back_Installations_ScrollDown()")
	
	-- 오브젝트 감싸는 테두리
	housing._staticSlotFront =  UI.getChildControl(Panel_Housing, "Static_SlotFront")
	housing._staticSlotFront:SetShow( false )
	
	-- 오브젝트 감싸는 테두리 (금색)
	housing._staticSlotBorder =  UI.getChildControl(Panel_Housing, "Static_SlotBorder")
	housing._staticSlotBorder:SetShow( false )
	
	-- 오브젝트 감싸는 테두리 (화살표)
	housing._staticSlotArrow =  UI.getChildControl(Panel_Housing, "Static_SlotArrow")
	housing._staticSlotArrow:SetShow( false )
	
	-- 도움말
	housing._helpImage =  UI.getChildControl(Panel_Housing, "Static_helpMouse")
	housing._helpTxtMove =  UI.getChildControl(Panel_Housing, "StaticText_Help_Move")
	housing._helpTxtRotate =  UI.getChildControl(Panel_Housing, "StaticText_Help_Rot")
	housing._helpTxtZoom =  UI.getChildControl(Panel_Housing, "StaticText_Help_Zoom")
	
	housing._helpImage:SetPosX ( getScreenSizeX() / 2 - housing._helpImage:GetSizeX() / 2 - housing._staticBackInstallations:GetSizeX() / 2 )
	
	
	local _helpImgPosX = housing._helpImage:GetPosX()
	local _helpImgPosY = housing._helpImage:GetPosY()
	
	housing._helpTxtMove:SetPosX ( _helpImgPosX + 20 )
	housing._helpTxtRotate:SetPosX ( _helpImgPosX + 88 )
	housing._helpTxtZoom:SetPosX ( _helpImgPosX + 164 )
	housing._helpTxtMove:SetPosY ( _helpImgPosY + 7 )
	housing._helpTxtRotate:SetPosY ( _helpImgPosY + 7 )
	housing._helpTxtZoom:SetPosY ( _helpImgPosY + 7 )
	
	-- 오브젝트 45도씩 회전 버튼
	housing._btnCheckRotate = UI.getChildControl(Panel_Housing, "CheckButton_Rotation")
	housing._btnCheckRotate:SetPosX( (getScreenSizeX() - housing._btnCheckRotate:GetSizeX() - housing._btnCheckRotate:GetTextSizeX() - housing._staticBackInstallations:GetSizeX()) / 2 )
	housing._btnCheckRotate:SetPosY( housing._helpImage:GetPosY() + housing._helpImage:GetSizeY() + 30 )
	housing._btnCheckRotate:addInputEvent("Mouse_LUp", "Panel_Housing_CheckRotateObject_MouseLUp()" )
	
	--카메라 90도씩 회전 버튼
	housing._btnCameraRotateLeft = UI.getChildControl(Panel_Housing, "Button_CameraRotateLeft")
	housing._btnCameraRotateRight = UI.getChildControl(Panel_Housing, "Button_CameraRotateRight")
	housing._btnCameraRotateLeft:SetPosX( (getScreenSizeX() - housing._btnCheckRotate:GetSizeX() - housing._staticBackInstallations:GetSizeX()) / 2 - housing._btnCameraRotateRight:GetSizeX() )
	housing._btnCameraRotateLeft:SetPosY( housing._btnCheckRotate:GetPosY() + 30 )
	housing._btnCameraRotateRight:SetPosX( housing._btnCameraRotateLeft:GetPosX() + housing._btnCameraRotateLeft:GetSizeX() + 10 )
	housing._btnCameraRotateRight:SetPosY( housing._btnCheckRotate:GetPosY() + 30 )
	housing._btnCameraRotateLeft:addInputEvent( "Mouse_LUp", "Panel_Housing_CameraRotationLeft_Click()")
	housing._btnCameraRotateRight:addInputEvent( "Mouse_LUp", "Panel_Housing_CameraRotationRight_Click()")
	
	-- 체크버튼
	housing._btnCheckAll = UI.getChildControl(Panel_Housing, "CheckButton_All")
	housing._btnCheckAll:addInputEvent("Mouse_LUp", "Panel_Housing_CheckAll_MouseLUp()" )
	housing._btnCheckAll:SetCheck(false)
	
	housing._btnCheckBottom = UI.getChildControl(Panel_Housing, "CheckButton_Bottom")
	housing._btnCheckBottom:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckBottom_MouseLUp()")
	housing._btnCheckBottom:SetCheck(false)
	
	housing._btnCheckWall	= UI.getChildControl(Panel_Housing, "CheckButton_Wall")
	housing._btnCheckWall:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckWall_MouseLUp()")
	housing._btnCheckWall:SetCheck(false)
	
	housing._btnCheckTable	= UI.getChildControl(Panel_Housing, "CheckButton_Out")
	housing._btnCheckTable:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckOut_MouseLUp()")
	housing._btnCheckTable:SetCheck(false)
	
	housing._btnCheckTop	= UI.getChildControl(Panel_Housing, "CheckButton_Top")
	housing._btnCheckTop:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckTop_MouseLUp()")
	housing._btnCheckTop:SetCheck(false)
	
	housing._btnCheckCurtain	= UI.getChildControl(Panel_Housing, "CheckButton_Curtain")
	housing._btnCheckCurtain:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckCurtain_MouseLUp()")
	housing._btnCheckCurtain:SetCheck(false)
	
	
	housing._btnCheckWallPaper	= UI.getChildControl(Panel_Housing, "CheckButton_WallPaper")
	housing._btnCheckWallPaper:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckWallPaper_MouseLUp()")
	housing._btnCheckWallPaper:SetCheck(false)
	
	housing._btnCheckCapet	= UI.getChildControl(Panel_Housing, "CheckButton_Capet")
	housing._btnCheckCapet:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckCapet_MouseLUp()")
	housing._btnCheckCapet:SetCheck(false)
	
	-- 체크버튼 배경
	housing._staticCheckBack 	= UI.getChildControl(Panel_Housing, "Static_BackCheck" )
	housing._buttonQuestion 	= UI.getChildControl(Panel_Housing, "Button_Question" )
	housing._staticCheckBlackBG = UI.getChildControl(Panel_Housing, "Static_CheckBG" )


	-- 설치되어 있는 설비도구 리스트를 보여줄것인지 확인
	housing._btnCheckIsShowInstalledObject =  UI.getChildControl(Panel_Housing, "CheckButton_Installed" )
	housing._btnCheckIsShowInstalledObject:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckShowInstalledObject_MouseLUp()")
	housing._btnCheckIsShowInstalledObject:SetPosX( housing._staticCheckBack:GetPosX() + 30 )
	housing._btnCheckIsShowInstalledObject:SetPosY( housing._staticCheckBack:GetPosY() + housing._staticCheckBack:GetSizeY() + 105 )
	housing._btnCheckIsShowInstalledObject:SetEnableArea( 0, 0, housing._btnCheckIsShowInstalledObject:GetTextSizeX(), housing._btnCheckIsShowInstalledObject:GetSizeY() )
	
	-- 설치되어 있는 설비도구 리스트를 모두 회수
	housing._btnDeleteAllObject = UI.getChildControl(Panel_Housing, "Static_Button_DeleteAll" )
	housing._btnDeleteAllObject:addInputEvent("Mouse_LUp",	"Panel_Housing_CheckIsDeleteAllObject_MouseLUp()")
	
	-- 층 라디오 버튼
	housing._staticBackFloor = UI.getChildControl(Panel_Housing, "Static_BackFloor" )
	housing._radioBtnFirstFloor = UI.getChildControl(Panel_Housing, "RadioButton_FirstFloor" )
	housing._radioBtnFirstFloor:addInputEvent("Mouse_LUp",	"Panel_Housing_FirstFloor_MouseLUp()")
	
	housing._radioBtnSecondFloor = UI.getChildControl(Panel_Housing, "RadioButton_SecondFloor" )
	housing._radioBtnSecondFloor:addInputEvent("Mouse_LUp",	"Panel_Housing_SecondFloor_MouseLUp()")
	
	housing._radioBtnThirdFloor = UI.getChildControl(Panel_Housing, "RadioButton_ThirdFloor" )
	housing._radioBtnThirdFloor:addInputEvent("Mouse_LUp",	"Panel_Housing_ThirdFloor_MouseLUp()")
	
	local tempText = UI.getChildControl(Panel_Housing, "StaticText_Floor" )
	housing._staticBackFloor:SetChild_DoNotUseXXX(tempText)
	housing._staticBackFloor:SetChild_DoNotUseXXX(housing._radioBtnFirstFloor)
	housing._staticBackFloor:SetChild_DoNotUseXXX(housing._radioBtnSecondFloor)
	housing._staticBackFloor:SetChild_DoNotUseXXX(housing._radioBtnThirdFloor)
	housing._staticBackFloor:SetShow(false)
	
	-- text : 가방 내 설치 가능 장식물
	local sizeY = housing._btnCheckAll:GetSizeY() + housing._btnCheckBottom:GetSizeY() + housing._btnCheckWall:GetSizeY() + housing._btnCheckTable:GetSizeY() + 95  - (housing._btnCheckWallPaper:GetSizeY() * 2 + 5)
	tempText = UI.getChildControl(Panel_Housing, "StaticText_InvenInst" )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._staticCheckBlackBG )
	housing._staticCheckBack:SetChild_DoNotUseXXX( tempText )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckAll )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckWall )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckBottom )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckTable )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckTop )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckCurtain )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckWallPaper )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._btnCheckCapet )
	housing._staticCheckBack:SetChild_DoNotUseXXX( housing._buttonQuestion )
	housing._staticCheckBack:SetShow(true)
	housing._staticCheckBack:SetSize(220, sizeY)
	housing._staticCheckBack:SetPosX( ScrX - 420 )
	housing._staticCheckBack:SetPosY(0)
	
	housing._buttonQuestion:SetPosX( housing._staticCheckBack:GetSizeX() - housing._buttonQuestion:GetSizeX() - 7 )
	housing._buttonQuestion:SetPosY(6)
	housing._staticCheckBlackBG:SetSize( housing._staticCheckBack:GetSizeX() - housing._staticCheckBlackBG:GetSpanSize().x - 7, housing._staticCheckBack:GetSizeY() - housing._staticCheckBlackBG:GetSpanSize().y - 7 )
	housing._btnCheckAll:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckAll:GetSizeX() / 2 )
	housing._btnCheckBottom:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckBottom:GetSizeX() / 2 )
	housing._btnCheckWall:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckWall:GetSizeX() / 2 )
	housing._btnCheckTable:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckTable:GetSizeX() / 2 )
	housing._btnCheckTop:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckTop:GetSizeX() / 2 )
	housing._btnCheckCurtain:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckCurtain:GetSizeX() / 2 )
	housing._btnCheckWallPaper:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckWallPaper:GetSizeX() / 2 )
	housing._btnCheckCapet:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckCapet:GetSizeX() / 2 )
	tempText:SetPosX(0)
	tempText:SetPosY(5)
	tempText:SetSize( housing._staticCheckBack:GetSizeX(), 20 )
	
	-- base installationSlot
	local templateStaticBackSlot = UI.getChildControl(Panel_Housing, "Static_BackSlot")
	local templateStaticImgSlot  = UI.getChildControl(Panel_Housing, "Static_ImageSlot")
	
	local slotElapsedY = 5
			
	-- 최대 갯수를 생성하고 필요한 갯수만 사용
	for ii=0,  housing._maxInstallationSlotCount-1 do	
	
		local newSlot = {}
		
		newSlot._staticBackSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, housing._staticBackInstallations, "Static_Installation_SlotBack_"..ii)		
		CopyBaseProperty( templateStaticBackSlot , newSlot._staticBackSlot)
		newSlot._staticBackSlot:SetIgnore( true )
		
		-- 아래(5), 위(5) 간격을 더한값.
		local slotSizeY = newSlot._staticBackSlot:GetSizeY() + (slotElapsedY * 2)
	
		newSlot._staticBackSlot:SetShow(false)
		newSlot._staticBackSlot:SetPosX( 23 )
		newSlot._staticBackSlot:SetPosY( ii * slotSizeY + slotElapsedY )
	
		newSlot._staticImgSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, newSlot._staticBackSlot, "Static_Installation_SlotImg_"..ii)
		CopyBaseProperty( templateStaticImgSlot , newSlot._staticImgSlot)

		newSlot._staticImgSlot:SetPosX( 3 )
		newSlot._staticImgSlot:SetPosY( 5 )
		newSlot._staticImgSlot:SetSize( 106, 106 )
				
		newSlot._staticImgSlot:addInputEvent("Mouse_LUp",		"Panel_Housing_installationSlot_MouseLUp(" ..ii..")" )
		newSlot._staticImgSlot:ActiveMouseEventEffect(true)
		newSlot._staticImgSlot:addInputEvent("Mouse_On",		"Panel_Housing_installationSlot_MouseOver(true,"..ii.. ")" )
		newSlot._staticImgSlot:addInputEvent("Mouse_Out",		"Panel_Housing_installationSlot_MouseOver(false,"..ii.. ")" )
		newSlot._staticImgSlot:addInputEvent("Mouse_UpScroll",	"Panel_Housing_Static_Back_Installations_ScrollUp()")
		newSlot._staticImgSlot:addInputEvent("Mouse_DownScroll",	"Panel_Housing_Static_Back_Installations_ScrollDown()")
	
		newSlot.icon = newSlot._staticBackSlot
		Panel_Tooltip_Item_SetPosition( ii, newSlot, "HousingMode" )

		housing._installationSlots[ii] = newSlot
	end

	-- 설치된 개수 / 최대 설치 개수
		housing._staticTextInstalledTentCount 	= UI.getChildControl(Panel_Housing, "StaticText_InstalledCount" )
		housing._staticTextMaxTentCount		 	= UI.getChildControl(Panel_Housing, "StaticText_MaxTentCount" )
		housing._staticTextInstalledTentCount:SetShow( false )
		housing._staticTextMaxTentCount		 :SetShow( false )
end

function housing:ShowMode( isShow )
	housing._staticTextInstalledTentCount:SetShow( false )
	housing._staticTextMaxTentCount		 :SetShow( false )

	if ( isShow ) then
		housing._staticSlotFront:SetShow( false )
		housing._staticSlotBorder:SetShow( false )
		housing._staticSlotArrow:SetShow( false )
		
		housing._btnCheckAll:SetCheck(true)
		housing._btnCheckBottom:SetCheck(false)
		housing._btnCheckWall:SetCheck(false)
		housing._btnCheckTable:SetCheck(false)
		housing._btnCheckTop:SetCheck(false)
		housing._btnCheckCurtain:SetCheck(false)
		housing._btnCheckWallPaper:SetCheck(false)
		housing._btnCheckCapet:SetCheck(false)

		if( housing_isInstallMode() ) then
			local houseWrapper = housing_getHouseholdActor_CurrentPosition()
			if( nil == houseWrapper ) then
				_PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()가 nullptr 이면 안됩니다.")
				return
			end
			
			CURRENT_HOUSEACTOR_IS_FIXED = ( houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom() )

			if ( CURRENT_HOUSEACTOR_IS_FIXED ) then
				housing._staticCheckBack:SetShow( true )
				housing._btnCheckAll:SetShow( true )
				housing._btnCheckBottom:SetShow( true )
				housing._btnCheckWall:SetShow( true )
				housing._btnCheckTable:SetShow( true )
				housing._btnCheckTop:SetShow( true )
				housing._btnCheckCurtain:SetShow( true )
				housing._btnCheckWallPaper:SetShow( false )										-- 현재 구분인자가 없음. 추후 구현되면 넣어준다(벽지)
				housing._btnCheckCapet:SetShow( false )											-- 마찬가지(바닥재)
				housing._buttonQuestion:SetShow( true )
				housing._staticCheckBlackBG:SetShow( true )
				housing._btnCheckIsShowInstalledObject:SetShow( true )

				housing._staticTextInstalledTentCount:SetShow( false )
				housing._staticTextMaxTentCount		 :SetShow( false )
				housing._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowHouse\" )" )				-- 물음표 좌클릭
			else
				-- 농작물 설치 모드면 분류 창 끔
				housing._btnCheckAll:SetShow( false )
				housing._btnCheckBottom:SetShow( false )
				housing._btnCheckWall:SetShow( false )
				housing._btnCheckTable:SetShow( false )
				housing._btnCheckTop:SetShow( false )
				housing._btnCheckCurtain:SetShow( false )
				housing._btnCheckWallPaper:SetShow( false )
				housing._btnCheckCapet:SetShow( false )
				housing._buttonQuestion:SetShow( false )
				housing._staticCheckBlackBG:SetShow( false )
				housing._btnCheckIsShowInstalledObject:SetShow( false )

				housing._staticCheckBack:SetShow( false )
				housing._staticTextInstalledTentCount:SetShow( true )
				housing._staticTextMaxTentCount		 :SetShow( true )
				housing._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowTent\" )" )				-- 물음표 좌클릭
				
				housing._staticTextInstalledTentCount:SetPosX( housing._staticBackInstallations:GetPosX() - ( housing._staticTextInstalledTentCount:GetSizeX() + 15 ) )
				housing._staticTextMaxTentCount:SetPosX( housing._staticBackInstallations:GetPosX() - ( housing._staticTextMaxTentCount:GetSizeX() + 15 ) )
			end
			
			housing:ShowInstallationInven(true)
			housing:ShowFloorStatic(true)
			housing._installationStartIndex = 0	
			
			housing._selectIndexForInstalledObjectList =  -1;
			
			Panel_Housing_Update_ShowingInstallationList()
			Panel_Housing_Update_installationSlots()
			housing:updateInstallableCount()
			housing._helpImage						:SetText( PAGetString( Defines.StringSheet_RESOURCE, "HOUSING_TXT_HELPTEXT" ))
		
			housing._btnCheckRotate					:SetShow( true )
			housing._btnCheckRotate:SetCheck( housing_getRestrictedRatateObject() )
		
			housing._btnCameraRotateLeft			:SetShow( true )
			housing._btnCameraRotateRight			:SetShow( true )
		
		else
			housing:ShowFloorStatic(false)
			housing:ShowInstallationInven(false)
			housing._helpImage						:SetText( "" )
			housing._btnCheckRotate					:SetShow( false )
			housing._btnCameraRotateLeft			:SetShow( false )
			housing._btnCameraRotateRight			:SetShow( false )
			housing._btnCheckIsShowInstalledObject	:SetShow( false )
			housing._btnDeleteAllObject		:SetShow( false )
		end
		
	else
		housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
	end
	-- 사운드 추가 필요
	
	Panel_Housing:SetShow(isShow, false)
end

function housing:updateInstallableCount()
	
	if false == housing_isInstallMode() then
		return;
	end
	
	if( true == CURRENT_HOUSEACTOR_IS_FIXED ) then
		return
	end

	local houseActorWrapper = housing_getHouseholdActor_CurrentPosition()
	if( nil == houseActorWrapper ) then
		_PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()가 nullptr 이면 안됩니다.")
		return
	end

	local css = houseActorWrapper:getStaticStatusWrapper():get()
	housing._staticTextInstalledTentCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "INSTALLATION_MAX_INSTALL_COUNT", "maxInstallCount", css:getInstallationMaxCount() ) )
	housing._staticTextMaxTentCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "INSTALLATION_CURRENT_INSTALL_COUNT", "currentCount", houseActorWrapper:getInstallationCountSum() ) )

end


local housing_harvest_graph = 
{
	waterRateStatic = {};
	tempRateStatic = {};
};


function housing:ShowInstallationMenu( isShow, posX, posY, isHarvest, isShowMove, isShowFix, isShowDelete, isShowCancel )	-- 설치시 세부 메뉴
	housing.FixingBG:SetShow(false)
	housing._btnObjectMove:SetShow(false)
	housing._btnObjectFix:SetShow(false)
	
	housing._btnObjectDelete:SetShow(false)
	housing._btnObjectCancel:SetShow(false)

	
	if false == isShow then
		return
	else	
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	end	

	-- ♬ 설치모드 들어갈 때 소리
	audioPostEvent_SystemUi(12,16)

	
	if ( isHarvest ) then
		PAHousing_FarmInfo_Open(housing._staticCheckBack:GetPosX() + 10, housing._staticCheckBack:GetPosY() + housing._staticCheckBack:GetSizeY() + 100)
	else
		PAHousing_FarmInfo_Close();
	end
	
	housing.FixingBG:SetShow(isShow)
	housing._btnObjectMove:SetShow(isShowMove)
	housing._btnObjectFix:SetShow(isShowFix)
	housing._btnObjectDelete:SetShow(isShowDelete)
	housing._btnObjectCancel:SetShow(isShowCancel)	
		
	local showCount = 0	
	if ( isShowFix ) then	showCount = showCount + 1	end
	if ( isShowDelete ) then	showCount = showCount + 1	end
	if ( isShowMove ) then	showCount = showCount + 1	end
	if( isShowCancel) then showCount = showCount + 1 end
		
	local modeSequence  = housing_getInstallModeSequence()
	
	if ( 2 == modeSequence ) then	-- InstallMode_Rotation
		housing.FixingBG:SetShow(true)
		showCount = showCount + 2
	end
		
	local startPosX = posX
	if 		showCount == 1 then	startPosX = startPosX-25 
	elseif 	showCount == 2 then	startPosX = startPosX-55
	elseif 	showCount == 3 then	startPosX = startPosX-75
	elseif 	showCount == 4 then	startPosX = startPosX-100
	elseif 	showCount == 5 then	startPosX = startPosX-125
	elseif 	showCount == 6 then	startPosX = startPosX-150
	else 	tempPosX = 0 end
	
	local elapsedPos = 0
	local yPos = 0
	local menuCount = 0

	if( housing.FixingBG:GetShow() ) then
		housing.FixingBG:SetPosX(startPosX - 6)
		housing.FixingBG:SetPosY(posY - 6)
	end
	
	if( housing._btnObjectFix:GetShow() ) then
		housing._btnObjectFix:SetPosX(startPosX)
		housing._btnObjectFix:SetPosY(posY + yPos)
		yPos = yPos + 35
		menuCount = menuCount + 1
	end
	
	if( housing._btnObjectDelete:GetShow() ) then
		housing._btnObjectDelete:SetPosX(startPosX)
		housing._btnObjectDelete:SetPosY(posY + yPos)
		yPos = yPos + 35
		menuCount = menuCount + 1
	end
	
	if( housing._btnObjectMove:GetShow() ) then
		housing._btnObjectMove:SetPosX(startPosX)
		housing._btnObjectMove:SetPosY(posY + yPos)
		yPos = yPos + 35
		menuCount = menuCount + 1
	end
	
	if( housing._btnObjectCancel:GetShow() ) then
		housing._btnObjectCancel:SetPosX(startPosX)
		housing._btnObjectCancel:SetPosY(posY + yPos)
		menuCount = menuCount + 1
	end
	
	housing.FixingBG:SetSize(housing.FixingBG:GetSizeX(), (menuCount * 35) + 10)
end

function Panel_Housing_CancelModeFromKeyBinder()
	
	if housing_isInstallMode() then
		-- 선택한 오브젝트가 있을 경우
		if( housing_isTemporaryObject() )then
			Panel_Housing_CancelInstallObject_InteractionFromMessageBox()
		else
			Event_HousingCancelInstallModeMessageBox()
		end
		
	else	
		Event_HousingCancelBuildTentMessageBox()
	end
	FGlobal_AlertHouseLightingReset()

end

function housing:ShowInstallationInven( isShow )	
	housing._staticBackInstallations:SetShow( isShow )
	if not CURRENT_HOUSEACTOR_IS_FIXED then
		isShow = false
	end
	housing._staticCheckBack:SetShow( isShow )
end

function housing:ShowFloorStatic( isShow )	

	if( false == isShow ) then
		housing._staticBackFloor:SetShow(false)
		return
	end
	
	local numFloor = housing_getHouseFloorCount()
	if(  numFloor <= 1 ) then
		housing._staticBackFloor:SetShow(false)
		return 
	end
		
	housing._staticBackFloor:SetShow( true )
	
	local sizeY = 0 --65 ,90 , 115
	if(  numFloor <= 2 ) then
		housing._radioBtnFirstFloor:SetShow(true)
		housing._radioBtnSecondFloor:SetShow(true)
		housing._radioBtnThirdFloor:SetShow(false)
		sizeY = 90
	elseif( numFloor <= 3 ) then		
		housing._radioBtnFirstFloor:SetShow(true)
		housing._radioBtnSecondFloor:SetShow(true)
		housing._radioBtnThirdFloor:SetShow(true)
		sizeY = 115
	end
	
	housing._staticBackFloor:SetSize( housing._staticBackFloor:GetSizeX(), sizeY)
	
	local curFloor = housing_getHouseFloorSelfPlayerBeing()
	if(  0 == curFloor ) then
		housing._radioBtnFirstFloor:SetCheck(true)
	elseif( 1 == curFloor ) then
		housing._radioBtnSecondFloor:SetCheck(true)	
	elseif( 2 == curFloor ) then
		housing._radioBtnThirdFloor:SetCheck(true)
	end
end

-- 설치된 오브젝트 리스트를 보여준다.
function Panel_Housing_IsShow_InstalledObject()
	if housing._btnCheckIsShowInstalledObject:IsCheck() then
		housing._btnDeleteAllObject:SetShow( true )
	else
		housing._btnDeleteAllObject:SetShow( false )
	end
	return housing._btnCheckIsShowInstalledObject:IsCheck();
end

----------------------------------------------------------------------------
--  inputhandler , 전역함수a
-----------------------------------------------------------------------------
function Panel_Housing_Mode_Click()  -- 하우징 모드 버튼	

	if ( not ( IsSelfPlayerWaitAction() or IsSelfPlayerBattleWaitAction() ) ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_ONLYWAITSTENCE") ); 
		return;
	end
	
	local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	if( nil == houseWrapper ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD") );
		return;
	end
	
	local houseInstallationMode = ( houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom() )
	if ( true == houseInstallationMode ) then
		-- 하우스 설치모드 진입 시 사운드 넣으세요!!
		audioPostEvent_SystemUi(01,32)
	else
		-- 텐트(울타리, 텃밭) 설치모드 진입 시 사운드 넣으세요!!
		audioPostEvent_SystemUi(01,32)
	end

	-- togle 한다.
	if  housing._isShow == false  then
		-- 켜준다
		local rv = housing_changeHousingMode(true, housing._isMyHouse )
		--if( 0 == rv ) then
			-- Event_Housing_ShowHousingModeUI(true)
		--end
		
		FGlobal_House_InstallationMode_Open()
	else
		housing_changeHousingMode(false, housing._isMyHouse )
		-- Event_Housing_ShowHousingModeUI(false)
		FGlobal_House_InstallationMode_Close()
	end
	
	-- 텃밭 설치모드 열 때, 가이드창 오픈
	if ( false == houseInstallationMode ) then
		FGlobal_FarmGuide_Open()
	else
		FGlobal_FarmGuide_Close()
	end
end

function Panel_Housing_ObjectRotation_Click( rotateType )	-- 오브젝트 회전
	housing_rotateObject( rotateType )
end

function Panel_Housing_CameraRotationLeft_Click()			-- 카메라 회전(좌)
	local xDegree = -0.5	-- 0.5 = 90도
	local yDegree = 0;
	housing_rotateCamera( xDegree, yDegree );
end
function Panel_Housing_CameraRotationRight_Click()			-- 카메라 회전(우)
	local xDegree = 0.5;	-- 0.5 = 90도
	local yDegree = 0;
	housing_rotateCamera( xDegree, yDegree );
end

function Panel_Housing_ObjectTranslation_Click( ) -- 오브젝트 이동시키기
	
	if( housing_isInstallMode() ) then
		local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper();
		if( nil ~= characterStaticWrapper ) then
			local isHarvest = characterStaticWrapper:getObjectStaticStatus():isHarvest()
			-- ♬ 이동 하는 순간 사운드를 출력해야한다.
			
			-- _PA_LOG("lua_debug","Panel_Housing_ObjectTranslation_Click(isHarvest).. " .. tostring( isHarvest ) );
			
			if ( isHarvest == true ) then
				audioPostEvent_SystemUi(12,13)		-- 재배 이동
			else
				audioPostEvent_SystemUi(12,17)		-- 가구 이동
			end							
		end
	end
		
	housing_moveObject()
	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
end

function Panel_Housing_ObjectFixing_Click( ) -- 오브젝트 설치
    
	if( housing_isInstallMode() ) then
		local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper();
		if( nil ~= characterStaticWrapper ) then
			local isHarvest = characterStaticWrapper:getObjectStaticStatus():isHarvest()
			-- ♬ 이동 하는 순간 사운드를 출력해야한다.			
			if ( isHarvest == true ) then
				audioPostEvent_SystemUi(12,15)		-- 재배 설치
			else
				audioPostEvent_SystemUi(12,19)		-- 가구 설치
				local itemEnchantStatic = characterStaticWrapper:get():getItemEnchantStatic()
				if ( nil ~= itemEnchantStatic ) then
					local itemKey = itemEnchantStatic._key:getItemKey()
					FGlobal_MiniGame_RequestEditingHouse(itemKey)
				end	
			end						
		end
	end
	
	local installationType = CppEnums.InstallationType.TypeCount
	if( housing_isInstallMode() ) then
		-- 벽지나 바닥재 일 경우, 한번 설치하면 아이템으로 회수가 안된다는 확인창을 띄워준다.
		local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper();
		if( nil ~= characterStaticWrapper ) then
			installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
			if(( installationType == CppEnums.InstallationType.eType_WallPaper ) or ( installationType == CppEnums.InstallationType.eType_FloorMaterial ) ) then
				
				local titleString	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_TITLE_WALLPAPERDONTCANCLE")
				local contentString	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_MEMO_WALLPAPERDONTCANCLE")
				local messageboxData= { title = titleString
									, content = contentString, functionYes = Panel_Housing_FixFloorMaterial_InteractionFromMessageBox, functionCancel =   MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageboxData)
				return;
			end
		end
	else
		-- 텐트 설치 모드이고, 자신의 텐트가 다른 곳에 설치 되어있는 상황이면, 텐트가 강제 철거
		-- 된다는 확인 창을 띄워준다.
		--local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper();
		--_PA_ASSERT( nil ~= characterStaticWrapper, "비어있으면 안됩니다.")
		
		--if ( characterStaticWrapper:getObjectStaticStatus():isPersonalTent() ) then
		--	local	temporaryWrapper= getTemporaryInformationWrapper()
		--	if	(nil ~= temporaryWrapper) and temporaryWrapper:isSelfTent()	then
		--		local contentString	= PAGetString(Defines.StringSheet_GAME, "TENT_REPLACE_MESSAGEBOX_MEMO")
		--		local messageboxData= { title = PAGetString(Defines.StringSheet_GAME, "TENT_REPLACE_MESSAGEBOX_TITLE")
		--								, content = contentString, functionYes = Panel_Housing_FixTent_InteractionFromMessageBox, functionCancel =   MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		--		MessageBox.showMessageBox(messageboxData)
		--		return;
		--	end
		--end
		--여러개 띄울수 있으므로 그냥 가능하다고 처리함.
		Panel_Housing_FixTent_InteractionFromMessageBox()
	end
	
	local rv = housing_InstallObject()
	if( 0 == rv ) then
		if( housing_isInstallMode() ) then
			
			-- 설치완료
			-- installationType 사용~
		
			housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
		else
			Event_Housing_ShowHousingModeUI(false)
		end
	end
end

function Panel_Housing_FixTent_InteractionFromMessageBox()

	local rv = housing_InstallObject()
	if( 0 == rv ) then
		Event_Housing_ShowHousingModeUI(false)
	end
	
end

function Panel_Housing_FixFloorMaterial_InteractionFromMessageBox()

	local rv = housing_InstallObject()
	if( 0 == rv ) then
		if( housing_isInstallMode() ) then
			housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
		end
	end
end


function Panel_Housing_ObjectDelete_Click( ) -- 오브젝트 삭제
	local	checkEquip	= housing_isEquipObject()
	if	checkEquip	then
		local errorString = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_EQUIP_DELETE")
		Event_MessageBox_NotifyMessage(errorString)
		return
	end
	
	-- 벽지나 바닥재 일 경우, 한번 설치하면 아이템으로 회수가 안된다는 확인창을 띄워준다.		
	if( Panel_Housing_IsShow_InstalledObject()  ) then
		local houseWrapper = housing_getHouseholdActor_CurrentPosition()
		if( nil == houseWrapper ) then
			_PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()가 nullptr 이면 안됩니다.")
			return
		end
		
		local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw( housing._selectIndexForInstalledObjectList )
		local installationActorWrapper = getInstallationActor( actorKeyRaw )
		if( nil ~= installationActorWrapper ) then
			local cssWrapper = 	installationActorWrapper:getStaticStatusWrapper()
			
			local contentString = ""
			local installationType = cssWrapper:getObjectStaticStatus():getInstallationType()
			if(( installationType == CppEnums.InstallationType.eType_WallPaper ) or ( installationType == CppEnums.InstallationType.eType_FloorMaterial ) ) then
				contentString = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_DELETE_MEMO_WALLPAPERDONTCANCLE")
			else
				contentString	= PAGetString(Defines.StringSheet_GAME, "INSTALLATION_DELETE_MESSAGEBOX_MEMO")			
			end
			
			local messageboxData= { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_OBJECTDELETE")
									, content = contentString, functionYes = Panel_Housing_DeleteObject_InteractionFromMessageBox, functionCancel =   MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData)
				
		end
	else
		local contentString	= PAGetString(Defines.StringSheet_GAME, "INSTALLATION_DELETE_MESSAGEBOX_MEMO")
		local messageboxData= { title = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_DELETE_MESSAGEBOX_TITLE"), content = contentString, functionYes = Panel_Housing_DeleteObject_InteractionFromMessageBox, functionCancel =   MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		return;		
	end
		
end

function Panel_Housing_ObjectCancel_Click()
	-- 확인창을 안띄우고 그냥 원상태로 만든다. 필요에 따라 확인창 띄움
	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
	
	if( housing_isInstallMode() ) then
		
		if( housing_isTemporaryObject() ) then
			housing_CancelInstallObject()		
		end
	else 
		Event_Housing_ShowHousingModeUI(false)
		housing_CancelBuildTent()
	end
	
end

function Panel_Housing_DeleteObject_InteractionFromMessageBox( ) -- 오브젝트 회수
	
	if( housing_isInstallMode() ) then
		local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper();
		if( nil ~= characterStaticWrapper ) then
			local isHarvest = characterStaticWrapper:getObjectStaticStatus():isHarvest()
			-- ♬ 이동 하는 순간 사운드를 출력해야한다.
			
			-- _PA_LOG("lua_debug","Panel_Housing_DeleteObject_InteractionFromMessageBox(isHarvest).. " .. tostring( isHarvest ) );
			
			if ( isHarvest == true ) then
				audioPostEvent_SystemUi(12,14)		-- 재배 회수
			else
				audioPostEvent_SystemUi(12,18)		-- 가구 회수
			end							
		end
	end
		
	-- ♬ 회수 하는 순간 사운드를 출력해야한다.
	-- audioPostEvent_SystemUi(04,00)
	
	if( Panel_Housing_IsShow_InstalledObject()  ) then
		housing_deleteObject_InstalledObjectList( housing._selectIndexForInstalledObjectList )
	else
		housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
		housing_deleteObject()	
	end
	
end

function Panel_Housing_CancelBuildTent_InteractionFromMessageBox( ) -- 텐트 설치 취소
	Event_Housing_ShowHousingModeUI(false)
	housing_CancelBuildTent()	
end

function Panel_Housing_CancelInstallObject_InteractionFromMessageBox( ) -- 오브젝트 설치 취소
	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
	housing_CancelInstallObject()
end

function Panel_Housing_CancelInstallMode_InteractionFromMessageBox()
	Event_Housing_ShowHousingModeUI(false)
	housing_changeHousingMode(false)
end

function Panel_Housing_BuildTent_InteractionFromMessageBox()
	Panel_House_ObjectControl_Confirm()
end

function Panel_Housing_IsMode()
	return housing._isShow
end

function MessageBox_Housing_Default_Cancel_function()
	if( housing_isInstallMode() ) then		
		if( housing_isTemporaryObject() ) then
			housing_moveObject()
		end
	else 
		housing_moveObject()	
	end
end

----------------------------------------------------------------------------
-- 이벤트
-----------------------------------------------------------------------------

function Event_Housing_HousingMode( isShow, isMyHouse )
		
	housing._isMyHouse = isMyHouse
	
	_PA_LOG( "유흥신" , "Event_Housing_HousingMode " ..tostring(isMyHouse) );
	
	Panel_Housing_Mode_Click()
end

function Event_Housing_ShowHousingModeUI( isShow )
	
	toClient_FadeIn(0.3);
	
	if isShow == true then
		ToClient_SaveUiInfo( true )
		SetUIMode( Defines.UIMode.eUIMode_Housing )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
		UI.flushAndClearUI()
		crossHair_SetShow(false)
		setShowLine(false)
	else
		SetUIMode( Defines.UIMode.eUIMode_Default )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경	
		UI.restoreFlushedUI()	
		crossHair_SetShow(true)
		setShowLine(true)
		
		--인벤과 툴팁이 열려있는  경우 닫아준다.
		InventoryWindow_Close()
		HandleClicked_HouseInstallation_Exit_DO()
	end
	
	housing:ShowMode( isShow )
	housing._isShow = isShow
end

function Event_Housing_ShowShowInstallationMenu( installMode, isShow, isShowMove, isShowFix, isShowDelete , isShowCancel)
	local posX = housing_getInstallationMenuPosX()
	local posY = housing_getInstallationMenuPosY()
	local isHarvest = housing_hasInstallationMenuHarvestTime()
		-- _PA_LOG("LUA", "내려놨나?")
	
	housing:ShowInstallationMenu( isShow, posX, posY, isHarvest, isShowMove, isShowFix, isShowDelete, isShowCancel )
end

function Event_HousingCancelBuildTentMessageBox()
	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
	local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "TENT_BUILD_CANCEL_MESSAGEBOX_MEMO")
	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "TENT_BUILD_CANCEL_MESSAGEBOX_TITLE"), content = messageBoxMemo, functionYes = Panel_Housing_CancelBuildTent_InteractionFromMessageBox, functionCancel = MessageBox_Housing_Default_Cancel_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	local isExist = MessageBox.doHaveMessageBoxData( messageboxData.title )
	
	-- _PA_LOG( "lua_debug", "Event_HousingCancelBuildTentMessageBox : " ..tostring(isExist) )
	
	if( false == isExist ) then
		MessageBox.showMessageBox(messageboxData)	
	else
	--	messageBox_YesButtonUp()	
	end
end

function Event_HousingCancelInstallObjectMessageBox()
	
	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
	
	--[[
	local messageBoxMemo = "설비도구의 설치를 취소하시겠습니까?"
	local messageboxData = { title = "설비도구 취소", content = messageBoxMemo, functionYes = Panel_Housing_CancelInstallObject_InteractionFromMessageBox, functionCancel = MessageBox_Housing_Default_Cancel_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}

	local isExist = MessageBox.doHaveMessageBoxData( messageboxData.title )
	if( false == isExist ) then
		MessageBox.showMessageBox(messageboxData)	
	end
	]]--
end

function Event_HousingBuildTentMessageBox()
	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)
	local messageBoxMemo= PAGetString(Defines.StringSheet_GAME, "TENT_BUILD_MESSAGEBOX_MEMO")
	local messageboxData= { title = PAGetString(Defines.StringSheet_GAME, "TENT_BUILD_MESSAGEBOX_TITLE"), content = messageBoxMemo, functionYes = Panel_Housing_BuildTent_InteractionFromMessageBox, functionCancel = MessageBox_Housing_Default_Cancel_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	
	local isExist = MessageBox.doHaveMessageBoxData( messageboxData.title )
	if( false == isExist ) then
		MessageBox.showMessageBox(messageboxData)	
	end
end

function Event_HousingCancelInstallModeMessageBox()
	-- ♬ 나가기 버튼 눌렀을때 사운드
	audioPostEvent_SystemUi(01,33)
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)

	housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)

	local messageBoxMemo= PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_MEMO")
	local messageboxData= { title = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_TITLE"), content = messageBoxMemo, functionYes = Panel_Housing_CancelInstallMode_InteractionFromMessageBox, functionCancel = MessageBox_Housing_Default_Cancel_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	
	local isExist = MessageBox.doHaveMessageBoxData( messageboxData.title )
	if( false == isExist ) then
		MessageBox.showMessageBox(messageboxData)	
	end
end

function Event_Housing_UpdateInstallationEquip()
--
end

function Event_Housing_UpdateInstallationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )
	
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
end

function Event_Housing_UpdateInstallationActor( isAdd )
	housing:updateInstallableCount()
end

----------------------------------------------------------------------
----------------------------------------------------------------------
--	하우징 모드 리뉴얼관련 추가 스크립트
----------------------------------------------------------------------
----------------------------------------------------------------------
function Event_HousingOnScreenResize()
	local sizeX = getScreenSizeX()
	local sizeY = getScreenSizeY()
	
	Panel_Housing:SetSize( sizeX, sizeY )
	
	housing._btnHousingMode:ComputePos()
	
	-- housing._btnObjectRotateLeft:ComputePos()
	-- housing._btnObjectRotateRight:ComputePos()
	
	housing._btnObjectMove:ComputePos()
	housing._btnObjectFix:ComputePos()
	housing._btnObjectDelete:ComputePos()
	housing._btnObjectCancel:ComputePos()

	-- 화면 중앙 상단의 하우스 설치 도움말의 위치 초기화
	housing._helpImage:SetPosX ( getScreenSizeX() / 2 - housing._helpImage:GetSizeX() / 2 - housing._staticBackInstallations:GetSizeX() / 2 )	
	housing._btnCheckIsShowInstalledObject:SetPosX( housing._staticCheckBack:GetPosX() + 30 )
	housing._btnCheckIsShowInstalledObject:SetPosY( housing._staticCheckBack:GetPosY() + housing._staticCheckBack:GetSizeY() + 105 )
	housing._btnDeleteAllObject:SetPosX( housing._btnCheckIsShowInstalledObject:GetPosX() )
	housing._btnDeleteAllObject:SetPosY( housing._btnCheckIsShowInstalledObject:GetPosY() + 20 )
	housing._helpTxtMove:SetPosX ( housing._helpImage:GetPosX() + 20 )
	housing._helpTxtRotate:SetPosX ( housing._helpImage:GetPosX() + 88 )
	housing._helpTxtZoom:SetPosX ( housing._helpImage:GetPosX() + 164 )
	housing._helpTxtMove:SetPosY ( housing._helpImage:GetPosY() + 7 )
	housing._helpTxtRotate:SetPosY ( housing._helpImage:GetPosY() + 7 )
	housing._helpTxtZoom:SetPosY ( housing._helpImage:GetPosY() + 7 )
			
	local templateStaticBackSlot = UI.getChildControl(Panel_Housing, "Static_BackSlot")
	
	local slotSizeY = templateStaticBackSlot:GetSizeY() + 10					
	local slotCount = math.floor( sizeY / slotSizeY )
	
	--_PA_LOG( "Lua Debug", "Event_HousingOnScreenResize " ..slotCount.." "..slotSizeY.." "..sizeY )
		
	--if( housing._installationSlotShowCount == slotCount ) then
	--	return
	--end
	
	-- 혹시 화면안에 들어가는 슬롯수가 생성해놓은 슬롯 보다 많으면.. 생성한 슬롯만 보여준다. 추가생성은 우선 안함
	if( housing._maxInstallationSlotCount < slotCount ) then
		housing._installationSlotShowCount = housing._maxInstallationSlotCount
	else
		housing._installationSlotShowCount = slotCount
	end
	
	housing._staticBackInstallations:SetSize( housing._staticBackInstallations:GetSizeX(), sizeY - 25 )
	housing._staticBackInstallations:ComputePos()
	-- housing._staticCheckBack:ComputePos()
	
	local slotPosX = housing._staticBackInstallations:GetPosX() + 23
	
	local slotStartPosY = (sizeY - (slotSizeY * slotCount)) / 2

	for ii=0, housing._maxInstallationSlotCount-1 do	
		local slot = housing._installationSlots[ii]
		
		local tempY = ( slotSizeY * ii ) + slotStartPosY
		slot._staticBackSlot:SetPosY( tempY - 10 )
		
		if( ii <= housing._installationSlotShowCount-1 ) then
			slot._staticBackSlot:SetShow(true)
		else
			slot._staticBackSlot:SetShow(false)
		end
	end
	
	local panelSize = housing._btnCheckAll:GetSizeY() + housing._btnCheckBottom:GetSizeY() + housing._btnCheckWall:GetSizeY() + housing._btnCheckTable:GetSizeY() + housing._btnCheckTop:GetSizeY() + housing._btnCheckWallPaper:GetSizeY() + housing._btnCheckWallPaper:GetSizeY() + housing._btnCheckCapet:GetSizeY() + 65 - (housing._btnCheckWallPaper:GetSizeY() * 2 + 5)
	housing._staticCheckBack:SetShow(true)
	housing._staticCheckBack:SetSize(220, panelSize)
	housing._staticCheckBack:SetPosX( sizeX - 420 )
	housing._staticCheckBack:SetPosY(0)

	housing._staticCheckBlackBG:SetSize( housing._staticCheckBack:GetSizeX() - housing._staticCheckBlackBG:GetSpanSize().x - 7, housing._staticCheckBack:GetSizeY() - housing._staticCheckBlackBG:GetSpanSize().y - 7 )
	housing._btnCheckAll:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckAll:GetSizeX() / 2 )
	housing._btnCheckBottom:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckBottom:GetSizeX() / 2 )
	housing._btnCheckWall:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckWall:GetSizeX() / 2 )
	housing._btnCheckTable:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckTable:GetSizeX() / 2 )
	housing._btnCheckTop:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckTop:GetSizeX() / 2 )
	housing._btnCheckCurtain:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckCurtain:GetSizeX() / 2 )
	housing._btnCheckWallPaper:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckWallPaper:GetSizeX() / 2 )
	housing._btnCheckCapet:SetPosX( housing._staticCheckBack:GetSizeX() / 2 - housing._btnCheckCapet:GetSizeX() / 2 )
	
	--[[
	tempText = UI.getChildControl(Panel_Housing, "StaticText_InvenInst" )
	if tempText ~= nil then
		tempText:SetPosX(0)
		tempText:SetPosY(5)
		tempText:SetSize( housing._staticCheckBack:GetSizeX(), 20 )
	end
	]]--
	
	housing._staticTextInstalledTentCount:ComputePos()
	housing._staticTextInstalledTentCount:SetPosX( sizeX - 380 )
	housing._staticTextMaxTentCount:ComputePos()
	housing._staticTextMaxTentCount:SetPosX( sizeX - 380 )
end

function Panel_Housing_Update_ShowingInstallationList()
	
	local isCheckFloor = housing._btnCheckBottom:IsCheck()
	local isCheckWall = housing._btnCheckWall:IsCheck()
	local isCheckTable = housing._btnCheckTable:IsCheck()
	local isCheckTop = housing._btnCheckTop:IsCheck()
	local isCheckCurtain = housing._btnCheckCurtain:IsCheck()
	local isCheckWallPaper = housing._btnCheckWallPaper:IsCheck()
	local isCheckCapet = housing._btnCheckCapet:IsCheck()
	local isAll =  (not isCheckFloor) and ( not isCheckWall ) and ( not isCheckTable ) and ( not isCheckTop ) and ( not isCheckCurtain ) and ( not isCheckWallPaper ) and ( not isCheckCapet ) and housing._btnCheckAll:IsCheck()
	
	if ( isCheckFloor ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	elseif ( isCheckWall ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	elseif ( isCheckTable ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	elseif ( isCheckTop ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	elseif ( isCheckCurtain ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	elseif ( isCheckWallPaper ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	elseif ( isCheckCapet ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FFFFFFFF )
	elseif ( isAll ) then
		housing._btnCheckBottom:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWall:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckTable:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckAll:SetFontColor( UI_color.C_FFFFFFFF )
		housing._btnCheckTop:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCurtain:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckWallPaper:SetFontColor( UI_color.C_FF888888 )
		housing._btnCheckCapet:SetFontColor( UI_color.C_FF888888 )
	end
	
	local isShowInstalledObject = Panel_Housing_IsShow_InstalledObject();
	if( isShowInstalledObject ) then
		-- 설치 되어 있는 설비도구의 리스트를 보여준다.
		Panel_Housing_Update_ShowingInstallationList_Sub_2()
	else
		-- 설치할 수 있는 아이템 리스트를 보여준다.
		Panel_Housing_Update_ShowingInstallationList_Sub_1()
	end
	
end

-- 인벤에 있는 아이템들을 보여준다.
function Panel_Housing_Update_ShowingInstallationList_Sub_1()
	
	local isCheckFloor = housing._btnCheckBottom:IsCheck()
	local isCheckWall = housing._btnCheckWall:IsCheck()
	local isCheckTable = housing._btnCheckTable:IsCheck()
	local isCheckTop = housing._btnCheckTop:IsCheck()
	local isCheckCurtain = housing._btnCheckCurtain:IsCheck()
	local isCheckWallPaper = housing._btnCheckWallPaper:IsCheck()
	local isCheckCapet = housing._btnCheckCapet:IsCheck()
	local isAll =  (not isCheckFloor) and ( not isCheckWall ) and ( not isCheckTable ) and ( not isCheckTop ) and ( not isCheckWallPaper ) and ( not isCheckCapet ) and housing._btnCheckAll:IsCheck()

	
	--local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	--houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():checkInstallableForHouse(instalaltionType)
	
	CURRENT_SHOWING_INSTALLATIONLIST = nil
	CURRENT_SHOWING_INSTALLATIONLIST = {}	
	
	local inventory = getSelfPlayer():get():getInventory()
	local invenSize = inventory:size()
	local loop = invenSize - 1

	local count = 0
	for ii=0 , loop do
		local itemWrapper = getInventoryItem( ii )
		if( nil ~= itemWrapper ) then
			if( itemWrapper:getStaticStatus():get():isItemInstallation() ) then
						
				local isFloor 	= ( isCheckFloor and itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus():isInstallableOnFloor() )
				local isWall	= ( isCheckWall and itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus():isInstallableOnWall() )
				local isTable	= ( isCheckTable and  itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus():isInstallableOnTheTable() )
				
				-- 현재 설치모드가 고정집에서 하는것일때, 작물을 뺀다,
				-- 현재 설치모드가 텐트일때 작물만 넣는다.
				local isAdd = true;
				local objectSSW = itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus()
				if( CURRENT_HOUSEACTOR_IS_FIXED ) then
					isAdd =  (false == objectSSW:isHarvest() )
							and ( CppEnums.InstallationType.eType_Scarecrow ~= objectSSW:getInstallationType() )
							and ( CppEnums.InstallationType.eType_Waterway ~= objectSSW:getInstallationType() )
				else
					isAdd = ( true == objectSSW:isHarvest() )
							or ( CppEnums.InstallationType.eType_Scarecrow == objectSSW:getInstallationType() )
							or ( CppEnums.InstallationType.eType_Waterway == objectSSW:getInstallationType() )
				end

				if isAdd then
					if( isAll or isFloor or isWall or isTable  ) then
						local tempItem = {}
						tempItem._slotNo = ii
						tempItem._name	= tostring(itemWrapper:getStaticStatus():getName() )
						tempItem._imgPath = tostring(itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus():getHouseScreenShotPath(0) )
								
						CURRENT_SHOWING_INSTALLATIONLIST[count] = tempItem
						count = count + 1
					end				
				end
			end
		end
	end		
	
	CURRENT_SHOWING_INSTALLATION_COUNT = count

end

-- 설치 되어 있는 설비도구의 리스트를 보여준다.
function Panel_Housing_Update_ShowingInstallationList_Sub_2()
	
	local isCheckFloor = housing._btnCheckBottom:IsCheck()
	local isCheckWall = housing._btnCheckWall:IsCheck()
	local isCheckTable = housing._btnCheckTable:IsCheck()
	local isCheckTop = housing._btnCheckTop:IsCheck()
	local isCheckCurtain = housing._btnCheckCurtain:IsCheck()
	local isCheckWallPaper = housing._btnCheckWallPaper:IsCheck()
	local isCheckCapet = housing._btnCheckCapet:IsCheck()
	local isAll =  (not isCheckFloor) and ( not isCheckWall ) and ( not isCheckTable ) and ( not isCheckTop ) and ( not isCheckCurtain ) and ( not isCheckWallPaper ) and ( not isCheckCapet ) and housing._btnCheckAll:IsCheck()
	
	
	CURRENT_SHOWING_INSTALLATIONLIST = nil
	CURRENT_SHOWING_INSTALLATIONLIST = {}	
		
	local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	if( nil == houseWrapper ) then
		_PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()가 nullptr 이면 안됩니다.")
		return
	end
	
	local loop = houseWrapper:getInstallationCount();	
	
	-- _PA_LOG( "luadebug" , "Panel_Housing_Update_ShowingInstallationList_Sub_2 count (  " .. tostring(loop).. ")" );
	
	local count = 0
	for ii=0 , loop do
		local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw(ii)
		local installationActorWrapper = getInstallationActor( actorKeyRaw )
		if( nil ~= installationActorWrapper ) then
						
			local cssWrapper = 	installationActorWrapper:getStaticStatusWrapper()
					
			local isFloor 	= ( isCheckFloor and cssWrapper:getObjectStaticStatus():isInstallableOnFloor() )
			local isWall	= ( isCheckWall and cssWrapper:getObjectStaticStatus():isInstallableOnWall() )
			local isTable	= ( isCheckTable and  cssWrapper:getObjectStaticStatus():isInstallableOnTheTable() )
		
			-- 현재 설치모드가 고정집에서 하는것일때, 작물을 뺀다,
			-- 현재 설치모드가 텐트일때 작물만 넣는다.
			local isAdd = false;
			if( CURRENT_HOUSEACTOR_IS_FIXED ) then
				isAdd =  (false == cssWrapper:getObjectStaticStatus():isHarvest() )
			else
				isAdd = ( true  == cssWrapper:getObjectStaticStatus():isHarvest() )
			end
		
			if isAdd then
				if( isAll or isFloor or isWall or isTable  ) then			
					local tempItem = {}
					tempItem._slotNo = CppEnums.TInventorySlotNoUndefined
					tempItem._name	= tostring(cssWrapper:getName() )
					tempItem._imgPath = tostring(cssWrapper:getObjectStaticStatus():getHouseScreenShotPath(0) )
							
					CURRENT_SHOWING_INSTALLATIONLIST[count] = tempItem
					count = count + 1
				end				
			end
			
		end
	end		
	
	CURRENT_SHOWING_INSTALLATION_COUNT = count

end


function Panel_Housing_Update_installationSlots()

	if( false == housing_isInstallMode() ) then
		return
	end		
	
	for idx = 0, housing._installationSlotShowCount-1 do
		local slot = housing._installationSlots[idx]
		slot._staticImgSlot:SetShow( false )
		slot._invenSlotNo = nil
	end
		
	local slotIndex = 0
	for start = 0, housing._installationSlotShowCount-1 do
		local slot = housing._installationSlots[slotIndex]
		
		if nil == slot then
			--_PA_LOG( "Lua_Debug", "start : " ..start.."slotIndex : "..slotIndex )						
		else			
			local itemIndex = housing._installationStartIndex + start	
			local installationItem =  CURRENT_SHOWING_INSTALLATIONLIST[itemIndex] 
					
			if( nil ~= installationItem ) then			
				if( nil ~= installationItem._imgPath ) then
					--_PA_LOG( "Lua_Debug", "name: " ..installationItem._name.."img: "..installationItem._imgPath )
					if( 0 < string.len(installationItem._imgPath) ) then
						slot._staticImgSlot:ChangeTextureInfoName( installationItem._imgPath )
					else
						slot._staticImgSlot:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Housing/Object_NoImage.dds" )
					end	
				end
				
				slot._staticImgSlot:SetShow(true)
				slot._invenSlotNo = installationItem._slotNo
				slot._name = installationItem._name	
				
				slotIndex = slotIndex + 1		
			end
			
		end
		
	end
end

function Panel_Housing_installationSlot_MouseLUp( index )
	local slot = housing._installationSlots[index]
	local iconPosX = slot._staticImgSlot:GetPosX() + slot._staticBackSlot:GetPosX() + housing._staticBackInstallations:GetPosX() - 5
	local iconPosY = slot._staticImgSlot:GetPosY() + slot._staticBackSlot:GetPosY() + housing._staticBackInstallations:GetPosY() - 5
	
	-- local itemSSW = nil
	-- local itemWrapper = nil
	-- local item = nil
	
	-- itemSSW = itemWrapper:getStaticStatus()
	-- item = itemWrapper:get()

	-- ♬ 오브젝트를 선택했을 때 나오는 사운드
	audioPostEvent_SystemUi(00,00)
	
	if( nil ~= slot ) then
	
		if( slot._staticImgSlot:GetShow() ) then
			-- 선택된 놈 파란색
			housing._staticSlotFront:SetShow( true )
			housing._staticSlotFront:ResetVertexAni()
			housing._staticSlotFront:SetVertexAniRun( "Ani_Color_CursorAni", true )
			housing._staticSlotFront:SetPosX( iconPosX )
			housing._staticSlotFront:SetPosY( iconPosY )
			
			-- 선택된 놈 금색
			housing._staticSlotBorder:SetShow( true )
			housing._staticSlotBorder:ResetVertexAni()
			housing._staticSlotBorder:SetVertexAniRun( "Ani_Color_BorderAni", true )
			housing._staticSlotBorder:SetPosX( iconPosX - 21 )
			housing._staticSlotBorder:SetPosY( iconPosY - 21 )
			
			-- 선택된 놈 금색 화살표
			-- housing._staticSlotArrow:SetShow( true )
			-- housing._staticSlotArrow:ResetVertexAni()
			-- housing._staticSlotArrow:SetVertexAniRun( "Ani_Color_ArrowAni", true )
			-- housing._staticSlotArrow:SetPosX( iconPosX - 60 )
			-- housing._staticSlotArrow:SetPosY( iconPosY + 50 )
			-- housing._staticSlotArrow:SetText( slot._name )
		end
	
		if( Panel_Housing_IsShow_InstalledObject() ) then
			-- 설치된 리스트를 보여줄 경우 삭제한다.
			housing._selectIndexForInstalledObjectList =  housing._installationStartIndex + index
			Panel_Housing_ObjectDelete_Click()
		else
			if( nil ~= slot._invenSlotNo ) then
				-- 농작물 설치 모드 일 때, 설치 개수를 카운트하고 초과하지 않도록 조절한다.
				if CURRENT_HOUSEACTOR_IS_FIXED then
					housing_selectInstallationItem( 0, slot._invenSlotNo )
				else
					local houseActorWrapper = housing_getHouseholdActor_CurrentPosition()
					local css = houseActorWrapper:getStaticStatusWrapper():get()
					local max = css:getInstallationMaxCount()
					local now = houseActorWrapper:get():getInstallationCount()
					if now < max then
						housing_selectInstallationItem(  0 , slot._invenSlotNo )
					else
						Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_NOMOREHARVEST") )
					end
				end
			end
		end
	
	end
end

function Panel_Housing_Static_Back_Installations_ScrollUp()
			
	local installationCount = CURRENT_SHOWING_INSTALLATION_COUNT
	
	if(  installationCount <= housing._installationSlotShowCount ) then
		return
	end
	
	housing._installationStartIndex = housing._installationStartIndex - 1
	if( housing._installationStartIndex < 0 ) then
		housing._installationStartIndex = 0
	end
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )
	housing_CancelInstallObject()
	
	--Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
end


function Panel_Housing_Static_Back_Installations_ScrollDown()
		
	local installationCount = CURRENT_SHOWING_INSTALLATION_COUNT

	if(  installationCount <= housing._installationSlotShowCount ) then
		return
	end
	
	housing._installationStartIndex = housing._installationStartIndex + 1
	
	local lastIndex = housing._installationStartIndex + housing._installationSlotShowCount
	
	if(  installationCount < lastIndex ) then
		housing._installationStartIndex = installationCount - housing._installationSlotShowCount
	end
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )
	housing_CancelInstallObject()
	
	--Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()

end

-------------------------------------------------------------
--				45도씩 오브젝트 돌리는 체크 버튼 이벤트
function Panel_Housing_CheckRotateObject_MouseLUp()

	local isCheck = housing._btnCheckRotate:IsCheck();
	housing_setRestrictedRatateObject( isCheck );
	
end

-------------------------------------------------------------
--				전체보기 버튼 클릭 이벤트
function Panel_Housing_CheckAll_MouseLUp()

	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
end
-------------------------------------------------------------
--				바닥설치물 버튼 클릭 이벤트
function Panel_Housing_CheckBottom_MouseLUp()

	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
end
-------------------------------------------------------------
--				벽 설치물 버튼 클릭 이벤트
function Panel_Housing_CheckWall_MouseLUp()

	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
end
-------------------------------------------------------------
--				테이블 버튼 클릭 이벤트
function Panel_Housing_CheckOut_MouseLUp()
	
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
	
end
-------------------------------------------------------------
--				천장 버튼 클릭 이벤트
function Panel_Housing_CheckTop_MouseLUp()
	
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
	
end
-------------------------------------------------------------
--				벽지 버튼 클릭 이벤트
function Panel_Housing_CheckCurtain_MouseLUp()
	
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
	
end
-------------------------------------------------------------
--				벽지 버튼 클릭 이벤트
function Panel_Housing_CheckWallPaper_MouseLUp()
	
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
	
end
-------------------------------------------------------------
--				카페트 버튼 클릭 이벤트
function Panel_Housing_CheckCapet_MouseLUp()
	
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
	housing._staticSlotFront:SetShow( false )
	housing._staticSlotBorder:SetShow( false )
	housing._staticSlotArrow:SetShow( false )

	if( housing_isInstallMode() ) then
		housing_CancelInstallObject()
	end
	
end
------------------------------------------------------------------
--
function Panel_Housing_CheckShowInstalledObject_MouseLUp()
	if housing_isInstallMode() then
		-- 선택한 오브젝트가 있을 경우
		if( housing_isTemporaryObject() )then
			Panel_Housing_CancelInstallObject_InteractionFromMessageBox()
		else
		
		end
	end
		
	Panel_Housing_Update_ShowingInstallationList()
	Panel_Housing_Update_installationSlots()
	
end

--설치 목록에 나오는 설치물 모두 회수
function Panel_Housing_CheckIsDeleteAllObject_MouseLUp()
	local houseWrapper = housing_getHouseholdActor_CurrentPosition()
	if ( nil == houseWrapper ) then return end
	local installedCount = houseWrapper:getInstallationCount()								-- 설치물 개수
	local freeInventorySlot = getSelfPlayer():get():getInventory():getFreeCount()			-- 인벤 남은 슬롯

	local installed_Delete_All = function()
		for i = 0, installedCount -1 do
			local slot = housing._installationSlots[i]
			if (nil ~= slot ) then
				if ( Panel_Housing_IsShow_InstalledObject() ) then
					housing._selectIndexForInstalledObjectList = housing._installationStartIndex + i
					housing_deleteObject_InstalledObjectList( housing._selectIndexForInstalledObjectList )
				end
			end
		end
	end

	local titleString = PAGetString( Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_1")
	local msgContent = ""
	if ( 0 == installedCount ) then
		msgContent = PAGetString( Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_2")
		local messageboxData = { title = titleString, content = msgContent, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData)
		return
	elseif ( 0 == freeInventorySlot ) then
		msgContent = PAGetString( Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_3")
		local messageboxData = { title = titleString, content = msgContent, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData)
		return
	elseif ( freeInventorySlot < installedCount ) then
		msgContent = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_4", "InstalledCount", installedCount, "FreeInventorySlot", freeInventorySlot)
	else
		msgContent = installedCount .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_5")
	end
	
	local messageboxData = { title = titleString, content = msgContent, functionYes = installed_Delete_All, functionCancel =   MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)

end

function Panel_Housing_FirstFloor_MouseLUp()
	housing_selectHouseFloor( 0 ) -- 1층
end

function Panel_Housing_SecondFloor_MouseLUp()
	housing_selectHouseFloor( 1 ) -- 2층
end

function Panel_Housing_ThirdFloor_MouseLUp()
	housing_selectHouseFloor( 2 ) -- 3층
end

-- 마우스를 올렸을 때
function Panel_Housing_installationSlot_MouseOver( isOn, index )
	-- ♬ 오브젝트를 선택했을 때 나오는 사운드
	audioPostEvent_SystemUi(00,04)
	
	if ( nil == housing._installationSlots[index] ) then
		return
	end

	if( Panel_Housing_IsShow_InstalledObject() ) then

	else
		local slot = housing._installationSlots[index]
		Panel_Tooltip_Item_Show_GeneralNormal( index, "HousingMode", isOn)
	end
	
end

function Panel_Housing_SlotNo( index )
	if ( nil == housing._installationSlots[index] ) then
		return -1
	end

	local slot = housing._installationSlots[index]
	return slot._invenSlotNo
end

function Panel_Housing_UpdateObject_bySelectIndex()

	local index = housing._installationSelectIndex
	
	if( nil == housing._installationSlots[index] ) then
		housing._staticSlotFront:SetShow( false )
		housing._staticSlotBorder:SetShow( false )
		housing._staticSlotArrow:SetShow( false )
		return
	end
	
	local slot = housing._installationSlots[index]
	housing._staticSlotArrow:SetText( slot._name )
	housing_selectInstallationItem( 0, slot._invenSlotNo )
end

function FromClient_ChangeCurrentHousehold()
	if ( false == Panel_House_InstallationMode:IsShow() ) then
		return
	end
	Event_Housing_ShowHousingModeUI(false)
	housing_changeHousingMode(false)
end

registerEvent("EventHousingHousingMode", 						"Event_Housing_HousingMode" )
-- registerEvent("EventHousingShowHousingModeUI", 					"Event_Housing_ShowHousingModeUI" )
registerEvent("EventHousingShowInstallationMenu", 				"Event_Housing_ShowShowInstallationMenu" )
registerEvent("onScreenResize", 								"Event_HousingOnScreenResize" )
registerEvent("EventHousingCancelBuildTentMessageBox", 			"Event_HousingCancelBuildTentMessageBox" )
registerEvent("EventHousingCancelInstallObjectMessageBox", 		"Event_HousingCancelInstallObjectMessageBox" )
registerEvent("EventHousingBuildTentMessageBox", 				"Event_HousingBuildTentMessageBox" )
-- registerEvent("EventHousingCancelInstallModeMessageBox", 		"Event_HousingCancelInstallModeMessageBox" )
registerEvent("EventHousingInstallationEquip", 					"Event_Housing_UpdateInstallationEquip" )
-- registerEvent("EventHousingUpdateInstallationInven", 			"Event_Housing_UpdateInstallationSlots" )
registerEvent("EventUpdateInstallationActor", 					"Event_Housing_UpdateInstallationActor" )
registerEvent("FromClient_SetSelfTent", 					    "Event_Housing_UpdateInstallationActor" )
registerEvent("FromClient_ChangeCurrentHousehold",				"FromClient_ChangeCurrentHousehold" )

-- 초기화 함수 호출
housing:Init()
housing:ShowMode( false )
housing:ShowInstallationMenu(false, 0, 0, false, false, false, false, false)

