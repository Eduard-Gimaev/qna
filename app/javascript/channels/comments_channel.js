import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const commentsElements = document.querySelectorAll('[id^="comments-list"]')
  console.log('commentsElements:', commentsElements)
  
  commentsElements.forEach((element) => {
    const questionId = element.dataset.questionId
    const answerId = element.dataset.answerId

    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: questionId, answer_id: answerId }, {
      connected() {
        console.log('Connected to the CommentsChannel')
      },

      disconnected() {
        console.log('Disconnected from the CommentsChannel')
      },

      received(data) {
        console.log("Received data:", data)
        if (answerId) {
          const commentsAnswer = document.querySelector(`#comments-list-answer-${answerId}`)
          if (commentsAnswer) {
            commentsAnswer.insertAdjacentHTML('beforeend', data)
          }
        } else if (questionId) {
          const commentsQuestion = document.querySelector(`#comments-list-question-${questionId}`)
          if (commentsQuestion) {
            commentsQuestion.insertAdjacentHTML('beforeend', data)
          }
        }
      }
    })
  })
})