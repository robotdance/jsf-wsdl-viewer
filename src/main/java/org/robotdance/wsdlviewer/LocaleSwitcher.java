package org.robotdance.wsdlviewer;

import java.io.Serializable;
import java.util.Locale;

import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;

@ManagedBean
@SessionScoped
public class LocaleSwitcher implements Serializable {

  private static final long serialVersionUID = 385950061416176524L;
  
  private Locale locale;
    
  @PostConstruct
  public void init() {
      locale = stripLocale(FacesContext.getCurrentInstance().getExternalContext().getRequestLocale());
  }    
  
  public String change(String lang) {
      setLocale(new Locale(lang));
      return FacesContext.getCurrentInstance().getViewRoot().getViewId() + "?faces-redirect=true";
  }

	public Locale getLocale() {
		return locale;
	}

  public Locale getSimplifiedLocale() {
    locale = stripLocale(locale);
    return locale;
  }
	
	public void setLocale(Locale locale) {
		this.locale = locale;
	}
	
	private Locale stripLocale(Locale locale) {
	  return new Locale(locale.getLanguage());
	}
	
}