package org.robotdance.wsdlviewer;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

/**
 * Servlet implementation class WsDoc
 */
@Deprecated
@WebServlet(urlPatterns="/view")
public class WsDoc extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static final String WSDL = "?wsdl"; 
	
	//TODO arrumar isso aqui
	private static final String XSL_PATH = "./wsdl-doc.xsl";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WsDoc() {
        super();        
    }

	/**
	 * Recebe uma requisicao do tipo ?service = url do servico com ou sem wsdl, invoca o servico para retorno do WSDL, e transforma o WSDL usando XSLT 
	 * para gerar o HTML da documentacao automatica
	 * Se a requisição tiver o parametro leigo=true, o WSDL será transformado para um HTML não técnico.
	 * 
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String wsdlResponse = "";
		String serviceParameter = request.getParameter("service");
		String leigoPrameter = request.getParameter("leigo");
		

		try {
			if(serviceParameter != null){			
				response.setCharacterEncoding("UTF-8");
		        response.setContentType("text/html;charset=UTF-8");
				
				if( ! serviceParameter.contains(WSDL)){
					serviceParameter = serviceParameter.concat(WSDL);
				}
				
				updateSession(serviceParameter, request, response);
				
				wsdlResponse = requestWsdl(serviceParameter);
				wsdlResponse = fixReverseProxy(request, wsdlResponse);
				wsdlResponse = transformWsdl(wsdlResponse, leigoPrameter);

		        response.getWriter().append(wsdlResponse);
			}
		} catch (Exception e){
			response.getWriter().append("Servico nao encontrado. Utilizar uma das URLs da pagina inicial.");
		}
	}

	/**
	 * Atualiza sessao com as ultima URL acessada
	 * @param serviceParameter
	 * @param request
	 * @param response
	 */
	private void updateSession(String serviceParameter, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession(true);
		List<String> urls = (List<String>)session.getAttribute("urls");
		if (urls == null){
			urls = new ArrayList<String>();
		}
		if( ! urls.contains(serviceParameter)){
			urls.add(serviceParameter);
		}
		session.setAttribute("urls", urls);
	}

	/**
	 * Transforma o WSDL em HTML, de acordo com arquivo XSLT. Se na URL estiver o parametro estiver com o valor "true"
	 * o xls utilizado para a transformação será o wsdl-leigo-doc.xsl.
	 * Caso contrário será o /wsdl-doc.xsl
	 * @param wsdlResponse
	 * @param leigo String com o valor do parametro leigo
	 * @return
	 * @throws ServletException
	 */
	private String transformWsdl(String wsdlResponse, String leigo) throws ServletException{
		InputStream wsdlInputStream;
		OutputStream transformedWsdl = new ByteArrayOutputStream();
		String xslFileName = "/wsdl-doc.xsl";
		TransformerFactory tFactory = TransformerFactory.newInstance();
		InputStream xslInputStream;
		Transformer transformer;

		try {
			if(Boolean.TRUE.toString().equals(leigo)){
				xslFileName = "/wsdl-leigo-doc.xsl";
			}
			xslInputStream  = this.getClass().getResourceAsStream(xslFileName);
			wsdlInputStream = new ByteArrayInputStream(wsdlResponse.getBytes("UTF-8"));
			transformer = tFactory.newTransformer(new StreamSource(xslInputStream));
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.transform(new StreamSource(wsdlInputStream ), new StreamResult(transformedWsdl));
			return transformedWsdl.toString();

		} catch (UnsupportedEncodingException e) {
			throw new ServletException(e);
		} catch (TransformerConfigurationException e) {
			throw new ServletException(e);
		} catch (TransformerException e) {
			throw new ServletException(e);
		}
	}
	
	/**
	 * Requisita o WSDL do servico
	 * @param serviceURL
	 * @return string com WSDL do servico
	 * @throws ServletException
	 */
	private String requestWsdl(String serviceURL) throws ServletException {
		HttpGet httpGet = new HttpGet(serviceURL);
		HttpClient httpClient = new DefaultHttpClient();
		ResponseHandler<String> responseHandler = new BasicResponseHandler( );
		String wsdlResponse;
		
		try {
			wsdlResponse = httpClient.execute(httpGet, responseHandler);
		} catch (ClientProtocolException e) {
			throw new ServletException(e);
		} catch (IOException e) {
			throw new ServletException(e);
		}
		return wsdlResponse;
	}

	
	/**
	 * Substitui o endereco local do servidor pelo endereco do proxy reverso
	 * @param request
	 * @param wsdlResponse
	 * @return
	 */
	private String fixReverseProxy(HttpServletRequest request, String wsdlResponse) {
		String appServerURL = RequestUtil.getAppServerURL(request);
		// TODO transformar "http://webservices.capesesp.com.br" em property
		// proxy reverso: webservices.capesesp.com.br -> helio:8080
		wsdlResponse = wsdlResponse.replaceAll(appServerURL, "http://webservices.capesesp.com.br"); 
		wsdlResponse = wsdlResponse.replaceAll("http://localhost:8080", "http://webservices.capesesp.com.br");
		wsdlResponse = wsdlResponse.replaceAll("http://helio:8080", "http://webservices.capesesp.com.br");
		return wsdlResponse;
	}
	
	/**
	 * @param wsdlResponse
	 */
	@SuppressWarnings("unused")
	private String addXslReference(String wsdlResponse){
		// adicionando a referencia ao XLST no WSDL gerado
		StringBuffer responseBody = new StringBuffer(wsdlResponse);
        int index = responseBody.indexOf("<wsdl:definitions"); 
        responseBody.insert(index, "<?xml-stylesheet type='text/xsl' href='" + XSL_PATH + "'?>");
        return responseBody.toString();
	}
	
}