package com.nns.common.filter;

import org.springframework.web.filter.CharacterEncodingFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DefaultFilter extends CharacterEncodingFilter {

	@Override
	protected void doFilterInternal(HttpServletRequest request,
			HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		if(request.getRequestURI().equals(request.getContextPath()+"/admin") || request.getRequestURI().equals(request.getContextPath()+"/admin/")) {
			response.sendRedirect(request.getContextPath()+"/admin/login.htm");

		} else if (request.getRequestURI().equals(request.getContextPath()+"/watcher") || request.getRequestURI().equals(request.getContextPath()+"/watcher/")) {
			response.sendRedirect(request.getContextPath()+"/watcher/login.htm");

		} else if (request.getRequestURI().equals(request.getContextPath()+"/dashboard") || request.getRequestURI().equals(request.getContextPath()+"/dashboard/")) {
			response.sendRedirect(request.getContextPath()+"/dashboard/system.htm");

		} else if (request.getRequestURI().equals(request.getContextPath()+"/board") || request.getRequestURI().equals(request.getContextPath()+"/board/")) {
			response.sendRedirect(request.getContextPath()+"/board/board_network.htm");

		} else {
			super.doFilterInternal(request, response, filterChain);
		}
	}

}
