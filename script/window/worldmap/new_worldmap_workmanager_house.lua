local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 			= Defines.Color
local UI_PSFT 			= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_TM 			= CppEnums.TextMode
local VCK 				= CppEnums.VirtualKeyCode

Panel_RentHouse_WorkManager:setMaskingChild(true)
Panel_RentHouse_WorkManager:setGlassBackground(true)
Panel_RentHouse_WorkManager:TEMP_UseUpdateListSwap(true)
Panel_RentHouse_WorkManager:ActiveMouseEventEffect( true )

Panel_Select_Inherit:setMaskingChild(true)
Panel_Select_Inherit:setGlassBackground(true)
Panel_Select_Inherit:TEMP_UseUpdateListSwap(true)
Panel_Select_Inherit:ActiveMouseEventEffect( true )

Panel_RentHouse_WorkManager:RegisterShowEventFunc( true, 'Panel_RentHouse_WorkManager_ShowAni()' )
Panel_RentHouse_WorkManager:RegisterShowEventFunc( false, 'Panel_RentHouse_WorkManager_HideAni()' )



function Panel_RentHouse_WorkManager_ShowAni()
	local aniInfo1 = Panel_RentHouse_WorkManager:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.05)
	aniInfo1.AxisX = Panel_RentHouse_WorkManager:GetSizeX() / 2
	aniInfo1.AxisY = Panel_RentHouse_WorkManager:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_RentHouse_WorkManager:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.05)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_RentHouse_WorkManager:GetSizeX() / 2
	aniInfo2.AxisY = Panel_RentHouse_WorkManager:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_RentHouse_WorkManager_HideAni()
	Panel_RentHouse_WorkManager:SetShowWithFade( UI_PSFT.PAUI_ANI_TYPE_FADE_OUT )
	local aniInfo1 = Panel_RentHouse_WorkManager:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local houseInfoSS 			= nil
local houseKey 				= nil
local param 				= nil
local _affiliatedTownKey	= 0
local prevGetWearHouseKey	= nil

-----------------------------------------------------
-- 최초 'defalut_Control' Setting 관련 함수
-----------------------------------------------------

local defalut_Control =
{
	_title						= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Title" ),
	_btn_Close					= UI.getChildControl( Panel_RentHouse_WorkManager, "Button_Win_Close" ),
	_btn_Question				= UI.getChildControl( Panel_RentHouse_WorkManager, "Button_Question" ),
	_tooltip_WorkName			= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Tooltip_Workname" ),
	
	_houseInfo =	
	{	
		_BG						= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_HouseInfo_BG" ),
		_Name               	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_HouseInfo_Name" ),
		_Desc               	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_HouseInfo_Desc" ),
		_UseType_Icon			= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_HouseInfo_UseType_Icon" ),
		_UseType_Name			= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_HouseInfo_UseType_Name" ),
		_UseType_Desc			= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_HouseInfo_UseType_Desc" ),
	},	
		
	_work_List =	
	{	
		_BG						= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkList_BG" ),
		_Title              	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkList_Title" ),
		_Scroll             	= UI.getChildControl( Panel_RentHouse_WorkManager, "Scroll_WorkList" ),
		_Level              	= {},
		_Icon               	= {},
		_Icon_Button        	= {},
		_Icon_Border        	= {},
		_Icon_Over        		= {},
		_Icon_Disable      		= {},
			
		_Template =	
		{	
			_Level				= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkList_Level" ),
			_Icon           	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkList_Icon" ),
			_Icon_Button    	= UI.getChildControl( Panel_RentHouse_WorkManager, "RadioButton_WorkList_Icon_BG" ),
			_Icon_Border    	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkList_Border" ),
			_Icon_Over	    	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkList_Icon_Over" ),
			_Icon_Disable    	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkList_Icon_Disable" ),
			
			_collumMax = 5,
			_collum_PosX_Gap = 10,
			
			_rowMax = 4,
			_row_PosY_Gap = 2,
		},	
	},	
		
	_worker_List =	
	{	
		_BG						= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkerList_BG" ),
		_Title              	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkerList_Title" ),
		_Scroll             	= UI.getChildControl( Panel_RentHouse_WorkManager, "Scroll_WorkerList" ),
		_No_Worker             	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_NoWorker" ),
		_Button             	= {},
		_Progress           	= {},
		_ActionPoint           	= {},
			
		_Template =	
		{	
			_Button				= UI.getChildControl( Panel_RentHouse_WorkManager, "RadioButton_Worker" ),
			_Progress       	= UI.getChildControl( Panel_RentHouse_WorkManager, "Progress2_Worker_ActionPoint" ),
			_ActionPoint       	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Worker_ActionPoint" ),
			
			_rowMax = 7,
			_row_PosY_Gap = 1,
		},	
	},	
	
	_work_Info =	
	{	
		_BG						= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_BG" ),
		_Title              	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Title" ),
								
		_Result_BG          	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Result_BG" ),
		_Result_Title       	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Result_Title" ),
		_Result_Line_1      	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Result_Line_1" ),
		_Result_Line_2      	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Result_Line_2" ),
		_Result_Icon        	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Result_Icon" ),
		_Result_Icon_BG_1     	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Result_Icon_BG_1" ),
		_Result_Icon_BG_2    	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Result_Icon_BG_2" ),
		_Result_Name        	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Result_Name" ),
								
		_Resource_BG        	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Resource_BG" ),
		_Resource_Title     	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_Title" ),
		_Resource_Line_1    	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Resource_Line_1" ),
		_Resource_Line_2    	= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_WorkInfo_Resource_Line_2" ),
		_Resource_Icon      	= {},
		_Resource_Icon_BG   	= {},
		_Resource_Icon_Boder   	= {},
		_Resource_Icon_Over   	= {},
		_Resource_Count     	= {},
		_Resource_Level     	= {},
		
		_Template =
		{
			_Resource_Icon		= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_Icon" ),
			_Resource_Icon_BG	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_Icon_BG" ),
			_Resource_Icon_Boder= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_Icon_Boder" ),
			_Resource_Icon_Over	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_Icon_Over" ),
			_Resource_Count 	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_Count" ),
			_Resource_Level 	= UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_WorkInfo_Resource_EnchantLevel" ),
			
			_collumMax = 6,
			_collum_PosX_Gap = 2,
		},
	},

	_work_Estimated =
	{
		_BG						= UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_BG" ),
		_Title                  = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_Title" ),
		                        
		_Time_BG                = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_Time_BG" ),
		_Time_Value             = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_Time_Value" ),
		_Time_Line              = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Time_Line" ),
		_Time_Count             = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_Time_Count" ),
		_Work_Count             = UI.getChildControl( Panel_RentHouse_WorkManager, "Button_Estimated_Work_Count" ),
		                        
		_Work_BG                = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Work_BG" ),
		_Work_Line_1            = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Work_Line_1" ),
		_Work_Line_2            = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Work_Line_2" ),
		_Work_Volume_Text       = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_WorkVolum_Text" ),
		_Work_Volume_Value      = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_WorkVolum_Value" ),
		_Work_Speed_Text        = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_WorkSpeed_Text" ),
		_Work_Speed_Value       = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_WorkSpeed_Value" ),
		                        
		_Move_BG                = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Move_BG" ),
		_Move_Line_1            = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Move_Line_1" ),
		_Move_Line_2            = UI.getChildControl( Panel_RentHouse_WorkManager, "Static_Estimated_Move_Line_2" ),
		_Move_Distance_Text     = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_MoveDistance_Text" ),
		_Move_Distance_Value    = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_MoveDistance_Value" ),
		_Move_Speed_Text        = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_MoveSpeed_Text" ),
		_Move_Speed_Value       = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_Estimated_MoveSpeed_Value" ),
		                        
		_Button_DoWork          = UI.getChildControl( Panel_RentHouse_WorkManager, "Button_doWork" ),
		_Button_DisableWork     = UI.getChildControl( Panel_RentHouse_WorkManager, "StaticText_DisableWork" ),
	},
	
	_select_Inherit =
	{
		_BG						= UI.getChildControl( Panel_Select_Inherit, "Static_Select_Inherit_BG" ),
		_Title                  = UI.getChildControl( Panel_Select_Inherit, "Static_Text_Select_Inherit_Title" ),
		_Btn_Close              = UI.getChildControl( Panel_Select_Inherit, "Button_Select_Inherit_Close" ),
		                        
		_Desc	                = UI.getChildControl( Panel_Select_Inherit, "StaticText_Select_Inherit_Desc" ),
		_Slider			        = UI.getChildControl( Panel_Select_Inherit, "Slider_Inherit" ),
		_Line_1			        = UI.getChildControl( Panel_Select_Inherit, "StaticText_Select_Inherit_Line_1" ),
		_Line_2			        = UI.getChildControl( Panel_Select_Inherit, "StaticText_Select_Inherit_Line_2" ),
		
		_Icon_BG	            = {},
		_Icon_Border            = {},
		_Icon_Over	            = {},
		_Icon		            = {},
		_Enchant_Level          = {},
		
		_Template =
		{			
			_Icon_BG	        = UI.getChildControl( Panel_Select_Inherit, "Static_Select_Inherit_IconBG" ),
			_Icon_Border	    = UI.getChildControl( Panel_Select_Inherit, "Static_Select_Inherit_Icon_Border" ),
			_Icon_Over	        = UI.getChildControl( Panel_Select_Inherit, "Static_Select_Inherit_Icon_Over" ),
			_Icon		        = UI.getChildControl( Panel_Select_Inherit, "Static_Select_Inherit_Icon" ),
			_Enchant_Level      = UI.getChildControl( Panel_Select_Inherit, "StaticText_Select_Inherit_Level" ),
			
			_collumMax = 5,
			_collum_PosX_Gap = 8,
		},
	}
}

defalut_Control._btn_Question:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseManageWork\" )" )				--물음표 좌클릭
defalut_Control._btn_Question:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"HouseManageWork\", \"true\")" )		--물음표 마우스오버
defalut_Control._btn_Question:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"HouseManageWork\", \"false\")" )		--물음표 마우스아웃

local post_SelectedWorker = nil

