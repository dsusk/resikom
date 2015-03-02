<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rk="http://sub.uni-goettingne.de/db/ent/resikom"
    version="2.0">
    <!-- exclude-result-prefixes="html xs xlink xd rk TEI" -->

    <xsl:include href="./rk_functions.xsl"/>

    <!-- SELECT mode-param for the resp. Handbook (HBI, HBII, HBIII, HBIV)-->
    <xsl:variable name="mode-param">HBII</xsl:variable>
    <xsl:variable name="hb-band" select="//TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title"
        as="xs:string"/>
    <xsl:variable name="hb-title" select="//TEI:teiHeader/TEI:fileDesc/TEI:publicationStmt/TEI:p"
        as="xs:string"/>
    <xsl:variable name="handbuch" select="concat($hb-title, ' - ', $hb-band)"/>
    <xsl:variable name="hb_subtitle">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">Ein dynastisch-topographisches Handbuch</xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">Grafen und Herren</xsl:when>
            <xsl:when test="$mode-param = 'HBII'">Bilder und Begriffe</xsl:when>
            <xsl:when test="$mode-param = 'HBIII'">Hof und Schrift</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="verlag">Jan Thorbecke Verlag</xsl:variable>
    <xsl:variable name="book">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">I</xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">IV</xsl:when>
            <xsl:when test="$mode-param = 'HBII'">II</xsl:when>
            <xsl:when test="$mode-param = 'HBIII'">III</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="isbn">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">978-3-7995-4515-0</xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">978-3-7995-4525-9</xsl:when>
            <xsl:when test="$mode-param = 'HBII'">978-3-7995-4519-8 </xsl:when>
            <xsl:when test="$mode-param = 'HBIII'">978-3-7995-4522-8</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="auflage">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">1. Auflage 2003</xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">1. Auflage 2012</xsl:when>
            <xsl:when test="$mode-param = 'HBII'">1. Auflage 2007</xsl:when>
            <xsl:when test="$mode-param = 'HBIII'">1. Auflage 2005</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="text()" mode="#default index HBI  HBIV HBII HBIII"/>

    <xsl:template match="/">
        <add>
            <xsl:choose>
                <xsl:when test="$mode-param = 'HBI'">
                    <xsl:apply-templates select="//TEI:div" mode="HBI"/>
                </xsl:when>
                <xsl:when test="$mode-param = 'HBIV'">
                    <xsl:apply-templates select="//TEI:div" mode="HBIV"/>
                </xsl:when>
                <xsl:when test="$mode-param = 'HBII'">
                    <xsl:apply-templates select="//TEI:div" mode="HBII"/>
                </xsl:when>
                <xsl:when test="$mode-param = 'HBIII'">
                    <!-- Dachartikel in //front, rest in body -->
                    <xsl:apply-templates select="//TEI:front//TEI:div" mode="HBIII"/>
                    <xsl:apply-templates select="//TEI:body//TEI:div" mode="HBIII"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:message> Not a valid mode, variable mode-param should be HBI or
                        HBIV</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </add>
    </xsl:template>

    <!-- DIV template for HB I -->
    <xsl:template match="TEI:div[not(@type)]" mode="HBI">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id]">
                <xsl:variable name="article_name" select="./TEI:head"/>
                <xsl:variable name="section_name" select="ancestor::TEI:div/TEI:head"/>
                <xsl:variable name="author"
                    select="normalize-space(descendant::TEI:div[@type='author'][1])"/>
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:call-template name="doc">
                    <xsl:with-param name="section_name" select="$section_name"/>
                    <xsl:with-param name="article_name" select="$article_name"/>
                    <xsl:with-param name="author" select="$author"/>
                    <xsl:with-param name="articleID" select="$articleID"/>
                    <xsl:with-param name="doc-name" select="$doc-name"/>
                    <xsl:with-param name="node" select="."> </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>

    </xsl:template>


    <!-- DIV template for HB IV -->
    <xsl:template match="TEI:div[not(@type)]" mode="HBIV">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id]">
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:variable name="section_name" select="./TEI:head"/>
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:for-each select="./TEI:div[not(@type)]">
                    <xsl:variable name="article_name" select="$section_name"/>
                    <xsl:variable name="subarticle_name" select="./TEI:head"/>
                    <xsl:variable name="subarticleID"
                        select="concat($articleID, substring(./TEI:head,1,1))"/>
                    <xsl:variable name="author" select="normalize-space(./TEI:div[@type='author'])"/>
                    <xsl:call-template name="doc">
                        <xsl:with-param name="section_name" select="$section_name"/>
                        <xsl:with-param name="article_name" select="$article_name"/>
                        <xsl:with-param name="author" select="$author"/>
                        <xsl:with-param name="articleID" select="$articleID"/>
                        <xsl:with-param name="subarticleID" select="$subarticleID"/>
                        <xsl:with-param name="subarticle_name" select="$subarticle_name"/>
                        <xsl:with-param name="doc-name" select="$doc-name"/>
                        <xsl:with-param name="node" select="."> </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- TEST -->
                <!-- <xsl:apply-templates select="."/> -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="TEI:div[not(@type)]" mode="HBIII">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id]">
                <xsl:variable name="article_name" select="./TEI:head"/>
                <!-- ?-->
                <xsl:variable name="section_name" select="ancestor::TEI:div/TEI:head"/>
                <xsl:variable name="author"
                    select="normalize-space(descendant::TEI:div[@type='author'][1])"/>
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:call-template name="doc">
                    <xsl:with-param name="article_name" select="$article_name"/>
                    <xsl:with-param name="author" select="$author"/>
                    <xsl:with-param name="articleID" select="$articleID"/>
                    <xsl:with-param name="doc-name" select="$doc-name"/>
                    <xsl:with-param name="node" select="."> </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="TEI:div[not(@type)]" mode="HBII">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id]">
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:variable name="section_name" select="ancestor::TEI:div/TEI:head[1]"/>
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:variable name="article_name" select="./TEI:head"/>
                <xsl:variable name="author"
                    select="normalize-space(descendant::TEI:div[@type='author'][1])"/>
                <xsl:choose>
                    <xsl:when test="./TEI:div/descendant::TEI:head[@xml:id]">
                        <!-- BEGRIFFE: copy all chid divs without head@xml:id -->
                        <xsl:variable name="N" as="node()*">
                            <xsl:element name="TEI:div">
                                <xsl:apply-templates select="./*" mode="HBII-inner"/>
                            </xsl:element>
                        </xsl:variable>
                        <xsl:call-template name="doc">
                            <xsl:with-param name="section_name" select="$section_name"/>
                            <xsl:with-param name="article_name" select="$article_name"/>
                            <xsl:with-param name="author" select="$author"/>
                            <xsl:with-param name="articleID" select="$articleID"/>
                            <xsl:with-param name="doc-name" select="$doc-name"/>
                            <xsl:with-param name="node" select="$N"/>
                        </xsl:call-template>

                        <!-- UNTERBEGRIFFE -->
                        <xsl:for-each select="./TEI:div[not(@type)]">
                            <xsl:choose>
                                <xsl:when test="./TEI:head[@xml:id]">
                                    <xsl:variable name="subarticleID" select="./TEI:head/@xml:id"/>
                                    <xsl:variable name="subarticle_name" select="./TEI:head"/>
                                    <xsl:variable name="author"
                                        select="normalize-space(descendant::TEI:div[@type='author'][1])"/>
                                    <xsl:call-template name="doc">
                                        <xsl:with-param name="section_name" select="$section_name"/>
                                        <xsl:with-param name="article_name" select="$article_name"/>
                                        <xsl:with-param name="author" select="$author"/>
                                        <xsl:with-param name="articleID" select="$articleID"/>
                                        <xsl:with-param name="doc-name" select="$doc-name"/>
                                        <xsl:with-param name="node" select="."/>
                                        <xsl:with-param name="subarticleID" select="$subarticleID"/>
                                        <xsl:with-param name="subarticle_name"
                                            select="$subarticle_name"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="not(contains(./TEI:head/@xml:id, 'IIub'))">
                        <!-- No Unterbegriffe in this articele -->
                        <xsl:call-template name="doc">
                            <xsl:with-param name="section_name" select="$section_name"/>
                            <xsl:with-param name="article_name" select="$article_name"/>
                            <xsl:with-param name="author" select="$author"/>
                            <xsl:with-param name="articleID" select="$articleID"/>
                            <xsl:with-param name="doc-name" select="$doc-name"/>
                            <xsl:with-param name="node" select="."/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="TEI:div" mode="HBII-inner">
        <xsl:choose>
            <xsl:when test="./TEI:head[not(@xml:id)] and not(contains(../TEI:head/@xml:id, 'IIub'))">
                <xsl:copy-of select="."/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="TEI:p|pb|hi" mode="HBII-inner">
        <xsl:copy-of select="." />
    </xsl:template>
    
    <xsl:template match="TEI:head[@xml:id]" mode="HBII-inner" />
        

    <xsl:template name="doc">
        <xsl:param name="section_name"/>
        <xsl:param name="article_name"/>
        <xsl:param name="author"/>
        <xsl:param name="articleID"/>
        <xsl:param name="doc-name"/>
        <xsl:param name="node" as="node()"/>
        <xsl:param name="subarticleID"/>
        <xsl:param name="subarticle_name"/>

        <doc>
            <!-- <xsl:text>
            </xsl:text> -->
            <field name="id">
                <xsl:value-of select="concat($doc-name, '-',count(preceding::TEI:div))"/>
            </field>
            <!--   <xsl:text>
                 </xsl:text> -->
            <field name="doc-name">
                <xsl:value-of select="$doc-name"/>
            </field>
            <field name="book">
                <xsl:value-of select="$book"/>
            </field>
            <field name="book-title">
                <xsl:value-of select="$handbuch"/>
            </field>
            <field name="book-subtitle">
                <xsl:value-of select="$hb_subtitle"/>
            </field>

            <field name="verlag">
                <xsl:value-of select="$verlag"/>
            </field>

            <field name="isbn">
                <xsl:value-of select="$isbn"/>
            </field>
            <field name="auflage">
                <xsl:value-of select="$auflage"/>
            </field>
            <field name="type">
                <xsl:text>article</xsl:text>
            </field>
            <field name="path">
                <xsl:value-of select="rk:generate-xpath($node, true())"/>
            </field>
            <xsl:if test="$section_name">
                <field name="section-title">
                    <xsl:value-of select="$section_name"/>
                </field>
            </xsl:if>
            <field name="article-title">
                <xsl:value-of select="$article_name"/>
            </field>
            <field name="author">
                <xsl:value-of select="$author"/>
            </field>
            <xsl:if test="$articleID">
                <field name="articleID">
                    <xsl:value-of select="$articleID"/>
                </field>
            </xsl:if>
            <xsl:if test="$subarticleID">
                <field name="subArticleID">
                    <xsl:value-of select="$subarticleID"/>
                </field>
            </xsl:if>
            <xsl:if test="$subarticle_name">
                <field name="subArticle-title">
                    <xsl:value-of select="$subarticle_name"/>
                </field>
            </xsl:if>

            <field name="page-from">
                <xsl:value-of select="preceding::TEI:pb[1]/@n"/>
            </field>
            <field name="page-to">
                <xsl:value-of select="number(following::TEI:pb[1]/@n)-1"/>
            </field>
            <field name="content">
                <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                <xsl:apply-templates select="$node" mode="content"/>
                <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </field>
            <xsl:text>
                 </xsl:text>
            <!-- <xsl:apply-templates select=".//TEI:div[@type='graphic']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='graphic_also']" mode="index"/> -->
            <xsl:apply-templates select=".//TEI:div[@type='references']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='sources']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='literature']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='sources_literature']" mode="index"/>
        </doc>
    </xsl:template>

    <!-- text formatter in content field -->
    <xsl:template match="TEI:head[@xml:id]" mode="content"/>
    <xsl:template match="TEI:head[not(@xml:id)]" mode="content">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">
                <xsl:variable name="element" select="concat('h', count(./ancestor::*)-5)"/>
                <xsl:element name="{$element}">
                    <xsl:value-of select="text()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">
                <xsl:if test="not(../../TEI:head[@xml:id])">
                    <xsl:variable name="element" select="concat('h', count(./ancestor::*)-6)"/>
                    <xsl:element name="{$element}">
                        <xsl:value-of select="text()"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$mode-param = 'HBII'">
                <xsl:variable name="element" select="concat('h', count(./ancestor::*))"/>
                   <xsl:element name="{$element}">
                    <xsl:value-of select="text()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$mode-param = 'HBIII'">
                <xsl:variable name="element" select="concat('h', count(./ancestor::*)-3)"/>
                <xsl:element name="{$element}">
                    <xsl:value-of select="text()"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="TEI:p" mode="content">
        <xsl:variable name="element" select="name(.)"/>
        <xsl:element name="{$element}">
            <xsl:apply-templates select="text()|./*" mode="content"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="TEI:pb" mode="content"/>

    <xsl:template match="TEI:hi" mode="content">
        <xsl:choose>
            <xsl:when test="@rend = 'italic'">
                <xsl:element name="i">
                    <xsl:apply-templates select="text()|./*" mode="content"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- smallCaps -->
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:value-of select="./@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="text()|./*" mode="content"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="TEI:div[@type='graphic' or @type='author']" mode="content"/>

    <xsl:template
        match="TEI:div[@type='references' or @type='literature' or @type='sources' or @type='sources_literature']"
        mode="content"/>

    <xsl:template match="TEI:figure" mode="content"/>

    <xsl:template match="TEI:div[@type='sources']" mode="index">
        <field name="sources">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:apply-templates select="text()|./*" mode="content"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
        <xsl:text>
                 </xsl:text>
    </xsl:template>
    <xsl:template match="TEI:div[@type='literature']" mode="index">
        <field name="literature">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:apply-templates select="text()|./*" mode="content"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
        <xsl:text>
                 </xsl:text>
    </xsl:template>
    <xsl:template match="TEI:div[@type='sources_literature']" mode="index">
        <field name="literature_sources">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:apply-templates select="text()|./*" mode="content"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
        <xsl:text>
                 </xsl:text>
    </xsl:template>
    <xsl:template match="TEI:div[@type='references']" mode="index" />
        
    

</xsl:stylesheet>