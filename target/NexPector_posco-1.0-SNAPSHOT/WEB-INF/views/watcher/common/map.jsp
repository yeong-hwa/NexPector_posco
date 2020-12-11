<%@ page contentType="text/html;charset=utf-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Simple Map</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
        html, body, #map-canvas {
            height: 100%;
            margin: 0px;
            padding: 0px
        }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
    <script>
        var map;
        function initialize() {
            var mapOptions = {
                zoom: 13,
                scrollwheel: false,
                center: new google.maps.LatLng(37.5621064, 126.9787353)
            };
            map = new google.maps.Map(document.getElementById('map-canvas'),
                    mapOptions);
        }

        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</head>
<body>
<div id="map-canvas"></div>
</body>
</html>
