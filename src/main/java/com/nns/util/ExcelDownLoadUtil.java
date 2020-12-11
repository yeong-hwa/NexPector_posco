/*                                                                                 
 * Copyright (c) 2011 ZOOIN.NET CO.,LTD. All rights reserved.                         
 *                                                                                 
 * This software is the confidential and proprietary information of ZOOIN.NET CO.,LTD.
 * You shall not disclose such Confidential Information and shall use it           
 * only in accordance with the terms of the license agreement you entered into      
 * with ZOOIN.NET CO.,LTD.                                                            
 */
package com.nns.util;

import jxl.Workbook;
import jxl.write.*;
import jxl.write.Number;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * List-Map 구조의 데이터를 엑셀로 다운로드하게 한다. 사용법은 아래 코드와 같다.
 * 출력되는 지점을 조정하기 위해서는 이차원 배열로 구성되는 titleArray의 구성을 변경한다.
 * List-Map 구조에 순번데이터가 없어 순번을 출력할 수 없을 경우 isNumbering = true로 설정하면,
 * 첫번째 컬럼에 순번을 출력하고, keyArray의 값은 한칸씩 밀려서 출력된다. 
 * <code>
 *	private ModelAndView excelDownLoad(HttpServletRequest req, HttpServletResponse res) throws WriteException, IOException {
 *
 *		String [][] titleArray = {{"번호", "소속", "평가대상그룹", "성명")};
 *		String [] keyArray = {"ORGNM", "TAGTGRP_NM", "EMP_NM"};
 *		List list2MapData = getSqlMapClientTemplate().queryForList("list2MapData");
 *		ExcelDownLoad.downLoad(response, list2MapData, titleArray, keyArray, "excel.xls",  "시트명", true);
 *		
 *		return null;
 *	}
 *
 * </code>
 *   
 * @author       fishingday
 * @version      1.0                   
 * @since        JDK1.4  
 * @HISTORY      : AUTHOR         DATE             DESC
 *                 fishingday     2007. 06. 22     CREATE          
 */

public class ExcelDownLoadUtil {
	private static final String CHARSET = "euc-kr";
	
