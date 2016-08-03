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

import java.util.Enumeration;

import org.hsqldb.Database;
import org.hsqldb.DatabaseURL;
import org.hsqldb.HsqlException;
import org.hsqldb.Trace;
import org.hsqldb.lib.Set;
import org.hsqldb.lib.SimpleLog;
import org.hsqldb.lib.HashSet;
import org.hsqldb.lib.java.JavaSystem;

// loosecannon1@users 1.7.2 patch properties on the JDBC URL
// tytar@users 20041209 - provide to set default table type

/**
 * Manages a .properties file for a database.
 *
 * @author fredt@users
 * @version 1.8.0
 * @since 1.7.0
 */
public class HsqlDatabaseProperties extends HsqlProperties {

    // db files modified
    public static final int FILES_NOT_MODIFIED = 0;
    public static final int FILES_MODIFIED     = 1;
    public static final int FILES_NEW          = 2;

    // sets of properties
    private static HashSet fullyProtectedProperties = new HashSet();
    private static HashSet setProtectedProperties   = new HashSet();
    private static HashSet booleanProperties        = new HashSet();
    private static HashSet integralProperties       = new HashSet();
    private static HashSet stringProperties         = new HashSet();

    // versions
    public static final String VERSION_STRING_1_7_0     = "1.7.0";
    public static final String VERSION_STRING_1_8_0     = "1.8.0";
    public static final String FIRST_COMPATIBLE_VERSION = "1.8.0";
    public static final String THIS_VERSION             = "1.8.0";
    public static final String THIS_FULL_VERSION        = "1.8.0.4";
    public static final String PRODUCT_NAME = "HSQL Database Engine";
    public static final int    MAJOR                    = 1,
                               MINOR                    = 8,
                               REVISION                 = 0;

    //
    public static final String  db_version  = "version";
    private static final String db_readonly = "readonly";
    private static final String db_modified = "modified";

    //
    private static final String runtime_gc_interval = "runtime.gc_interval";
    public static final String  hsqldb_applog       = "hsqldb.applog";
    public static final String  hsqldb_cache_scale  = "hsqldb.cache_scale";
    public static final String hsqldb_cache_file_scale =
        "hsqldb.cache_file_scale";
    public static final String hsqldb_cache_size_scale =
        "hsqldb.cache_size_scale";
    public static final String  hsqldb_cache_version = "hsqldb.cache_version";
    private static final String hsqldb_catalogs      = "hsqldb.catalogs";
    public static final String hsqldb_compatible_version =
        "hsqldb.compatible_version";
    public static final String hsqldb_default_table_type =
        "hsqldb.default_table_type";
    public static final String hsqldb_defrag_limit = "hsqldb.defrag_limit";
    private static final String hsqldb_files_readonly =
        "hsqldb.files_readonly";
    public static final String  hsqldb_log_size      = "hsqldb.log_size";
    public static final String  hsqldb_nio_data_file = "hsqldb.nio_data_file";
    private static final String hsqldb_max_nio_scale = "hsqldb.max_nio_scale";
    private static final String hsqldb_original_version =
        "hsqldb.original_version";
    public static final String hsqldb_script_format = "hsqldb.script_format";

    //
    private static final String sql_compare_in_locale =
        "sql.compare_in_locale";
    private static final String sql_enforce_strict_size =
        "sql.enforce_strict_size";
    public static final String sql_tx_no_multi_write =
        "sql.tx_no_multi_rewrite";

    //
    public static final String textdb_cache_scale = "textdb.cache_scale";
    public static final String textdb_cache_size_scale =
        "textdb.cache_size_scale";
    public static final String textdb_all_quoted = "textdb.all_quoted";
    public static final String textdb_allow_full_path =
        "textdb.allow_full_path";
    public static final String textdb_encoding     = "textdb.encoding";
    public static final String textdb_ignore_first = "textdb.ignore_first";
    public static final String textdb_quoted       = "textdb.quoted";
    public static final String textdb_fs           = "textdb.fs";
    public static final String textdb_vs           = "textdb.vs";
    public static final String textdb_lvs          = "textdb.lvs";

    static {

        // properties that are not user-defined or only modified in the
        // *.properties file
        String[] fullyProtectedPropertiesNames = {
            db_version, hsqldb_compatible_version, hsqldb_cache_version,
            hsqldb_original_version, hsqldb_files_readonly, db_readonly,
            db_modified, sql_compare_in_locale, textdb_allow_full_path
        };

        fullyProtectedProperties.addAll(fullyProtectedPropertiesNames);

        // properties that cannot be modified by SET PROPERTY command
        String[] setProtectedPropertiesNames = {
            hsqldb_log_size, hsqldb_script_format, hsqldb_defrag_limit,
        };

        setProtectedProperties.addAll(setProtectedPropertiesNames);

        // user defined boolean properties
        String[] booleanPropertiesNames = {
            hsqldb_nio_data_file, hsqldb_catalogs, sql_enforce_strict_size,
            textdb_quoted, textdb_all_quoted, textdb_ignore_first,
            sql_tx_no_multi_write
        };

        booleanProperties.addAll(booleanPropertiesNames);

        // user defined integral properties
        String[] integralPropertiesNames = {
            runtime_gc_interval, hsqldb_applog, hsqldb_max_nio_scale,
            hsqldb_cache_file_scale, hsqldb_cache_scale,
            hsqldb_cache_size_scale, hsqldb_log_size, textdb_cache_scale,
            textdb_cache_size_scale
        };

        integralProperties.addAll(integralPropertiesNames);

        // user defined string properties
        String[] stringPropertiesNames = {
            textdb_fs, textdb_vs, textdb_lvs, textdb_encoding,
            hsqldb_default_table_type
        };

        stringProperties.addAll(stringPropertiesNames);
    }

