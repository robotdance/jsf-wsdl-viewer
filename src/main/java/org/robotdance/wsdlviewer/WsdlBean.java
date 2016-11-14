package org.robotdance.wsdlviewer;

import java.io.Serializable;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Locale;
import java.util.Map;

import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

@ManagedBean
@SessionScoped
public class WsdlBean implements Serializable {
	
  private static final long serialVersionUID = -5697334784311144787L;

  private static final String OUTCOME_INDEX = "index";

	private static final String OUTCOME_WSDL = "wsdl";

	private Part file;
	
	private String wsdlContent;
	
	private String wsdlUrl;
	
	private String transformedWsdl;
	
	private String example;
	
	private Map<String, String> getRequest() {
		return FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();		
	}
	
	private Locale getLocale() {
	  Locale locale = new Locale(FacesContext.getCurrentInstance().getViewRoot().getLocale().getLanguage());
		return locale;
	}
	
	public String typeWsdl() {
		return transformByUrl(wsdlUrl);
	}

	public String transformByUrl(String url) {
		try {
			wsdlContent = WsdlContent.fromUrl(new URL(url));
			transformedWsdl = WsdlTransformer.getInstance().transform(wsdlContent, getLocale());
			return OUTCOME_WSDL;
			
		} catch (WsdlTransformException e) {
			Messages.TRANSFORM_ERROR.addToFacesContext("wsdl:url", FacesMessage.SEVERITY_ERROR);
			
		} catch (WsdlContentException e) {
			Messages.READING_ERROR.addToFacesContext("wsdl:url", FacesMessage.SEVERITY_ERROR);
			
		} catch (MalformedURLException e) {
			Messages.READING_ERROR.addToFacesContext("wsdl:url", FacesMessage.SEVERITY_ERROR);
		}
		return OUTCOME_INDEX;
	}
	
	public String upload() {
		try {
			wsdlContent = WsdlContent.fromFile(file);
			transformedWsdl = WsdlTransformer.getInstance().transform(wsdlContent, getLocale());
			return OUTCOME_WSDL;
			
		} catch (NullPointerException e) {
			Messages.READING_ERROR.addToFacesContext("upload:file", FacesMessage.SEVERITY_ERROR);

		} catch (WsdlContentException e) {
			Messages.READING_ERROR.addToFacesContext(FacesMessage.SEVERITY_ERROR);
			
		} catch (WsdlTransformException e) {
			Messages.TRANSFORM_ERROR.addToFacesContext(FacesMessage.SEVERITY_ERROR);
		}
		return OUTCOME_INDEX;
	}
	
	public String example() {
		try {
			wsdlContent = WsdlContent.fromExample(getRequest().get("example"));
			transformedWsdl = WsdlTransformer.getInstance().transform(wsdlContent, getLocale());
			return OUTCOME_WSDL;

		} catch (WsdlTransformException e) {
			Messages.INTERNAL_ERROR.addToFacesContext(FacesMessage.SEVERITY_FATAL);
			
		}
		return OUTCOME_INDEX;
	}
	
	public String getAppServerURL(){
		return RequestUtil.getAppServerURL((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest());
	}

	public String getTransformedWsdl() {
		String url = getRequest().get("url");
		if(url != null) {
			transformByUrl(url);
		}
		return transformedWsdl;
	}

	public void setTransformedWsdl(String transformedWsdl) {
		this.transformedWsdl = transformedWsdl;
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

	public String getExampleName() {
		return example;
	}

	public void setExampleName(String exampleName) {
		this.example = exampleName;
	}
	
}
