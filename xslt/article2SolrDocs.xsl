<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rk="http://sub.uni-goettingne.de/db/ent/resikom"
    version="2.0">
    <!-- exclude-result-prefixes="html xs xlink xd rk TEI" -->
    
    <!--       Es wird eine Artikel-Basierter Solr-Index für HB I (mode=HBI) bzw HBIV (mode ) erstellt -->
    

    <!-- HBI: Artikel sind mit <TEI:head xml:id=Ixxx> gekennzeichnet, xxx entspricht der ID in der DB 
        (Artikel haben jeweils einen Autor und keine Unterartikel)
        Ausnahmebehandlung: Dachartikel Hauptorte - Metropolen im Reich  -->
      
    <xsl:include href="./rk_functions.xsl"/>
    
    <!-- Variable mode-param in MUSS angepasst werden!-->     
    <xsl:variable name="mode-param">HBI</xsl:variable>
    <xsl:variable name="hb-band" select="//TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title" as="xs:string" />
    <xsl:variable name="hb-title" select="//TEI:teiHeader/TEI:fileDesc/TEI:publicationStmt/TEI:p" as="xs:string" />
    <xsl:variable name="handbuch" select="concat($hb-title, ' - ', $hb-band)" />
    <xsl:variable name="hb_subtitle">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">Ein dynastisch-topographisches Handbuch
            </xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">Grafen und Herren</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable> 
    <xsl:variable name="verlag">Jan Thorbecke Verlag</xsl:variable>
    <xsl:variable name="book">
     <xsl:choose>
         <xsl:when test="$mode-param = 'HBI'">I</xsl:when>
         <xsl:when test="$mode-param = 'HBIV'">IV</xsl:when>
         <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    
   <xsl:variable name="isbn">
       <xsl:choose>
           <xsl:when test="$mode-param = 'HBI'">978-3-7995-4515-0</xsl:when>
           <xsl:when test="$mode-param = 'HBIV'">978-3-7995-4525-9</xsl:when>
           <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
       </xsl:choose>
   </xsl:variable>
    
    <xsl:variable name="auflage">
        <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">1. Auflage 2003</xsl:when>
            <xsl:when test="$mode-param = 'HBIV'">1. Auflage 2012</xsl:when>
            <xsl:otherwise>NO_HANDBOOK</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    
    
   <xsl:template match="text()" mode="#default index HBI  HBIV" />    

    <xsl:template match="/">
        <add>
            <xsl:choose>
                <xsl:when test="$mode-param = 'HBI'">
                    <xsl:apply-templates select="//TEI:div" mode="HBI"/>                    
                </xsl:when>
                <xsl:when test="$mode-param = 'HBIV'">
                    <xsl:apply-templates select="//TEI:div" mode="HBIV"/>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message> Not a valid mode, variable mode-param should be HBI or HBIV</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </add>
    </xsl:template>



<!-- DIV template for HB I -->
   <xsl:template match="TEI:div[not(@type)]"  mode="HBI">
    <xsl:choose>
        <xsl:when test="./TEI:head[@xml:id]">  <!-- or contains(./TEI:head, 'HAUPTORTE - METROPOLEN') -->
            <xsl:variable name="article_name" select="./TEI:head"/>
            <xsl:variable name="section_name" select="ancestor::TEI:div/TEI:head"/> 
            <xsl:variable name="author" select="normalize-space(descendant::TEI:div[@type='author'][1])"/>
            <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
            <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                    <xsl:call-template name="doc">
                        <xsl:with-param name="section_name" select="$section_name"/>
                        <xsl:with-param name="article_name" select="$article_name"/>
                        <xsl:with-param name="author" select="$author"/>
                        <xsl:with-param name="articleID" select="$articleID"/>
                        <xsl:with-param name="doc-name" select="$doc-name"/>
                        <xsl:with-param name="node" select=".">
                        </xsl:with-param></xsl:call-template>
        </xsl:when>            
        <xsl:otherwise>
            <xsl:apply-templates select="."/>
        </xsl:otherwise>
    </xsl:choose>

   </xsl:template>
    

