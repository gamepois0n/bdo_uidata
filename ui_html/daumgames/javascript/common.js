//var imagePath = "D:\Dev/UI_Texture/Icon/New_Icon/Product_Icon_PNG/";
var imagePath = "coui://UI_Texture/Icon/New_Icon/Product_Icon_PNG/";
var items = new Array();
var string = new Array();
var result = new Array();
var uniqueKey = new Array();
var resultItemList	= new Array();
var resultLength	= 0;
var firstLoadLength	= 30;
var reload = 0;
var initCategory = "";
var initKey = "";
var historyItemKey = new Array();
var historyItemName = new Array();
var historyCount = 0;
var globalItemKey = 0;
var globalItemName = '';

function sortUnique(arr) {
    arr.sort();
    var last_i;
    for (var i=0;i<arr.length;i++)
        if ((last_i = arr.lastIndexOf(arr[i])) !== i)
            arr.splice(i+1, last_i-i);
    return arr;
}

function historyPrint(itemKey, itemName){
	var historySize = historyItemKey.length;
	var historyStr = '';

	historyItemKey[historySize] = itemKey;
	historyItemName[historySize] = itemName;
//	$("#container .history").val();

	for(i=0; i<=historySize; i++){
		if(i==0){
			historyStr += "<span>"+historyItemName[i]+"</span>";
		}else{
			if(historySize==i){
				historyStr += "><span class='nowHistory'>"+historyItemName[i]+"</span>";
			}else{
				historyStr += "><span>"+historyItemName[i]+"</span>";
			}
		}
	}
	$("#container .history").html(historyStr);
	console.log(historyStr);
}