function defalut_Control:Init_Control()
	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._houseInfo._BG, self._houseInfo._Name )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._houseInfo._BG, self._houseInfo._Desc )
	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_List._BG, self._work_List._Title )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_List._BG, self._work_List._Scroll )	
	
	FGlobal_Set_Table_Control(self._work_List, "_Icon_Button", 	"_Icon_Button", true, true)
	FGlobal_Set_Table_Control(self._work_List, "_Icon_Border", 	"_Icon_Button", true, true)
	FGlobal_Set_Table_Control(self._work_List, "_Icon_Over", 	"_Icon_Button", true, true)
	FGlobal_Set_Table_Control(self._work_List, "_Icon", 		"_Icon_Button", true, true)
	FGlobal_Set_Table_Control(self._work_List, "_Level", 		"_Icon_Button", true, false)
	FGlobal_Set_Table_Control(self._work_List, "_Icon_Disable", "_Icon_Button", true, true)
		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._worker_List._BG, self._worker_List._Title )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._worker_List._BG, self._worker_List._Scroll )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._worker_List._BG, self._worker_List._No_Worker )
	
	FGlobal_Set_Table_Control(self._worker_List, "_Button", 		"_Button", true, false)
	FGlobal_Set_Table_Control(self._worker_List, "_Progress", 		"_Button", true, false)
	FGlobal_Set_Table_Control(self._worker_List, "_ActionPoint", 	"_Button", true, false)
		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Title )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_BG )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Title )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Line_1 )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Line_2 )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon_BG_1 )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon_BG_2 )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Result_Name  )	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Resource_BG )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Resource_Title )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Resource_Line_1 )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Info._BG, self._work_Info._Resource_Line_2 )

	FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon_BG", 	"_Resource_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon_Boder", 	"_Resource_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon_Over", 	"_Resource_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon", 		"_Resource_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._work_Info, "_Resource_Count", 		"_Resource_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._work_Info, "_Resource_Level", 		"_Resource_Icon_BG", false, true)
		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Title )	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Time_BG )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Time_Value )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Time_Line )	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Time_Count )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Count )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_BG )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Line_1 ) 		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Line_2 ) 		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Volume_Text ) 	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Volume_Value ) 	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Speed_Text ) 	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Work_Speed_Value ) 		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_BG )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_Line_1 )			
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_Line_2 ) 		
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_Distance_Text )
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_Distance_Value ) 
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_Speed_Text ) 	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Move_Speed_Value ) 	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Button_DoWork )	
	FGlobal_AddChild(Panel_RentHouse_WorkManager, self._work_Estimated._BG, self._work_Estimated._Button_DisableWork )	

	FGlobal_Set_Table_Control(self._select_Inherit, "_Icon_BG", 		"_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._select_Inherit, "_Icon_Border", 	"_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._select_Inherit, "_Icon_Over", 		"_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._select_Inherit, "_Icon", 			"_Icon_BG", false, true)
	FGlobal_Set_Table_Control(self._select_Inherit, "_Enchant_Level", 	"_Icon_BG", false, true)
	
	defalut_Control._tooltip_WorkName:SetShow(false)
end
defalut_Control:Init_Control()

function defalut_Control:Init_Function()

	self._btn_Close								:addInputEvent("Mouse_LUp",			"FGlobal_RentHouse_WorkManager_Close()")
	
	self._work_List._BG							:addInputEvent("Mouse_UpScroll",	"HandleScroll_Work_List_UpDown(true)")
	self._work_List._BG							:addInputEvent("Mouse_DownScroll",	"HandleScroll_Work_List_UpDown(false)")
	
	self._work_List._Scroll						:addInputEvent("Mouse_UpScroll",	"HandleScroll_Work_List_UpDown(true)")
	self._work_List._Scroll						:addInputEvent("Mouse_DownScroll",	"HandleScroll_Work_List_UpDown(false)")
	self._work_List._Scroll						:addInputEvent("Mouse_LDown",		"HandleScroll_Work_List_OnClick()")
	self._work_List._Scroll						:addInputEvent("Mouse_LUp",			"HandleScroll_Work_List_OnClick()")
	self._work_List._Scroll:GetControlButton()	:addInputEvent("Mouse_UpScroll",	"HandleScroll_Work_List_UpDown(true)")
	self._work_List._Scroll:GetControlButton()	:addInputEvent("Mouse_DownScroll",	"HandleScroll_Work_List_UpDown(false)")
	self._work_List._Scroll:GetControlButton()	:addInputEvent("Mouse_LDown",		"HandleScroll_Work_List_OnClick()")
	self._work_List._Scroll:GetControlButton()	:addInputEvent("Mouse_LUp",			"HandleScroll_Work_List_OnClick()")
	self._work_List._Scroll:GetControlButton()	:addInputEvent("Mouse_LPress",		"HandleScroll_Work_List_OnClick()")
	
	for key, value in pairs (self._work_List._Icon_Over) do
		value:addInputEvent("Mouse_LUp",		"Work_List_Select(" .. key ..")")
		value:addInputEvent("Mouse_On",			"HandleOn_Work_List(" .. key ..")")
		value:addInputEvent("Mouse_Out",		"HandleOut_Work_List(" .. key ..")")
		value:addInputEvent("Mouse_UpScroll",	"HandleScroll_Work_List_UpDown(true)")
		value:addInputEvent("Mouse_DownScroll",	"HandleScroll_Work_List_UpDown(false)")
	end
	
	self._worker_List._BG						:addInputEvent("Mouse_UpScroll",	"HandleScroll_Worker_List_UpDown(true)")
	self._worker_List._BG						:addInputEvent("Mouse_DownScroll",	"HandleScroll_Worker_List_UpDown(false)")
	                                            
	self._worker_List._Scroll					:addInputEvent("Mouse_UpScroll",	"HandleScroll_Worker_List_UpDown(true)")
	self._worker_List._Scroll					:addInputEvent("Mouse_DownScroll",	"HandleScroll_Worker_List_UpDown(false)")
	self._worker_List._Scroll					:addInputEvent("Mouse_LDown",		"HandleScroll_Worker_List_OnClick()")
	self._worker_List._Scroll					:addInputEvent("Mouse_LUp",			"HandleScroll_Worker_List_OnClick()")
	self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_UpScroll",	"HandleScroll_Worker_List_UpDown(true)")
	self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_DownScroll",	"HandleScroll_Worker_List_UpDown(false)")
	self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LDown",		"HandleScroll_Worker_List_OnClick()")
	self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LUp",			"HandleScroll_Worker_List_OnClick()")
	self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LPress",		"HandleScroll_Worker_List_OnClick()")	
	
	for key, value in pairs (self._worker_List._Button) do
		value:addInputEvent("Mouse_On",			"HandleOn_Worker_List(" .. key ..")")
		value:addInputEvent("Mouse_Out",		"HandleOut_Worker_List()")
		value:addInputEvent("Mouse_UpScroll",	"HandleScroll_Worker_List_UpDown(true)")
		value:addInputEvent("Mouse_DownScroll",	"HandleScroll_Worker_List_UpDown(false)")
	end
	
	self._work_Info._Result_Icon_BG_2			:addInputEvent("Mouse_On",			"Item_Tooltip_Show_Test(true)")
	self._work_Info._Result_Icon_BG_2			:addInputEvent("Mouse_Out",			"Item_Tooltip_Hide_Test()")

	for key, value in pairs (self._work_Info._Resource_Icon_Over) do
		value:addInputEvent("Mouse_On",			"Item_Tooltip_Show_Test(false, " .. key .. ")")
		value:addInputEvent("Mouse_Out",		"Panel_Tooltip_Item_hideTooltip()")
	end
	
	self._work_Estimated._Work_Count			:addInputEvent("Mouse_LUp",			"HandleClicked_WorkCount_House()")
	self._work_Estimated._Button_DoWork			:addInputEvent("Mouse_LUp",			"HandleClick_doWork()")
	
	self._select_Inherit._Btn_Close				:addInputEvent("Mouse_LUp",			"WorldMapPopupManager:pop()")	
	
	self._select_Inherit._BG					:addInputEvent("Mouse_UpScroll",	"HandleScroll_Inherit_List_UpDown(true)")
	self._select_Inherit._BG					:addInputEvent("Mouse_DownScroll",	"HandleScroll_Inherit_List_UpDown(false)")
	                                            
	self._select_Inherit._Slider				:addInputEvent("Mouse_UpScroll",	"HandleScroll_Inherit_List_UpDown(true)")
	self._select_Inherit._Slider				:addInputEvent("Mouse_DownScroll",	"HandleScroll_Inherit_List_UpDown(false)")
	self._select_Inherit._Slider				:addInputEvent("Mouse_LDown",		"HandleScroll_Inherit_List_OnClick()")
	self._select_Inherit._Slider:GetControlButton():addInputEvent("Mouse_UpScroll",		"HandleScroll_Inherit_List_UpDown(true)")
	self._select_Inherit._Slider:GetControlButton():addInputEvent("Mouse_DownScroll",	"HandleScroll_Inherit_List_UpDown(false)")
	self._select_Inherit._Slider:GetControlButton():addInputEvent("Mouse_LDown",		"HandleScroll_Inherit_List_OnClick()")
	self._select_Inherit._Slider:GetControlButton():addInputEvent("Mouse_LUp",			"HandleScroll_Inherit_List_OnClick()")
	self._select_Inherit._Slider:GetControlButton():addInputEvent("Mouse_LPress",		"HandleScroll_Inherit_List_OnClick()")	

	for key, value in pairs (self._select_Inherit._Icon_Over) do
		value:addInputEvent("Mouse_LUp",		"HandleClick_Inherit_Item(" .. key ..")")
		value:addInputEvent("Mouse_On",			"HandleOn_Inherit_Item_Tooltip(" .. key ..")")
		value:addInputEvent("Mouse_Out",		"HandleOut_Inherit_Item_Tooltip()")
		value:addInputEvent("Mouse_UpScroll",	"HandleScroll_Inherit_List_UpDown(true)")
		value:addInputEvent("Mouse_DownScroll",	"HandleScroll_Inherit_List_UpDown(false)")
	end
end
defalut_Control:Init_Function()

-----------------------------------------------------
-- 작업 목록(Work List) 관련 함수
-----------------------------------------------------

local Work_List = 
{
	_data_Table 			= {},
	_dataIndex 				= {},
	_dataIndex_First		= nil,
	_dataIndex_previous		= nil,
	_workList_Count			= nil,
	_workableType			= nil,
	_workingCount			= 1,
			
	_collumMax 				= defalut_Control._work_List._Template._collumMax,
	_rowMax 				= defalut_Control._work_List._Template._rowMax,	
	_slotCount	 			= defalut_Control._work_List._Template._collumMax * defalut_Control._work_List._Template._rowMax,
			
	_scroll 				= defalut_Control._work_List._Scroll,
	_contentRow				= 0,	
	_offsetIndex 			= 0,
	_offset_Max 			= 0,
			
	_position				= nil,
		
	_selected_Data_Row		= nil,
	_selected_Data_Collum	= nil,
	_selected_Work			= nil,
	_selected_Index			= nil,
	_over_Index				= nil,
}

local Inherit_List ={}

function Work_List:_setData()
	local level 			= param._level
	local receipeKey 		= param._useType

	self._workList_Count	= ToClient_getHouseWorkableListCount(houseInfoSS)
	--[[
	local houseInfoSSWrapper = FGlobal_SelectedHouseInfo(param._houseKey)
	local rentHouse = ToClient_GetRentHouseWrapper( param._houseKey )
	local _currentUseType			= rentHouse:getType()
	local realIndex = houseInfoSSWrapper:getIndexByReceipeKey(_currentUseType)
	local houseInfoCraftWrapper = houseInfoSSWrapper:getHouseCraftWrapperByIndex(realIndex)
	local _useTypeName = nil
	if nil ~= houseInfoCraftWrapper then
		_useTypeName = houseInfoCraftWrapper:getReciepeName()		
	end	
	--]]
	-- self._workableType		= ToClient_getHouseWorkableTypeByIndex( houseInfoSS, 0 )
	local workCount			= ToClient_getRentHouseWorkableListByCustomOnlySize( receipeKey, 1, level)
	-- if workCount == 0 or self._workList_Count == 0 then
		-- return
	-- elseif workCount ~= self._workList_Count then
		-- 이건 문제다!!
	-- end

	self._data_Table 		= {}
	
	local collumIndex 	= 1
	local rowIndex 		= 1
	local levelIndex 	= 1
	local savedLevel 	= 0
	local levelCount 	= 0
	local levelUp 		= false	

	for index = 1, workCount do
		-- 기본 정보
		if ( index == 1 ) or ( levelUp == true ) then
			if ( nil == self._data_Table[rowIndex] ) then
				self._data_Table[rowIndex] = {}
				self._data_Table[rowIndex]._level = levelIndex
				rowIndex = rowIndex + 1
				levelUp = false
			end
		end		
		if ( self._data_Table[rowIndex] == nil ) then
			self._data_Table[rowIndex] = {}
		end		
		
		-- 작업 정보
		local esSSW			= ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS ,index - 1)
		if esSSW:isSet() then
			if ( self._data_Table[rowIndex][collumIndex] == nil ) then
				self._data_Table[rowIndex][collumIndex] = {}
			end
			
			local esSS				= esSSW:get()
			local itemStaticWrapper	= esSSW:getResultItemStaticStatusWrapper()
			local itemStatic		= itemStaticWrapper:get()
			local gradeType			= itemStaticWrapper:getGradeType()
			local workVolume		= Int64toInt32(esSS._productTime / toInt64(0,1000) )
			local workName			= esSSW:getDescription()
			local workDesc			= esSSW:getDetailDescription()
			local workIcon 			= "icon/" .. esSSW:getIcon()	
			local workKey			= ToClient_getWorkableExchangeKeyByIndex(index - 1)
			local exchangeKeyRaw	= esSSW:getExchangeKeyRaw()

			-- 결과물 정보
			local resultIcon = workIcon
			local resultName = workName
			local resultKey  = nil
			if false == esSSW:getUseExchangeIcon() then
				resultName	= getItemName( itemStatic )		
				resultKey 	= itemStatic._key
			end	
		
			self._data_Table[rowIndex][collumIndex] = 
			{
				_index			= index,		
				_level			= levelIndex,
					
				_workName		= workName,
				_workDesc		= workDesc,
				_workKey		= workKey,
				_workIcon		= workIcon,
				_workVolume		= workVolume,
					
				_resultIcon		= resultIcon,
				_resultName		= resultName,
				_resultKey		= resultKey,
				
				_gradeType		= gradeType,
				
				_exchangeKeyRaw = exchangeKeyRaw,
				
				_isCraftable	= true,
				
				_resource		= {},
				_inherit		= {},
				_resourceCount	= 1
			}		
			
			-- 재료 정보
			local eSSCount 						= getExchangeSourceNeedItemList(esSS, true)

			local inheritIndex	 				= ToClient_getDyanmicEnchantIndex( exchangeKeyRaw )		
			local haveCount_Inherit = 0
			if inheritIndex > -1 then
				Inherit_List._selected_inherit	= nil
				haveCount_Inherit = Inherit_List:SetData(exchangeKeyRaw, self._data_Table[rowIndex][collumIndex])
			else
				Inherit_List._selected_inherit = -1
			end

			self._data_Table[rowIndex][collumIndex]._resourceCount = eSSCount

			for idx = 1, eSSCount do			
				if nil == self._data_Table[rowIndex][collumIndex]._resource[idx] then
					self._data_Table[rowIndex][collumIndex]._resource[idx] = {}
				end
				
				local _idx = idx - 1
				if inheritIndex > -1 then -- 계승할 Item을 항상 가장 앞에 둔다.
					if idx == 1 then
						_idx 		= inheritIndex
					elseif idx <= inheritIndex then
						_idx = idx - 2 
					end
				end
				
				local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(_idx)
				local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
				local itemStatic = itemStaticWrapper:get()
				local itemKey = itemStaticInfomationWrapper:getKey()
				local _gradeType = itemStaticWrapper:getGradeType()
				local resourceKey = itemStatic._key
				local itemIcon = "icon/" .. getItemIconPath( itemStatic )
				local needCount = Int64toInt32( itemStaticInfomationWrapper:getCount_s64() )
				local haveCount = 0
				if inheritIndex ~= _idx then
					if ( 0 ~= _affiliatedTownKey ) then
						haveCount = Int64toInt32( warehouse_getItemCount( _affiliatedTownKey , itemKey ) )
					else
						haveCount = 0
					end
				elseif inheritIndex == _idx then
					haveCount = haveCount_Inherit
				end
			
				self._data_Table[rowIndex][collumIndex]._resource[idx] = 
				{
					_itemKey		= itemKey,
					_resourceKey	= resourceKey,
					_itemIcon		= itemIcon,
					_needCount		= needCount,
					_haveCount		= haveCount,
					_gradeType		= _gradeType,
					_isInheritIndex	= (inheritIndex == _idx),
				}
				
				if haveCount < needCount then
					self._data_Table[rowIndex][collumIndex]._isCraftable = false
				end
			end	
		
			
		
		
			if levelIndex ~= savedLevel  then
				levelCount = ToClient_getRentHouseWorkableListByCustomOnlySize( receipeKey, 1, levelIndex)
				savedLevel = levelIndex
			end
			if ( index == levelCount ) then
				levelUp = true
				collumIndex = self._collumMax
				levelIndex = levelIndex + 1
				if ( levelIndex > level ) then
					break
				end
			end				
					
			if collumIndex < ( self._collumMax ) then
				collumIndex = collumIndex + 1
			else
				collumIndex = 1
				rowIndex = rowIndex + 1
			end	
		end
	end

	local _offset_Max = rowIndex - self._rowMax
	if _offset_Max < 0 then
		_offset_Max = 0
	end
	
	self._offset_Max 	= _offset_Max
	self._offsetIndex 	= 0
	self._contentRow	= rowIndex	
	self._position		= ToClient_GetHouseInfoStaticStatusWrapper(houseKey):getPosition()
	
	UIScroll.SetButtonSize( defalut_Control._work_List._Scroll, self._rowMax, self._contentRow ) -- 스크롤바 버튼의 크기를 조정한다.

	self._selected_Data_Row		= nil
	self._selected_Data_Collum	= nil
	self._selected_Work			= nil
	self._selected_Index		= nil	
