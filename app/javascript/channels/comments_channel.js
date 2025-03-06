import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const commentsElements = document.querySelectorAll('[id^="comments-list"]')
  console.log('commentsElements:', commentsElements)
  commentsElements.forEach((commentsElement) => {
    const questionId = commentsElement.dataset.questionId
    const answerId = commentsElement.dataset.answerId


    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: questionId  }, {
      connected() {
        console.log('Connected to the CommentsChannel')
        console.log('questionId:', questionId)
        console.log('answerId:', answerId)
      },

      disconnected() {
        console.log('Disconnected from the CommentsChannel')
      },

      received(data) {
        console.log("Received data:", data)
        console.log('questionId:', questionId)
        console.log('answerId:', answerId)
        if (answerId) {
          console.log('Processing comment for answerId:', answerId)
          const answerCommentsElement = document.querySelector(`#comments-list-${answerId}`)
          if (answerCommentsElement) {
            answerCommentsElement.insertAdjacentHTML('beforeend', data)
          }
        } else if (questionId) { 
          console.log('Processing comment for questionId:', questionId)
          const questionCommentsElement = document.querySelector(`#comments-list-${questionId}`)
          if (questionCommentsElement) {
            questionCommentsElement.insertAdjacentHTML('beforeend', data)
          }
        }
      }
    })
  })
})