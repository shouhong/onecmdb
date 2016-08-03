
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
			<body>
				<h1 align="center">OneCMDB Templates</h1>
				<a name="TopPageIndex"></a>
				<hr size="2" noshade="true" width="70%" align="center"/>
				<div align="center">
				<OL>
				<xsl:for-each select="onecmdb/templates/template">
					<xsl:variable name="alias" select="@alias" />
					<LI>
						<a href="#{$alias}"><b><xsl:value-of select="derivedFrom/ref/@alias" />::<xsl:value-of select="@alias"/></b></a>
					</LI>
				</xsl:for-each>
				
				</OL>
				</div>
				<hr size="2" noshade="true" width="70%" align="center"/>
				<xsl:for-each select="onecmdb/templates/template">
					<xsl:variable name="alias" select="@alias" />
					<br/>
					<a name="{$alias}" href="#TopPageIndex">index</a>
					<xsl:text></xsl:text>
					<h2 align="center"><xsl:value-of select="derivedFrom/ref/@alias" />::<xsl:value-of select="@alias" /></h2>
					<table border="0" width="80%" align="center">
						<tr bgcolor="#9acd32">
							<th align="left">Alias</th>
							<th align="left">Name</th>
							<th align="left">SimpleType</th>
							<th align="left">ComplexType</th>
							<th align="left">RefType</th>
							<th align="left">Derived</th>
							<th align="left">Min Occurs</th>
							<th align="left">Max Occurs</th>
							<th align="left">Description</th>
							
						</tr>
					
						<xsl:for-each select="attribute">
							<tr bgcolor="#DFE8FF" border="1">
								<td>
									<xsl:value-of select="@attAlias" />
								</td>
								<td>
									<xsl:value-of select="@displayName"/>
								</td>
							
								<td>
									<xsl:value-of select="simpleType"/>
								</td>
								<td>
									<xsl:value-of select="complexType/ref/@alias"/>
								</td>
								<td>
									<xsl:value-of select="complexType/refType/ref/@alias"/>
								</td>
								<td>
									<xsl:value-of select="@derived"/>
								</td>
								<td>
									<xsl:value-of select="policy/minOccurs"/>
								</td>
								<td>
									<xsl:value-of select="policy/maxOccurs"/>
								</td>
								<td>
									<xsl:value-of select="description"/>
								</td>
								
								
							</tr>
						</xsl:for-each>
					</table>
					<br/>
					<hr size="5" noshade="true" width="70%" align="center"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>