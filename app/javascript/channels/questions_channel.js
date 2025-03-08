
import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log("Connected to the QuestionsChannel")
  },

  disconnected() {
    console.log("Disconnected from the QuestionsChannel")
  },

  received(data) {
    console.log("Received data:", data)
    const questionsList = document.getElementById("questions-list")
    if (questionsList) {
      questionsList.insertAdjacentHTML("beforeend", data)
    }
  }
})