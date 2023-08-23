<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- A lancer suite à une requete API http://api.archives-ouvertes.fr/search/?q=collCode_s:IFIP-XXXXXX&fl=fl=title_s,authFullName_s,page_s,comment_s,halId_s,docType_s,volume_s&rows=100&wt=xml   -->    
    <xsl:output method="html" version="5.0" encoding="UTF-8"/>
    <!-- Calcul du nom de la collection pour les liens href -->
    <xsl:variable name="CollName">
        <xsl:text>IFIP-</xsl:text>
        <xsl:value-of select="//doc/str[@name='docType_s'][.='PROCEEDINGS' or .='OUV']/parent::node()/str[@name='volume_s']"/>
    </xsl:variable>
    <xsl:variable name="document">
        <xsl:copy-of select="/"></xsl:copy-of>
    </xsl:variable>
    <xsl:template match="/">
     <html>
        <body>
            <h1>Table of Contents</h1>
            <xsl:text disable-output-escaping="yes">&lt;hr/&gt;</xsl:text>
            <table style="width='63%';border='0'; cellspacing='20';cellpadding='20';">
                <!--xsl:apply-templates select="//doc" mode='affOUV'/-->
                <xsl:apply-templates select="//doc/str[@name='docType_s'][.='PROCEEDINGS']/parent::node() or //doc/str[@name='docType_s'][.='OUV']/parent::node()" />
                <xsl:for-each select="distinct-values(//doc/str[@name='comment_s'])">
                    <xsl:sort select="number(substring-after(substring-before(.,':'),'Part '))"  order="ascending"></xsl:sort>
                    <xsl:call-template name="addPart">
                        <xsl:with-param name="partName">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>    
                    <!--xsl:apply-templates select="."/-->                    
                </xsl:for-each>

            </table>
        </body>
    </html>
    </xsl:template>
    
    <xsl:template match="str[@name='comment_s']">
        <xsl:value-of select="."></xsl:value-of>
    </xsl:template>
    <xsl:template match="doc">
        <tr style="valign='top';">
            <td style="align='left';">
                <!--a href="https://ifip.hal.science/IFIP-AICT-419/{ str[@name = 'halId_s'] }"><xsl:value-of select="arr[@name = 'title_s']/str"/></a-->
                <a href="https://ifip.hal.science/{$CollName}/{ str[@name = 'halId_s'] }"><xsl:value-of select="arr[@name = 'title_s']/str"/></a>
                
                <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
                <b><i><xsl:apply-templates select="arr[@name = 'authFullName_s']/str"/></i></b>
            </td>
            <xsl:choose>
                <xsl:when test="./str[@name='docType_s'] = 'PROCEEDINGS'">
                    <td class="page" style="text-align: right;" valign="top">Front Matter</td>
                </xsl:when>
                <xsl:when test="./str[@name='docType_s'] ='OUV'">
                    <td class="page" style="text-align: right;" valign="top">Front Matter</td>
                </xsl:when>
                <xsl:otherwise>
                    <td class="page" style="text-align: right;" valign="top"><xsl:value-of select="str[@name = 'page_s']"/></td>
                </xsl:otherwise>
            </xsl:choose>
            
        </tr>
    </xsl:template>
    
    <!--xsl:template match="doc" mode='affOUV'>
        <xsl:if test="./str[@name='docType_s'] = 'OUV'">
            <xsl:apply-templates select="." mode='affDoc'></xsl:apply-templates>
        </xsl:if>
    </xsl:template-->
    <xsl:template match="arr[@name = 'authFullName_s']/str[last()]" priority="1">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="arr[@name = 'authFullName_s']/str" priority="0">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text> 
    </xsl:template>
    <xsl:template name="addPart">
        <xsl:param name="partName"/>
        <tr style="valign='top';"><td style="align='left';" colspan="2">
            <hr /><h2 style="text-align: left;">
                <xsl:value-of select="substring-after(.,':')"></xsl:value-of>
            <hr /></h2>
        </td></tr>
        <xsl:for-each select="$document//doc/str[@name='comment_s'][.= $partName ]/parent::node()">
            <!--xsl:copy-of select="."></xsl:copy-of-->
            <xsl:sort select="number(substring-before(str[@name = 'page_s'],'-'))"  order="ascending"></xsl:sort>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
         
    </xsl:template>
</xsl:stylesheet>