	/**
	 * List-Map 구조의 데이터를 엑셀로 다운로드하게 한다. 사용법은 아래 코드와 같다.
	 *
	 * <code>
	 *
	 *	String [][] titleArray = {{"번호", "소속", "평가대상그룹", "성명")};
	 *	String [] keyArray = {"NUM", "ORGNM", "TAGTGRP_NM", "EMP_NM"};
	 *	List list2MapData = getSqlMapClientTemplate().queryForList("list2MapData");
	 *	ExcelDownLoad.downLoad(response, list2MapData, titleArray, keyArray, "excel.xls", "시트명", false);
	 *
	 * </code>
	 * @param request 
	 * @param response 결과를 출력한 Response
	 * @param dataList 엑셀로 변환할 List-Map 형태의 데이터
	 * @param titleArray 각 컬럼의 제목. 
	 * @param keyArray Map에서 데이터를 가져오기 위한 Key 값. 꺼내올 값의 순서대로 입력한다.
	 * @param fileName 다운로드되는 파일의 기본이름. 없는 경우 날짜(ex-20070622.xls)가 들어간다.
	 * @param sheetName Sheet의 이름. 없을 경우 파일명과 동일하다.
	 * @param isNumbering TRUE 이면 첫번째 컬럼에 순번을 넣는다. List 값은 하나씩 밀려서 찍는다. 기본값은 false
	 * @throws java.io.IOException
	 * @throws jxl.write.WriteException
	 */
	public static void downLoad(HttpServletRequest request, HttpServletResponse response, List dataList, String[][] titleArray, String[] keyArray, String fileName, String sheetName, boolean isNumbering) throws IOException, WriteException {

		// 파일명이 없으면 날짜로 파일명을 생성해준다.
		if(fileName == null || "".equals(fileName)){
			fileName = new java.text.SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls";
		}

		// 시트명이 없으면 ...
		if(sheetName == null || "".equals(sheetName)){
			sheetName = "Sheet1";
		}

		// 정할 것은 정하고...
     	response.setContentType("application/vnd.ms-excel; charset=" + CHARSET);
	    response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes(CHARSET), "latin1") + ";");

     	// 엑셀 테이터를 만들고...
     	WritableWorkbook workbook = Workbook.createWorkbook(response.getOutputStream());

	    WritableCellFormat titelFormat= new WritableCellFormat();
		WritableCellFormat contextFormat= new WritableCellFormat();

		titelFormat.setBackground(jxl.format.Colour.GRAY_25 );
		titelFormat.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN );
		titelFormat.setAlignment(jxl.format.Alignment.CENTRE);

		contextFormat.setBackground(jxl.format.Colour.WHITE );
		contextFormat.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN );
		contextFormat.setAlignment(jxl.format.Alignment.LEFT);

		int cnt = 0;

	    workbook.createSheet(sheetName, cnt);
	    WritableSheet sheet = workbook.getSheet(cnt);

	    int s = 0;
	    if(fileName.equals("StbStatsSchedule.xls")){
	    	String CORP_NM = "";
	    	String CH_NM = "";
		    String SCHE_NM = "";
		    String VIEW_DAY = "";
		    String LABEL_CORP_NM = "";
		    String LABEL_CH_NM = "";
		    String LABEL_SCHE_NM = "";
		    String LABEL_BRDCST_TIME = "";
		    String LABEL_AVG_VIEW_TIME = "";
		    Integer SUM_VIEW_TIME = 0;
		    Integer NUM = 0;
		    for(int i = 0; i < dataList.size(); i++){
		    	Map dataMap = (Map) dataList.get(i);
		    	CORP_NM = (String) dataMap.get("CORP_NM");
		    	CH_NM = (String) dataMap.get("CH_NM");
		    	SCHE_NM = (String) dataMap.get("SCHE_NM");
		    	VIEW_DAY = (String) dataMap.get("VIEW_DAY");
		    	LABEL_CORP_NM = (String) dataMap.get("LABEL_CORP_NM");
		    	LABEL_CH_NM = (String) dataMap.get("LABEL_CH_NM");
		    	LABEL_SCHE_NM = (String) dataMap.get("LABEL_SCHE_NM");
		    	LABEL_BRDCST_TIME = (String) dataMap.get("LABEL_BRDCST_TIME");
		    	LABEL_AVG_VIEW_TIME = (String) dataMap.get("LABEL_AVG_VIEW_TIME");
		    	SUM_VIEW_TIME += ((java.lang.Number)dataMap.get("VIEW_AVG")).intValue();
		    	NUM = Integer.parseInt(dataMap.get("NUM").toString());
		    }
		    Integer AVG_VIEW_TIME = (SUM_VIEW_TIME) / dataList.size();

		    Label lab = new Label( 0, 0, LABEL_CORP_NM, titelFormat);
		    Label lab1 = new Label( 1, 0, CORP_NM);
		    Label lab2 = new Label( 0, 1, LABEL_CH_NM, titelFormat);
		    Label lab3 = new Label( 1, 1, CH_NM);
	    	Label lab4 = new Label( 0, 2, LABEL_SCHE_NM, titelFormat);
	    	Label lab5 = new Label( 1, 2, SCHE_NM);
	    	Label lab6 = new Label( 0, 3, LABEL_BRDCST_TIME, titelFormat);
	    	Label lab7 = new Label( 1, 3, VIEW_DAY);
	    	Label lab8 = new Label( 0, 4, LABEL_AVG_VIEW_TIME, titelFormat);
	    	Label lab9 = new Label( 1, 4, AVG_VIEW_TIME + "%");
	    	sheet.insertRow(2);
	    	sheet.addCell(lab);
	    	sheet.addCell(lab1);
	    	sheet.addCell(lab2);
	    	sheet.addCell(lab3);
	    	sheet.addCell(lab4);
	    	sheet.addCell(lab5);
	    	sheet.addCell(lab6);
	    	sheet.addCell(lab7);
	    	sheet.addCell(lab8);
	    	sheet.addCell(lab9);

	    	s = 7;
	    }

        // 타이틀...
       for( int t = 0 + s; t < (titleArray.length + s) ; t++){
        	for(int t_bu = 0; t_bu < titleArray[0].length; t_bu++){
        		Label lab = new Label( t_bu, t, titleArray[0][t_bu], titelFormat);
        		sheet.addCell(lab);
        	}
        }

        // 내용
        int titleSize =  titleArray.length;
		for(int h = 0 + s;h < dataList.size() + s; h++){
			Map m = (Map)dataList.get(h - s);

			int numberingSize = 0;
			if(isNumbering){ // 번호 붙이가 있으면... 번호 붙이고...
				Number num = new Number(numberingSize, h + titleSize, h + 1, contextFormat);
				sheet.addCell(num);
				numberingSize = 1;
			}

			if((h/60000) == (cnt + 1)){
				cnt = cnt + 1;
				workbook.createSheet(sheetName + cnt, cnt);
				sheet = workbook.getSheet(cnt);
				System.out.println(workbook.getSheetNames());

				for( int t = 0 + s; t < (titleArray.length + s) ; t++){
		        	for(int t_bu = 0; t_bu < titleArray[0].length; t_bu++){
		        		Label lab = new Label( t_bu, t, titleArray[0][t_bu], titelFormat);
		        		sheet.addCell(lab);
		        	}
		        }
			}

			for(int i = 0; i < keyArray.length;i++){
				Object obj = m.get(keyArray[i]);
				// 값이 없으면... 널 처리
				if(obj == null){obj = "";}

				if(obj instanceof Long){ // 숫자면 여기
					Number c_num = new Number( i + numberingSize, h%60000 + titleSize, ((Long)obj).longValue(), contextFormat);
					sheet.addCell(c_num);
				}else if(obj instanceof Integer){ // 숫자면 여기
					Number c_num = new Number( i + numberingSize, h%60000 + titleSize, ((Integer)obj).intValue(), contextFormat);
					sheet.addCell(c_num);
				}else if(obj instanceof java.lang.Number){ // 숫자면 여기
					Number c_num = new Number( i + numberingSize, h%60000 + titleSize, ((java.lang.Number)obj).doubleValue(), contextFormat);
					sheet.addCell(c_num);
				}else{ // 문자면 여기
					Label lab = new Label( i + numberingSize, h%60000 + titleSize, String.valueOf(obj).replaceAll("\r", ""), contextFormat);
					sheet.addCell(lab);
				}
			}
		}
 	    workbook.write();
        workbook.close();
	}

	/**
	 * List-Map 구조의 데이터를 엑셀로 다운로드하게 한다. 사용법은 아래 코드와 같다.
	 *
	 * <code>
	 *
	 *	String [][] titleArray = {{"번호", "소속", "평가대상그룹", "성명")};
	 *	String [] keyArray = {"NUM", "ORGNM", "TAGTGRP_NM", "EMP_NM"};
	 *	List list2MapData = getSqlMapClientTemplate().queryForList("list2MapData");
	 *	ExcelDownLoad.downLoad(response, list2MapData, titleArray, keyArray, "excel.xls", "시트명");
	 *
	 * </code>
	 *
	 * @param request
	 * @param response 결과를 출력한 Response
	 * @param dataList 엑셀로 변환할 List-Map 형태의 데이터
	 * @param titleArray 각 컬럼의 제목.
	 * @param keyArray Map에서 데이터를 가져오기 위한 Key 값. 꺼내올 값의 순서대로 입력한다.
	 * @param fileName 다운로드되는 파일의 기본이름. 없는 경우 날짜(ex-20070622.xls)가 들어간다.
	 * @param sheetName Sheet의 이름. 없을 경우 Sheet1로 설정된다.
	 * @throws java.io.IOException
	 * @throws jxl.write.WriteException
	 */
	public static void downLoad(HttpServletRequest request, HttpServletResponse response, List dataList, String[][] titleArray, String[] keyArray, String fileName, String sheetName) throws IOException, WriteException {
		ExcelDownLoadUtil.downLoad(request, response, dataList, titleArray, keyArray, fileName, sheetName, false);
	}

	/**
	 * List-Map 구조의 데이터를 엑셀로 다운로드하게 한다. 사용법은 아래 코드와 같다.
	 * 시트명은 Sheet1으로 설정된다.
	 * <code>
	 *
	 *	String [][] titleArray = {{"번호", "소속", "평가대상그룹", "성명")};
	 *	String [] keyArray = {"NUM", "ORGNM", "TAGTGRP_NM", "EMP_NM"};
	 *	List list2MapData = getSqlMapClientTemplate().queryForList("list2MapData");
	 *	ExcelDownLoad.downLoad(response, list2MapData, titleArray, keyArray, "excel.xls");
	 *
	 * </code>
	 *
	 * @param request
	 * @param response 결과를 출력한 Response
	 * @param dataList 엑셀로 변환할 List-Map 형태의 데이터
	 * @param titleArray 각 컬럼의 제목.
	 * @param keyArray Map에서 데이터를 가져오기 위한 Key 값. 꺼내올 값의 순서대로 입력한다.
	 * @param fileName 다운로드되는 파일의 기본이름. 없는 경우 날짜(ex-20070622.xls)가 들어간다.
	 * @throws java.io.IOException
	 * @throws jxl.write.WriteException
	 */
	public static void downLoad(HttpServletRequest request, HttpServletResponse response, List dataList, String[][] titleArray, String[] keyArray, String fileName) throws IOException, WriteException {
		ExcelDownLoadUtil.downLoad(request, response, dataList, titleArray, keyArray, fileName, null, false);
	}

	/**
	 * List-Map 구조의 데이터를 엑셀로 다운로드하게 한다. 사용법은 아래 코드와 같다.
	 * 다운로드되는 기본 파일명은 서버에 설정된 현재 일자로 출력된다.
	 * <code>
	 *
	 *	String [][] titleArray = {{"번호", "소속", "평가대상그룹", "성명")};
	 *	String [] keyArray = {"NUM", "ORGNM", "TAGTGRP_NM", "EMP_NM"};
	 *	List list2MapData = getSqlMapClientTemplate().queryForList("list2MapData");
	 *	ExcelDownLoad.downLoad(response, list2MapData, titleArray, keyArray);
	 *
	 * </code>
	 *
	 * @param request
	 * @param response 결과를 출력한 Response
	 * @param dataList 엑셀로 변환할 List-Map 형태의 데이터
	 * @param titleArray 각 컬럼의 제목.
	 * @param keyArray Map에서 데이터를 가져오기 위한 Key 값. 꺼내올 값의 순서대로 입력한다.
	 * @throws java.io.IOException
	 * @throws jxl.write.WriteException
	 */
	public static void downLoad(HttpServletRequest request, HttpServletResponse response, List dataList, String[][] titleArray, String[] keyArray) throws IOException, WriteException {
		ExcelDownLoadUtil.downLoad(request, response, dataList, titleArray, keyArray, null, null, false);
	}
}
