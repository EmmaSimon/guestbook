function validate_form(evt)
{
    evt = evt || window.event;
    var name = document.forms["entry"]["name"].value;
    var email = document.forms["entry"]["email"].value;
    var comment = document.forms["entry"]["comment"].value;

    if ((name == null || name == "") && (email == null || email == "") && (comment == null || comment == "")) {
        alert("Sorry, you need to fill out the form before submitting!");
        evt.preventDefault();
    } else if ((name == null || name == "") && (email == null || email == "")) {
        alert("Please provide a name and email address.");
        evt.preventDefault();
    } else if ((name == null || name == "") && (comment == null || comment == "")) {
        alert("Please provide a name and comment.");
        evt.preventDefault();
    } else if ((email == null || email == "") && (comment == null || comment == "")) {
        alert("Please provide a comment and email address.");
        evt.preventDefault();
    } else if (name == null || name == "") {
        alert("Please provide a name.");
        evt.preventDefault();
    } else if (email == null || email == "") {
        alert("Please provide an email address.");
        evt.preventDefault();
    } else if (comment == null || comment == "") {
        alert("Please provide a comment.");
        evt.preventDefault();
    } else if (!check_email(email)) {
        alert("Sorry, that doesn't look like a valid email address.");
        evt.preventDefault();
    } 
}

function check_email(email) {
    if (email.length > 254) {
        return false;
    } else {
        var email_regex = /[a-z0-9]+(?:\.[a-z0-9]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i;
        return email_regex.test(email);
        return true;
    }
}