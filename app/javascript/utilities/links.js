function checkGists() {
  var elements = document.getElementsByClassName("gist-content");

  Array.prototype.forEach.call(elements, function(element) {
    var gistId = element.getAttribute('data-gist-id');

    fetch(`https://api.github.com/gists/${gistId}`)
      .then(response => response.json())
      .then(data => {
        element.innerHTML = `<pre>${data.files[Object.keys(data.files)[0]].content}</pre>`;
      })
      .catch(error => {
        console.error('Error fetching gist:', error);
      });
  });
}

document.addEventListener('turbolinks:load', function() {
  window.checkGists = checkGists;
  checkGists();
});