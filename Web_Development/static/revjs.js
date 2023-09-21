
function validID() {
    if(!document.getElementById('movieid').value.match(/^[0-9]*$/)) {
        document.getElementById('reverror').style.display = 'block';
        return false;
    }
    else {
        document.getElementById('reverror').style.display = 'none';
        return true;
    }
}

function onSubmit() {
   return validID();
}