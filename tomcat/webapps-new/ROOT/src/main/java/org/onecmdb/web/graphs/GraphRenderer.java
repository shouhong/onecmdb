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
package org.onecmdb.web.graphs;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.onecmdb.web.ImageMap;

public interface GraphRenderer {

    /**
     * Render a representation of the input graph onto a specific format onto
     * a specific output stream.
     * @param graphML An input stream conssiting of a graph represented in 
     * {@link http://graphml.graphdrawing.org/ GraphML} format.
     * @param output An output stream where to write the produced artifact.
     * @param format the image format (e.g., "JPG", "PNG"). The number and kind
     * of available formats varies by platform. See
     * {@link javax.imageio.ImageIO} and related classes for more.
     * format on the output stream.
     * @throws IOException In case of illegal input format, or errors with the
     * streams passed.
     */
    public abstract void render(InputStream graphML, OutputStream output, String format,
            ImageMap imagemap)        
            throws IOException;

}