<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:ws="http://schemas.xmlsoap.org/wsdl/"
	xmlns:ws2="http://www.w3.org/ns/wsdl" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" 
	xmlns:local="http://tomi.vanek.sk/xml/wsdl-viewer"
	version="1.0"
	exclude-result-prefixes="ws ws2 xsd soap local">

	<xsl:param name="locale" select="'pt'" />
	
	<xsl:variable name="i18n" select="document('i18n.xml')/i18n/language[@lang=$locale]" />

	<xsl:output method="html" 
	    version="1.0"
	    encoding="utf-8"
		indent="yes"
		omit-xml-declaration="yes" 
		media-type="text/html" />

	<xsl:strip-space elements="*" />

	<xsl:param name="wsdl-viewer.version">3.1.01</xsl:param>
	
	<xsl:param name="ENABLE-SERVICE-PARAGRAPH" select="true()" />
	<xsl:param name="ENABLE-OPERATIONS-PARAGRAPH" select="true()" />
	<xsl:param name="ENABLE-SRC-CODE-PARAGRAPH" select="true()" />
	<xsl:param name="ENABLE-OPERATIONS-TYPE" select="true()" />
	<xsl:param name="ENABLE-LINK" select="true()" />
	<xsl:param name="ENABLE-INOUTFAULT" select="true()" />
	<xsl:param name="ENABLE-STYLEOPTYPEPATH" select="true()" />
	<xsl:param name="ENABLE-DESCRIPTION" select="true()" />
	<xsl:param name="ENABLE-PORTTYPE-NAME" select="true()" />
	<xsl:param name="ENABLE-ANTIRECURSION-PROTECTION" select="true()" />
	<xsl:param name="ANTIRECURSION-DEPTH">
		3
	</xsl:param>
	
	<xsl:variable name="GENERATED-BY">
		<xsl:value-of select="$i18n/generated-by"/>
	</xsl:variable>
	
	<xsl:variable name="PORT-TYPE-TEXT">
		<xsl:value-of select="$i18n/port-type"/>
	</xsl:variable>
	
	<xsl:variable name="IFACE-TEXT">
		<xsl:value-of select="$i18n/iface"/>
	</xsl:variable>
	
	<xsl:variable name="SOURCE-CODE-TEXT">
		<xsl:value-of select="$i18n/source-code"/>
	</xsl:variable>
	
	<xsl:variable name="RECURSIVE">
		<xsl:value-of select="$i18n/recursive"/>
	</xsl:variable>
	
	<xsl:variable name="SRC-PREFIX">
		<xsl:value-of select="$i18n/src-prefix"/>
	</xsl:variable>
	
	<xsl:variable name="SRC-FILE-PREFIX">
		<xsl:value-of select="$i18n/src-file-prefix"/>
	</xsl:variable>
	
	<xsl:variable name="OPERATIONS-PREFIX">
		<xsl:value-of select="$i18n/operations-prefix"/>
	</xsl:variable>
	
	<xsl:variable name="PORT-PREFIX">
		<xsl:value-of select="$i18n/port-prefix"/>
	</xsl:variable>
	
	<xsl:variable name="IFACE-PREFIX">
		<xsl:value-of select="$i18n/iface-prefix"/>
	</xsl:variable>
	
	<xsl:variable name="global.wsdl-name" select="/*/*[(local-name() = 'import' or local-name() = 'include') and @location][1]/@location" />
	<xsl:variable name="consolidated-wsdl" select="/* | document($global.wsdl-name)/*" />
	<xsl:variable name="global.xsd-name" select="($consolidated-wsdl/*[local-name() = 'types']//xsd:import[@schemaLocation] | $consolidated-wsdl/*[local-name() = 'types']//xsd:include[@schemaLocation])[1]/@schemaLocation" />
	<xsl:variable name="consolidated-xsd" select="(document($global.xsd-name)/xsd:schema/xsd:*|/*/*[local-name() = 'types']/xsd:schema/xsd:*)[local-name() = 'complexType' or local-name() = 'element' or local-name() = 'simpleType']" />
	<xsl:variable name="global.service-name" select="concat($consolidated-wsdl/ws:service/@name, $consolidated-wsdl/ws2:service/@name)" />
	<xsl:variable name="global.binding-name" select="concat($consolidated-wsdl/ws:binding/@name, $consolidated-wsdl/ws2:binding/@name)" />
	<xsl:variable name="html-title">
		<xsl:apply-templates select="/*" mode="html-title.render" />
	</xsl:variable>

	<xsl:template match="*" mode="copy">
	  <xsl:element name="{name()}" namespace="{namespace-uri()}">
	    <xsl:apply-templates select="@*|node()" mode="copy" />
	  </xsl:element>
	</xsl:template>

	<xsl:template match="@*|text()|comment()" mode="copy">
	  <xsl:copy/>
	</xsl:template>

	<xsl:template match="@*" mode="qname.normalized">
		<xsl:variable name="local" select="substring-after(., ':')" />
		<xsl:choose>
			<xsl:when test="$local">
				<xsl:value-of select="$local" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ws:definitions | ws2:description" mode="html-title.render">
		<xsl:choose>
			<xsl:when test="$global.service-name">
				<xsl:value-of select="concat('Web Service: ', $global.service-name)" />
			</xsl:when>
			<xsl:when test="$global.binding-name">
				<xsl:value-of select="concat('WS Binding: ', $global.binding-name)" />
			</xsl:when>
			<xsl:when test="ws2:interface/@name">
				<xsl:value-of select="concat('WS Interface: ', ws2:interface/@name)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$i18n/web-service-fragment"/>
			</xsl:otherwise>
			<!-- <xsl:otherwise><xsl:message terminate="yes">Syntax error in element 
				<xsl:call-template name="src.syntax-error.path"/></xsl:message></xsl:otherwise> -->
		</xsl:choose>
	</xsl:template>

	<xsl:template name="src.syntax-error">
		<xsl:message terminate="yes">
			<xsl:value-of select="$i18n/syntax-error"/>
			<xsl:call-template name="src.syntax-error.path" />
		</xsl:message>
	</xsl:template>

	<xsl:template name="src.syntax-error.path">
		<xsl:for-each select="parent::*">
			<xsl:call-template name="src.syntax-error.path" />
		</xsl:for-each>
		<xsl:value-of select="concat('/', name(), '[', position(), ']')" />
	</xsl:template>

	<xsl:template match="*[local-name(.) = 'documentation']" mode="documentation.render">
		<xsl:if test="$ENABLE-DESCRIPTION and string-length(.) &gt; 0">
			<div class="lbl"><xsl:value-of select="$i18n/description"/></div>
			<div class="value">
				<xsl:apply-templates mode="copy" select="node()" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="render.source-code-link">
		<xsl:if test="$ENABLE-SRC-CODE-PARAGRAPH and $ENABLE-LINK">
			<span class="full-detail">
			<a class="btn btn-default btn-xs local" href="{concat('#', $SRC-PREFIX, generate-id(.))}">
				<xsl:value-of select="$SOURCE-CODE-TEXT" />
			</a>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="about.detail">
		<xsl:param name="version" />
	</xsl:template>

	<xsl:template name="processor-info.render">
		<xsl:text>This document was generated by </xsl:text>
		<a href="{system-property('xsl:vendor-url')}">
			<xsl:value-of select="system-property('xsl:vendor')" />
		</a>
		<xsl:text>XSLT engine.</xsl:text>
		<xsl:text>The engine processed the WSDL in XSLT </xsl:text>
		<xsl:value-of select="format-number(system-property('xsl:version'), '#.0')" />
		<xsl:text>compliant mode.</xsl:text>
	</xsl:template>

	<xsl:template match="ws:service|ws2:service" mode="service-start">
		<div class="full-detail">
			<div class="lbl"><xsl:value-of select="$i18n/namespace"/></div>
			<div class="value"><xsl:value-of select="$consolidated-wsdl/@targetNamespace" /></div>
		</div>
		<xsl:apply-templates select="*[local-name(.) = 'documentation']" mode="documentation.render" />
		<xsl:apply-templates select="ws:port|ws2:endpoint" mode="service" />
	</xsl:template>

	<xsl:template match="ws2:endpoint" mode="service">
		<xsl:variable name="binding-name">
			<xsl:apply-templates select="@binding" mode="qname.normalized" />
		</xsl:variable>
		<xsl:variable name="binding"
			select="$consolidated-wsdl/ws2:binding[@name = $binding-name]" />

		<xsl:variable name="binding-type" select="$binding/@type" />
		<xsl:variable name="binding-protocol" select="$binding/@*[local-name() = 'protocol']" />
		<xsl:variable name="protocol">
			<xsl:choose>
				<xsl:when test="starts-with($binding-type, 'http://schemas.xmlsoap.org/wsdl/soap')">SOAP 1.1</xsl:when>
				<xsl:when test="starts-with($binding-type, 'http://www.w3.org/2005/08/wsdl/soap')">SOAP 1.2</xsl:when>
				<xsl:when test="starts-with($binding-type, 'http://schemas.xmlsoap.org/wsdl/mime')">MIME</xsl:when>
				<xsl:when test="starts-with($binding-type, 'http://schemas.xmlsoap.org/wsdl/http')">HTTP</xsl:when>
				<xsl:otherwise>Unknown</xsl:otherwise>
			</xsl:choose>

			<!-- TODO: Add all bindings to transport protocols -->
			<xsl:choose>
				<xsl:when
					test="starts-with($binding-protocol, 'http://www.w3.org/2003/05/soap/bindings/HTTP')">
					over HTTP
				</xsl:when>
				<xsl:otherwise />
			</xsl:choose>
		</xsl:variable>

		
		<div class="lbl"><xsl:value-of select="$i18n/address"/></div>
		<div class="value">
			<xsl:value-of select="@address" />
		</div>
		<div class="full-detail">
			<div class="lbl"><xsl:value-of select="$i18n/protocol"/></div>
			<div class="value"><xsl:value-of select="$protocol" /></div>
		</div>

		<xsl:apply-templates select="$binding" mode="service" />

		<xsl:variable name="iface-name">
			<xsl:apply-templates select="../@interface" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws2:interface[@name = $iface-name]" mode="service" />

	</xsl:template>
	<xsl:template match="ws2:interface" mode="service">
		<h3>
			<xsl:value-of select="$i18n/interface"/>&#160;<b class="interface"><xsl:value-of select="@name" /></b>
			<xsl:if test="$ENABLE-LINK">
				<xsl:text></xsl:text>
				<small>
					<xsl:if test="$ENABLE-OPERATIONS-PARAGRAPH">
						<a class="btn btn-default btn-xs local" href="#{concat($PORT-PREFIX, generate-id(.))}">
							<xsl:value-of select="$PORT-TYPE-TEXT" />
						</a>
					</xsl:if>
					<xsl:call-template name="render.source-code-link" />
				</small>
			</xsl:if>
		</h3>

		<xsl:variable name="base-iface-name">
			<xsl:apply-templates select="@extends" mode="qname.normalized" />
		</xsl:variable>

		<xsl:if test="$base-iface-name">
			<div class="lbl"><xsl:value-of select="$i18n/extends"/> </div>
			<div class="value">
				<xsl:value-of select="$base-iface-name" />
			</div>
		</xsl:if>

		<xsl:variable name="base-iface" select="$consolidated-wsdl/ws2:interface[@name = $base-iface-name]" />

		<div class="lbl"><xsl:value-of select="$i18n/methods"/> </div>
		<div class="value">
			<xsl:text></xsl:text>
			<ol class="operations">
				<xsl:apply-templates select="$base-iface/ws2:operation | ws2:operation"
					mode="service">
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</ol>
		</div>
	</xsl:template>
	<xsl:template match="ws:port" mode="service">
		<xsl:variable name="binding-name">
			<xsl:apply-templates select="@binding" mode="qname.normalized" />
		</xsl:variable>
		<xsl:variable name="binding"
			select="$consolidated-wsdl/ws:binding[@name = $binding-name]" />

		<xsl:variable name="binding-uri"
			select="namespace-uri( $binding/*[local-name() = 'binding'] )" />
		<xsl:variable name="protocol">
			<xsl:choose>
				<xsl:when
					test="starts-with($binding-uri, 'http://schemas.xmlsoap.org/wsdl/soap')">
					SOAP
				</xsl:when>
				<xsl:when
					test="starts-with($binding-uri, 'http://schemas.xmlsoap.org/wsdl/mime')">
					MIME
				</xsl:when>
				<xsl:when
					test="starts-with($binding-uri, 'http://schemas.xmlsoap.org/wsdl/http')">
					HTTP
				</xsl:when>
				<xsl:otherwise>
					unknown
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="port-type-name">
			<xsl:apply-templates select="$binding/@type"
				mode="qname.normalized" />
		</xsl:variable>

		<xsl:variable name="port-type"
			select="$consolidated-wsdl/ws:portType[@name = $port-type-name]" />

		<h3 class="full-detail">
			<xsl:value-of select="$i18n/port"/>&#160;<b class="port"><xsl:value-of select="@name" /></b>
			<xsl:if test="$ENABLE-LINK">
				<xsl:text> </xsl:text>
				<small>
					<xsl:if test="$ENABLE-OPERATIONS-PARAGRAPH">
						<a class="btn btn-default btn-xs local" href="#{concat($PORT-PREFIX, generate-id($port-type))}">
							<xsl:value-of select="$PORT-TYPE-TEXT" />
						</a>
					</xsl:if>
					<xsl:call-template name="render.source-code-link" />
				</small>
			</xsl:if>
		</h3>

		<div class="full-detail">
			<div class="lbl"><xsl:value-of select="$i18n/address"/></div>
			<div class="value">
				<xsl:value-of select="*[local-name() = 'address']/@location" />
			</div>
		</div>

		<div class="full-detail">
			<div class="lbl"><xsl:value-of select="$i18n/protocol"/> </div>
			<div class="value"><xsl:value-of select="$protocol" /></div>
		</div>

		<xsl:apply-templates select="$binding" mode="service" />

		<div class="lbl"><xsl:value-of select="$i18n/methods"/></div>
		<div class="value">
			<xsl:text></xsl:text>
			<ol style="line-height: 180%;">
				<xsl:apply-templates
					select="$consolidated-wsdl/ws:portType[@name = $port-type-name]/ws:operation"
					mode="service">
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</ol>
		</div>
	</xsl:template>
	
	<xsl:template match="ws:operation|ws2:operation" mode="service">
		<li>
			<div class="operation-name-brief">
				<xsl:value-of select="@name" />
			</div>
			<xsl:if test="$ENABLE-LINK">
				<xsl:if test="$ENABLE-OPERATIONS-PARAGRAPH">
					<span class="full-detail">
						<a class="btn btn-default btn-xs local" href="{concat('#', $OPERATIONS-PREFIX, generate-id(.))}">Detalhes</a>
					</span>
				</xsl:if>
				<xsl:call-template name="render.source-code-link" />
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="ws:binding|ws2:binding" mode="service">
		<xsl:variable name="real-binding"
			select="*[local-name() = 'binding']|self::ws2:*" />

		<xsl:if test="$real-binding/@style">
			<div class="full-detail">
				<div class="lbl"><xsl:value-of select="$i18n/default-style"/></div>
				<div class="value"><xsl:value-of select="$real-binding/@style" /></div>
			</div>
		</xsl:if>

		<xsl:if test="$real-binding/@transport|$real-binding/*[local-name() = 'protocol']">
			<xsl:variable name="protocol" select="concat($real-binding/@transport, $real-binding/*[local-name() = 'protocol'])" />
			
			<div class="full-detail">
				<div class="lbl"><xsl:value-of select="$i18n/protocol"/></div>
				<div class="value">
					<xsl:choose>
						<xsl:when test="$protocol = 'http://schemas.xmlsoap.org/soap/http'">
							<xsl:value-of select="$i18n/soap-over-http"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$protocol" />
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</xsl:if>

		<xsl:if test="$real-binding/@verb">
			<div class="lbl"><xsl:value-of select="$i18n/default-method"/></div>
			<div class="value">
				<xsl:value-of select="$real-binding/@verb" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ws2:interface" mode="operations">
		<xsl:if test="$ENABLE-PORTTYPE-NAME">
			<h3>
				<a name="{concat($IFACE-PREFIX, generate-id(.))}">
					<xsl:value-of select="$IFACE-TEXT" />&#160;<b class="interface"><xsl:value-of select="@name" /></b>
				</a>
				<xsl:call-template name="render.source-code-link" />
			</h3>
		</xsl:if>

		<ol>
			<xsl:apply-templates select="ws2:operation" mode="operations">
				<xsl:sort select="@name" />
			</xsl:apply-templates>
		</ol>
	</xsl:template>

	<xsl:template match="ws2:operation" mode="operations">
		<xsl:variable name="binding-info"
			select="$consolidated-wsdl/ws2:binding[@interface = current()/../@name or substring-after(@interface, ':') = current()/../@name]/ws2:operation[@ref = current()/@name or substring-after(@ref, ':') = current()/@name]" />
		<li>
			<xsl:if test="position() != last()">
				<xsl:attribute name="class">operation</xsl:attribute>
			</xsl:if>
			<div class="operation-name-brief">
				<a name="{concat($OPERATIONS-PREFIX, generate-id(.))}">
					<xsl:value-of select="@name" />
				</a>
			</div>
			<div class="value">
				<xsl:text></xsl:text>
				<xsl:call-template name="render.source-code-link" />
			</div>
			<xsl:apply-templates select="ws2:documentation" mode="documentation.render" />

			<xsl:if test="$ENABLE-STYLEOPTYPEPATH">
				<!-- TODO: add the operation attributes - according the WSDL 2.0 spec. -->
			</xsl:if>
			<xsl:apply-templates
				select="ws2:input|ws2:output|../ws2:fault[@name = ws2:infault/@ref or @name = ws2:outfault/@ref]"
				mode="operations.message">
				<xsl:with-param name="binding-data" select="$binding-info" />
			</xsl:apply-templates>
		</li>
	</xsl:template>

	<xsl:template match="ws2:input|ws2:output|ws2:fault" mode="operations.message">
		<xsl:param name="binding-data" />
		<xsl:if test="$ENABLE-INOUTFAULT">
			<div class="lbl">
				<!-- <xsl:value-of select="concat(translate(substring(local-name(.), 
					1, 1), 'abcdefghijklmnoprstuvwxyz', 'ABCDEFGHIJKLMNOPRSTUVWXYZ'), substring(local-name(.), 
					2), ':')"/> -->
				<xsl:choose>
					<xsl:when test="local-name(.) = 'input'">
						<span><xsl:value-of select="$i18n/input"/></span>
					</xsl:when>
					<xsl:when test="local-name(.) = 'output'">
						<span><xsl:value-of select="$i18n/output"/></span>
					</xsl:when>
					<xsl:otherwise>
						<span><xsl:value-of select="$i18n/exception"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<div class="value">
				<xsl:variable name="type-name">
					<xsl:apply-templates select="@element" mode="qname.normalized" />
				</xsl:variable>

				<xsl:call-template name="render-type">
					<xsl:with-param name="type-local-name" select="$type-name" />
				</xsl:call-template>

				<xsl:call-template name="render.source-code-link" />

				<xsl:variable name="type-tree" select="$consolidated-xsd[@name = $type-name and not(xsd:simpleType)][1]" />
				<xsl:apply-templates select="$type-tree" mode="operations.message.part" />
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ws:portType" mode="operations">
		<div class="operations operation-details">
			<xsl:if test="position() != last()">
				<xsl:attribute name="class">port</xsl:attribute>
			</xsl:if>
			<xsl:if test="$ENABLE-PORTTYPE-NAME">
				<h3>
					<a name="{concat($PORT-PREFIX, generate-id(.))}">
						<xsl:value-of select="$PORT-TYPE-TEXT" />&#160;<b class="port-type"><xsl:value-of select="@name" /></b>
					</a>
					<!-- port source code -->
					<xsl:call-template name="render.source-code-link" />
				</h3>
			</xsl:if>
			<ol>
				<xsl:apply-templates select="ws:operation" mode="operations">
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</ol>
		</div>
	</xsl:template>
	
	<xsl:template match="ws:operation" mode="operations">
		<xsl:variable name="binding-info"
			select="$consolidated-wsdl/ws:binding[@type = current()/../@name or substring-after(@type, ':') = current()/../@name]/ws:operation[@name = current()/@name]" />
		<li>
			<xsl:if test="position() != last()">
				<xsl:attribute name="class">operation</xsl:attribute>
			</xsl:if>
			<a class="operation-name" name="{concat($OPERATIONS-PREFIX, generate-id(.))}">
				<xsl:value-of select="@name" />
			</a>
			<xsl:call-template name="render.source-code-link" />


			<div style="clear:both; margin-top: 10px;"></div>

			<xsl:if test="$ENABLE-DESCRIPTION and string-length(ws:documentation) &gt; 0">
				<div class="lbl"><xsl:value-of select="$i18n/description"/></div>
				<div class="value">
					<div class="documentation-value">
						<xsl:apply-templates mode="copy" select="ws:documentation/node()" />
					</div>
				</div>
			</xsl:if>

			<xsl:if test="$ENABLE-STYLEOPTYPEPATH">
				<xsl:variable name="binding-operation"
					select="$binding-info/*[local-name() = 'operation']" />
				<xsl:if test="$binding-operation/@style">
					<div class="full-detail">
						<div class="lbl"><xsl:value-of select="$i18n/default-style"/></div>
						<div class="value"><xsl:value-of select="$binding-operation/@style" /></div>
					</div>
				</xsl:if>

				<div class="full-detail">
					<div class="lbl"><xsl:value-of select="$i18n/operation-type"/></div>
					<div class="value">
						<xsl:choose>
							<xsl:when test="$binding-info/ws:input[not(../ws:output)]">
								<i><xsl:value-of select="$i18n/operation-types/one-way/label"/>. </i>
								<xsl:value-of select="$i18n/operation-types/one-way/description"/>
							</xsl:when>
							<xsl:when test="$binding-info/ws:input[following-sibling::ws:output]">
								<i><xsl:value-of select="$i18n/operation-types/request-response/label"/>. </i>
								<xsl:value-of select="$i18n/operation-types/request-response/description"/>
							</xsl:when>
							<xsl:when test="$binding-info/ws:input[preceding-sibling::ws:output]">
								<i><xsl:value-of select="$i18n/operation-types/solicit-response/label"/>. </i>
								<xsl:value-of select="$i18n/operation-types/solicit-response/description"/>
							</xsl:when>
							<xsl:when test="$binding-info/ws:output[not(../ws:input)]">
								<i><xsl:value-of select="$i18n/operation-types/notification/label"/>. </i>
								<xsl:value-of select="$i18n/operation-types/notification/description"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$i18n/unknown"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>

				<xsl:if test="string-length($binding-operation/@soapAction) &gt; 0">
					<div class="full-detail">
						<div class="lbl"><xsl:value-of select="$i18n/soap-action"/></div>
						<div class="value"><xsl:value-of select="$binding-operation/@soapAction" /></div>
					</div>
				</xsl:if>

				<xsl:if test="$binding-operation/@location">
					<div class="full-detail">
						<div class="lbl"><xsl:value-of select="$i18n/http-path"/></div>
						<div class="value">
							<xsl:value-of select="$binding-operation/@location" />
						</div>
					</div>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="ws:input|ws:output|ws:fault" mode="operations.message">
				<xsl:with-param name="binding-data" select="$binding-info" />
			</xsl:apply-templates>
		</li>
	</xsl:template>
	
	<xsl:template match="ws:input|ws:output|ws:fault" mode="operations.message">
		<xsl:param name="binding-data" />
		<xsl:if test="$ENABLE-INOUTFAULT">
			<div class="lbl">
				<!-- <xsl:value-of select="concat(translate(substring(local-name(.), 
					1, 1), 'abcdefghijklmnoprstuvwxyz', 'ABCDEFGHIJKLMNOPRSTUVWXYZ'), substring(local-name(.), 
					2), ':')"/> -->
				<xsl:choose>
					<xsl:when test="local-name(.) = 'input'">
						<span><xsl:value-of select="$i18n/input"/></span>
					</xsl:when>
					<xsl:when test="local-name(.) = 'output'">
						<span><xsl:value-of select="$i18n/output"/></span>
					</xsl:when>
					<xsl:otherwise>
						<span><xsl:value-of select="$i18n/exception"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<xsl:variable name="msg-local-name" select="substring-after(@message, ':')" />
			<xsl:variable name="msg-name">
				<xsl:choose>
					<xsl:when test="$msg-local-name">
						<xsl:value-of select="$msg-local-name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@message" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="msg" select="$consolidated-wsdl/ws:message[@name = $msg-name]" />
			<xsl:choose>
				<xsl:when test="$msg">
					<xsl:apply-templates select="$msg" mode="operations.message">
						<xsl:with-param name="binding-data" select="$binding-data/ws:*[local-name(.) = local-name(current())]/*" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<div class="value">
						<i><xsl:value-of select="$i18n/none"/></i>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ws:message" mode="operations.message">
		<xsl:param name="binding-data" />
		<div class="value full-detail">
			<xsl:value-of select="@name" />
			<xsl:if test="$binding-data">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="name($binding-data)" />
				<xsl:variable name="use" select="$binding-data/@use" />
				<xsl:if test="$use">
					<xsl:text>, use = </xsl:text>
					<xsl:value-of select="$use" />
				</xsl:if>
				<xsl:variable name="part" select="$binding-data/@part" />
				<xsl:if test="$part">
					<xsl:text>, part = </xsl:text>
					<xsl:value-of select="$part" />
				</xsl:if>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:call-template name="render.source-code-link" />
		</div>

		<xsl:apply-templates select="ws:part" mode="operations.message" />
	</xsl:template>

	<xsl:template match="ws:part" mode="operations.message">
		<div class="value box" style="margin-bottom: 3px">
			<xsl:choose>
				<xsl:when test="string-length(@name) &gt; 0">
					<b class="part-name" ><xsl:value-of select="@name" /></b>

					<xsl:variable name="elem-or-type">
						<xsl:choose>
							<xsl:when test="@type">
								<xsl:value-of select="@type" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@element" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="type-local-name"
						select="substring-after($elem-or-type, ':')" />
					<xsl:variable name="type-name">
						<xsl:choose>
							<xsl:when test="$type-local-name">
								<xsl:value-of select="$type-local-name" />
							</xsl:when>
							<xsl:when test="$elem-or-type">
								<xsl:value-of select="$elem-or-type" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$i18n/unknown"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:call-template name="render-type">
						<xsl:with-param name="type-local-name" select="$type-name" />
					</xsl:call-template>

					<xsl:variable name="part-type"
						select="$consolidated-xsd[@name = $type-name and not(xsd:simpleType)][1]" />
					<xsl:apply-templates select="$part-type"
						mode="operations.message.part" />

				</xsl:when>
				<xsl:otherwise>
					<i>none</i>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!-- End of included transformation: wsdl-viewer-operations.xsl -->

	<!-- Begin of included transformation: wsdl-viewer-xsd-tree.xsl -->
	<xsl:template match="xsd:simpleType" mode="operations.message.part" />
	
	<xsl:template name="recursion.should.continue">
		<xsl:param name="anti.recursion" />
		<xsl:param name="recursion.label" />
		<xsl:param name="recursion.count">
			1
		</xsl:param>
		<xsl:variable name="has.recursion"
			select="contains($anti.recursion, $recursion.label)" />
		<xsl:variable name="anti.recursion.fragment"
			select="substring-after($anti.recursion, $recursion.label)" />
		<xsl:choose>
			<xsl:when test="$recursion.count &gt; $ANTIRECURSION-DEPTH" />

			<xsl:when
				test="not($ENABLE-ANTIRECURSION-PROTECTION) or string-length($anti.recursion) = 0 or not($has.recursion)">
				<xsl:text>1</xsl:text>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="recursion.should.continue">
					<xsl:with-param name="anti.recursion" select="$anti.recursion.fragment" />
					<xsl:with-param name="recursion.label" select="$recursion.label" />
					<xsl:with-param name="recursion.count" select="$recursion.count + 1" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xsd:complexType" mode="operations.message.part">
		<xsl:param name="anti.recursion" />

		<xsl:variable name="recursion.label" select="concat('[', @name, ']')" />
		<xsl:variable name="recursion.test">
			<xsl:call-template name="recursion.should.continue">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
				<xsl:with-param name="recursion.label" select="$recursion.label" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($recursion.test) != 0">
				<xsl:apply-templates select="*"
					mode="operations.message.part">
					<xsl:with-param name="anti.recursion"
						select="concat($anti.recursion, $recursion.label)" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<small class="small">
					<xsl:value-of select="$RECURSIVE" />
				</small>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xsd:complexContent" mode="operations.message.part">
		<xsl:param name="anti.recursion" />

		<xsl:apply-templates select="*"
			mode="operations.message.part">
			<xsl:with-param name="anti.recursion" select="$anti.recursion" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template
		match="xsd:complexType[descendant::xsd:attribute[ not(@*[local-name() = 'arrayType']) ]]"
		mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<xsl:variable name="recursion.label" select="concat('[', @name, ']')" />
		<xsl:variable name="recursion.test">
			<xsl:call-template name="recursion.should.continue">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
				<xsl:with-param name="recursion.label" select="$recursion.label" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($recursion.test) != 0">
				<ul type="circle">
					<xsl:apply-templates select="*"
						mode="operations.message.part">
						<xsl:with-param name="anti.recursion"
							select="concat($anti.recursion, $recursion.label)" />
					</xsl:apply-templates>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<small class="small">
					<xsl:value-of select="$RECURSIVE" />
				</small>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xsd:restriction | xsd:extension" mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<xsl:variable name="type-local-name" select="substring-after(@base, ':')" />
		<xsl:variable name="type-name">
			<xsl:choose>
				<xsl:when test="$type-local-name">
					<xsl:value-of select="$type-local-name" />
				</xsl:when>
				<xsl:when test="@base">
					<xsl:value-of select="@base" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$i18n/unknown"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="base-type" select="$consolidated-xsd[@name = $type-name][1]" />
		<!-- xsl:if test="not($type/@abstract)"> <xsl:apply-templates select="$type"/></xsl:if -->
		<xsl:if test="$base-type != 'Array'">
			<xsl:apply-templates select="$base-type"
				mode="operations.message.part">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>
		</xsl:if>
		<xsl:apply-templates select="*"
			mode="operations.message.part">
			<xsl:with-param name="anti.recursion" select="$anti.recursion" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xsd:union" mode="operations.message.part">
		<xsl:call-template name="process-union">
			<xsl:with-param name="set" select="@memberTypes" />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="process-union">
		<xsl:param name="set" />
		<xsl:if test="$set">
			<xsl:variable name="item" select="substring-before($set, ' ')" />
			<xsl:variable name="the-rest" select="substring-after($set, ' ')" />

			<xsl:variable name="type-local-name" select="substring-after($item, ':')" />
			<xsl:variable name="type-name">
				<xsl:choose>
					<xsl:when test="$type-local-name">
						<xsl:value-of select="$type-local-name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$item" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="render-type">
				<xsl:with-param name="type-local-name" select="$type-name" />
			</xsl:call-template>

			<xsl:call-template name="process-union">
				<xsl:with-param name="set" select="$the-rest" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="xsd:sequence" mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<ul class="messagePart">
			<xsl:apply-templates select="*"
				mode="operations.message.part">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="xsd:choice" mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<ul class="messagePart">
			<li><xsl:value-of select="$i18n/choose-one-of"/></li>
			<xsl:apply-templates select="*"
				mode="operations.message.part">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="xsd:all" mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<ul type="diamond">
			<xsl:apply-templates select="*"
				mode="operations.message.part">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="xsd:any" mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<ul type="box">
			<xsl:apply-templates select="*"
				mode="operations.message.part">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="xsd:element[parent::xsd:schema]"
		mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<xsl:variable name="recursion.label" select="concat('[', @name, ']')" />
		<xsl:variable name="recursion.test">
			<xsl:call-template name="recursion.should.continue">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
				<xsl:with-param name="recursion.label" select="$recursion.label" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($recursion.test) != 0">
				<xsl:variable name="type-name">
					<xsl:call-template name="xsd.element-type" />
				</xsl:variable>
				<xsl:variable name="elem-type"
					select="$consolidated-xsd[generate-id() != generate-id(current()) and $type-name and @name=$type-name and contains(local-name(), 'Type')][1]" />

				<xsl:if test="$type-name != @name">
					<xsl:apply-templates select="$elem-type"
						mode="operations.message.part">
						<xsl:with-param name="anti.recursion"
							select="concat($anti.recursion, $recursion.label)" />
					</xsl:apply-templates>

					<xsl:if test="not($elem-type)">
						<xsl:call-template name="render-type">
							<xsl:with-param name="type-local-name" select="$type-name" />
						</xsl:call-template>
					</xsl:if>

					<xsl:apply-templates select="*"
						mode="operations.message.part">
						<xsl:with-param name="anti.recursion"
							select="concat($anti.recursion, $recursion.label)" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<small class="small">
					<xsl:value-of select="$RECURSIVE" />
				</small>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xsd:element | xsd:attribute" mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<!--<xsl:variable name="recursion.label" select="concat('[', @name, ']')"/> -->
		<li class="fechado">
			<xsl:variable name="local-ref"
				select="concat(@name, substring-after(@ref, ':'))" />
			<xsl:variable name="elem-name">
				<xsl:choose>
					<xsl:when test="@name">
						<xsl:value-of select="@name" />
					</xsl:when>
					<xsl:when test="$local-ref">
						<xsl:value-of select="$local-ref" />
					</xsl:when>
					<xsl:when test="@ref">
						<xsl:value-of select="@ref" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$i18n/anonymous"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="type-name">
				<xsl:call-template name="xsd.element-type" />
			</xsl:variable>
			<xsl:variable name="elem-type" select="$consolidated-xsd[@name = $type-name and contains(local-name(), 'Type')][1]" />
			<xsl:choose>
				<xsl:when test="$elem-type and not(contains($type-name, 'Enum'))">
					<a href="#" onclick="expand(this);return false;">
						<xsl:value-of select="$elem-name" />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$elem-name" />
				</xsl:otherwise>
			</xsl:choose>

			<xsl:call-template name="render-type">
				<xsl:with-param name="type-local-name" select="$type-name" />
			</xsl:call-template>

			<xsl:apply-templates select="$elem-type | *"
				mode="operations.message.part">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>

		</li>
	</xsl:template>

	<xsl:template match="xsd:attribute[ @*[local-name() = 'arrayType'] ]"
		mode="operations.message.part">
		<xsl:param name="anti.recursion" />
		<xsl:variable name="array-local-name"
			select="substring-after(@*[local-name() = 'arrayType'], ':')" />
		<xsl:variable name="type-local-name"
			select="substring-before($array-local-name, '[')" />
		<xsl:variable name="array-type"
			select="$consolidated-xsd[@name = $type-local-name][1]" />

		<xsl:variable name="recursion.label" select="concat('[', $type-local-name, ']')" />
		<xsl:variable name="recursion.test">
			<xsl:call-template name="recursion.should.continue">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
				<xsl:with-param name="recursion.label" select="$recursion.label" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($recursion.test) != 0">
				<xsl:apply-templates select="$array-type"
					mode="operations.message.part">
					<xsl:with-param name="anti.recursion"
						select="concat($anti.recursion, $recursion.label)" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<small class="small">
					<xsl:value-of select="$RECURSIVE" />
				</small>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="xsd.element-type">
		<xsl:variable name="ref-or-type">
			<xsl:choose>
				<xsl:when test="@type">
					<xsl:value-of select="@type" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@ref" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type-local-name" select="substring-after($ref-or-type, ':')" />
		<xsl:variable name="type-name">
			<xsl:choose>
				<xsl:when test="$type-local-name">
					<xsl:value-of select="$type-local-name" />
				</xsl:when>
				<xsl:when test="$ref-or-type">
					<xsl:value-of select="$ref-or-type" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$i18n/undefined"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$type-name" />
	</xsl:template>

	<xsl:template match="xsd:documentation" mode="operations.message.part">
		<div class="documentation">
			<!-- 
			<div class="documentation-arrow">
				<img class="img" src="./right-arrow.svg" />
			</div>
			 -->
			<div class="documentation-content">
				<xsl:apply-templates mode="copy" select="node()" />
			</div>
		</div>
	</xsl:template>

	<xsl:template name="render-type">
		<xsl:param name="anti.recursion" />
		<xsl:param name="type-local-name" />

		<xsl:if test="$ENABLE-OPERATIONS-TYPE">
			<xsl:variable name="recursion.label" select="concat('[', $type-local-name, ']')" />
			<xsl:variable name="recursion.test">
				<xsl:call-template name="recursion.should.continue">
					<xsl:with-param name="anti.recursion" select="$anti.recursion" />
					<xsl:with-param name="recursion.label" select="$recursion.label" />
					<xsl:with-param name="recursion.count" select="$ANTIRECURSION-DEPTH" />
				</xsl:call-template>
			</xsl:variable>

			<xsl:if test="string-length($recursion.test) != 0">
				<div class="element-type-container">
					<xsl:variable name="elem-type" select="$consolidated-xsd[@name = $type-local-name and (not(contains(local-name(current()), 'element')) or contains(local-name(), 'Type'))][1]" />
					<xsl:if test="string-length($type-local-name) &gt; 0">
						<xsl:call-template name="render-type.write-name">
							<xsl:with-param name="type-local-name" select="$type-local-name" />
							<xsl:with-param name="type-default-value" select="@default" />
						</xsl:call-template>
					</xsl:if>

					<xsl:choose>
						<xsl:when test="$elem-type">
							<xsl:apply-templates select="$elem-type" mode="render-type">
								<xsl:with-param name="anti.recursion" select="concat($anti.recursion, $recursion.label)" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*" mode="render-type">
								<xsl:with-param name="anti.recursion" select="concat($anti.recursion, $recursion.label)" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:call-template name="render-type.properties">
							<xsl:with-param name="minOccurs" select="@minOccurs" />
							<xsl:with-param name="maxOccurs" select="@maxOccurs" />
							<xsl:with-param name="nillable" select="@nillable" />
    				</xsl:call-template>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="render-type.properties">
		<xsl:param name="minOccurs" />
		<xsl:param name="maxOccurs" />
		<xsl:param name="nillable" />
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="not($minOccurs)">1</xsl:when>
				<xsl:when test="$minOccurs = 0"><xsl:value-of select="$i18n/zero"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$minOccurs"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="max">
			<xsl:choose>
				<xsl:when test="not($maxOccurs)">1</xsl:when>
				<xsl:when test="$maxOccurs = 'unbounded'"><xsl:value-of select="$i18n/unlimited"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$maxOccurs"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$min = 0 or $min = 'zero' and $max = 1">
				<span class="text-success optional range"><xsl:value-of select="$i18n/optional"/>. </span>
			</xsl:when>
			<xsl:when test="$min = 1 and $max = 1">
				<span class="text-success required range"><xsl:value-of select="$i18n/required"/>. </span>
			</xsl:when>
			<xsl:otherwise>
				<span class="text-success range">
					<xsl:value-of select="$i18n/between"/>&#160;
					<xsl:value-of select="$min"/>&#160;
					<xsl:value-of select="$i18n/and"/>&#160;
					<xsl:value-of select="$max"/>&#160;
					<xsl:value-of select="$i18n/elements"/>.
				</span>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="not($nillable = 1)">
				<small class="text-muted nillable"><xsl:value-of select="$i18n/does-not-allow-null"/>. </small>
			</xsl:when>
			<xsl:otherwise>
				<small class="text-muted nillable"><xsl:value-of select="$i18n/allow-null"/>. </small>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="render-type.write-name">
		<xsl:param name="type-local-name" />
		<xsl:param name="type-default-value" />
		<div class="element-type">
			<span class="word"><xsl:value-of select="$i18n/type"/></span>
			<span class="type">
				<xsl:choose>
					<xsl:when test="$type-local-name">
						<xsl:choose>
							<xsl:when test="$type-local-name = 'boolean'"><xsl:value-of select="$i18n/types/boolean"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'string'"><xsl:value-of select="$i18n/types/string"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'dateTime'"><xsl:value-of select="$i18n/types/datetime"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'int'"><xsl:value-of select="$i18n/types/int"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'integer'"><xsl:value-of select="$i18n/types/integer"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'positiveInteger'"><xsl:value-of select="$i18n/types/positive-integer"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'double'"><xsl:value-of select="$i18n/types/double"/>. </xsl:when>
							<xsl:when test="$type-local-name = 'float'"><xsl:value-of select="$i18n/types/float"/>. </xsl:when>
							<xsl:otherwise><xsl:value-of select="$type-local-name" /></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="$i18n/undefined"/></xsl:otherwise>
				</xsl:choose>
			</span>
		</div>
		<xsl:if test="$type-default-value">
			<div class="element-type-default-word">, <xsl:value-of select="$i18n/default"/>: </div>
			<div class="element-type-default">
				<xsl:value-of select="$type-default-value" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*">
		<xsl:message terminate="no">
			WARNING: Unmatched element: <xsl:value-of select="name()"/>
		</xsl:message>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*" mode="render-type" />

	<xsl:template match="xsd:element | xsd:complexType | xsd:simpleType | xsd:complexContent" mode="render-type">
		<xsl:param name="anti.recursion" />
		<xsl:apply-templates select="*" mode="render-type">
			<xsl:with-param name="anti.recursion" select="$anti.recursion" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="xsd:restriction[ parent::xsd:simpleType ]" mode="render-type">
		<div class="restriction">
			<xsl:param name="anti.recursion" />
			<xsl:variable name="type-local-name" select="substring-after(@base, ':')" />
			<xsl:variable name="type-name">
				<xsl:choose>
					<xsl:when test="$type-local-name">
						<xsl:value-of select="$type-local-name" />
					</xsl:when>
					<xsl:when test="@base">
						<xsl:value-of select="@base" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$i18n/undefined"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
	
			<xsl:text>: </xsl:text>
			
			<xsl:call-template name="render-type.write-name">
				<xsl:with-param name="type-local-name" select="$type-local-name" />
			</xsl:call-template>
			
			<span class="restriction-word">
				<xsl:choose>
					<xsl:when test="local-name(.) = 'restriction'">
						<xsl:value-of select="$i18n/restricted"/>:
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="local-name()" />
					</xsl:otherwise>
				</xsl:choose>
			</span>
			
			<xsl:apply-templates select="*" mode="render-type">
				<xsl:with-param name="anti.recursion" select="$anti.recursion" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="xsd:simpleType/xsd:restriction/xsd:*[not(self::xsd:enumeration)]" mode="render-type">
		<xsl:text> </xsl:text>
		<xsl:value-of select="local-name()" />
		<xsl:text>(</xsl:text>
		<xsl:value-of select="@value" />
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="xsd:restriction | xsd:extension" mode="render-type">
		<xsl:param name="anti.recursion" />
		<xsl:variable name="type-local-name" select="substring-after(@base, ':')" />
		<xsl:variable name="type-name">
			<xsl:choose>
				<xsl:when test="$type-local-name">
					<xsl:value-of select="$type-local-name" />
				</xsl:when>
				<xsl:when test="@base">
					<xsl:value-of select="@base" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$i18n/undefined"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="base-type" select="$consolidated-xsd[@name = $type-name][1]" />
		<xsl:variable name="abstract">
			<xsl:if test="$base-type/@abstract">
				<xsl:value-of select="$i18n/abstract"/>
			</xsl:if>
		</xsl:variable>

		<xsl:if test="not($type-name = 'Array')">
			<xsl:value-of select="concat(' - ', local-name(), ' of ', $abstract)" />
			<xsl:call-template name="render-type.write-name">
				<xsl:with-param name="type-local-name" select="$type-name" />
			</xsl:call-template>
		</xsl:if>

		<xsl:apply-templates select="$base-type | *" mode="render-type">
			<xsl:with-param name="anti.recursion" select="$anti.recursion" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xsd:attribute[ @*[local-name() = 'arrayType'] ]"
		mode="render-type">
		<xsl:param name="anti.recursion" />
		<xsl:variable name="array-local-name"
			select="substring-after(@*[local-name() = 'arrayType'], ':')" />
		<xsl:variable name="type-local-name"
			select="substring-before($array-local-name, '[')" />
		<xsl:variable name="array-type"
			select="$consolidated-xsd[@name = $type-local-name][1]" />

		<xsl:text> - array of </xsl:text>
		<xsl:call-template name="render-type.write-name">
			<xsl:with-param name="type-local-name" select="$type-local-name" />
		</xsl:call-template>

		<xsl:apply-templates select="$array-type" mode="render-type">
			<xsl:with-param name="anti.recursion" select="$anti.recursion" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xsd:enumeration" mode="render-type" />
	
	<xsl:template match="xsd:enumeration[not(preceding-sibling::xsd:enumeration)]" mode="render-type">
		<code class="enum">
			<xsl:apply-templates select="self::* | following-sibling::xsd:enumeration" mode="render-type.enum" />
		</code>
	</xsl:template>
	
	<xsl:template match="xsd:enumeration" mode="render-type.enum">
		<xsl:if test="preceding-sibling::xsd:enumeration">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:value-of select="@value" />
	</xsl:template>

	<xsl:template match="@*" mode="src.import">
		<xsl:param name="src.import.stack" />
		<xsl:variable name="recursion.label" select="concat('[', string(.), ']')" />
		<xsl:variable name="recursion.check"
			select="concat($src.import.stack, $recursion.label)" />

		<xsl:choose>
			<xsl:when test="contains($src.import.stack, $recursion.label)">
				<h2 style="red">
					<xsl:value-of
						select="concat('Cyclic include / import: ', $recursion.check)" />
				</h2>
			</xsl:when>
			<xsl:otherwise>
				<h2>
					<a name="{concat($SRC-FILE-PREFIX, generate-id(..))}">
						<xsl:choose>
							<xsl:when test="parent::xsd:include">
								<xsl:value-of select="$i18n/included"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$i18n/imported"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="name() = 'location'">
								WSDL
							</xsl:when>
							<xsl:otherwise>
								Schema
							</xsl:otherwise>
						</xsl:choose>
						<i>
							<xsl:value-of select="." />
						</i>
					</a>
				</h2>

				<div class="box">
					<xsl:apply-templates select="document(string(.))"
						mode="src" />
				</div>

				<xsl:apply-templates
					select="document(string(.))/*/*[local-name() = 'import'][@location]/@location"
					mode="src.import">
					<xsl:with-param name="src.import.stack" select="$recursion.check" />
				</xsl:apply-templates>
				<xsl:apply-templates
					select="document(string(.))//xsd:import[@schemaLocation]/@schemaLocation"
					mode="src.import">
					<xsl:with-param name="src.import.stack" select="$recursion.check" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="src">
		<div class="xml-element">
			<a name="{concat($SRC-PREFIX, generate-id(.))}">
				<xsl:apply-templates select="." mode="src.link" />
				<xsl:apply-templates select="." mode="src.start-tag" />
			</a>
			<xsl:apply-templates
				select="*|comment()|processing-instruction()|text()[string-length(normalize-space(.)) &gt; 0]"
				mode="src" />
			<xsl:apply-templates select="." mode="src.end-tag" />
		</div>
	</xsl:template>
	
	<xsl:template match="*" mode="src.start-tag">
		<xsl:call-template name="src.elem">
			<xsl:with-param name="src.elem.end-slash">/</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template
		match="*[*|comment()|processing-instruction()|text()[string-length(normalize-space(.)) &gt; 0]]"
		mode="src.start-tag">
		<xsl:call-template name="src.elem" />
	</xsl:template>
	
	<xsl:template match="*" mode="src.end-tag" />
	
	<xsl:template match="*[*|comment()|processing-instruction()|text()[string-length(normalize-space(.)) &gt; 0]]" mode="src.end-tag">
		<xsl:call-template name="src.elem">
			<xsl:with-param name="src.elem.start-slash">/</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*" mode="src.link-attribute">
		<xsl:if test="$ENABLE-LINK">
			<xsl:attribute name="href">
				<xsl:value-of select="concat('#', $SRC-PREFIX, generate-id(.))" />
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*[local-name() = 'import' or local-name() = 'include'][@location or @schemaLocation]" mode="src.link">
		<xsl:if test="$ENABLE-LINK">
			<xsl:attribute name="href">
				<xsl:value-of select="concat('#', $SRC-FILE-PREFIX, generate-id(.))" />
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="src.link" />
	<xsl:template match="ws2:service|ws2:binding" mode="src.link">
		<xsl:variable name="iface-name">
			<xsl:apply-templates select="@interface" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws2:interface[@name = $iface-name]" mode="src.link-attribute" />
	</xsl:template>
	<xsl:template match="ws2:endpoint" mode="src.link">
		<xsl:variable name="binding-name">
			<xsl:apply-templates select="@binding" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws2:binding[@name = $binding-name]" mode="src.link-attribute" />
	</xsl:template>
	<xsl:template match="ws2:binding/ws2:operation" mode="src.link">
		<xsl:variable name="operation-name">
			<xsl:apply-templates select="@ref" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws2:interface/ws2:operation[@name = $operation-name]"
			mode="src.link-attribute" />
	</xsl:template>
	<xsl:template
		match="ws2:binding/ws2:fault|ws2:interface/ws2:operation/ws2:infault|ws2:interface/ws2:operation/ws2:outfault"
		mode="src.link">
		<xsl:variable name="operation-name">
			<xsl:apply-templates select="@ref" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws2:interface/ws2:fault[@name = $operation-name]"
			mode="src.link-attribute" />
	</xsl:template>
	<xsl:template
		match="ws2:interface/ws2:operation/ws2:input|ws2:interface/ws2:operation/ws2:output|ws2:interface/ws2:fault"
		mode="src.link">
		<xsl:variable name="elem-name">
			<xsl:apply-templates select="@element" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates select="$consolidated-xsd[@name = $elem-name]"
			mode="src.link-attribute" />
	</xsl:template>
	<xsl:template
		match="ws:operation/ws:input[@message] | ws:operation/ws:output[@message] | ws:operation/ws:fault[@message] | soap:header[ancestor::ws:operation and @message]"
		mode="src.link">
		<xsl:apply-templates
			select="$consolidated-wsdl/ws:message[@name = substring-after( current()/@message, ':' )]"
			mode="src.link-attribute" />
	</xsl:template>
	<!-- <xsl:template match="ws:operation/ws:input[@message] | ws:operation/ws:output[@message] 
		| ws:operation/ws:fault[@message] | soap:header[ancestor::ws:operation and 
		@message]" mode="src.link"> <xsl:apply-templates select="$consolidated-wsdl/ws:message[@name 
		= substring-after( current()/@message, ':' )]" mode="src.link-attribute"/> 
		</xsl:template> -->
	<xsl:template match="ws:message/ws:part[@element or @type]"
		mode="src.link">
		<xsl:variable name="elem-local-name" select="substring-after(@element, ':')" />
		<xsl:variable name="type-local-name" select="substring-after(@type, ':')" />
		<xsl:variable name="elem-name">
			<xsl:choose>
				<xsl:when test="$elem-local-name">
					<xsl:value-of select="$elem-local-name" />
				</xsl:when>
				<xsl:when test="$type-local-name">
					<xsl:value-of select="$type-local-name" />
				</xsl:when>
				<xsl:when test="@element">
					<xsl:value-of select="@element" />
				</xsl:when>
				<xsl:when test="@type">
					<xsl:value-of select="@type" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="src.syntax-error" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="$consolidated-xsd[@name = $elem-name]"
			mode="src.link-attribute" />
	</xsl:template>
	<xsl:template match="ws:service/ws:port[@binding]" mode="src.link">
		<xsl:variable name="binding-name">
			<xsl:apply-templates select="@binding" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws:binding[@name = $binding-name]" mode="src.link-attribute" />
	</xsl:template>
	<xsl:template match="ws:operation[@name and parent::ws:binding/@type]"
		mode="src.link">
		<xsl:variable name="type-name">
			<xsl:apply-templates select="../@type" mode="qname.normalized" />
		</xsl:variable>
		<xsl:apply-templates
			select="$consolidated-wsdl/ws:portType[@name = $type-name]/ws:operation[@name = current()/@name]"
			mode="src.link-attribute" />
	</xsl:template>
	<xsl:template match="xsd:element[@ref or @type]" mode="src.link">
		<xsl:variable name="ref-or-type">
			<xsl:choose>
				<xsl:when test="@type">
					<xsl:value-of select="@type" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@ref" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type-local-name" select="substring-after($ref-or-type, ':')" />
		<xsl:variable name="xsd-name">
			<xsl:choose>
				<xsl:when test="$type-local-name">
					<xsl:value-of select="$type-local-name" />
				</xsl:when>
				<xsl:when test="$ref-or-type">
					<xsl:value-of select="$ref-or-type" />
				</xsl:when>
				<xsl:otherwise />
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$xsd-name">
			<xsl:variable name="msg"
				select="$consolidated-xsd[@name = $xsd-name and contains(local-name(), 'Type')][1]" />
			<xsl:apply-templates select="$msg" mode="src.link-attribute" />
		</xsl:if>
	</xsl:template>
	<xsl:template match="xsd:attribute[contains(@ref, 'arrayType')]"
		mode="src.link">
		<xsl:variable name="att-array-type"
			select="substring-before(@*[local-name() = 'arrayType'], '[]')" />
		<xsl:variable name="xsd-local-name"
			select="substring-after($att-array-type, ':')" />
		<xsl:variable name="xsd-name">
			<xsl:choose>
				<xsl:when test="$xsd-local-name">
					<xsl:value-of select="$xsd-local-name" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$att-array-type" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$xsd-name">
			<xsl:variable name="msg"
				select="$consolidated-xsd[@name = $xsd-name][1]" />
			<xsl:apply-templates select="$msg" mode="src.link-attribute" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="xsd:extension | xsd:restriction"
		mode="src.link">
		<xsl:variable name="xsd-local-name" select="substring-after(@base, ':')" />
		<xsl:variable name="xsd-name">
			<xsl:choose>
				<xsl:when test="$xsd-local-name">
					<xsl:value-of select="$xsd-local-name" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@type" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="msg"
			select="$consolidated-xsd[@name = $xsd-name][1]" />
		<xsl:apply-templates select="$msg" mode="src.link-attribute" />
	</xsl:template>
	
	<xsl:template name="src.elem">
		<xsl:param name="src.elem.start-slash" />
		<xsl:param name="src.elem.end-slash" />

		<xsl:value-of select="concat('&lt;', $src.elem.start-slash, name(.))" disable-output-escaping="no" />
		<xsl:if test="not($src.elem.start-slash)">
			<xsl:apply-templates select="@*" mode="src" />
			<xsl:apply-templates select="." mode="src.namespace" />
		</xsl:if>
		<xsl:value-of select="concat($src.elem.end-slash, '&gt;')" disable-output-escaping="no" />
	</xsl:template>
	
	<xsl:template match="@*" mode="src">
		<xsl:text> </xsl:text>
		<span class="xml-att">
			<xsl:value-of select="concat(name(), '=')" />
			<span class="xml-att-val">
				<xsl:value-of select="concat('&quot;', ., '&quot;')"
					disable-output-escaping="yes" />
			</span>
		</span>
	</xsl:template>
	
	<xsl:template match="*" mode="src.namespace">
		<xsl:variable name="supports-namespace-axis" select="count(/*/namespace::*) &gt; 0" />
		<xsl:variable name="current" select="current()" />

		<xsl:choose>
			<xsl:when test="count(/*/namespace::*) &gt; 0">
				<!-- When the namespace axis is present (e.g. Internet Explorer), we 
					can simulate the namespace declarations by comparing the namespaces in scope 
					on this element with those in scope on the parent element. Any difference 
					must have been the result of a namespace declaration. Note that this doesn't 
					reflect the actual source - it will strip out redundant namespace declarations. -->
				<xsl:for-each select="namespace::*[. != 'http://www.w3.org/XML/1998/namespace']">
					<xsl:if test="not($current/parent::*[namespace::*[. = current()]])">
						<div class="xml-att">
							<xsl:text> xmlns</xsl:text>
							<xsl:if test="string-length(name())">
								:
							</xsl:if>
							<xsl:value-of select="concat(name(), '=')" />
							<span class="xml-att-val">
								<xsl:value-of select="concat('&quot;', ., '&quot;')"
									disable-output-escaping="yes" />
							</span>
						</div>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- When the namespace axis isn't supported (e.g. Mozilla), we can simulate 
					appropriate declarations from namespace elements. This currently doesn't 
					check for namespaces on attributes. In the general case we can't reliably 
					detect the use of QNames in content, but in the case of schema, we know which 
					content could contain a QName and look there too. This mechanism is rather 
					unpleasant though, since it records namespaces where they are used rather 
					than showing where they are declared (on some parent element) in the source. 
					Yukk! -->
				<xsl:if
					test="namespace-uri(.) != namespace-uri(parent::*) or not(parent::*)">
					<span class="xml-att">
						<xsl:text> xmlns</xsl:text>
						<xsl:if test="substring-before(name(),':') != ''">
							:
						</xsl:if>
						<xsl:value-of select="substring-before(name(),':')" />
						<xsl:text>=</xsl:text>
						<span class="xml-att-val">
							<xsl:value-of select="concat('&quot;', namespace-uri(.), '&quot;')"
								disable-output-escaping="yes" />
						</span>
					</span>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="text()" mode="src">
		<span class="xml-text">
			<xsl:value-of select="." disable-output-escaping="no" />
		</span>
	</xsl:template>
	
	<xsl:template match="comment()" mode="src">
		<div class="xml-comment">
			<xsl:text disable-output-escaping="no">&lt;!-- </xsl:text>
			<xsl:value-of select="." disable-output-escaping="no" />
			<xsl:text disable-output-escaping="no"> --&gt;</xsl:text>
		</div>
	</xsl:template>
	
	<xsl:template match="processing-instruction()" mode="src">
		<div class="xml-proc">
			<xsl:text disable-output-escaping="no">&lt;?</xsl:text>
			<xsl:copy-of select="name(.)" />
			<xsl:value-of select="concat(' ', .)"
				disable-output-escaping="yes" />
			<xsl:text disable-output-escaping="no"> ?&gt;</xsl:text>
		</div>
	</xsl:template>

	<xsl:template match="/">
		<xsl:call-template name="body.render" />
	</xsl:template>

	<!-- Rendering: HTML body -->
	<xsl:template name="body.render">
		<div id="operations">
			<div id="outer_box">
				<div id="inner_box">
					<xsl:call-template name="title.render" />
					<xsl:call-template name="content.render" />
					<xsl:call-template name="footer.render" />
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- Rendering: heading -->

	<xsl:template name="title.render">
	   <!-- 
		<div id="header">
			<h1>
				$html-title substituido por $consolidated-wsdl/@targetNamespace <xsl:value-of select="$html-title"/>
				Web service: <xsl:value-of select="$consolidated-wsdl/@targetNamespace" />
			</h1>
		</div>
         -->
	</xsl:template>

	<!-- Rendering: content -->
	<xsl:template name="content.render">
		<div id="content">
			<xsl:if test="$ENABLE-SERVICE-PARAGRAPH">
				<xsl:call-template name="service.render" />
			</xsl:if>
			<xsl:if test="$ENABLE-OPERATIONS-PARAGRAPH">
				<xsl:call-template name="operations.render" />
			</xsl:if>
			<xsl:if test="$ENABLE-SRC-CODE-PARAGRAPH">
				<xsl:call-template name="src.render" />
			</xsl:if>
		</div>
	</xsl:template>



	<!-- Rendering: footer -->

	<xsl:template name="footer.render">
		<div id="footer">
			<!-- nada por enquanto -->
		</div>
	</xsl:template>

	<!-- Rendering: WSDL service information -->

	<xsl:template name="service.render">
		<div class="page">
			<xsl:apply-templates select="$consolidated-wsdl/*[local-name(.) = 'documentation']" mode="documentation.render" />
			<xsl:apply-templates
				select="$consolidated-wsdl/ws:service|$consolidated-wsdl/ws2:service"
				mode="service-start" />
			<xsl:if test="not($consolidated-wsdl/*[local-name() = 'service']/@name)">
				<!-- If the WS is without implementation, just with binding points = 
					WS interface -->
				<xsl:apply-templates select="$consolidated-wsdl/ws:binding"
					mode="service-start" />
				<xsl:apply-templates select="$consolidated-wsdl/ws2:interface"
					mode="service" />
			</xsl:if>
		</div>
	</xsl:template>



	<!-- Rendering: WSDL operations - detail -->

	<xsl:template name="operations.render">
		<div class="page">
			<a class="target" name="page.operations">
				<h2>Métodos</h2>
			</a>
			<ul>
				<xsl:apply-templates select="$consolidated-wsdl/ws:portType"
					mode="operations">
					<xsl:sort select="@name" />
				</xsl:apply-templates>

				<xsl:choose>
					<xsl:when test="$consolidated-wsdl/*[local-name() = 'service']/@name">
						<xsl:variable name="iface-name">
							<xsl:apply-templates
								select="$consolidated-wsdl/*[local-name() = 'service']/@interface"
								mode="qname.normalized" />
						</xsl:variable>
						<xsl:apply-templates
							select="$consolidated-wsdl/ws2:interface[@name = $iface-name]"
							mode="operations">
							<xsl:sort select="@name" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$consolidated-wsdl/ws2:interface/@name">


						<!-- TODO: What to do if there are more interfaces? -->

						<xsl:apply-templates select="$consolidated-wsdl/ws2:interface[1]"
							mode="operations" />
					</xsl:when>
					<xsl:otherwise>


						<!-- TODO: Error message or handling somehow this unexpected situation -->

					</xsl:otherwise>
				</xsl:choose>
			</ul>
		</div>
	</xsl:template>

	<!-- Rendering: WSDL and XSD source code files -->
	<xsl:template name="src.render">
		<div class="page full-detail">
			<a class="target" name="page.src">
				<h2><xsl:value-of select="$i18n/service-descriptor"/></h2>
			</a>
			<div class="box source">
				<div class="xml-proc">
					<xsl:text>&lt;?xml version="1.0"?&gt;</xsl:text>
				</div>
				<xsl:apply-templates select="/" mode="src" />
			</div>
			<xsl:apply-templates select="/*/*[local-name() = 'import'][@location]/@location" mode="src.import" />
			<xsl:apply-templates select="$consolidated-wsdl/*[local-name() = 'types']//xsd:import[@schemaLocation]/@schemaLocation | $consolidated-wsdl/*[local-name() = 'types']//xsd:include[@schemaLocation]/@schemaLocation" mode="src.import" />
		</div>
		<div id="wsdl" style="display: none">
			<xsl:copy-of select="/"/> 
		</div>
	</xsl:template>

</xsl:stylesheet>
