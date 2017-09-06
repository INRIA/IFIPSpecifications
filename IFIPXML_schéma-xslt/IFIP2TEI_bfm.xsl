<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:variable name="countryCodes" select="document('CountryCodes.xml')"/>
   
    <xsl:variable name="volumeNb">
        <xsl:value-of
            select="/Publisher/Series/Book/BookInfo/BookVolumeNumber"/>
    </xsl:variable>
    <xsl:variable name="collection">
        <xsl:choose>
            <xsl:when
                test="contains(Publisher/Series/SeriesInfo/SeriesTitle, 'IFIP Advances')"
                >AICT</xsl:when>
            <xsl:when
                test="contains(/Publisher/Series/SeriesInfo/SeriesTitle, 'Lecture Notes in Computer Science')"
                >LNCS</xsl:when>
            <xsl:when
                test="contains(/Publisher/Series/SeriesInfo/SeriesTitle, 'Lecture Notes in Business Information')"
                >LNBIP</xsl:when>
            <xsl:otherwise> CollectionInconnue </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>   
    <xsl:variable name="Affiliations">
        <xsl:copy-of select="//Affiliation"></xsl:copy-of>
    </xsl:variable>
    <xsl:template match="/">
        <!-- Ajouter test que le ficher  $FrontMatterName existe bien sinon ERREUR-->

        <TEI xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:hal="http://hal.archives-ouvertes.fr/"
            xsi:schemaLocation="http://www.tei-c.org/ns/1.0 https://api.archives-ouvertes.fr/documents/aofr-sword.xsd">
            <text>
                 <body>
                    <listBibl>
                        <biblFull>
                            <!--titleStmt>
                                <title xml:lang="en">
                                    <xsl:value-of select="concat($collection,' ',$volumeNb)"/>
                                </title>
                            
                                <xsl:apply-templates
                                    select="//Editor"/>
                            </titleStmt-->
               
                            <editionStmt>

                                <edition>
                                  
                                    
                                    <!-- POUR LR MOMENT, nom du fichier=nom du xml.pdf"/-->
                                    <ref type="annex" subtype="" n="0">
                                        <xsl:attribute name="target">
                                            <xsl:value-of select="concat('ftp://ftp.ccsd.cnrs.fr/','BookFrontmatter.pdf')"/>
                                        </xsl:attribute>                                  
                                    </ref>

                                </edition>
                            </editionStmt>
                            <publicationStmt>
                                <!--<distributor>IFIP</distributor>
                                -->
                                <availability>
                                    <licence target="http://creativecommons.org/licenses/by/"/>
                                </availability>
                            </publicationStmt>
                            <seriesStmt>
                                <idno type="stamp" n="IFIP">IFIP - International Federation for Information Processing</idno>
                                <idno type="stamp"
                                    n="{concat('IFIP-', normalize-space($collection))}"/>
                                <idno type="stamp"
                                    n="{concat('IFIP-', normalize-space($collection),'-',normalize-space($volumeNb))}"
                                />
                                <xsl:apply-templates select="/Publisher/Series/Book/BookInfo/IFIPentity/TC"/>
                                <xsl:apply-templates select="/Publisher/Series/Book/BookInfo/IFIPentity/WG"/>
                           </seriesStmt>
                            <notesStmt>
                                <note type="popular" n="0"/>             
                                <note type="audience" n="2"/>
                                <!-- car déjà dans le bookTitle
                                <note type="commentary">
                                    <xsl:apply-templates
                                        select="Publisher/Series/Book/BookInfo/BookSubTitle"/>
                                </note>
                                -->
                                <xsl:apply-templates select="/Publisher/Series/Book/Part/PartInfo"  />
                            </notesStmt>
                            <sourceDesc>
                                <biblStruct>
                                    <analytic>
                                        <title xml:lang="en">
                                            <xsl:value-of select="concat($collection,' ',$volumeNb)"/>
                                        </title>
                                        <xsl:apply-templates
                                            select="//EditorGroup/Editor"
                                        />
                                    </analytic>
                                    <monogr>
                                        <xsl:apply-templates select="Publisher/Series/Book"/>
                                    </monogr>
                                    <xsl:apply-templates select="Publisher/Series/SeriesInfo"/>
                                    <xsl:apply-templates
                                        select="/Publisher/Series/Book/BookInfo/BookDOI"
                                    />
                                </biblStruct>
                            </sourceDesc>
                            <profileDesc>
                                <langUsage>
                                    <language ident="en"/>
                                </langUsage>
                                <textClass>
                                    <xsl:apply-templates
                                        select="//Chapter/ChapterHeader/KeywordGroup"/>
                                    <xsl:call-template name="addDomain">
                                        <xsl:with-param name="dom">info</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:apply-templates select="/Publisher/Series/Book/BookInfo/IFIPentity"></xsl:apply-templates>
                                    <classCode scheme="halTypology" n="OUV"/>
                                </textClass>
                                <abstract xml:lang="en">Book Front Matter</abstract>                                
                            </profileDesc>
                        </biblFull>
                    </listBibl>
                </body>
                <back>
                    <listOrg type="laboratories">
                        <xsl:apply-templates select="/descendant::Affiliation"/>
                    </listOrg>
                </back>
            </text>
        </TEI>

    </xsl:template>

    <xsl:template match="Book">
        <xsl:apply-templates select="BookInfo/BookElectronicISBN"/>
        <xsl:apply-templates select="BookInfo/BookPrintISBN"/>
      
       

        <imprint>
            <xsl:apply-templates select="/Publisher/PublisherInfo/PublisherName"/>
            <!--facultatif biblScope unit="pp">-</biblScope-->
            <biblScope unit="serie">
                <xsl:apply-templates select="/Publisher/Series/SeriesInfo/SeriesTitle"/>
                <!--xsl:apply-templates select="SeriesTitle"/-->
            </biblScope>
            <biblScope unit="volume">
                <xsl:value-of select="$volumeNb"/>
            </biblScope>
            <date type="datePub">
                <xsl:choose>
                    <xsl:when test="string-length(/Publisher/Series/Book/BookInfo/BookCopyright/CopyrightYear)!=0">
                        <xsl:value-of select="/Publisher/Series/Book/BookInfo/BookCopyright/CopyrightYear"></xsl:value-of>
                    </xsl:when>
                    <xsl:when test="string-length(BookFrontmatter/BodyFrontmatter/Preface/PrefaceInfo/PrefaceDate)!=0">
                        <xsl:value-of select="BookFrontmatter/BodyFrontmatter/Preface/PrefaceInfo/PrefaceDate"></xsl:value-of>
                    </xsl:when>
                </xsl:choose>
            </date>
        </imprint>
    </xsl:template>

    <xsl:template match="Editor">
        <author role="aut">
            <xsl:apply-templates/>
            <xsl:if test="@AffiliationIDS">
                <xsl:for-each select="tokenize(@AffiliationIDS,' ')">
                    <xsl:call-template name="Affiche_affi">
                        <xsl:with-param name="idAff"><xsl:value-of select="normalize-space(.)" /></xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>  
            </xsl:if>
        </author>
    </xsl:template>

    <xsl:template match="EditorName">
        <persName>
            <xsl:apply-templates select="*"/>
        </persName>
    </xsl:template>

    <xsl:template match="KeywordGroup">
        <keywords scheme="author">
            <xsl:apply-templates select="Keyword"/>
        </keywords>
    </xsl:template>

    <xsl:template match="Keyword">
        <term xml:lang="en">
            <xsl:apply-templates/>
        </term>
    </xsl:template>

  
    <xsl:template match="PublisherName">
        <publisher>
            <xsl:apply-templates/>
        </publisher>
    </xsl:template>


 

   

    <xsl:template match="SeriesInfo">
        <!--<series>
            <xsl:apply-templates select="SeriesTitle"/>
            <!-\- SeriesID, SeriesPrintISSN, SeriesElectronicISSN: on n'a rien dans le schéma SWORD HAL pour caser cela-\->
        </series>-->
    </xsl:template>

    <!-- <xsl:template match="SeriesTitle">
        <biblScope unit="serie">
            <xsl:apply-templates/>
        </biblScope>
    </xsl:template>-->

    <!-- <xsl:template match="SeriesTitle">
        <title level="s">
            <xsl:apply-templates/>
        </title>
    </xsl:template>-->

    <xsl:template match="SeriesElectronicISSN">
        <idno type="eISSN">
            <xsl:apply-templates/>
        </idno>
    </xsl:template>

    <xsl:template match="SeriesPrintISSN">
        <idno type="pISSN">
            <xsl:apply-templates/>
        </idno>
    </xsl:template>

    <xsl:template match="SeriesID">
        <idno type="seriesID"/>
    </xsl:template>
    <xsl:template match="BookPrintISBN">
        <idno type="isbn">
            <xsl:apply-templates/>
        </idno>
    </xsl:template>


    <xsl:template match="BookElectronicISBN">
        <idno type="eisbn">
            <xsl:apply-templates/>
        </idno>
    </xsl:template>

    <xsl:template match="BookDOI">
        <idno type="DOI">
            <xsl:apply-templates/>
        </idno>
    </xsl:template>
    <!--Attention dans le fichier source les middle sont aussi en Given name donner la recommandation de mettre dans uen balise MiddleName ? sinon on a en sortie que l'inittial -->
    <xsl:template match="GivenName[1]">
        <forename type="first">
            <xsl:apply-templates/>
        </forename>
    </xsl:template>
    <xsl:template match="GivenName">
        <forename type="middle">
            <xsl:apply-templates/>
        </forename>
    </xsl:template>
    <xsl:template match="Particle">
        <forename type="middle">
            <xsl:apply-templates/>
        </forename>
    </xsl:template>

    <!--Voir dans les données fournies si le middle name est distinct ? <xsl:template match="Initials">
        <forename type="middle">
            <xsl:apply-templates/>
        </forename>
    </xsl:template>-->

    <xsl:template match="FamilyName">
        <surname>
            <xsl:apply-templates/>
        </surname>
    </xsl:template>

    <!--    <xsl:template match="Editor">
        <editor>
            <xsl:apply-templates/>
            <xsl:if test="@AffiliationIDS">
                <xsl:for-each select="tokenize(@AffiliationIDS,' ')">
                    <affiliation ref="#localStruct-{.}"/>
                </xsl:for-each>
            </xsl:if>
        </editor>
    </xsl:template>-->
   



    <!-- +++++++++++++++ Places ++++++++++++++++ -->

    <!-- Springer: City, State, Postcode, Country -->
    <!-- ScholarOne: city, state, country, province? -->
    <!-- Sage: country -->
    <!-- NLM 2.3 article: country -->
    <!-- BMJ: corresponding-author-city, corresponding-author-country, corresponding-author-state, corresponding-author-zipcode -->

    <xsl:template match="Country | country | corresponding-author-country">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:variable name="countryWithNoSpace" select="normalize-space(.)"/>
            
                <xsl:choose>
                    <xsl:when test="@country_code">
                        <!-- A specific test for ScholarOne -->
                        <xsl:attribute name="key">
                            <xsl:call-template name="normalizeISOCountry">
                                <xsl:with-param name="country" select="@country_code"/>
                            </xsl:call-template>
                        </xsl:attribute>
                       <!-- <xsl:call-template name="normalizeISOCountryName">
                            <xsl:with-param name="country" select="@country_code"/>
                        </xsl:call-template>-->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="key">
                            <xsl:call-template name="normalizeISOCountry">
                                <xsl:with-param name="country" select="$countryWithNoSpace"/>
                            </xsl:call-template>
                        </xsl:attribute>
                       <!-- <xsl:call-template name="normalizeISOCountryName">
                            <xsl:with-param name="country" select="$countryWithNoSpace"/>
                        </xsl:call-template>-->
                    </xsl:otherwise>
                </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="normalizeISOCountry">
        <xsl:param name="country"/>
        <xsl:variable name="resultCode">
            <xsl:value-of
                select="$countryCodes/descendant::tei:row[tei:cell/text()=$country]/tei:cell[@role='a2code']"
            />
        </xsl:variable>
        <xsl:message>Country: <xsl:value-of select="$country"/> - Code: <xsl:value-of
                select="$resultCode"/></xsl:message>
        <xsl:value-of select="$resultCode"/>
    </xsl:template>

    <!--<xsl:template name="normalizeISOCountryName">
        <xsl:param name="country"/>
        <xsl:variable name="resultCode">
            <xsl:value-of
                select="$countryCodes/descendant::tei:row[tei:cell/text()=$country]/tei:cell[@role='name' and @xml:lang='en']"
            />
        </xsl:variable>
        <xsl:message>Country: <xsl:value-of select="$country"/> - normalized: <xsl:value-of
                select="$resultCode"/></xsl:message>
        <xsl:value-of select="$resultCode"/>
    </xsl:template>-->





    <!-- Rule for email, phone, fax -->
    <!-- BMJ: corresponding-author-email -->
    <!-- NLM 2.2: email -->
    <!-- Springer: Email -->

    <xsl:template match="email | corresponding-author-email | Email | eml">
        <email>
             <xsl:value-of select="normalize-space(.)"/>
         </email>
    </xsl:template>

    <xsl:template match="phone | Phone">
        <xsl:if test=".!=''">
            <note type="phone">
                <xsl:apply-templates/>
            </note>
        </xsl:if>
    </xsl:template>

    <xsl:template match="fax | Fax">
        <xsl:if test=".!=''">
            <note type="fax">
                <xsl:apply-templates/>
            </note>
        </xsl:if>
    </xsl:template>

    <xsl:template match="uri | url | URL">
        <xsl:if test=".!=''">
            <ptr type="url">
                <xsl:attribute name="target">
                    <xsl:apply-templates/>
                </xsl:attribute>
            </ptr>
        </xsl:if>
    </xsl:template>

    <!-- Not satisfactory: should find a better way -->
    <xsl:template match="PublisherURL">
        <note type="URL">
            <xsl:apply-templates/>
        </note>
    </xsl:template>

    <xsl:template match="room">
        <xsl:if test=".!=''">
            <note type="room">
                <xsl:apply-templates/>
            </note>
        </xsl:if>
    </xsl:template>


    <!-- Organisations -->
    <!-- BMJ: institution, corresponding-author-institution -->
    <!-- ScholarOne: inst, dept -->
    <!-- Springer 2/3: OrgDivision, OrgName -->



    <xsl:template match="Affiliation">
      <xsl:if test="normalize-space(.)!=''" >
        <!-- Création de l'institution -->
        <org type="institution" xml:id="localStruct-{@ID}Institution">
            <orgName>
                <xsl:apply-templates select="OrgName"/>
            </orgName>
            <xsl:apply-templates select="OrgAddress"/>
        </org>
        
        <!-- Création du labo seulement si orgDivision -->   
        <xsl:if test="OrgDivision" >
            <org type="laboratory" xml:id="localStruct-{@ID}">
                <orgName>
                    <xsl:apply-templates select="OrgDivision"/>
                </orgName>
                <xsl:apply-templates select="OrgAddress"/>
                <listRelation>
                    <relation active="#localStruct-{@ID}Institution"> </relation>
                </listRelation>
                
                
            </org>
        </xsl:if>
      </xsl:if>
        
    </xsl:template>
    <xsl:template match="OrgAddress">
        <desc>
          <address>
        <xsl:if test="normalize-space(./Street)!=''
            or normalize-space(./Postbox)!=''
            or normalize-space(./Postcode)!='' 
            or normalize-space(./City)!='' 
            or normalize-space(./State)!='' ">
            <addrLine>
                <!-- A FAIRE aller à la ligne après route et ville et pays ? -->
                <xsl:value-of select="string-join(./*,' ')"/>
            </addrLine>
        </xsl:if>                
            <country key="$resultCode">
                <xsl:apply-templates select="./Country"/>
            </country>
          </address>
        </desc>        
    </xsl:template>
    <xsl:template  match="IFIPentity">
        <xsl:choose>
            <xsl:when test="./TC=6">
                <xsl:call-template name="addDomain">
                    <xsl:with-param name="dom">info</xsl:with-param>
                </xsl:call-template>	
            </xsl:when>
            <xsl:when test="./TC=8">
                <xsl:call-template name="addDomain">
                    <xsl:with-param name="dom">shs.info</xsl:with-param>
                </xsl:call-template>	
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <!-- ajoute un domaine -->
    <xsl:template name="addDomain">
        <xsl:param name="dom"/>
        <classCode scheme="halDomain" n="normalize-space($dom)">
            <xsl:attribute name="n"><xsl:value-of select="$dom"/></xsl:attribute>
        </classCode>
        
    </xsl:template>
    <xsl:template match="OrgName|OrgDivision|BookSubTitle|OrgDivision">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="SeriesTitle">
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
    </xsl:template>
    <xsl:template match="TC">
        <idno type="stamp"
            n="{concat('IFIP-TC', normalize-space(.))}"/>
        
    </xsl:template>
    <xsl:template match="WG">
        <idno type="stamp"
            n="{concat('IFIP-WG', translate(normalize-space(.),'.','-'))}"/>
    </xsl:template>
    <xsl:template match="PartInfo">
        <note type="commentary">
           <xsl:value-of select="concat('Part ',./PartID,': ',normalize-space(./PartTitle))"></xsl:value-of>
        </note>
        
    </xsl:template>
    <!-- affiche une affiliation -->
    <xsl:template name="Affiche_affi">
        <xsl:param name="idAff"/>
        <xsl:choose>
            <xsl:when test="$Affiliations/AAffiliation[@ID=$idAff]/OrgDivision">
                <affiliation ref="#localStruct-{$idAff}"/>
            </xsl:when>
            <xsl:otherwise>
                <affiliation ref="#localStruct-{$idAff}Institution"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
