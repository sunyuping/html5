//  commend.js   
//  xiaonei          
//  
//  Created by sunyuping on 10/02/12.  
//  Copyright 2010 renren.com. All rights reserved.  

//全局变量区域
var divID = 0;
var pic_width = 60;


/**
 * 获取屏幕的大少
 *
 * @return width:屏幕的宽度；height：屏幕的高度
 */
function getscreen(){
	var leftPos = (typeof window.screenLeft == "number") ? window.screenLeft : window.screenX;
	var topPos = (typeof window.screenTop == "number") ? window.screenTop : window.screenY;
	return {width:leftPos,height:topPos}
}
/**
 * 测试多个参数传入并且弹窗输出的函数  
 * @params 传入的参数列表  
 * 
 */
moreParameter = function(){
	var s='list:number='+arguments.length.toString()+'\n';
	for(var i=0;i<arguments.length;i++)
	{
        s+=arguments[i]+'\n';
	}
	alert(s);
}
/**
 * 让指定控件滚动到指定位置的函数  
 * @param p_id  指定控件的id
 * @param p_top 指定位置的距离页面原点0，0（不是屏幕原点）的顶边距离
 * @param p_left指定位置的距离页面原点0，0（不是屏幕原点）的左边距离
 * 
 */
function scrollop(p_id_str,p_left,p_top){
    var position = getElementPositionById(p_id_str);
    window.scrollTo(position.left,position.top);
}
/**
 * 获得指定控件位置信息的函数  
 * @param p_id  指定控件的id
 * @return left  指定控件左边距
 * @return top 	指定控件距离定点高度
 * @return width	指定控件宽度
 * @return height指定控件高度
 */
function getElementPositionById(p_id_str){
	var ielement = document.getElementById(p_id_str);
	return {left:ielement.offsetLeft,top:ielement.offsetTop,width:ielement.offsetWidth,height:ielement.offsetHeight}
}
/**
 * 在指定标签内部后面插入标签元素  
 * @param p_id  指定控件的id
 * //@param p_local_str 参数为’before‘则在元素之前插入标签元素，否则在之后插入标签元素
 * @return  无
 */
function insertElement(p_id){
	var cardiv = document.createElement("div"); 
	cardiv.style.position="static";
    cardiv.id="cardiv"+divID;
    cardiv.name="cardiv"+divID;
    cardiv.style.backgroundColor="#FF0000";
    cardiv.style.zIndex=divID;
    var imgstr="<img src=\"icon_phone.png\" width=\"40\" height=\"40\" alt=\"dd"+divID.toString()+"\">";
    cardiv.innerHTML=imgstr; 
	var ielement = document.getElementById(p_id);
	ielement.insertBefore(cardiv);
	divID++;
	//var speed = 50;
	//insertviewAnimation(cardiv,100,100,800,100,speed);
}
/**
 * 在整个budy体前后插入标签元素  
 * 
 * @param p_local_str 参数为’before‘则在元素之前插入标签元素，否则在之后插入标签元素
 * @return  无
 */
