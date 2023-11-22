import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"
import { componentSubscription } from "../channels/stimul8/component_channel.js"
import morphdom from "morphdom"

export default class extends Controller {
  static values = { className: String }
  connect() {
    this.subscription = this.connectToServer()
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  async callMethod(event) {
    event.preventDefault();
    this.subscription.callMethod(event.params)
  }

  subscription() {
    consumer.subscriptions.create(
      { channel: "ComponentChannel", componentClass: this.classNameValue, componentId: this.element.id },
      {
        received(data) {
          if (data.reaction == "redraw") {
            this.redraw(data.html)
          } else if (data.reaction == "remove") {
            this.removeElement()
          } else if (data.reaction == "reload") {
            this.reloadPage()
          } else if (data.reaction == "redirect") {
            this.redirectTo(data.redirectUrl)
          } else if (data.reaction == "dispatch_event") {
            this.dispatchEvent(data.eventName, data.eventDetail)
          } else if (data.reaction == "animation") {
            this.animate(data.keyFrames, data.timings)
          }
          // TODO: add in types for animations and events - and add event handlers to components
        },
        callMethod(params) {
          this.perform("call_method", params)
        }
      }
    );
  }

  async redraw(html) {
    this.element.classList.add("is-updating")
    element.outerHTML = data.html
  }

  async removeElement() {
    this.element.classList.add("is-removing")
    this.element.remove()
  }

  async reloadPage() {
    this.element.classList.add("is-waiting")
    Turbo.visit(window.location.href, { action: "replace" })
  }

  async redirectTo(url) {
    this.element.classList.add("is-waiting")
    Turbo.visit(url)
  }

  async dispatchEvent(eventName, eventDetail) {
    this.element.dispatchEvent(new CustomEvent(eventName, { detail: eventDetail }))
  }

  async animate(keyFrames, timings) {
    this.element.animate(keyFrames, timings)
  }
}

