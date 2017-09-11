<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- A lancer suite à une requete API http://api.archives-ouvertes.fr/search/?q=collCode_s:IFIP-AICT-419&fl=title_s,authFullName_s,page_s,halId_s&rows=100&wt=xml   -->    
    <xsl:output method="html" version="5.0" encoding="UTF-8"/>
    <xsl:variable name="document">
        <xsl:copy-of select="/"></xsl:copy-of>
    </xsl:variable>
    <xsl:template match="/">
        <html>
            <body>
                <h1>Table of Contents</h1>
                <xsl:text disable-output-escaping="yes">&lt;hr/&gt;</xsl:text>
                <table style="width='63%';border='0'; cellspacing='20';cellpadding='20';">
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
                <a href="https://hal.inria.fr/IFIP-LNCS-4980/{ str[@name = 'halId_s'] }"><xsl:value-of select="arr[@name = 'title_s']/str"/></a>
                <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
                <b><i><xsl:apply-templates select="arr[@name = 'authFullName_s']/str"/></i></b>
            </td>
            <td class="page" style="text-align: right;" valign="top"><xsl:value-of select="str[@name = 'page_s']"/></td>
        </tr>
    </xsl:template>
    
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
            <xsl:value-of select="$partName"></xsl:value-of>
                <hr /></h2>
        </td></tr>
        <xsl:for-each select="$document//doc/str[@name='comment_s'][.= $partName ]/parent::node()">
            <!--xsl:copy-of select="."></xsl:copy-of-->
            <xsl:sort select="number(substring-before(str[@name = 'page_s'],'-'))"  order="ascending"></xsl:sort>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
         
    </xsl:template>
</xsl:stylesheet>
