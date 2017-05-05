<script type="text/javascript">
function geolocate(timezone, cityPrecision, objectVar) {
 //Bug reports : http://forum.ipinfodb.com/viewforum.php?f=7
  var api = (cityPrecision) ? "ip-city" : "ip-country";
  var domain = 'api.ipinfodb.com';
  var url = "https://" + domain + "/v3/" + api + "/?key=************************&format=json" + "&callback=" + objectVar + ".setGeoCookie";
  var geodata;
  var callbackFunc;
  var JSON = JSON || {};
  // implement JSON.stringify serialization
  JSON.stringify = JSON.stringify || function (obj) {
    var t = typeof (obj);
    if (t != "object" || obj === null) {
      // simple data type
      if (t == "string") obj = '"'+obj+'"';
        return String(obj);
    } else {
    // recurse array or object
      var n, v, json = [], arr = (obj && obj.constructor == Array);
      for (n in obj) {
        v = obj[n]; t = typeof(v);
        if (t == "string") v = '"'+v+'"';
        else if (t == "object" && v !== null) v = JSON.stringify(v);
        json.push((arr ? "" : '"' + n + '":') + String(v));
      }
      return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
    }
  };
 
  // implement JSON.parse de-serialization
  JSON.parse = JSON.parse || function (str) {
    if (str === "") str = '""';
      eval("var p=" + str + ";");
      return p;
  };
 
  //Check if cookie already exist. If not, query IPInfoDB
  this.checkcookie = function(callback) {
    geolocationCookie = getCookie('geolocation');
    callbackFunc = callback;
    if (!geolocationCookie) {
      getGeolocation();
    } else {
      geodata = JSON.parse(geolocationCookie);
      callbackFunc();
    }
  }
 
  //API callback function that sets the cookie with the serialized JSON answer
  this.setGeoCookie = function(answer) {
    if (answer['statusCode'] == 'OK') {
      JSONString = JSON.stringify(answer);
      setCookie('geolocation', JSONString, 365);
      geodata = answer;
      callbackFunc();
    }
  }
 
  //Return a geolocation field
  this.getField = function(field) {
    try {
      return geodata[field];
    } catch(err) {}
  }
 
  //Request to IPInfoDB
  function getGeolocation() {
    try {
      script = document.createElement('script');
      script.src = url;
      document.body.appendChild(script);
    } catch(err) {}
  }
 
  //Set the cookie
  function setCookie(c_name, value, expire) {
    var exdate=new Date();
    exdate.setDate(exdate.getDate()+expire);
    document.cookie = c_name+ "=" +escape(value) + ((expire==null) ? "" : ";expires="+exdate.toGMTString());
  }
 
  //Get the cookie content
  function getCookie(c_name) {
    if (document.cookie.length > 0 ) {
      c_start=document.cookie.indexOf(c_name + "=");
      if (c_start != -1){
        c_start=c_start + c_name.length+1;
        c_end=document.cookie.indexOf(";",c_start);
        if (c_end == -1) {
          c_end=document.cookie.length;
        }
        return unescape(document.cookie.substring(c_start,c_end));
      }
    }
    return '';
  }
}
//function geolocate(timezone, cityPrecision, objectVar).
//If you rename your object name, you must rename 'visitorGeolocation' in the function
var visitorGeolocation = new geolocate(false, true, 'visitorGeolocation');
 
//Check for cookie and run a callback function to execute after geolocation is read either from cookie or IPInfoDB API
var callback = function(){
                //alert('Visitor zip code : ' + visitorGeolocation.getField('zipCode'))
               };
visitorGeolocation.checkcookie(callback);
$(document).ready(function(event){
	var jsonurl = "http://api.openweathermap.org/data/2.5/weather?lat="+ visitorGeolocation.getField('latitude')+"&lon="+visitorGeolocation.getField('longitude')+"&APPID=******************";
	var jsonobj = {"action":"getWeatherObject","targetURL":jsonurl};
	var cityName= visitorGeolocation.getField('cityName');
	var regionName= visitorGeolocation.getField('regionName');
	jQuery.ajax('./getweather', {'type' : 'POST', 'data' : jsonobj, 'success' : function(data) {
		if((jQuery.isEmptyObject(data) == false) || (data != "")){
			if (typeof cityName !== "undefined") {
			   var day = $.datepicker.formatDate("MM dd, yy", new Date());
			   var condition = data.weather[0].main;
			   var description = data.weather[0].description;
			   var icon = data.weather[0].icon;
			   var temp = data.main.temp;
			   var ftemp= Math.round((temp*9)/5 - 459.67);
			   var markup=
				'<div class="weather"><b><p style="color:#d31f45;">'+ cityName+', '+ regionName +
				'</p></b><p class="cond"><img src="http://openweathermap.org/img/w/'+ icon +'.png" height="50px" style="vertical-align: middle;height:35px"/><img src="${applicationScope.contextURL}/rsrc/images/weathericons/therm.png" style="vertical-align: middle;height:21px;"/> <b><span style="vertical-align: middle;">'+ ftemp + 
				'&deg;</span></b></p><p><b>'+ condition +
				'</b></p></div>';
			$('#weatherWidget').html(markup);
			}
		}else{
			console.log("Error retrieving weather data!");
		}
	}
	}).error(function(){
        showError("Your browser does not support CORS requests!");
    });
});
</script>