<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:rk="http://sub.uni-goettingne.de/db/ent/resikom"
    version="2.0">
    
    
    
    <!-- Get file name of a node -->
    <xsl:function name="rk:document-name" as="xs:string">
        <xsl:param name="node" as="node()"/>
        <xsl:choose>
            <xsl:when test="document-uri(root($node)) != ''">
                <xsl:value-of select="rk:uri-to-name(document-uri(root($node)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="rk:uri-to-name" as="xs:string">
        <xsl:param name="uri" as="xs:string"/>
        <xsl:variable name="file-name" select="replace($uri, '^.*/(.*)$', '$1')" as="xs:string"/>
        <xsl:value-of select="replace($file-name, '^(.*?)\.[^.]*$', '$1')"/>
    </xsl:function>
    
    
    
    
    <xsl:function name="rk:chunk">
        <xsl:param name="ms1" as="element()"/>
        <xsl:param name="ms2" as="element()"/>
        <xsl:param name="node" as="node()"/>
        <xsl:choose>
            <xsl:when test="$node instance of element()">
                <xsl:choose>
                    <xsl:when test="$node is $ms1">
                        <xsl:copy-of select="$node"/>
                    </xsl:when>
                    <xsl:when test="some $n in $node/descendant::* satisfies ($n is $ms1 or $n is $ms2)">
                        <xsl:element name="{local-name($node)}" namespace="{namespace-uri($node)}">
                            <xsl:for-each select="$node/node() | $node/@*">
                                <xsl:copy-of select="rk:chunk($ms1, $ms2, .)"/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$node &gt;&gt; $ms1 and $node &lt;&lt; $ms2">
                        <xsl:copy-of select="$node"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$node instance of attribute()">
                <xsl:copy-of select="$node"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$node &gt;&gt; $ms1 and $node &lt;&lt; $ms2">
                    <xsl:copy-of select="$node"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    
    <xsl:function name="rk:generate-xpath">
        <xsl:param name="node" as="node()"/>
        <xsl:param name="numbers" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$numbers">
                <xsl:for-each select="$node/ancestor::*">
                    <xsl:value-of select="name()"/>
                    <xsl:variable name="parent" select="."/>
                    <xsl:variable name="siblings" select="count(preceding-sibling::*[name()=name($parent)])"/>
                    <xsl:if test="$siblings">
                        <xsl:value-of select="concat('[', $siblings + 1, ']')"/>
                    </xsl:if>
                    <xsl:value-of select="'/'"/>
                </xsl:for-each>
                <xsl:value-of select="name($node)"/>
                <xsl:variable name="siblings" select="count($node/preceding-sibling::*[name()=name($node)])"/>
                <xsl:if test="$siblings">
                    <xsl:value-of select="concat('[', $siblings + 1, ']')"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$node/ancestor::*/name()" separator="/"/>
                <xsl:value-of select="concat('/', name($node))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
</xsl:stylesheet>