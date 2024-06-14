import GistClient from 'gist-client';

document.addEventListener('turbolinks:load', () => {
  const token = document.querySelector('meta[name="github-token"]').content;
  const gistClient = new GistClient();
  gistClient.setToken(token);

  const gistLinks = document.querySelectorAll('.gist-link');

  gistLinks.forEach(link => {
    const gistUrl = link.href;
    const gistId = gistUrl.split('/').pop();

    gistClient.getOneById(gistId)
      .then(gist => {
        const gistContent = gist.files[Object.keys(gist.files)[0]].content;

        const gistContainer = document.createElement('div');
        gistContainer.classList.add('gist-content');
        gistContainer.innerText = gistContent;

        link.parentElement.appendChild(gistContainer);
        link.remove();
      })
      .catch(error => console.error('Error loading Gist:', error));
  });
});
