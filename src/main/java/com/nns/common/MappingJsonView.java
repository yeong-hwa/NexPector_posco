package com.nns.common;

import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import java.util.Map;

public class MappingJsonView extends MappingJacksonJsonView {

	@Override
	protected Object filterModel(Map<String, Object> model) {
		// TODO Auto-generated method stub
		Object result = super.filterModel(model);
		if (!(result instanceof Map)) {
			return result;
		}
		Map map = (Map) result;
		if (map.size() == 1) {
			return map.values().toArray()[0];
		}
		return map;
	}

}