end

function Work_List:_updateSlot(_isFirst)

	FGlobal_Clear_Control(defalut_Control._work_List._Level)
	FGlobal_Clear_Control(defalut_Control._work_List._Icon)
	FGlobal_Clear_Control(defalut_Control._work_List._Icon_Over)
	FGlobal_Clear_Control(defalut_Control._work_List._Icon_Button)
	FGlobal_Clear_Control(defalut_Control._work_List._Icon_Border)
	FGlobal_Clear_Control(defalut_Control._work_List._Icon_Disable)
	self._dataIndex = {}

	local collumIndex = 1
	local rowIndex = self._offsetIndex + 1
	local isFirst = _isFirst
	for index = 1, self._slotCount do
		if ( nil == self._data_Table[rowIndex] )then
			break
		end
		if ( nil ~= self._data_Table[rowIndex]._level ) and ( 1 == collumIndex ) then
			rowByIndex = math.ceil( index / self._collumMax )
			defalut_Control._work_List._Level[rowByIndex]:SetText(self._data_Table[rowIndex]._level .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_HOUSE_LEVEL"))
			defalut_Control._work_List._Level[rowByIndex]:SetShow(true)
		end
		if ( nil ~= self._data_Table[rowIndex][collumIndex] ) then
			if true == isFirst then
				self._dataIndex_First = index
				isFirst = false
			end

			self._dataIndex[index] = 
			{
				_rowIndex 		= rowIndex,
				_collumIndex 	= collumIndex,				
			}
			
			if self._selected_Index == self._data_Table[rowIndex][collumIndex]._index then
				defalut_Control._work_List._Icon_Button[index]:SetCheck(true)
			else
				defalut_Control._work_List._Icon_Button[index]:SetCheck(false)
			end
						
			defalut_Control._work_List._Icon[index]				:ChangeTextureInfoName(self._data_Table[rowIndex][collumIndex]._workIcon)
			defalut_Control._work_List._Icon[index]				:SetShow(true)

			if true == self._data_Table[rowIndex][collumIndex]._isCraftable then
				defalut_Control._work_List._Icon[index]			:SetMonoTone(false)	
				defalut_Control._work_List._Icon_Disable[index]	:SetShow(false)	
			elseif false == self._data_Table[rowIndex][collumIndex]._isCraftable then
				defalut_Control._work_List._Icon[index]			:SetMonoTone(true)
				defalut_Control._work_List._Icon_Disable[index]	:SetShow(true)
			end
			
			defalut_Control._work_List._Icon_Over[index]	:SetShow(true)	
			defalut_Control._work_List._Icon_Button[index]	:SetShow(true)	
			

			local gradeType = self._data_Table[rowIndex][collumIndex]._gradeType
			
			if (0 < gradeType) and (gradeType <= #UI.itemSlotConfig.borderTexture) then
				defalut_Control._work_List._Icon_Border[index]:ChangeTextureInfoName( UI.itemSlotConfig.borderTexture[gradeType].texture )			
				local x1, y1, x2, y2 = setTextureUV_Func( defalut_Control._work_List._Icon_Border[index], UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2 )
				defalut_Control._work_List._Icon_Border[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
				defalut_Control._work_List._Icon_Border[index]:setRenderTexture(defalut_Control._work_List._Icon_Border[index]:getBaseTexture())	
				defalut_Control._work_List._Icon_Border[index]:SetShow(true)
			else
				defalut_Control._work_List._Icon_Border[index]:SetShow(false)
			end
		end
		
		if collumIndex < ( self._collumMax ) then
			collumIndex = collumIndex + 1
		else
			collumIndex = 1
			rowIndex = rowIndex + 1
		end		
	end

	defalut_Control._work_List._Scroll:SetControlPos( self._offsetIndex / self._offset_Max) -- 스크롤바 버튼의 위치를 조정한다.
	HandleOn_Work_List_Refresh()

end

function Work_List_Select(index)	
	if Panel_Window_Exchange_Number:IsShow() then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil)
	end
	if nil == Work_List._dataIndex[index] then
		return
	end

	if true == Panel_Select_Inherit:GetShow() then
		WorldMapPopupManager:pop()
	end
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		HandleClick_Work_List( index )
		return
	end
	local rowIndex							= Work_List._dataIndex[index]._rowIndex
	local collumIndex						= Work_List._dataIndex[index]._collumIndex
	Work_List._selected_Data_Row			= rowIndex
	Work_List._selected_Data_Collum 		= collumIndex
	Work_List._selected_Work				= Work_List._data_Table[rowIndex][collumIndex]._workKey
	Work_List._selected_Index				= Work_List._data_Table[rowIndex][collumIndex]._index
	if 1 == #Work_List._data_Table[rowIndex][collumIndex]._inherit and -1 ~= Inherit_List._selected_inherit then
		Inherit_List._selected_inherit = Work_List._data_Table[rowIndex][collumIndex]._inherit[1]._itemNoRaw
	elseif -1 ~= Inherit_List._selected_inherit then
		Inherit_List._selected_inherit = nil
	end

	Work_Info_Update()
	Work_List:_updateSlot()
	Work_Estimated_Update()
end

function HandleOn_Work_List(index)
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		Keep_Tooltip_Work = true
		return
	end
	
	local rowIndex					= Work_List._dataIndex[index]._rowIndex
	local collumIndex				= Work_List._dataIndex[index]._collumIndex

	local uiBase 	= defalut_Control._work_List._Icon_Border[index]		
	local workIndex = Work_List._data_Table[rowIndex][collumIndex]._index
	local esSSW		= ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, workIndex - 1 )
	if esSSW:isSet() then
		FGlobal_Show_Tooltip_Work( esSSW, uiBase )
		Work_List._over_Index			= index
	end
	
	if rowIndex ~= Work_List._selected_Data_Row or collumIndex ~= Work_List._selected_Data_Collum then
		Work_Info_Update(true)
		Work_Estimated_Update(true)		
	else
		Work_Info_Update()
		Work_Estimated_Update()
	end
end

function HandleOut_Work_List(index)
	if isKeyPressed( VCK.KeyCode_CONTROL ) or Work_List._over_Index ~= index then
		return
	end	

	if nil ~= Work_List._dataIndex[index] then
		local rowIndex					= Work_List._dataIndex[index]._rowIndex
		local collumIndex				= Work_List._dataIndex[index]._collumIndex
		
		local workIndex = Work_List._data_Table[rowIndex][collumIndex]._index
		local esSSW		= ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, workIndex - 1 )
		if esSSW:isSet() then
			FGlobal_Hide_Tooltip_Work(esSSW, true)
			Work_List._over_Index			= nil
		end
	else
		FGlobal_Hide_Tooltip_Work(0, true)
	end
	
	Work_Info_Update()
	Work_Estimated_Update()
	
	defalut_Control._tooltip_WorkName:SetShow(false)
