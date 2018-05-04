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
<body class="light-gray-bg">
<div class="container" id="goodsContainer" style="padding:0px 0px;oveflow:scroll">
  <div class="row">
     <ul class="nav nav-tabs" style="margin:0 15%">
	  <li style="width:50%" class="active" onclick="$(this).addClass('active');$(this).siblings().removeClass('active');$('#editGoods').show();$('#reviewInfo').hide();">
	    <a href="javascript:;">商品基本信息编辑</a>
	  </li>
	  <li style="width:50%" onclick="$(this).addClass('active');$(this).siblings().removeClass('active');$('#editGoods').hide();$('#reviewInfo').show();">
	    <a href="javascript:;">审批反馈</a>
	  </li>
	</ul>
  </div>
  <div class="row" id="editGoods" style="width:100%;margin:1px 0px 0px 0px;padding:5px 8px;background-color:white;">
    <h5 style="text-align:center">商品基本信息编辑</h5>
    <h6 style="color:red">
      &nbsp;&nbsp;&nbsp;&nbsp;所有信息必须确保真实可靠，不可出现描述与真实品质不符的情况！<br>
    </h6>
	<form class="form-horizontal" method ="post" autocomplete="on" enctype="multipart/form-data" role="form" >
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">商品名称<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <input class="form-control" v-model="param.goodsName" required maxLength="100" placeHolder="请输入商品名称2-100字符">
        </div>
      </div>         
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">商品分类<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <select class="form-control"  v-model="param.categoryId" required>
            <option v-for="item in metadata.categories" v-bind:value="item.categoryId">{{item.categoryName}}</option>
          </select>
        </div>
      </div> 
       <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">商品主图<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <div class="col-xs-9" style="padding-left:0"><input class="form-control"  v-model="param.mainImgPath" required readonly placeholder="请选择图片"></div>
          <div class="col-xs-3" style="padding-left:0"><button class="btn btn-info" @click="selectImage(1,'main')">选择</button></div>
        </div>
      </div> 
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">商品轮播图<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
           <div class="col-xs-9" style="padding-left:0"><textarea class="col-xs-9 form-control" v-model="param.carouselImgPaths" maxLength=500 rows=10 readonly placeholder="请选择图片" ></textarea></div>
           <div class="col-xs-3" style="padding-left:0"><button class="btn btn-info" @click="selectImage(10,'carousel')">选择</button></div>
        </div>
      </div>
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">商品产地<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
           <input type="text" class="form-control" v-model="param.place"  max=100 >
        </div>       
      </div>
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">生产者<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
           <input type="text" class="form-control" v-model="param.vender"  max=100 >
        </div>       
      </div>
      <div class="form-group">
        <div class="col-xs-12" style="padding-left:1px">
          <label class="col-xs-12 control-label" >规格明细与库存(名称唯一,为空则过滤该条记录)<span style="color:red">*</span></label>
        </div>
        <div class="col-xs-12"  style="height:300px;overflow:scroll">
           <table class="table table-striped table-bordered table-condensed">
             <tr>
               <th width="40%" style="padding:2px 2px">规格名称</th>
               <th width="15%" style="padding:2px 2px">数量值</th>
               <th width="15%" style="padding:2px 2px">单位</th>
               <th width="15%" style="padding:2px 2px">售价(¥)</th>
               <th width="15%" style="padding:2px 2px">库存件数</th>
             </tr>
             <tr v-for="(item,index) in specDetailArr" >
               <td style="padding:2px 2px">
                 <input type="text"  style="width:100%" maxlength="20" :value="item.name" @change="setSpecItem('name',index,$event)">
               </td>
               <td style="padding:2px 2px">
                 <input type="number" style="width:100%" min=0 max=999999 :value="item.val" @change="setSpecItem('val',index,$event)">
               </td>
               <td style="padding:2px 2px">
                 <input type="text" style="width:100%" :value="item.unit" maxlength=5 @change="setSpecItem('unit',index,$event)">
               </td>
               <td style="padding:2px 2px">
                 <input type="number" style="width:100%" :value="item.price" min=0 max=99999999 @change="setSpecItem('price',index,$event)">
               </td>               
               <td style="padding:2px 2px">
                 <input type="number" style="width:100%" min=0 max=999999 :value="item.stock" @change="setSpecItem('stock',index,$event)">
               </td>
             </tr>
           </table>
        </div>       
      </div>
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">限购数量<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <input type="datetime" class="form-control" v-model="param.limitedNum" min=0 max=999999 placeholder="请输入每人限购数量，0表示不限购" >
        </div>
      </div>
      <div class="form-group" v-if="param.limitedNum>0">
        <label class="col-xs-4 control-label" style="padding-right:1px">限购开始时间<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <input type="date" class="form-control" v-model="param.beginTime"  maxLength=20  required placeholder="请输入限购开始时间">
        </div>
      </div>
      <div class="form-group" v-if="param.limitedNum>0">
        <label class="col-xs-4 control-label" style="padding-right:1px">限购结束时间<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <input type="date" class="form-control" v-model="param.endTime"  maxLength=20  required placeholder="请输入限购开始时间">
        </div>
      </div>
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">运费模版<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <select class="form-control" v-model="postageIdArr" required multiple>
            <option v-for="item in metadata.postages" v-bind:value="item.postageId">{{item.postageName}}</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-xs-4 control-label" style="padding-right:1px">是否立即上架<span style="color:red">*</span></label>
        <div class="col-xs-8" style="padding-left:1px">
          <label style="padding:0 5px"><input type="radio" v-model="param.status" value="0" style="display:inline-block;width:15px;height:15px">否</label>
          <label style="padding:0 5px"><input type="radio" v-model="param.status" value="1" style="display:inline-block;width:15px;height:15px">是</label>
        </div>
      </div>     
      <div class="form-group">
        <div class="col-xs-12" style="padding-left:1px">
          <label class="col-xs-6 control-label" >商品图文描述<span style="color:red">*</span></label>
        </div>
        <div class="col-xs-12" >
          <input type="hidden" value="${(goods.goodsDesc)!''}" id="hiddenGoodsDesc">
          <textarea class="form-control" maxLength=10000  rows=30 required v-model="param.goodsDesc"
          placeholder="    请输入10-10000字符的企业经营简介。
    编辑说明：最好请在文本编辑器中编辑好之后复制粘贴于此。
    相关格式说明：如果是一个段落请将段落内容放置于标签: <p>与</p>之间；换行则在句末添加标签：<br>；插入图片使用标签：<img href='  ' width = '100%' > ，href属性的内容来自图库中图片的链接(不是图片名称)。不清楚的话可以问问身边的做软件开发的朋友。"></textarea>
        </div>
      </div>
      <div class="form-group">
         <div style="text-align:center">
           <button type="button" class="btn btn-info" style="margin:20px" @click="submit">&nbsp;&nbsp;提 交&nbsp;&nbsp;</button>
           <button type="button" class="btn btn-warning" style="margin:20px" @click="reset">&nbsp;&nbsp;重 置&nbsp;&nbsp; </button>
         </div>
      </div>
	</form>
  </div>

  <div class="row" id="reviewInfo" style="width:100%;margin:1px 0px 0px 0px;padding:5px 8px;background-color:white;display:none">
  	<h5 style="text-align:center">最新审批结果信息</h5>
  	<p>审批时间：{{review.reviewTime}}</p>
  	<p>审批结果：{{getReviewResult()}} </p>
  	<p>审批意见：{{review.reviewLog}}</p>
  </div>
