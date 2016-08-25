package org.robotdance.wsdlviewer;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Scanner;

import javax.servlet.http.Part;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;

public class WsdlContent {

	public static String fromFile(Part file) throws WsdlContentException
	{
		try {
			String wsdlContent;
			Scanner scanner;
			scanner = new Scanner(file.getInputStream());
			scanner.useDelimiter("\\A");
			wsdlContent = scanner.next(); 
			scanner.close();
			return wsdlContent;
		} catch (IOException e) {
			throw new WsdlContentException(e);
		}
	}
	
	public static String fromExample(String example)
	{
		String wsdlContent;
		InputStream is = WsdlTransformer.class.getResourceAsStream(example);
		Scanner scanner = new Scanner(is);
		scanner.useDelimiter("\\A");
		wsdlContent = scanner.next();
		scanner.close();
		return wsdlContent;
	}
	
	public static String fromUrl(URL url) throws WsdlContentException
	{
		try {
			HttpGet httpGet = new HttpGet(url.toExternalForm());
			HttpClient httpClient = HttpClientBuilder.create().build();
			ResponseHandler<String> responseHandler = new BasicResponseHandler( );
			String wsdlResponse;
			wsdlResponse = httpClient.execute(httpGet, responseHandler);
			return wsdlResponse;
			
		} catch (ClientProtocolException e) {
			throw new WsdlContentException(e);
			
		} catch (IOException e) {
			throw new WsdlContentException(e);
		}
	}
}
