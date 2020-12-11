package com.nns.nexpector.common.kendo.vo;

public class Sort {
    private String field;
    private String dir;

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("Sort{");
        sb.append("field='").append(field).append('\'');
        sb.append(", dir='").append(dir).append('\'');
        sb.append('}');
        return sb.toString();
    }
}
