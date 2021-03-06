// Hash that will hold all markers, grouped by type
defaultCategories = {};
userCategories = {};

// Alias for the google.maps Object
_m = google.maps;

// infoWindow object used for popups
infoWindow = new _m.InfoWindow();

// Initial Home Position
home = latLng(42.695, 23.347);

// Initial Map Options
mapOptions = {
  center: home,
  zoom: 12,
  minZoom: 3
};

// Call initial map-loading logic
_m.event.addDomListener(window, 'load', loadMap);

/**
 * Called when the DOM is loaded.
 * Initializes the map and loads all points
 */
function loadMap() {
  map = new _m.Map(document.getElementById("map-canvas"), mapOptions);

  is_admin = false;
  // Checks if the user has admin privilegies
  $.getJSON("/json/adminUser.json", function(json) {
    if (json.admin) {
      is_admin = true;
    }
  });

  // Get All Public Points and load them as markers on the Map.
  $.getJSON("/json/points.json", function(json) {
      loadMarkers(json.markers, 'default');
  });

  // Get All Types of Points listed in the database
  $.getJSON("/json/types.json", function(json) {
    loadTypes("#default-categories", json.types);
  });

  $.getJSON("/json/loggedUser.json", function(json) {
    if (json.id !== null) {
      enableUserInterface(map, json.id);
    }
  });

}

/**
 * All code loading custom user logic
 */
function enableUserInterface(map, user_id) {
  // Setup the click event listener for the Map:
  // Add a new marker on the clicked location
  _m.event.addListener(map, 'click', function(event) {
    addNewPoint(event, user_id);
  });

  // Create the DIV to hold the control and call the
  // HomeControl() constructor passing in this DIV.
  var homeControlDiv = document.createElement('div');
  var homeControl    = new HomeControl(homeControlDiv, map, home);

  homeControlDiv.index = 1;
  map.controls[_m.ControlPosition.TOP_RIGHT].push(homeControlDiv);

  // Get All User Points and load them as markers on the Map.
  $.getJSON("/json/userPoints.json/" + user_id, function(json) {
    loadMarkers(json.markers, 'user');
  });

  $.getJSON("/json/userTypes.json/" + user_id, function(json) {
    loadTypes("#user-categories", json.types);
  });

  $.getJSON("/json/getHome.json/" + user_id, function(json) {
    var newHome = new _m.LatLng(json.lat, json.lng);
    homeControl.setHome(newHome);
    map.setCenter(newHome);
  });
}

/**
 * Shows a modal to enter new point. If saved,
 * the point is stored and shown on the map
 */
function addNewPoint(event, user_id) {
  var clickEvent = event;
  var pointLatLng = clickEvent.latLng;

  infoWindow.close();

  var marker  = placeMarker(map, pointLatLng, "New Point", true);
  var $name   = $("#new-point-name");
  var $desc   = $("#new-point-description");
  var $type   = $("#new-point-type");
  var $extras = $("#new-point-extras");

  $("#add-point-modal").modal("show");

  $(".discard-point").unbind("click").click(function() {
    marker.setMap(null);

    $name.val('');
    $desc.val('');
    $type.val('');
    $extras.val('');
    $("#add-point-modal input[name=pointType]:checked").prop("checked", false);
  });

  $("#save-point").unbind("click").click(function() {
    var point = {
      name: $name.val(),
      lat:  pointLatLng.lat(),
      lng:  pointLatLng.lng(),
      desc: $desc.val(),
      type: $type.val(),
      extras: $extras.val()
    };

    $name.val('');
    $desc.val('');
    $type.val('');
    $extras.val('');

    marker.setTitle(point.name);
    addMarker(marker, 'user', point);
    $.post('/json/addNewPoint/' + user_id, point);
  });
}

/**
 * Loads a set of Types represented as JSON and
 * displays them in the sidebar.
 */
function loadTypes(listSelector, types) {
  $list = $(listSelector);
  $.each(types, function(_, type) {
    $list.append("<li><label><input type='checkbox' value='" + type + "' checked='checked' /> " + type + "</label></li>");
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
    var shouldMove = group == 'user' ? true : is_admin;
    var marker = placeMarker(map, position, element.name, shouldMove);
    addMarker(marker, group, element);
  });
}

function addMarker(marker, group, element) {
  var id = element._id;
  var type = element.type;
  var name = element.name;
  var description;

  description = "<h3>";
  if (group != 'user' && id !== undefined) {
    description += "<a href='/places/" + id + "'>" + name + "</a>";
  } else {
    description += name;
  }
  description += "</h3><span><a href='/places/search/type/" + type + "'>" + type + "</a></span><p>" + element.description + "</p>";

  if (element.priceRange) {
    description += "<p>Price Range: " + element.priceRange + "</p>";
  }

  if (element.seats) {
    description += "<p>Seats: " + element.seats + "</p>";
  }

  if (element.schedule) {
    description += "<p>Schedule:<br />"
    description += "Monday: " + element.schedule.mon[0] + " - " + element.schedule.mon[1] + "<br />";
    description += "Tuesday: " + element.schedule.tue[0] + " - " + element.schedule.tue[1] + "<br />";
    description += "Wednesday: " + element.schedule.wed[0] + " - " + element.schedule.wed[1] + "<br />";
    description += "Thursday: " + element.schedule.thu[0] + " - " + element.schedule.thu[1] + "<br />";
    description += "Friday: " + element.schedule.fri[0] + " - " + element.schedule.fri[1] + "<br />";
  }


  if (group == 'user') {
    if (userCategories[type] === undefined) {
      userCategories[type] = []
    }

    userCategories[type].push(marker);
  } else {
    if (defaultCategories[type] === undefined) {
      defaultCategories[type] = []
    }

    defaultCategories[type].push(marker);
  }

  // Setup the click event listener for the Marker:
  // Show the infoWindow with information about the selected marker
  _m.event.addListener(marker, 'click', function() {
    infoWindow.close();
    infoWindow.setContent(description);
    infoWindow.open(map, marker);

    $.post("/json/updateViews/" + id);
  });

  // Setup the dragend event listener for the Marker:
  // Persist the new position in the database
  _m.event.addListener(marker, 'dragend', function() {
    var markerPosition = marker.getPosition();
    element.lat = markerPosition.lat();
    element.lng = markerPosition.lng();

    $.post("/json/updatePoint/" + id, element);
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
  $("#user-categories").on("click", "input[type=checkbox]", function() {
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
  $("#default-categories").on("click", "input[type=checkbox]", function() {
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
