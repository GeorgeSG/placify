// Hash that will hold all markers, grouped by type
markers = {};

// Alias for the google.maps Object
_m = google.maps;

// infoWindow object used for popups
infoWindow = new _m.InfoWindow();

// Initial Home Position
home = latLng(42.695, 23.347);

// Initial Map Options
mapOptions = {
  center: home,
  zoom: 12
};

/**
 * Called when the DOM is loaded.
 * Initializes the map and loads all points
 */
function loadMap() {
  // Create Map
  map = new _m.Map(document.getElementById("map-canvas"), mapOptions);

  // Setup the click event listener for the Map:
  // Add a new marker on the clicked location
  _m.event.addListener(map, 'click', function(event) {
    // TODO: create a UI to set Point Details
    // TODO: call backend services to store the Point
    var marker = placeMarker(map, event.latLng, "New Point", true);
  });

  // Create the DIV to hold the control and call the
  // HomeControl() constructor passing in this DIV.
  var homeControlDiv = document.createElement('div');
  var homeControl = new HomeControl(homeControlDiv, map, home);

  homeControlDiv.index = 1;
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(homeControlDiv);

  // Get All Public Points and load them as markers
  // on the Map.
  // TODO: Call backend services
  $.getJSON("/mock/points.json", function(json) {
      loadMarkers(json.markers);
  }).fail(function() {
    console.log('Failed Loading JSON!');
  });

  /**
   * Loads a set of Points represented as JSON and
   * displays them on the map.
   *
   * Groups markers by type and adds them to the markers hash
   */
  function loadMarkers(jsonMarkers) {
    var types = $.map(jsonMarkers, function(marker, _) { return marker.type; });
    types     = $.unique(types);

    $.each(types, function(_, type) { markers[type] = [] });

    $.each(jsonMarkers, function(_, element) {
      var position = latLng(element.lat, element.lng);
      var marker   = placeMarker(map, position, element.name, true);
      markers[element.type].push(marker);

      _m.event.addListener(marker, 'click', function() {
        infoWindow.close();
        infoWindow.setContent(element.description)
        infoWindow.open(map, marker);
      });

      _m.event.addListener(marker, 'dragend', function() {
        // TODO: call backend services
        console.log('marker position changed to:');
        console.log(marker.getPosition());
      })
    });
  }
}

// Call initial map-loading logic
_m.event.addDomListener(window, 'load', loadMap);


/**
 * Performs additional needed actions when the DOM is loaded
 */
$(function() {
  var $window = $(window);
  var $canvas = $("#map-canvas");

  // Handle Resizing of the Map canvas
  function resizeCanvas() {
    $canvas.height($(window).height() - 160);
  }

  resizeCanvas();

  $window.resize(function() {
    resizeCanvas();
  });

  // Handle filtering of markers via the checkboxes
  $("#point-types input[type='checkbox']").click(function() {
    var $this   = $(this);
    var checked = $this.is(':checked');
    var type    = this.value;

    if (markers[type] !== undefined) {
      $.each(markers[type], function(_, marker) {
        marker.setVisible(checked);
      });

      infoWindow.close();
    }
  });
});


