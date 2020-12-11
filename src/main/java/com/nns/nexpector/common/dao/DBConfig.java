package com.nns.nexpector.common.dao;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// DB 정보 노출시키고 싶지않을 때 사용(xml 파일에 datasource bean이 있을경우 실행안됨 xml이 우선함) 
@Configuration
public class DBConfig {
	@Value("#{dbProps['datasource.jdbc.driver']}")
	private String driver;
	@Value("#{dbProps['datasource.jdbc.url']}")
	private String url;
	@Value("#{dbProps['datasource.jdbc.username']}")
	private String username;
	@Value("#{dbProps['datasource.jdbc.password']}")
	private String password;
	
    @Bean(destroyMethod="close")
    public DataSource dataSource(){
        BasicDataSource dataSource = new BasicDataSource();
        
        dataSource.setDriverClassName(driver);
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        System.out.println("Datasource bean create");
        return dataSource;
    }
}
