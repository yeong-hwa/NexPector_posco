/*                                                                                 
 * Copyright (c) 2011 ZOOIN.NET CO.,LTD. All rights reserved.                         
 *                                                                                 
 * This software is the confidential and proprietary information of ZOOIN.NET CO.,LTD.
 * You shall not disclose such Confidential Information and shall use it           
 * only in accordance with the terms of the license agreement you entered into      
 * with ZOOIN.NET CO.,LTD.                                                            
 */
package com.nns.util;


import jxl.*;
import jxl.read.biff.BiffException;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Excel 파싱.  <BR>
 *           
 * @author       shocky                
 * @version      1.0                   
 * @since        JDK1.4  
 * @HISTORY      AUTHOR    	DATE           	DESC
 *               shocky    	2007. 04. 04   	CREATE   
 *               shocky    	2007. 07. 03   	setSheet() 칼럼수 강제고정/count 할수 있도록 수정.  
 *               fishingday	2007. 11. 09   	1. 생성자 추가 및 InputStream으로 엑셀 읽기 기능 추가.
 *                                          2. getList2Map 메소드 생성 - List&Map 형태로 데이터 읽기 기능 추가.
 *                                          3. close() 메소드 추가.   
 */
public class ExcelReadUtil{
	private String str_ExcelPath;			// 엑셀파일 경로
	private String str_ExcelName;			// 실제 엑셀파일명
	private String str_ExcelFull;			// 엑셀 FullPath

	private Workbook workbook;				// Workbook 객체
	private Sheet sheet;					// 현재 Sheet
	private int totalRows;					// 총 행수
	private int totalCols;					// 총 열수
	private int totalRecord;				// 총 레코드 행수
	private int int_SheetNo;				// 기본 Sheet 번호 (0~)
	private int int_ColsCNT;				// 필수 열 수
	private int i_max_code	= 1;

	/**
	 * 기본생성자
	 *
	 */
	public ExcelReadUtil(){}
	
	/**
	 * 스트림을 사용하는 생성자
	 * 
	 * @param inputStream
	 * @throws jxl.read.biff.BiffException
	 * @throws java.io.IOException
	 */
	public ExcelReadUtil(InputStream inputStream) throws BiffException, IOException{
		setWorkbook(inputStream);
	}

	/**
	 * 엑셀파일 스트림, 시트번호 및 컬럼 수로 엑셀 초기화
	 *
	 * @param inputStream
	 * @param int_SheetNo
	 * @param int_ColsCNT
	 * @throws jxl.read.biff.BiffException
	 * @throws java.io.IOException
	 */
	public ExcelReadUtil(InputStream inputStream, int int_SheetNo, int int_ColsCNT) throws BiffException, IOException{
		setWorkbook(inputStream, int_SheetNo, int_ColsCNT);
	}

	/**
	 * 엑셀파일 경로와 파일명으로 엑셀 초기화
	 *
	 * @param str_FilePath
	 * @param str_FileName
	 */
	public ExcelReadUtil(String str_FilePath, String str_FileName){
		setWorkbook(str_FilePath, str_FileName);
	}

	/**
	 * 엑셀파일 경로와 파일명, 시트번호 및 컬럼 수로 엑셀 초기화
	 *
	 * @param str_FilePath
	 * @param str_FileName
	 * @param int_SheetNo
	 * @param int_ColsCNT
	 */
	public ExcelReadUtil(String str_FilePath, String str_FileName, int int_SheetNo, int int_ColsCNT){
		setWorkbook(str_FilePath, str_FileName, int_SheetNo, int_ColsCNT);
	}

	/**
	 * 엑셀파일 경로와 파일명으로 엑셀 초기화
	 *
	 * @param str_FilePath
	 * @param str_FileName
	 */
	public void setWorkbook(String str_FilePath, String str_FileName){
		try{
			this.str_ExcelPath		= str_FilePath;
			this.str_ExcelName		= str_FileName;

			if((this.str_ExcelPath!=null && !this.str_ExcelPath.equals("")) && (this.str_ExcelName!=null && !this.str_ExcelName.equals(""))){
				this.str_ExcelFull	= this.str_ExcelPath + this.str_ExcelName;

				if(excelExist() == 1){
					this.workbook	= Workbook.getWorkbook(new File(this.str_ExcelFull));
				}else{
					this.workbook	= null;
				}
			}else{
				this.workbook		= null;
			}
		}catch(Exception ex){
			System.out.println("Open Fail [1] !!"+ex.getMessage());
		}
	}