function bodyAppendinfo(p_local_str){
    var cardiv = document.createElement("div");
    // cardiv.style.position="absolute";
    // cardiv.style.left=currentX-(15/2)+"px";
    //cardiv.style.top=currentY-(31/2)+"px";
    //cardiv.style.width="150px";
    // cardiv.style.height="29px"; 
    cardiv.id="cardiv"+divID;
    cardiv.name="cardiv"+divID;
    cardiv.style.backgroundColor="#FF0000";
    cardiv.style.zIndex=divID;
    var imgstr="";
    imgstr="<img src=\"icon_phone.png\" width=\"40\" height=\"40\" alt=\"dd"+divID.toString()+"\">";
    cardiv.innerHTML=imgstr; 
    // onFocus=\"change()\"
    
    document.body.appendChild(cardiv);
    // document.body.indexOf();
    divID++;
    alert('nnd,在最后添加一行图片标签元素');
}
var totlewidth  = 0;
var totleheight = 0;
var i =0;
var one ;
var incremental_w = 0;
var incremental_h = 0;
function insertviewAnimation(p_element,p_left,p_top,p_width,p_height,p_speed){
	totlewidth = p_width;
	totleheight =p_height;
	p_element.style.position="absolute";
	p_element.firstChild.style.position = "absolute";
	//doAnimation(p_element,0,0,Math.floor(totlewidth/p_speed))
	one = p_element;
	incremental_w = Math.floor(totlewidth/p_speed);
	incremental_h = Math.floor(totleheight/p_speed);
	doan();
}
function doan(){
	one.style.width=incremental_w*i + "px";
    one.style.height=incremental_h*i + "px";
    one.firstChild.style.width = one.style.width;
    one.firstChild.style.height = one.style.height;
    if(incremental_w*i >= totlewidth || incremental_h*i >= totleheight){
        return;
    }
    window.setTimeout("i+=1;doan()",1);
}
function doAnimation(p_element,p_width,p_height,p_Incremental){
    p_element.style.width=p_width + "px";
    p_element.style.height=p_height + "px";
    if(p_width < totlewidth && totlewidth > 0 && totleheight > 0){
    	window.setTimeout("i+=1;do()",2000);
    	//alert('nnd');
    }else{
    	p_element.style.width=totlewidth + "px";
    	p_element.style.height=totleheight + "px";
    	totleheight= 0;
    	totlewidth = 0;
    }
}

function Op(o)
{
    var x=y=0;
    do{
        x+=o.offsetLeft;
        y+=o.offsetTop;
    }
    while (o=o.offsetParent);
    return {x:x,y:y};
}
function touchdiv(event){
    alert('dianji=='+event.clientY);
    var str = getDivPosition(event.clientX,event.clientY,310.0);
    alert('result=='+str);
    var divid;
    var int_x = window.pageXOffset;
    var int_y = window.pageYOffset;
    var int_displaywidth = window.outerWidth;
    var div_top = event.clientX;
    var div_left = event.clientY;
    //alert('w_x'+int_x+'w_h'+int_y+'div_x'+div_left+'div_y'+div_top);
    var tagid = document.elementFromPoint(div_top,div_left);
    //tagid.style.backgroundColor = "#00ff00";
    var tagname = tagid.tagName;
    while(1){
        if(tagid.tagName == "DIV"){
            divid = tagid;
            var div_x= Op(divid).x;
            var div_y= Op(divid).y;
            var div_w = divid.clientWidth;
            var div_h = divid.clientHeight;
            var child = document.createElement("div");
            
            child.style.position="absolute";
            // cardiv.style.left=currentX-(15/2)+"px";
            //cardiv.style.top=currentY-(31/2)+"px";
            //cardiv.style.width="150px";
            // cardiv.style.height="29px";
            
            child.style.top=div_y+"px";
            child.style.left=div_x+"px";
            child.style.width = div_w+"px";
            child.style.height = div_h+"px";
            child.style.backgroundColor = "#ff0000";
           // document.body.appendChild(child);
            break;
        }
        tagid = tagid.parentElement;
        if(tagid == null){
            break;
        }
    }
}

var index = 0;
function addevent(event) {
    //var obj = document.getElementById("main_output");
    getDivPosition(event.clientX,event.clientY,1200);
    
    var child = document.createElement("div");
    var now = new Date().getTime();
    if (event instanceof MouseEvent) {
        child.innerHTML = (++index) + " <b>" + event.type + "</b> x:" + event.clientX + " y:" + event.clientY + " t:" ;//+ (now - lastevent) + "ms";
    } else if ((typeof TouchEvent != "undefined") && (event instanceof TouchEvent)) {
        child.innerHTML = (++index) + " <b>" + event.type + "</b> x:" + event.changedTouches[0].clientX + " y:" + event.changedTouches[0].clientY + " t:" ;//+ (now - lastevent) + "ms";
    } else {
        child.innerHTML = (++index) + " <b>" + event.type + "</b> t:";// + (now - lastevent) + "ms";
    }
    lastevent = now;
    /*
     obj.appendChild(child);
     if (obj.childNodes.length > 23) { // iOS上div不支持滚动条。。。
     obj.removeChild(obj.firstChild);
     }
     */
}

