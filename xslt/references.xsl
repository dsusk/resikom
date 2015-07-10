<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rk="http://sub.uni-goettingne.de/db/ent/resikom"
    version="2.0">


    <xsl:include href="./rk_functions.xsl"/>
    <xsl:template match="text()" mode="#all"/>

    <xsl:variable name="mode-param">HBI</xsl:variable>
    <!-- no-header oder header -->
    <xsl:variable name="mode-param2">no-header</xsl:variable>
    <xsl:variable name="book">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">I</xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">IV</xsl:when>
            <xsl:when test="$mode-param = 'HBII'">II</xsl:when>
            <xsl:when test="$mode-param = 'HBIII'">III</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$mode-param2='header'">
                <xsl:call-template name="writeHeader"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>
        </xsl:text>
                <xsl:choose>
                    <xsl:when test="$mode-param='HBI'">
                        <xsl:apply-templates select="//TEI:div" mode="HBI"/>
                    </xsl:when>
                    <xsl:when test="$mode-param='HBII'">
                        <xsl:apply-templates select="//TEI:div[@type='references']" mode="HBII"/>
                    </xsl:when>
                    <xsl:when test="$mode-param='HBIII'">
                        <xsl:apply-templates select="//TEI:div" mode="HBIII"/>
                    </xsl:when>
                    <xsl:when test="$mode-param='HBIV'">
                        <xsl:apply-templates select="//TEI:div[@type='references']" mode="HBIV"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="TEI:div[not(@type)]" mode="HBI">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id]">
               <!--  <xsl:variable name="article_name" select="./TEI:head"/>
                <xsl:variable name="section_name" select="ancestor::TEI:div/TEI:head"/>
                <xsl:variable name="author"
                    select="normalize-space(descendant::TEI:div[@type='author'][1])"/> -->
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:variable name="path" select="rk:generate-xpath(., true())"/>
                
                <xsl:variable name="allRefs" select="(descendant::TEI:div[@type='references'])[1]" />
                <xsl:variable name="refs" select="replace($allRefs, '&#x00A0;', '')"/>
                <xsl:variable name="ref_seq" select="tokenize($refs, '→')"/>
                
                <xsl:for-each select="$ref_seq">
                    <xsl:variable name="r" select="replace(normalize-space(.), '&#x2009;', '')" />
                    <xsl:choose>
                        <xsl:when test="$r != ''">
                            
                            <xsl:variable name="k" select="replace(normalize-space($r), '(,.*)| (\[.*\]) | \(.*\)', '')" />
                            <xsl:variable name="key">
                                <xsl:value-of select="substring-after($k, '. ')" />
                            </xsl:variable>
                    <xsl:call-template name="doc">
                        <xsl:with-param name="doc-name" select="$doc-name"/>
                        <xsl:with-param name="path" select="$path" />
                        <xsl:with-param name="articleID" select="$articleID"/>
                        <xsl:with-param name="reference" select="normalize-space($r)"/>
                        <xsl:with-param name="counter" select="position()"/>
                        <xsl:with-param name="key" select="$key"/>    
                    </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="TEI:div[@type='references']" mode="HBII">
        <xsl:variable name="doc-name" select="rk:document-name(.)"/>
        <xsl:variable name="path" select="rk:generate-xpath(., true())"/>
        <xsl:variable name="heads" select="ancestor::TEI:div/TEI:head[@xml:id]" />
        <xsl:variable name="articleID" select="$heads[last()]/@xml:id"/>
        <!-- <xsl:value-of select="$heads[last()]" /> -->


        <xsl:variable name="allRefs" select="." />
        <xsl:variable name="refs" select="replace($allRefs, '&#x00A0;', '')"/>
        <xsl:variable name="ref_seq" select="tokenize($refs, '→')"/>
        
        <xsl:for-each select="$ref_seq">
            <xsl:variable name="r" select="replace(normalize-space(.), '&#x2009;', '')" />
            <xsl:choose>
                <xsl:when test="$r != ''">
                    <xsl:variable name="key">
                        <xsl:choose>
                            <xsl:when test="contains($r, ';')">
                                <xsl:value-of select="normalize-space(substring-after($r, ';'))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(substring-after($r, '.'))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
            
        <xsl:call-template name="doc">
            <xsl:with-param name="doc-name" select="$doc-name"/>
            <xsl:with-param name="path" select="$path" />
            <xsl:with-param name="articleID" select="$articleID"/>
            <xsl:with-param name="reference" select="normalize-space($r)"/>
            <xsl:with-param name="counter" select="position()"/>
            <xsl:with-param name="key" select="$key"/>    
            
        </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        
       <!--  <xsl:value-of select="." /> -->
    </xsl:template>



    <xsl:template match="TEI:div[@type='references']" mode="HBIV">
        
        <xsl:variable name="heads" select="ancestor::TEI:div/TEI:head[@xml:id]" />
        <xsl:variable name="articleID" select="$heads[last()]/@xml:id"/> 
        <!-- <xsl:variable name="articleID" select="parent::TEI:div/TEI:head/@xml:id"/> -->
        <xsl:variable name="doc-name" select="rk:document-name(.)"/>
        <xsl:variable name="path" select="rk:generate-xpath(., true())"/>
        
        <xsl:variable name="allRefs" select="." />
        <xsl:variable name="refs" select="replace($allRefs, '&#x00A0;', '')"/>
        <xsl:variable name="ref_seq" select="tokenize($refs, '→')"/>
        <xsl:for-each select="$ref_seq">
            <xsl:variable name="r" select="replace(normalize-space(.), '&#x2009;', '')" />
            <xsl:choose>
                <xsl:when test="$r != ''">
                    
                    <xsl:variable name="k" select="replace(normalize-space($r), '(,.*)| (\[.*\]) | \(.*\)', '')" />
                    <xsl:variable name="key">
                        <xsl:value-of select="substring-after($k, '. ')" />
                    </xsl:variable>                    
        <xsl:call-template name="doc">
            <xsl:with-param name="doc-name" select="$doc-name"/>
            <xsl:with-param name="path" select="$path" />
            <xsl:with-param name="articleID" select="$articleID"/>
            <xsl:with-param name="reference" select="normalize-space($r)"/>
            <xsl:with-param name="counter" select="position()"/>
            <xsl:with-param name="key" select="$key"/>    
        </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        
    </xsl:template>

   <!-- <xsl:template match="TEI:div[not(@type)]" mode="HBIV">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id] and not(.//TEI:head[@xml:id])">
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:variable name="path" select="rk:generate-xpath(., true())"/>
                
                <xsl:variable name="allRefs" select="(descendant::TEI:div[@type='references'])[1]" />
                <xsl:variable name="refs" select="replace($allRefs, '&#x00A0;', '')"/>
                <xsl:variable name="ref_seq" select="tokenize($refs, '→')"/>
                
                <xsl:for-each select="$ref_seq">
                    <xsl:variable name="r" select="replace(normalize-space(.), '&#x2009;', '')" />
                    <xsl:choose>
                        <xsl:when test="$r != ''">
                            
                            <xsl:variable name="k" select="replace(normalize-space($r), '(,.*)| (\[.*\]) | \(.*\)', '')" />
                            <xsl:variable name="key">
                                <xsl:value-of select="substring-after($k, '. ')" />
                            </xsl:variable>
                            <xsl:call-template name="doc">
                                <xsl:with-param name="doc-name" select="$doc-name"/>
                                <xsl:with-param name="path" select="$path" />
                                <xsl:with-param name="articleID" select="$articleID"/>
                                <xsl:with-param name="reference" select="normalize-space($r)"/>
                                <xsl:with-param name="counter" select="position()"/>
                                <xsl:with-param name="key" select="$key"/>    
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template> -->


    <xsl:template name="doc">
        <xsl:param name="articleID"/>
        <xsl:param name="doc-name"/>
        <xsl:param name="path" />
        <xsl:param name="subarticleID"/>
        <xsl:param name="reference"/>
        <xsl:param name="counter"/>
        <xsl:param name="key"/>
        <doc>
            <field name="id">
                <xsl:value-of
                    select="concat($doc-name, '-ref-',$articleID, $counter)"/>
            </field>
            <field name="docname">
                <xsl:value-of select="$doc-name"/>
            </field>
            <field name="book">
                <xsl:value-of select="$book"/>
            </field>
            <field name="type">
                <xsl:text>reference</xsl:text>
            </field>
            <field name="article_id">
                <xsl:value-of select="$articleID"/>
            </field>
            <field name="path"> </field>
            <field name="article_reference">
                <xsl:value-of select="$reference"/>
            </field>
            <field name="keyword">
                <xsl:value-of select="$key"/>
            </field>
            <xsl:if test="$subarticleID">
                <field name="subarticle_id">
                    <xsl:value-of select="$subarticleID"/>
                </field>
            </xsl:if>
        </doc>
        <xsl:text>
        </xsl:text>

    </xsl:template>


    <xsl:template name="writeHeader">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI' or $mode-param = 'HBII'">
                <xsl:variable name="A" select="//TEI:body[1]/TEI:div[2]//TEI:head[@xml:id]"/>
                <xsl:variable name="B" select="//TEI:body[1]/TEI:div[3]/TEI:head[@xml:id]"/>
                <xsl:variable name="C" select="//TEI:body[1]/TEI:div[4]//TEI:head[@xml:id]"/>
                <xsl:for-each select="$A">
                    <xsl:text>A##</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>##</xsl:text>
                    <xsl:value-of select="./@xml:id"/>
                    <xsl:text>
            </xsl:text>
                </xsl:for-each>
                <xsl:for-each select="$B">
                    <xsl:text>B##</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>##</xsl:text>
                    <xsl:value-of select="./@xml:id"/>
                    <xsl:text>
            </xsl:text>
                </xsl:for-each>
                <xsl:for-each select="$C">
                    <xsl:text>C##</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>##</xsl:text>
                    <xsl:value-of select="./@xml:id"/>
                    <xsl:text>
            </xsl:text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise> <!-- HB IV -->
                <xsl:apply-templates select="//TEI:body[1]//TEI:head[@xml:id]" mode="HBIV"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- <xsl:template match="TEI:head[@xml:id]" mode="HBIV">
        <xsl:value-of select="."/>
        <xsl:text>##</xsl:text>
        <xsl:value-of select="./@xml:id"/>
        <xsl:text>
            </xsl:text>
    </xsl:template>
    -->

</xsl:stylesheet>