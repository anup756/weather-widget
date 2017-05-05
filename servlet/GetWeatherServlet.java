package weather.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;
import org.json.JSONObject;


public class GetWeatherServlet extends HttpServlet{
    private static final int REQUEST_TIMEOUT = 20000;
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        
        String action = req.getParameter("action");
        if("getWeatherObject".equals(action)) {
            String targetURL = req.getParameter("targetURL");
            PostMethod postAPI = new PostMethod(targetURL);
            HttpClient httpclient = new HttpClient();
            httpclient.getParams().setSoTimeout(REQUEST_TIMEOUT);
            int apiCode = httpclient.executeMethod(postAPI);
            String response = postAPI.getResponseBodyAsString();
            if (apiCode == HttpStatus.SC_OK) {
                JSONObject rObject = new JSONObject(response);
                Util.writeResponse(req, resp, 200, rObject);
                return;
                }else{
                JSONObject rObject = new JSONObject("");
                Util.writeResponse(req, resp, 200, rObject);
            }
        }
    }
}
