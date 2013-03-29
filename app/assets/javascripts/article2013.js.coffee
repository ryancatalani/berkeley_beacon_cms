jQuery ->

	if $('body').hasClass('fd')

		if $(window).width() >= 768

			ps = $("#body").find("p")

			$('#mid_share').insertAfter( $(ps)[2] ).show()
			$('#mid_follow').insertAfter( $(ps)[6] ).show()

			$(document).ready ->
				$("#popular_most_viewed").find(".popular-story").each (i) ->
					img = $(this).find("img")[0]
					if img
						if i == 0
							new_src = img.src.replace("thumb_40","thumb_460")
						else
							new_src = img.src.replace("thumb_40","thumb_220")
						$(img).attr("src", new_src)
					else
						$(this).css('height': $(this).css('width'))
						$(this).addClass('no_img')