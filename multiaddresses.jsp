<script type="text/javascript">
var address = '${namedDetail[0]["address"]}, ${namedDetail[0]["city"]}, ${namedDetail[0]["state"]} ${namedDetail[0]["zipcode"]}';
//OR address = "Street Address, City, State, Zip Code";

if (address != '') {
	address = address.replace(/\s/g, '%20');
}
var gmapurl= "https://maps.google.com/maps/api/geocode/json?address="+address+"&sensor=false";
$.getJSON(gmapurl, function(latlong){
	if(jQuery.isEmptyObject(latlong.results) == false){
		var lat = latlong.results[0].geometry.location.lat;
		var lng = latlong.results[0].geometry.location.lng;
		var statelong = latlong.results[0].address_components[4].long_name;
		var jsonurl = "http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lng+"&APPID=**********************";
		var jsonobj = {"action":"getWeatherObject","targetURL":jsonurl};
		jQuery.ajax('./getweather', {'type' : 'POST', 'data' : jsonobj, 'success' : function(data) {
					if(jQuery.isEmptyObject(data) == false){
						   var day = $.datepicker.formatDate("MM dd, yy", new Date());
						   var condition = data.weather[0].main;
						   var description = data.weather[0].description;	
						   var icon = data.weather[0].icon;
						   var temp = data.main.temp;
						   var ftemp= Math.round((temp*9)/5 - 459.67);
						   var markup='<div class="weather"><table><tbody style="text-align: center;"><tr><td style="width: 85px;"><img src="http://api.openweathermap.org/img/w/'+icon+
						   '.png" style="height: 65px;"/></td><td><b><p style="font-size: 14px;color:#d31f45;">${namedDetail[0]["city"]}, ${namedDetail[0]["state"]}</p></b><p class="cond">'+ condition +
						   '</p><img src="${applicationScope.contextURL}/rsrc/images/weathericons/therm.png" style="vertical-align: middle;"/><b><span style="vertical-align: middle;font-size: 25px;">'+ ftemp +
						   '&deg;</span></b></td></tr></tbody></table></div>';
						   
						$('#weatherSideWidget').html(markup);
					}else{
						console.log("Error retrieving weather data!");
					}
				}
				}).error(function(){
			        showError("Your browser does not support geolocation requests!");
			    });
	}
});
</script>