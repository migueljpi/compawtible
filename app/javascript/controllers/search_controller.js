import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"];

  connect() {
    console.log("Search controller connected");
  }

  // Called on keyup event
  async search() {
    console.log("Searching...");
    const query = this.inputTarget.value;

    // Send a request to the controller to get the pets based on the query
    const response = await fetch(`/users/${this.data.get('userId')}/pets?query=${query}`, {
      method: "GET",
      headers: {
        "Accept": "text/vnd.turbo-stream.html" // Turbo Stream response type
      }
    });

    // Ensure the response is successful
    if (response.ok) {
      // Parse the Turbo Stream response and inject the results into the target container
      const turboStream = await response.text();
      this.resultsTarget.innerHTML = turboStream;
    } else {
      console.error("Error fetching results:", response.statusText);
    }
  }
}
