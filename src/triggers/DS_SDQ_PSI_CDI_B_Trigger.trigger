trigger DS_SDQ_PSI_CDI_B_Trigger on DS_SDQ_PSI_CDI_B__c (before insert, before update, after insert, after update) {

  Utility ut = new Utility();
  
  List<DS_DATA__c> sdqdata = [Select Data_Type__c, Content__c, Page__c, Variable__c, 
                            Object__c, Form__c, Source_Form__c, Type__c, Age_Range__c
                             FROM DS_DATA__c
                             WHERE Data_Type__c = 'DS_Form_Info'  
                                 AND isDeleted = false
                                 AND Section__c = false
                             AND Object__c = 'DS_SDQ_PSI_CDI_B'
                             ];
                             
  Map<String, List<DS_DATA__c>> sdqInfo = new Map<String, List<DS_DATA__c>>();  

  List<DS_DATA__c> sdqSelf = new List<DS_DATA__c>();
  List<DS_DATA__c> sdqOld = new List<DS_DATA__c>();
  List<DS_DATA__c> sdqYoung = new List<DS_DATA__c>();

    
  for(DS_DATA__c sdq : sdqdata) {
    if(sdq.Form__c == 'DS_SDQ_S_11_17')
      { sdqSelf.add(sdq);}
    else
      if(sdq.Age_Range__c == '11-17'){ //(sdq.Form__c == 'DS_SDQ_P_11_17'){//
        sdqOld.add(sdq);
      }
      else
              //if(sdq.Form__c == 'DS_SDQ_P_04_10')
        sdqYoung.add(sdq);
  }

  sdqInfo.put('Self', sdqSelf);
  sdqInfo.put('4-10', sdqYoung); 
  sdqInfo.put('11-17', sdqOld);
  //////////////////////////////////////////////////
   List<String> clientIDs = new List<String>();
   
  if(Trigger.isBefore) {
  
    Map<Integer, Integer> Scoring= new Map<Integer, Integer>();
    
    for(DS_SDQ_PSI_CDI_B__c SDQ: Trigger.new) {
      clientIDs.add(SDQ.Client__c);
    }
        Map<Id, Client__c> clientInfo = new Map<Id, Client__c>([SELECT id, Gender__c, AGE__c
                                                                FROM Client__c
                                                                WHERE id IN : clientIDs]);
////////////////////////////////////////////////////////////////////  
    for(DS_SDQ_PSI_CDI_B__c SDQ: Trigger.new) {

      Client__c client = clientInfo.get(SDQ.Client__c);
///////////////////////////////////////////////////////////////////////////////////////////////
Integer SOMA;// = 0;//Emotional 
  Integer WORR ;//= 0; //Emotional 
  Integer UNHA ;//= 0; //Emotional 
  Integer CLIN;// = 0; //Emotional 
  Integer AFRA;// = 0; //Emotional 
  Integer EMO;// = 0; //Emotional 
  Integer TANT;// = 0; //Behavioral
  Integer OBEY;// = 0; //Behavioral
  Integer FIGH = 0; //Behavioral
  Integer LIES = 0; //Behavioral
  Integer STEA = 0; //Behavioral
  Integer BEH = 0; //Behavioral
  Integer REST = 0; //Hyperactive
  Integer FIDG = 0; //Hyperactive
  Integer DIST = 0; //Hyperactive
  Integer REFL = 0; //Hyperactive
  Integer ATTE = 0; //Hyperactive
  Integer HYP = 0; //Hyperactive
  Integer LONE = 0; //Other Children
  Integer FRIE = 0; //Other Children
  Integer POPU = 0; //Other Children
  Integer BULL = 0; //Other Children
  Integer OLDB = 0; //Other Children
  Integer OTC = 0; //Other Children
  Integer CONS = 0; //Kind Helpful Behaviors
  Integer SHAR = 0; //Kind Helpful Behaviors
  Integer CARI = 0; //Kind Helpful Behaviors
  Integer KIND = 0; //Kind Helpful Behaviors
  Integer HELP = 0; //Kind Helpful Behaviors
  Integer KHB = 0; //Kind Helpful Behaviors
  Integer HOWLONG = 0;
  Integer UPSET = 0;
  Integer IMPH = 0;
  Integer IMPF = 0;
  Integer IMPC = 0;
  Integer IMPL = 0;
//////////////////////////////////////////////////////////////////////////////////////////////////////      
      Integer EmoNullP =0;
      Integer BehNullP =0;
      Integer HypNullP =0;
      Integer OtcNullP =0;
      Integer KhbNullP =0;
      
      Integer EmoNullS =0;
      Integer BehNullS =0;
      Integer HypNullS =0;
      Integer OtcNullS =0;
      Integer KhbNullS =0;      
//////////////////////////////////////////////////////////////////////////////////////////////////////   
Integer TOT = 0;
String PTYP;
String ETYP;
String BTYP;
String HTYP;
String OTYP;
String KTYP;
String ITYP;

String EBCD;// = 0;//


/////////////////////////////////////YOUNG PARENT/////////////////////////////////////////////////////////////////   
              //if(SDQ.STATUS_SDQ_P_04_10__c != null){
               for(DS_DATA__c young:sdqInfo.get('4-10') ){
           //   SDQ.FORM__c = 'DS_SDQ_P_04_10';
         //emotional
                if (SDQ.BSDPSOMA__c == null){ SOMA=0; EmoNullP++;}
                  else {SOMA= Integer.valueof(SDQ.BSDPSOMA__c);}
               if ( SDQ.BSDPWORR__c== null){ WORR=0; EmoNullP++;} 
                  else {WORR= Integer.valueof(SDQ.BSDPWORR__c);}                   
               if (SDQ.BSDPUNHA__c == null){ UNHA=0; EmoNullP++;} 
                  else {UNHA= Integer.valueof(SDQ.BSDPUNHA__c);}                   
               if (SDQ.BSDPCLIN__c == null){CLIN =0;EmoNullP++;} 
                  else {CLIN= Integer.valueof(SDQ.BSDPCLIN__c);}                    
               if (SDQ.BSDPAFRA__c == null){AFRA =0; EmoNullP++;} 
                  else {AFRA= Integer.valueof(SDQ.BSDPAFRA__c);}                
                    //behavioral
               if (SDQ.BSDPTANT__c == null){ TANT=0; BehNullP++;}
                  else {TANT= Integer.valueof(SDQ.BSDPTANT__c);}
               if (SDQ.BSDPOBEY__c == null){OBEY =0; BehNullP++;}
                  else {OBEY= Integer.valueof(SDQ.BSDPOBEY__c);}
               if (SDQ.BSDPFIGH__c == null){ FIGH=0; BehNullP++;}
                  else {FIGH= Integer.valueof(SDQ.BSDPFIGH__c);}
               if (SDQ.BSDPLIES__c == null){LIES =0; BehNullP++;}
                  else {LIES= Integer.valueof(SDQ.BSDPLIES__c);}
               if (SDQ.BSDPSTEA__c == null){ STEA=0; BehNullP++;}
                  else {STEA= Integer.valueof(SDQ.BSDPSTEA__c);}                    
                    //hyperactivity
               if (SDQ.BSDPREST__c == null){ REST=0; HypNullP++;}
                  else {REST= Integer.valueof(SDQ.BSDPREST__c);}
               if (SDQ.BSDPFIDG__c == null){ FIDG=0; HypNullP++;}
                  else {FIDG= Integer.valueof(SDQ.BSDPFIDG__c);}
               if (SDQ.BSDPDIST__c == null){DIST =0; HypNullP++;}
                  else {DIST= Integer.valueof(SDQ.BSDPDIST__c);}
               if (SDQ.BSDPREFL__c == null){REFL =0; HypNullP++;}
                  else {REFL= Integer.valueof(SDQ.BSDPREFL__c);}
               if (SDQ.BSDPATTE__c == null){ ATTE=0; HypNullP++;}
                  else {ATTE= Integer.valueof(SDQ.BSDPATTE__c);}
                    //other children
               if (SDQ.BSDPLONE__c == null){ LONE=0; OtcNullP++;}
                  else {LONE= Integer.valueof(SDQ.BSDPLONE__c);}
               if (SDQ.BSDPFRIE__c == null){FRIE =0; OtcNullP++;}
                  else {FRIE= Integer.valueof(SDQ.BSDPFRIE__c);}
               if (SDQ.BSDPPOPU__c == null){POPU =0; OtcNullP++;}
                  else {POPU= Integer.valueof(SDQ.BSDPPOPU__c);}
               if (SDQ.BSDPBULL__c == null){ BULL=0; OtcNullP++;}
                  else {BULL= Integer.valueof(SDQ.BSDPBULL__c);}
               if (SDQ.BSDPOLDB__c == null){ OLDB=0; OtcNullP++;}
                  else {OLDB= Integer.valueof(SDQ.BSDPOLDB__c);}
                    //kind helpful behaviors
               if (SDQ.BSDPCONS__c == null){CONS =0; KhbNullP++;}
                  else {CONS= Integer.valueof(SDQ.BSDPCONS__c);}
               if (SDQ.BSDPSHAR__c == null){SHAR =0; KhbNullP++;}
                  else {SHAR= Integer.valueof(SDQ.BSDPSHAR__c);}
               if (SDQ.BSDPCARI__c == null){ CARI=0; KhbNullP++;}
                  else {CARI= Integer.valueof(SDQ.BSDPCARI__c);}
               if (SDQ.BSDPKIND__c == null){ KIND=0; KhbNullP++;}
                  else {KIND= Integer.valueof(SDQ.BSDPKIND__c);}
               if (SDQ.BSDPHELP__c == null){HELP =0; KhbNullP++;}
                  else {HELP= Integer.valueof(SDQ.BSDPHELP__c);}  
                  
               if (SDQ.BSDPTIME__c == null){HOWLONG =0; }
                  else {HOWLONG = Integer.valueof(SDQ.BSDPTIME__c);}
                    //impact///////////////////////////////  
               if ((SDQ.BSDPUPSET__c == null)||(SDQ.BSDPUPSET__c == '0'))
                       {UPSET=0; }
                  else {UPSET= (Integer.valueof(SDQ.BSDPUPSET__c)-1);}
                /////////////////////////////////  
               if ((SDQ.BSDPIMPH__c == null)||(SDQ.BSDPIMPH__c == '0'))
                       {IMPH=0;}
                  else {IMPH= (Integer.valueof(SDQ.BSDPIMPH__c)-1);}
                 ///////////////////////////////////// 
               if ((SDQ.BSDPIMPF__c == null)||(SDQ.BSDPIMPF__c == '0'))
                       {IMPF=0;}
                  else {IMPF= (Integer.valueof(SDQ.BSDPIMPF__c)-1);}
                 //////////////////////////////////////////// 
               if ((SDQ.BSDPIMPC__c == null)||(SDQ.BSDPIMPC__c == '0'))
                       {IMPC=0;}
                  else {IMPC= (Integer.valueof(SDQ.BSDPIMPC__c)-1);}
               ////////////////////////////////////////////////////   
               if ((SDQ.BSDPIMPL__c == null)||(SDQ.BSDPIMPL__c == '0'))
                       {IMPL=0;}
                  else {IMPL= (Integer.valueof(SDQ.BSDPIMPL__c)-1);}                  
            
            
               //total
                 SDQ.BSDPEMO__c= SOMA+WORR+UNHA+CLIN+AFRA;
                 SDQ.BSDPBEH__c= TANT+OBEY+FIGH+LIES+STEA;
                 SDQ.BSDPHYP__c= REST+FIDG+DIST+REFL+ATTE;
                 SDQ.BSDPOTC__c= LONE+FRIE+POPU+BULL+OLDB;
                 SDQ.BSDPKHB__c= CONS+SHAR+CARI+KIND+HELP;
                 SDQ.BSDPTOT__c= Integer.valueof(SDQ.BSDPEMO__c)+Integer.valueof(SDQ.BSDPBEH__c)+Integer.valueof(SDQ.BSDPHYP__c)+Integer.valueof(SDQ.BSDPOTC__c);
                 SDQ.BSDPDCL__c= IMPF+IMPC+IMPL+UPSET+IMPH;
                 
                 //significance
                     if (SDQ.BSDPTOT__c<=13){ SDQ.BSDPTYP__c='Normal/Average';}
                         else if (SDQ.BSDPTOT__c>= 17){SDQ.BSDPTYP__c='Clinical';}
                         else{SDQ.BSDPTYP__c='Borderline';}
                     if (SDQ.BSDPEMO__c<=3){SDQ.BSDPETYP__c='Normal/Average';}
                         else if (SDQ.BSDPEMO__c>= 5){SDQ.BSDPETYP__c='Clinical';}
                         else{SDQ.BSDPETYP__c='Borderline';} 
                     if (SDQ.BSDPBEH__c<=2){SDQ.BSDPBTYP__c='Normal/Average';}
                         else if (SDQ.BSDPBEH__c>= 4){SDQ.BSDPBTYP__c='Clinical';}
                         else{SDQ.BSDPBTYP__c='Borderline';}
                     if (SDQ.BSDPHYP__c<=5){SDQ.BSDPHTYP__c='Normal/Average';}
                         else if (SDQ.BSDPHYP__c>= 7){SDQ.BSDPHTYP__c='Clinical';}
                         else{SDQ.BSDPHTYP__c='Borderline';}
                     if (SDQ.BSDPOTC__c<=2){SDQ.BSDPOTYP__c='Normal/Average';}
                         else if (SDQ.BSDPOTC__c>= 4){SDQ.BSDPOTYP__c='Clinical';}
                         else{SDQ.BSDPOTYP__c='Borderline';}
                     if (SDQ.BSDPKHB__c>=6){SDQ.BSDPKTYP__c='Normal/Average';}
                         else if (SDQ.BSDPKHB__c<=4){SDQ.BSDPKTYP__c='Clinical';}
                         else{SDQ.BSDPKTYP__c='Borderline';} 
                     if (SDQ.BSDPDCL__c==0){SDQ.BSDPITYP__c='Normal/Average';}
                         else if (SDQ.BSDPDCL__c== 1){SDQ.BSDPITYP__c='Borderline';}
                         else if (SDQ.BSDPDCL__c>=2){SDQ.BSDPITYP__c='Clinical';}
                      ///////Missing   
               
                    if (EMONULLP>2){ 
                        SDQ.BSDPETYP__c ='Missing/Incomplete';
                        SDQ.BSDPTYP__c='Missing/Incomplete';
                     }   
                     if (BEHNULLP>2){ 
                         SDQ.BSDPBTYP__c ='Missing/Incomplete';
                       SDQ.BSDPTYP__c='Missing/Incomplete';
                     }  
                     if (HYPNULLP>2){ 
                         SDQ.BSDPHTYP__c ='Missing/Incomplete';
                        SDQ.BSDPTYP__c='Missing/Incomplete';
                     }  
                     if (OTCNULLP>2){ 
                         SDQ.BSDPOTYP__c ='Missing/Incomplete';
                        SDQ.BSDPTYP__c='Missing/Incomplete';
                     }  
                     if (KHBNULLP>2){ 
                         SDQ.BSDPKTYP__c ='Missing/Incomplete';
                     }  
                        
              SDQ.EMONULLP__c = EmoNullS;
               SDQ.BEHNULLP__c = BehNullS;
               SDQ.HYPNULLP__c = HypNullS;
               SDQ.OTCNULLP__c = OtcNullS;
               SDQ.KHBNULLP__c = KhbNullS;
                }
//}
//////////////////////////////////////////////OLD PARENT////////////////////////////////////////////////////////   
 //if(SDQ.STATUS_SDQ_P_11_17__c != null){
                for(DS_DATA__c old:sdqInfo.get('11-17')){                
               //SDQ.FORM__c = 'DS_SDQ_P_11_17';
         //emotional
                if (SDQ.BSDPSOMA__c == null){ SOMA=0; EmoNullP++;}
                  else {SOMA= Integer.valueof(SDQ.BSDPSOMA__c);}
               if ( SDQ.BSDPWORR__c== null){ WORR=0; EmoNullP++;} 
                  else {WORR= Integer.valueof(SDQ.BSDPWORR__c);}                   
               if (SDQ.BSDPUNHA__c == null){ UNHA=0; EmoNullP++;} 
                  else {UNHA= Integer.valueof(SDQ.BSDPUNHA__c);}                   
               if (SDQ.BSDPCLIN__c == null){CLIN =0;EmoNullP++;} 
                  else {CLIN= Integer.valueof(SDQ.BSDPCLIN__c);}                    
               if (SDQ.BSDPAFRA__c == null){AFRA =0; EmoNullP++;} 
                  else {AFRA= Integer.valueof(SDQ.BSDPAFRA__c);}                
                    //behavioral
               if (SDQ.BSDPTANT__c == null){ TANT=0; BehNullP++;}
                  else {TANT= Integer.valueof(SDQ.BSDPTANT__c);}
               if (SDQ.BSDPOBEY__c == null){OBEY =0; BehNullP++;}
                  else {OBEY= Integer.valueof(SDQ.BSDPOBEY__c);}
               if (SDQ.BSDPFIGH__c == null){ FIGH=0; BehNullP++;}
                  else {FIGH= Integer.valueof(SDQ.BSDPFIGH__c);}
               if (SDQ.BSDPLIES__c == null){LIES =0; BehNullP++;}
                  else {LIES= Integer.valueof(SDQ.BSDPLIES__c);}
               if (SDQ.BSDPSTEA__c == null){ STEA=0; BehNullP++;}
                  else {STEA= Integer.valueof(SDQ.BSDPSTEA__c);}                    
                    //hyperactivity
               if (SDQ.BSDPREST__c == null){ REST=0; HypNullP++;}
                  else {REST= Integer.valueof(SDQ.BSDPREST__c);}
               if (SDQ.BSDPFIDG__c == null){ FIDG=0; HypNullP++;}
                  else {FIDG= Integer.valueof(SDQ.BSDPFIDG__c);}
               if (SDQ.BSDPDIST__c == null){DIST =0; HypNullP++;}
                  else {DIST= Integer.valueof(SDQ.BSDPDIST__c);}
               if (SDQ.BSDPREFL__c == null){REFL =0; HypNullP++;}
                  else {REFL= Integer.valueof(SDQ.BSDPREFL__c);}
               if (SDQ.BSDPATTE__c == null){ ATTE=0; HypNullP++;}
                  else {ATTE= Integer.valueof(SDQ.BSDPATTE__c);}
                    //other children
               if (SDQ.BSDPLONE__c == null){ LONE=0; OtcNullP++;}
                  else {LONE= Integer.valueof(SDQ.BSDPLONE__c);}
               if (SDQ.BSDPFRIE__c == null){FRIE =0; OtcNullP++;}
                  else {FRIE= Integer.valueof(SDQ.BSDPFRIE__c);}
               if (SDQ.BSDPPOPU__c == null){POPU =0; OtcNullP++;}
                  else {POPU= Integer.valueof(SDQ.BSDPPOPU__c);}
               if (SDQ.BSDPBULL__c == null){ BULL=0; OtcNullP++;}
                  else {BULL= Integer.valueof(SDQ.BSDPBULL__c);}
               if (SDQ.BSDPOLDB__c == null){ OLDB=0; OtcNullP++;}
                  else {OLDB= Integer.valueof(SDQ.BSDPOLDB__c);}
                    //kind helpful behaviors
               if (SDQ.BSDPCONS__c == null){CONS =0; KhbNullP++;}
                  else {CONS= Integer.valueof(SDQ.BSDPCONS__c);}
               if (SDQ.BSDPSHAR__c == null){SHAR =0; KhbNullP++;}
                  else {SHAR= Integer.valueof(SDQ.BSDPSHAR__c);}
               if (SDQ.BSDPCARI__c == null){ CARI=0; KhbNullP++;}
                  else {CARI= Integer.valueof(SDQ.BSDPCARI__c);}
               if (SDQ.BSDPKIND__c == null){ KIND=0; KhbNullP++;}
                  else {KIND= Integer.valueof(SDQ.BSDPKIND__c);}
               if (SDQ.BSDPHELP__c == null){HELP =0; KhbNullP++;}
                  else {HELP= Integer.valueof(SDQ.BSDPHELP__c);}  
                  
               if (SDQ.BSDPTIME__c == null){HOWLONG =0; }
                  else {HOWLONG = Integer.valueof(SDQ.BSDPTIME__c);}
                    //impact///////////////////////////////  
               if ((SDQ.BSDPUPSET__c == null)||(SDQ.BSDPUPSET__c == '0'))
                       {UPSET=0; }
                  else {UPSET= (Integer.valueof(SDQ.BSDPUPSET__c)-1);}
                /////////////////////////////////  
               if ((SDQ.BSDPIMPH__c == null)||(SDQ.BSDPIMPH__c == '0'))
                       {IMPH=0;}
                  else {IMPH= (Integer.valueof(SDQ.BSDPIMPH__c)-1);}
                 ///////////////////////////////////// 
               if ((SDQ.BSDPIMPF__c == null)||(SDQ.BSDPIMPF__c == '0'))
                       {IMPF=0;}
                  else {IMPF= (Integer.valueof(SDQ.BSDPIMPF__c)-1);}
                 //////////////////////////////////////////// 
               if ((SDQ.BSDPIMPC__c == null)||(SDQ.BSDPIMPC__c == '0'))
                       {IMPC=0;}
                  else {IMPC= (Integer.valueof(SDQ.BSDPIMPC__c)-1);}
               ////////////////////////////////////////////////////   
               if ((SDQ.BSDPIMPL__c == null)||(SDQ.BSDPIMPL__c == '0'))
                       {IMPL=0;}
                  else {IMPL= (Integer.valueof(SDQ.BSDPIMPL__c)-1);}                  
            
            
               //total
                 SDQ.BSDPEMO__c= SOMA+WORR+UNHA+CLIN+AFRA;
                 SDQ.BSDPBEH__c= TANT+OBEY+FIGH+LIES+STEA;
                 SDQ.BSDPHYP__c= REST+FIDG+DIST+REFL+ATTE;
                 SDQ.BSDPOTC__c= LONE+FRIE+POPU+BULL+OLDB;
                 SDQ.BSDPKHB__c= CONS+SHAR+CARI+KIND+HELP;
                 SDQ.BSDPTOT__c= Integer.valueof(SDQ.BSDPEMO__c)+Integer.valueof(SDQ.BSDPBEH__c)+Integer.valueof(SDQ.BSDPHYP__c)+Integer.valueof(SDQ.BSDPOTC__c);
                 SDQ.BSDPDCL__c= IMPF+IMPC+IMPL+UPSET+IMPH;
                 
                 //significance
                     if (SDQ.BSDPTOT__c<=13){ SDQ.BSDPTYP__c='Normal/Average';}
                         else if (SDQ.BSDPTOT__c>= 17){SDQ.BSDPTYP__c='Clinical';}
                         else{SDQ.BSDPTYP__c='Borderline';}
                     if (SDQ.BSDPEMO__c<=3){SDQ.BSDPETYP__c='Normal/Average';}
                         else if (SDQ.BSDPEMO__c>= 5){SDQ.BSDPETYP__c='Clinical';}
                         else{SDQ.BSDPETYP__c='Borderline';} 
                     if (SDQ.BSDPBEH__c<=2){SDQ.BSDPBTYP__c='Normal/Average';}
                         else if (SDQ.BSDPBEH__c>= 4){SDQ.BSDPBTYP__c='Clinical';}
                         else{SDQ.BSDPBTYP__c='Borderline';}
                     if (SDQ.BSDPHYP__c<=5){SDQ.BSDPHTYP__c='Normal/Average';}
                         else if (SDQ.BSDPHYP__c>= 7){SDQ.BSDPHTYP__c='Clinical';}
                         else{SDQ.BSDPHTYP__c='Borderline';}
                     if (SDQ.BSDPOTC__c<=2){SDQ.BSDPOTYP__c='Normal/Average';}
                         else if (SDQ.BSDPOTC__c>= 4){SDQ.BSDPOTYP__c='Clinical';}
                         else{SDQ.BSDPOTYP__c='Borderline';}
                     if (SDQ.BSDPKHB__c>=6){SDQ.BSDPKTYP__c='Normal/Average';}
                         else if (SDQ.BSDPKHB__c<=4){SDQ.BSDPKTYP__c='Clinical';}
                         else{SDQ.BSDPKTYP__c='Borderline';} 
                     if (SDQ.BSDPDCL__c==0){SDQ.BSDPITYP__c='Normal/Average';}
                         else if (SDQ.BSDPDCL__c== 1){SDQ.BSDPITYP__c='Borderline';}
                         else if (SDQ.BSDPDCL__c>=2){SDQ.BSDPITYP__c='Clinical';}
                      ///////Missing   
               
                    if (EMONULLP>2){ 
                        SDQ.BSDPETYP__c ='Missing/Incomplete';
                         SDQ.BSDPTYP__c ='Missing/Incomplete';
                        }   
                     if (BEHNULLP>2){ 
                         SDQ.BSDPBTYP__c ='Missing/Incomplete';
                         SDQ.BSDPTYP__c ='Missing/Incomplete';
                         }  
                     if (HYPNULLP>2){ 
                         SDQ.BSDPHTYP__c ='Missing/Incomplete';
                         SDQ.BSDPTYP__c ='Missing/Incomplete';
                         }  
                     if (OTCNULLP>2){ 
                         SDQ.BSDPOTYP__c ='Missing/Incomplete';
                         SDQ.BSDPTYP__c ='Missing/Incomplete';
                         }  
                     if (KHBNULLP>2){ SDQ.BSDPKTYP__c ='Missing/Incomplete';}  
                                                
              SDQ.EMONULLP__c = EmoNullS;
               SDQ.BEHNULLP__c = BehNullS;
               SDQ.HYPNULLP__c = HypNullS;
               SDQ.OTCNULLP__c = OtcNullS;
               SDQ.KHBNULLP__c = KhbNullS;
               }
              // }
//////////////////////////////////////////////////OLD SELF////////////////////////////////////////////////////  
// if(SDQ.STATUS_SDQ_S_11_17__c != null){
                for(DS_DATA__c self:sdqInfo.get('Self')){                  
               //SDQ.FORM__c = 'DS_SDQ_S_11_17';           
         //emotional
                if (SDQ.BSDSSOMA__c == null){ SOMA=0; EmoNullS++;}
                  else {SOMA= Integer.valueof(SDQ.BSDSSOMA__c);}
               if ( SDQ.BSDSWORR__c== null){ WORR=0; EmoNullS++;} 
                  else {WORR= Integer.valueof(SDQ.BSDSWORR__c);}                   
               if (SDQ.BSDSUNHA__c == null){ UNHA=0; EmoNullS++;} 
                  else {UNHA= Integer.valueof(SDQ.BSDSUNHA__c);}                   
               if (SDQ.BSDSCLIN__c == null){CLIN =0;EmoNullS++;} 
                  else {CLIN= Integer.valueof(SDQ.BSDSCLIN__c);}                    
               if (SDQ.BSDSAFRA__c == null){AFRA =0; EmoNullS++;} 
                  else {AFRA= Integer.valueof(SDQ.BSDSAFRA__c);}                
                    //behavioral
               if (SDQ.BSDSTANT__c == null){ TANT=0; BehNullS++;}
                  else {TANT= Integer.valueof(SDQ.BSDSTANT__c);}
               if (SDQ.BSDSOBEY__c == null){OBEY =0; BehNullS++;}
                  else {OBEY= Integer.valueof(SDQ.BSDSOBEY__c);}
               if (SDQ.BSDSFIGH__c == null){ FIGH=0; BehNullS++;}
                  else {FIGH= Integer.valueof(SDQ.BSDSFIGH__c);}
               if (SDQ.BSDSLIES__c == null){LIES =0; BehNullS++;}
                  else {LIES= Integer.valueof(SDQ.BSDSLIES__c);}
               if (SDQ.BSDSSTEA__c == null){ STEA=0; BehNullS++;}
                  else {STEA= Integer.valueof(SDQ.BSDSSTEA__c);}                    
                    //hyperactivity
               if (SDQ.BSDSREST__c == null){ REST=0; HypNullS++;}
                  else {REST= Integer.valueof(SDQ.BSDSREST__c);}
               if (SDQ.BSDSFIDG__c == null){ FIDG=0; HypNullS++;}
                  else {FIDG= Integer.valueof(SDQ.BSDSFIDG__c);}
               if (SDQ.BSDSDIST__c == null){DIST =0; HypNullS++;}
                  else {DIST= Integer.valueof(SDQ.BSDSDIST__c);}
               if (SDQ.BSDSREFL__c == null){REFL =0; HypNullS++;}
                  else {REFL= Integer.valueof(SDQ.BSDSREFL__c);}
               if (SDQ.BSDSATTE__c == null){ ATTE=0; HypNullS++;}
                  else {ATTE= Integer.valueof(SDQ.BSDSATTE__c);}
                    //other children
               if (SDQ.BSDSLONE__c == null){ LONE=0; OtcNullS++;}
                  else {LONE= Integer.valueof(SDQ.BSDSLONE__c);}
               if (SDQ.BSDSFRIE__c == null){FRIE =0; OtcNullS++;}
                  else {FRIE= Integer.valueof(SDQ.BSDSFRIE__c);}
               if (SDQ.BSDSPOPU__c == null){POPU =0; OtcNullS++;}
                  else {POPU= Integer.valueof(SDQ.BSDSPOPU__c);}
               if (SDQ.BSDSBULL__c == null){ BULL=0; OtcNullS++;}
                  else {BULL= Integer.valueof(SDQ.BSDSBULL__c);}
               if (SDQ.BSDSOLDB__c == null){ OLDB=0; OtcNullS++;}
                  else {OLDB= Integer.valueof(SDQ.BSDSOLDB__c);}
                    //kind helpful behaviors
               if (SDQ.BSDSCONS__c == null){CONS =0; KhbNullS++;}
                  else {CONS= Integer.valueof(SDQ.BSDSCONS__c);}
               if (SDQ.BSDSSHAR__c == null){SHAR =0; KhbNullS++;}
                  else {SHAR= Integer.valueof(SDQ.BSDSSHAR__c);}
               if (SDQ.BSDSCARI__c == null){ CARI=0; KhbNullS++;}
                  else {CARI= Integer.valueof(SDQ.BSDSCARI__c);}
               if (SDQ.BSDSKIND__c == null){ KIND=0; KhbNullS++;}
                  else {KIND= Integer.valueof(SDQ.BSDSKIND__c);}
               if (SDQ.BSDSHELP__c == null){HELP =0; KhbNullS++;}
                  else {HELP= Integer.valueof(SDQ.BSDSHELP__c);}  
                  
               if (SDQ.BSDSTIME__c == null){HOWLONG =0; }
                  else {HOWLONG = Integer.valueof(SDQ.BSDSTIME__c);}
                    //impact///////////////////////////////  
               if ((SDQ.BSDSUPSET__c == null)||(SDQ.BSDSUPSET__c == '0'))
                       {UPSET=0; }
                  else {UPSET= (Integer.valueof(SDQ.BSDSUPSET__c)-1);}
                /////////////////////////////////  
               if ((SDQ.BSDSIMPH__c == null)||(SDQ.BSDSIMPH__c == '0'))
                       {IMPH=0;}
                  else {IMPH= (Integer.valueof(SDQ.BSDSIMPH__c)-1);}
                 ///////////////////////////////////// 
               if ((SDQ.BSDSIMPF__c == null)||(SDQ.BSDSIMPF__c == '0'))
                       {IMPF=0;}
                  else {IMPF= (Integer.valueof(SDQ.BSDSIMPF__c)-1);}
                 //////////////////////////////////////////// 
               if ((SDQ.BSDSIMPC__c == null)||(SDQ.BSDSIMPC__c == '0'))
                       {IMPC=0;}
                  else {IMPC= (Integer.valueof(SDQ.BSDSIMPC__c)-1);}
               ////////////////////////////////////////////////////   
               if ((SDQ.BSDSIMPL__c == null)||(SDQ.BSDSIMPL__c == '0'))
                       {IMPL=0;}
                  else {IMPL= (Integer.valueof(SDQ.BSDSIMPL__c)-1);}                  
            
               //total
                 SDQ.BSDSEMO__c= SOMA+WORR+UNHA+CLIN+AFRA;
                 SDQ.BSDSBEH__c= TANT+OBEY+FIGH+LIES+STEA;
                 SDQ.BSDSHYP__c= REST+FIDG+DIST+REFL+ATTE;
                 SDQ.BSDSOTC__c= LONE+FRIE+POPU+BULL+OLDB;
                 SDQ.BSDSKHB__c= CONS+SHAR+CARI+KIND+HELP;
                 SDQ.BSDSTOT__c= Integer.valueof(SDQ.BSDSEMO__c)+Integer.valueof(SDQ.BSDSBEH__c)+Integer.valueof(SDQ.BSDSHYP__c)+Integer.valueof(SDQ.BSDSOTC__c);
                 SDQ.BSDSDCL__c= IMPF+IMPC+IMPL+UPSET+IMPH;
                 
                 //significance
                     if (SDQ.BSDSTOT__c<=13){ SDQ.BSDSTYP__c='Normal/Average';}
                         else if (SDQ.BSDSTOT__c>= 17){SDQ.BSDSTYP__c='Clinical';}
                         else{SDQ.BSDSTYP__c='Borderline';}
                     if (SDQ.BSDSEMO__c<=3){SDQ.BSDSETYP__c='Normal/Average';}
                         else if (SDQ.BSDSEMO__c>= 5){SDQ.BSDSETYP__c='Clinical';}
                         else{SDQ.BSDSETYP__c='Borderline';} 
                     if (SDQ.BSDSBEH__c<=2){SDQ.BSDSBTYP__c='Normal/Average';}
                         else if (SDQ.BSDSBEH__c>= 4){SDQ.BSDSBTYP__c='Clinical';}
                         else{SDQ.BSDSBTYP__c='Borderline';}
                     if (SDQ.BSDSHYP__c<=5){SDQ.BSDSHTYP__c='Normal/Average';}
                         else if (SDQ.BSDSHYP__c>= 7){SDQ.BSDSHTYP__c='Clinical';}
                         else{SDQ.BSDSHTYP__c='Borderline';}
                     if (SDQ.BSDSOTC__c<=2){SDQ.BSDSOTYP__c='Normal/Average';}
                         else if (SDQ.BSDSOTC__c>= 4){SDQ.BSDSOTYP__c='Clinical';}
                         else{SDQ.BSDSOTYP__c='Borderline';}
                     if (SDQ.BSDSKHB__c>=6){SDQ.BSDSKTYP__c='Normal/Average';}
                         else if (SDQ.BSDSKHB__c<=4){SDQ.BSDSKTYP__c='Clinical';}
                         else{SDQ.BSDSKTYP__c='Borderline';} 
                     if (SDQ.BSDSDCL__c==0){SDQ.BSDSITYP__c='Normal/Average';}
                         else if (SDQ.BSDSDCL__c== 1){SDQ.BSDSITYP__c='Borderline';}
                         else if (SDQ.BSDSDCL__c>=2){SDQ.BSDSITYP__c='Clinical';}
                      ///////Missing   
               
                    if (EMONULLS>2){ 
                        SDQ.BSDSETYP__c ='Missing/Incomplete';
                         SDQ.BSDSTYP__c ='Missing/Incomplete';
                        }   
                     if (BEHNULLS>2){ 
                         SDQ.BSDSBTYP__c ='Missing/Incomplete';
                         SDQ.BSDSTYP__c ='Missing/Incomplete';
                         }  
                     if (HYPNULLS>2){ 
                         SDQ.BSDSHTYP__c ='Missing/Incomplete';
                         SDQ.BSDSTYP__c ='Missing/Incomplete';
                         }  
                     if (OTCNULLS>2){ 
                         SDQ.BSDSOTYP__c ='Missing/Incomplete';
                         SDQ.BSDSTYP__c ='Missing/Incomplete';
                         }  
                     if (KHBNULLS>2){ SDQ.BSDSKTYP__c ='Missing/Incomplete';}  
                                                
              SDQ.EMONULLS__c = EmoNullS;
               SDQ.BEHNULLS__c = BehNullS;
               SDQ.HYPNULLS__c = HypNullS;
               SDQ.OTCNULLS__c = OtcNullS;
               SDQ.KHBNULLS__c = KhbNullS;
               
               
               
                
}
//}
//////////////////////////////////////////////////////////////////////////////////////
            System.debug(SDQ.FORM__c);
        }
        
          
            
        }
    
   
  if(Trigger.isAfter) { 

    ut.updateSummaryStatusForMergedObject(Trigger.new);

    // Audit trial 
    AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }

  }
 
}