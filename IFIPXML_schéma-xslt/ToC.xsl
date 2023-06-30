<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- A lancer suite à une requete API https://api.archives-ouvertes.fr/search/?q=collCode_s:IFIP-XXXXXX&fl=title_s,authFullName_s,page_s,comment_s,halId_s,docType_s,volume_s&rows=100&wt=xml   -->    
    <xsl:output method="html" version="5.0" encoding="UTF-8"/>
    <!-- Calcul du nom de la collection pour les liens href -->
    <xsl:variable name="CollName">
        <xsl:text>IFIP-</xsl:text>
        <xsl:value-of select="//doc/str[@name='docType_s'][.='PROCEEDINGS']/parent::node()/str[@name='volume_s']"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <html>
            <body>
                <strong>Table of Contents</strong>
                <xsl:text disable-output-escaping="yes">&lt;hr/&gt;</xsl:text>
                <table style="width='63%';border='0'; cellspacing='20';cellpadding='20';">
                    <xsl:for-each select="//doc">
                        <xsl:sort select="number(substring-before(str[@name = 'page_s'],'-'))"  order="ascending"></xsl:sort>
                        <xsl:apply-templates select="."/>                    
                    </xsl:for-each>

                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="doc">
        <tr style="valign='top';">
            <td style="align='left';">
                <a href="https://ifip.hal.science/{$CollName}/{ str[@name = 'halId_s'] }"><xsl:value-of select="arr[@name = 'title_s']/str"/></a>
                <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
                <b><i><xsl:apply-templates select="arr[@name = 'authFullName_s']/str"/></i></b>
            </td>
            <!--td class="page" style="text-align: right;" valign="top"><xsl:value-of select="str[@name = 'page_s']"/></td-->
            
            <xsl:choose>
                <xsl:when test="./str[@name='docType_s'] = 'OUV'">
                    <td class="page" style="text-align: right;" valign="top">Front Matter</td>
                </xsl:when>
                <xsl:otherwise>
                    <td class="page" style="text-align: right;" valign="top"><xsl:value-of select="str[@name = 'page_s']"/></td>
                </xsl:otherwise>
            </xsl:choose>
            
        </tr>
    </xsl:template>
    
    <xsl:template match="arr[@name = 'authFullName_s']/str[last()]" priority="1">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="arr[@name = 'authFullName_s']/str" priority="0">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text> 
    </xsl:template>
    
</xsl:stylesheet>
