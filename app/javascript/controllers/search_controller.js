import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "location", "radius", "checkbox", "locationFields"];

  connect() {
    console.log("Search controller connected");
  }

  toggleLocationFields() {
    const isChecked = this.checkboxTarget.checked;
    console.log("Use my location:", isChecked);

    if (isChecked) {
      this.locationFieldsTarget.style.display = "block";
    } else {
      this.locationFieldsTarget.style.display = "none";
      this.search(); // Trigger search to reset pets when unticked
    }
  }

  async search() {
    const query = this.inputTarget.value;
    const useMyLocation = this.checkboxTarget.checked;
    const params = new URLSearchParams({ query: query });

    if (useMyLocation) {
      const location = this.locationTarget.value;
      const radius = this.radiusTarget.value;
      params.append("location", location);
      params.append("radius", radius);
    }

    console.log("Searching with:", Object.fromEntries(params.entries()));

    const response = await fetch(`/users/${this.element.dataset.searchUserId}/pets?${params.toString()}`, {
      method: "GET",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
      },
    });

    if (response.ok) {
      const turboStream = await response.text();
      this.resultsTarget.innerHTML = turboStream;
    } else {
      console.error("Error fetching results:", response.statusText);
    }
  }
}
