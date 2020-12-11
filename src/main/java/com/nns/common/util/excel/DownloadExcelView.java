package com.nns.common.util.excel;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Map;

public class DownloadExcelView extends AbstractView {


	public DownloadExcelView() {
		setContentType("application/download; utf-8");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		File file = (File)model.get("downloadFile");
		response.setContentType("application/download; utf-8");
		response.setContentLength((int)file.length());

		String userAgent = request.getHeader("User-Agent");
		String rename = (String) request.getAttribute("fileName");
		String fileName = (rename == null) ? file.getName() : rename;

		if (userAgent.indexOf("MSIE") > -1 || userAgent.indexOf("Trident") > -1) {
			// IE
			response.setHeader("Content-Disposition", "attachment; filename=\""+ java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "\\ ") + "\";");

		} else {
			// Mozilla
			response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1").replaceAll("\\+", "\\ ") + "\";");
		}

		response.setHeader("Content-Transfer-Encoding", "binary");


		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;

		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			if (file.exists() && file.isFile()) {
				file.delete();
			}
		}
		out.flush();
	}

}
