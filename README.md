# jsf-wsdl-viewer

A web application that generates a friendly document for WSDL web services.

[A demo can be seen here](https://webservices.capesesp.com.br/docs)

## History

It was 2010. I was working on a systems integration project heavily focused on SOAP Web services. Me and my team were responsible for the design of endpoints and integration mechanisms between a host of third party applications, most of them without any exposed interface. We started developing fast bottom-up web services in java, in order to provide WSDLs and some functional prototypes.  Soon we realized that was necessary to discuss the service interface with these third party companies, and our WSDLs needed to be readable and more documented as well. So we switched to top-down design, and started researching tools to "humanize" a good WSDL. Then we found Tomi Vanek work, and we decided to continue his work in a slightly different manner. And so our wsdl viewer had born. Now, after so many years, i came back to the same company, and the application is still necessary, mostly because the integration layer of these applications is solely made by SOAP services. So i  updated this application to live a couple more years. In the meantime, if possible, i plan to migrate it to another technology, of course if i have time. My apologies about testing, coverage and other quality stuff, currently I am more convinced of migrating it instead of providing the so necessary tests.

## Contribute

If you want to contribute in Java, help writing tests first.

If you want to contribute in another language, consider migrating it to Ruby/Rails. I only ask to keep it under robotdance umbrella.
