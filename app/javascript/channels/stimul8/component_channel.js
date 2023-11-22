import consumer from "channels/consumer"
import { Turbo } from "@hotwired/turbo-rails"

export default componentSubscription = (componentId, componentClass, element) => consumer.subscriptions.create(
  { channel: "ComponentChannel", componentClass: componentClass, componentId: componentId },
  {
    connected() {
      // Called when the subscription is ready for use on the server
    },
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
    received(data) {
      if (data.type == "redraw") {
        element.outerHTML = data.html
      } else if (data.type == "remove") {
        element.remove()
      } else if (data.type == "reload") {
        Turbo.visit(window.location.href, { action: "replace" })
      } else if (data.type == "redirect") {
        Turbo.visit(data.redirectUrl)
      }
      // TODO: add in types for animations and events - and add event handlers to components
    },
    callMethod(params) {
      this.perform("call_method", params)
    }
  }
);
