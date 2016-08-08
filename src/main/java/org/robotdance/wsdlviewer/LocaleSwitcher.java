package org.robotdance.wsdlviewer;

import java.util.Locale;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;

@ManagedBean
@SessionScoped
public class LocaleSwitcher {
    private Locale locale = FacesContext.getCurrentInstance().getViewRoot().getLocale();
    
    public String change(String lang, String country) {
        setLocale(new Locale(lang, country));
        return FacesContext.getCurrentInstance().getViewRoot().getViewId() + "?faces-redirect=true";
    }

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}
}