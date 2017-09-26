/**
* @author Danny Fu
* @date 06/29/2016
*
* @modified DF 03/30/2017 Add comments
*
* @group Trauma
* @group-content /ApexDocContent/Trauma/Trauma_detail_factory.htm
*
* @description An apex class to generate trauma detail element instance.
* 
*/

public with sharing class DS_TDETAIL_Factory {
    
    public static DS_TDETAIL_Interface.Element getInstance(string className) {
        
        Type t = Type.forName(className);
                
        if(t == null && className != null) {
            // Attempt to get the type again with the namespace explicitly set to blank
            t = Type.forName('', className);
        }
        
        // If the class still does not exist, send the error message and return null
        if(t == null) {
            System.debug(LoggingLevel.Error, 'Failed to find type for ['+className+']');
            return null;
        }

        // Create an instance to confirm the type
        object testInstance = t.newInstance();
        if(!(testInstance instanceOf DS_TDETAIL_Interface.Element)) {
            return null;
        }

        DS_TDETAIL_Interface.Element interfaceInstance = (DS_TDETAIL_Interface.Element)testInstance;
        
        return interfaceInstance;
        
    }

}