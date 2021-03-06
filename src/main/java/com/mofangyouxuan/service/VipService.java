package com.mofangyouxuan.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONObject;
import com.mofangyouxuan.common.ErrCodes;
import com.mofangyouxuan.dto.SettleAccount;
import com.mofangyouxuan.dto.VipBasic;
import com.mofangyouxuan.utils.HttpUtils;
import com.mofangyouxuan.utils.ObjectToMap;

/**
 * 会员服务，主要用于向服务中心发送请求
 * @author jeekhan
 *
 */
@Component 
public class VipService {
	
	//private static String tmpFileDir;
	private static String mfyxServerUrl;

	private static String vipBasicGetUrl;
	private static String vipCashFlowGetAllUrl;
	private static String vipResetPwdUrl;
	private static String vipUpdPwdUrl;
	
	private static String settleAccountSaveUrl;
	private static String settleAccountDeleteUrl;
	private static String settleAccountGetAllUrl;
	


	
//	@Value("${sys.tmp-file-dir}")
//	public void setTmpFileDir(String url) {
//		tmpFileDir = url;
//	}
	
	@Value("${mfyx.mfyx-server-url}")
	public void setMfyxServerUrl(String url) {
		mfyxServerUrl = url;
	}
	
	@Value("${mfyx.vip-basic-get-url}")
	public void setVipBasicGetUrl(String url) {
		vipBasicGetUrl = url;
	}
	@Value("${mfyx.vip-cash-flow-getall-url}")
	public void setChangeFlowGetAllUrl(String url) {
		vipCashFlowGetAllUrl = url;
	}
	@Value("${mfyx.vip-reset-pwd-url}")
	public void setVipResetPwdUrl(String url) {
		vipResetPwdUrl = url;
	}
	@Value("${mfyx.vip-upd-pwd-url}")
	public void setVipUpdPwdUrl(String url) {
		vipUpdPwdUrl = url;
	}
	
	@Value("${mfyx.settle-account-save-url}")
	public void setSettleAccountSaveUrl(String url) {
		settleAccountSaveUrl = url;
	}
	@Value("${mfyx.settle-account-delete-url}")
	public void setSettleAccountDeleteUrl(String url) {
		settleAccountDeleteUrl = url;
	}
	@Value("${mfyx.settle-account-getall-url}")
	public void setSettleAccountGetAllUrl(String url) {
		settleAccountGetAllUrl = url;
	}
	
	
	
	/**
	 * 获取会员基本信息
	 * @param openId
	 * @return
	 */
	public static VipBasic getVipBasic(Integer vipId) {
		VipBasic vipBasic = null;
		String url = mfyxServerUrl + vipBasicGetUrl;
		url = url.replace("{vipId}", vipId+"");
		String strRetVip = HttpUtils.doPost(url);
		try {
			JSONObject ret = JSONObject.parseObject(strRetVip);
			if(ret.containsKey("vipId")) {//成功
				vipBasic = JSONObject.toJavaObject(ret, VipBasic.class);
			}
		}catch(Exception e) {
			e.printStackTrace();
			vipBasic = null;
		}
		return vipBasic;
	}
	

