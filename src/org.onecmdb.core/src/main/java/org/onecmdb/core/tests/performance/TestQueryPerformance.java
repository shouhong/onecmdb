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
package org.onecmdb.core.tests.performance;

import java.util.Set;

import org.onecmdb.core.ICi;
import org.onecmdb.core.IModelService;
import org.onecmdb.core.internal.model.Path;
import org.onecmdb.core.internal.model.QueryCriteria;
import org.onecmdb.core.internal.model.QueryResult;
import org.onecmdb.core.tests.AbstractOneCmdbTestCase;
import org.onecmdb.core.tests.OneCMDBTestConfig;

public class TestQueryPerformance extends AbstractOneCmdbTestCase {

	@Override
	protected String getDatasourceResource() {
		return("org/onecmdb/core/tests/resources/datasource/mysql-15-update-datasource.xml");
	}
	
	
	public void testQueryCI() {
		IModelService svc = (IModelService) session.getService(IModelService.class);
	
		ICi brukare = svc.findCi(new Path<String>("NetworkIF"));
		long start = System.currentTimeMillis();
		Set<ICi> cis =  brukare.getOffsprings();
		long stop = System.currentTimeMillis();
		System.out.println("Query: " + (stop-start) + "ms for " + cis.size() + " instances");
		
		
		QueryCriteria crit = new QueryCriteria();
		crit.setOffspringOfAlias("Resurs");
		crit.setOffspringDepth(new Integer(1));
		crit.setMatchCiInstances(true);
		start = System.currentTimeMillis();
		QueryResult result = svc.query(crit);
		stop = System.currentTimeMillis();
		System.out.println("Query: " + (stop-start) + "ms for " + result.size() + " instances");
	}
	
	

}
