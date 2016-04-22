public class DS_SDQ_Scoring {   
    
    //list of records on DS_DATA that are specific to SDQ
    private Map<String, List<DS_DATA__c>> sdqInfo = new Map<String, List<DS_DATA__c>>();   
    
    //initialize variable alias
    //Emotional subscore values and total
    public Integer SOMA { get; set; }
    public Integer WORR { get; set; }
    public Integer UNHA  { get; set; }
    public Integer CLIN { get; set; }
    public Integer AFRA { get; set; }    
    public Integer EMO { get; set; }
    
    //Behavioral subscore values and total
    public Integer TANT  { get; set; }
    public Integer OBEY { get; set; }
    public Integer FIGH { get; set; }
    public Integer LIES { get; set; }
    public Integer STEA { get; set; }
    public Integer BEH { get; set; }
    
    //Hyperactivity subscore values and total
    public Integer REST { get; set; }
    public Integer FIDG { get; set; }
    public Integer DIST { get; set; }
    public Integer REFL { get; set; }
    public Integer ATTE { get; set; }
    public Integer HYP { get; set; }
    
    //Other children subscore values and total
    public Integer LONE { get; set; }
    public Integer FRIE { get; set; }
    public Integer POPU { get; set; }
    public Integer BULL { get; set; }
    public Integer OLDB { get; set; }
    public Integer OTC { get; set; }
    
    //Kind and helpful behavoir (aka prosocial) subscore values and total
    public Integer CONS { get; set; }
    public Integer SHAR { get; set; }
    public Integer CARI { get; set; }
    public Integer KIND { get; set; }
    public Integer HELP { get; set; }
    public Integer KHB { get; set; }    
    
    //Impact subscore values and total
    public Integer UPSET { get; set; }
    public Integer IMPH { get; set; }
    public Integer IMPF { get; set; }
    public Integer IMPC { get; set; }
    public Integer IMPL { get; set; }
    public Integer DCL {get;set;}
    
    //Total score
    public Integer TOT { get; set; }
    
    //Null counters for subscores
    public Integer EMONULL { get; set; }
    public Integer BEHNULL { get; set; }
    public Integer HYPNULL { get; set; }
    public Integer OTCNULL { get; set; }
    public Integer KHBNULL { get; set; }
    
    //Duration
    public Integer HOWLONG { get; set; }
    
    //Significance for subscales
    public String ETYP { get; set; }
    public String BTYP { get; set; }
    public String HTYP { get; set; }
    public String OTYP { get; set; }
    public String KTYP { get; set; }
    public String ITYP { get; set; }
    public String PTYP { get; set; }    
    
    //Difficulties present
    public String EBCD { get; set; }//baseline
    public String EBDD { get; set; }//follow-up
    
    public String PorS{get;set;}
  //  public List<DS_DATA__c> sdqSelf{get;set;}
   // public List<DS_DATA__c> sdqParent{get;set;}
    ///////////////////////////////////////////////////////////
    
    public DS_SDQ_Scoring() {    
        List<DS_DATA__c> sdqdata = [Select Data_Type__c, Content__c, Page__c, Variable__c, 
                                    Object__c, Source_Form__c, Type__c, Age_Range__c
                                    FROM DS_DATA__c
                                    WHERE 
                                    (Source_Form__c ='DS_SDQ_P_11_17' 
                                     OR Source_Form__c ='DS_SDQ_P_04_10' 
                                     OR Source_Form__c ='DS_SDQ_S_11_17' )
                                    AND isDeleted = false
                                    AND Section__c = false
                                   ];
        
        System.debug(sdqdata );//*
        //initialize null counters
        EMONULL = 0;
        BEHNULL = 0;
        HYPNULL = 0;
        OTCNULL = 0;
        KHBNULL = 0;
    }          
    
    public SObject scoreAnalyzer(SObject obj) {
        scoringBody(obj);
        System.debug(obj);
        return obj;
    }
    
    public SObject scoringBody(SObject obj) {
        //string of object name
        String thisObject =String.valueOf(obj.getsObjectType());
        
        //B or F function based on object name
        String BorF = (thisObject == 'DS_SDQ_PSI_CDI_B__c') ? 'B' : 'F'; 
        
        String ParentSelf =String.valueOf(obj.get(BorF+'FORM__c'));
        String PorS = (ParentSelf =='SDQ_S_11_17') ? 'S':'P';
        
        //null parsing
        //if variable = null, set alias to 0 and increment null alias
        //otherwise, set variable = alias
        
        //emotional
        if ( obj.get(BorF+'SD'+PorS+'SOMA__c') == null){ SOMA=0; EMONULL++;}
        else{SOMA  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'SOMA__c'));}
        if ( obj.get(BorF+'SD'+PorS+'WORR__c') == null){ WORR=0; EMONULL++;}
        else{WORR  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'WORR__c'));}
        if ( obj.get(BorF+'SD'+PorS+'UNHA__c') == null){ UNHA=0; EMONULL++;}
        else{UNHA  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'UNHA__c'));}
        if ( obj.get(BorF+'SD'+PorS+'CLIN__c') == null){ CLIN=0; EMONULL++;}
        else{CLIN  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'CLIN__c'));}
        if ( obj.get(BorF+'SD'+PorS+'AFRA__c') == null){ AFRA=0; EMONULL++;}
        else{AFRA  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'AFRA__c'));}
        
        //behavioral                
        if ( obj.get(BorF+'SD'+PorS+'TANT__c') == null){TANT =0; BEHNULL++;}
        else{TANT  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'TANT__c'));}
        if ( obj.get(BorF+'SD'+PorS+'OBEY__c') == null){OBEY =0; BEHNULL++;}
        else{OBEY  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'OBEY__c'));}
        if ( obj.get(BorF+'SD'+PorS+'FIGH__c') == null){ FIGH=0; BEHNULL++;}
        else{FIGH  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'FIGH__c'));}
        if ( obj.get(BorF+'SD'+PorS+'LIES__c') == null){LIES =0; BEHNULL++;}
        else{LIES  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'LIES__c'));}
        if ( obj.get(BorF+'SD'+PorS+'STEA__c') == null){ STEA=0; BEHNULL++;}
        else{STEA  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'STEA__c'));}
        
        //hyperactive
        if ( obj.get(BorF+'SD'+PorS+'REST__c') == null){REST =0; HYPNULL++;}
        else{REST  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'REST__c'));}
        if ( obj.get(BorF+'SD'+PorS+'FIDG__c') == null){ FIDG=0; HYPNULL++;}
        else{FIDG  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'FIDG__c'));}
        if ( obj.get(BorF+'SD'+PorS+'DIST__c') == null){DIST =0; HYPNULL++;}
        else{DIST  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'DIST__c'));}
        if ( obj.get(BorF+'SD'+PorS+'REFL__c') == null){ REFL=0; HYPNULL++;}
        else{REFL  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'REFL__c'));}            
        if ( obj.get(BorF+'SD'+PorS+'ATTE__c') == null){ATTE=0; HYPNULL++;}                
        else{ATTE  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'ATTE__c'));}
        
        //peer
        if ( obj.get(BorF+'SD'+PorS+'LONE__c') == null){ LONE=0; OTCNULL++;}
        else{LONE  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'LONE__c'));}
        if ( obj.get(BorF+'SD'+PorS+'FRIE__c')== null){ FRIE=0; OTCNULL++;}
        else{FRIE  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'FRIE__c'));}
        if ( obj.get(BorF+'SD'+PorS+'POPU__c') == null){ POPU=0; OTCNULL++;}
        else{POPU  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'POPU__c'));}
        if ( obj.get(BorF+'SD'+PorS+'BULL__c')== null){ BULL=0; OTCNULL++;}
        else{BULL  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'BULL__c'));}
        if ( obj.get(BorF+'SD'+PorS+'OLDB__c')== null){ OLDB=0; OTCNULL++;}
        else{OLDB  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'OLDB__c'));}
        
        //prosocial
        if ( obj.get(BorF+'SD'+PorS+'CONS__c') == null){ CONS=0; KHBNULL++;}
        else{CONS  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'CONS__c'));}
        if ( obj.get(BorF+'SD'+PorS+'SHAR__c') == null){ SHAR=0; KHBNULL++;}
        else{SHAR  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'SHAR__c'));}
        if ( obj.get(BorF+'SD'+PorS+'CARI__c') == null){ CARI=0; KHBNULL++;}
        else{CARI  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'CARI__c'));}
        if ( obj.get(BorF+'SD'+PorS+'KIND__c') == null){ KIND=0; KHBNULL++;}
        else{KIND  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'KIND__c'));}
        if ( obj.get(BorF+'SD'+PorS+'HELP__c') == null){ HELP=0; KHBNULL++;}
        else{HELP  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'HELP__c'));} 
        
        //add alias for variables for subscale alias sums
        EMO  = SOMA+WORR+UNHA+CLIN+AFRA;
        BEH  = TANT+OBEY+FIGH+LIES+STEA;
        HYP  = REST+FIDG+DIST+REFL+ATTE;
        OTC  = LONE+FRIE+POPU+BULL+OLDB;
        KHB  = CONS+SHAR+CARI+KIND+HELP;
        
        //parse subscale alias onto object variable
        obj.put(BorF+'SD'+PorS+'EMO__c', EMO);
        obj.put(BorF+'SD'+PorS+'BEH__c', BEH);
        obj.put(BorF+'SD'+PorS+'HYP__c', HYP);
        obj.put(BorF+'SD'+PorS+'OTC__c', OTC);
        obj.put(BorF+'SD'+PorS+'KHB__c', KHB);
        
        System.debug(EMO);
        System.debug(BEH);
        System.debug(HYP);
        System.debug(OTC);
        System.debug(KHB);
        
        if ((obj.get(BorF+'SD'+PorS+'TIME__c')) == null){HOWLONG =0; }
        else {HOWLONG  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'TIME__c'));}
        
        //add subscale score alias for total score alias and parse onto object variable
        TOT = EMO+BEH+HYP+OTC;//+KHB;
        obj.put(BorF+'SD'+PorS+'TOT__c', TOT);
        System.debug(TOT);
        
        //impact
        //Hand-scoring values are 0,0,1,2.
        if (((obj.get(BorF+'SD'+PorS+'UPSET__c')) == null)||((obj.get(BorF+'SD'+PorS+'UPSET__c')) == '0')) {UPSET=0; }
            else { (UPSET= Integer.valueOf(obj.get(BorF+'SD'+PorS+'UPSET__c'))-1); }
        /////////////////////////////////
        if (((obj.get(BorF+'SD'+PorS+'IMPH__c')) == null)||(obj.get(BorF+'SD'+PorS+'IMPH__c')) == '0'){IMPH=0;}
            else {IMPH= (Integer.valueof(obj.get(BorF+'SD'+PorS+'IMPH__c'))-1);}
        /////////////////////////////////
        if (((obj.get(BorF+'SD'+PorS+'IMPF__c')) == null)||(obj.get(BorF+'SD'+PorS+'IMPF__c')) == '0'){IMPF=0;}
            else {IMPF= (Integer.valueof(obj.get(BorF+'SD'+PorS+'IMPF__c'))-1);}
        /////////////////////////////////
        if (((obj.get(BorF+'SD'+PorS+'IMPC__c')) == null)||((obj.get(BorF+'SD'+PorS+'IMPC__c')) == '0')){IMPC=0;}
            else {IMPC= (Integer.valueof(obj.get(BorF+'SD'+PorS+'IMPC__c'))-1);}
        /////////////////////////////////
        if (((obj.get(BorF+'SD'+PorS+'IMPL__c')) == null)||((obj.get(BorF+'SD'+PorS+'IMPL__c')) == '0')){IMPL=0;}
            else {IMPL= (Integer.valueof(obj.get(BorF+'SD'+PorS+'IMPL__c'))-1);}   
        
        //parse impact alias onto object variable         
     /*   obj.put(BorF+'SD'+PorS+'UPSET__c', String.valueOf(UPSET));    
        obj.put(BorF+'SD'+PorS+'IMPH__c', String.valueOf(IMPH));
        obj.put(BorF+'SD'+PorS+'IMPF__c', String.valueOf(IMPF));
        obj.put(BorF+'SD'+PorS+'IMPC__c', String.valueOf(IMPC));
        obj.put(BorF+'SD'+PorS+'IMPL__c', String.valueOf(IMPL)); */

        System.debug(UPSET);
        System.debug(IMPH);
        System.debug(IMPF);
        System.debug(IMPC);
        System.debug(IMPC);
        
        //add impact variable alias for total impact score alias and parse onto object variable
        DCL = UPSET+IMPH+IMPF+IMPC+IMPL; 
        obj.put(BorF+'SD'+PorS+'DCL__c', DCL);
        System.debug(DCL);
        
        //parse null alias onto the object variable
        obj.put(BorF+'EMONULL'+PorS+'__c',EMONULL);
        obj.put(BorF+'BEHNULL'+PorS+'__c',BEHNULL);
        obj.put(BorF+'HYPNULL'+PorS+'__c',HYPNULL);
        obj.put(BorF+'OTCNULL'+PorS+'__c',OTCNULL);
        obj.put(BorF+'KHBNULL'+PorS+'__c',KHBNULL);            
        
        //significance
        //(For each category) 
        //if variable <= borderline threshold, significance variable = 'Normal/Average'
        //if variable is between borderline and clinical threshold, significance variable = 'Borderline'
        //if variable is above clinical threshold, significance variable = 'Clinical'
        
        //total
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'TOT__c'))<=13)
        {obj.put(BorF+'SD'+PorS+'TYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'TOT__c'))>= 17)
        {obj.put(BorF+'SD'+PorS+'TYP__c','Clinical');}
        else
        {obj.put(BorF+'SD'+PorS+'TYP__c','Borderline');}
        
        //emotional
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'EMO__c'))<=3)
        {obj.put(BorF+'SD'+PorS+'ETYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'EMO__c'))>= 5)
        {obj.put(BorF+'SD'+PorS+'ETYP__c','Clinical');}
        else
        {obj.put(BorF+'SD'+PorS+'ETYP__c','Borderline');} 
        
        //behavioral
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'BEH__c'))<=2)
        {obj.put(BorF+'SD'+PorS+'BTYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'BEH__c'))>= 4)
        {obj.put(BorF+'SD'+PorS+'BTYP__c','Clinical');}
        else
        {obj.put(BorF+'SD'+PorS+'BTYP__c','Borderline');}
        
        //hyperactivity
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'HYP__c'))<=5)
        {obj.put(BorF+'SD'+PorS+'HTYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'HYP__c'))>= 7)
        {obj.put(BorF+'SD'+PorS+'HTYP__c','Clinical');}
        else
        {obj.put(BorF+'SD'+PorS+'HTYP__c','Borderline');}
        
        //other children
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'OTC__c'))<=2)
        {obj.put(BorF+'SD'+PorS+'OTYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'OTC__c'))>= 4)
        {obj.put(BorF+'SD'+PorS+'OTYP__c','Clinical');}
        else
        {obj.put(BorF+'SD'+PorS+'OTYP__c','Borderline');}
        
        //prosocial
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'KHB__c'))>=6)
        {obj.put(BorF+'SD'+PorS+'KTYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'KHB__c'))<=4)
        {obj.put(BorF+'SD'+PorS+'KTYP__c','Clinical');}
        else
        {obj.put(BorF+'SD'+PorS+'KTYP__c','Borderline');} 
        
        //impact
        if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'DCL__c'))==0)
        {obj.put(BorF+'SD'+PorS+'ITYP__c','Normal/Average');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'DCL__c'))== 1)
        {obj.put(BorF+'SD'+PorS+'ITYP__c','Borderline');}
        else if (Integer.valueOf(obj.get(BorF+'SD'+PorS+'DCL__c'))>=2)                 
        {obj.put(BorF+'SD'+PorS+'ITYP__c','Clinical');}
        
        //missing
        //if there are >2 scores missing from a subscore, the significance = 'Missing/Incomplete'
        //if any subscale (EXCEPT KHB) is marked as 'Missing/Incomplete', the total significance = 'Missing/Incomplete'
        
        //emotional
        if (EMONULL>2){ 
            obj.put(BorF+'SD'+PorS+'ETYP__c','Missing/Incomplete');
            obj.put(BorF+'SD'+PorS+'TYP__c','Missing/Incomplete');
        }   
        //behavioral
        if (BEHNULL>2){ 
            obj.put(BorF+'SD'+PorS+'BTYP__c','Missing/Incomplete');
            obj.put(BorF+'SD'+PorS+'TYP__c','Missing/Incomplete');
        }  
        //hyperactivity
        if (HYPNULL>2){ 
            obj.put(BorF+'SD'+PorS+'HTYP__c','Missing/Incomplete');
            obj.put(BorF+'SD'+PorS+'TYP__c','Missing/Incomplete');
        }  
        //other children
        if (OTCNULL>2){ 
            obj.put(BorF+'SD'+PorS+'OTYP__c','Missing/Incomplete');
            obj.put(BorF+'SD'+PorS+'TYP__c','Missing/Incomplete');
        }  
        //kind & helpful behavior
        if (KHBNULL>2){ 
            obj.put(BorF+'SD'+PorS+'KTYP__c','Missing/Incomplete');
        }  
        System.debug(BorF);
        System.debug(PorS);
        System.debug(obj);
        return obj;
    }               
}