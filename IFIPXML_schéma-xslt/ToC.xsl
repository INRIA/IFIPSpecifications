<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- A lancer suite à une requete API http://api.archives-ouvertes.fr/search/?q=collCode_s:IFIP-AICT-419&fl=title_s,authFullName_s,page_s,halId_s&rows=100&wt=xml   -->    
    <xsl:output method="html" version="5.0" encoding="UTF-8"/>
    
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
                <a href="https://hal.inria.fr/IFIP-AICT-419/{ str[@name = 'halId_s'] }"><xsl:value-of select="arr[@name = 'title_s']/str"/></a>
                <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
                <b><i><xsl:apply-templates select="arr[@name = 'authFullName_s']/str"/></i></b>
            </td>
            <td class="page" style="align='right';"><xsl:value-of select="str[@name = 'page_s']"/></td>
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
