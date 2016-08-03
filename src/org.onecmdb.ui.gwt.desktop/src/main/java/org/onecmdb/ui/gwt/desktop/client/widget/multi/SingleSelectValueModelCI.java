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
package org.onecmdb.ui.gwt.desktop.client.widget.multi;

import java.util.List;

import org.onecmdb.ui.gwt.desktop.client.fixes.combo.IValueComponent;
import org.onecmdb.ui.gwt.desktop.client.service.content.ContentData;
import org.onecmdb.ui.gwt.desktop.client.service.model.CIModel;
import org.onecmdb.ui.gwt.desktop.client.service.model.CMDBPermissions;
import org.onecmdb.ui.gwt.desktop.client.service.model.ValueListModel;
import org.onecmdb.ui.gwt.desktop.client.service.model.ValueModel;
import org.onecmdb.ui.gwt.desktop.client.service.model.grid.CIModelCollection;
import org.onecmdb.ui.gwt.desktop.client.widget.grid.EditableCIInstanceGrid;
import org.onecmdb.ui.gwt.desktop.client.widget.grid.GridQueryLoader;

import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.layout.FillLayout;
import com.google.gwt.user.client.Element;

public class SingleSelectValueModelCI extends LayoutContainer implements Listener<SelectionChangedEvent>, IValueComponent<ValueModel> {

	
	private GridQueryLoader loader;
	private ListStore<CIModelCollection> store;
	private CIModel template;
	private ValueListModel values;
	private ContentData mdr;
	private List selected;
	private SelectionMode selMode;
	private CMDBPermissions permissions;
	private ValueModel valueModel;
	private String alias;

	public SingleSelectValueModelCI(ContentData mdr, String alias, CIModel template,  CMDBPermissions perm) {
		this.mdr = mdr;
		this.template = template;
		this.selMode = SelectionMode.SINGLE;;
		this.permissions = perm;
		this.alias = alias;
	}
	
	
	@Override
	protected void onRender(Element parent, int index) {
		// TODO Auto-generated method stub
		super.onRender(parent, index);
	
		initUI();
	}

	private void initUI() {
		setLayout(new FillLayout());
		ContentData cd = new ContentData();
		cd.set("template", template.getAlias());
		EditableCIInstanceGrid grid = new EditableCIInstanceGrid(mdr, cd, template.getNameAndIcon());
		grid.setSelectNewTemplate(true);
		grid.setPermissions(permissions);
		grid.setSelectable(true);
		grid.setSelectionMode(selMode);
		grid.setSelectionListener(this);
		grid.setSilentInfo(true);
		add(grid);
	}


	public List getSelection() {
		return(this.selected);
	}


	public void handleEvent(SelectionChangedEvent be) {
		this.selected = be.getSelection();
	}


	public ValueModel getValue() {
		CIModel model = getSelectedCI();
		if (model == null) {
			return(null);
		}
		if (valueModel == null) {
			valueModel = new ValueModel();			
			valueModel.setAlias(this.alias);
		} 
		valueModel.setValue(model.getAlias());
		valueModel.setValueDisplayName(model.getDisplayName());
		valueModel.set(CIModel.CI_ICON_PATH, model.get(CIModel.CI_ICON_PATH));
		valueModel.set(ValueModel.VALUE_ISCOMPLEX, true);
		
		return(valueModel);
	}
	
	protected CIModel getSelectedCI() {
		if (this.selected == null) {
			return(null);
		}
		if (this.selected instanceof List) {
			if (this.selected.size() > 0) {
				Object value = this.selected.get(0);
				if (value instanceof CIModelCollection) {
					return(((CIModelCollection)value).getCIModels().get(0));
				}
				if (value instanceof CIModel) {
					return((CIModel)value);
				}
				
			}
		}
		if (this.selected instanceof CIModel) {
			return((CIModel)this.selected);
		}
		return(null);

	}

	public void setValue(ValueModel value) {
		if (value == null) {
			return;
		}
		this.valueModel = value.copy();
	}
}
