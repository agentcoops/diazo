<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:esi="http://www.edge-delivery.org/esi/1.0"
    xmlns:xdv="http://namespaces.plone.org/xdv"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    >

    <!--
        Annotate the themes html
    -->

    <xsl:template match="xdv:theme">
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>   
<!--
    <xsl:template match="//xdv:theme//comment()">
        <xsl:element name="xsl:comment"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
-->
    <xsl:template match="//xdv:theme//*">
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="generate-id()"/>-<xsl:value-of select="ancestor::xdv:theme/@href"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="html/@xmlns" priority="5">
        <!-- setting the namespace to xhtml mucks up the included namespaces, so cheat -->
        <xsl:if test="//xdv:*/@method='esi'">
            <!-- when we have another namespace defined, libxml2/xmlsave.c will not magically add the xhtml ns for us -->
            <xsl:element name="xsl:attribute">
                <xsl:attribute name="name">xmlns</xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="pre/text()">
        <!-- Filter out quoted &#13; -->
        <xsl:value-of select="str:replace(., '&#13;&#10;', '&#10;')"/>
    </xsl:template>

    <xsl:template match="style/text()|script/text()">
        <xsl:element name="xsl:variable">
            <xsl:attribute name="name">tag_text</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
        <xsl:element name="xsl:value-of">
            <xsl:attribute name="select">$tag_text</xsl:attribute>
            <xsl:attribute name="disable-output-escaping">yes</xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="//xdv:theme//comment() | //xdv:*[@theme]//comment()">
        <xsl:element name="xsl:comment"><xsl:value-of select="."/></xsl:element>
    </xsl:template>

</xsl:stylesheet>
