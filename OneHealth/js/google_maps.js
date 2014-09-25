var map;
// Retrive the latitude and longitude from the hidden controls
var currentLatLng = new google.maps.LatLng(document.getElementById('hidden_lat').value, document.getElementById('hidden_lng').value);

function initialize() {

    // Set the center and zoom factor
    var mapOptions = {
        zoom: 14,
        center: currentLatLng
    };

    // Set the icon used for the marker
    var customIcon = "http://maps.google.com/mapfiles/ms/icons/yellow.png";

    // set the map to the element on the page
    map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

    // Disply the info window on the page
    var infowindow = new google.maps.InfoWindow();

    // Use the place marker to mark the place
    var yourPlaceMarker = new google.maps.Marker({
        position: currentLatLng,
        map: map,
        title: "You are here now !!",
        animation: google.maps.Animation.DROP,
        icon: customIcon
    });

    // Add the mouseover event so that the info window is displayed when hovered over the marker
    google.maps.event.addListener(yourPlaceMarker, 'mouseover', function () {
        infowindow.setContent(this.title);
        infowindow.open(map, this);
    });

}

google.maps.event.addDomListener(window, 'load', initialize);