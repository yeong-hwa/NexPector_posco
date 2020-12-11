package com.nns.util;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExcelPoiUtil {
	public List getList2Map_xls(InputStream fis, String[] keyItem, int startRow) throws Exception
	{	
		List lst = null;
		try{
			HSSFWorkbook wb = new HSSFWorkbook(fis);
			HSSFSheet sheet = wb.getSheetAt(0);
			
			System.out.println("읽은 ROW : " + sheet.getLastRowNum());
			for(int i=startRow;i<=sheet.getLastRowNum();i++)
			{
				HSSFRow excel_row = sheet.getRow(i);
				System.out.println("읽은 Cell : " + excel_row.getLastCellNum());
				if(keyItem.length > excel_row.getLastCellNum())
				{
					continue;
				}
				else
				{
					if(lst == null) lst = new ArrayList();
					Map m = new HashMap();
					for(int j=0;j<keyItem.length;j++)
					{
						m.put(keyItem[j], excel_row.getCell(j).toString().trim());
						System.out.println(excel_row.getCell(j).toString().trim());
					}
					lst.add(m);
				}
			}
			fis.close();
		}catch(Exception e){
			try{
				fis.close();
			}catch(Exception ex){
			}
			throw e;
		}
		
		return lst;
	}
	
	public List getList2Map_xlsx(InputStream fis, String[] keyItem, int startRow) throws Exception
	{	
		List lst = null;
		try{
			XSSFWorkbook wb = new XSSFWorkbook(fis);
			XSSFSheet sheet = wb.getSheetAt(0);
			
			System.out.println("읽은 ROW : " + sheet.getLastRowNum());
			for(int i=startRow;i<=sheet.getLastRowNum();i++)
			{
				XSSFRow excel_row = sheet.getRow(i);
				System.out.println("읽은 Cell : " + excel_row.getLastCellNum());
				if(keyItem.length > excel_row.getLastCellNum())
				{
					continue;
				}
				else
				{
					if(lst == null) lst = new ArrayList();
					Map m = new HashMap();
					for(int j=0;j<keyItem.length;j++)
					{
						m.put(keyItem[j], excel_row.getCell(j).toString().trim());
						System.out.println(excel_row.getCell(j).toString().trim());
					}
					lst.add(m);
				}
			}
			fis.close();
		}catch(Exception e){
			try{
				fis.close();
			}catch(Exception ex){
			}
			throw e;
		}
		
		return lst;
	}
}
