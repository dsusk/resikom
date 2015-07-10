<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rk="http://sub.uni-goettingne.de/db/ent/resikom"
    version="2.0">


<!-- work on solr-index-file article output articleID\tID
    -->
    
    

    <xsl:template match="//doc">
    <xsl:choose>
        <xsl:when test="./field[@name='type'] = 'article'">
            <xsl:value-of select="field[@name='article_title']" /><xsl:text>##</xsl:text>
                    <xsl:value-of select="./field[@name='article_id']" />
        </xsl:when>
        <xsl:when test="./field[@name='type'] = 'subarticle'">
            <xsl:value-of select="field[@name='subarticle_title']" />
            <xsl:text>##</xsl:text>
            <xsl:value-of select="./field[@name='subarticle_id']" />                                
        </xsl:when>
    </xsl:choose>
        <xsl:text>##</xsl:text> 
        <xsl:value-of select="field[@name='id']" /><xsl:text>
        </xsl:text>
    </xsl:template>


</xsl:stylesheet>