	/**
	 *  엑셀파일 경로와 파일명, 시트번호 및 컬럼 수로 엑셀 초기화
	 *
	 * @param str_FilePath
	 * @param str_FileName
	 * @param int_SheetNo
	 * @param int_ColsCNT
	 */
	public void setWorkbook(String str_FilePath, String str_FileName, int int_SheetNo, int int_ColsCNT) {
		try{
			this.int_SheetNo = int_SheetNo;
			this.int_ColsCNT = int_ColsCNT;
			setWorkbook(str_FilePath, str_FileName);		// Workbook 설정 (파일경로,파일명)
			setSheet(this.int_SheetNo, this.int_ColsCNT);				// Sheet 설정 (Sheet 번호, 열 갯수)
		}catch(Exception ex){
			System.out.println("Open Fail [2] !!"+ex.getMessage());
		}
	}

	/**
	 * 엑셀파일 스트림으로 초기화
	 *
	 * @param is
	 * @throws jxl.read.biff.BiffException
	 * @throws java.io.IOException
	 */
	public void setWorkbook(InputStream is) throws BiffException, IOException{
		this.workbook	= Workbook.getWorkbook(is);
	}

	/**
	 * 엑셀파일 스트림과 시트번호 및 컬럼 수로 엑셀 초기화
	 *
	 * @param is
	 * @param int_SheetNo
	 * @param int_ColsCNT
	 * @throws jxl.read.biff.BiffException
	 * @throws java.io.IOException
	 */
	public void setWorkbook(InputStream is, int int_SheetNo, int int_ColsCNT) throws BiffException, IOException{
		this.int_SheetNo = int_SheetNo;
		this.int_ColsCNT = int_ColsCNT;
		setWorkbook(is);
		setSheet(int_SheetNo, int_ColsCNT);
	}

	/**
	 * Sheet 설정 (Sheet 번호, 열 갯수)
	 *
	 * @param int_ColsCNT
	 */
	public void setSheet(int int_ColsCNT){
		setSheet(0, int_ColsCNT);
	}

	/**
	 * Sheet 설정 (Sheet 번호, 열 갯수)
	 *
	 * @param int_SheetNo
	 * @param int_ColsCNT
	 */
	public void setSheet(int int_SheetNo, int int_ColsCNT){
		try{
			if(int_SheetNo < 0){							// Sheet 번호가 0보다 작으면 Sheet 열기 실패
				this.int_SheetNo	= 0;
				this.sheet		= null;

				totalRows			= -1;
				totalCols			= -1;
				this.int_ColsCNT	= 0;
			}else{											// Sheet 번호가 정상이면 Sheet 설정
				this.int_SheetNo	= int_SheetNo;
				if(workbook != null){
					this.sheet		= workbook.getSheet(int_SheetNo);

					totalRows		= this.sheet.getRows();			// 현 sheet의 총 행수

					if(int_ColsCNT == 0){
						totalCols		= this.sheet.getColumns();		// 현 sheet의 총 열수
						this.int_ColsCNT= totalCols;
					}else{
						totalCols		= int_ColsCNT;					// 정의된 열 수로 강제고정.
						this.int_ColsCNT= int_ColsCNT;
					}
				}else{
					this.sheet		= null;

					totalRows		= -1;
					totalCols		= -1;
					this.int_ColsCNT= 0;
				}
			}
		}catch(Exception ex){
			System.out.println("Set Sheet Fail !!"+ex.getMessage());
		}
	}

	public Workbook getWorkbook(){
		return workbook;
	}

	public Sheet getSheet(){
		return sheet;
	}

	public int getRows(){
		return totalRows;
	}

	public int getCols(){
		return totalCols;
	}

	public void close(){
		if(workbook != null){
			workbook.close();
		}
	}

	/**
	 * 엑셀파일이 실제로 존재하는지 체크
	 * @return
	 */
	public int excelExist(){
		int exist_flag	= 0;
		File td			=  new File(str_ExcelPath);

		if (td.exists()) {
			File files[] = td.listFiles();
			exist_flag = 0;

			for (int i=0; i<files.length; i++) {
				String _file = files[i].getName();

				if (_file.equals(str_ExcelName)) {		//존재여부 체크  (삭제용도 아님)
					exist_flag	= 1;
				}
			}
		}else{
			exist_flag = 0;
		}

		return exist_flag;
	}

