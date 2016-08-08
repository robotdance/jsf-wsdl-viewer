package org.robotdance.wsdlviewer;

public class WsdlTransformException extends Exception {

	private static final long serialVersionUID = 1L;

	public WsdlTransformException(){ }

	public WsdlTransformException(String message)
    {
        super(message);
    }
	
	public WsdlTransformException(Throwable cause)
    {
        super(cause);
    }

	public WsdlTransformException(String message, Throwable cause)
    {
        super(message, cause);
    }

	public WsdlTransformException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace)
    {
        super(message, cause, enableSuppression, writableStackTrace);
    }	
	
}