jQuery(function(){
	
	$("#txt_search").keypress(function( event ) {
		if ( event.which == 13 ) {
			event.preventDefault();
			$("#btn_search").click();
		}
	});
	
	$("#txt_search").focus(function() {
		engine.call("ToClient_SetInputMode", 2)	
	});
	
	$("#txt_search").blur(function() {
		engine.call("ToClient_SetInputMode", 1)	
	});
	
  	$("#btn_search").click(function() {
		reload = 0;
		uniqueKey = new Array();
		result = new Array();
		var search_word = $("#txt_search").val();
		
		if($.trim(search_word) == ""){
			renderMessage(string[200]["name"]);
			return false;
		}
		
		var regex = /[~`!#$%\^&*+=\-\[\]\\';,/{}|\\":<>\?]/g;
		if (regex.test($.trim(search_word))) {
			renderMessage(string[203]["name"]);
			return false;
		}
		
		try {
			var regex = new RegExp(search_word);
			result = jQuery.grep(items, function(arr) {
				return regex.test(arr.name);
			});
		} catch (e) {
	    	renderMessage(string[204]["name"]);
	    }
		
		if((typeof result == "undefined") || (result.length < 1)){	
			$("#itemList").empty();
			$("#itemList").scrollTop(0);
			
			renderMessage(string[205]["name"]);
			return false;
		}

		$(".category_tab").removeClass("tab-on");
		
		// item list
		renderItemList(result);
		
		// item info
		var key = result[0].key;
		createItemInfo(key);
	});
	
	$(".show_category").click(function() {
		reload = 0;
		uniqueKey = new Array();
		result = new Array();
		// reset search text
		$("#txt_search").val("");
		
		var category = $(this).data("category");
		result = searchByCategory(category);
		
		if((typeof result == "undefined") || (result.length < 1)){
			renderMessage(string[202]["name"]);
			return false;
		}
		
		// category
		renderCategoryTitle(category);
		
		// item list
		renderItemList(result);
		
		// item info
		var key = result[0].key;
		createItemInfo(key);
	});
	
	$(document).on("click",".show_item",function(){
		var key = $(this).data("key");
		createItemInfo(key);
		$("#itemInfo").scrollTop(0);
	});

	$(document).on("click",".show_itemList",function(){
		var key = $(this).data("key");
		createItemInfo(key);
		$("#itemInfo").scrollTop(0);
	});

	$(document).on("mouseover",".show_itemList",function(){
		$(this).css("background-color","#E7E7E7");
		$(this).prev('td').css("background-color","#E7E7E7");
	});

	$(document).on("mouseout",".show_itemList",function(){
		$(this).css("background-color","#EFEFEF");
		$(this).prev('td').css("background-color","#EFEFEF");
	});

	$(document).on("click",".show_itemR",function(){
		var key = $(this).data("key");
		createItemInfo(key);
		$(".category_tab").removeClass("tab-on");
		$("#itemList").scrollTop(0);
		$("#itemInfo").scrollTop(0);
	});

	$("#itemList").scroll( function() {	// 스크롤 끝에서 추가 데이터 로딩
	  var elem = $("#itemList");
	  if ( elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight() && elem.scrollTop() != 0)
		{
			if(reload == 0)
			{
				renderItemListAdd();
			}
			reload = 1;
		}
	});
});

function initString(xml){
	$(xml).find('productNote').children().each(function(){	
		
		var index = "";
		var name = "";
		$(this).find('message').each(function(){	
			index = $(this).attr('index');
			name = $(this).attr('name');
			string[index] = { "name": name };
		});
	});

	$('[data-string]').each(function(){	// html country language replace
		var strNo = $(this).data("string");
		$(this).html( string[strNo]["name"] );
		if( strNo == 200 ) $(this).attr( "placeholder",string[strNo]["name"] );
		if( strNo == 207 ) $(this).val( string[strNo]["name"] );
	})
}

function initData(xml){
	
	var itemCount = 0;
	
	$(xml).find('itemmaking').children().each(function(){	
		
		var category = this.nodeName; 
		var key = "";
		var name = "";
		var icon = "";
		
		$(this).find('item').each(function(){	
			
			name = $(this).attr('name');
			key = $(this).attr('key');
			icon = $(this).attr('icon');
			var item = {"category": category, "key":key, "name":name, "icon":icon};
			items.push(item);
			itemCount++;
			
			if(itemCount == 1){
				initCategory = category;
				initKey = key;
			}
		});
		//console.log(this.nodeName + " count : " + itemCount);
	});
	//console.log("result count :" + items.length);
	
	renderStart();
}

function searchByCategory(category){
	try {
		var regex = new RegExp(category);
		result = jQuery.grep(items, function(arr) {
			return regex.test(arr.category);
		});
		return result;
    } catch (e) {
    	renderMessage(string[206]["name"] + e.message);
    }
}

function renderItemList(result){	// firstLoadLength 만큼 우선 로딩
	$("#itemList table").empty();
	
	var html = "";
	resultItemList = result;
	
	if(result.length > 50)
	{
		resultLength = firstLoadLength;
	}else{
		resultLength = result.length;
	}
	for(var idx=0; idx<resultLength;idx++){
		engine.call('FromWeb_CheckItem', idx, result[idx].key).then(function (resultIndex) {
			var itemKey 	= resultItemList[resultIndex].key
			var category 	= resultItemList[resultIndex].category
			var name 		= resultItemList[resultIndex].name
			var icon 		= resultItemList[resultIndex].icon
			if(0 <= resultIndex && uniqueKey[itemKey] != true )
			{
				uniqueKey[itemKey] = true;
				html = "<tr>";
				html += 		"<td>";
				html += 			"<a id='key_" + itemKey  + "' class='show_item' href='javascript:;' data-category='" + category + "' data-key='" + itemKey + "'><img id='itemIcon' src='" + imagePath + icon + "' alt='' /></a>";
				html += 		"</td>";
				html += 		"<td valign=middle data-key='" + itemKey + "' class='show_itemList'>";
				html += 			"<a class='show_item' href='javascript:;' data-category='" + category + "' data-key='" + itemKey + "'>" + name +"</a>";
				//html += 			"<a class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'>" + result[i].name +"="+result[i].key+"</a>";
				html += 		"</td>";
				html += "</tr>";
				
				$("#itemList table").append(html);
			}
		});

	}

//	for(var i=0; i<resultLength;i++){
//		if(0 <= i && uniqueKey[result[i].key] != true )
//		{
//			uniqueKey[result[i].key] = true;
//			html += "<tr>";
//			html += 		"<td>";
//			html += 			"<a id='key_" + result[i].key  + "' class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'><img id='itemIcon' src='" + imagePath + result[i].icon + "' alt='' /></a>";
//			html += 		"</td>";
//			html += 		"<td valign=middle data-key='" + result[i].key + "' class='show_itemList'>";
////			html += 			"<a class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'>" + result[i].name +"</a>";
//			html += 			"<a class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'>" + result[i].name +"="+result[i].key+"</a>";
//			html += 		"</td>";
//			html += "</tr>";
//			console.log(uniqueKey[result[i].key]);
//		}
//	}
	$("#itemList").scrollTop(0);
}

function renderItemListAdd(){	// 추가 데이터 로딩
	resultItemList = result;
	var html = "";

	for(idx=firstLoadLength; idx<result.length;idx++){
		engine.call('FromWeb_CheckItem', idx, result[idx].key).then(function (resultIndex) {
			var itemKey 	= resultItemList[resultIndex].key
			var category 	= resultItemList[resultIndex].category
			var name 		= resultItemList[resultIndex].name
			var icon 		= resultItemList[resultIndex].icon
			if(0 <= resultIndex && uniqueKey[itemKey] != true )
			{
				uniqueKey[itemKey] = true;
				html = "<tr>";
				html += 		"<td>";
				html += 			"<a id='key_" + itemKey  + "' class='show_item' href='javascript:;' data-category='" + category + "' data-key='" + itemKey + "'><img id='itemIcon' src='" + imagePath + icon + "' alt='' /></a>";
				html += 		"</td>";
				html += 		"<td valign=middle data-key='" + itemKey + "' class='show_itemList'>";
				html += 			"<a class='show_item' href='javascript:;' data-category='" + category + "' data-key='" + itemKey + "'>" + name +"</a>";
				//html += 			"<a class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'>" + result[i].name +"="+result[i].key+"</a>";
				html += 		"</td>";
				html += "</tr>";
				$("#itemList table").append(html);
			}
		});
	}
//	for(i=firstLoadLength; i<result.length;i++){
//		if(0 <= i && uniqueKey[result[i].key] != true )
//		{
//			uniqueKey[result[i].key] = true;
//			html += "<tr>";
//			html += 		"<td>";
//			html += 			"<a id='key_" + result[i].key  + "' class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'><img id='itemIcon' src='" + imagePath + result[i].icon + "' alt='' /></a>";
//			html += 		"</td>";
//			html += 		"<td valign=middle data-key='" + result[i].key + "' class='show_itemList'>";
////			html += 			"<a class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'>" + result[i].name +"</a>";
//			html += 			"<a class='show_item' href='javascript:;' data-category='" + result[i].category + "' data-key='" + result[i].key + "'>" + result[i].name +"="+result[i].key+"</a>";
//			html += 		"</td>";
//			html += "</tr>";
//		}
//	}
//	$("#itemList").append(html);
}
 
function renderCategoryTitle(category){
	var subtitle = "";
	switch(category){
		case "nodeProduct" :
			subtitle = string[0]["name"];
			break;
		case "fishing" :
			subtitle = string[1]["name"];
			break;	
		case "alchemy" :
			subtitle = string[2]["name"];
			break;	
		case "cooking" :
			subtitle = string[3]["name"];
			break;	
		case "manufacture" :
			subtitle = string[4]["name"];
			break;	
		case "houseCraft" :
			subtitle = string[5]["name"];
			break;	
		case "collect" :
			subtitle = string[6]["name"];
			break;				
		default:
			subtitle = "";
	}
	
	$( "#subtitle" ).text(subtitle);
	
	// update tab ui
	$(".category_tab").removeClass("tab-on");
	$("#"+category).addClass("tab-on");	
}


function createItemInfo(itemKey){
	var param = "../../xml/" + itemKey + ".xml"
	$.ajax({
		type	  : "GET",
		url       : param,
		dataType  : "xml",
		success   : responseCreateItemInfo,
		error : function(xhr, status, error){
			var html = "<p align=\"center\" style=\"margin-top:30px\"><b>"+ string[202]["name"]; +"</b></p>";
			$("#itemInfo").html(html);
		}
	});
}

function responseCreateItemInfo(xml){
	$item = $(xml).find('itemInfo');
	var itemKey = $item.find('itemKey').text();
	var itemName = $item.find('itemName').text();
	var itemIcon = $item.find('itemIcon').text();
	var itemDesc = $item.find('itemDesc').text();
	var diff = '';
	var diff2 = '';
	itemDesc = itemDesc.replace(/\\n/ig,"<BR/>")
	itemIcon = imagePath + itemIcon

//	if(globalItemKey != itemKey && historyCount !=0 ){
//		historyPrint(itemKey, itemName);
//	}
//
//	historyCount++;
//
//	globalItemKey = itemKey;

	var itemInfo = ""
	itemInfo +=	"<tr class='none'>";
	itemInfo +=		"<td rowspan='2' align='center' valign='middle' style='text-align:center'><img class='mainIcon' src="+itemIcon+" alt='' ></td>";
	itemInfo +=		"<td><strong>"+itemName+"</strong></td>";
	itemInfo +=	"</tr>";
	itemInfo +=	"<tr class='itemDescTR'>";
	itemInfo +=		"<td class='itemDesc' scope='col'>"+itemDesc+"</td>";
	itemInfo +=	"</tr>";
	itemInfo +=	"<tr>";
	itemInfo +=		"<th>"+string[103]["name"]+"</th>";
	itemInfo +=		"<td>";
	itemInfo +=		"<table width='100%'>";
	itemInfo +=		"<tbody>";
	
	if($(xml).find('collect').length > 0){
		var splitItem = new Array();
		var i = 0;
		itemInfo += "<tr><td><strong>"+ string[6]["name"] +"</strong></tr></td>";
		$(xml).find('collect').each(function(){
			$(this).find('character').each(function(){
				splitItem[i] = $(this).find('name').text();
			});
			i++;
		});
		itemInfo += "<tr>";
		itemInfo += 		"<td><tab>"+splitItem.join(", ")+"</tab></td>";
		itemInfo += "</tr>";
	}
	
	$(xml).find('manufacture').each(function(){	
		var action = $(this).attr("action");
		switch(action){
			case "MANUFACTURE_DRY"					: action = string[10]["name"];		break;
			case "MANUFACTURE_GRIND"				: action = string[11]["name"];		break;
			case "MANUFACTURE_SHAKE"				: action = string[12]["name"];		break;
			case "MANUFACTURE_HEAT"					: action = string[13]["name"];		break;
			case "MANUFACTURE_THINNING" 			: action = string[14]["name"];		break;
			case "MANUFACTURE_FIREWOOD" 			: action = string[15]["name"];		break;
			case "MANUFACTURE_ROYALGIFT_COOK" 		: action = string[16]["name"];		break;
			case "MANUFACTURE_ROYALGIFT_ALCHEMY" 	: action = string[17]["name"];		break;
			default: action = "";
		}
		if(action==""){
			itemInfo += "<tr><td><strong>"+ string[4]["name"] +"</strong></td></tr>";	
		}else{
			itemInfo += "<tr><td><strong>"+ string[4]["name"] +"&nbsp;( " + action + " )</strong></td></tr>";	
		}
		itemInfo += "<tr><td>";
		$(this).find('item').each(function(){
			itemInfo += createSubImgItem($(this));
		});
		itemInfo += "</td></tr>";
	});
	
	$(xml).find('house').each(function(){
		diff = '';
		var menuType = $(this).attr('type');
		if(menuType.length > 0){
			menuType = '90' + menuType;
			diff += "<tr><td><strong>"+ string[5]["name"] +"&nbsp;("+string[menuType]["name"]+")</strong></td></tr>";	
		}else{
			diff += "<tr><td><strong>"+ string[5]["name"] +"("+string[103]["name"]+")</strong></td></tr>";	
		}
		diff += "<tr><td>";
		$(this).find('item').each(function(){
			diff += createSubImgItem($(this));
		});
		diff += "</td></tr>";
		if (diff != diff2){
			diff2 = diff;
			itemInfo += diff;
		}
	});
	
	$(xml).find('fishing').each(function(){	
		itemInfo += "<tr><td><strong>"+ string[1]["name"] +"</strong></td></tr>";
	});
	

	var alchemyCnt = 1;
	$(xml).find('alchemy').each(function(){
		if($(xml).find('alchemy').size()==1){
			itemInfo += "<tr><td><strong>"+ string[2]["name"] +"</strong></td></tr><tr><td>";	
		}else{
			itemInfo += "<tr><td><strong>"+ string[2]["name"] +" #"+alchemyCnt+"</strong></td></tr><tr><td>";	
		}
		var i = 0;
		var diffIndex = new Array();
		$(this).find('item').each(function(){
			diff = createSubItem($(this));
			if (diffIndex.indexOf(diff)){
				diffIndex[i] = diff;
				itemInfo += diff;
			}
			i++;
		});
		itemInfo += "</td></tr>";
		alchemyCnt++;
	});
	
	if($(xml).find('node').length > 0){
		itemInfo += createNode(xml, 'region', string[20]["name"]);
	}
	
	if($(xml).find('shop').length > 0){
		var splitItem = new Array();
		var i = 0;
		itemInfo += "<tr><td><strong>"+ string[21]["name"] +"</strong></tr></td>";
		$(xml).find('shop').each(function(){
			$(this).find('character').each(function(){
				splitItem[i] = $(this).find('name').text();
			});
			i++;
		});
		var printItem = sortUnique(splitItem);
		itemInfo += "<tr>";
		itemInfo += 		"<td><tab>"+printItem.join(", ")+"</tab></td>";
		itemInfo += "</tr>";
	}
	
	var cookCnt = 1;
	$(xml).find('cook').each(function(){
		if($(xml).find('cook').size()==1){
			itemInfo += "<tr><td><strong>"+ string[3]["name"] +"</strong></td></tr><tr><td>";	
		}else{
			itemInfo += "<tr><td><strong>"+ string[3]["name"] +" #"+cookCnt+"</strong></td></tr><tr><td>";	
		}
		var i = 0;
		var diffIndex = new Array();
		$(this).find('item').each(function(){
			diff = createSubItem($(this));
			if (diffIndex.indexOf(diff)){
				diffIndex[i] = diff;
				itemInfo += diff;
			}
			i++;
		});
		itemInfo += "</td></tr>";
		cookCnt++;
	});

	if($(xml).find('makelist').length > 0){
		itemInfo +=		"</tbody>";
		itemInfo +=		"</table>";
		itemInfo +=		"</td>";
		itemInfo +=	"</tr>";
		itemInfo +=	"<tr>";
		itemInfo +=		"<td class='make'>"+ string[22]["name"] +"</td>";
		itemInfo +=		"<td>";
		itemInfo +=		"<table width='100%'>";
		itemInfo +=		"<tbody>";

		$(xml).find('makelist').each(function(){	
			itemInfo += "<tr><td><strong>"+itemName+" "+ string[23]["name"] +"</strong></td></tr>";	
			itemInfo += "<tr><td>";
			$(this).find('item').each(function(){
				itemInfo += createSubImgItem($(this));
			});
			itemInfo += "</td></tr>";
		});
	}
	
	itemInfo +=		"</tbody>";
	itemInfo +=		"</table>";
	itemInfo +=		"</td>";
	itemInfo +=	"</tr>";
	
	$( "#itemInfo" ).html(itemInfo);
}
  
function createSubItem(item){
	var id = item.find('id').text();
	var name = item.find('name').text();
	var icon = item.find('icon').text();
	var desc = item.find('desc').text();
			
	var subItem = "";
	
	var subItem ="<tab2><img class='recipeIcon' src='" + imagePath + icon + "' alt=''>&nbsp;<a href=\"javascript:;\" class='show_itemR' data-key='" + id + "'>"+name+"</a></tab2>";
	
	return subItem;
}

function createSubImgItem(item){
	var id = item.find('id').text();
	var name = item.find('name').text();
	var icon = item.find('icon').text();
	var desc = item.find('desc').text();
	
	var subItem ="<tab2><img class='recipeIcon' src='" + imagePath + icon + "' alt=''>&nbsp;<a href=\"javascript:;\" class='show_itemR' data-key='" + id + "'>"+name+"</a></tab2>";
	
	return subItem;
}

function createCharacter(item){
	var name = item.find('name').text();
	var subItem = "";
	
	subItem += "<tr>";
	subItem += 		"<td><tab>"+name+"</tab></td>";
	subItem += "</tr>";
	
	return subItem;
}

function createSplit(xml, items, Cate){
	var subItem = "<tr><td><strong>"+Cate+"</strong></tr></td>";
	var splitItem = new Array();
	var i = 0;
	$(xml).find(items).each(function(){
		var name = $(this).find('name').text();
		splitItem[i] = name;
		i++;
	});
	
	subItem += "<tr>";
	subItem += 		"<td><tab>"+splitItem.join(", ")+"</tab></td>";
	subItem += "</tr>";
	
	return subItem;
}
  
function createNode(xml, items, Cate){
	var subItem = "<tr><td><strong>"+Cate+"</strong></tr></td>";
	var splitItem = new Array();
	var i = 0;
	$(xml).find('node').each(function(){
		var name = $(this).attr('region');
		splitItem[i] = name;
		i++;
	});
	
	subItem += "<tr>";
	subItem += 		"<td><tab>"+splitItem.join(", ")+"</tab></td>";
	subItem += "</tr>";
	
	return subItem;
}

function renderStart(){
	
	var parameters = unescape(location.search).substring(1).split(/\&|\=/g);
	
	var byParameter = false;
	var onlyCategory = false;
	
	if((parameters != "") && (typeof parameters != "undefined")){	
		
		byParameter = true;
		
		if(typeof parameters[0] != "undefined"){
			initCategory = parameters[0].toString();
		}
		
		if(typeof parameters[1] != "undefined"){
			initKey = parameters[1].toString();
		} else {
			onlyCategory = true;
		}
	}
	
	var result = searchByCategory(initCategory);
	
	if((typeof result == "undefined") || (result.length < 1)){
		renderMessage(string[202]["name"]);
		return false;
	}
	
	// category
	renderCategoryTitle(initCategory);
	
	if(byParameter && onlyCategory){
		initKey = result[0].key;
	}
	
	// item list
	renderItemList(result, initKey);
	
	// item info
	createItemInfo(initKey);
	
	// item scroll by parameter
	if(byParameter && !onlyCategory){
		
		if($('#key_' + initKey).length > 0){
			setTimeout(function(){
				$('#key_' + initKey).get(0).scrollIntoView();
			},300);
		}
	}
}

function renderMessage(message){
	$("#itemInfo").empty();
	var html = "<p align=\"center\" style=\"margin-top:30px\"><b>" + message + "</b></p>";
	$("#itemInfo").html(html);
	return;
}

$(document).ready(function(){
	$.ajax({
		type	  : "GET",
		url       : "../../xml/string.xml",
		dataType  : "xml",
		success   : initString,
		error : function(xhr, status, error){
			renderMessage("string file not found");
		}
	});

	$.ajax({
		type	  : "GET",
		url       : "../../xml/itemmaking.xml",
		dataType  : "xml",
		success   : initData,
		error : function(xhr, status, error){
			renderMessage(string[202]["name"]);
		}
	});
});