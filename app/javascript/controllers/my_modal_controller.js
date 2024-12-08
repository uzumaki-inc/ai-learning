import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="my-modal"
export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element)
    this.modal.show()
  }

  disconnect() {
    // このコードがなくても一見ちゃんと動くが、将来予期せぬ問題が起きる可能性があるので念のためモーダルを廃棄する
    this.modal.dispose();
  }

  close(event) {
    if (event.detail.success) {
      this.modal.hide()
    }
  }
}
