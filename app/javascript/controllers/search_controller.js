import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "location", "radius"];

  connect() {
    console.log("Search controller connected");
  }

  async search() {
    const query = this.inputTarget.value;
    const location = this.locationTarget.value;
    const radius = this.radiusTarget.value;

    console.log("Searching with:", { query, location, radius });

    const params = new URLSearchParams({
      query: query,
      location: location,
      radius: radius,
    });

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
