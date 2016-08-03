OneCMDB Repository
==================

Overview
========
All configuration for OneCMDB Desktop is stored in this directory.
The root to this is specified under ${install}/tomcat*/webapps/onecmdb-desktop/WEB-INF/classes/repository.cfg

Special File
============
- content.meta 
 Stores information on how to convert a files in the directory into a Java object.
 For example a property file to be used has the following entry in the content.meta
 <entry key="java.util.Properties">org.onecmdb.ui.gwt.framework.server.service.content.PropertyAdaptor</entry>

Directory Structure (excluded content.meta)
====================
readme.txt - This file.


Desktop/
	defaultView.xml - Defines the start menu.

OneCMDB/
	Configuration/
		IconMapper.cfg - Maps CI's to real icon files(Stored under content/Images/Icons)
		onecmdb.xml - Defines where OneCMDB WSDL is running.
	Visualization/
		Graphs - Contains user defined Graphs.
		Tables - Contains user defined Tables.
		Trees - Contains user defined Trees.
	Export/
	ChangeStore/ - Stores the latest imported data from a MDR. Used to determine changes.
		...
			<imported data>	
		...
	
Content/
	Applet/    - Applet code for graph visualization.
	Documents/ - Arbitary documents.
	Images/
		Icons/ - Icon store.
MDR
	Models - Stores default models. Save user defined models here.
		...
		<model xml files>
		...	
		
