// Make submit buttons work
$(document).ready(function() {
    $('.submit-link').click(function() {
        $(this).closest('form').submit();
        return false; // Don't follow the link.
    });

    $('.modal-close').click(function() {
        $.modal.close();
    });
});