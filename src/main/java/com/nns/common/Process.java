package com.nns.common;

import org.apache.ibatis.session.SqlSession;

public interface Process {
    public void execute(SqlSession session) throws Exception;
}
