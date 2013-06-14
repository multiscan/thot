$("#emptybooklist").hide()
thot.scrollTo(jQuery('#booklist').prev())
jQuery("#booklist").prepend($("<%= escape_javascript(render(@loan)) %>").hide().fadeIn(1000))
jQuery('#loan_inv').val("")
