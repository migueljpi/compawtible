import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["loadingModal"];

  connect() {
    console.log(":white_check_mark: LoadingController connected");

    document.addEventListener("turbo:submit-start", () => { //triggers after submit
      console.log(":rocket: Form submitted, showing loading modal...");
      this.showLoadingModal.bind(this); // We can add bind to make sure it happens once
    });

    document.addEventListener("turbo:frame-load", (event) => { //triggers after new content is loaded
      if (event.target.id === "output-three") { // output-three is the new content
        console.log(":white_check_mark: Data received, hiding loading modal...");
        this.hideLoadingModal.bind(this); // Same here
      }
    });
  }

  // We can remove event listeners to prevent duplicates
  disconnect() {
    document.removeEventListener("turbo:submit-start", this.showLoadingModal());
    document.removeEventListener("turbo:frame-load", this.hideLoadingModal());
  }

  showLoadingModal() {
    if (this.loadingModalTarget) {
      this.loadingModalTarget.classList.remove("d-none");

      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget);
      if (!modal) {
        modal = new bootstrap.Modal(this.loadingModalTarget, { backdrop: false, keyboard: false });
      }
      modal.show();
    } else {
      console.error(":x: Loading modal not found!");
    }
  }

  hideLoadingModal() {
    if (this.loadingModalTarget) {
      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget); //get bootstrap modal
      if (modal) {
        //We can try to replace settimeout with this to make sure the event happens only once
        // <start>
        this.loadingModalTarget.addEventListener("hidden.bs.modal", () => { // This is triggered by finishing modal.hide()
          this.loadingModalTarget.classList.add("d-none");
        }, { once: true });
        // <end>
        modal.hide(); //bootstrap will hide modal
      }
      setTimeout(() => { //set timeout to allow bootstrap to finish hiding modal before adding "d-none"
        this.loadingModalTarget.classList.add("d-none");
      }, 300);
    }
  }
}
