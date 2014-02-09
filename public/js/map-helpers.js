/**
 * Creates a new marker and displays it on the map
 */
function placeMarker(map, position, title, draggable) {
  var marker = new _m.Marker({
      map: map,
      position: position,
      title: title,
      animation: google.maps.Animation.DROP,
      draggable: draggable || false
  });

  return marker;
}

/**
 * Easier creation of LatLng objects
 */
function latLng(lat, lng) {
  return new _m.LatLng(lat, lng);
}
