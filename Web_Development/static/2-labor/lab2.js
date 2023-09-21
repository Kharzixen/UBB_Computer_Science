/*
Mellau Mark-Mate , 523/1
Labor 2 , 6-os sorszám
*/

/*----------------------------------------------------------------------------*/
/* HTML Form függvényei */
/*----------------------------------------------------------------------------*/

// age -> kiszamitjuk a megadott datumbol hogy mi az életkora a játékosnak
let age = 0;
let validEmail = false;
let validURL = false;

const m = document.getElementById('mail');
const fs = document.getElementById('favsite');
const fn = document.getElementById('fname');
const ln = document.getElementById('lname');
const d = document.getElementById('bday');

// minden onblur esetén megvizsgáljuk hogy helyesek-e a megadott adatok --> ekkor megjelenik a submit gomb .
function checkFormValid() {
  if (validEmail && validURL && m.validity.valid && fs.validity.valid
    && fn.value != null && fn.value != '' && ln.value != null && ln.value != '' && ln.validity.valid && fn.validity.valid
    && d.value != null && d.value != '') {
    document.getElementById('submit').style.display = 'block';
  } else document.getElementById('submit').style.display = 'none';
}

// valigáljuk regexek segítségével hogy érvényes gmail vagy yahoo emailcímet adott meg a felhasználó
function validateEmail(passedEmail) {
  const regex1 = /^[a-z0-9](\.?[a-z0-9]){5,}@gmail\.com$/;
  const regex2 = /^[a-z0-9](\.?[a-z0-9]){5,}@yahoo\.com$/;
  if (!(passedEmail.match(regex1) || passedEmail.match(regex2))) {
    validEmail = false;
    document.getElementById('Ermail').style.display = 'block';
  } else {
    validEmail = true;
    document.getElementById('Ermail').style.display = 'none';
  }
  checkFormValid();
}

// valid url-t ad meg a felhasználó
function validateURL(passedURL) {
  const regex = /((http)|(https)):\/\/([A-Za-z0-9_-]{1,}){1,}(\.[A-Za-z0-9_-]*)*\.[A-Za-z]{2,}(\/[A-Za-z0-9_-]{1,})*/;
  if (passedURL.match(regex)) {
    validURL = true;
    document.getElementById('Erurl').style.display = 'none';
  } else {
    validURL = false;
    document.getElementById('Erurl').style.display = 'block';
  }
  checkFormValid();
}

function validateFName() {
  if (!(fn.validity.valid && fn.value != '' && ln.value != null)) {
    document.getElementById('Erfname').style.display = 'block';
  } else {
    document.getElementById('Erfname').style.display = 'none';
  }
  checkFormValid();
}

function validateLName() {
  if (!(ln.validity.valid && ln.value != '' && ln.value != null)) {
    document.getElementById('Erlname').style.display = 'block';
  } else {
    document.getElementById('Erlname').style.display = 'none';
  }
  checkFormValid();
}

// beállítja az oldalon a footer mezöbe az utolsó módosítás dátumát  ;
function insertFooter() {
  document.getElementById('footer').innerHTML = `Last modified:${document.getElementById('footer').innerHTML}${document.lastModified}`;
  document.getElementById('footer').style.textAlign = 'center';
  document.getElementById('footer').style.marginTop = '430px';
}

// submit megnyomása esetén megjelenítjük látható helyen a player adatait , letiltjuk az oldal reloadját , és elindítjuk a játékot .
function onSubmit() {
  let uname,
    bday,
    url,
    mail;
  uname = `${fn.value} ${ln.value}`;
  bday = d.value;
  url = fs.value;
  mail = m.value;
  document.getElementById('data').innerHTML = `<h2>Player Data</h2><p>Username: ${uname}</p><p>Birthday: ${bday}</p><p>Fav site: ${url}</p><p>Email Address: ${mail}</p>`;
  document.getElementById('form').style.display = 'none';
  age = getAge(bday);
  startGame();
  return false;
}

// függvény ami kiszámítja egy megadott dataString esetén hány éves a playerünk
function getAge(dateString) {
  const today = new Date();
  const birthDate = new Date(dateString);
  let age = today.getFullYear() - birthDate.getFullYear();
  const m = today.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  return age;
}

/*----------------------------------------------------------------------------*/
/* Játék függvényei: */
/*----------------------------------------------------------------------------*/

// colors-> legeneralt szinek
let colors = [];
const colorDictionary = []; // --> konvertálja a színkódot emberi nyelvre
let nrOfGuesses = 0;     // minden tipp esetén növeljükk

// kigenerál a 6 szinbol 4-et , és feltölti a szótárat
function generateColors() {
  // piros , sarga , kek , zold , pink , narancs
  const allcolors = new Array('#ff0000', '#ffff00', '#0000cc', '#00ff00', '#ff00ff', '#ffa500');
  colorDictionary['#ff0000'] = 'Red';
  colorDictionary['#ffff00'] = 'Yellow';
  colorDictionary['#0000cc'] = 'Blue';
  colorDictionary['#00ff00'] = 'Green';
  colorDictionary['#ff00ff'] = 'Pink';
  colorDictionary['#ffa500'] = 'Orange';

  const inds = [];
  while (inds.length < 4) {
    const curr = Math.floor(Math.random() * 6);
    if (inds.indexOf(curr) === -1) inds.push(curr);
  }
  return new Array(allcolors[inds[0]], allcolors[inds[1]], allcolors[inds[2]], allcolors[inds[3]]);
}

