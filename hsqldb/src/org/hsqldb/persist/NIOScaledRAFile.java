/* Copyright (c) 2001-2005, The HSQL Development Group
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of the HSQL Development Group nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL HSQL DEVELOPMENT GROUP, HSQLDB.ORG,
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


package org.hsqldb.persist;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

import org.hsqldb.Trace;

/**
 * NIO version of ScaledRAFile. This class is used only for storing a CACHED
 * TABLE .data file and cannot be used for TEXT TABLE source files.
 *
 * Due to various issues with java.nio classes, this class will use a mapped
 * channel up to a certain size. After reaching this size, all access to the
 * random access file is delegated to the superclass which does not
 * use java.nio.
 *
 * @author fredt@users
 * @version  1.7.2
 * @since 1.7.2
 */
class NIOScaledRAFile extends ScaledRAFile {

    MappedByteBuffer buffer;
    FileChannel      channel;
    long             bufferLength;
    private boolean  wasNio;
    private boolean  bufferModified;

    /**
     * Public constructor for access by reflection
     */
    public NIOScaledRAFile(String name,
                           boolean mode)
                           throws FileNotFoundException, IOException {

        super(name, mode);

        if (super.length() > MAX_NIO_LENGTH) {
            Trace.printSystemOut("Initiatiated without nio");

            return;
        }

        wasNio  = isNio = true;
        channel = file.getChannel();

        enlargeBuffer(super.length(), 0);
        Trace.printSystemOut("initial length " + super.length());
        Trace.printSystemOut("NIO file instance created. mode:  " + mode);
    }

    /** @todo fredt - better message */
    private long newBufferSize(long newsize) throws IOException {

        long bufsize;

        for (int scale = 20; ; scale++) {
            bufsize = 1L << scale;

            if (bufsize >= newsize) {
                break;
            }
        }

        return bufsize;
    }

    private void enlargeBuffer(long offset, int size) throws IOException {

        int position = 0;

        if (buffer != null) {
            position = buffer.position();

            try {
                if (bufferModified) {
                    buffer.force();
                }
            } catch (Exception e) {
                e.printStackTrace();

                throw new IOException(e.getMessage());
            }
        }

        long newSize = newBufferSize(offset + size);

        Trace.printSystemOut("NIO next enlargeBuffer():  " + newSize);

        if (bufferLength > (1L << 24)) {
            System.gc();
        }

        if (bufferLength <= MAX_NIO_LENGTH) {
            try {
                buffer = channel.map(isReadOnly()
                                     ? FileChannel.MapMode.READ_ONLY
                                     : FileChannel.MapMode.READ_WRITE, 0,
                                     newSize);
                bufferModified = false;
            } catch (Exception e) {
                Trace.printSystemOut("NIO enlargeBuffer() failed:  "
                                     + newSize);

                isNio   = false;
                buffer  = null;
                channel = null;

                System.gc();
                super.seek(position);

                return;
            }
        } else {
            Trace.printSystemOut("Stopped NIO at enlargeBuffer():  "
                                 + newSize);

            isNio   = false;
            buffer  = null;
            channel = null;

            System.gc();
            super.seek(position);

            return;
        }

        bufferLength = newSize;

        buffer.position(position);
    }

    public void seek(long newPos) throws IOException {

        if (!isNio) {
            super.seek(newPos);

            return;
        }

        if (newPos == bufferLength) {
            Trace.printSystemOut("Seek to buffer length " + newPos);
        }

        if (newPos > bufferLength) {
            enlargeBuffer(newPos, 4);

            if (!isNio) {
                super.seek(newPos);

                return;
            }
        }

        buffer.position((int) newPos);
    }

    public long getFilePointer() throws IOException {

        if (!isNio) {
            return super.getFilePointer();
        }

        return buffer.position();
    }

    public int read() throws IOException {

        if (!isNio) {
            return super.read();
        }

        return buffer.get();
    }

    public void read(byte[] b, int offset, int length) throws IOException {

        if (!isNio) {
            super.read(b, offset, length);

            return;
        }

        buffer.get(b, offset, length);
    }

    public int readInt() throws IOException {

        if (!isNio) {
            return super.readInt();
        }

        return buffer.getInt();
    }

    public long readLong() throws IOException {

        if (!isNio) {
            return super.readLong();
        }

        return buffer.getLong();
    }

    public void write(byte[] b, int offset, int len) throws IOException {

        if (!isNio) {
            super.write(b, offset, len);

            return;
        }

        bufferModified = true;

        if ((long) buffer.position() + len > bufferLength) {
            enlargeBuffer((long) buffer.position(), len);

            if (!isNio) {
                super.write(b, offset, len);

                return;
            }
        }

        buffer.put(b, offset, len);
    }

    public void writeInt(int i) throws IOException {

        if (!isNio) {
            super.writeInt(i);

            return;
        }

        bufferModified = true;

        if ((long) buffer.position() + 4 > bufferLength) {
            enlargeBuffer((long) buffer.position(), 4);

            if (!isNio) {
                super.writeInt(i);

                return;
            }
        }

        buffer.putInt(i);
    }

    public void writeLong(long i) throws IOException {

        if (!isNio) {
            super.writeLong(i);

            return;
        }

        bufferModified = true;

        if ((long) buffer.position() + 4 > bufferLength) {
            enlargeBuffer((long) buffer.position(), 4);

            if (!isNio) {
                super.writeLong(i);

                return;
            }
        }

        buffer.putLong(i);
    }

    public void close() throws IOException {

        if (!isNio) {
            super.close();

            return;
        }

        Trace.printSystemOut("NIO next close() - fileLength = "
                             + bufferLength);
        Trace.printSystemOut("NIO next buffer.force()");

        if (buffer != null && bufferModified) {
            buffer.force();
        }

        buffer  = null;
        channel = null;

        Trace.printSystemOut("NIO next file.close()");
        file.close();
        System.gc();
    }

    public boolean wasNio() {
        return wasNio;
    }
}
