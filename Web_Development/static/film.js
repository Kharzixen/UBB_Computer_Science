/* eslint-disable prefer-destructuring */
// eslint-disable-next-line no-unused-vars
function showMoreData(id, element) {
  fetch(`/getMoreData?movieID=${id}`, {
    method: 'get',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
  })
    .then((response) => {
      if (response.status === 200) {
        response.json().then((message) => {
          console.log(message);
          if  (message.error === undefined) {
            const genres = message.Genres;
            const description = message.Description;
            console.log(genres, description);
            // eslint-disable-next-line no-param-reassign
            const p1 = document.createElement('p');
            const p2 = document.createElement('p');
            const b1 = document.createElement('b');
            const b2 = document.createElement('b');
            b1.innerText = 'Genres: ';
            b2.innerText = 'Description: ';
            p1.appendChild(b1);
            p2.appendChild(b2);
            p1.append(`${genres}`);
            p2.append(`${description}`);
            p1.classList.add('genres');
            p2.classList.add('description');
            console.log(p1, p2);
            element.getElementsByClassName('genres')[0].replaceWith(p1);
            element.getElementsByClassName('description')[0].replaceWith(p2);
          } else {
            console.log(message.error);
          }
        });
      } else {
        console.log('Error while trying to show more data.');
      }
    });
}

// eslint-disable-next-line no-unused-vars
// eslint-disable-next-line max-lines-per-function
function submitDetailsForm(event) {
  event.preventDefault();
  const form = event.target;
  const formData = new FormData(form);
  fetch('/submitDetailsReview', {
    method: 'post',
    body: formData,
  }).then((response) => {
    response.json().then((message) => {
      if (response.status === 200) {
        const data = message;
        console.log(data);
        const id = data.id;
        const user = data.user;
        const rating = data.rating;
        const review = data.review;
        const isadmin = data.isadmin;
        const newRevBox = document.createElement('div');
        newRevBox.classList.add('reviewbox');
        const p0 = document.createElement('p');
        const p1 = document.createElement('p');
        const p2 = document.createElement('p');
        const p3 = document.createElement('p');
        const p4 = document.createElement('p');
        const p5 = document.createElement('p');
        const b0 = document.createElement('b');
        const b1 = document.createElement('b');
        const b2 = document.createElement('b');
        const b3 = document.createElement('b');
        const button = document.createElement('button');
        const approveButton = document.createElement('button');
        const refuseButton = document.createElement('button');
        const br = document.createElement('br');
        p0.classList.add('statusfield');
        p1.classList.add('idfield');
        p2.classList.add('userfield');
        p1.innerText = id;
        button.setAttribute('onclick', 'deleteComment(this.parentNode)');
        approveButton.setAttribute('onclick', 'approveComment(this.parentNode)');
        refuseButton.setAttribute('onclick', 'refuseComment(this.parentNode)');
        button.innerText = 'Delete Comment';
        approveButton.innerText = 'Approve Comment';
        refuseButton.innerText = 'Refuse Comment';
        approveButton.classList.add('approveButton');
        refuseButton.classList.add('refuseButton');
        b0.innerText = 'Status: ';
        b1.innerText = 'User: ';
        b2.innerText = 'Rating: ';
        b3.innerText = 'Review: ';
        p0.appendChild(b0);
        if (isadmin) {
          p0.append('Pending...');
        } else {
          p0.append('Pending... (An admin will approve your comment asap :) )');
        }
        p2.appendChild(b1);
        p3.appendChild(b2);
        p4.appendChild(b3);
        p2.append(user);
        p3.append(rating);
        p5.classList.add('det_revdescr');
        p5.append(review);
        newRevBox.appendChild(p0);
        newRevBox.appendChild(p1);
        newRevBox.appendChild(p2);
        newRevBox.appendChild(p3);
        newRevBox.appendChild(p4);
        newRevBox.appendChild(p5);
        newRevBox.appendChild(button);
        newRevBox.append(' ');
        if (isadmin) {
          newRevBox.appendChild(approveButton);
          newRevBox.append(' ');
          newRevBox.appendChild(refuseButton);
        }
        document.getElementById('reviews').appendChild(newRevBox);
        newRevBox.parentNode.appendChild(br);
        console.log(isadmin);
      } else {
        console.log(message.error);
      }
    });
  });
}

// eslint-disable-next-line no-unused-vars
function deleteComment(element) {
  const revID = element.getElementsByClassName('idfield')[0].innerText;
  const owner = element.getElementsByClassName('userfield')[0].innerText.split(' ')[1];
  fetch('/delete_comment', {
    method: 'post',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      id: revID,
      user: owner,
    }),
  }).then((response) => {
    if (response.status === 200) {
      response.json().then((message) => {
        const msg = (message.msg);
        // eslint-disable-next-line no-param-reassign
        const newChild = document.createElement('p');
        newChild.innerText = `${msg}`;
        element.replaceWith(newChild);
      });
    } else {
      const newChild = document.createElement('p');
      newChild.innerText = '*can not be deleted*';
      element.replaceWith(newChild);
      console.log('Comment deletetion error');
    }
  });
}

// eslint-disable-next-line no-unused-vars
function approveComment(element) {
  const revID = element.getElementsByClassName('idfield')[0].innerText;
  fetch('/approve_comment', {
    method: 'post',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      id: revID,
    }),
  }).then((response) => {
    if (response.status === 200) {
      response.json().then((message) => {
        const msg = (message.msg);
        console.log(element.getElementsByClassName('statusfield')[0]);
        const statusfield = element.getElementsByClassName('statusfield')[0];
        statusfield.replaceChildren();
        const b = document.createElement('b');
        b.innerText = 'Status: ';
        statusfield.appendChild(b);
        statusfield.append(msg);
        const approveButton = element.getElementsByClassName('approveButton')[0];
        element.removeChild(approveButton);
        const refuseButton = document.createElement('button');
        refuseButton.setAttribute('onclick', 'refuseComment(this.parentNode)');
        refuseButton.innerText = 'Refuse Comment';
        refuseButton.classList.add('refuseButton');
        if (!element.getElementsByClassName('refuseButton')[0]) {
          element.append(' ');
          element.appendChild(refuseButton);
        }
      });
    } else {
      console.log('Can not be approved');
    }
  });
}

// eslint-disable-next-line no-unused-vars
function refuseComment(element) {
  const revID = element.getElementsByClassName('idfield')[0].innerText;
  fetch('/refuse_comment', {
    method: 'post',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      id: revID,
    }),
  }).then((response) => {
    if (response.status === 200) {
      response.json().then((message) => {
        const msg = (message.msg);
        console.log(element.getElementsByClassName('statusfield')[0]);
        const statusfield = element.getElementsByClassName('statusfield')[0];
        statusfield.replaceChildren();
        const b = document.createElement('b');
        b.innerText = 'Status: ';
        statusfield.appendChild(b);
        statusfield.append(msg);
        const refuseButton = element.getElementsByClassName('refuseButton')[0];
        element.removeChild(refuseButton);
        const approveButton = document.createElement('button');
        approveButton.setAttribute('onclick', 'approveComment(this.parentNode)');
        approveButton.innerText = 'Approve Comment';
        approveButton.classList.add('approveButton');
        if (!element.getElementsByClassName('approveButton')[0]) {
          element.append(' ');
          element.appendChild(approveButton);
        }
      });
    } else {
      console.log('Can not be refused');
    }
  });
}
