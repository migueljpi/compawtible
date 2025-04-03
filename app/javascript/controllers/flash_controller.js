import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    console.log("Connected to flash controller")
    setTimeout(() => {
      this.element.classList.add('hidden');
      console.log('hidden applied');
    }, 7000);
  }
}
