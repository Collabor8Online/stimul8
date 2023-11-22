import { Controller } from "@hotwired/stimulus"
import { componentSubscription } from "@rails/actioncable"
import morphdom from "morphdom"

export default class extends Controller {
  static values = { className: String }
  connect() {
    this.subscription = componentSubscription(this.element.id, this.classNameValue, this.element)
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  async callMethod(event) {
    event.preventDefault();
    this.subscription.callMethod(event.params)
  }
}