    private Database database;

    public HsqlDatabaseProperties(Database db) {

        super(db.getPath(), db.getFileAccess(), db.isFilesInJar());

        database = db;

        // char padding to size and exception if data is too long
        setProperty(sql_enforce_strict_size, false);

        // removed from 1.7.2 - sql.month is always true (1-12)
        // removed from 1.7.2 - sql.strict_fk is always enforced
        // if true, requires a pre-existing unique index for foreign key
        // referenced column and returns an error if index does not exist
        // 1.61 creates a non-unique index if no index exists
        // setProperty("sql.strict_fk", false);
        // removed from 1.7.2
        // has no effect if sql_strict_fk is true, otherwise if true,
        // creates a unique index for foreign keys instead of non-unique
        // setProperty("sql.strong_fk", true);
        // the two properties below are meant for attempting to open an
        // existing database with all its files *.properties, *script and
        // *.data.
        // version of a new database
        setProperty(db_version, THIS_VERSION);

        // the earliest version that can open this database
        // this is set to 1.7.2 when the db is written to
        setProperty(hsqldb_compatible_version, FIRST_COMPATIBLE_VERSION);

        // data format of the cache file
        // this is set to 1.7.0 when a new *.data file is created
        setProperty(hsqldb_cache_version, VERSION_STRING_1_7_0);

        // the version that created this database
        // once created, this won't change if db is used with a future version
        setProperty(hsqldb_original_version, THIS_VERSION);
        /*
                garbage collection with gc_interval
                Setting this value can be useful when HSQLDB is used as an
                in-process part of an application. The minimum practical
                amount is probably "10000" and the maximum "1000000"

                In some versions of Java, such as 1.3.1_02 on windows,
                when the application runs out of memory it runs the gc AND
                requests more memory from the OS. Setting this property
                forces the DB to live inside its memory budget but the
                maximum amount of memory can still be set with the
                java -Xmx argument to provide the memory needed by other
                parts of the app to do graphics and networking.

                Of course there is a speed penalty for setting the value
                too low and doing garbage collection too often.

                This was introduced as a result of tests by Karl Meissner
                (meissnersd@users)
         */

        // garbage collect per Record or Cache Row objects created
        // the default, "0" means no garbage collection is forced by
        // hsqldb (the Java Runtime will do it's own garbage collection
        // in any case).
        setProperty(runtime_gc_interval, 0);

        // this property is either 1 or 8
        setProperty(hsqldb_cache_file_scale, 1);

        // this property is between 6 - 20, default 8
        setProperty(hsqldb_cache_size_scale, 8);

        // number of rows from CACHED tables kept constantly in memory
        // the number of rows in up to 3 * (2 to the power of
        // cache_scale value).
        // reduce the default 14 (3*16K rows) if memory is limited and rows
        // are large.
        // values between 8-16 are allowed
        setProperty(hsqldb_cache_scale, 14);

        // maximum size of .log file in megabytes
        setProperty(hsqldb_log_size, "200");

        // type of logging (0 : text , 1 : binary, 3 : compressed)
        setProperty(hsqldb_script_format, 0);
        setProperty(db_readonly, false);
        setProperty(db_modified, "no-new-files");

        // initial method of data file access
        setProperty(hsqldb_nio_data_file, true);

        // set default table type to MEMORY
        setProperty(hsqldb_default_table_type, "memory");

        // the property "version" is also set to the current version
        //
        // the following properties can be set by the user as defaults for
        // text tables. the default values are shown.
        // "textdb.fs", ","
        // "textdb.vs", ",";
        // "textdb.lvs", ","
        // "textdb.ignore_first", false
        // "textdb.quoted", true
        // "textdb.all_quoted", false
        // "textdb.encoding", "ASCII"
        // "textdb.cache_scale", 10  -- allowed range 8-16
        // "textdb.cache_size_scale", 10  -- allowed range 8-20
        //
        // settings for OOo integration
        if (db.isStoredFileAccess()) {
            setProperty(hsqldb_default_table_type, "cached");
            setProperty(hsqldb_cache_scale, 13);
            setProperty(hsqldb_log_size, 10);
            setProperty(sql_enforce_strict_size, true);
            setProperty(hsqldb_nio_data_file, false);
        }
    }

