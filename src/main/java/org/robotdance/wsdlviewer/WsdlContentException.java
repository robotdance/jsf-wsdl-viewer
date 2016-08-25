package org.robotdance.wsdlviewer;

public class WsdlContentException extends Exception {

	private static final long serialVersionUID = 1L;

	public WsdlContentException(){ }

	public WsdlContentException(String message)
    {
        super(message);
    }
	
	public WsdlContentException(Throwable cause)
    {
        super(cause);
    }

	public WsdlContentException(String message, Throwable cause)
    {
        super(message, cause);
    }

	public WsdlContentException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace)
    {
        super(message, cause, enableSuppression, writableStackTrace);
    }	
	
}
