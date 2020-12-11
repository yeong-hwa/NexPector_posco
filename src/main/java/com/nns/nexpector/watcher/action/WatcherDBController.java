package com.nns.nexpector.watcher.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;


/**
 * Net Backup DB 정보 조회 <br/>
 * Controller <br/>
 *
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherDBController {

	private static Logger logger = LoggerFactory.getLogger(WatcherDBController.class);

	@Autowired
	private CommonServices service;

	@Autowired
	private View json;

	/**
	 * DB NETBACKUP STATUS Count 정보 조회. <br/>
	 * 화면에서 Grid Columns 항목을 결정하기 위함
	 *
	 * @param map
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/db/status/count")
	public View getStatusCount(ModelMap map, @RequestParam Map param, HttpServletResponse res) {

		try {
			/* Tab 이 노출 되었다는것은 데이터가 존재하는 것이기때문에
			   Status 테이블만 존재하고 값이 없으면 Status2 테이블은 조회하지 않음. */
			int count = (Integer) service.getObject("db.dbStatusInfoCountQry", param);
			String status = "status";

			if (count == 0) {
				status = "status2";
			}

			map.addAttribute("status", status);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + "db.dbStatusInfoCountQry");
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage());
		}

		return json;
	}


	/**
	 * DB NETBACKUP STATUS 정보 조회.
	 *
	 * @param map
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/db/status")
	public View getStatusInfo(ModelMap map, @RequestBody Map param, HttpServletResponse res) {

		try {
			// Paging 안하고 Sorting 만 사용 할 경우
			if (param.get("skip") != null && param.get("take") != null) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}

			/* STATUS 테이블에 데이터가 존재 하면 STATUS 테이블 조회
			 * STATUS 테이블에 데이터가 존재하지 않으면 STATUS2 테이블 조회
			 * 테이블이 두개 인 이유는 같은 감시 이나 항목이 틀린 경우가 발생한 경우 */

			List result = service.getList("db.dbStatusInfoLstQry", param);

			if (result.isEmpty()) {
				result = service.getList("db.dbStatus2InfoLstQry", param);
			}

			map.addAttribute("list", result);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + "db.dbStatusInfoLstQry");
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage());
		}

		return json;
	}

	/**
	 * DB NET BACKUP TPCONF 정보 조회.
	 *
	 * @param map
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/db/tpconf")
	public View getTpconfInfo(ModelMap map, @RequestBody Map param, HttpServletResponse res) {

		try {
			// Paging 안하고 Sorting 만 사용 할 경우
			if (param.get("skip") != null && param.get("take") != null) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}
			List result = service.getList("db.dbTpconfInfoLstQry", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + "db.dbTpconfInfoLstQry");
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage());
		}

		return json;
	}

	/**
	 * DB NET BACKUP MEDIA 정보 조회.
	 *
	 * @param map
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/db/media")
	public View getMediaInfo(ModelMap map, @RequestBody Map param, HttpServletResponse res) {

		try {
			// Paging 안하고 Sorting 만 사용 할 경우
			if (param.get("skip") != null && param.get("take") != null) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}
			List result = service.getList("db.dbMediaInfoLstQry", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("qry_name:" + "db.dbMediaInfoLstQry");
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage());
		}

		return json;
	}

}
