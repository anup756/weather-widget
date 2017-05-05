# Weather Widget
This is a tiny weather widget to use in your website or app using javascript (and java)

For this example we will be using IPInfoDB IP service to get client ip and convert it into an actual address. Then we will call OpenWeatherMap API to get the weather data and show it in our web app.

For some browsers, due to cross-origin (http requests from https) errors, requests will not able to be submitted. The easy solution for this is to channel all the requests through the server. To avoid cross-origin issues, I have a servlet (GetWeatherServlet) that does the api request and sends the response to the client.

![alt text](https://raw.githubusercontent.com/anup756/weather-widget/master/icons/weather.png)
