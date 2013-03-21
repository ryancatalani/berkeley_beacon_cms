jQuery ->

	if $('body').hasClass('fd')

		if $(window).width() >= 768

			ps = $("#body").find("p")

			$('#mid_share').insertAfter( $(ps)[2] ).show()
			$('#mid_follow').insertAfter( $(ps)[6] ).show()

			$(document).ready ->
				$("#popular").find("img").each (i) ->
					if i == 0
						new_src = this.src.replace("thumb_40","thumb_460")
					else
						new_src = this.src.replace("thumb_40","thumb_220")
					$(this).attr("src", new_src)