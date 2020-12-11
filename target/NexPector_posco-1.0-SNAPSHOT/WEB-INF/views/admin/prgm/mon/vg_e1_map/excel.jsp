<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Kendo UI Snippet</title>

    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.2.714/styles/kendo.common.min.css"/>
    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.2.714/styles/kendo.rtl.min.css"/>
    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.2.714/styles/kendo.silver.min.css"/>
    <link rel="stylesheet" href="http://kendo.cdn.telerik.com/2016.2.714/styles/kendo.mobile.all.min.css"/>

    <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script src="http://kendo.cdn.telerik.com/2016.2.714/js/jszip.min.js"></script>
    <script src="http://kendo.cdn.telerik.com/2016.2.714/js/kendo.all.min.js"></script>
</head>
<body>
  
<script>
var workbook = new kendo.ooxml.Workbook({
  sheets: [
    {
      columns: [ { autoWidth: true } ],
      rows: [
        {
          cells: [
            {
              value: "장비ID",
              bold: true,
              italic: true
            },
            {
              value: "장비명",
              bold: true,
              italic: true
            },
            {
              value: "장비IP",
              bold: true,
              italic: true
            },
            {
              value: "그룹명",
              bold: true,
              italic: true
            },
            {
              value: "E1 Port",
              bold: true,
              italic: true
            },
            {
              value: "지점코드",
              bold: true,
              italic: true
            },
            {
              value: "지점명",
              bold: true,
              italic: true
            }
          ]
        },
        {
          cells: [
            {
              value: "Centered horizontally and vertically",
              vAlign: "center",
              hAlign: "center",
              rowSpan: 2
            }
          ]
        }
      ]
    }
  ]
});
kendo.saveAs({
    dataURI: workbook.toDataURL(),
    fileName: "vg_e1_jum_mapping.xlsx"
});
</script>
</body>
</html>