    /**
     * Creates file with defaults if it didn't exist.
     * Returns false if file already existed.
     */
    public boolean load() throws HsqlException {

        boolean exists;

        if (!DatabaseURL.isFileBasedDatabaseType(database.getType())) {
            return true;
        }

        try {
            exists = super.load();
        } catch (Exception e) {
            throw Trace.error(Trace.FILE_IO_ERROR,
                              Trace.LOAD_SAVE_PROPERTIES, new Object[] {
                fileName, e
            });
        }

        if (!exists) {
            return false;
        }

        filterLoadedProperties();

        String version = getProperty(hsqldb_compatible_version);

        // do not open if the database belongs to a later (future) version
        int check = version.substring(0, 5).compareTo(THIS_VERSION);

        Trace.check(check <= 0, Trace.WRONG_DATABASE_FILE_VERSION);

        version = getProperty(db_version);

        if (version.charAt(2) == '6') {
            setProperty(hsqldb_cache_version, "1.6.0");
        }

        JavaSystem.gcFrequency = getIntegerProperty(runtime_gc_interval, 0);

        return true;
    }

    /**
     * Sets the database member variables after creating the properties object,
     * openning a properties file, or changing a property with a command
     */
    public void setDatabaseVariables() {

        if (isPropertyTrue(db_readonly)) {
            database.setReadOnly();
        }

        if (isPropertyTrue(hsqldb_files_readonly)) {
            database.setFilesReadOnly();
        }

        database.sqlEnforceStrictSize =
            isPropertyTrue(sql_enforce_strict_size);

        if (isPropertyTrue(sql_compare_in_locale)) {
            stringProps.remove(sql_compare_in_locale);
            database.collation.setCollationAsLocale();
        }

        database.txManager.setReWriteProtection(
            isPropertyTrue(sql_tx_no_multi_write));
        database.setMetaDirty(false);
    }

    public void save() throws HsqlException {

        if (!DatabaseURL.isFileBasedDatabaseType(database.getType())
                || database.isFilesReadOnly() || database.isFilesInJar()) {
            return;
        }

        try {
            super.save(fileName + ".properties" + ".new");
            fa.renameElement(fileName + ".properties" + ".new",
                             fileName + ".properties");
        } catch (Exception e) {
            database.logger.appLog.logContext(SimpleLog.LOG_ERROR,
                                              "save properties");

            throw Trace.error(Trace.FILE_IO_ERROR,
                              Trace.LOAD_SAVE_PROPERTIES, new Object[] {
                fileName, e
            });
        }
    }

    void filterLoadedProperties() {

        Enumeration en = stringProps.propertyNames();

        while (en.hasMoreElements()) {
            String key = (String) en.nextElement();
            boolean accept = fullyProtectedProperties.contains(key)
                             || setProtectedProperties.contains(key)
                             || booleanProperties.contains(key)
                             || integralProperties.contains(key)
                             || stringProperties.contains(key);

            if (!accept) {
                stringProps.remove(key);
            }
        }
    }

    /**
     *  overload file database properties with any passed on URL line
     *  do not store password etc
     */
    public void setURLProperties(HsqlProperties props) {

        if (props != null) {
            for (Enumeration e =
                    props.propertyNames(); e.hasMoreElements(); ) {
                String propertyName = (String) e.nextElement();

                if (isBoolean(propertyName) || isIntegral(propertyName)
                        || isString(propertyName)
                        || db_readonly.equals(propertyName)) {
                    setProperty(propertyName,
                                props.getProperty(propertyName));
                }
            }
        }
    }

    public boolean isSetPropertyAllowed(String property) {
        return !(fullyProtectedProperties.contains(property)
                 || setProtectedProperties.contains(property));
    }

    public boolean isBoolean(String property) {
        return booleanProperties.contains(property);
    }

    public boolean isIntegral(String property) {
        return integralProperties.contains(property);
    }

    public boolean isString(String property) {
        return stringProperties.contains(property);
    }

    public Set getBooleanPropertyNames() {
        return booleanProperties;
    }

    public Set getIntegralPropertyNames() {
        return integralProperties;
    }

    public Set getStringPropertyNames() {
        return stringProperties;
    }

    public String setProperty(String key, String value) {

        value = super.setProperty(key, value);

        return value;
    }

    public int getDefaultWriteDelay() {
        return database.isStoredFileAccess() ? 2000
                                             : 20000;
    }

    public void setDBModified(int mode) throws HsqlException {

        String value = "no";

        if (mode == FILES_MODIFIED) {
            value = "yes";
        } else if (mode == FILES_NEW) {
            value = "no-new-files";
        }

        setProperty(db_modified, value);
        save();
    }

    public int getDBModified() throws HsqlException {

        String value = getProperty("modified");

        if ("yes".equals(value)) {
            return FILES_MODIFIED;
        } else if ("no-new-files".equals(value)) {
            return FILES_NEW;
        }

        return FILES_NOT_MODIFIED;
    }
}