end

function HandleOn_Work_List_Refresh()
	local index			= Work_List._over_Index
	
	if index ~= nil then
		if defalut_Control._work_List._Icon[index]:GetShow() then
			HandleOn_Work_List(index)
		else
			HandleOut_Work_List(index)
		end
	end
end

function HandleClick_Work_List( index )
	local rowIndex					= Work_List._dataIndex[index]._rowIndex
	local collumIndex				= Work_List._dataIndex[index]._collumIndex
	
	local workIndex = Work_List._data_Table[rowIndex][collumIndex]._index
	local esSSW		= ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, workIndex - 1 )
	if esSSW:isSet() then
		FGlobal_Show_Tooltip_Work_Copy( esSSW )
	end
end
-----------------------------------------------------
-- 일꾼 목록(Worker List) 관련 함수
-----------------------------------------------------

local Worker_List =
{
	_data_Table 			= {},
	_dataIndex 				= {},
			
	_rowMax 				= defalut_Control._worker_List._Template._rowMax,	
			
	_contentRow				= nil,	
	_offsetIndex 			= nil,
	_offset_Max 			= nil,
		
	_selected_Worker		= nil,
	_selected_WorkerKey		= nil,
	_selected_Index			= nil,
	_over_Index				= nil,
}

-- 지역 별로 일꾼을 정렬해주자.
local workingTime = {}
local homeWayKey = {}
local sortDistanceValue = {}
local Worker_SortByRegionInfo = function( workIndex )
	if nil == workIndex then
		workIndex			= 0
	end
	local esSSW			 	= ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, workIndex )
	if false == esSSW:isSet() then
		return
	end
	local esSS			 	= esSSW:get()
	local productCategory	= esSS._productCategory
	local workableKey		= ToClient_getWorkableExchangeKeyByIndex(workIndex)
	local sortMethod 		= 0
	local waitingWorkerCount = ToClient_getHouseWaitWorkerList(houseInfoSS, productCategory, workableKey, sortMethod)
	local rowIndex 			= Work_List._selected_Data_Row
	local collumIndex 		= Work_List._selected_Data_Collum

	if ( 0 == waitingWorkerCount ) then
		return
	end
	
	local possibleWorkerIndex = 0
	for index = 1, waitingWorkerCount do
		local npcWaitingWorker = ToClient_getHouseWaitWorkerByIndex( houseInfoSS, index - 1)
		local workerNoRaw		= npcWaitingWorker:getWorkerNo():get_s64()
		local workerWrapperLua	= getWorkerWrapper( workerNoRaw, false )

		if( true == ToClient_isWaitWorker( npcWaitingWorker ) and ( false == workerWrapperLua:getIsAuctionInsert() ) ) then
			possibleWorkerIndex = possibleWorkerIndex + 1
		
			local firstWorkerNo			= npcWaitingWorker:getWorkerNo();	
			local workerNoChar 			= firstWorkerNo:get_s64()		
			local npcWaitingWorkerSS 	= npcWaitingWorker:getWorkerStaticStatus()
			local workerNo 				= WorkerNo( workerNoChar )			
			local workSpeed				= npcWaitingWorkerSS:getEfficiency( productCategory, ItemExchangeKey( workableKey ) );
			local moveSpeed				= npcWaitingWorkerSS._moveSpeed / 100.0;	
			local distance 				= ToClient_getCalculateMoveDistance( workerNo, Work_List._position ) / 100 
			local workVolume 			= Work_List._data_Table[rowIndex][collumIndex]._workVolume
			local workBaseTime 			= ToClient_getNpcWorkingBaseTime() / 1000
			local totalWorkTime			= math.ceil(workVolume/workSpeed) * workBaseTime + (distance/moveSpeed) * 2
			
			workingTime[possibleWorkerIndex]		= Int64toInt32(totalWorkTime)
			homeWayKey[possibleWorkerIndex]			= npcWaitingWorker:getHomeWaypoint()
			sortDistanceValue[possibleWorkerIndex]	= distance
		end
	end
	local possibleWorkerCount = possibleWorkerIndex
	
	local temp = nil
	local workerDataSwap = function( index, sortCount )
		if ( index ~= sortCount ) and ( Worker_List._data_Table[index]._homeWaypoint ~= Worker_List._data_Table[sortCount]._homeWaypoint ) then
			temp = Worker_List._data_Table[index]
			Worker_List._data_Table[index] = Worker_List._data_Table[sortCount]
			Worker_List._data_Table[sortCount] = temp
			temp = sortDistanceValue[index]
			sortDistanceValue[index] = sortDistanceValue[sortCount]
			sortDistanceValue[sortCount] = temp
		end
	end

	-- 우선 작업시간 별로 정렬
	for ii = 1, possibleWorkerCount do
		local temp = nil
		for i = possibleWorkerCount, 1, -1 do
			if 1 < i and workingTime[i] < workingTime[i-1] then
				temp = Worker_List._data_Table[i]
				Worker_List._data_Table[i] = Worker_List._data_Table[i-1]
				Worker_List._data_Table[i-1] = temp
				temp = workingTime[i]
				workingTime[i] = workingTime[i-1]
				workingTime[i-1] = temp
				temp = sortDistanceValue[i]
				sortDistanceValue[i] = sortDistanceValue[i-1]
				sortDistanceValue[i-1] = temp
			end
		end
		if nil == temp then
			break
		end
	end
	
	-- 이후 노드키 별로 정렬(같은 영지 내의 일꾼부터 표시)
	local territory = {}
	if 0 < FGlobal_WayPointKey_Return() and 300 >= FGlobal_WayPointKey_Return() then			-- 발레노스 영지
		territory[0] = true
		territory[1] = false
		territory[2] = false
		territory[3] = false
	elseif 301 <= FGlobal_WayPointKey_Return() and 600 >= FGlobal_WayPointKey_Return() then		-- 세렌디아 영지
		territory[0] = false
		territory[1] = true
		territory[2] = false
		territory[3] = false
	elseif 601 <= FGlobal_WayPointKey_Return() and 1000 >= FGlobal_WayPointKey_Return() then	-- 칼페온 영지
		territory[0] = false
		territory[1] = false
		territory[2] = true
		territory[3] = false
	elseif 1101 <= FGlobal_WayPointKey_Return() then											-- 메디아 영지
		territory[0] = false
		territory[1] = false
		territory[2] = false
		territory[3] = true
	end
	
	-- 작업시킬 거점에 속해 있는 일꾼부터 정렬
	local _sortCount = 0
	for ii = _sortCount + 1, possibleWorkerCount do
		if ( Worker_List._data_Table[ii]._homeWaypoint == FGlobal_WayPointKey_Return() ) then
			_sortCount = _sortCount + 1
			if ( ii ~= _sortCount ) then
				workerDataSwap( ii, _sortCount )
			end
		end
	end
	
	local sortByRegion = function( territoryKey )
		local sortTerritoryCount = 0
		local startValue = _sortCount + 1
		if ( possibleWorkerCount < startValue ) then
			return
		end
		if ( 0 == territoryKey ) then
			for jj = startValue, possibleWorkerCount do
				if 0 < Worker_List._data_Table[jj]._homeWaypoint and 300 >= Worker_List._data_Table[jj]._homeWaypoint then
					if startValue ~= jj then
						workerDataSwap( jj, startValue + sortTerritoryCount )
					end
					_sortCount = _sortCount + 1
					sortTerritoryCount = sortTerritoryCount + 1
				end
			end

		elseif ( 1 == territoryKey ) then
			for jj = startValue, possibleWorkerCount do
				if 301 <= Worker_List._data_Table[jj]._homeWaypoint and 600 >= Worker_List._data_Table[jj]._homeWaypoint then
					if startValue ~= jj then
						workerDataSwap( jj, startValue + sortTerritoryCount )
					end
					_sortCount = _sortCount + 1
					sortTerritoryCount = sortTerritoryCount + 1
				end
			end

		elseif ( 2 == territoryKey ) then
			for jj = startValue, possibleWorkerCount do
				if 601 <= Worker_List._data_Table[jj]._homeWaypoint and 1000 >= Worker_List._data_Table[jj]._homeWaypoint then
					if startValue ~= jj then
						workerDataSwap( jj, startValue + sortTerritoryCount )
					end
					_sortCount = _sortCount + 1
					sortTerritoryCount = sortTerritoryCount + 1
				end
			end

		elseif ( 3 == territoryKey ) then
			for jj = startValue, possibleWorkerCount do
				if 1101 <= Worker_List._data_Table[jj]._homeWaypoint then
					if startValue ~= jj then
						workerDataSwap( jj, startValue + sortTerritoryCount )
					end
					_sortCount = _sortCount + 1
					sortTerritoryCount = sortTerritoryCount + 1
				end
			end
		end
		
		-- 영지별로 분류했으면, 다시 거리로 정렬 / 거리가 같을 경우 이미 작업시간으로 분류돼 있다
		if ( 1 < sortTerritoryCount ) then
			for ii = startValue + 1, startValue + sortTerritoryCount - 1 do
				for jj = startValue + sortTerritoryCount - 1, startValue + 1, -1 do
					if ( sortDistanceValue[jj] < sortDistanceValue[jj-1] ) then
						workerDataSwap( jj, jj-1 )
					end
				end
			end
		end
	end
		
	if ( waitingWorkerCount ~= _sortCount ) then
		-- 발레노스 영지 작업관리
		if true == territory[0] then
			sortByRegion(0)
			sortByRegion(1)
			sortByRegion(2)
			sortByRegion(3)

		-- 세렌디아 영지 작업관리
		elseif true == territory[1] then
			sortByRegion(1)
			sortByRegion(0)
			sortByRegion(2)
			sortByRegion(3)

		-- 칼페온 영지 작업관리
		elseif true == territory[2] then
			sortByRegion(2)
			sortByRegion(1)
			sortByRegion(0)
			sortByRegion(3)

		-- 메디아 영지 작업관리
		elseif true == territory[3] then
			sortByRegion(3)
			sortByRegion(1)
			sortByRegion(0)
			sortByRegion(2)
		end
	end
			
