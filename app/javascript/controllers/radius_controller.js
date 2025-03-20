import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="radius"
export default class extends Controller {
  static targets = ["slider", "output"]

  connect() {
    console.log("Hello, radius!")
  }

  update() {
    this.outputTarget.textContent = `${this.sliderTarget.value} km`
  }
}
