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
 * paper mail: Lokomo Systems AB, Svärdvägen 27, SE-182 33
 * Danderyd, Sweden.
 *
 */
package org.onecmdb.ui.gwt.toolkit.client.model.onecmdb.graph.query;

public class GWT_AttributeValueConstraint extends GWT_AttributeConstraint {
	public static final int EQUALS = 0;
	public static final int GREATER_THAN = 1;
	public static final int LESS_THAN = 2;
	public static final int GREATER_THAN_OR_EQUAL = 3;
	public static final int LESS_THAN_OR_EQUAL = 4;
	public static final int LIKE = 5;
	public static final int CONTAINS = 6;
	public static final int IS_NULL = 7;
	
	public static final int STRING_DATA_TYPE = 0;
	public static final int NUMBER_DATA_TYPE = 1;
	public static final int DATE_DATA_TYPE = 2;
	
	private String value;
	private int operation;
	private int valueType;
	
	public GWT_AttributeValueConstraint(String attrAlias, int operation, String attrValue) {
		super(attrAlias);
		this.value = attrValue;
		this.operation = operation;
	}

	public GWT_AttributeValueConstraint() {
		super();
	}
	
	public int getValueType() {
		return valueType;
	}


	public void setValueType(int valueType) {
		this.valueType = valueType;
	}


	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public int getOperation() {
		return operation;
	}

	public void setOperation(int operation) {
		this.operation = operation;
	}
	
	
	
	
	
	
	
}