end

function Worker_List:_setData()
	local workIndex						= 0 -- 동일 House의 Work는 모두 동일한 Type이므로, 첫 Index만 Check 하면 된다.
	local esSSW			 				= ToClient_getHouseWorkableItemExchangeByIndex( houseInfoSS, workIndex )
	
	if esSSW:isSet() then
		local esSS			 				= esSSW:get()
		local productCategory				= esSS._productCategory
		local workableKey					= ToClient_getWorkableExchangeKeyByIndex(workIndex)
		local sortMethod 					= 0
		
		local waitingWorkerCount = ToClient_getHouseWaitWorkerList(houseInfoSS, productCategory, workableKey, sortMethod)
		if waitingWorkerCount <= 0 then
			defalut_Control._work_Estimated._Button_DisableWork:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RENTHOUSE_WORKMANAGER_WORKERLIST_NOWORKER") )
		else
			defalut_Control._work_Estimated._Button_DisableWork:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RENTHOUSE_WORKMANAGER_BTN_DISABLEWORK") )
		end

		self._data_Table = {}
		local _idx = 0
		for Index = 1, waitingWorkerCount do
			local npcWaitingWorker	= ToClient_getHouseWaitWorkerByIndex( houseInfoSS, Index - 1)
			local workerNoRaw		= npcWaitingWorker:getWorkerNo():get_s64()
			local workerWrapperLua	= getWorkerWrapper( workerNoRaw, false )

			if( true == ToClient_isWaitWorker( npcWaitingWorker ) and ( false == workerWrapperLua:getIsAuctionInsert() ) ) then			
				_idx = _idx + 1
				if nil == self._data_Table[_idx]	then
					self._data_Table[_idx] = {}
				end
				
				local checkData = npcWaitingWorker:getStaticSkillCheckData()
				checkData:set(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse, param._houseUseType, 0)
				checkData._diceCheckForceSuccess = true

				local firstWorkerNo			= npcWaitingWorker:getWorkerNo();		
				local workerNoChar 			= firstWorkerNo:get_s64()		
				local npcWaitingWorkerSS 	= npcWaitingWorker:getWorkerStaticStatus();
				local workerNo 				= WorkerNo( workerNoChar )			
				local workSpeed				= npcWaitingWorker:getWorkEfficienceWithSkill(checkData, productCategory)	-- 집일 때
				local moveSpeed				= npcWaitingWorker:getMoveSpeedWithSkill(checkData) / 100.0
				local maxPoint 				= npcWaitingWorkerSS._actionPoint
				local currentPoint 			= npcWaitingWorker:getActionPoint()
				local workerRegionWrapper	= ToClient_getRegionInfoWrapper( npcWaitingWorker )
				local isWorkable			= ToClient_getWorkerWorkerableHouse( houseInfoSS, Index - 1)
				local homeWaypoint			= npcWaitingWorker:getHomeWaypoint()
				local name					= ""
				if ( isWorkable ) then
					name				= "Lv."..npcWaitingWorker:getLevel() .. " " .. getWorkerName(npcWaitingWorkerSS) .. "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "<PAOldColor>)"
				else
					name				= "Lv."..npcWaitingWorker:getLevel() .. " " .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_HOUSE_NOTFINDNODE", "npcWaitingWorkerSS", getWorkerName(npcWaitingWorkerSS), "getAreaName", workerRegionWrapper:getAreaName() )
					-- getWorkerName(npcWaitingWorkerSS) .. "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "-<PAOldColor><PAColor0xffFF0000>연결안됨<PAOldColor>)"
				end
				local workerGrade			= npcWaitingWorkerSS:getCharacterStaticStatus()._gradeType:get()	-- 일꾼 등급
				
				self._data_Table[_idx] =
				{
					_workerNo		= workerNo,
					_workerNo_s64	= workerNoChar,
					_workerNoChar	= Int64toInt32(workerNoChar),
					_name			= name,
					_workSpeed 		= workSpeed / 1000000,
					_moveSpeed 		= moveSpeed,
					_maxPoint 		= maxPoint,
					_currentPoint 	= currentPoint,
					_homeWaypoint	= homeWaypoint,
					_isWorkable		= isWorkable,
					_workerGrade	= workerGrade,
				}
			end
		end
		
		local _offset_Max = _idx - self._rowMax
		if _offset_Max < 0 then
			_offset_Max = 0
		end
		
		self._offset_Max 	= _offset_Max
		self._offsetIndex 	= 0
		self._contentRow	= _idx	

		UIScroll.SetButtonSize( defalut_Control._worker_List._Scroll, self._rowMax, self._contentRow ) -- 스크롤바 버튼의 크기를 조정한다.
	else
		_PA_LOG("LUA", "Worker_List:_setData() = > not esSSW:isSet()")
	end
	Worker_SortByRegionInfo()
end

function Worker_List:_updateSlot()
	if Work_List._workList_Count == 0 then
		return
	end
	FGlobal_Clear_Control(defalut_Control._worker_List._Button)
	FGlobal_Clear_Control(defalut_Control._worker_List._ActionPoint)
	FGlobal_Clear_Control(defalut_Control._worker_List._Progress)

	local rowIndex = self._offsetIndex + 1
	for index = 1, self._rowMax do
		local _dataIndex = rowIndex + index - 1
		local data 			= self._data_Table[_dataIndex]
		if nil == data then
			break
		end
		
		local name			= data._name
		local actionPoint	= tostring(data._currentPoint) .."/" .. tostring(data._maxPoint)
		local preogressRate = math.floor( (data._currentPoint / data._maxPoint) * 100)
		local workerGrade	= data._workerGrade

		defalut_Control._worker_List._Button[index]		:SetFontColor( ConvertFromGradeToColor(workerGrade) )
		
		defalut_Control._worker_List._Button[index]		:SetTextMode( CppEnums.TextMode.eTextMode_LimitText ) -- 일꾼 이름 자르기
		defalut_Control._worker_List._Button[index]		:SetText(name)
		defalut_Control._worker_List._Button[index]		:addInputEvent("Mouse_LUp","Worker_List_Select(" .. index .. ")")
		defalut_Control._worker_List._ActionPoint[index]:SetText(actionPoint)
		defalut_Control._worker_List._Progress[index]	:SetProgressRate(preogressRate)
		
		defalut_Control._worker_List._Button[index]		:SetShow(true)
		-- defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
		defalut_Control._worker_List._Progress[index]	:SetShow(true)
		
		if Worker_List._selected_WorkerKey == data._workerNoChar then 
			defalut_Control._worker_List._Button[index]:SetCheck(true)
			defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
		else
			defalut_Control._worker_List._Button[index]:SetCheck(false)
			defalut_Control._worker_List._ActionPoint[index]:SetShow(false)
		end

		-- local workerWrapperLua = getWorkerWrapper( data._workerNo_s64, false )
		-- if true == workerWrapperLua:getIsAuctionInsert() then	-- 거래소에 등록됐다면, 선택되지 않게!
		-- 	defalut_Control._worker_List._Button[index]		:SetIgnore( true )
		-- 	defalut_Control._worker_List._Button[index]		:addInputEvent("Mouse_LUp","")
		-- end
		
		
		
		self._dataIndex[index] = _dataIndex
	end
	
	defalut_Control._worker_List._Scroll:SetControlPos( self._offsetIndex / self._offset_Max) -- 스크롤바 버튼의 위치를 조정한다.
	HandleOn_Worker_List_Refresh()
end

function Worker_List_Select(index)	
	if Panel_Window_Exchange_Number:IsShow() then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil)
	end
	local selectedIndex						= Worker_List._dataIndex[index]
	if nil ~= Worker_List._dataIndex[index] then
		Worker_List._selected_Worker			= Worker_List._data_Table[selectedIndex]._workerNo
		Worker_List._selected_WorkerKey			= Worker_List._data_Table[selectedIndex]._workerNoChar
		Worker_List._selected_WorkerNoRaw		= Worker_List._data_Table[selectedIndex]._workerNo_s64
		Worker_List._selected_Index				= selectedIndex		
		_affiliatedTownKey						= Worker_List._data_Table[selectedIndex]._homeWaypoint
		if ( prevGetWearHouseKey ~= _affiliatedTownKey ) then
			warehouse_requestInfo(_affiliatedTownKey) -- 창고 Data를 가져온다!
		end
		FGlobal_HouseCraft_WorkManager_Refresh(false)
		defalut_Control._worker_List._No_Worker:SetShow(false)

	else
		_affiliatedTownKey = 0	-- 현재 열린 마을 키.

		defalut_Control._worker_List._No_Worker:SetShow(true)
	end
	Work_List._workingCount = 1
	defalut_Control._work_Estimated._Time_Count:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONGOING", "getWorkingCount", Work_List._workingCount ) ) -- "(" .. Work_List._workingCount .. "회)" )

	Worker_List:_updateSlot()
	Work_Estimated_Update()
	
end

