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
      const accessToken = 'pk.eyJ1IjoibWlndWVsanBpIiwiYSI6ImNtOGQ5ZGF6aTFjZDcyaXM1dW80MWUwNDQifQ.KXuPqIDaEnTkIjUJTNZ_Uw'
      const apiEndpoint = `https://api.mapbox.com/search/geocode/v6/forward?q=${location}&access_token=${accessToken}`

      fetch(apiEndpoint)
        .then(response => response.json())
        .then(data => {
          const locations = data.features.map(feature => {
            // document.getElementById("cars").insertAdjacentHTML('beforeend', `<option value="${feature.properties.context.place.name}">${feature.properties.context.place.name}</option>`);
            // return feature.properties.context.place.name;
          });
        });
      }
  }
}
