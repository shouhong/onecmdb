/*
 * Lokomo OneCMDB - An Open Source Software for Configuration
 * Management of Datacenter Resources
 *
 * Copyright (C) 2006 Lokomo Systems AB
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301 USA.
 * 
 * Lokomo Systems AB can be contacted via e-mail: info@lokomo.com or via
 * paper mail: Lokomo Systems AB, Sv�rdv�gen 27, SE-182 33
 * Danderyd, Sweden.
 *
 */
package org.onecmdb.core.tests.core;

import junit.framework.TestCase;

import org.onecmdb.core.IValue;
import org.onecmdb.core.internal.model.primitivetypes.TimeType;
import org.onecmdb.core.tests.AbstractOneCmdbTestCase;

/**
 * Test all built-in data types for accurancy.
 *
 * @author Niklas
 *
 */
public class TestDataTypes extends AbstractOneCmdbTestCase {
	
	
	
	public void testStringType() {
		
	}
	
	
	
	public void testTime() {
		TimeType timeType = new TimeType();
		IValue time = timeType.parseString("23:15:20Z");
	}

}