function HandleOn_Worker_List(index)
	Worker_List._over_Index		= index
	defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
	Work_Estimated_Update(false)

	local self = Worker_List
	local workerIndex = self._offsetIndex + index
	local npcWaitingWorker = ToClient_getNpcWorkerByWorkerNo( Worker_List._data_Table[workerIndex]._workerNo_s64 )
	if nil ~= npcWaitingWorker then
		local uiBase = defalut_Control._worker_List._Button[index]
		FGlobal_ShowWorkerTooltipByWorkerNoRaw( Worker_List._data_Table[workerIndex]._workerNo_s64, uiBase, true )
		-- FGlobal_ShowWorkerTooltip( npcWaitingWorker:get(), uiBase, true )
	end
end

function HandleOut_Worker_List()
	Worker_List._over_Index		= nil
	Worker_List:_updateSlot()
	Work_Estimated_Update()

	FGlobal_HideWorkerTooltip()
end

function HandleOn_Worker_List_Refresh()
	if nil ~= Worker_List._over_Index then
		HandleOn_Worker_List(Worker_List._over_Index)
	end
end
-----------------------------------------------------
-- 제작 상세 정보/제작 예상 시간 Update 관련 함수
-----------------------------------------------------
function Work_Info_Update(isWorkOver)
	local rowIndex 		= Work_List._selected_Data_Row
	local collumIndex 	= Work_List._selected_Data_Collum
	if isWorkOver then
		rowIndex 		= Work_List._dataIndex[Work_List._over_Index]._rowIndex
		collumIndex 	= Work_List._dataIndex[Work_List._over_Index]._collumIndex
		defalut_Control._work_Info._Result_Icon_BG_1:SetShow(false)
	else
		defalut_Control._work_Info._Result_Icon_BG_1:SetShow(true)
	end

	if nil == rowIndex or nil == collumIndex or nil == Work_List._data_Table[rowIndex] or nil == Work_List._data_Table[rowIndex][collumIndex] then
		return
	end
	
	local icon 			= Work_List._data_Table[rowIndex][collumIndex]._resultIcon
	local key			= Work_List._data_Table[rowIndex][collumIndex]._resultKey
	local name			= Work_List._data_Table[rowIndex][collumIndex]._resultName

	defalut_Control._work_Info._Result_Icon		:ChangeTextureInfoName(icon)
	defalut_Control._work_Info._Result_Name		:SetText(name)
	
	FGlobal_Clear_Control(defalut_Control._work_Info._Resource_Icon)
	FGlobal_Clear_Control(defalut_Control._work_Info._Resource_Icon_BG)
	FGlobal_Clear_Control(defalut_Control._work_Info._Resource_Icon_Boder)
	FGlobal_Clear_Control(defalut_Control._work_Info._Resource_Icon_Over)
	FGlobal_Clear_Control(defalut_Control._work_Info._Resource_Count)
	FGlobal_Clear_Control(defalut_Control._work_Info._Resource_Level)
	
	local resourceCount = #Work_List._data_Table[rowIndex][collumIndex]._resource
	for idx = 1, resourceCount do
		local itemKey 	= Work_List._data_Table[rowIndex][collumIndex]._resource[idx]._itemKey
		local itemIcon 	= Work_List._data_Table[rowIndex][collumIndex]._resource[idx]._itemIcon
		local needCount = Work_List._data_Table[rowIndex][collumIndex]._resource[idx]._needCount
		local haveCount = Work_List._data_Table[rowIndex][collumIndex]._resource[idx]._haveCount
		local resourceCount = tostring(haveCount) .. "/" .. tostring(needCount)
		if needCount > haveCount then
			resourceCount = "<PAColor0xFFDB2B2B>" .. resourceCount .. "<PAOldColor>"
		end
		
		local gradeType = Work_List._data_Table[rowIndex][collumIndex]._resource[idx]._gradeType

		if (0 < gradeType) and (gradeType <= #UI.itemSlotConfig.borderTexture) then
			defalut_Control._work_Info._Resource_Icon_Boder[idx]:ChangeTextureInfoName( UI.itemSlotConfig.borderTexture[gradeType].texture )			
			local x1, y1, x2, y2 = setTextureUV_Func( defalut_Control._work_Info._Resource_Icon_Boder[idx], UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2 )
			defalut_Control._work_Info._Resource_Icon_Boder[idx]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			defalut_Control._work_Info._Resource_Icon_Boder[idx]:setRenderTexture(defalut_Control._work_Info._Resource_Icon_Boder[idx]:getBaseTexture())	
			defalut_Control._work_Info._Resource_Icon_Boder[idx]:SetShow(true)
		else
			defalut_Control._work_Info._Resource_Icon_Boder[idx]:SetShow(false)
		end
		
		
		defalut_Control._work_Info._Resource_Icon[idx]   	:ChangeTextureInfoName(itemIcon)
		defalut_Control._work_Info._Resource_Count[idx]  	:SetText(resourceCount)
		defalut_Control._work_Info._Resource_Level[idx]		:SetText("")

		defalut_Control._work_Info._Resource_Icon[idx]   	:SetShow(true)
		defalut_Control._work_Info._Resource_Icon_BG[idx]	:SetShow(true)
		defalut_Control._work_Info._Resource_Icon_Over[idx]	:SetShow(true)
		defalut_Control._work_Info._Resource_Count[idx]  	:SetShow(true)
	end
end

function Work_Estimated_Update(isWorkOver)
	local rowIndex 		= Work_List._selected_Data_Row
	local collumIndex 	= Work_List._selected_Data_Collum
	if isWorkOver then
		rowIndex 		= Work_List._dataIndex[Work_List._over_Index]._rowIndex
		collumIndex 	= Work_List._dataIndex[Work_List._over_Index]._collumIndex
	end
	
	local distance		= 0
	local workVolume    = 0
	local workSpeed     = 0
	local moveSpeed     = 0
	if nil ~= Work_List._data_Table[rowIndex][collumIndex] then
		workVolume 	= Work_List._data_Table[rowIndex][collumIndex]._workVolume
		defalut_Control._work_Estimated._Work_Volume_Value		:SetText(": " .. workVolume)	
		if true == Work_List._data_Table[rowIndex][collumIndex]._isCraftable then
			defalut_Control._work_Estimated._Work_Count			:SetShow(true)
			defalut_Control._work_Estimated._Button_DoWork		:SetShow(true)
			defalut_Control._work_Estimated._Button_DisableWork	:SetShow(false)	
		elseif false == Work_List._data_Table[rowIndex][collumIndex]._isCraftable then
			defalut_Control._work_Estimated._Work_Count			:SetShow(false)
			defalut_Control._work_Estimated._Button_DoWork		:SetShow(false)
			defalut_Control._work_Estimated._Button_DisableWork	:SetShow(true)	
		end
	end
	
	local workerIndex	= Worker_List._selected_Index
	if false == isWorkOver then
		workerIndex = Worker_List._dataIndex[Worker_List._over_Index]
	end
	
	if nil ~= Worker_List._data_Table[workerIndex] then
		distance 		= ToClient_getCalculateMoveDistance( Worker_List._data_Table[workerIndex]._workerNo , Work_List._position ) / 100 
		workSpeed		= Worker_List._data_Table[workerIndex]._workSpeed
		moveSpeed		= Worker_List._data_Table[workerIndex]._moveSpeed

		defalut_Control._work_Estimated._Move_Distance_Value	:SetText(": " .. string.format("%.0f", distance))
		defalut_Control._work_Estimated._Work_Speed_Value		:SetText(": " .. string.format("%.2f", workSpeed))
		defalut_Control._work_Estimated._Move_Speed_Value		:SetText(": " .. string.format("%.2f", moveSpeed))
	else
		defalut_Control._work_Estimated._Move_Distance_Value	:SetText("--")
		defalut_Control._work_Estimated._Work_Speed_Value		:SetText("--")
	    defalut_Control._work_Estimated._Move_Speed_Value		:SetText("--")
	end
	
	if nil ~= Worker_List._data_Table[workerIndex] and nil ~= Work_List._data_Table[rowIndex][collumIndex] then
		local workBaseTime 	= ToClient_getNpcWorkingBaseTime() / 1000
		local totalWorkTime	= math.ceil(workVolume/workSpeed) * workBaseTime + (distance/(moveSpeed)) * 2
		-- (아이템제작기본시간/작업속도)*제작기본시간 + (거리/이동속도) * 2
		defalut_Control._work_Estimated._Time_Value				:SetText( Util.Time.timeFormatting(math.floor(totalWorkTime)) )
	else
		defalut_Control._work_Estimated._Time_Value				:SetText("--")
	end
	

end

-----------------------------------------------------
-- Scroll 관련 함수
-----------------------------------------------------

local Scroll_UpDown = function(isUp, _target)
	if ( false == isUp ) then
		_target._offsetIndex = math.min(_target._offset_Max, _target._offsetIndex + 1)
	else
		_target._offsetIndex = math.max(0, _target._offsetIndex -1)
	end	
	_target:_updateSlot()
	-- HouseWorkListSection_ShowTooltip_Reflesh()
end

function HandleScroll_Work_List_UpDown(isUp)
	Scroll_UpDown(isUp, Work_List)
end

function HandleScroll_Worker_List_UpDown(isUp)
	Scroll_UpDown(isUp, Worker_List)
end

function HandleScroll_Inherit_List_UpDown(isUp)
	Scroll_UpDown(isUp, Inherit_List)
end

local ScrollOnClick = function(_target, _scroll)
	local _scroll_Button = _scroll:GetControlButton()
	local _scroll_Blank = _scroll:GetSizeY() - _scroll_Button:GetSizeY() 
	local _scroll_Percent = _scroll_Button:GetPosY() / _scroll_Blank
	_target._offsetIndex = 0
	
	_target._offsetIndex = math.floor( _scroll_Percent * _target._offset_Max )
	_target:_updateSlot()
end

function HandleScroll_Work_List_OnClick()
	ScrollOnClick(Work_List, defalut_Control._work_List._Scroll)
end

function HandleScroll_Worker_List_OnClick()
	ScrollOnClick(Worker_List, defalut_Control._worker_List._Scroll)
end

local SliderOnClick = function(_target, _slider)
	local _scroll_Button = _slider:GetControlButton()
	local _scroll_Blank = _slider:GetSizeX() - _scroll_Button:GetSizeX() 
	local _scroll_Percent = _scroll_Button:GetPosX() / _scroll_Blank
	--_target._offsetIndex = math.max(math.min(math.floor(_scroll_Percent * _target._offset_Max), 1), 0)
	_target._offsetIndex = 0
	if ( 0 < _target._offset_Max ) then
		local countValue = _target._offset_Max + 1
		_target._offsetIndex = math.min( math.floor(_scroll_Percent * (countValue) ), _target._offset_Max )
	end	
	_target:_updateSlot()
end

function HandleScroll_Inherit_List_OnClick()
	SliderOnClick(Inherit_List, defalut_Control._select_Inherit._Slider)
end
-----------------------------------------------------
-- ToolTip 관련 함수
-----------------------------------------------------

function Item_Tooltip_Show_Test(isResult, idx)
	local rowIndex 		= Work_List._selected_Data_Row
	local collumIndex 	= Work_List._selected_Data_Collum
	if nil == Work_List._data_Table[rowIndex] then
		return
	end
	local staticStatusKey = nil
	local uiBase = nil
	if isResult then
		staticStatusKey = Work_List._data_Table[rowIndex][collumIndex]._resultKey	
		uiBase = 	defalut_Control._work_Info._Result_Icon_BG_1
	elseif false == isResult and nil ~= idx then
		staticStatusKey = Work_List._data_Table[rowIndex][collumIndex]._resource[idx]._resourceKey	
		uiBase = defalut_Control._work_Info._Resource_Icon_BG[idx]
	end
		
	if ( nil == staticStatusKey ) and ( true == isResult ) then
		
		-- local workDes = "설명!asdasdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
		local workDes = Work_List._data_Table[rowIndex][collumIndex]._workDesc
		if workDes =="" then
			return
		end
		defalut_Control._tooltip_WorkName:SetAutoResize( true )
		defalut_Control._tooltip_WorkName:SetTextMode( UI_TM.eTextMode_AutoWrap )
		defalut_Control._tooltip_WorkName:SetText(workDes)
		defalut_Control._tooltip_WorkName:SetShow(true)
		
		local textSize = defalut_Control._tooltip_WorkName:GetTextSizeX()
		defalut_Control._tooltip_WorkName:SetSize(textSize + 5, defalut_Control._tooltip_WorkName:GetSizeY())
		
		-- WorkName 을 표시하는 Tooltip!!
		 local uiParent 	= defalut_Control._work_Info._BG	
		defalut_Control._tooltip_WorkName:SetPosX(uiParent:GetPosX() + uiBase:GetPosX() + uiBase:GetSizeX())
		defalut_Control._tooltip_WorkName:SetPosY(uiParent:GetPosY() + uiBase:GetPosY() + 2)
	elseif ( nil == staticStatusKey ) or ( nil == uiBase ) then
		return
	else
		local exchangeKeyRaw	= Work_List._data_Table[rowIndex][collumIndex]._exchangeKeyRaw
		local inheritIndex		= ToClient_getDyanmicEnchantIndex( exchangeKeyRaw )
		if ( 1 <= #Work_List._data_Table[rowIndex][collumIndex]._inherit ) and ( inheritIndex + 1 == idx ) then
			local itemNoRaw		= Work_List._data_Table[rowIndex][collumIndex]._inherit[1]._itemNoRaw
			local itemWrapper	= warehouse_getItemByItemNo(_affiliatedTownKey, itemNoRaw)
			if ( nil ~= itemWrapper ) then
				Panel_Tooltip_Item_Show(itemWrapper, uiBase, false, true)
			end
		else
			local staticStatusWrapper = getItemEnchantStaticStatus( staticStatusKey )	
			Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
		end
	end
	
end

function Item_Tooltip_Hide_Test()
	if true == defalut_Control._tooltip_WorkName:GetShow() then
		defalut_Control._tooltip_WorkName:SetShow(false)
	end
	Panel_Tooltip_Item_hideTooltip()
end

-----------------------------------------------------
-- Panel Open/Close 관련 함수
-----------------------------------------------------

function FGlobal_RentHouse_WorkManager_Open(houseInfoSSWrapper, _param)
	Panel_RentHouse_WorkManager:SetShow(true, true)
	
	local PosX = Panel_HouseControl:GetPosX(PosX)
	local PosY = Panel_HouseControl:GetPosY(PosY)	
	Panel_RentHouse_WorkManager:SetPosX(PosX)
	Panel_RentHouse_WorkManager:SetPosY(PosY)
	
	if nil == houseInfoSSWrapper then
		FGlobal_RentHouse_WorkManager_Close()
		return
	end
	
	Worker_List._selected_Worker		= nil
	Worker_List._selected_WorkerKey		= nil
	Worker_List._selected_Index			= nil
	Worker_List._over_Index				= nil
	
	houseInfoSS			= houseInfoSSWrapper:get();
	houseKey			= houseInfoSSWrapper:getHouseKey()
	param				= _param
	prevGetWearHouseKey	= nil
	
	Work_List:_setData()
	Work_List:_updateSlot(true)
	Work_List_Select(Work_List._dataIndex_First)		
	Work_List:_updateSlot()
	
	Worker_List:_setData()
	Worker_List:_updateSlot()
	Worker_List_Select(1)
	Worker_List:_updateSlot()	
	
	defalut_Control._title:SetText(param._houseName)
	-- defalut_Control._work_Info._Select_BG:SetShow(false)
	
	Set_HouseUseType_Texture_BG(defalut_Control._houseInfo._BG)
	Set_HouseUseType_Texture_Icon(defalut_Control._houseInfo._UseType_Icon)
	
	defalut_Control._houseInfo._UseType_Name:SetText( param._useTypeName )
	defalut_Control._houseInfo._UseType_Desc:SetAutoResize( true )
	defalut_Control._houseInfo._UseType_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	defalut_Control._houseInfo._UseType_Desc:SetText( param._useType_Desc )
end

function FGlobal_RentHouse_WorkManager_Close()
	--Panel_RentHouse_WorkManager:SetShow(false)
	FGlobal_WorldMapWindowEscape();
end

-----------------------------------------------------
-- 작업 시작 Button 관련 함수
-----------------------------------------------------
function HandleClick_doWork()													-- 작업 시작
	if workerManager_CheckWorkingOtherChannelAndMsg() then
		return
	end
	
	if ( nil == Worker_List._selected_Worker ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect") )
		return
	end	

	if nil == Inherit_List._selected_inherit then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_Select_Inherit, true )

		FGlobal_Inherit_List_Open()
	else
		HandleClick_doWork_Continue()
	end
end

function HandleClick_doWork_Continue()
	if ( false == ToClient_WareHouseCheckSealed( Worker_List._selected_Worker, Inherit_List._selected_inherit ) ) then
		HandleClick_doWork_Continue_ItemClearWarning()
		return
	end

	local cancelFunction = function()
		Inherit_List._selected_inherit	= nil
		Inherit_List._over_Index		= nil
		return
	end
	local messageContent = PAGetString( Defines.StringSheet_GAME, "LUA_RENTHOUSE_STAMPING_CLEAR" )
	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = messageContent, functionYes = HandleClick_doWork_Continue_ItemClearWarning, functionNo = cancelFunction, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function HandleClick_doWork_Continue_ItemClearWarning()
	if ( -1 == Inherit_List._selected_inherit ) then
		HandleClick_doWork_Confirm()
		return
	end
	local cancelFunction = function()
		Inherit_List._selected_inherit	= nil
		Inherit_List._over_Index		= nil
		return
	end
	local messageContent = PAGetString( Defines.StringSheet_GAME, "LUA_RENTHOUSE_IMPROVE_ITEMCLEARWARNING" )
	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = messageContent, functionYes = HandleClick_doWork_Confirm, functionNo = cancelFunction, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function HandleClick_doWork_Confirm()
	local workingCount 	= Work_List._workingCount			-- 작업 횟수는 기본 1회
	local itemNoRaw 	= Inherit_List._selected_inherit	-- 개량할 item을 지정
	if nil ~= itemNoRaw then
		if nil == houseInfoSS or nil == Work_List._selected_Work or nil == Worker_List._selected_Worker then
			return
		end

		if 11 == param._houseUseType then	-- 개량소 일때만
			local warehouseWrapper	= warehouse_get( _affiliatedTownKey )
			local itemWrapper		= warehouseWrapper:getItemByItemNoRaw( itemNoRaw )
			local hasJewel			= false
			for jewelIdx = 0 , 5 do
				local itemEnchantSSW = itemWrapper:getPushedItem(jewelIdx)	-- 소켓에 꼽힌 아이템 정보.
				if nil ~= itemEnchantSSW then
					hasJewel = true
					break
				end
			end

			if true == hasJewel then
				local messageTitle		= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- 알 림
				local messageContent	= PAGetString(Defines.StringSheet_GAME, "LUA_NEWWORDMAP_WORKMANAGER_HOUSE_HASJEWEL") -- 수정이 장착된 장비는 개량 할 수 없습니다.
				local messageboxData	= { title = messageTitle, content = messageContent, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageboxData)

				Inherit_List._selected_inherit	= nil
				Inherit_List._over_Index		= nil
				return
			end
		end
		
		-- { 반복 작업 재료 갯수 체크
			local workingType			= CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse
			local houseUseType			= param._houseUseType
			local rowIndex				= Work_List._selected_Data_Row
			local colIndex				= Work_List._selected_Data_Collum
			local itemExchangeKeyRaw	= Work_List._data_Table[rowIndex][colIndex]._exchangeKeyRaw
			local workerNoRaw			= Worker_List._selected_WorkerNoRaw
			local workerWrapperLua		= getWorkerWrapper( workerNoRaw, true )
			local waypointKey			= workerWrapperLua:getHomeWaypoint()
			local workerRepeatCount		= workerWrapperLua:getAdditionalRepeatCount( workingType, houseUseType, waypointKey, itemExchangeKeyRaw )

			-- { workerRepeatCount가 0 이상이면 재료 체크를 해야 한다.
				local isPassCheck	= true
				if 0 < workerRepeatCount then
					local resourceCount = #Work_List._data_Table[rowIndex][colIndex]._resource
					for idx = 1, resourceCount do
						local needCount 		= Work_List._data_Table[rowIndex][colIndex]._resource[idx]._needCount
						local haveCount 		= Work_List._data_Table[rowIndex][colIndex]._resource[idx]._haveCount
						local isMaterialFull 	= 0 <= (haveCount - ( needCount * (workerRepeatCount + 1) ))	-- 반복 외 기본 횟수가 있어서 +1 한다.
						if not isMaterialFull then
							isPassCheck = false
							break
						end
					end
				end
			-- }
		-- }

		if not isPassCheck then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_WORKERMANAGER_REPEATWORK_NEEDMATERIAL" ) )
			-- "반복 작업에 필요한 재료가 부족합니다."
			return
		end

		ToClient_requestStartRentHouseWorkingToNpcWorker( houseInfoSS, Worker_List._selected_Worker, Work_List._selected_Work, workingCount, itemNoRaw)	
		FGlobal_RedoWork( 0, houseInfoSS, Worker_List._selected_Worker, nil, Work_List._selected_Work, nil, workingCount, itemNoRaw, nil, _affiliatedTownKey )
		post_SelectedWorker = Worker_List._selected_Worker
		FGlobal_RentHouse_WorkManager_Close();
	end
end


-----------------------------------------------------
-- 작업 횟수 Button 관련 함수
-----------------------------------------------------
function LimitWorkableCount_House()
	local rowIndex			= Work_List._selected_Data_Row
	local collumIndex		= Work_List._selected_Data_Collum
	local resourceCount		= Work_List._data_Table[rowIndex][collumIndex]._resourceCount
	local haveCount			= {}
	local minHaveCount		= Worker_List._data_Table[Worker_List._selected_Index]._currentPoint
	if 1 < resourceCount then
		for i = 1, resourceCount do
			local data = Work_List._data_Table[rowIndex][collumIndex]._resource[i]
			if ( false == data._isInheritIndex ) then
				minHaveCount = math.min(data._haveCount / data._needCount, minHaveCount)
			end
		end
	else
		local data = Work_List._data_Table[rowIndex][collumIndex]._resource[1]
		minHaveCount = math.min((data._haveCount / data._needCount), minHaveCount)
	end

	return math.max(math.floor(minHaveCount), 1)
end

local set_Workable_Count = function( inputNumber )
	Work_List._workingCount = Int64toInt32( inputNumber )
	defalut_Control._work_Estimated._Time_Count:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Work_List._workingCount ) ) -- "(" .. Work_List._workingCount .. "회)" )
