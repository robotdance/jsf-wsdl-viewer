package org.robotdance.wsdlviewer;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;

/**
 * Transforms WSDL in HTML using XSLT
 */
public class WsdlTransformer  {

	class ClasspathResourceURIResolver implements URIResolver {
		  @Override
		  public Source resolve(String href, String base) throws TransformerException {
		    return new StreamSource(this.getClass().getResourceAsStream(href));
		  }
	}
	
	
	private static WsdlTransformer instance;
	
	/**
	 * Transforms WSDL in HTML using XSLT
	 * @param wsdlContent
	 * @return String with HTML content
	 * @throws ServletException
	 */
	
	public static WsdlTransformer getInstance() {
		if(instance == null) {
			instance = new WsdlTransformer();
		}
		return instance;
	}
	
	public String transform(String wsdlContent, Locale locale) throws WsdlTransformException {

		try {
			InputStream xsltInputStream;
			Transformer transformer;
			StreamSource streamSource, transformerSource;
			StreamResult streamResult;
			
			InputStream wsdlInputStream;
			OutputStream transformedWsdl = new ByteArrayOutputStream();
			TransformerFactory transformerFactory = TransformerFactory.newInstance();

			String xsltFile = "/wsdlviewer.xsl";
			ClassLoader classLoader = this.getClass().getClassLoader();
			URL xsltUrl = classLoader.getResource(xsltFile);
			
			xsltInputStream = this.getClass().getResourceAsStream(xsltFile);
			wsdlInputStream = new ByteArrayInputStream(wsdlContent.getBytes("UTF-8"));

			transformerSource = new StreamSource(xsltInputStream);
			transformerSource.setSystemId(xsltUrl.toExternalForm());

			streamSource = new StreamSource(wsdlInputStream);
			streamResult = new StreamResult(transformedWsdl);
			
			transformer = transformerFactory.newTransformer(transformerSource);
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setParameter("locale", locale.toString());
			transformer.transform(streamSource, streamResult);
			return transformedWsdl.toString();	

		} catch (UnsupportedEncodingException e) {
			throw new WsdlTransformException(e);
			
		} catch (TransformerConfigurationException e) {
			throw new WsdlTransformException(e);
			
		} catch (TransformerException e) {
			throw new WsdlTransformException(e);
		}
	}
	
	/**
	 * Gets the WSDL contents
	 * @param serviceURL
	 * @return String with WSDL contents
	 * @throws ServletException
	 */
	public String retrieve(String serviceURL) throws WsdlRetrieveException {
		try {
			HttpGet httpGet = new HttpGet(serviceURL);
			HttpClient httpClient = HttpClientBuilder.create().build();
			ResponseHandler<String> responseHandler = new BasicResponseHandler( );
			String wsdlResponse;
			wsdlResponse = httpClient.execute(httpGet, responseHandler);
			return wsdlResponse;
			
		} catch (ClientProtocolException e) {
			throw new WsdlRetrieveException(e);
			
		} catch (IOException e) {
			throw new WsdlRetrieveException(e);
		}
	}
	
}