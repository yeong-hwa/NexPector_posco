<?xml version="1.0" encoding="UTF-8" ?>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@page import="java.io.OutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>=
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Map.Entry"%>
<%
	
	List lstInvtItem = (List)request.getAttribute("data");
	HashMap subList = new HashMap();
	Map map = new HashMap();
	
	int nRowCount = (lstInvtItem == null) ? 0 : lstInvtItem.size();
	
	int iCnt = 0;
	int iCode = 0;
	
	String sFileName = "IP PHINE 관리.xls";
	sFileName = new String ( sFileName.getBytes("KSC5601"), "8859_1");
	
	out.clear();
	out = pageContext.pushBody();
	response.reset();   // 이 문장이 없으면 excel 등의 파일에서 한글이 깨지는 문제 발생.
	
	String strClient = request.getHeader("User-Agent");
	
	String fileName = sFileName;
	
	if (strClient.indexOf("MSIE 5.5") > -1) {
	    response.setHeader("Content-Disposition", "filename=" + fileName + ";");
	} else {
	    response.setContentType("application/vnd.ms-excel");
	    response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
	}
	
	OutputStream fileOut = null;
	
	
	// 워크북 생성
	HSSFWorkbook objWorkBook = new HSSFWorkbook();
	
	// 제목 시작
	// 워크북 스타일
	HSSFCellStyle hs = objWorkBook.createCellStyle();
	HSSFFont hf = objWorkBook.createFont();
	
	// 워크북 위치 스타일
	hs.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	
	// 워크북 컬러 스타일
	hs.setFillForegroundColor(HSSFColor.GREY_50_PERCENT.index);
	hs.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	
	// 워크북 테스트 설정
	hs.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
	hs.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
	hs.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
	hs.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
	
	// 워크북 font 스타일
	hf.setColor(HSSFColor.BLACK.index);
	hf.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	hf.setFontName("맑은고딕체");
	hf.setFontHeight((short)200);
	
	// 스타일 폰트 적용
	hs.setFont(hf);
	// 제목 종료
	
	// 내용 시작
	// 워크북 스타일
	HSSFCellStyle hsContent = objWorkBook.createCellStyle();
	HSSFFont hfContent = objWorkBook.createFont();
	
	// 워크북 위치 스타일
	hsContent.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	
	// 워크북 테스트 설정
	hsContent.setBorderRight(HSSFCellStyle.BORDER_THIN);
	hsContent.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	hsContent.setBorderTop(HSSFCellStyle.BORDER_THIN);
	hsContent.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	
	// 내용 종료
	
	
	// 워크시트 생성
	HSSFSheet objSheet = objWorkBook.createSheet();
	
	// 워크시트 셀 크기 조정
	objSheet.setColumnWidth((short)0, (short)3000);
	objSheet.setColumnWidth((short)1, (short)3000);
	objSheet.setColumnWidth((short)2, (short)5000);
	objSheet.setColumnWidth((short)3, (short)3000);
	objSheet.setColumnWidth((short)4, (short)12000);
	objSheet.setColumnWidth((short)5, (short)5000);
	objSheet.setColumnWidth((short)6, (short)3000);
	objSheet.setColumnWidth((short)7, (short)3000);
	objSheet.setColumnWidth((short)8, (short)3000);
	objSheet.setColumnWidth((short)9, (short)3000);
	objSheet.setColumnWidth((short)10, (short)3000);
	
	// 행생성
	HSSFRow objRow = objSheet.createRow((short)0);
	// 셀 생성
	HSSFCell objCell = null;
	
	// 제목
	objCell = objRow.createCell((short)0);
	objCell.setCellValue("교환기ID");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("교환기명");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)2);
	objCell.setCellValue("전화기IP");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)3);
	objCell.setCellValue("내선번호");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)4);
	objCell.setCellValue("사용자 정보");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)5);
	objCell.setCellValue("SNMP Community");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)6);
	objCell.setCellValue("SNMP 버전");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)7);
	objCell.setCellValue("포트");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)8);
	objCell.setCellValue("전화기 타입");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)9);
	objCell.setCellValue("그룹코드");
	objCell.setCellStyle(hs);
	
	objCell = objRow.createCell((short)10);
	objCell.setCellValue("그룹명");
	objCell.setCellStyle(hs);
	
	int iRowNum = 1;
	
	///// Recordset 존재하지 않을 때
	if (nRowCount == 0) { 
		objRow = objSheet.createRow((short)iRowNum);
		
		objCell = objRow.createCell((short)0);
		objCell.setCellValue("해당 사료가 없습니다.");
	
	}
	///// Recordset 존재할 때
	else{
		iCnt = 0;
		iCode = 0;
		for ( iCnt = 0; iCnt < lstInvtItem.size(); iCnt++) {
			
			subList = (HashMap)lstInvtItem.get(iCnt);
			
			Iterator iterator = subList.entrySet().iterator();
			objRow = objSheet.createRow((short)iRowNum);
			
			while (iterator.hasNext()){
				Entry entry = (Entry)iterator.next();
				String key = (String)entry.getKey();
				Object value = entry.getValue();
				map.put(key, value);
			}
			// 내용
			for(iCode = 0;iCode < map.size(); iCode++){
				
				String val = map.get("N_MON_ID").toString();
				
				objCell = objRow.createCell((short)0);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
			    val = map.get("N_MON_NAME").toString();
			    
			    objCell = objRow.createCell((short)1);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("S_IPADDRESS").toString();
			    
			    objCell = objRow.createCell((short)2);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("S_EXT_NUM").toString();
			    
			    objCell = objRow.createCell((short)3);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("S_NAME").toString();
			    
			    objCell = objRow.createCell((short)4);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("S_COMMUNITY").toString();
			    
			    objCell = objRow.createCell((short)5);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("N_SNMP_VER").toString();
			    
			    objCell = objRow.createCell((short)6);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("N_PORT").toString();
			    
			    objCell = objRow.createCell((short)7);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("S_TYPE").toString();
			    
			    objCell = objRow.createCell((short)8);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("N_GROUP_NAME").toString();
			    
			    objCell = objRow.createCell((short)9);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
				val = map.get("N_GROUP").toString();
			    
			    objCell = objRow.createCell((short)10);
			    objCell.setCellValue(val);
			    objCell.setCellStyle(hsContent);
			    
			}
		    iRowNum++;
		}
	}


	fileOut = response.getOutputStream(); 
	objWorkBook.write(fileOut);
	fileOut.close();
%>