package org.robotdance.wsdlviewer;

public class WsdlRetrieveException extends Exception {

	private static final long serialVersionUID = 1L;

	public WsdlRetrieveException(){ }

	public WsdlRetrieveException(String message)
    {
        super(message);
    }
	
	public WsdlRetrieveException(Throwable cause)
    {
        super(cause);
    }

	public WsdlRetrieveException(String message, Throwable cause)
    {
        super(message, cause);
    }

	public WsdlRetrieveException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace)
    {
        super(message, cause, enableSuppression, writableStackTrace);
    }	
	
}
