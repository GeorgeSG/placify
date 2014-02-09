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

function latLng(lat, lng) {
  return new google.maps.LatLng(lat, lng);
}
