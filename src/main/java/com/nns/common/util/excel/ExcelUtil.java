package com.nns.common.util.excel;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.format.Colour;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

public class ExcelUtil {

	public final static SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss-SSS");

	public static File getTempFile(String path, String fileName) {
		String date = ExcelUtil.DATE_TIME_FORMAT.format(new Date(System.currentTimeMillis()));
		File file = new File(path + File.pathSeparator + fileName + date + ".xls");
		return file;
	}

	public static String makeTempDir(String servletPath) {
		/*
		int end = servletPath.lastIndexOf(File.separatorChar);
		String rootPath = servletPath.substring(0, end);
		String dirPath = rootPath + File.separator + "Temp";
		 */
		String dirPath = servletPath + File.separator + "Temp";

		File dirFile = new File(dirPath);

		if (!dirFile.exists() || !dirFile.isDirectory()) {
			if (!dirFile.mkdirs()) {
				return null;
			}
		}

		return dirPath;
	}

	public static jxl.write.Label createTitle(int col, int row, String data) {
		WritableCellFormat titleFormat = null;
		try {
			titleFormat = new WritableCellFormat();
			titleFormat.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);
			titleFormat.setAlignment(jxl.format.Alignment.CENTRE);
			titleFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			titleFormat.setBackground(Colour.ICE_BLUE);
		} catch(Exception e) {
			titleFormat = new WritableCellFormat();
		}

		jxl.write.Label label = null;
		if (data == null) {
			label = new jxl.write.Label(col, row, "", titleFormat);
		} else {
			label = new jxl.write.Label(col, row, data, titleFormat);
		}
		return label;
	}

	public static jxl.write.Label createCenterLabel(int col, int row, String data) {
		WritableCellFormat centerFormat = null;
		try {
			centerFormat = new WritableCellFormat();
			centerFormat.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);
			centerFormat.setAlignment(jxl.format.Alignment.CENTRE);
			centerFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		} catch(Exception e) {
			centerFormat = new WritableCellFormat();
		}

		jxl.write.Label label = null;
		if (data == null) {
			label = new jxl.write.Label(col, row, "", centerFormat);
		} else {
			label = new jxl.write.Label(col, row, data, centerFormat);
		}
		return label;
	}


	@SuppressWarnings("rawtypes")
	public static String getData(Map map, String key) {
		if (map != null) {
			Object obj = map.get(key);
			if (obj != null) {
				return obj.toString();
			}
		}
		return null;
	}

	@SuppressWarnings("rawtypes")
	public static File createExcelFile(String dirPath, String fileName, String[] titleArray, int[] widthArray, String[] columnArray, List dataList) {

		WritableWorkbook workbook = null;
		WritableSheet sheet = null;
		File resultFile = null;

		try {
			String fileTempStr = dirPath + File.separator + fileName + DATE_TIME_FORMAT.format(new Date(System.currentTimeMillis())) + ".xls";
			resultFile = new File(fileTempStr);

			if (dataList == null || dataList.size() == 0) {

				workbook = Workbook.createWorkbook(resultFile);
				sheet = workbook.createSheet("IP Phone", 0);
				for (int i = 0; i < titleArray.length; i++) {
					sheet.addCell(createTitle(i ,0, titleArray[i]));
					sheet.setColumnView(i, widthArray[i]);
				}

			} else {
				int dataSize = dataList.size();
				if (dataSize > 60000) {
					dataSize = 60000;
				}

				workbook = Workbook.createWorkbook(resultFile);
				sheet = workbook.createSheet("IP Phone", 0);
				for (int i = 0; i < titleArray.length; i++) {
					sheet.addCell(createTitle(i ,0, titleArray[i]));
					sheet.setColumnView(i, widthArray[i]);
				}

				Map map = null;
				for (int i = 0; i < dataSize; i++) {
					map = (Map)dataList.get(i);
					for (int j = 0; j < columnArray.length; j++) {
						sheet.addCell(createCenterLabel(j ,(i+1), getData(map, columnArray[j])));
					}
				}

			}

			workbook.write();
			workbook.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return resultFile;
	}

	public static int checkExcelData(String filePath, String[] titleArray) {

		Workbook w;
		try {
			File file = new File(filePath);
			if (file.exists() && file.isFile()) {

				w = Workbook.getWorkbook(file);
				Sheet sheet = w.getSheet(0);

				if (sheet.getColumns() != titleArray.length) {
					return -10;
				}

				String title = null;
				if (sheet.getRows() > 0) {
					for (int i = 0; i < titleArray.length; i++) {
						Cell cell = sheet.getCell(i, 0);
						title = cell.getContents();
						if (!titleArray[i].equals(title)) {
							return -10;
						}
					}
				}

			}

		} catch (Exception e) {
			return -1;
		}

		return 0;
	}


	public static List<Map<String, String>> getExcelData(String filePath, String[] columnArray) {

		List<Map<String, String>> result = new ArrayList<Map<String, String>>();

		Workbook w;
		try {
			File file = new File(filePath);
			if (file.exists() && file.isFile()) {

				w = Workbook.getWorkbook(file);
				Sheet sheet = w.getSheet(0);

				if (sheet.getRows() > 1) {
					for (int r = 1; r < sheet.getRows(); r++) {
						Map<String, String> map = new HashMap<String, String>();
						for (int col = 0; col < columnArray.length; col++) {
							map.put(columnArray[col], getString(sheet.getCell(col, r)));
						}
						result.add(map);
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public static String getString(Cell cell) {
		if (cell != null) {
			// cell.getType();
			return ((cell.getContents() == null) ? null : cell.getContents().trim());
		}
		return null;
	}

}
