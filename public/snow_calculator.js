$(function(){
	var monday_snow_days = 2;
	var monday_after_snow_days = 1;
	var tuesday_snow_days = 2;
	var wednesday_snow_days = 1;

	var credit_cost = 1145.0; // http://www.emerson.edu/admission/graduate-admission/tuition-expenses/tuition-cost
	var credit_hours = 15.0; // 1 credit hour per semester is 15 weeks of classroom instruction; http://www.emerson.edu/policy/credit-hour-definition
	var credit_cost_per_hour = credit_cost / credit_hours;
	var credit_cost_per_hour_big = new Big(credit_cost_per_hour);

	var total_cost = 0;

	var total_hours = function() {

		var hour_inputs = [
		$('#monday'),
		$('#monday_after'),
		$('#tuesday'),
		$('#wednesday')
		];
		var hour_inputs_counts = [
		monday_snow_days,
		monday_after_snow_days,
		tuesday_snow_days,
		wednesday_snow_days
		];
		var sum = 0;

		$.each(hour_inputs, function(index, el) {
			if (el.val().length == 0) {
				sum += 0;
			} else if (el.val().indexOf(":") != -1) {
				var arr = el.val().split(":");
				var hh = parseInt(arr[0]);
				var mm = parseInt(arr[1]);
				var mm_dec = mm / 60.0;
				sum += (hh + mm_dec) * hour_inputs_counts[index];
			} else {
				sum += parseFloat(el.val()) * hour_inputs_counts[index];
			}
		});

		return sum;
	};

	var calculate_cost = function(hours) {			
		var hours_big = new Big(hours);
		var rounded = hours_big.times(credit_cost_per_hour_big).round(2, 1).toFixed(2);

		update_total_text(rounded);
		total_cost = rounded;
		update_share_links();

		return rounded;
	};

	var update_total_text = function(total) {
		$('.updatable_cost').each(function(){
			$(this).text(total);
		});
	};

	var update_day_count = function() {
		var numbers = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
		$('.updatable_mondays').each(function() {
			if (monday_snow_days < 10) {
				$(this).text(numbers[monday_snow_days]);	
			} else {
				$(this).text(monday_snow_days);
			}
		});
		$('.updatable_mondays_after').each(function() {
			if (monday_after_snow_days < 10) {
				$(this).text(numbers[monday_after_snow_days]);	
			} else {
				$(this).text(monday_after_snow_days);
			}
		});
		$('.updatable_tuesdays').each(function() {
			if (tuesday_snow_days < 10) {
				$(this).text(numbers[tuesday_snow_days]);
			} else {
				$(this).text(tuesday_snow_days);
			}
		});
		$('.updatable_wednesdays').each(function() {
			if (wednesday_snow_days < 10) {
				$(this).text(numbers[wednesday_snow_days]);
			} else {
				$(this).text(wednesday_snow_days);
			}
		});
	}

	var update_share_links = function() {
		var twt_text = "My canceled classes at @EmersonCollege are worth $" + Math.ceil(total_cost) + ". " + window.location.toString() + " via @BeaconUpdate";
		var encoded_twt_text = encodeURIComponent(twt_text);
		var twt_link = "https://twitter.com/intent/tweet?&text=" + encoded_twt_text;
		$(".twitter_link").each(function(){
			$(this).attr('href', twt_link);
		});

		var fb_link = "https://www.facebook.com/dialog/feed?app_id=128499383927655&display=popup&caption=See%20how%20much%20your%20canceled%20classes%20at%20Emerson%20are%20worth.&description=An%20interactive%20feature%20by%20The%20Berkeley%20Beacon.&link=http%3A%2F%2Fwww.berkeleybeacon.com%2Fprojects%2Fsnow_calculator&picture=https%3A%2F%2Fs3.amazonaws.com%2FBerkeleyBeacon%2Fbeacon_uploads%2Fuploads%2F1423126348-Snowstorm_Bushell_01272015_0021.jpg.jpg&redirect_uri=http://www.berkeleybeacon.com/projects/snow_calculator&name=";
		var fb_results = "My canceled classes are worth $" + Math.ceil(total_cost);
		var fb_results_encoded = encodeURIComponent(fb_results);
		var fb_final_link = fb_link + fb_results_encoded;
		$(".facebook_link").each(function(){
			$(this).attr('href', fb_final_link);
		});
	}

	$('input').on('keyup', function(){
		calculate_cost(total_hours());
	});

	update_day_count();

});