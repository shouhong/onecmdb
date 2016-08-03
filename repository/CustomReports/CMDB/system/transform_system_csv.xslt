<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="iso-8859-1"/>
<xsl:template match="/">
"System.Type","System.Hostname","System.IPAddress","System.IPv6Address","System.MAC_Address","System.SerialNumber","OS.Type","OS.Version","OS.Familly","OS.LicenseKey","Network.Name"
<xsl:for-each select="Tree/system">
<xsl:text>"</xsl:text><xsl:value-of select="@type"/><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="Hostname" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="IPAddress" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="IPv6Address" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="MAC_Address" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="SerialNumber" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="os2system/os/@type" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="os2system/os/Version" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="os2system/os/Family" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="os2system/os/LicenseKey" /><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="system2network/network/Name" /><xsl:text>"</xsl:text>,
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>