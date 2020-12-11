package com.nns.util;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class PoiExcelDown{
	private static final String CHARSET = "euc-kr";
	
	public static void downLoad(HttpServletRequest request, HttpServletResponse response, List dataList, String[][] titleArray, String[] keyArray, String fileName, String sheetName, boolean isNumbering) throws IOException{
	
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

    //엑셀 테이터를 만들어 볼까
    Workbook workbook = null;
    int indexDot = fileName.lastIndexOf(".");
    if(indexDot == -1)indexDot=0;
    String fileExtention = fileName.substring(indexDot).toLowerCase();
    if(".xlsx".equals(fileExtention)){
    	workbook = new XSSFWorkbook();
    }else{
    	workbook = new HSSFWorkbook();
    }
    
    CellStyle titleStyle = workbook.createCellStyle();
    CellStyle contextStyle = workbook.createCellStyle();
    
    titleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
    titleStyle.setFillBackgroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
    titleStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
    titleStyle.setBorderBottom(CellStyle.BORDER_THIN);
    titleStyle.setBorderLeft(CellStyle.BORDER_THIN);
    titleStyle.setBorderRight(CellStyle.BORDER_THIN);
    titleStyle.setBorderTop(CellStyle.BORDER_THIN);
    titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
    
    contextStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
    contextStyle.setFillBackgroundColor(IndexedColors.WHITE.getIndex());
    contextStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
    contextStyle.setBorderBottom(CellStyle.BORDER_THIN);
    contextStyle.setBorderLeft(CellStyle.BORDER_THIN);
    contextStyle.setBorderRight(CellStyle.BORDER_THIN);
    contextStyle.setBorderTop(CellStyle.BORDER_THIN);
    contextStyle.setAlignment(CellStyle.ALIGN_LEFT);
    
    workbook.createSheet(sheetName);
    Sheet sheet = workbook.getSheetAt(0);
    
    // 타이틀...	
    for( int t = 0; t < titleArray.length ; t++){
    	Row row = sheet.createRow(t);
    	for(int t_bu = 0; t_bu < titleArray[t].length; t_bu++){
    		Cell tilteCell = row.createCell(t_bu);
    		tilteCell.setCellStyle(titleStyle);
    		tilteCell.setCellValue(titleArray[t][t_bu]);
    	}
    }
    
    // 내용
    int titleSize =  titleArray.length;
	for(int h=0;h < dataList.size(); h++){
		Map m = (Map)dataList.get(h);
		//row 류프
		Row row = sheet.createRow(h+1);
		
		for(int i = 0; i < keyArray.length;i++){
			Object obj = m.get(keyArray[i]);
			//cell 루프
			Cell contextCell = row.createCell(i);
			
			// 값이 없으면... 널 처리
			if(obj == null){obj = "";}
			
			if(obj instanceof Long){ // 숫자면 여기
				
				contextCell.setCellStyle(contextStyle);
				contextCell.setCellValue(((Long)obj).longValue());
				
			}else if(obj instanceof Integer){ // 숫자면 여기
				
				contextCell.setCellStyle(contextStyle);
				contextCell.setCellValue(((Integer)obj).intValue());
			}else if(obj instanceof Number){ // 숫자면 여기

				contextCell.setCellStyle(contextStyle);
				contextCell.setCellValue(((Number)obj).doubleValue());
			}else{ // 문자면 여기
			
				contextCell.setCellStyle(contextStyle);
				contextCell.setCellValue(String.valueOf(obj).replaceAll("\r", ""));
			}
		}
	}
    
    OutputStream out = response.getOutputStream();
    workbook.write(out);
    out.close();
    
	}	
}