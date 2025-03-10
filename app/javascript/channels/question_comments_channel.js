import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const element = document.querySelector('[id^="comments-list-question"]')
  
  if (element) {
    const questionId = element.dataset.questionId

    consumer.subscriptions.create({ channel: "QuestionCommentsChannel", question_id: questionId }, {
      connected() {
        console.log("Connected to the QuestionCommentsChannel with question_id:", questionId)
      },

      disconnected() {
        console.log("Disconnected from the QuestionCommentsChannel")
      },

      received(data) {
        console.log("Received data:", data)
        const questionCommentsList = document.getElementById(`comments-list-question-${data.question_id}`)
        if (questionCommentsList) {
          questionCommentsList.insertAdjacentHTML("beforeend", data.comment.body)
        }
      }
    })
  }
})