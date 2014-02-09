// Hash that will hold all markers, grouped by type
defaultCategories = {};
userCategories = {};

// Hardcode Init until server is ready
userCategories['billiard'] = [];
userCategories['snooker'] = [];
userCategories['darts'] = [];

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

// Call initial map-loading logic
_m.event.addDomListener(window, 'load', loadMap);

/**
 * Called when the DOM is loaded.
 * Initializes the map and loads all points
 */
function loadMap() {
  // Create Map
  map = new _m.Map(document.getElementById("map-canvas"), mapOptions);

  // Setup the click event listener for the Map:
  // Add a new marker on the clicked location
  _m.event.addListener(map, 'click', addNewPoint);

  // Create the DIV to hold the control and call the
  // HomeControl() constructor passing in this DIV.
  var homeControlDiv = document.createElement('div');
  var homeControl    = new HomeControl(homeControlDiv, map, home);

  homeControlDiv.index = 1;
  map.controls[_m.ControlPosition.TOP_RIGHT].push(homeControlDiv);

  // Get All Public Points and load them as markers on the Map.
  // TODO: Call backend services
  $.getJSON("/mock/points.json", function(json) {
      loadMarkers(json.markers, 'default');
  }).fail(function() {
    console.log('Failed Loading JSON!');
  });

  // Get All User Points and load them as markers on the Map.
  // TODO: Call backend services
  $.getJSON("/mock/userPoints.json", function(json) {
      loadMarkers(json.markers, 'user');
  }).fail(function() {
    console.log('Failed Loading JSON!');
  });
}

/**
 * Shows a modal to enter new point. If saved,
 * the point is stored and shown on the map
 */
function addNewPoint(event) {
  var clickEvent = event;
  infoWindow.close();

  var marker = placeMarker(map, clickEvent.latLng, "New Point", true);
  var $name = $("#new-point-name");
  var $desc = $("#new-point-description");

  $("#add-point-modal").modal("show");

  $(".discard-point").unbind("click").click(function() {
    marker.setMap(null);

    $name.val('');
    $desc.val('');
    $("#add-point-modal input[name=pointType]:checked").prop("checked", false);
  });

  $("#save-point").unbind("click").click(function() {
    var $type = $("#add-point-modal input[name=pointType]:checked");
    var pointName = $name.val();
    var pointDesc = $desc.val();
    var pointType = $type.val();

    $name.val('');
    $desc.val('');
    $type.prop("checked", false);

    pointDesc = "<div><h3>" + pointName + "</h3><span>" + pointType + "</span><p>" + pointDesc + "</p></div>";

    marker.setTitle(pointName);
    addMarker(marker, 'user', pointType, pointDesc);
    // TODO: call backend services to store the point
  });
}

/**
 * Loads a set of Points represented as JSON and
 * displays them on the map.
 *
 * Groups markers by type and adds them to the markers hash
 */
function loadMarkers(jsonMarkers, group) {
  var types = $.map(jsonMarkers, function(marker, _) { return marker.type; });
  types = $.unique(types);
  $.each(types, function(_, type) {
    if (group == 'user') {
      userCategories[type] = [];
    } else {
      defaultCategories[type] = [];
    }
  });

  $.each(jsonMarkers, function(_, element) {
    var position = latLng(element.lat, element.lng);
    var marker   = placeMarker(map, position, element.name, true);

    addMarker(marker, group, element.type, element.description);
  });
}

function addMarker(marker, group, type, description) {
  if (group == 'user') {
    userCategories[type].push(marker);
  } else {
    defaultCategories[type].push(marker);
  }

  // Setup the click event listener for the Marker:
  // Show the infoWindow with information about the selected marker
  _m.event.addListener(marker, 'click', function() {
    infoWindow.close();
    infoWindow.setContent(description)
    infoWindow.open(map, marker);
  });

  // Setup the dragend event listener for the Marker:
  // Persist the new position in the database
  _m.event.addListener(marker, 'dragend', function() {
    // TODO: call backend services - persist new position
    console.log('marker position changed to:');
    console.log(marker.getPosition());
  });
}

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
  $("#user-categories input[type=checkbox]").click(function() {
    var $this   = $(this);
    var checked = $this.is(':checked');
    var type    = this.value;

    if (userCategories[type] !== undefined) {
      $.each(userCategories[type], function(_, marker) {
        marker.setVisible(checked);
      });

      infoWindow.close();
    }
  });

  // Handle filtering of markers via the checkboxes
  $("#default-categories input[type=checkbox]").click(function() {
    var $this   = $(this);
    var checked = $this.is(':checked');
    var type    = this.value;

    if (defaultCategories[type] !== undefined) {
      $.each(defaultCategories[type], function(_, marker) {
        marker.setVisible(checked);
      });

      infoWindow.close();
    }
  });
});
