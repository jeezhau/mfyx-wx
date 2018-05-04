<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
	<title>摩放优选</title>
	<!-- Bootstrap -->
	<link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!--Vue -->
    <script src="https://cdn.jsdelivr.net/npm/vue"></script>
    <!-- -->
    <link href="/css/font-awesome.min.css" rel="stylesheet">
    <link href="/css/templatemo-style.css" rel="stylesheet">
    
    <script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
    
    <link href="/css/weui.css" rel="stylesheet">
    
    <link href="/css/mfyx.css" rel="stylesheet">
</head>
<body class="light-gray-bg" >
<header >
  <#include "/menu/page-category-menu.ftl" encoding="utf8"> 
</header>
<div class="container goods-container" id="container" style="padding:0 1px;overflow:scroll">
  <div class="row" style="margin:0 0;overflow:scroll">
    <div v-for="goods in goodsList" class="col-xs-6" style="padding:0px 0px;">
	    <div style="margin:2px 1px;background-color:white;text-align:center;vertical-align:center" >
	      <a v-bind:href="'/goods/show/' + goods.goodsId">
	        <img alt="" :src="'/image/file/show/' + goods.mainImgPath" style="width:90%;height:150px">
	      </a>
	    </div>
	    <div style="margin:1px 1px;" >
	      <div style="margin:1px 0;padding:0 5px;background-color:white" >
		        {{goods.goodsName}}
	      </div>
	      <div style="margin:1px 0px;padding:0 5px;background-color:white;color:red" >
	      	<span class="pull-left ">惠¥: <span>{{goods.priceLowest}}</span>元</span>
	      	<span class="pull-right ">库存: <span>{{goods.stockSum}}</span>件</span>
	      </div>
	      <div style="margin:1px 0px 2px 0;padding:0 5px 3px 5px;background-color:white;text-align:center" >
	        <a class="btn btn-danger " style="padding:3px 12px" :href="'/order/place/'+ goods.goodsId"><span style="color:white">立即下单</span></a>
	        <a class="btn btn-primary" style="padding:3px 12px" :href="'/order/order/begin/' + goods.goodsId"><span style="color:white">加入收藏</span></a>
	      </div>
	    </div>
    </div>
  </div>
</div><!-- end of container -->
<script type="text/javascript">
 var containerVue = new Vue({
	 el:'#container',
	 data:{
		param:{
			categoryId:'', 
			keywords:'',
			pageSize:20,
			begin:0
		},
		goodsList:[] 
	 },
	 methods:{
		 getAll: function(){
			 containerVue.goodsList = [];
			 $.ajax({
					url: '/shop/getall',
					method:'post',
					data: this.param,
					success: function(jsonRet,status,xhr){
						if(jsonRet ){
							if(jsonRet.errcode == 0){//
								for(var i=0;i<jsonRet.datas.length;i++){
									containerVue.goodsList.push(jsonRet.datas[i]);
								}
								containerVue.param.pageSize = jsonRet.pageCond.pageSize;
								containerVue.param.begin = jsonRet.pageCond.begin;
							}else{
								//alert(jsonRet.errmsg);
							}
						}else{
							alert('获取数据失败！')
						}
					},
					dataType: 'json'
				});			 
		 }
	 }
 });
 containerVue.getAll();
 //分类查询
 function getGoodsByCat(categoryId){
	 containerVue.param.categoryId = categoryId;
	 containerVue.param.begin = 0;
	 containerVue.getAll();
 }
 function getGoodsByKey(keywords){
	 if(keywords){
		 containerVue.param.keywords = keywords;
		 containerVue.param.begin = 0;
		 containerVue.getAll();
	 }
 } 
 
 var winHeight = $(window).height(); //页面可视区域高度   
 var scrollHandler = function () {  
     var pageHieght = $(document.body).height();  
     var scrollHeight = $(window).scrollTop(); //滚动条top   
     var r = (pageHieght - winHeight - scrollHeight) / winHeight;
     if (r < 0.5) {//上拉翻页 
    	 	containerVue.begin = containerVue.begin + containerVue.pageSize;
    	 	containerVue.getAll();
     }
     if(scrollHeight<0){//下拉刷新
    	 	containerVue.param.begin = 0;
    	 	containerVue.getAll();
     }
 }  
 //定义鼠标滚动事件  
 $("#container").scroll(scrollHandler); 
 

</script>  
<footer >
  <#include "/menu/page-bottom-menu.ftl" encoding="utf8"> 
</footer>
</body>
</html>