end

function HandleClicked_WorkCount_House()
	local s64_MaxWorkableCount = toInt64(0, LimitWorkableCount_House())
	
	if toInt64(0, 0) >= s64_MaxWorkableCount then
		_PA_LOG("이문종", "일꾼이 작업할 수 없습니다.")
	else
		Panel_NumberPad_Show( true, s64_MaxWorkableCount, 0, set_Workable_Count, false )
	end
end

------------------------------------------------------------------------
--------------------- 계량 Item 선택 관련 함수 -------------------------
------------------------------------------------------------------------
-- Panel_Select_Inherit:SetShow(true)

Inherit_List =
{
	_data					= {},
	_Item_MaxCount			= defalut_Control._select_Inherit._Template._collumMax,

	_contentCollum			= 0,	
	_offsetIndex	  		= 0,
	_offset_Max 			= 0,
	_slotMax				= 0,
	
	_selected_inherit 		= nil,		
}

function Inherit_List:SetData(exchangeKeyRaw, _data_Parent)
	local haveCount = ToClient_getDynamicEnchantLevelItemListByRentHouse( _affiliatedTownKey, exchangeKeyRaw )

	for index = 1, haveCount do
		local itemNoRaw 	= ToClient_getDynamicEnchantLevelItemKeyByRentHouse( index - 1 )
		local itemWrapper 	= ToClient_getDynamicEnchantLevelItemWrapper( index - 1 )
		local itemESSW	 	= itemWrapper:getStaticStatus()
		local itemStatic 	= itemESSW:get()
		local itemKey 		= itemStatic._key
		local enchantLevel 	= itemKey:getEnchantLevel()
		local itemIcon 		= "icon/" .. itemESSW:getIconPath()
		local stackCount	= 0
		if ( 0 ~= _affiliatedTownKey) then
			stackCount	= warehouse_getItemCountByItemNo(_affiliatedTownKey, itemNoRaw)
		end
		
		_data_Parent._inherit[index] =
		{
			_itemNoRaw		= itemNoRaw,
			_itemKey		= itemKey,
			_itemIcon		= itemIcon,
			_enchantLevel	= enchantLevel,
			_stackCount		= stackCount,
			_data_Parent	= _data_Parent,
		}
	end
	
	return haveCount
