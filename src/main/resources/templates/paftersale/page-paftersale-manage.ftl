<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <#include "/head/page-common-head.ftl" encoding="utf8">
</head>
<body class="light-gray-bg" style="oveflow:scroll">

<#include "/common/tpl-loading-and-nomore-data.ftl" encoding="utf8"> 
<#include "/common/tpl-msg-alert.ftl" encoding="utf8"> 

<div class="container " id="container" style="padding:0">
  <div class="row" style="margin:5px ;text-align:center" >
    <ul class="nav navbar-nav nav-tabs" style="width:100%;padding:0 5px;font-size:18px;font-weight:bold;">  
        <li class="<#if status='refunding'> active </#if>" style="width:50%" @click="window.location.href='/paftersale/manage/refunding'"> 
          <a href="javascript:;"> 退款 </a> 
        </li> 
        <li class="<#if status='exchanging'> active </#if>" style="width:50%" @click="window.location.href='/paftersale/manage/exchanging'"> 
          <a href="javascript:;" > 换货 </a> 
        </li>                      
     </ul>
  </div>
  <div class="row" style="margin:0"><!-- 所有订单之容器 -->
	  <div v-for="order in orders" class="col-xs-12 col-sm-12 col-md-6 col-lg-4" style="padding:3px ">
	    <#include "/porder/tpl-porder-buy-user-4vue.ftl" encoding="utf8">
	    <#include "/common/tpl-order-buy-content-4vue.ftl" encoding="utf8">
		<div class="row" style="margin:1px 0;padding:0px 18px 0px 18px;background-color:white;">
		    <a v-if="startWith(order.status,'3') ||  startWith(order.status,'4') || startWith(order.status,'5') || startWith(order.status,'6')" class="btn btn-default pull-right" :href="'/psaleorder/logistics/' + order.orderId" style="padding:0 3px;margin:0 3px"><span >查看物流</span></a>
		    
		    <a v-if="param.status=='refunding' && ( order.status==='60' || order.status==='62' || order.status==='63' )" class="btn btn-primary pull-right" :href="'/paftersale/refund/begin/' + order.orderId" style="padding:0 3px;margin:0 3px"><span >处理退款</span></a>
		    
		    <a v-if="param.status=='exchanging' && (order.status==='50' || order.status==='52' || order.status==='53')" class="btn btn-primary pull-right" :href="'/paftersale/exchange/begin/' + order.orderId" style="padding:0 3px;margin:0 3px"><span >处理换货</span></a>
		    
		</div>
	  </div>
  </div>
  
</div><!-- end of container -->
<script type="text/javascript">
var containerVue = new Vue({
	el:'#container',
	data:{
		param:{
			status:"${status!'refund'}",
			begin:0,
			pageSize:30,
			count:0
		},
		orders:[]
	},
	methods:{
		getOrders:function(stat){
			$("#loadingData").show();
			$("#nomoreData").hide();
			if(stat){
				this.param.status = stat;
			}
			containerVue.orders = [];
			$.ajax({
				url: '/paftersale/getall/' + this.param.status,
				method:'post',
				data: this.param,
				success: function(jsonRet,status,xhr){
					if(jsonRet && jsonRet.datas){
						for(var i=0;i<jsonRet.datas.length;i++){
							var item = jsonRet.datas[i];
							item.goodsSpec = JSON.parse(item.goodsSpec);
							item.headimgurl = startWith(item.headimgurl,'http')? item.headimgurl: ('/user/headimg/show/'+item.userId);
							containerVue.orders.push(item);
						}
						containerVue.param.begin = jsonRet.pageCond.begin;
						containerVue.param.pageSize = jsonRet.pageCond.pageSize;
						containerVue.param.count = jsonRet.pageCond.count;
					}else{
						if(jsonRet && jsonRet.errmsg){
							//alert(jsonRet.errmsg);
							//$("#nomoreData").show();
						}
					}
					$("#loadingData").hide();
				},
				failure:function(){
					$("#loadingData").hide();
				},
				dataType: 'json'
			});
		}
	}
});
containerVue.getOrders("${status!'refunding'}");

//分页初始化
scrollPager(containerVue.param,containerVue.orders,containerVue.getOrders) ;

</script>


<footer>
  <#include "/menu/page-partner-func-menu.ftl" encoding="utf8">
</footer>

</body>
</html>