</div><!-- end of container -->
<footer>
  <#include "/menu/page-partner-func-menu.ftl" encoding="utf8"> 
</footer>
<script type="text/javascript">
var goodsContainerVue = new Vue({
	el:'#goodsContainer',
	data:{
		metadata:{
			categories:[],
			postages:[]
		},
		review:{
			reviewResult:'${(goods.reviewResult)!"0"}',
			reviewTime:'' ,
			reviewLog:"${(goods.reviewLog)!''}"
		},
		param:{
			goodsId:'${(goods.goodsId)!-1}'.replace(',',''),
			goodsName:'${(goods.goodsName)!''}',
			categoryId:'${(goods.categoryId)!''}'.replace(',',''),
			goodsDesc:'',
			mainImgPath:'${(goods.mainImgPath)!''}',
			carouselImgPaths:'${(goods.carouselImgPaths)!''}',
			place:'${(goods.place)!''}',
			vender:'${(goods.vender)!''}',
			//priceLowest:'${(goods.priceLowest)!''}'.replace(',',''),
			//stockSum:'${(goods.stockSum)!''}'.replace(',',''),
			specDetail:"",
			limitedNum:'${(goods.limitedNum)!''}'.replace(',',''),
			beginTime:'${(goods.beginTime)!''}',
			endTime:'${(goods.endTime)!''}',
			postageIds:'${(goods.postageIds)!''}',
			status:'${(goods.status)!''}'
		},
		postageIdArr:'${(goods.postageIds)!''}'.split(','),
		specDetailArr:JSON.parse('${(goods.specDetail)!"[]"}')
	},
	watch:{
		postageIdArr :function(){
			this.param.postageIds = this.postageIdArr.join(',');
		}
	},
	methods:{
		getReviewResult: function(){
    			if("0" == this.review.reviewResult) {
    				return "待审核";
    			}else if("2" == this.review.reviewResult) {
    				return "审核拒绝";
    			}else if("1" == this.review.reviewResult) {
    				return "审核通过";
    			}
        		return "其他";
		},
		addSpec:function(){
			if(this.specDetailArr == null){
				this.specDetailArr = [];
			}
			this.specDetailArr.push(new Object({name:'',val:'',unit:'',price:'',stock:''}));
		},
		delSpec:function(index){
			this.specDetailArr.splice(index,1);
		},
		setSpecItem:function(field,index,event){
			var spec = this.specDetailArr[index];
			var value = $(event.target).val();
			if(field === 'name'){
				if(!value){
					value = '';
				}
				value = value.trim();
				if(value.length>20){
					alert('规格明细中第 ' + (index+1) + " 条数据的'规格名称'不合规，长度须为1-20字符！");
					$(event.target).focus();
					return false;
				}
				$(event.target).val(value);
				spec.name = value;
			}
			if(field == 'val' && value){
				var val = parseInt(value);
				if(isNaN(val) || val < 1 || val > 999999){
					alert("规格明细中的第 " + (index+1) + "条的数量值不合规，须为1-999999的整数值！");
					$(event.target).focus();
					return false;
				}
				$(event.target).val(val);
				spec.val = val;
			}
			if(field == 'unit' && value){
				value = value.trim();
				if(value.length < 1 || value.length > 5){
					alert("规格明细中的第 " + (index+1) + "条的单位不合规，长度须为1-5字符！");
					$(event.target).focus();
					return false;
				}
				$(event.target).val(value);
				spec.unit = value;
			}
			if(field == 'price' && value){
				var val = parseFloat(value);
				if(isNaN(val) || val < 0 || val > 99999999.99){
					alert("规格明细中的第 " + (index+1) + "条的单价不合规，须为0-99999999.99的数值！");
					$(event.target).focus();
					return false;
				}
				val = val.toFixed(2);
				$(event.target).val(val);
				spec.price = val;
				/* if(this.param.priceLowest){
					if(val<this.param.priceLowest){
						this.param.priceLowest = val;
					}
				}else{
					this.param.priceLowest = val;
				} */
			}
			if(field == 'stock' && value){
				var val = parseInt(value);
				if(isNaN(val) || val < 0 || val > 999999){
					alert("规格明细中的第 " + (index+1) + "条的库存不合规，须为0-999999的整数值！");
					$(event.target).focus();
					return false;
				}
				$(event.target).val(val);
				spec.stock = val;
				
				/* this.param.stockSum = 0;
				for(var i=0;i<this.specDetailArr.length;i++){
					var sp = this.specDetailArr[i];
					if(sp.name && sp.stock){
						this.param.stockSum = this.param.stockSum + parseInt(sp.stock);
					}
				} */
			}
		},
		getCategories: function(){
			$.ajax({
				url: '/goods/categories',
				method:'get',
				data: {},
				success: function(jsonRet,status,xhr){
					if(jsonRet.categories){
						goodsContainerVue.metadata.categories = [];
						for(var i=0;i<jsonRet.categories.length;i++){
							goodsContainerVue.metadata.categories.push(jsonRet.categories[i]);
						}
					}else{
						alert('获取商品分类数据失败！')
					}
				},
				dataType: 'json'
			});
		},
		getPostages: function(){
			//获取系统所有的运费模版
			$.ajax({
				url: '/postage/getall',
				method:'post',
				data: {},
				success: function(jsonRet,status,xhr){
					if(jsonRet ){
						if(jsonRet.postages){
							goodsContainerVue.metadata.postages = [];
							for(var i=0;i<jsonRet.postages.length;i++){
								goodsContainerVue.metadata.postages.push(jsonRet.postages[i]);
							}
						}
					}else{
						alert('获取数据失败！')
					}
				},
				dataType: 'json'
			});
		},
		selectImage: function(selectCntLimit,imgType){
			//选择商品的图片
			$('#imageGalleryShowModal').modal('show');
			imageGalleryShowVue.selectCntLimit = selectCntLimit;
			imageGalleryShowVue.selectedImages = [];
			imageGalleryShowVue.callbackFun = function(images){
				if(imgType === 'main'){
					goodsContainerVue.param.mainImgPath = images;
				}else{
					goodsContainerVue.param.carouselImgPaths = images;
				}
			}
		},
		submit: function(){
			//组织规格数据
			var okSpecArr = [];
			//var stockSum = 0;
			//var priceLowest = 1000000000;
			for(var i=0;i<this.specDetailArr.length;i++){
				var spec = this.specDetailArr[i];
				if(!spec.name){
					continue;//过滤该条数据
				}else{
					spec.name = spec.name.trim();
				}
				if(spec.name.length > 20){
					alert("规格明细中的第 " + (i+1) + "条的规格名称不合规，长度范围：2-20字符！");
					return;
				}
				if(!spec.unit || spec.unit.trim().length > 5){
					alert("规格明细中的第 " + (index+1) + "条的单位不合规，长度须为1-5字符！");
					return false;
				}else{
					spec.unit = spec.unit.trim();
				}
				var val = parseInt(spec.val);
				if(isNaN(val) || val<1 || val>999999){
					alert("规格明细中的第 " + (i+1) + "条的数量值不合规，须为1-999999的整数值！");
					return false;
				}else{
					spec.val = val;
				}
				var val = parseFloat(spec.price);
				if(isNaN(val) || val < 0 || val > 99999999){
					alert("规格明细中的第 " + (index+1) + "条的单价不合规，须为0-99999999的数值！");
					return false;
				}else{
					val = val.toFixed(2);
					spec.price = val;
					/* if(priceLowest > val){
						priceLowest = val;
					} */
				}
				var val = parseInt(spec.stock);
				if(isNaN(val) || val< 0 || val > 999999){
					alert("规格明细中的第 " + (i+1) + "条的库存不合规，须为0-999999的整数值！");
					return false;
				}else{
					spec.stock = val;
					//stockSum += val;
				}
				okSpecArr.push(spec);
			}
			if(okSpecArr.length<1){
				alert("规格明细数据不可为空，至少要有一条数据！");
				return ;
			}
			for(var i=0;i<okSpecArr.length;i++){
				for(var j=i+1;j<okSpecArr.length;j++){
					if(okSpecArr[i].name == okSpecArr[j].name){
						alert("规格明细不可出现同规格名称的记录！");
						return false;
					}
				}
			}
			this.param.specDetail = JSON.stringify(okSpecArr);
			$.ajax({
				url: '/goods/save',
				method:'post',
				data: this.param,
				success: function(jsonRet,status,xhr){
					if(jsonRet){
						if(0 == jsonRet.errcode){
							window.location.href='/goods/manage';
						}else{//出现逻辑错误
							alert(jsonRet.errmsg);
						}
					}else{
						alert('系统数据访问失败！')
					}
				},
				dataType: 'json'
			});
		},
		reset: function(){
			window.location.reload();
		}
	}
});

goodsContainerVue.getCategories();
goodsContainerVue.getPostages();
if(goodsContainerVue.specDetailArr.length<30){
	var len = 30-goodsContainerVue.specDetailArr.length;
	for(var i=0;i<len;i++){
		goodsContainerVue.addSpec();
	}	
}
goodsContainerVue.param.goodsDesc = $('#hiddenGoodsDesc').val();
</script>

<#include "/image/page-image-show-tpl.ftl" encoding="utf8"> 

<#if errmsg??>
<!-- 错误提示模态框（Modal） -->
<div class="modal fade " id="errorModal" tabindex="-1" role="dialog" aria-labelledby="errorTitle" aria-hidden="false" data-backdrop="static">
	<div class="modal-dialog">
  		<div class="modal-content">
     		<div class="modal-header">
        			<button type="button" class="close" data-dismiss="modal"  aria-hidden="true">× </button>
        			<h4 class="modal-title" id="errorTitle" style="color:red">错误提示</h4>
     		</div>
     		<div class="modal-body">
       			<p> ${errmsg} </p><p/>
     		</div>
     		<div class="modal-footer">
     			<div style="margin-left:50px">
        			</div>
     		</div>
  		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script>
$("#errorModal").modal('show');
</script>
</#if>
</body>
</html>