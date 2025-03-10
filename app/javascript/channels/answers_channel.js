import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const answersList = document.getElementById("answers-list")
  if (answersList) {
    const questionId = answersList.dataset.questionId

    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
      connected() {
        console.log("Connected to the AnswersChannel")
      },

      disconnected() {
        console.log("Disconnected from the AnswersChannel")
      },

      received(data) {
        console.log("Received data:", data)
        answersList.insertAdjacentHTML("beforeend", data)
      }
    })
  }
})