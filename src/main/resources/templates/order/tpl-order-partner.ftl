
        <div class="row" style="margin:0px 0px;padding:5px 10px;background-color:white">
	      <a class="pull-left" :href="'/partner/mcht/' + order.partnerId">
	        <img alt="头像" :src="'/partner/cert/show/logo/' + order.partnerId" width="20px" height="20px" style="border-radius:50%"> 
	        {{order.partnerBusiName}}
	      </a>
		  <span class="pull-right"><a :href="'/order/detail/' + order.orderId">{{getOrderStatus(order.status)}}</a></span>
	    </div>