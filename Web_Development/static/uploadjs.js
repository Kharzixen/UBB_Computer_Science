function checkGenres(){
    if(!document.getElementById('genres').value.match(/^\s*[a-z0-9-]+(?:\s*[a-z0-9-]+)*\s*$/)){
        document.getElementById('genreserror').style.display = 'block';
        return false;
    }
    else{
        document.getElementById('genreserror').style.display = 'none';
        return true;
    }
}

function validTitle() {
    if(!document.getElementById('title').value.match(/^[A-Z][a-zA-Z0-9', .-]*/)) {
        document.getElementById('titleerror').style.display = 'block';
        return false;
    }
    else {
        document.getElementById('titleerror').style.display = 'none';
        return true;
    }
}

function onSubmit(){
    return validTitle() && checkGenres();
}