import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stimul8"
export default class extends Controller {

  async callAction(event) {
    event.preventDefault();
  }
}
