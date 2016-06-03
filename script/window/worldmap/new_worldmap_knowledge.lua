local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode

local __existMentalInfo = {
	[1] 	= { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 38, y1 = 197, x2 = 74, y2 = 233, },		-- 인물
	[5001] 	= { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 1, y1 = 197, x2 = 37, y2 = 233, }, 		-- 지형
	[10001]	= { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 75, y1 = 197, x2 = 111, y2 = 233, }, 		-- 생태
	[20001] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 75, y1 = 197, x2 = 111, y2 = 233, }, 		-- 모험일지
	[25001] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 75, y1 = 197, x2 = 111, y2 = 233, }, 		-- 학문
	[30001] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 112, y1 = 197, x2 = 148, y2 = 233, }, 		-- 생활
}

local __extraMentalInfo = {
	-- [2] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 35, y1 = 100, x2 = 51, y2 = 116, }, 		-- 질다 (재료상인)
	[4] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 클로린스(물약)
	[9] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 타크로스(기술교관)
	[45] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 475, y1 = 38, x2 = 511, y2 = 74, }, 		-- 에일린(물약)
	[43] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 475, y1 = 38, x2 = 511, y2 = 74, }, 		-- 라니(물약)
	[61] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 475, y1 = 38, x2 = 511, y2 = 74, }, 		-- 키나(물약)
	[16] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 		-- 로렌조(마구간)
	
	[38] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 암스트롱(기술교관)
	[34] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 헤센베일(물약)
	[60] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 		-- 사무엘(마구간)
	
	[386] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 크록서스(기술교관)
	[388] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 릴리아(물약)
	
	[109] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 크루혼 웜스베인(기술교관)
	[103] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 카레스토 폰티(물약)
	[104] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 라라(물약)
	[116] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 바나실(마구간)
	[127] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 이자우로(마구간)
	
	[139] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 모니쿠(물약)
	[150] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 세이레인(물약)
	[181] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 엘라(마구간)
	[153] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 암브로시아(마구간)

	[155] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 체이사르(기술교관)
	[156] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 로레나(마구간)
	[166] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 올리비에로(마구간)
	[167] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 푸블리오(마구간)
	[169] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 델모(마구간)
	
	[344] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 475, y1 = 38, x2 = 511, y2 = 74, }, 	-- 알쳄(물약)
	[354] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 게이브릴(마구간)
	[351] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 브리스만(마구간)
	[399] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 디만토르(마구간)
	[400] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 아쉬로그(마구간)
	[482] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 레날두스(기술교관)
	[483] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 폰 마렌(기술교관)
	[484] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 프세보르(기술교관)
	
	[350] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 로마리오(마구간)
	[337] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 스텔라(물약)
	[340] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 폴리니(기술교관)
	[333] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 헤르아르(마구간)
	
	[465] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 피리아(물약)
	[467] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 테레시오 카폰(기술교관)
	[470] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 파누치(마구간)
	
	[414] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 칸트(물약)
	[419] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 릴바노스(기술교관)
	[430] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 파르투스(마구간)
	[440] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 라하론(마구간)
	
	[444] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 고프란트(물약)
	[451] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 베벨(마구간)
	
	[454] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 옌센(물약)
	[458] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 크리에(물약)
	[461] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 넬리도르민(기술교관)
	[457] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 스피그(마구간)
	
	[314] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 말릭(물약)
	[327] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 	-- 루이보(물약)
	[329] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 스피그(마구간)
	
	[183] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 에르닐(창고)
	-- [183] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 바오리(창고)
	[113] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 아메리고(창고)
	[182] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 프레닐(창고)
	-- [464] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 라팔로(창고)
	[464] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 파비노 그레코(창고)
	[421] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 크리스틴 세서리(창고)
	[450] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 랑구스(창고)
	[733] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 마쿰(창고)	
	[864] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 라마닛(창고)	
	
	[597] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 데베(창고)
	[632] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 112, x2 = 363, y2 = 148, }, 	-- 이냐르(창고)
	
	[593] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 메이샤(마구간)
	[628] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 무암 만트(마구간)
	[749] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 멜슨 반도르(마구간)
	[667] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 굴라(마구간)
	[697] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 비알 나세르(마구간)
	[732] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 키아라 쿱(마구간)
	[740] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 75, x2 = 363, y2 = 111, }, 	-- 노드미어 쿱(마구간)
	
	[587] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 압둘 자움(기술교관)
	[622] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 엘라 세르빈(기술교관)
	[656] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 그라인(기술교관)
	[669] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 사르마 아닌(기술교관)
	[671] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 1,  x2 = 363, y2 = 37, }, 		-- 포리오(기술교관)
	
	[582] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 넬로플(물약)
	[617] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 사레(물약)
	[826] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 모아디(물약)
	[651] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 람로(물약)
	[661] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 반나프시(물약)
	[677] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 데살람(물약)
	[685] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 모하드(물약)
	[695] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 이타크 탈롬(물약)
	[639] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74, }, 		-- 수이(물약)

	[496] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 401, y1 = 1, x2 = 437, y2 = 37, }, 	-- 클레이아(거래소장)
	[497] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 401, y1 = 1, x2 = 437, y2 = 37, }, 	-- 엘르 벨루치(거래소장)
	[613] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 401, y1 = 1, x2 = 437, y2 = 37, }, 	-- 루시 벤쿰(거래소장)
	[11]  = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 401, y1 = 1, x2 = 437, y2 = 37, }, 	-- 쉬엘(거래소장)
}

