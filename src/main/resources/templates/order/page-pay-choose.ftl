<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <#include "/head/page-common-head.ftl" encoding="utf8">
    <#include "/head/page-wechat-head.ftl" encoding="utf8">
</head>
<body class="light-gray-bg">
<#include "/common/tpl-msg-alert.ftl" encoding="utf8">
<#include "/common/tpl-loading-and-nomore-data.ftl" encoding="utf8">
<#include "/user/tpl-ajax-login-modal.ftl" encoding="utf8">

 <#if list?? && amount?? >
<div class="container " id="container" style="padding:0;overflow:scroll">
  <div class="row">
    <div class="col-xs-2"><a href="/user/index/basic"><img alt="" src="/icons/返回.png" style="width:18px;height:18px"></a></div>
    <div class="col-xs-10"><h3 style="text-align:center;margin:3px">选择支付方式</h3></div>
  </div>
  <!-- 商品信息 -->
  <div class="row" style="margin:0px 1px ;padding:5px 0;" >
    <#list list as order>
     <#include "/common/tpl-order-buy-content-4fm.ftl" encoding="utf8">
    </#list>
  </div> 
  
  <!-- 官方信息 -->
  <div class="row" style="margin:5px 1px ;padding:3px 3px;" >
   <img alt="" src="/img/mfyx_logo.jpeg" width=30px height=30px style="border-radius:50%"><span style="padding:0 10px;color:red">摩放优选</span>
  </div>  
  
  <!-- 支付方式选择 -->
  <div class="row" style="">
    <div class="col-xs-12 " style="margin:1px 5px ;padding:10px 25px;background-color:white" @click="choosePay(3)">
     <img alt="" src="/icons/支付宝logo.png" width="20px" height=20px>
     <span>支付宝</span>
     <img alt="" src="/icons/推荐标签.png" width="50px" height=20px>
     <span v-if="param.payType == 3" class="pull-right"><img src="/icons/选择.png" style="widht:20px;height:20px;"></span>
    </div>
    <div class="col-xs-12 " style="margin:1px 5px ;padding:10px 25px;background-color:white" @click="choosePay(2)">
     <img alt="" src="/icons/微信支付.png" width="20px" height=20px>
     <span>微信支付</span>
     <span v-if="param.payType == 2" class="pull-right"><img src="/icons/选择.png" style="widht:20px;height:20px;"></span>
    </div>
    <div class="col-xs-12" style="margin:1px 5px;padding:10px 25px;background-color:white" @click="choosePay(1)">
     <img alt="" src="/icons/余额.png" width="20px" height=20px>
     <span>会员余额</span>
     <span v-if="param.payType == 1 " class="pull-right"><img src="/icons/选择.png" style="widht:20px;height:20px;"></span>
    </div>
    <div class="col-xs-12" style="margin:1px 5px;padding:10px 25px;">
      <p>注意：使用 [会员余额] 之外的第三方支付将收取订单金额<span style="color:red"> 0.7%至3% </span>的手续费，手续费付给第三方支付平台！
      下述金额不包含手续费，手续费将额外收取！部分商家会将该手续费在交易确认完成后退到您的余额账户！！</p>
    </div>
  </div>
  
<!-- 支付 -->
<footer >
  <div class="row" style="margin:50px 0"></div>
  <div class="weui-tabbar" style="position:fixed;left:0px;bottom:1px">
    	<span class="weui-tabbar__item " >
	    <span class="weui-tabbar__label" >金额(含运费) <span style="color:red;font-size:18px">¥ ${amount}</span></span>
	</span>   
     <a href="javascript:;" class="weui-tabbar__item " style='background-color:red;text-align:center;vertical-align:center;' @click="prepay">
	    <span class="weui-tabbar__label" style="font-size:20px;color:white">提交支付</span>
     </a>     	
  </div>
</footer>
</div><!-- end of container -->

<script type="text/javascript">
var containerVue = new Vue({
	el:'#container',
	data:{
		param:{
			orderId:'${orderIds}',
			payType:0 //支付方式:1-会员余额,2-微信，3-支付宝
		}
	},
	methods:{
		choosePay:function(tp){
			this.param.payType = tp;
		},
		prepay: function(){
			$("#dealingData").show();
			if(!this.param.payType){
				alertMsg('系统提示','请先选择支付方式！');
				return;
			}
			$.ajax({
				url: '/order/prepay/' + this.param.payType + '/' + this.param.orderId,
				method:'post',
				data: {},
				success: function(jsonRet,status,xhr){
					$("#dealingData").hide();
					if(jsonRet && jsonRet.errmsg){
						if(jsonRet.errcode === 0){//创建支付成功
							if(jsonRet.payType == '1'){ //使用余额支付
								 window.location.href = "/order/pay/use/bal/" + containerVue.param.orderId;
							}else if(startWith(jsonRet.payType,'2')){//微信支付
								if(jsonRet.payType == '23'){
									window.location.href = "/order/pay/use/wxqrcode/" + containerVue.param.orderId;
								}else if (jsonRet.payType == '22'){//H5支付
									window.location.href = jsonRet.outPayUrl;
								}else if(jsonRet.payType == '21'){//公众号支付
									WeixinJSBridge.invoke(
								       'getBrandWCPayRequest', {
								           "appId":jsonRet.appId,     //公众号名称，由商户传入     
								           "timeStamp":jsonRet.timeStamp,         //时间戳，自1970年以来的秒数     
								           "nonceStr":jsonRet.nonceStr, //随机串     
								           "package":"prepay_id=" + jsonRet.prepay_id,     
								           "signType":"MD5",         //微信签名方式：     
								           "paySign":jsonRet.paySign //微信签名
										},
										function(res){     
											if(res.err_msg == "get_brand_wcpay_request:ok" ) {
												 window.location.href = "/order/pay/finish/" + containerVue.param.orderId;
											}else{
												alertMsg('系统提示','使用微信支付出现失败！'+ res.err_msg);		        	   
											}
										}
									); 
								}else{
									alertMsg('错误提示','调用微信支付失败！');
								}
							}else if(startWith(jsonRet.payType,'3')){//支付宝支付
								if(!jsonRet.AliPayForm){
									alertMsg('错误提示','调用支付宝支付失败！');
								}else{
									window.location.href = "/order/pay/use/aliform/" + containerVue.param.orderId;
								}
							}
						}else{//出现逻辑错误
							if(jsonRet.errcode === -100000){
								$('#ajaxLoginModal').modal('show');
							}else{
								alertMsg('错误提示',jsonRet.errmsg);
							}
						}
					}else{
						alertMsg('错误提示','系统数据访问失败！');
					}
				},
				failure:function(){
					$("#dealingData").hide();
				},
				dataType: 'json'
			});
		}
	}
});

</script>
</#if>


<#if errmsg??>
 <#include "/error/tpl-error-msg-modal.ftl" encoding="utf8">
</#if>


</body>
</html>

