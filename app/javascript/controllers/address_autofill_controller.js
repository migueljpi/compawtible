import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Address autofill controller connected");
    const script = document.getElementById('search-js');

    if (script.loaded) {
      console.log("Search.js already loaded");
      this.initializeAutofill();
    } else {
      script.addEventListener('load', () => {
        console.log("Search.js loaded");
        this.initializeAutofill();
      });
    }
  }

  fetchLocations(event) {
    if (event.target.value.length >= 3) {
      console.log(event.target.value);
      const location = event.target.value
      const accessToken = 'ENV['MAPBOX_ACCESS_TOKEN']'
      const apiEndpoint = `https://api.mapbox.com/search/geocode/v6/forward?q=${location}&access_token=${accessToken}`
      const locationOptions = document.getElementById("location-options");
      locationOptions.innerHTML = '';
      fetch(apiEndpoint)
        .then(response => response.json())
        .then(data => {
          const locations = data.features.map(feature => {
            console.log(feature.properties.full_address);
            console.log(feature.properties.context.place);
            locationOptions.insertAdjacentHTML('beforeend', `<option value="${feature.properties.full_address}">${feature.properties.full_address}</option>`);
            return feature.properties.full_address;
          });
        });
      }
  }
}