local __npcType = {
	[1] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 327, y1 = 38, x2 = 363, y2 = 74,	},	-- 물약상인
	[2] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 253, y1 = 75,	x2 = 289, y2 = 111,	},	-- 무기상인
	[3] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 290, y1 = 1, 	x2 = 326, y2 = 37,	}, 	-- 보석상인
	[4] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 290, y1 = 38, 	x2 = 326, y2 = 74,	}, 	-- 가구상인	
	[5] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 290, y1 = 75, 	x2 = 326, y2 = 111, }, 	-- 재료상인	
	[6] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 290, y1 = 112, x2 = 326, y2 = 148, }, 	-- 물고기상인
	[7] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 253, y1 = 1, 	x2 = 289, y2 = 37,	}, 	-- 작업감독관
	[8] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 253, y1 = 38, 	x2 = 289, y2 = 74,	}, 	-- 연금술사
	[10] = { _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds", x1 = 253, y1 = 149, x2 = 289, y2 = 185,	}, 	-- PC방 상인
}



function FromClient_CreateKnowledge( knowledgeStatic )
	local mentalCardStaticWrapper = knowledgeStatic:FromClient_getKnowledgeInfo();
		
		----------------------------------------------------
	-- 컨텐츠 별 아이콘 바꿔준다
	local isUniqueTexture = false
	local textureData = __existMentalInfo[mentalCardStaticWrapper:getMainThemeKeyRaw()]
	if ( nil == textureData ) then
		textureData = __existMentalInfo[1] -- 새로운키가 등록되면 무조건 인물로 보여줌.
	end				
	local extraTextureData = __extraMentalInfo[ mentalCardStaticWrapper:getKey() ]
	if( nil ~= extraTextureData ) then
		textureData = extraTextureData
		isUniqueTexture = true
	end

	local npcShopType = __npcType[ mentalCardStaticWrapper:getOwnerNpcShopType() ]
	if( nil ~= npcShopType ) then
		textureData = npcShopType
		isUniqueTexture = true
	end
	
	knowledgeStatic:ChangeTextureInfoName( textureData._text )
	local x1, y1, x2, y2 = setTextureUV_Func( knowledgeStatic, textureData.x1, textureData.y1, textureData.x2, textureData.y2 )
	knowledgeStatic:getBaseTexture():setUV(  x1, y1, x2, y2  )
	knowledgeStatic:setRenderTexture(knowledgeStatic:getBaseTexture())

	
	local uiHintStatic = knowledgeStatic:FromClient_getKnowledgeHint()
	local uiHintQuestionStatic = knowledgeStatic:FromClient_getKnowledgeHintQuestion() 
	
	if ( mentalCardStaticWrapper:isHasCard() ) then
		if ( isUniqueTexture ) then
			knowledgeStatic:SetMonoTone( false )
			knowledgeStatic:SetColor( UI_color.C_FFFFFFFF )
		else
			knowledgeStatic:SetMonoTone( false )
			knowledgeStatic:SetColor( UI_color.C_FF40D7FD )
		end
		uiHintQuestionStatic:ChangeTextureInfoName( "New_UI_Common_ForLua/Default/Default_Etc_00.dds" )
		
		local x1, y1, x2, y2 = setTextureUV_Func( uiHintQuestionStatic, 102, 60, 110, 68 )
		uiHintQuestionStatic:getBaseTexture():setUV(  x1, y1, x2, y2  )
		uiHintQuestionStatic:setRenderTexture( uiHintQuestionStatic:getBaseTexture() )
			
		uiHintStatic:SetText( mentalCardStaticWrapper:getName() )
	else
		if ( isUniqueTexture ) then
			knowledgeStatic:SetMonoTone( true )
			knowledgeStatic:SetColor( UI_color.C_88FFFFFF )
		else
			knowledgeStatic:SetMonoTone( false )
			knowledgeStatic:SetColor( UI_color.C_88FFFFFF )
		end
		uiHintQuestionStatic:SetAlpha( 1 )
			
		uiHintQuestionStatic:ChangeTextureInfoName( "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds" )
		
		local x1, y1, x2, y2 = setTextureUV_Func(uiHintQuestionStatic, 130, 128, 156, 163 )
		uiHintQuestionStatic:getBaseTexture():setUV(  x1, y1, x2, y2  )
		uiHintQuestionStatic:setRenderTexture( uiHintQuestionStatic:getBaseTexture() )

		uiHintStatic:SetText( mentalCardStaticWrapper:getKeyword() )
	end

	uiHintStatic:SetSize( uiHintStatic:GetTextSizeX() + 40, uiHintStatic:GetSizeY() )
	uiHintStatic:SetShow(false)
	uiHintQuestionStatic:SetShow(true)
end

function FromClient_OnWorldMapKnowledge( knowledgeStatic )
	local uiHintStatic = knowledgeStatic:FromClient_getKnowledgeHint()
	local uiHintQuestionStatic = knowledgeStatic:FromClient_getKnowledgeHintQuestion() 
	
	uiHintStatic:SetShow(true)
	uiHintQuestionStatic:SetAlpha(0)
	if isLuaLoadingComplete then
		TooltipSimple_ShowMouseGuide( knowledgeStatic, false, true )
	end
end



function FromClient_OutWorldMapKnowledge( knowledgeStatic )
	local uiHintStatic			= knowledgeStatic:FromClient_getKnowledgeHint()
	local uiHintQuestionStatic	= knowledgeStatic:FromClient_getKnowledgeHintQuestion() 
	
	uiHintStatic:SetShow(false)
	uiHintQuestionStatic:SetAlpha(1)
	if isLuaLoadingComplete then
		TooltipSimple_Hide()
	end
end


registerEvent("FromClient_CreateKnowledge",			"FromClient_CreateKnowledge")
registerEvent("FromClient_OnWorldMapKnowledge",		"FromClient_OnWorldMapKnowledge")
registerEvent("FromClient_OutWorldMapKnowledge",	"FromClient_OutWorldMapKnowledge")
