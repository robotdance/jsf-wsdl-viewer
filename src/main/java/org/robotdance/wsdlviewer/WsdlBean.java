package org.robotdance.wsdlviewer;

import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.Scanner;

import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

@ManagedBean
@SessionScoped
public class WsdlBean {
	
	private Part file;
	
	private String wsdlContent;
	
	private String wsdlUrl;
	
	private String transformedWsdl;
	
	private String exampleName;

	public String typeWsdl() {
		try {
			Locale locale = FacesContext.getCurrentInstance().getViewRoot().getLocale();
			wsdlContent = WsdlTransformer.getInstance().retrieve(wsdlUrl);
			transformedWsdl = WsdlTransformer.getInstance().transform(wsdlContent, locale);
			return "success";
			
		} catch (WsdlTransformException e) {
			Messages.TRANSFORM_ERROR.addToFacesContext("wsdl:url", FacesMessage.SEVERITY_ERROR);
			return "error";
			
		} catch (WsdlRetrieveException e) {
			Messages.READING_ERROR.addToFacesContext("wsdl:url", FacesMessage.SEVERITY_ERROR);
			return "error";
		}
	}
	
	public String upload() {
		try {
			Locale locale = FacesContext.getCurrentInstance().getViewRoot().getLocale();
			Scanner scanner = new Scanner(file.getInputStream());
			scanner.useDelimiter("\\A");
			wsdlContent = scanner.next();
			transformedWsdl = WsdlTransformer.getInstance().transform(wsdlContent, locale);
			scanner.close();
			return "success";
			
		} catch (NullPointerException e) {
			Messages.READING_ERROR.addToFacesContext("upload:file", FacesMessage.SEVERITY_ERROR);
			return "error";
			
		} catch (IOException e) {
			Messages.READING_ERROR.addToFacesContext(FacesMessage.SEVERITY_ERROR);
			return "error";
			
		} catch (WsdlTransformException e) {
			Messages.TRANSFORM_ERROR.addToFacesContext(FacesMessage.SEVERITY_ERROR);
			return "error";
		}
	}
	
	public String example() {
		try {
			exampleName = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("exampleName");
			Locale locale = FacesContext.getCurrentInstance().getViewRoot().getLocale();
			InputStream is = WsdlTransformer.class.getResourceAsStream(exampleName);
			Scanner scanner = new Scanner(is);
			scanner.useDelimiter("\\A");
			wsdlContent = scanner.next();
			transformedWsdl = WsdlTransformer.getInstance().transform(wsdlContent, locale);
			scanner.close();
		} catch (WsdlTransformException e) {
			Messages.INTERNAL_ERROR.addToFacesContext(FacesMessage.SEVERITY_FATAL);
		}
		return "success";
	}
	
	/**
	 * Retorna URL absoluta do app server
	 * @return
	 */
	public String getAppServerURL(){
		return RequestUtil.getAppServerURL((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest());
	}
	
	public Part getFile() {
		return file;
	}

	public void setFile(Part file) {
		this.file = file;
	}
	

    public String getFileContent() {
        return wsdlContent;
    }

	public String getWsdlUrl() {
		return wsdlUrl;
	}

	public void setWsdlUrl(String wsdlUrl) {
		this.wsdlUrl = wsdlUrl;
	}

	public String getTransformedWsdl() {
		return transformedWsdl;
	}

	public void setTransformedWsdl(String transformedWsdl) {
		this.transformedWsdl = transformedWsdl;
	}

	public String getExampleName() {
		return exampleName;
	}

	public void setExampleName(String exampleName) {
		this.exampleName = exampleName;
	}
	
}