	/**
	 * 각 행의 실제 Depth를 구해주는 메쏘드
	 * @param str_IndexNo
	 * @return
	 */
	public int getDepth(String str_IndexNo){
		int depth_no			= 0;
		int index_length			= 0;

		// depth 구하기
		if(str_IndexNo != null){
			index_length		= str_IndexNo.trim().length();		// 위계값 총 길이

			if(str_IndexNo.charAt(index_length-1) == '.'){			// 맨마지막에 불필요한 구분자(.) 제거하기
				str_IndexNo		= str_IndexNo.substring(0, index_length-2);
				index_length	= str_IndexNo.trim().length();		// 위계값 총 길이 다시 구하기
			}

			for(int idx=0; idx<index_length; idx++){				// 실제 총 길이에서 구분자(.) 갯수 구하기 (실제 depth)
				if(str_IndexNo.charAt(idx) == '.') depth_no++;
			}
		}

		return depth_no;
	}

	/**
	 * Insert시 사용 가능한 객체코드 (max(object_id)+1) 를 구해주는 메쏘드
	 * @return
	 */
	public int getMaxCode(){
		try{
			i_max_code	= i_max_code + 1;
		}catch(Exception ex){
			System.out.println("[Error] ExcelReadUtil.java : getMaxCode() = "+ ex.getMessage());
		}

		return i_max_code;
	}


	/**
	 * 현재 엑셀파일의 해당 Sheet내용을 2차원 배열로 반환 (배열로 받아 출력하거나, 파싱 사전작업으로 getArray에서 사용)
	 * @return
	 */
	public String[][] getExcel(){
		int totRecord	= 0;
		String arr_List[][]	= new String[totalRows][totalCols];
		int idx_x, idx_y, idx_m;

		try{
			if(totalRows > 0 && totalCols == int_ColsCNT){	// 기본 행&열 수 체크------------------------------ 1열에 타이틀 미포함일경우 (0), 포함할경우 1부터 시작
				// 배열로 옮기기
				idx_m	= 0;
				for(idx_x = 0; idx_x < totalRows; idx_x++){	// 1행(idx=0)은 필드명
					Cell arrInfo[]				= sheet.getRow(idx_x);
					// Modify by fishingday 2008.01.10
					if(arrInfo != null && arrInfo.length > 0 && arrInfo[0].getContents() != null && !"".equals(arrInfo[0].getContents())){
						for(idx_y = 0; idx_y < totalCols; idx_y++){
							if(arrInfo.length > idx_y){
								if(arrInfo[idx_y].getContents() == null)
									arr_List[idx_x][idx_y]	= "";
								else
									arr_List[idx_x][idx_y]	= arrInfo[idx_y].getContents();
							}else{
								arr_List[idx_x][idx_y]	= "";
							}

						}

						totRecord++;
					}
					idx_m++;
				}
			}
		}catch(Exception ex){
			for(idx_x = 0; idx_x < arr_List.length; idx_x++){
				for(idx_y = 0; idx_y < arr_List[0].length; idx_y++){
					arr_List[idx_x][idx_y]	= "";
				}
			}
			totRecord	= 0;

			System.out.println("Get Array Fail !!"+ex.getMessage());
			ex.printStackTrace();
		}
		totalRecord	 = totRecord;

		return arr_List;
	}

	/**
	 * 엑셀내용을 배열로 구하여 DB에 삽입 가능한 형태로 파싱하는 작업 수행
	 * @return
	 */
	public String[][] getArray(){
		String arr_List[][];
		//int totRecord		= 0;
		arr_List			= getExcel();

		try{
			// depth에 따라 고유코드, 상위코드, 정렬순서 구하기
			String temp_content	= new String();
			int temp_depth		= 0;
			int max_code		= 0;
			int up_code			= 0;
			int order_num		= 0;
			int check_depth		= 0;
			int check_count		= 1;
			int idx_m; //idx_x, idx_y,

			max_code			= getMaxCode();	// 삽입 가능한 고유 코드 구하기

			while(check_count > 0){		// 이전 depth의 row 갯수가 1이상일 경우 다음 depth 찾기
				check_count	= 0;		// 찾은 row 수 초기화

				for(idx_m = 0; idx_m < totalRecord; idx_m++){			// 총 row 수 만큼 반복
					temp_content			= arr_List[idx_m][0];	// 현재 row의 위계값



					// depth 구하기
					temp_depth				= 0;
					temp_depth				= getDepth(temp_content);

					if(temp_depth == check_depth - 1){						// 현재 체크 대상(depth)의 상위 depth인 row일 경우 고유코드를 상위코드로 사용하기 위해 저장
						if(Integer.parseInt(arr_List[idx_m][totalCols]) != up_code){		// 해당 상위 depth의 하위 depth가 처음일 경우 order_num = 0
							up_code	= Integer.parseInt(arr_List[idx_m][totalCols]);
						}
					}else if(temp_depth == check_depth){						// 현재 체크 대상(depth)의 row인 경우
						arr_List[idx_m][totalCols]		= (max_code++) +"";		// 고유코드
						arr_List[idx_m][totalCols+1]	= up_code+"";			// 상위코드
						arr_List[idx_m][totalCols+2]	= (order_num++) +"";	// 정렬순서 (삽입순서)
						arr_List[idx_m][totalCols+3]	= temp_depth+"";		// depth

						check_count++;											// 현재 depth에 해당하는 레코드 갯수
					}
				}

				check_depth++;

				if(check_depth > 1000) break;	// 무한루프 피하기 위해.. (임시)
			}

			arr_List	= this.sorting(arr_List);	// 정렬 다시하기
		}catch(Exception ex){
			System.out.println("Get Array Fail !!"+ex.getMessage());
		}

		return arr_List;
	}

