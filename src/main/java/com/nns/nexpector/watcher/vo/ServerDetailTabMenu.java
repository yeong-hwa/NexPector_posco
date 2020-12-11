package com.nns.nexpector.watcher.vo;

/**
 * 감시장비별 상세조회 Tab Menu - Value Object Class
 * @since 2015-04-28
 * @author Han Joonho
 */
public class ServerDetailTabMenu {

    private int styleCode;
    private int snmpManCode;
    private int typeCode;
    private String vgName;
    private int seqSvrTabMenu;
    private String tabKey;
    private String tabName;
    private String tabUrl;
    private String cmType;

    public int getStyleCode() {
        return styleCode;
    }

    public void setStyleCode(int styleCode) {
        this.styleCode = styleCode;
    }

    public int getSnmpManCode() {
        return snmpManCode;
    }

    public void setSnmpManCode(int snmpManCode) {
        this.snmpManCode = snmpManCode;
    }

    public int getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(int typeCode) {
        this.typeCode = typeCode;
    }

    public String getVgName() {
        return vgName;
    }

    public void setVgName(String vgName) {
        this.vgName = vgName;
    }

    public int getSeqSvrTabMenu() {
        return seqSvrTabMenu;
    }

    public void setSeqSvrTabMenu(int seqSvrTabMenu) {
        this.seqSvrTabMenu = seqSvrTabMenu;
    }

    public String getTabKey() {
        return tabKey;
    }

    public void setTabKey(String tabKey) {
        this.tabKey = tabKey;
    }

    public String getTabName() {
        return tabName;
    }

    public void setTabName(String tabName) {
        this.tabName = tabName;
    }

    public String getTabUrl() {
        return tabUrl;
    }

    public void setTabUrl(String tabUrl) {
        this.tabUrl = tabUrl;
    }

    public String getCmType() {
        return cmType;
    }

    public void setCmType(String cmType) {
        this.cmType = cmType;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("ServerDetailTabMenu{");
        sb.append("styleCode=").append(styleCode);
        sb.append(", snmpManCode=").append(snmpManCode);
        sb.append(", typeCode=").append(typeCode);
        sb.append(", vgName='").append(vgName).append('\'');
        sb.append(", seqSvrTabMenu=").append(seqSvrTabMenu);
        sb.append(", tabKey='").append(tabKey).append('\'');
        sb.append(", tabName='").append(tabName).append('\'');
        sb.append(", tabUrl='").append(tabUrl).append('\'');
        sb.append(", cmType='").append(cmType).append('\'');
        sb.append('}');
        return sb.toString();
    }
}
