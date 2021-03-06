<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <#include "/head/page-common-head.ftl" encoding="utf8">
</head>
<body class="light-gray-bg">
<#include "/common/tpl-msg-alert.ftl" encoding="utf8">
<#include "/user/tpl-ajax-login-modal.ftl" encoding="utf8">

<div class="container " id="container" style="oveflow:scroll">
   <div class="row">
     <a class="col-xs-2" href="/cash/manage" style="vertical-algin:center;text-align:center"><img width="15px" height="15px" alt="" src="/icons/返回.png"></a>
     <h3 class="col-xs-9" style="margin:5px 0;text-align:center" >我的提现申请</h3>
   </div>
   <div class="row">
     <div v-for="item in dataList" class="list-group">
	  <div class="list-group-item" onclick="$(this).addClass('active');$(this).siblings().removeClass('active')">
		<h5 class="list-group-item-heading">
			{{item.accountName}} {{item.accountNo}} 
		</h5>
		<div class="list-group-item-text">
			<div class="row">
			  <div class="col-xs-6" style="padding:0 5px">申请时间：{{item.applyTime}}</div>
			  <div class="col-xs-6" style="padding:0 5px">当前状态：{{getCashApplyStatus(item.status)}}</div>
			</div>
			<div class="row">
			  <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3" style="padding:0 5px">提现方式：{{getCashType(item.cashType)}}</div>
			  <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3" style="padding:0 5px">账户类型：{{getAccountType(item.accountType)}}</div>
			  <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3" style="padding:0 5px">通道类型：{{getChannelType(item.channelType)}}</div>
			  <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3" style="padding:0 5px">账户银行：{{item.accountBank}}</div>
			  <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3" style="padding:0 5px">提现金额：{{new Number(item.cashAmount/100).toFixed(2)}}</div>
			  <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3" style="padding:0 5px">手&nbsp;续&nbsp;&nbsp;费：{{new Number(item.cashFee/100).toFixed(2)}}</div>
			</div>
			<div class="row">
			  <div class="col-xs-12" style="padding:0 5px">处理时间：{{item.updateTime}}</div>
			  <div class="col-xs-12" style="padding:0 5px">处理结果：{{item.memo}}</div>
			</div>
			<div v-if="item.status=='0'" class="row">
			  <button class="btn btn-danger pull-right"  style="margin:3px 20px;padding:1px 25px" @click="deleteApply(item)"> 删 除 </button>
			</div>
		</div>
	  </div>
	</div>
  </div>  
</div><!-- end of container -->
<script>
var containerVue = new Vue({
	el:'#container',
	data:{
		dataList:[],
		search:{},
		pageCond:{
			begin:0,
			pageSize:20,
			count:0
		}
	},
	methods:{
		deleteApply: function(item){
			$('#delCashApplyModal').modal('show');
			delCashApplyVue.param.applyId = item.applyId;
			delCashApplyVue.param.accountName = item.accountName;
			delCashApplyVue.param.accountNo = item.accountNo;
			delCashApplyVue.param.cashAmount = item.cashAmount/100;
		},
		getAll :function(isRefresh,isForward){
			var url = '/cash/getall';
			var searchParam = {
				'begin':containerVue.pageCond.begin,
				'pageSize':containerVue.pageCond.pageSize
			};
			getAllData(isRefresh,isForward,url,searchParam,containerVue.dataList,containerVue.pageCond);
		}
	}
});
containerVue.getAll();
//分页初始化
scrollPager(containerVue.pageCond,containerVue.dataList,containerVue.getAll); 
</script>

<!-- 删除申请模态框（Modal） -->
<div class="modal fade " id="delCashApplyModal" tabindex="-1" role="dialog" aria-labelledby="errorTitle" aria-hidden="false" data-backdrop="static" style="top:20%">
<div class="modal-dialog">
<div class="modal-content">
	<div class="modal-header">
	  <button type="button" class="close" data-dismiss="modal"  aria-hidden="true">× </button>
	  <h4 class="modal-title" id="errorTitle" style="color:red" >删除提现申请</h4>
	</div>
	<div class="modal-body">
	  <div class="row form-group" style="margin:3px 5px 3px 15px;padding:3px 3px;">
        <label class="col-xs-4 control-label" style="padding-right:1px">提现账户<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px" >
          <span>{{param.accountName}} {{param.accountNo}}</span>
        </div>
      </div>
      <div class="row form-group" style="margin:3px 5px 3px 15px;padding:3px 3px;">
        <label class="col-xs-4 control-label" style="padding-right:1px">提现金额(元)<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <span>{{new Number(param.cashAmount).toFixed(2)}}</span>
        </div>
      </div>
      <div class="row form-group" style="margin:3px 5px 3px 15px;padding:3px 3px;">
        <label class="col-xs-4 control-label" style="padding-right:1px">会员密码<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <input type="password" class="form-control" v-model="param.passwd" maxLength=20 placeholder="会员密码" >
        </div>
      </div>
	</div>
	<div class="modal-footer">
	  <div class="row" style="text-align:center;width:100%">
	    <button class="btn btn-danger" style="width:80%;" @click="submit"> 删 除 </button>
	  </div>
	</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script>
var delCashApplyVue = new Vue({
	el:'#delCashApplyModal',
	data:{
		param:{
			applyId:'',
			cashAccount:'',
			accountName:'',
			accountNo:'',
			passwd:''
		}
	},
	methods:{
		submit: function(){
			$.ajax({
				url: '/cash/delete',
				method:'post',
				data: this.param,
				success: function(jsonRet,status,xhr){
					$('#delCashApplyModal').modal('hide');
					if(jsonRet.errcode == 0){
						containerVue.getAll();
					}else{
						if(jsonRet.errcode === -100000){
							$('#ajaxLoginModal').modal('show');
						}else{
							alertMsg('错误提示',jsonRet.errmsg);
						}
					}
				},
				dataType: 'json'
			});
		}
	}
});

</script>
		
</body>
</html>
