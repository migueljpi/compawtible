import { Controller } from "@hotwired/stimulus"
import StarRating from "star-rating.js"

export default class extends Controller {
  connect() {
    // Initialize the star-rating.js library
    new StarRating(this.element, {
      tooltip: false, // Disable the tooltip
      maxStars: 5,  // You can adjust the number of stars here
            classNames: {
        active: 'gl-active', // Active star state class
        base: 'gl-star-rating', // Base star rating class
        selected: 'gl-selected'  // Selected star class
      },
    });
  }

}
