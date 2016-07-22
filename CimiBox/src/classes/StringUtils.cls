/* ============================================================
 * This code is part of the "apex-lang" open source project avaiable at:
 * 
 *      http://code.google.com/p/apex-lang/
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
 
/****
*@description  Port of the StringUtils class from Java to Apex.  This
 * class is part of the Apache Commons Lang project available
 * at http://commons.apache.org/lang/. 
*
*@group System
*@group-content /ApexDocContent/System/StringUtils.htm
****/
global class StringUtils {

    global static final String EMPTY = '';
    global static final String LF = '\n';
    global static final String CR = '\r';
    global static final Integer INDEX_NOT_FOUND = -1;

    private static final Integer PAD_LIMIT = 8192;
    
    global static String joinArray(Object[] objectArray) {
        return joinArray(objectArray, null);
    }
    
    global static String joinArray(Object[] objectArray, String separator) {
        if (objectArray == null) {
            return null;
        }
        return joinArray(objectArray, separator, 0, objectArray.size());
    }

    global static String joinArray(Object[] objectArray, String separator, Integer startIndex, Integer endIndex) {
        if (objectArray == null) {
            return null;
        }
        if (separator == null) {
            separator = EMPTY;
        }

        String buf = '';
        if(startIndex < 0){
            startIndex = 0;
        }
        Boolean isFirst = true;
        for (Integer i = startIndex; i < endIndex && i < objectArray.size(); i++) {
            if(objectArray[i] != null) {
                if(isFirst){
                    isFirst = false;
                } else {
                    buf += separator;
                }
                buf += objectArray[i];
            }
        }
        return buf;
    }

    
    
    
}