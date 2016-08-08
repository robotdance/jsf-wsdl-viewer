package org.robotdance.wsdlviewer;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import javax.faces.application.FacesMessage;
import javax.faces.application.FacesMessage.Severity;
import javax.faces.context.FacesContext;

/**
 * Application messages used by objects.
 */
public enum Messages {

	TRANSFORM_ERROR("transform_error"),
    READING_ERROR("reading_error"),
	INVALID_WSDL("invalid_wsdl"), 
	INTERNAL_ERROR("internal_error");	
	
	private static final String BUNDLE_NAME = "wsdlviewer";
	
	private static final String NE = "!!"; //NE = Nao Encontrada(o)

	private String key;
	
	private String message;
	
	/**
	 * Constructor
	 * @param key key in properties file 
	 */
	private Messages(String key) {
		Locale locale = FacesContext.getCurrentInstance().getViewRoot().getLocale();
		try {
			this.key = key;
			this.message = ResourceBundle.getBundle(BUNDLE_NAME, locale).getString(key);
		} catch (MissingResourceException e){
			this.message = NE + key + NE;
		}
	}
	
	/**
	 * Returns the original message value as it is in the properties file
	 * @return String the original message value as it is in the properties file
	 */
	public String toString() {
		return message;
	}
	
	/**
	 * Returns the message with arguments replacing placeholders
	 * Ex:
	 * missing.resource.file = arquivo properties nao encontrado: {0}
	 * {0} will be replaced by args[0] and the result will be returned
	 * @param args A list of objects
	 * @return String formatted string
	 * @throws IllegalArgumentException 
	 */
	public String toString(Object... args) throws IllegalArgumentException {
		return MessageFormat.format(message, args);
	}
	
	/**
	 * Converts to FacesMessage object 
	 * @return object FacesMessage 
	 */
	public FacesMessage toFacesMessage(){
		FacesMessage message = new FacesMessage(toString());
		return message;
	}

	/**
	 * Converts to FacesMessage object
	 * @param severity Severity
	 * @return FacesMessage object
	 */
	public FacesMessage toFacesMessage(Severity severity){
		FacesMessage message = new FacesMessage(toString());
		message.setSeverity(severity);
		return message;
	}
	
	/**
	 * Returns key
	 * @return key
	 */
	public String getChave(){
		return key;
	}

	/**
	 * Add message to faces context
	 * 
	 */
	public void addToFacesContext(){
		FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, toString(), null ));
	}
	
	/**
	 * Add message to faces context
	 * @param severity Severity
	 */
	public void addToFacesContext(Severity severity){
		FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(severity, toString(), toString() ));
	}
	
	/**
	 * Add message to faces context
	 * @param severity Severity
	 * @param args arguments
	 */
	public void addToFacesContext(Severity severity, Object args){
		FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(severity, toString(args), toString(args)));
	}

	/**
	 * Add message to faces context
	 * @param componentID Component ID
	 * @param severity Severity
	 */
	public void addToFacesContext(String componentID, Severity severity){
		FacesContext.getCurrentInstance().addMessage(componentID, new FacesMessage(severity, toString(), toString() ));
	}

	/**
	 * Add message to faces context
	 * @param componentID Component ID
	 * @param severity Severity
	 * @param args arguments
	 */
	public void addToFacesContext(String componentID, Severity severity, Object args){
		FacesContext.getCurrentInstance().addMessage(componentID, new FacesMessage(severity, toString(args), toString(args) ));
	}
}