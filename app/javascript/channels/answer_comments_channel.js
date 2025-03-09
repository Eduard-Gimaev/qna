import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const element = document.querySelector('[id^="comments-list-answer"]')
  
  if (element) {
    const answerId = element.dataset.answerId

    consumer.subscriptions.create({ channel: "AnswerCommentsChannel", answer_id: answerId }, {
      connected() {
        console.log("Connected to the AnswerCommentsChannel with answer_id:", answerId)
      },

      disconnected() {
        console.log("Disconnected from the AnswerCommentsChannel")
      },

      received(data) {
        console.log("Received data:", data)
        const answerCommentsList = document.getElementById(`comments-list-answer-${data.answer_id}`)
        if (answerCommentsList) {
          answerCommentsList.insertAdjacentHTML("beforeend", data.comment.body)
        }
      }
    })
  }
})