// kirajzolja 4 színes négzetet a megadott színsorrenddel
function drawRectangles(colorArray) {
  const ctx = document.getElementById('canv').getContext('2d');
  ctx.fillStyle = colorArray[0];
  ctx.fillRect(40, 40, 50, 50);
  ctx.fillStyle =  colorArray[1];
  ctx.fillRect(100, 40, 50, 50);
  ctx.fillStyle = colorArray[2];
  ctx.fillRect(160, 40, 50, 50);
  ctx.fillStyle = colorArray[3];
  ctx.fillRect(220, 40, 50, 50);
}

// a játék divet láthatatlanra állítjuk , és kiírjuk a nyert üzenetet
function playerWon(printableColorArray) {
  const won = document.getElementById('won');
  won.style.display = 'block';
  document.getElementById('game').style.display = 'none';
  if (age > 15) won.innerHTML = `<p> Congratulations , player (age > 15) <br> Correct order of colors: ${printableColorArray} <br>  Number of guesses: ${nrOfGuesses}</p>`;
  else won.innerHTML = `<p> Congratulations , player (age < 15) <br> Correct order of colors: ${printableColorArray} <br>  Number of guesses: ${nrOfGuesses}</p>`;
}

// ha veszit a játékos
function playerLost(printableColorArray) {
  const lost = document.getElementById('lost');
  lost.style.display = 'block';
  document.getElementById('game').style.display = 'none';
  if (age > 15) lost.innerHTML = `<p> Game over , player (age > 15)<br> Correct order of colors: ${printableColorArray}<br>  Number of guesses: ${nrOfGuesses}</p>`;
  else lost.innerHTML = `<p> Game over , player (age < 15)<br> Correct order of colors: ${printableColorArray} <br>  Number of guesses: ${nrOfGuesses}</p>`;
}

// lathatová tesszük a játék panelt , inicializáljuk a színeket és kirajzoljuk egy semleges színnel a négyzeteket .
function startGame() {
  document.getElementById('game').style.display = 'block';
  colors = generateColors();
  // nice ;)
  colorArray = ['#666699', '#666699', '#666699', '#666699'];
  drawRectangles(colorArray);
}

// Tipp kiértékelö függvény . kiírja a tippet , ellenörzi a tippek számát , a játék státuszát ;
// meghívja a canvasra kirajzoló függvényt átadva a tippel színkódokat

function evaluateGuess() {
  let nrgood = 0;
  let nrexact = 0;
  const checkedcolors = [];
  const colorArray = ['#666699', '#666699', '#666699', '#666699'];
  let printableColorArray = [];

  nrOfGuesses += 1;

  for (let no = 1; no <= 4; no++) {
    const c = document.getElementById(`c${no}`).value;
    printableColorArray.push(colorDictionary[c]);
    if (colors.indexOf(c) !== -1 && checkedcolors.indexOf(c) === -1) {
      nrgood++;
      checkedcolors.push(c);
      colorArray[no - 1] = '#000000';
    }

    if (checkedcolors.indexOf(c) !== -1) {
      colorArray[no - 1] = '#000000';
    }

    if (colors.indexOf(c) === no - 1) {
      nrexact++;
      colorArray[no - 1] = '#FFFFFF';
    }
  }

  const canvas = document.getElementById('canv');
  const context = canvas.getContext('2d');
  context.clearRect(0, 0, canvas.width, canvas.height);
  drawRectangles(colorArray);

  if (nrexact == 4) {
    playerWon(printableColorArray);
  }

  if (nrOfGuesses >= 8) {
    printableColorArray = [];
    for (let i = 0; i < 4; i++) {
      printableColorArray.push(colorDictionary[colors[i]]);
    }
    playerLost(printableColorArray);
  }

  // visszaállítja a tippelö mezöket -> be kell tartania a játékosnak a sorrendet , de nagyon sok felesleges lekezelnivalót megúszunk
  document.getElementById('res').innerHTML = `${document.getElementById('res').innerHTML}<br><p>${nrOfGuesses}) ${nrgood} good guesses , ${nrexact} exact guesses : <br>   {${printableColorArray}}</p>`;
  document.getElementById('c1').value = 'def';
  for (let no = 2; no <= 4; no++) {
    document.getElementById(`c${no}`).disabled = true;
    document.getElementById(`c${no}`).value = 'def';
  }
}

// kijelölt négyzetek után megnyílik a rákövetkezö , a 4. kiválasztott szín után meghívja a tippre a kiértékelö függvényt .
function inOrder(element, no) {
  if (no == 4) evaluateGuess();

  if (element.value != 'def' && no != 4) {
    no += 1;
    document.getElementById(`c${no}`).disabled = false;
  }
}

window.addEventListener('load', insertFooter);
