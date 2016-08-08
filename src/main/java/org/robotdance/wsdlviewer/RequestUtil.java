package org.robotdance.wsdlviewer;

import javax.servlet.http.HttpServletRequest;

public abstract class RequestUtil {
	
	public static String getAppServerURL(HttpServletRequest request){
		String requestURL = request.getRequestURL().toString();
		requestURL = requestURL.substring(0, requestURL.lastIndexOf(request.getRequestURI()));
		return requestURL;
	}
	
}
