public class DS_FAPGAR_Scoring {
    
    private Utility ut = new Utility();
    
    public DS_FAPGAR_Scoring() {}
    
    public SObject scoreAnalyzer(SObject obj) {
        
        String BorF = (String.valueOf(obj.getsObjectType()) == 'DS_Functioning_Forms_B__c') ? 'B' : 'F';
        
        Integer RawScore = 0;
                
        List<String> fg = new List<String>();
        
        fg.add(String.valueOf(obj.get(BorF+'FAPGAR1__c')));
        fg.add(String.valueOf(obj.get(BorF+'FAPGAR2__c')));
        fg.add(String.valueOf(obj.get(BorF+'FAPGAR3__c')));
        fg.add(String.valueOf(obj.get(BorF+'FAPGAR4__c')));
        fg.add(String.valueOf(obj.get(BorF+'FAPGAR5__c')));
        
        for(String value : fg) {
            // If one of the value is null, rawsocre is null and finish the loop. 
            If(value == null) { RawScore = null; break; }
            // If value is '99', use 0 for scoring. 
            RawScore += (value == '99') ? 0 : Integer.valueOf(value);
        }
        
        obj.put(BorF+'FAPGAR_MET__c', (RawScore >= 5 && RawScore <= 10) ? 'Met' : 'Not Met');
        obj.put(BorF+'FAPGAR_RAW__c', RawScore);
        
        return obj;
        
    }

}