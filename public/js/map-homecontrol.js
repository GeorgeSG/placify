/**
 * The HomeControl adds a control to the map that
 * returns the user to the control's defined home.
 */

// Define a property to hold the Home state
HomeControl.prototype._home = null;

// Define setters and getters for this property
HomeControl.prototype.getHome = function() {
  return this._home;
}

HomeControl.prototype.setHome = function(home) {
  this._home = home;
}

function HomeControl(controlDiv, map, home) {
  var control   = this;
  control._home = home;

  // Set CSS styles for the DIV containing the control
  // Setting padding to 5 px will offset the control
  // from the edge of the map
  controlDiv.style.padding = '5px';

  // Set CSS for the control border
  var goHomeUI = document.createElement('div');
  goHomeUI.style.display         = 'inline-block';
  goHomeUI.style.backgroundColor = 'white';
  goHomeUI.style.borderStyle     = 'solid';
  goHomeUI.style.borderWidth     = '1px';
  goHomeUI.style.borderColor     = 'rgba(0, 0, 0, 0.14902)';
  goHomeUI.style.cursor          = 'pointer';
  goHomeUI.style.color           = 'rgb(86, 86, 86)';
  goHomeUI.style.textAlign       = 'center';
  goHomeUI.title = 'Center map at home';
  controlDiv.appendChild(goHomeUI);

  // Set CSS for the control interior
  var goHomeText = document.createElement('div');
  goHomeText.style.fontFamily = 'Roboto, Arial, sans-serif';
  goHomeText.style.fontSize   = '11px';
  goHomeText.style.padding    = '1px 6px';
  goHomeText.innerHTML = 'Home';
  goHomeUI.appendChild(goHomeText);

  // Set CSS for the setHome control border
  var setHomeUI = document.createElement('div');
  setHomeUI.style.display         = 'inline-block';
  setHomeUI.style.marginLeft      = '1px';
  setHomeUI.style.backgroundColor = 'white';
  setHomeUI.style.borderStyle     = 'solid';
  setHomeUI.style.borderWidth     = '1px';
  setHomeUI.style.borderColor     = 'rgba(0, 0, 0, 0.14902)';
  setHomeUI.style.cursor          = 'pointer';
  setHomeUI.style.color           = 'rgb(86, 86, 86)';
  setHomeUI.style.textAlign       = 'center';
  setHomeUI.title = 'Set home at current position.';
  controlDiv.appendChild(setHomeUI);

  // Set CSS for the control interior
  var setHomeText = document.createElement('div');
  setHomeText.style.fontFamily = 'Roboto, Arial, sans-serif';
  setHomeText.style.fontSize = '11px';
  setHomeText.style.padding = '1px 6px';
  setHomeText.innerHTML = 'Set Home';
  setHomeUI.appendChild(setHomeText);

  // Setup the click event listener for Home:
  // simply set the map to the control's current home property.
  _m.event.addDomListener(goHomeUI, 'click', function() {
    var currentHome = control.getHome();
    map.panTo(currentHome);
  });

  // Setup the click event listener for Set Home:
  // Set the control's home to the current Map center.
  _m.event.addDomListener(setHomeUI, 'click', function() {
    // TODO: call backend services
    var newHome = map.getCenter();
    control.setHome(newHome);

    $.getJSON("/json/loggedUser.json", function(json) {
      if (json.id !== null) {
        var params = {lat: newHome.lat(), lng: newHome.lng()}
        console.log(newHome)
        $.post("/json/setHome/" + json.id, params, function(data) {
          console.log(data);
        });
      }
    });

  });
}

