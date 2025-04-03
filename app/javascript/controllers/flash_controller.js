import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    console.log("Connected to flash controller")
    this.removeExistingFlash();
    setTimeout(() => {
      this.element.classList.add('fade-out');
      console.log('fade-out applied');
    }, 4000);
  }

  removeExistingFlash() {
    const existingFlash = document.querySelectorAll('.alert[data-controller="flash"]');
    existingFlash.forEach (flash => {
      if (flash !== this.element) {
        flash.classList.add('fade-out');
      }
    })
  }
}