	/**
	 * 엑셀파일을 읽어 List&Map 형태로 반한다.
	 * List&Map 형태로 만들기 위해서는 Map에 Key로 사용할
	 * 문자 배열(ColsKeyList)을 만들어서 넣어줘야 한다.
	 *
	 * 엑셀 데이터는 String 형태로만 담긴다.
	 *
	 * @param ColsKeyList ColsKeyList Map 사용할 Key
	 * @return List&Map
	 * @throws java.io.UnsupportedEncodingException
	 */
	public List getList2Map(String [] ColsKeyList){
		return getList2Map(ColsKeyList, true);
	}

	/**
	 * 엑셀파일을 읽어 List&Map 형태로 반한다.
	 * List&Map 형태로 만들기 위해서는 Map에 Key로 사용할
	 * 문자 배열(ColsKeyList)을 만들어서 넣어줘야 한다.
	 *
	 * isPutType을 true 설정하면, CellType에 정의된
	 * DATE(java.util.Date), Lable(java.lang.String), number(java.math.BigDecimal)로 데이터를 받는다.
	 *
	 * @param ColsKeyList Map 사용할 Key
	 * @param isPutType true 이면 Object의 Type형태로 받는다.
	 * @return List&Map
	 * @throws java.io.UnsupportedEncodingException
	 */
	public List getList2Map(String [] ColsKeyList, boolean isPutType){
		List listExcel2Map = null;

		// 일단 있을 것은 있고...
		if(totalRows > 0 && totalCols == int_ColsCNT){
			// Map 2 List 옮기기
			listExcel2Map = new ArrayList();
			for(int j = 0; j < totalRows; j++){	// 1행(idx=0)은 필드명
				Cell cells[]				= sheet.getRow(j);
				// 정말 Cell이 있는 거야?
				if(cells != null && cells.length > 0){
					// 여기는 담아서 넘길 맵을 만들어 주고...
					Map rowsMap = new HashMap();
					for(int k = 0; k < cells.length; k++){ // 정해진 만큼만 돌린다.
						// 키-리스트  길이보다는 적어야 하고..
						if(ColsKeyList.length > k){
							if(isPutType){ // 객체의 타입별로 받을 수 있고... 
								if(cells[k] == null || cells[k].getType() == CellType.EMPTY){
									// 패스~
								}if(cells[k].getType() == CellType.LABEL){ // 문자 type
									rowsMap.put(ColsKeyList[k],((LabelCell)cells[k]).getString());
								}else if(cells[k].getType() == CellType.NUMBER){ // 숫자 type
									rowsMap.put(ColsKeyList[k], new BigDecimal(((NumberCell)cells[k]).getValue()));
								}else if(cells[k].getType() == CellType.DATE){ // 날짜 type
									rowsMap.put(ColsKeyList[k], ((DateCell)cells[k]).getDate());
								}else{
									String value = cells[k].getContents();
									if(value != null){
										value = value.trim();
									}
									rowsMap.put(ColsKeyList[k], value);
								}
							}else{ // 무쉭해도... 스트링만 고집할 수 도 있고...
								String value = cells[k].getContents();
								if(value != null){
									value = value.trim();
								}
								rowsMap.put(ColsKeyList[k], value);
							}
						}// if < ColsKeyList
					}// for cells
					listExcel2Map.add(rowsMap);
				}// is cells
			} // for totalRows
		}

		return listExcel2Map;
	}