<!-- DIV template for HB IV --> 
    <xsl:template match="TEI:div[not(@type)]"  mode="HBIV">
        <xsl:choose>
            <xsl:when test="./TEI:head[@xml:id]">
                <xsl:variable name="doc-name" select="rk:document-name(.)"/>
                <xsl:variable name="section_name" select="./TEI:head"/>                 
                <xsl:variable name="articleID" select="./TEI:head/@xml:id"/>
                <xsl:for-each select="./TEI:div[not(@type)]">
                    <xsl:variable name="article_name" select="./TEI:head"/>
                    <xsl:variable name="author" select="normalize-space(./TEI:div[@type='author'])"/>
                    <xsl:call-template name="doc">
                        <xsl:with-param name="section_name" select="$section_name"/>
                        <xsl:with-param name="article_name" select="$article_name"/>
                        <xsl:with-param name="author" select="$author"/>
                        <xsl:with-param name="articleID" select="$articleID"/>
                        <xsl:with-param name="doc-name" select="$doc-name"/>
                        <xsl:with-param name="node" select=".">
                    </xsl:with-param></xsl:call-template>
                </xsl:for-each>
            </xsl:when>            
            <xsl:otherwise>    <!-- TEST -->
                <xsl:apply-templates select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    
    <xsl:template name="doc">
        <xsl:param name="section_name" />
        <xsl:param name="article_name"/>
        <xsl:param name="author" />
        <xsl:param name="articleID"/>
        <xsl:param name="parentArticleID" />
        <xsl:param name="doc-name" />
        <xsl:param name="node" as="node()"></xsl:param>
       
        <doc><!-- <xsl:text>
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
            <field name="section-title">
                <xsl:value-of select="$section_name"/>
            </field> 
            <field name="article-title">
                <xsl:value-of select="$article_name"/>
            </field>     
            <field name="author">
                <xsl:value-of select="$author"/>
            </field>
            
            <!-- <xsl:if test="$node/TEI:head">
                <field name="article-subtitle">
                    <xsl:value-of select="$node/TEI:head"/>
                </field>
                <xsl:text>
                 </xsl:text>
            </xsl:if> -->
            <xsl:if test="$articleID">
                <field name="articleID">
                    <xsl:value-of select="$articleID"/>
                </field>
            </xsl:if>
            <field name="page-from">
                <xsl:value-of select="preceding::TEI:pb[1]/@n"/>
            </field>
            <field name="page-to">
                <xsl:value-of select="number(following::TEI:pb[1]/@n)-1"/>
            </field>
            
            <!-- muss noch formatiert etc werden -->
            <field name="content">
                <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                <!-- <xsl:value-of select="$node/text()" />--><xsl:apply-templates select="$node" mode="content"/><xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </field>
            <xsl:text>
                 </xsl:text>
            <xsl:apply-templates select=".//TEI:div[@type='graphic']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='graphic_also']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='references']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='sources']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='literature']" mode="index"/>
            <xsl:apply-templates select=".//TEI:div[@type='sources_literature']" mode="index"/>
        </doc>
    </xsl:template>
    
    <!-- text formatter in content field --> 
    
    <xsl:template match="TEI:head[@xml:id]" mode="content" />
        
    <xsl:template match="TEI:head[not(@xml:id)]" mode="content">
        <!-- Tiefe zu attribute class zufügen <xsl:value-of select="count(./ancestor::*) + 1"/> -->
            <xsl:choose>
            <xsl:when test="$mode-param = 'HBI'">
                <xsl:element name="span">
                 <xsl:attribute name="class"> <xsl:value-of select="concat(name(.), ' head', count(./ancestor::*)-5)" /></xsl:attribute>
        <xsl:value-of select="text()" />
        </xsl:element>
        </xsl:when>
        <xsl:when test="$mode-param = 'HBIV'">
            <xsl:if test="not(../../TEI:head[@xml:id])">
                <xsl:element name="span">
                    <xsl:attribute name="class"> <xsl:value-of select="concat(name(.), ' head', count(./ancestor::*)-5)" /></xsl:attribute>
                    <xsl:value-of select="text()" />
                </xsl:element>
            </xsl:if>
        </xsl:when>
        </xsl:choose>
        
     </xsl:template>

    <xsl:template match="TEI:p" mode="content">
        <xsl:element name="span">
            <xsl:attribute name="class"><xsl:value-of select="name(.)"/></xsl:attribute>
            <xsl:apply-templates select="text()|./*" mode="content" /> 
        </xsl:element> 
    </xsl:template>
    
    <xsl:template match="TEI:pb" mode="content">
        <xsl:element name="span">
            <xsl:attribute name="class"><xsl:value-of select="name(.)"/></xsl:attribute>
            <xsl:attribute name="n"><xsl:value-of select="./@n"/></xsl:attribute>
        </xsl:element> 
    </xsl:template>
    
    <xsl:template match="TEI:hi" mode="content">
        <xsl:element name="span">
            <xsl:attribute name="class"><xsl:value-of select="./@rend" /></xsl:attribute>
            <xsl:value-of select ="." />
        </xsl:element> 
    </xsl:template>

    <xsl:template match="TEI:div[@type='graphic' or @type='author']" mode="content" />
    <xsl:template match="TEI:div[@type='references' or @type='literature' or @type='sources' or @type='sources_literature']" mode="content" />
    <xsl:template match="TEI:div[@type='graphic' or @type='graphic_also']" mode="content" />
   <!--  <xsl:template match="TEI:head" mode="content" /> -->
        
        
    <xsl:template match="TEI:div[@type='sources']" mode="index">
        <field name="sources">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text><xsl:apply-templates select="text()|./*" mode="content" /> <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
        <xsl:text>
                 </xsl:text>
    </xsl:template>
   
    <xsl:template match="TEI:div[@type='literature']" mode="index">
        <field name="literature">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text><xsl:apply-templates select="text()|./*" mode="content" /> <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>            
        </field>
        <xsl:text>
                 </xsl:text>
    </xsl:template>
    
    <xsl:template match="TEI:div[@type='sources_literature']" mode="index">
        <field name="literature_sources">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text><xsl:apply-templates select="text()|./*" mode="content" /> <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </field>
        <xsl:text>
                 </xsl:text>
    </xsl:template>
       

    
</xsl:stylesheet>