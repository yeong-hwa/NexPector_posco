package com.nns.common;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.nns.nexpector.common.service.CommonServices;

public class MailReportQuartzJob extends QuartzJobBean {

	private CommonServices commonServices;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	protected void executeInternal(JobExecutionContext arg0) throws JobExecutionException {
		try {
			ApplicationContext applicationContext = (ApplicationContext) arg0.getScheduler().getContext().get("applicationContext");
			commonServices = applicationContext.getBean(CommonServices.class);
			Map<String, Object> param = new HashMap<String, Object>();
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			
			//테스트용 
			//cal.set(2018, 7, 9);
			
			String day = fmt.format(cal.getTime());
			
			String xlsxFileAddress = "dayReport_" + day + ".xlsx";
			param.put("S_ST_DT", day);

			// excel 파일 저장
			try {
				//String directory = "D:\\excelfile\\daylyReport\\"; // window용
				String directory="/excelfile/daylyReport/";
				File xlsFile = new File(directory + xlsxFileAddress);
				if (!xlsFile.exists()) {
					xlsFile.getParentFile().mkdirs();
				}

				if (xlsFile.createNewFile()) { // 파일이 생성되는 시점
					// excel만들기
					XSSFWorkbook workBook = new XSSFWorkbook();
					String tablename = "TB_MON_HISTORY_RESOURCE_";
					int mm = cal.get(Calendar.MONTH) + 1;

					List<String> tableList = new ArrayList<String>(); // 테이블
					tableList.add(tablename + String.format("%02d", mm));
					List<String> preTableList = new ArrayList<String>(); // 이전 테이블
					cal.add(Calendar.DATE, -1);
					param.put("PRE_DT", fmt.format(cal.getTime()));

					int pre_mm = cal.get(Calendar.MONTH) + 1;
					preTableList.add(tablename + String.format("%02d", pre_mm));
					param.put("tableList", tableList);
					param.put("preTableList", preTableList);
					param.put("R_TYPE", 0);
					param.put("excelYn", "yes");

					List<HashMap<String, Object>> list = commonServices.getList("DayReportServerRetrieveListQry",param);
					logger.debug("DayReportServerRetrieveListQry: " + list);

					XSSFSheet sheet = workBook.createSheet("sheet1");
					Row row = null;
					Cell cell = null;
					int rowNo = 0;
					// 테두리 설정
					XSSFCellStyle headcs = workBook.createCellStyle();
					headcs.setBorderTop(BorderStyle.THIN);
					headcs.setBorderRight(BorderStyle.THIN);
					headcs.setBorderBottom(BorderStyle.THIN);
					headcs.setBorderLeft(BorderStyle.THIN);
					headcs.setAlignment(HorizontalAlignment.CENTER);
					
					XSSFCellStyle bodycs = workBook.createCellStyle();
					bodycs.setBorderTop(BorderStyle.THIN);
					bodycs.setBorderRight(BorderStyle.THIN);
					bodycs.setBorderBottom(BorderStyle.THIN);
					bodycs.setBorderLeft(BorderStyle.THIN);
				
					// 헤드
					row = sheet.createRow(rowNo++);
					cell = row.createCell(0);
					cell.setCellValue("DayReportServer : " + day);
					cell.setCellStyle(headcs);
					sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 10));

					String[] colums = { "그룹", "구분", "장비명", "IP Address", "자원", "현재값(%)", "평균값(%)", "피크(%)", "피크 일시", "전 일평균", "증감" };
					row = sheet.createRow(rowNo++);
					for (int i = 0, size = colums.length; i < size; i++) {
						cell = row.createCell(i);
						cell.setCellValue(colums[i]);
						cell.setCellStyle(headcs);
					}

					// 바디생성
					String colums1[] = { "S_GROUP_NAME", "S_TYPE_NAME", "S_MON_NAME", "S_MON_IP", "S_MAP_NAME",
							"N_CUR_USE", "N_AVG_USE", "N_MAX_USE", "D_MAX_DATE", "PRE_AVG_USE", "INCREASE" };
					for (HashMap<String, Object> item : list) {
						row = sheet.createRow(rowNo++);
						for (int i = 0, size = colums1.length; i < size; i++) {
							cell = row.createCell(i);
							cell.setCellValue(item.get(colums1[i]).toString());
							cell.setCellStyle(bodycs);
						}
					}
					/*for (int i = 0; i < colums.length; i++) {
						sheet.autoSizeColumn(i);
					}
					*/
					List<HashMap<String, Object>> list2 = commonServices.getList("DayReportHistoryErrorQry",param);
					logger.debug("DayReportHistoryErrorQry: " + list2);
					rowNo = rowNo+1;
					
					// 헤드
					sheet.addMergedRegion(new CellRangeAddress(rowNo, rowNo, 0, 6));
					row = sheet.createRow(rowNo++);
					cell = row.createCell(0);
					cell.setCellValue("DayReportError : " + day);
					cell.setCellStyle(headcs);

					String[] colums2 = { "발생시각", "장비명", "장비IP", "장애등급", "상태", "처리자ID", "내용"};
					row = sheet.createRow(rowNo++);
					for (int i = 0, size = colums2.length; i < size; i++) {
						cell = row.createCell(i);
						cell.setCellValue(colums2[i]);
						cell.setCellStyle(headcs);
					}

					// 바디생성
					String colums3[] = { "D_UPDATE_TIME", "S_MON_NAME", "S_MON_IP", "S_ALM_RATING_NAME", "N_ALM_STATUS_NAME","S_USER_ID", "S_MSG"};
					for (HashMap<String, Object> item2 : list2) {
						row = sheet.createRow(rowNo++);
						for (int j = 0, size = colums3.length; j < size; j++) {
							cell = row.createCell(j);
							cell.setCellValue(item2.get(colums3[j]).toString());
							cell.setCellStyle(bodycs);
						}
					}

					FileOutputStream fileOut = new FileOutputStream(xlsFile);
					workBook.write(fileOut);
					fileOut.close();
					//workBook.close();

					logger.debug("{} 데일리 리포트 파일이 생성되었습니다.", xlsxFileAddress);
				} else {
					logger.debug("{} 데일리 리포트 파일이 이미 생성되어있습니다.", xlsxFileAddress);
				}

			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}

			// 메일 발송

		} catch (Exception e) {
			logger.debug("데일리 리포트 파일 생성 fail");
			e.printStackTrace();
		}
	}

}