	/********************************** JSP에서 사용될 출력용 문자열을 구해주는 메소드들 **********************************/
	/**
	 * 현재 엑셀파일의 내용을 배열로 구하여 문자열로 반환 (<tr><td></td></tr>) : 저장전 업로드된 파일 확인용
	 */
	public String printExcel(){	
		String arr_List[][];
		arr_List			= getExcel();
		String str_RecordList	= new String();
		int idx_x, idx_y;//, idx_m;

		try{
			// 배열 결과 출력
			String temp_align	= new String();
			int temp_padding	= 10;
			int temp_depth	= 0;

			for(idx_x = 0; idx_x < totalRecord; idx_x++){
				str_RecordList		+=	"<tr height='25' class='content'>\n";
				temp_depth			= getDepth(arr_List[idx_x][0]);

				for(idx_y = 0; idx_y < totalCols; idx_y++){
					temp_align		= "left";
					temp_padding	= 10;

					if(idx_y == 0){
						temp_padding	+= temp_depth * 10;
					}else{
						if(idx_y >= 2){
							temp_padding	= 0;
							temp_align		= "center";
						}
					}
					str_RecordList	+=	"	<td align='"+temp_align+"' style='padding-left:"+temp_padding+"'>"+ arr_List[idx_x][idx_y] +"</td>\n";
				}
				str_RecordList		+=	"</tr>\n";
			}
		}catch(Exception ex){
			System.out.println("Print Excel Fail !!"+ex.getMessage());

			if(totalRecord == 0){
				if(str_ExcelPath == null || str_ExcelPath.equals("")){
					str_RecordList		= "<tr height='25' class='content'><td colspan='4' align='center'></td></tr>\n";
				}else{
					str_RecordList		= "<tr height='25' class='content'><td colspan='4' align='center'>파일을 찾지 못했습니다.</td></tr>\n";
				}
				for(idx_x = 1; idx_x < 10; idx_x++){
					str_RecordList		+= "<tr height='25' class='content'><td colspan='4' align='center'></td></tr>\n";
				}
			}else{
				str_RecordList			= "<tr height='25' class='content'><td colspan='4' align='center'>파일을 열지 못했습니다.!!</td></tr>\n";
			}
		}

		return str_RecordList;
	}

	public String[][] sorting(String[][] arr_List){
		int order_num = 0;

		for(int idx = 0; idx < totalRecord; idx++){
		//	if(arr_List[idx][totalCols+3].equals("0")){
		//		order_num = 0;
		//	}
			arr_List[idx][totalCols+2]	= ++order_num+"";
		}

		return arr_List;
	}

	/**
	 * 엑셀내용을 배열로 구하여 DB에 삽입 가능한 형태로 파싱한 결과를 출력하기 위해 문자열로 반환
	 * @return
	 */
	public String printArray(){	
		String arr_List[][];
		arr_List				= getArray();
		String str_RecordList	= new String();
		int idx_x, idx_y; //, idx_m;

		try{
			// 배열 결과 출력
			String temp_align	= new String();
			int temp_padding	= 10;
			int temp_cols	= 0;

			for(idx_x = 0; idx_x < totalRecord; idx_x++){
				temp_cols				= arr_List[0].length;
				str_RecordList			+=	"<tr height='25' class='content'>\n";

				for(idx_y = 0; idx_y < temp_cols-1; idx_y++){
					temp_align			= "left";
					temp_padding		= 10;
					if(idx_y == 0){
						if(arr_List[idx_x][(temp_cols-1)] != null && !arr_List[idx_x][(temp_cols-1)].equals(""))
							temp_padding	+= Integer.parseInt(arr_List[idx_x][(temp_cols-1)]) * 10;
					}else{
						if(idx_y >= 2){
							temp_padding	= 0;
							temp_align		= "center";
						}
					}
					str_RecordList			+=	"	<td align='"+temp_align+"' style='padding-left:"+temp_padding+"'>"+ arr_List[idx_x][idx_y] +"</td>\n";
				}
				str_RecordList				+=	"</tr>\n";
			}
		}catch(Exception ex){
			System.out.println("Print Array Fail !!"+ex.getMessage());

			if(totalRecord == 0){
				if(str_ExcelPath == null || str_ExcelPath.equals("")){
					str_RecordList		= "<tr height='25' class='content'><td colspan='7' align='center'></td></tr>\n";
				}else{
					str_RecordList		= "<tr height='25' class='content'><td colspan='7' align='center'>파일을 찾지 못했습니다.</td></tr>\n";
				}
				for(idx_x = 1; idx_x < 10; idx_x++){
					str_RecordList		+= "<tr height='25' class='content'><td colspan='7' align='center'></td></tr>\n";
				}
			}else{
				str_RecordList			= "<tr height='25' class='content'><td colspan='7' align='center'>파일정보 파싱 실패!!</td></tr>\n";
			}
		}

		return str_RecordList;
	}
}