	/**
	 * 查询会员资金流水信息
	 * @param jsonSearchParams
	 * @param jsonPageCond
	 * @return {errcode:0,errmsg:"ok",pageCond:{},datas:[{}...]} 
	 */
	public static JSONObject searchFlows(String jsonSearchParams,String jsonPageCond) {
		String url = mfyxServerUrl + vipCashFlowGetAllUrl;
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("jsonSearchParams", jsonSearchParams);
		params.put("jsonPageCond", jsonPageCond);
		String strRet = HttpUtils.doPost(url, params);
		try {
			JSONObject jsonRet = JSONObject.parseObject(strRet);
			return jsonRet;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 重设资金操作密码（忘记或新设）
	 * @param vipId
	 * @param type	重置媒介
	 * @return {errcode:0,errmsg:"ok"} 
	 */
	public static JSONObject resetPwd(Integer vipId ,String type) {
		String url = mfyxServerUrl + vipResetPwdUrl;
		url = url.replace("{vipId}", vipId +"");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("type", type);
		String strRet = HttpUtils.doPostSSL(url, params);
		try {
			JSONObject jsonRet = JSONObject.parseObject(strRet);
			return jsonRet;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 更新会员资金操作密码
	 * @param vipId
	 * @param oldPwd		旧密码
	 * @param newPwd		新密码
	 * @return {errcode:0,errmsg:"ok"} 
	 */
	public static JSONObject updPwd(Integer vipId ,String oldPwd,String newPwd) {
		String url = mfyxServerUrl + vipUpdPwdUrl;
		url = url.replace("{vipId}", vipId +"");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("oldPwd", oldPwd);
		params.put("newPwd", newPwd);
		String strRet = HttpUtils.doPostSSL(url, params);
		try {
			JSONObject jsonRet = JSONObject.parseObject(strRet);
			return jsonRet;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 保存会员提现账户信息
	 * 
	 * @param vipId
	 * @param account
	 * @param passwd
	 * @return {errcode,errmsg}
	 */
	public static JSONObject saveAccount(Integer vipId,SettleAccount account,String passwd) {
		String url = mfyxServerUrl + settleAccountSaveUrl;
		url = url.replace("{vipId}", vipId +"");
	
		Map<String, Object> params = new HashMap<String,Object>();
		String[] excludeFields = {"updateTime","status"};
		params = ObjectToMap.object2Map(account,excludeFields,false);
		params.put("passwd", passwd);
		String strRet = HttpUtils.doPost(url, params);
		JSONObject jsonRet = new JSONObject();
		try {
			jsonRet = JSONObject.parseObject(strRet);
			if(!jsonRet.containsKey("errcode")) {
				jsonRet.put("errcode", ErrCodes.COMMON_EXCEPTION);
				jsonRet.put("errmsg", "出现系统访问错误，错误信息：" + strRet);
			}
		}catch(Exception e) {
			e.printStackTrace();
			jsonRet.put("errcode", ErrCodes.COMMON_EXCEPTION);
			jsonRet.put("errmsg", "系统异常，异常信息：" + e.getMessage());
		}
		return jsonRet;
	}
	
	/**
	 * 删除提现账户信息
	 * 
	 * @param vipId
	 * @param settleId
	 * @param passwd
	 * @return {errcode,errmsg}
	 */
	public static JSONObject deleteAccount(Integer vipId,Long settleId,String passwd) {
		String url = mfyxServerUrl + settleAccountDeleteUrl;
		url = url.replace("{vipId}", vipId +"");
	
		Map<String, Object> params = new HashMap<String,Object>();
		params.put("passwd", passwd);
		params.put("settleId", settleId);
		String strRet = HttpUtils.doPost(url, params);
		JSONObject jsonRet = new JSONObject();
		try {
			jsonRet = JSONObject.parseObject(strRet);
			if(!jsonRet.containsKey("errcode")) {
				jsonRet.put("errcode", ErrCodes.COMMON_EXCEPTION);
				jsonRet.put("errmsg", "出现系统访问错误，错误信息：" + strRet);
			}
		}catch(Exception e) {
			e.printStackTrace();
			jsonRet.put("errcode", ErrCodes.COMMON_EXCEPTION);
			jsonRet.put("errmsg", "系统异常，异常信息：" + e.getMessage());
		}
		return jsonRet;
	}
	
	/**
	 * 获取会员所有提现账户信息
	 * 
	 * @param vipId
	 * @param settleId
	 * @param passwd
	 * @return {errcode,errmsg,datas:[{...}...]}
	 */
	public static JSONObject getAllAccount(Integer vipId,String passwd) {
		String url = mfyxServerUrl + settleAccountGetAllUrl;
		url = url.replace("{vipId}", vipId +"");
	
		Map<String, Object> params = new HashMap<String,Object>();
		params.put("passwd", passwd);
		String strRet = HttpUtils.doPost(url, params);
		JSONObject jsonRet = new JSONObject();
		try {
			jsonRet = JSONObject.parseObject(strRet);
			if(!jsonRet.containsKey("errcode")) {
				jsonRet.put("errcode", ErrCodes.COMMON_EXCEPTION);
				jsonRet.put("errmsg", "出现系统访问错误，错误信息：" + strRet);
			}
		}catch(Exception e) {
			e.printStackTrace();
			jsonRet.put("errcode", ErrCodes.COMMON_EXCEPTION);
			jsonRet.put("errmsg", "系统异常，异常信息：" + e.getMessage());
		}
		return jsonRet;
	}
	
	
}