function onevent(event) {
   // addevent(event);
   // alert('dianji=='+event.clientY);
    
    var childs = document.getElementsByTagName("DIV");
    for(child in childs){
        //child.style.onMouseDown = "touchdiv(event)"
    }
    /*
     try {
     if (event instanceof TouchEvent) {
     var obj = document.getElementById(event.type);
     if (obj != null) {
     obj.innerHTML = event;
     }
     } else if (! (event instanceof MouseEvent)) {
     var obj = document.getElementById(event.type);
     if (obj != null) {
     obj.innerHTML = "type:" + event.type + "<br />" + "scale:" + event.scale + "<br />" + "rotation:" + event.rotation;
     }
     }
     } catch(e) {}
     */
}

function addmyevent(){
    var childs = document.getElementsByTagName("DIV");
    for(var i = 0;i< childs.length;i++){
        var child = childs.item(i);
        // child.addEventListener("touchstart", testevent, false);
        //child.onMouseOut = testevent;
        // child.onclick  =  Function("alert('a');");
    }
}
function webPointToHtml(p_x,p_y,p_scale){
    var scrollPositionX = window.pageXOffset;
    var scrollPositionY = window.pageYOffset;
    p_x*=p_scale;
    p_y*=p_scale;
    p_x +=scrollPositionX;
    p_y +=scrollPositionY;
   // alert('webPointToHtml'+p_x+','+p_y+','+p_scale);
    return {x:p_x,y:p_y}
    
}
function htmlPointToWeb(p_x,p_y,p_scale){
    var scrollPositionX = window.pageXOffset;
    var scrollPositionY = window.pageYOffset;
    p_x -=scrollPositionX;
    p_y -=scrollPositionY;
    p_x/=p_scale;
    p_y/=p_scale;
    //alert('syp=='+','+p_x+','+p_y+',p_scale'+p_scale);
    return {x:p_x,y:p_y}
}

function getDivPosition(p_x,p_y,p_webWidth){
   // alert('getDivPosition'+p_x+','+p_y+','+p_webWidth);
    var divid;
    var point_str = '';
    var scale = 1;//p_webWidth/window.outerWidth;
    var html_point = webPointToHtml(p_x,p_y,scale);
   // alert('html_point'+html_point.x+','+html_point.y);
    
    var tagid = document.elementFromPoint(p_x,p_y,scale);
    while(1){
        if(tagid.tagName == "DIV"){
            divid = tagid;
            var div_x= Op(divid).x;
            var div_y= Op(divid).y;
            var div_w = divid.clientWidth;
            var div_h = divid.clientHeight;
            //alert('div'+div_x+','+div_y+','+div_w+','+div_h);
            if(div_h < pic_width){
                var webpoint =htmlPointToWeb(div_x,div_y,scale); 
                point_str = webpoint.x+','+webpoint.y+','+div_h;
               // alert('div_h < pic_width');
            }else{
                if(div_y+div_h-p_y < pic_width){
                    p_y = div_y+div_h - pic_width;
                }
               // var webpoint =htmlPointToWeb(p_x,p_y,scale); 
               // point_str = webpoint.x+','+webpoint.y+','+pic_width;
               point_str = p_x+','+p_y+','+pic_width;
            }
            //            var child = document.createElement("div");
            //            child.style.position="absolute";
            //            child.style.top=div_y+"px";
            //            child.style.left=div_x+"px";
            //            child.style.width = div_w+"px";
            //            child.style.height = div_h+"px";
            //            child.style.backgroundColor = "#ff0000";
            //            document.body.appendChild(child);
            break;
        }
        tagid = tagid.parentElement;
        if(tagid == null){
            break;
        }
    }
    tagid.style.backgroundColor = "#00ff00";
    return point_str;
}
function test(){
    
    getDivPosition(17,200,300);
}
















