import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="radius"
export default class extends Controller {
  static targets = ["slider", "output"];

  connect() {
    console.log("Radius controller connected");
    this.update(); // Set the initial value on connect
  }

  update() {
    this.outputTarget.textContent = `${this.sliderTarget.value} km`;

    // Trigger the search method in the search controller
    const searchController = this.element.closest("[data-controller='search']").controller;
    if (searchController) {
      searchController.search();
    }
  }
}
