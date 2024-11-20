import { Controller } from "@hotwired/stimulus"
import autosize from "autosize/dist/autosize";

// Connects to data-controller="textarea-autosize"
export default class extends Controller {
  connect() {
    autosize(this.element)
  }
}
