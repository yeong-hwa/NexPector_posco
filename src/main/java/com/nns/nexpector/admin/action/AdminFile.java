package com.nns.nexpector.admin.action;

import com.nns.common.util.excel.AdminFileDao;
import com.nns.common.util.excel.ExcelUtil;
import com.nns.common.util.excel.ValueUtil;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.ComStr;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/admin/*")
public class AdminFile {

	private static Logger logger = LoggerFactory.getLogger(AdminFile.class);

	@Autowired
	private CommonServices commonServices;

	@Autowired
	private View jsonView;

	private static final String[] titleArray = {"교환기ID","교환기명","전화기IP","내선번호","사용자 정보","전화기 타입","전화기 그룹 코드","전화기 그룹명","SNMP Community","SNMP Version","SNMP Port"};
	private static final String[] columnArray = {"N_MON_ID","S_MON_NAME","S_IPADDRESS","S_EXT_NUM","S_NAME","S_TYPE", "N_GROUP", "S_GROUP_NAME","S_COMMUNITY", "N_SNMP_VER", "N_PORT"};

	@SuppressWarnings("rawtypes")
	@RequestMapping("ipphone_file_import")
	public View importIpPhone(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request, HttpServletResponse response) {

		int returnCode = 0;
		File excelFile = null;
		try {
			response.setContentType("text/plain");
			if (request instanceof MultipartHttpServletRequest) {

				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				MultipartFile orgFile = multipartRequest.getFile("file_uploadpath");

				if (orgFile != null) {
					String dirPath = ExcelUtil.makeTempDir(request.getSession().getServletContext().getRealPath(""));

					if (dirPath != null) {
						String date = ExcelUtil.DATE_TIME_FORMAT.format(new Date(System.currentTimeMillis()));
						String filePath = dirPath + File.pathSeparator + "Ins_IP_Phone_" + date + ".xls";
						excelFile = new File(filePath);
						orgFile.transferTo(excelFile);

						returnCode = ExcelUtil.checkExcelData(filePath, titleArray);

						if (returnCode == 0) {
							List<Map<String, String>> listData = ExcelUtil.getExcelData(filePath, columnArray);

							boolean isCheck = true;
							if (listData != null && listData.size() > 0) {
								List cmList = commonServices.getList("ipphone_file_cm", null);
								List groupList = commonServices.getList("ipphone_file_svr_group", null);

								List<String> pkList = new ArrayList<String>();
								String key = null;
								Map<String, String> map = null;
								for (int i = 0; i < listData.size(); i++) {
									map = listData.get(i);
									modelMap.addAttribute("RSLT_MSG", "Excel Row : " + (i+2));

									// N_MON_ID
									if (!ValueUtil.isEquals(cmList, map.get("N_MON_ID"))) {
										returnCode = -20; // 등록할 수 없는 교환기ID 입니다.
										isCheck = false;
										break;
									}

									// S_IPADDRESS
									if (!ValueUtil.isIpAddress(map.get("S_IPADDRESS"))) {
										returnCode = -21; // 전화기IP 형식이 맞지 않습니다.
										isCheck = false;
										break;
									}

									// -1000
									key = map.get("N_MON_ID")+"#"+map.get("S_IPADDRESS");
									if (!ValueUtil.checkPk(pkList, key)) {
										returnCode = -1000; // 데이터가 중복되어 등록할 수 없습니다.
										isCheck = false;
										break;
									}
									pkList.add(key);

									// S_EXT_NUM
									if (!ValueUtil.isString(map.get("S_EXT_NUM"), 20, false)) {
										returnCode = -22; // 내선번호 입력값을 확인하십시오.
										isCheck = false;
										break;
									}

									// S_NAME
									if (!ValueUtil.isString(map.get("S_NAME"), 200, true)) {
										returnCode = -23; // 사용자 정보 입력값을 확인하십시오.
										isCheck = false;
										break;
									}

									// S_COMMUNITY
									if (!ValueUtil.isString(map.get("S_COMMUNITY"), 20, false)) {
										returnCode = -24; // SNMP Community 입력값을 확인하십시오.
										isCheck = false;
										break;
									}

									// N_SNMP_VER
									if (!ValueUtil.isNumber(map.get("N_SNMP_VER"), 1, false, 1, 2)) {
										returnCode = -25; // SNMP Version 입력값을 확인하십시오.
										isCheck = false;
										break;
									}

									// N_PORT
									if (!ValueUtil.isNumber(map.get("N_PORT"), 5, false, 1, 65535)) {
										returnCode = -26; // SNMP Port 입력값을 확인하십시오.
										isCheck = false;
										break;
									}

									// S_TYPE
									if (!ValueUtil.isString(map.get("S_TYPE"), 20, false)) {
										returnCode = -27; // 사용자 정보 입력값을 확인하십시오.
										isCheck = false;
										break;
									}

									// N_GROUP
									if (!ValueUtil.isEquals(groupList, map.get("N_GROUP"))) {
										returnCode = -28; // 등록할 수 없는 전화기 그룹 코드 입니다.
										isCheck = false;
										break;
									}
								}

							}

							if (isCheck) {
								AdminFileDao.insertIpPhone(commonServices, listData);
								modelMap.addAttribute("RSLT_MSG", "등록 : " + listData.size() + "건");
							}

						}

					} else {
						returnCode = -1;
					}
				} else {
					returnCode = -1;
				}
			}

			/*
			 *  0 성공
			 * -1 정상적인 파일이 아닙니다.
			 * -10 엑셀 서식이 맞지 않습니다.
			 * -20~ 입력 값이 형식이 맞지 않습니다.
			 * -1000 데이터가 중복되어 등록할 수 없습니다.
			 */
			modelMap.addAttribute("RSLT", returnCode);

		} catch (Exception e) {
			modelMap.addAttribute("RSLT", -9999);
			modelMap.addAttribute("RSLT_MSG", e.getMessage());
			logger.error(e.getMessage(), e);

		} finally {
			if (excelFile != null) {
				if (excelFile.exists() && excelFile.isFile()) {
					excelFile.delete();
				}
			}
		}
		return jsonView;
	}

	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("ipphone_file_export")
	public ModelAndView exportIpPhone(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request, HttpServletResponse response) {
		try {

			String dirPath = ExcelUtil.makeTempDir(request.getSession().getServletContext().getRealPath(""));
			if (dirPath != null) {
				// N_MON_ID , S_IPADDRESS , S_TYPE , N_GROUP
				List list = commonServices.getList("ipphone_file.ipphone_file_export", param);

				String fileName = "IP_Phone_";
				int[] widthArray = {12,20,17,12,45,15,20,22,20,18,16};

				File file = ExcelUtil.createExcelFile(dirPath, fileName, titleArray, widthArray, columnArray, list);

				return new ModelAndView("downloadExcelView", "downloadFile", file);
			}

		} catch (Exception e) {
			modelMap.addAttribute("RSLT", -9999);
			logger.error(e.getMessage(), e);
		}
		return null;
	}
	
	private static final String[] titleArrayJijum	= {"본부","지점","러닝","구분","IP","전화번호","주소", "등록일시"};
	private static final String[] columnArrayJijum	= {"S_GROUP_NAME","S_NAME","S_RUNNING","S_GUBUN","S_IP_ADDRESS","S_EXT_NUM","S_ADDRESS","D_INS_DATE"};
	
	//
	private static final String[] titleArrayJijumEx		= {"본부", "지점", "러닝", "구분", "IP", "전화번호", 	"주 소"};
	private static final String[] columnArrayJijumEx	= {"S_GROUP_NAME","S_NAME","S_RUNNING","S_GUBUN","S_IP_ADDRESS","S_EXT_NUM","S_ADDRESS"};
	//
	private static final String[] titleArrayJijumDash		= {"상태", "본부", "지점", "러닝", "구분", "전화번호", "주소"};
	private static final String[] columnArrayJijumDash		= {"S_STATUS", "S_GROUP_NAME","S_NAME","S_RUNNING","S_GUBUN","S_EXT_NUM","S_ADDRESS"};
	/**
	 * jijum excel export (지점 엑셀 다운로드)
	 * @param modelMap
	 * @param param
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("jijum_file_export")
	public ModelAndView exportJijum(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request, HttpServletResponse response) {
		try {

			String dirPath = ExcelUtil.makeTempDir(request.getSession().getServletContext().getRealPath(""));
			if (dirPath != null) {
				List list = commonServices.getList("jijum_file.jijum_file_export", param);

				String fileName = "Jijum_";
				int[] widthArray = {12,20,17,12,25,15,60,20};
				
				File file = ExcelUtil.createExcelFile(dirPath, fileName, titleArrayJijum, widthArray, columnArrayJijum, list);

				return new ModelAndView("downloadExcelView", "downloadFile", file);
			}

		} catch (Exception e) {
			modelMap.addAttribute("RSLT", -9999);
			logger.error(e.getMessage(), e);
		}
		return null;
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping("jijum_file_import")
	public View importJijum(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request, HttpServletResponse response) {

		int returnCode = 0;
		File excelFile = null;
		try {
			response.setContentType("text/plain");
			if (request instanceof MultipartHttpServletRequest) {

				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				MultipartFile orgFile = multipartRequest.getFile("file_uploadpath");

				if (orgFile != null) {
					String dirPath = ExcelUtil.makeTempDir(request.getSession().getServletContext().getRealPath(""));

					if (dirPath != null) {
						String date = ExcelUtil.DATE_TIME_FORMAT.format(new Date(System.currentTimeMillis()));
						String filePath = dirPath + File.pathSeparator + "Ins_Jijum_" + date + ".xls";
						
						excelFile = new File(filePath);
						orgFile.transferTo(excelFile);

						returnCode = ExcelUtil.checkExcelData(filePath, titleArrayJijumEx);
						returnCode	= 0;
						
						if (returnCode == 0) {
							List<Map<String, String>> inLstData	= new ArrayList<Map<String, String>>();
							List<Map<String, String>> listData	= ExcelUtil.getExcelData(filePath, columnArrayJijumEx);

							boolean isCheck = true;
							if (listData != null && listData.size() > 0) {
								List<Map<String, Object>> cmList = commonServices.getList("jijum_file_cm", null);
								Map<String, Object> groupNameMap	= new HashMap<String, Object>();
								//
								for (Map item : cmList) {
									groupNameMap.put(ComStr.toStr(item.get("S_VALUE")), item.get("N_CODE"));
									logger.debug("Group Codemap {}, {}", item.get("S_VALUE"), item.get("N_CODE"));
								}
								
								List<String> pkList = new ArrayList<String>();
								String key = null;
								Map<String, String> map = null;
								for (int i = 0; i < listData.size(); i++) {
									map = listData.get(i);
									modelMap.addAttribute("RSLT_MSG", "Excel Row : " + (i+2));
									
									key = map.get("S_GROUP_NAME");
									
									if ("".equals(ComStr.toStr(key))) {
										break;
									}
									
									if (ComStr.toStr(groupNameMap.get(key)).isEmpty()) {
										logger.debug("지역 오류  {}", key);
										returnCode = -900; // 등록할 수 없는 지역구분입니다.
										isCheck = false;
										break;
									}
									
									if (! "".equals(ComStr.toStr(map.get("S_IP_ADDRESS")))) {
										if (!ValueUtil.isIpAddress(map.get("S_IP_ADDRESS"))) {
											logger.debug("IP Address {}", map.get("S_IP_ADDRESS"));
											returnCode = -21; // 전화기IP 형식이 맞지 않습니다.
											isCheck = false;
											break;
										}
										
										// -1000
										key = map.get("S_IP_ADDRESS");
										if (!ValueUtil.checkPk(pkList, key)) {
											returnCode = -1000; // 데이터가 중복되어 등록할 수 없습니다.
											isCheck = false;
											break;
										}
										pkList.add(key);
									}
									
									if (!ValueUtil.isString(map.get("S_EXT_NUM"), 20, false)) {
										returnCode = -22; // 내선번호 입력값을 확인하십시오.
										isCheck = false;
										break;
									}
									
									inLstData.add(map);
								}

							}

							if (isCheck) {
								AdminFileDao.insertJijum(commonServices, inLstData);
								modelMap.addAttribute("RSLT_MSG", "등록 : " + inLstData.size() + "건");
							}

						}

					} else {
						returnCode = -1;
					}
				} else {
					returnCode = -1;
				}
			}

			/*
			 *  0 성공
			 * -1 정상적인 파일이 아닙니다.
			 * -10 엑셀 서식이 맞지 않습니다.
			 * -20~ 입력 값이 형식이 맞지 않습니다.
			 * -1000 데이터가 중복되어 등록할 수 없습니다.
			 */
			modelMap.addAttribute("RSLT", returnCode);

		} catch (Exception e) {
			modelMap.addAttribute("RSLT", -9999);
			modelMap.addAttribute("RSLT_MSG", e.getMessage());
			logger.error(e.getMessage(), e);

		} finally {
			if (excelFile != null) {
				if (excelFile.exists() && excelFile.isFile()) {
					excelFile.delete();
				}
			}
		}
		return jsonView;
	}
	
	
	
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("dash_file_export")
	public ModelAndView exportDash(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request, HttpServletResponse response) {
		try {

			String dirPath = ExcelUtil.makeTempDir(request.getSession().getServletContext().getRealPath(""));
			if (dirPath != null) {
				
				List list = commonServices.getList("dash_file_export", param);

				String fileName = "dash_";
				int[] widthArray = {12,20,17,12,45,15,60};

				File file = ExcelUtil.createExcelFile(dirPath, fileName, titleArrayJijumDash, widthArray, columnArrayJijumDash, list);

				return new ModelAndView("downloadExcelView", "downloadFile", file);
			}

		} catch (Exception e) {
			modelMap.addAttribute("RSLT", -9999);
			logger.error(e.getMessage(), e);
		}
		return null;
	}
}