end

function Inherit_List:_updateSlot()
	local _data 		= self._data
	
	if nil == _data then
		return
	end
	defalut_Control._select_Inherit._Slider:SetInterval( self._offset_Max )

	for idx = 1, self._Item_MaxCount do
		local index = self._offsetIndex + idx
		if nil ~= _data[index] then			
			local icon 			= _data[index]._itemIcon
			local enchantLevel 	= _data[index]._enchantLevel
			local gradeType 	= _data[index]._data_Parent._resource[1]._gradeType
			defalut_Control._select_Inherit._Icon[idx]			:ChangeTextureInfoName(icon)
			
			if enchantLevel > 0 then
				local printenchantLevel = ""
				if 0 < enchantLevel and enchantLevel < 15 then
					printenchantLevel = "+" .. tostring(enchantLevel)
				elseif 15 == enchantLevel then
					printenchantLevel = "I"
				elseif 16 == enchantLevel then
					printenchantLevel = "II"
				elseif 17 == enchantLevel then
					printenchantLevel = "III"
				elseif 18 == enchantLevel then
					printenchantLevel = "IV"
				elseif 19 == enchantLevel then
					printenchantLevel = "V"
				elseif 20 <= enchantLevel then
					printenchantLevel = "VI"
				end

				defalut_Control._select_Inherit._Enchant_Level[idx]	:SetText( printenchantLevel )
				defalut_Control._select_Inherit._Enchant_Level[idx] :SetShow(true)
			else
				defalut_Control._select_Inherit._Enchant_Level[idx] :SetShow(false)
			end
			
			if (0 < gradeType) and (gradeType <= #UI.itemSlotConfig.borderTexture) then
				defalut_Control._select_Inherit._Icon_Border[idx]:ChangeTextureInfoName( UI.itemSlotConfig.borderTexture[gradeType].texture )			
				local x1, y1, x2, y2 = setTextureUV_Func( defalut_Control._select_Inherit._Icon_Border[idx], UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2 )
				defalut_Control._select_Inherit._Icon_Border[idx]:getBaseTexture():setUV(  x1, y1, x2, y2  )
				defalut_Control._select_Inherit._Icon_Border[idx]:setRenderTexture(defalut_Control._select_Inherit._Icon_Border[idx]:getBaseTexture())	
				defalut_Control._select_Inherit._Icon_Border[idx]:SetShow(true)
			else
				defalut_Control._select_Inherit._Icon_Border[idx]:SetShow(false)
			end
			
			defalut_Control._select_Inherit._Icon_BG[idx]		:SetShow(true)
			defalut_Control._select_Inherit._Icon_Over[idx]		:SetShow(true)
			defalut_Control._select_Inherit._Icon[idx]          :SetShow(true)			
		else
			defalut_Control._select_Inherit._Icon_BG[idx]		:SetShow(false)
			defalut_Control._select_Inherit._Icon[idx]          :SetShow(false)
			defalut_Control._select_Inherit._Enchant_Level[idx] :SetShow(false)
			defalut_Control._select_Inherit._Icon_Over[idx]		:SetShow(false)
			defalut_Control._select_Inherit._Icon_Border[idx]	:SetShow(false)
		end
	end
	
	UISlider_SetButtonSize( defalut_Control._select_Inherit._Slider, self._Item_MaxCount, self._contentCollum )
	if defalut_Control._select_Inherit._Slider:GetShow() then
		defalut_Control._select_Inherit._Line_2:SetShow(false)
		defalut_Control._select_Inherit._Slider:SetControlPos( self._offsetIndex / self._offset_Max * 100 )
	else
		defalut_Control._select_Inherit._Line_2:SetShow(true)
	end
	
	HandleOn_Inherit_Item_Tooltip(Inherit_List._over_Index)
end

function FGlobal_Inherit_List_Open()
	local self 			= Inherit_List
	local rowIndex 		= Work_List._selected_Data_Row	
	local collumIndex 	= Work_List._selected_Data_Collum
	local _data 		= Work_List._data_Table[rowIndex][collumIndex]
	if nil == _data then
		return
	end
	
	Inherit_List._data			= _data._inherit
	Inherit_List._contentCollum	= #_data._inherit
	
	Inherit_List._offsetIndex	= 0
	Inherit_List._offset_Max	= Inherit_List._contentCollum - Inherit_List._Item_MaxCount
	Inherit_List._slotMax		= Inherit_List._contentCollum
	
	if Inherit_List._offset_Max < 0 then
		Inherit_List._offset_Max = 0
	else
		Inherit_List._slotMax 	= Inherit_List._Item_MaxCount
	end	

	Inherit_List._selected_inherit 		= nil
	Inherit_List._over_Index			= nil
	
	Inherit_List:_updateSlot()
end

function HandleClick_Inherit_Item(idx)
	local itemIndex = Inherit_List._offsetIndex + idx
	Inherit_List._selected_inherit = Inherit_List._data[itemIndex]._itemNoRaw
	HandleClick_doWork_Continue()
	WorldMapPopupManager:pop()
end

function HandleOn_Inherit_Item_Tooltip(idx)
	if nil ~= idx then
		Inherit_List._over_Index = idx	
	else
		return
	end
	local itemIndex = Inherit_List._offsetIndex + idx 
	if nil == Inherit_List._data[itemIndex] then
		HandleOut_Inherit_Item_Tooltip()
		return
	end
	local rowIndex 			= Work_List._selected_Data_Row	
	local collumIndex 		= Work_List._selected_Data_Collum
	local exchangeKeyRaw	= Work_List._data_Table[rowIndex][collumIndex]._exchangeKeyRaw
	local haveCount 		= ToClient_getDynamicEnchantLevelItemListByRentHouse( _affiliatedTownKey, exchangeKeyRaw )
	local itemWrapper 		= ToClient_getDynamicEnchantLevelItemWrapper( itemIndex - 1 )
	local uiBase 			= defalut_Control._select_Inherit._Icon_BG[idx]

	Panel_Tooltip_Item_Show( itemWrapper,  uiBase, false, true )
end

function HandleOut_Inherit_Item_Tooltip()
	Inherit_List._over_Index = nil
	Panel_Tooltip_Item_hideTooltip()
end

------------------------------------------------------------------------
------------------------- Event 관련 함수  -----------------------------
------------------------------------------------------------------------

function FromClient_House_StopWork()
	if Panel_RentHouse_WorkManager:GetShow() then
		Worker_List:_setData()
		Worker_List:_updateSlot()

		if nil == Worker_List._selected_Index then
			Worker_List_Select(1)
		end
	end
end

function FGlobal_HouseCraft_WorkManager_Refresh()
	local index = nil
	local offsetIndex = Work_List._offsetIndex
	for key, value in pairs( Work_List._dataIndex ) do
		if ( value._rowIndex == Work_List._selected_Data_Row ) and ( value._collumIndex == Work_List._selected_Data_Collum ) then
			index = key
			break
		end
	end

	Work_List:_setData()
	Work_List._offsetIndex = offsetIndex
	Work_List:_updateSlot()
	if ( nil ~= index ) then
		Work_List_Select(index)
	else
		Work_List_Select(Work_List._dataIndex_First)
	end
		
	--Worker_List:_setData()
	--Worker_List:_updateSlot()

	Work_Info_Update()
	Work_Estimated_Update()
end

function FromClient_WareHouse_Update_ForHouseCraft(affiliatedTownKey)
	if ( prevGetWearHouseKey == affiliatedTownKey ) then
		return
	end
	prevGetWearHouseKey = affiliatedTownKey
	if affiliatedTownKey == _affiliatedTownKey and true == Panel_RentHouse_WorkManager:GetShow() then
		FGlobal_HouseCraft_WorkManager_Refresh()
	end
end

registerEvent("EventWarehouseUpdate",					"FromClient_WareHouse_Update_ForHouseCraft")
registerEvent("WorldMap_StopWorkerWorking",				"FromClient_House_StopWork")
