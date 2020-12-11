package com.nns.nexpector.common.action;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.nns.nexpector.admin.Menu;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class CommonController {

	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);

	@Autowired
	private CommonServices service;
	@Autowired
	private View jsonView;
	@Autowired
	private View jsonView2;
	@Autowired
	private HttpSession sess;
	@Autowired
	private Menu menu;
	@Value("#{serviceProps['watcher.detail.navi.countperpage']}")
	private int detailLeftCountPerPage;

	private void addParam(Map param) {
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}

	@RequestMapping(value = "/ajax/{module}/{path}/{jspName}", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView goWatcherJspPage(ModelMap map, @PathVariable String module, @PathVariable String path,
			@PathVariable String jspName, @RequestParam Map param) {
		addParam(param);

		String path_name = path.replaceAll("\\.", "/");
		String jspPath = module + "/" + path_name + "/" + jspName;

		if (logger.isDebugEnabled()) {
			logger.debug("jspPath:: " + jspPath + " - " + param);
		}
		try {
			/*
			 * 페이지에 테이블 조회 결과등을 넘기고 싶은 경우 url/go_{jspName} 에 파라메터로 req_data 를 추가 req_data의
			 * 값에 대한 형식은 값이름-쿼리이름;값이름-쿼리이름 = 값과 쿼리이름의 구분자는 ";" 이고, 여러 값이 필요한 경우 구분은 "|" 으로
			 * 구분 한다. 추가 : 쿼리명 뒤에 콜론(:)에 리턴 타입 지정 기본 List 형태 리턴 map 인경우 Map 형태로 리턴
			 */
			if (param.get("req_data") != null && !param.get("req_data").toString().equals("")) {
				String req_data = param.get("req_data").toString();
				String[] arr_data = req_data.split("\\|");

				for (int i = 0; i < arr_data.length; i++) {
					String[] tmp_arr = arr_data[i].split(";");
					if (tmp_arr.length == 1) {
						map.addAttribute(service.getList(tmp_arr[0], param));
					} else if (tmp_arr.length > 1) {
						if (tmp_arr[1].indexOf(":") != -1) {
							String[] qry_arr = tmp_arr[1].split(":");
							if (qry_arr.length > 1) {
								if (qry_arr[1].equals("map")) {
									Map m = service.getMap(qry_arr[0], param);
									logger.debug(tmp_arr[0] + " - " + m);
									map.addAttribute(tmp_arr[0], m);
								} else {
									List lst = service.getList(tmp_arr[1], param);
									logger.debug(tmp_arr[0] + " - " + lst);
									map.addAttribute(tmp_arr[0], lst);
								}
							}
						} else {
							List lst = service.getList(tmp_arr[1], param);
							logger.debug(tmp_arr[0] + " - " + lst);
							map.addAttribute(tmp_arr[0], lst);
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error("path_name:" + jspPath);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView(jspPath);
	}

	@RequestMapping("/admin/go_{path_name}")
	public ModelAndView goAdminJspPage(HttpServletRequest req, HttpServletResponse res, ModelMap map,
			@PathVariable String path_name, @RequestParam Map param) throws Exception {

		res.setHeader("Pragma", "No-cache");
		res.setDateHeader("Expires", -1);
		res.setHeader("Cache-Control", "no-cache");

		menu.setAdminLeftMenu(req);

		addParam(param);
		path_name = path_name.replaceAll("\\.", "/");

		if (logger.isDebugEnabled()) {
			logger.debug("path_name:: " + path_name + " - " + param);
		}

		try {
			/*
			 * 페이지에 테이블 조회 결과등을 넘기고 싶은 경우 url/go_{path_name} 에 파라메터로 req_data 를 추가 req_data의
			 * 값에 대한 형식은 값이름-쿼리이름;값이름-쿼리이름 = 값과 쿼리이름의 구분자는 ";" 이고, 여러 값이 필요한 경우 구분은 "|" 으로
			 * 구분 한다. 추가 : 쿼리명 뒤에 콜론(:)에 리턴 타입 지정 기본 List 형태 리턴 map 인경우 Map 형태로 리턴
			 */
			if (param.get("req_data") != null && !param.get("req_data").toString().equals("")) {
				String req_data = param.get("req_data").toString();
				String[] arr_data = req_data.split("\\|");

				for (int i = 0; i < arr_data.length; i++) {
					String[] tmp_arr = arr_data[i].split(";");
					if (tmp_arr.length == 1) {
						map.addAttribute(service.getList(tmp_arr[0], param));
					} else if (tmp_arr.length > 1) {
						if (tmp_arr[1].indexOf(":") != -1) {
							String[] qry_arr = tmp_arr[1].split(":");
							if (qry_arr.length > 1) {
								if (qry_arr[1].equals("map")) {
									Map m = service.getMap(qry_arr[0], param);
									logger.debug(tmp_arr[0] + " - " + m);
									map.addAttribute(tmp_arr[0], m);
								} else {
									List lst = service.getList(tmp_arr[1], param);
									logger.debug(tmp_arr[0] + " - " + lst);
									map.addAttribute(tmp_arr[0], lst);
								}
							}
						} else {
							List lst = service.getList(tmp_arr[1], param);
							logger.debug(tmp_arr[0] + " - " + lst);
							map.addAttribute(tmp_arr[0], lst);
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error("path_name:" + path_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/admin/" + path_name);
	}

	@RequestMapping("/watcher/go_{path_name}")
	public ModelAndView goWatcherJspPage(ModelMap map, @PathVariable String path_name, @RequestParam Map param,
			HttpServletResponse res) {
		res.setHeader("Pragma", "No-cache");
		res.setDateHeader("Expires", -1);
		res.setHeader("Cache-Control", "no-cache");

		addParam(param);
		path_name = path_name.replaceAll("\\.", "/");

		if (logger.isDebugEnabled()) {
			logger.debug("path_name:: " + path_name + " - " + param);
		}
		try {
			/*
			 * 페이지에 테이블 조회 결과등을 넘기고 싶은 경우 url/go_{path_name} 에 파라메터로 req_data 를 추가 req_data의
			 * 값에 대한 형식은 값이름-쿼리이름;값이름-쿼리이름 = 값과 쿼리이름의 구분자는 ";" 이고, 여러 값이 필요한 경우 구분은 "|" 으로
			 * 구분 한다. 추가 : 쿼리명 뒤에 콜론(:)에 리턴 타입 지정 기본 List 형태 리턴 map 인경우 Map 형태로 리턴
			 */
			if (param.get("req_data") != null && !param.get("req_data").toString().equals("")) {
				String req_data = param.get("req_data").toString();
				String[] arr_data = req_data.split("\\|");

				for (int i = 0; i < arr_data.length; i++) {
					String[] tmp_arr = arr_data[i].split(";");
					
					if (tmp_arr.length == 1) {
						map.addAttribute(service.getList(tmp_arr[0], param));
					} else if (tmp_arr.length > 1) {
						if (tmp_arr[1].indexOf(":") != -1) {
							String[] qry_arr = tmp_arr[1].split(":");
							if (qry_arr.length > 1) {
								if (qry_arr[1].equals("map")) {
									Map m = service.getMap(qry_arr[0], param);
									logger.debug(tmp_arr[0] + " - " + m);
									map.addAttribute(tmp_arr[0], m);
								} else {
									List lst = service.getList(tmp_arr[1], param);
									logger.debug(tmp_arr[0] + " - " + lst);
									map.addAttribute(tmp_arr[0], lst);
								}
							}
						} else {
							
							//이력/통계조회 > 일일 보고서 쿼리만 table리스트로 가져와야 하므로 분기함.
							if (tmp_arr[1].equals("DayReportServerRetrieveListQry")) {
								param = getDayReportServerRetrieveListQryParam(param);
								map.addAttribute("params", param);
							} //end 일일,주간,월간 서버쿼리
							
							//이력/통계조회 > 일일 보고서 쿼리만 table리스트로 가져와야 하므로 분기함.
							if (tmp_arr[1].equals("DayReportErrorRetrieveListQry")) {
								param = getDayReportServerRetrieveListQryParam(param);
								param.put("excelYn", "yes"); //엑셀이면 페이징 없앰		
							} //end 일일,주간,월간 서버쿼리
							
							List lst = service.getList(tmp_arr[1], param);
							logger.debug(tmp_arr[0] + " - " + lst);
							map.addAttribute(tmp_arr[0], lst);
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error("path_name:" + path_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/" + path_name);
	}

	@RequestMapping("/dashboard/go_{path_name}")
	public ModelAndView goDashboardJspPage(ModelMap map, @PathVariable String path_name, @RequestParam Map param,
			HttpServletResponse res) {
		res.setHeader("Pragma", "No-cache");
		res.setDateHeader("Expires", -1);
		res.setHeader("Cache-Control", "no-cache");

		addParam(param);
		path_name = path_name.replaceAll("\\.", "/");

		if (logger.isDebugEnabled()) {
			logger.debug("path_name:: " + path_name + " - " + param);
		}
		try {
			/*
			 * 페이지에 테이블 조회 결과등을 넘기고 싶은 경우 url/go_{path_name} 에 파라메터로 req_data 를 추가 req_data의
			 * 값에 대한 형식은 값이름-쿼리이름;값이름-쿼리이름 = 값과 쿼리이름의 구분자는 ";" 이고, 여러 값이 필요한 경우 구분은 "|" 으로
			 * 구분 한다. 추가 : 쿼리명 뒤에 콜론(:)에 리턴 타입 지정 기본 List 형태 리턴 map 인경우 Map 형태로 리턴
			 */
			if (param.get("req_data") != null && !param.get("req_data").toString().equals("")) {
				String req_data = param.get("req_data").toString();
				String[] arr_data = req_data.split("\\|");

				for (int i = 0; i < arr_data.length; i++) {
					String[] tmp_arr = arr_data[i].split(";");
					if (tmp_arr.length == 1) {
						map.addAttribute(service.getList(tmp_arr[0], param));
					} else if (tmp_arr.length > 1) {
						if (tmp_arr[1].indexOf(":") != -1) {
							String[] qry_arr = tmp_arr[1].split(":");
							if (qry_arr.length > 1) {
								if (qry_arr[1].equals("map")) {
									Map m = service.getMap(qry_arr[0], param);
									logger.debug(tmp_arr[0] + " - " + m);
									map.addAttribute(tmp_arr[0], m);
								} else {
									List lst = service.getList(tmp_arr[1], param);
									logger.debug(tmp_arr[0] + " - " + lst);
									map.addAttribute(tmp_arr[0], lst);
								}
							}
						} else {
							List lst = service.getList(tmp_arr[1], param);
							logger.debug(tmp_arr[0] + " - " + lst);
							map.addAttribute(tmp_arr[0], lst);
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error("path_name:" + path_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/dashboard/" + path_name);
	}

	// JSP Server Page Paging
	@RequestMapping("/watcher/goPagination_{path_name}")
	public ModelAndView goWatcherPaginationJspPage(ModelMap map, @PathVariable String path_name,
			@RequestParam Map param, HttpServletResponse res) {
		res.setHeader("Pragma", "No-cache");
		res.setDateHeader("Expires", -1);
		res.setHeader("Cache-Control", "no-cache");

		addParam(param);
		path_name = path_name.replaceAll("\\.", "/");

		if (logger.isDebugEnabled()) {
			logger.debug("path_name:: " + path_name + " - " + param);
		}
		try {
			/*
			 * 페이지에 테이블 조회 결과등을 넘기고 싶은 경우 url/go_{path_name} 에 파라메터로 req_data 를 추가 req_data의
			 * 값에 대한 형식은 값이름-쿼리이름;값이름-쿼리이름 = 값과 쿼리이름의 구분자는 ";"
			 */
			if (param.get("req_data") != null && !param.get("req_data").toString().equals("")) {
				String[] values = ((String) param.get("req_data")).split(";");
				String attrKeyName = values[0];
				String qry_name = values[1];

				int currentPageNo = param.get("currentPageNo") == null ? 1
						: Integer.parseInt((String) param.get("currentPageNo"));
				int countPerPage = param.get("countPerPage") == null ? 15
						: Integer.parseInt((String) param.get("countPerPage"));
				int pageSize = param.get("pageSize") == null ? 5 : Integer.parseInt((String) param.get("pageSize"));

				// 필수 정보를 넣어 준다.
				PaginationInfo paginationInfo = new PaginationInfo();
				paginationInfo.setCurrentPageNo(currentPageNo); // 현재 페이지 번호
				paginationInfo.setRecordCountPerPage(countPerPage); // 한 페이지에 게시되는 게시물 건수
				paginationInfo.setPageSize(pageSize); // 페이징 리스트의 사이즈

				int firstRecordIndex = paginationInfo.getFirstRecordIndex();
				int lastRecordIndex = paginationInfo.getLastRecordIndex();

				param.put("firstRecordIndex", firstRecordIndex);
				param.put("lastRecordIndex", pageSize);

				List result = service.getList(qry_name, param);

				int totalCount = result == null || result.isEmpty() ? 0
						: Integer.parseInt(String.valueOf(((Map) result.get(0)).get("TOTAL_COUNT")));
				paginationInfo.setTotalRecordCount(totalCount);

				map.addAttribute(attrKeyName, result);
				map.addAttribute("paginationInfo", paginationInfo);
			}
		} catch (Exception e) {
			logger.error("path_name:" + path_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/" + path_name);
	}

	@RequestMapping({ "/admin/map_{qry_name}", "/watcher/map_{qry_name}" })
	public View getMapData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		try {
			Map result = service.getMap(qry_name, param);
			map.addAttribute(result == null ? Collections.EMPTY_MAP : result);
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping({ "/admin/lst_{qry_name}", "/watcher/lst_{qry_name}", "/dashboard/lst_{qry_name}" })
	public View getListData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		try {
			List list = service.getList(qry_name, param);
			map.addAttribute(list);
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping({ "/dashboard/chart/{qry_name}" })
	public View getChartData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		try {
			map.addAttribute(service.getList(qry_name, param));
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	// JSON Paging
	@RequestMapping({ "/admin/pagination_{qry_name}", "/watcher/pagination_{qry_name}" })
	public View getPaginationListData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		if (logger.isDebugEnabled()) {
			logger.debug("qry_name:: " + qry_name + " - " + param);
		}
		try {
			int currentPageNo = param.get("currentPageNo") == null ? 1
					: Integer.parseInt((String) param.get("currentPageNo"));
			int countPerPage = param.get("countPerPage") == null ? detailLeftCountPerPage
					: Integer.parseInt((String) param.get("countPerPage"));
			int pageSize = param.get("pageSize") == null ? 15 : Integer.parseInt((String) param.get("pageSize"));

			// 필수 정보를 넣어 준다.
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(currentPageNo); // 현재 페이지 번호
			paginationInfo.setRecordCountPerPage(countPerPage); // 한 페이지에 게시되는 게시물 건수
			paginationInfo.setPageSize(pageSize); // 페이징 리스트의 사이즈

			int firstRecordIndex = paginationInfo.getFirstRecordIndex();
			int lastRecordIndex = paginationInfo.getLastRecordIndex();

			param.put("firstRecordIndex", firstRecordIndex);
			param.put("lastRecordIndex", pageSize);

			List result = service.getList(qry_name, param);

			int totalCount = result == null || result.isEmpty() ? 0
					: Integer.parseInt(String.valueOf(((Map) result.get(0)).get("TOTAL_COUNT")));
			paginationInfo.setTotalRecordCount(totalCount);

			map.addAttribute("list", result);
			map.addAttribute("paginationInfo", paginationInfo);
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping(value = { "/admin/kendoPagination_{qry_name}", "/watcher/kendoPagination_{qry_name}" }, method = RequestMethod.POST)
	public View getKendoPaginationListData(ModelMap map, @PathVariable String qry_name, @RequestBody Map<String, Object> param) {
		addParam(param);
		if (logger.isDebugEnabled()) {
			logger.debug("qry_name :: " + qry_name + " - " + param);
		}
		try {
			// Paging 안하고 Sorting 만 사용 할 경우
			if (param.get("skip") != null && param.get("take") != null) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}

			//이력/통계조회 > 일일 보고서 쿼리만 table리스트로 가져와야 하므로 분기함.
			
			if (qry_name.equals("DayReportServerRetrieveListQry")) {
				param = getDayReportServerRetrieveListQryParam(param);
				map.addAttribute("params", param);
			} //end 일일,주간,월간 서버쿼리
			
			//이력/통계조회 > 일일 보고서 쿼리만 table리스트로 가져와야 하므로 분기함.
			if (qry_name.equals("DayReportErrorRetrieveListQry")) {
				param = getDayReportServerRetrieveListQryParam(param);
			} //end 일일,주간,월간 서버쿼리	
			
			List result = service.getList(qry_name, param);
			map.addAttribute("list", result);
			logger.info("request parameter:" + LogUtils.mapToString(param));
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage());
		}

		return jsonView2;
	}

	@RequestMapping({ "/admin/pagination", "/watcher/pagination" })
	public String getPaginationTotalRecordCountListData(ModelMap map, @RequestParam Map param) {
		addParam(param);

		try {
			int currentPageNo = param.get("currentPageNo") == null ? 1
					: Integer.parseInt((String) param.get("currentPageNo"));
			int recordCountPerPage = param.get("recordCountPerPage") == null ? detailLeftCountPerPage
					: Integer.parseInt((String) param.get("recordCountPerPage"));
			int pageSize = param.get("pageSize") == null ? 5 : Integer.parseInt((String) param.get("pageSize"));
			int totalRecordCount = param.get("totalRecordCount") == null ? 0
					: Integer.parseInt((String) param.get("totalRecordCount"));

			// 필수 정보를 넣어 준다.
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(currentPageNo); // 현재 페이지 번호
			paginationInfo.setRecordCountPerPage(recordCountPerPage); // 한 페이지에 게시되는 게시물 건수
			paginationInfo.setPageSize(pageSize); // 페이징 리스트의 사이즈
			paginationInfo.setTotalRecordCount(totalRecordCount); // 조회된 레코드 총 개수

			map.addAttribute("paginationInfo", paginationInfo);
		} catch (Exception e) {
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return "/watcher/common/pagination";
	}

	@RequestMapping("/map_chart_data")
	public View getMapChartData(ModelMap map, @RequestParam Map param) {
		addParam(param);
		try {
			map.addAttribute("ALL", service.getList("serverStatusQry2_all", param));
			map.addAttribute("TYPE", service.getList("serverStatusQry2_type", param));
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("/page_{qry_name}")
	public View getPageData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		try {
			map.addAttribute(service.getPageData(qry_name, param));
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("/pageNavigate")
	public ModelAndView getPageNavigate(ModelMap map, @RequestParam Map param) {
		addParam(param);
		try {
			logger.debug(param.toString());
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/include/paging/pageNavigate");
	}

	private static String outPrint(Map param, String name) {
		StringBuffer sb = new StringBuffer();
		String nl = "\n";
		sb.append(name + nl);

		Set set = param.keySet();
		Iterator iter = set.iterator();

		while (iter.hasNext()) {
			String key = (String) iter.next();
			sb.append("key : " + key + " , " + param.get(key) + nl);
		}
		sb.append("end." + nl);

		return sb.toString();

	}

	@RequestMapping({ "/admin/ins_{qry_name}", "/watcher/ins_{qry_name}" })
	public View getInsData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		HashMap m = new HashMap();
		try {
			if (!qry_name.contains(";")) {
				m.put("RSLT", service.getInsData(qry_name, param));
			} else {
				String[] tmp_arr = qry_name.split(";");
				int tmp_rslt = 0;
				for (int i = 0; i < tmp_arr.length; i++) {
					tmp_rslt += service.getInsData(tmp_arr[i], param);
				}
				m.put("RSLT", tmp_rslt);
			}
			map.addAttribute(m);

			if (qry_name.equals("snmp_alarm.insert_data")) {

				logger.debug(outPrint(param, "snmp_alarm.insert_data"));

				// INSERT TB_INS_COMMAND
				HashMap commandMap = new HashMap();
				commandMap.put("N_TO", "4");
				commandMap.put("N_COMMAND", "303");
				commandMap.put("N_SID", param.get("N_MON_ID"));
				commandMap.put("S_VALUE", "");
				service.getInsData("insViewToProcess", commandMap);
			}

		} catch (SQLException se) {
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
		} catch (Exception e) {
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping({ "/admin/upd_{qry_name}", "/watcher/upd_{qry_name}" })
	public View getUpdData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		HashMap m = new HashMap();
		try {
			m.put("RSLT", service.getUpdData(qry_name, param));
			map.addAttribute(m);

			if (qry_name.equals("snmp_alarm.update_data")) {

				logger.debug(outPrint(param, "snmp_alarm.update_data"));

				// INSERT TB_INS_COMMAND
				HashMap commandMap = new HashMap();
				commandMap.put("N_TO", "4");
				commandMap.put("N_COMMAND", "303");
				commandMap.put("N_SID", param.get("N_MON_ID"));
				commandMap.put("S_VALUE", "");
				service.getInsData("insViewToProcess", commandMap);
			}

		} catch (SQLException se) {
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error("message:" + se.getMessage() + ", code:" + se.getErrorCode(), se);
		} catch (Exception e) {
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping({ "/admin/del_{qry_name}", "/watcher/del_{qry_name}" })
	public View getDelData(ModelMap map, @PathVariable String qry_name, @RequestParam Map param) {
		addParam(param);
		HashMap m = new HashMap();
		try {
			m.put("RSLT", service.getDelData(qry_name, param));
			map.addAttribute(m);

			if (qry_name.equals("snmp_alarm.delete_data")) {

				logger.debug(outPrint(param, "snmp_alarm.delete_data"));

				// INSERT TB_INS_COMMAND
				HashMap commandMap = new HashMap();
				commandMap.put("N_TO", "4");
				commandMap.put("N_COMMAND", "303");
				commandMap.put("N_SID", param.get("N_MON_ID"));
				commandMap.put("S_VALUE", "");
				service.getInsData("insViewToProcess", commandMap);
			}

		} catch (SQLException se) {
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error("message:" + se.getMessage() + ", code:" + se.getErrorCode(), se);
		} catch (Exception e) {
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping({ "/session_err", "/admin/session_err" })
	public ModelAndView getSessionError() {
		return new ModelAndView("/include/error/session_err");
	}

	@RequestMapping("/watcher/history/accrue_resource/save_test_data")
	@ResponseStatus(value = HttpStatus.OK)
	@Transactional
	public void saveTestData(@RequestParam("S_MAP_KEY") String mapKey, @RequestParam("N_MON_ID") int monId,
			@RequestParam("MONTH") String month) throws Exception {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("S_MAP_KEY", mapKey);
		params.put("N_MON_ID", monId);

		for (int i = 1; i <= 30; i++) {
			String day = i < 10 ? "0" + i : String.valueOf(i);
			params.put("N_DAY", month + day);

			for (int j = 0; j <= 23; j++) {
				params.put("TIME_" + (j < 10 ? "0" + j : String.valueOf(j)), (int) (Math.random() * 100) + 1);
			}

			service.getInsData("history_stats.insertAccrueResource", params);
		}
	}

	public static void main(String[] args) {
		int[] arr = splitToComponentTimes(61);
		System.out.println(Arrays.toString(arr));

	}

	public static int[] splitToComponentTimes(long longVal) {
		long secondL = longVal;
		int nDay = (int) secondL / (60 * 60 * 24);
		int nDayToSec = nDay * (60 * 60 * 24); // 일 * 86400초
		secondL = secondL - nDayToSec;
		int nHours = (int) (secondL / (60 * 60));
		secondL = (int) secondL - nHours * (60 * 60);
		int nMins = (int) (secondL / 60);
		secondL = secondL - nMins * 60;
		int nSec = (int) secondL;

		int[] ints = { nDay, nHours, nMins, nSec };
		return ints;
	}
	
	//이력/통계조회 > 일일 보고서 쿼리만 table리스트로 파라미터 만들기
	private Map<String, Object> getDayReportServerRetrieveListQryParam(Map<String, Object> param) {
		String st_date = param.get("S_ST_DT").toString();
		String rtype = param.get("R_TYPE").toString();
		String tablename = param.get("S_TABLE").toString();
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date stdate = null;
		try {
			stdate = dt.parse(st_date);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Calendar cal = Calendar.getInstance();
		cal.setTime(stdate);
		int mm = cal.get(Calendar.MONTH)+1;
		List<String> tableList = new ArrayList<String>(); // 테이블
		tableList.add(tablename+String.format("%02d", mm));
		
		List<String> preTableList = new ArrayList<String>(); // 이전 테이블
		if (rtype.equals("1")) { // 주간
			//이번주 날짜
			Calendar tweek = Calendar.getInstance();
			tweek.setTime(stdate);
			tweek.set(Calendar.DAY_OF_WEEK, 7); 
			List<String> dayList = new ArrayList<String>();
			dayList.add(dt.format(tweek.getTime()));
			while(tweek.get(Calendar.DAY_OF_WEEK) !=1 ) {
				tweek.add(Calendar.DATE, -1);
				dayList.add(dt.format(tweek.getTime()));
				if(mm != tweek.get(Calendar.MONTH)+1) {
					tableList.add(tablename+String.format("%02d", mm));
				}
			}
			param.put("T_ST_DT",dayList.get(dayList.size()-1));
			param.put("T_ED_DT",dayList.get(0));
			
			tweek.add(Calendar.DATE, -1);
			List<String> preDayList = new ArrayList<String>();
			preDayList.add(dt.format(tweek.getTime()));
			int pre_mm = tweek.get(Calendar.MONTH)+1;
			preTableList.add(tablename+String.format("%02d", pre_mm));
			while(tweek.get(Calendar.DAY_OF_WEEK) != 1 ) {
				tweek.add(Calendar.DATE, -1);
				preDayList.add(dt.format(tweek.getTime()));
				if(pre_mm != tweek.get(Calendar.MONTH)+1) {
					preTableList.add(tablename+String.format("%02d", pre_mm));
				}
				pre_mm=tweek.get(Calendar.MONTH)+1;
			}
			param.put("P_ST_DT",preDayList.get(preDayList.size()-1));
			param.put("P_ED_DT",preDayList.get(0));
		} else if (rtype.equals("2")) { // 월간
			cal.add ( cal.MONTH, - 1 );
			int pre_mm = cal.get(Calendar.MONTH);
			param.put("PRE_DT", dt.format(cal.getTime()));
			preTableList.add(tablename+String.format("%02d", pre_mm));
		} else { // r_type 0 /일간					
			cal.add(Calendar.DATE, -1);
			int pre_mm = cal.get(Calendar.MONTH)+1;
			param.put("PRE_DT", dt.format(cal.getTime()));
			preTableList.add(tablename+String.format("%02d", pre_mm));
		}
		LinkedHashSet<String> temp;
		if(tableList.size() >1) {
			temp = new LinkedHashSet<String>();
			temp.addAll(tableList);
			tableList.clear();
			tableList.addAll(temp);
		}
		if(preTableList.size() >1) {
			temp = new LinkedHashSet<String>();
			temp.addAll(preTableList);
			preTableList.clear();
			preTableList.addAll(temp);
		}
		param.put("tableList", tableList);
		param.put("preTableList", preTableList);
	
		return param;
	}

}
