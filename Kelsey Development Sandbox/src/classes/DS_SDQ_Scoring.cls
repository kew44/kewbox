/****
*@description Class that calculates SDQ scores and significance
*@author KW
*
*@modified 10/3-5/16    KW  parent vs self significance difference on certain subscales
*@modified	11/8-11/16		KW	loop escape/reset value debug (for uploading multiple records via DL)
*@modified	11/14-15/14		KW	clean up value out of range
****/

public class DS_SDQ_Scoring {   

    //initialize variable alias
    public Integer EMO { get; set; }//emotional
    public Integer BEH { get; set; }//behavior   
    public Integer HYP { get; set; }//hyper    
    public Integer OTC { get; set; }//peer   
    public Integer KHB { get; set; }//prosocial 
    public Integer DCL { get; set; }//impact
    
    //Total score
    public Integer TOT { get; set; }
    
    //Null counters for subscores
    public Integer EMONULL { get; set; }//emotional
    public Integer BEHNULL { get; set; }//behavior
    public Integer HYPNULL { get; set; }//hyper
    public Integer OTCNULL { get; set; }//peer
    public Integer KHBNULL { get; set; }//prosocial
    
    //Duration
    public Integer HOWLONG { get; set; }
    
    //Significance for subscales
    public String ETYP { get; set; }//emotional
    public String BTYP { get; set; }//behavior
    public String HTYP { get; set; }//hyper
    public String OTYP { get; set; }//peer
    public String KTYP { get; set; }//prosocial
    public String ITYP { get; set; }//impact  
    public String TTYP { get; set; }//total
	
	public List<String> clientList {get;set;}
    
    //parent or self
    public String PorS { get; set; }
	
		//score analysis method
		public SObject scoreAnalyzer(SObject obj) {
		
			Map<String, String> statusMap= new Map<String, String>();
			statusMap.put('Young Parent', String.valueOf(obj.get('STATUS_SDQ_P_04_10__c')));
			statusMap.put('Old Parent', String.valueOf(obj.get('STATUS_SDQ_P_11_17__c')));
			statusMap.put('Old Self', String.valueOf(obj.get('STATUS_SDQ_S_11_17__c')));
			
			//client ids
			String clientId = String.valueOf(obj.get('Client__c'));
			
			//list of froms
			List<String> formsList = new List<String>();
			
			//map client to forms
			Map<String, List<String>> clientForms = new Map<String,List<String>>();
		
			for (String s: statusMap.keySet()){
				//alias
				String statusValue = String.valueOf(statusMap.get(s));
				
				if(statusValue != null){
					formsList.add(s);
				}
				
			}
			System.debug(formsList);
								
			scoringBody(obj, formsList);
            return obj;
        }
        
		//find significance method
        public void findSignificance(String BorF, String PorS, String prefix, Integer nullCount, Integer subScore  ){
            //total
            if(prefix == 'TOT'){
                if(TTYP != 'Missing/Incomplete'){
                    //parent
                    if(PorS == 'P'){
                        //normal range0-13
                        if(subScore <= 13){
                            TTYP = 'Normal/Average';
                        }
                        //clinical range 17-40
                        else if(subScore >= 17){
                            TTYP = 'Clinical';
                        }
                        //borderline range 14-16
                        else{
                            TTYP = 'Borderline';
                        }
                    }
                    //self
                    else if(PorS == 'S'){
                        //normal range0-15
                        if(subScore <= 15){
                            TTYP = 'Normal/Average';
                        }
                        //clinical range 20-40
                        else if(subScore >= 20){
                            TTYP = 'Clinical';
                        }
                        //borderline range 16-19
                        else{
                            TTYP = 'Borderline';
                        }
                    }
                }
            }
        
            //emotional
            else if(prefix == 'EMO'){
                //check null count
                if(nullCount <= 2){
                    //parent
                    if(PorS =='P'){
                        //normal range 0-3
                        if(subScore <= 3){
                            ETYP = 'Normal/Average';
                        }
                        //clinical range 5-10
                        else if(subScore >=5){
                            ETYP = 'Clinical';
                        } 
                        //borderline range 4
                        else{   
                            ETYP = 'Borderline';                    
                        }
                    }
                    //self
                    else if(PorS =='S'){
                        //normal range 0-5
                        if(subScore <= 5){
                            ETYP = 'Normal/Average';
                        }
                        //clinical range 7-10
                        else if(subScore >= 7){
                            ETYP = 'Clinical';
                        }
                        //borderline range 6
                        else{                       
                            ETYP = 'Borderline';
                        }
                    }
                }
                 //check if 2 or more
                else if(nullCount > 2){
                    ETYP = 'Missing/Incomplete';
                }
            }
                        
            //behavioral
            else if(prefix == 'BEH'){       
                //check null count
                if(nullCount <= 2){
                    //parent
                    if(PorS =='P'){
                        //normal range 0-2
                        if(subScore <= 2){
                            BTYP = 'Normal/Average';
                        }
                        //clinical range 4-10
                        else if(subScore >=4){
                            BTYP = 'Clinical';
                        }
                        //borderline range 3
                        else{   
                            BTYP = 'Borderline';                    
                        }
                    }
                    //self
                    else if(PorS =='S'){
                        //normal range 0-3
                        if(subScore <= 3){
                            BTYP = 'Normal/Average';
                        }
                        //clinical range 5-10
                        else if(subScore >= 5){
                            BTYP = 'Clinical';
                        }
                        //borderline range 4
                        else{                       
                            BTYP = 'Borderline';
                        }
                    }
                }
                else if(nullCount > 2){
                    BTYP = 'Missing/Incomplete';
                }
            }       
            
            //peer
            else if(prefix == 'OTC'){
                //check null count
                if(nullCount <= 2){
                    //parent
                    if(PorS =='P'){
                        //normal range 0-2
                        if(subScore <= 2){
                            OTYP = 'Normal/Average';
                        }
                        //clinical range 4-10
                        else if(subScore >=4){
                            OTYP = 'Clinical';
                        }
                        //borderline range 3
                        else{   
                            OTYP = 'Borderline';                    
                        }
                    }
                    //self
                    else if(PorS =='S'){
                        //normal range 0-3
                        if(subScore <= 3){
                            OTYP = 'Normal/Average';
                        }
                        //clinical range 6-10
                        else if(subScore >= 6){
                            OTYP = 'Clinical';
                        }
                        //borderline range 4-5
                        else{                       
                            OTYP = 'Borderline';
                        }
                    }
                }
                else if(nullCount > 2){
                    OTYP = 'Missing/Incomplete';
                }
            }
                    
            ///scales where significance is the same for both parent and self
            //hyperactivity
            else if(prefix =='HYP'){
                //check null count
                if(nullCount <= 2){             
                    //normal range 0-5
                    if(subScore <= 5){
                        HTYP = 'Normal/Average';
                    }
                    //clinical range 7-10
                    else if(subScore >=7){
                        HTYP = 'Clinical';
                    }
                    //borderline range 6
                    else{   
                        HTYP = 'Borderline';                    
                    }               
                }
                else if(nullCount > 2){
                    HTYP = 'Missing/Incomplete';
                }
            }
                                    
            //prosocial
            else if(prefix =='KHB'){
                //check null count (this does not affect overall significance if missing)
                if(nullCount <= 2){                 
                    //normal range 6-10
                    if(subScore >= 6){
                        KTYP = 'Normal/Average';
                    }
                    //clinical range 0-4
                    else if(subScore <= 4){
                        KTYP = 'Clinical';
                    }
                    //borderline range 5
                    else{   
                        KTYP = 'Borderline';                    
                    }               
                }
                else if(nullCount > 2){
                    KTYP = 'Missing/Incomplete';
                }
            }
            
            //impact (no null count)
            else if(prefix =='DCL'){
                //normal range 0
                if(subScore < 1){
                    ITYP = 'Normal/Average';
                }
                //clinical range 2-10
                else if(subScore >= 2){
                    ITYP = 'Clinical';
                }
                //borderline range 1
                else{   
                    ITYP = 'Borderline';                    
                }
            }
        }
        
		//scoring calculation method
        public SObject scoringBody(SObject obj, List<String> formsList) {
			
            //string of object name
            String thisObject =String.valueOf(obj.getsObjectType());
            
            //B or F function based on object name
            String BorF = (thisObject == 'DS_SDQ_PSI_CDI_B__c') ? 'B' : 'F'; 
            		            
			//loop through the list of forms for a particular record
			for(String fl : formsList){
				System.debug(fl);
				//parent or self form determines what variables
				String Pors = (fl == 'Old Self') ? 'S' : 'P';
				System.debug(PorS);
			
				//initialize null counters
				EMONULL = 0;
				BEHNULL = 0;
				HYPNULL = 0;
				OTCNULL = 0;
				KHBNULL = 0;
				
				//initialize sums
				 EMO = 0;
				 BEH = 0;
				 HYP = 0;
				 OTC = 0;
				 KHB = 0;
				 DCL = 0;
				 TOT = 0;
				 
				 //initialize significance
				 ETYP = '';
				 BTYP = '';
				 HTYP = '';
				 OTYP = '';
				 KTYP = '';
				 ITYP = '';
				 TTYP = '';
				 
				//map for each subscore type
				Map<String,Integer> EmoMap = new Map<String,Integer>();     
				Map<String,Integer> BehMap = new Map<String,Integer>();
				Map<String,Integer> HypMap = new Map<String,Integer>();
				Map<String,Integer> OtcMap = new Map<String,Integer>();
				Map<String,Integer> KhbMap = new Map<String,Integer>();
				Map<String,Integer> DclMap = new Map<String,Integer>();
				Map<String,Integer> TotMap = new Map<String,Integer>();         
				
				//add subscales and key to maps
				//EMO 
				EmoMap.put('SOMA', Integer.valueOf(obj.get(BorF+'SD'+PorS+'SOMA__c')));
				EmoMap.put('WORR', Integer.valueOf(obj.get(BorF+'SD'+PorS+'WORR__c')));
				EmoMap.put('UNHA', Integer.valueOf(obj.get(BorF+'SD'+PorS+'UNHA__c')));
				EmoMap.put('CLIN', Integer.valueOf(obj.get(BorF+'SD'+PorS+'CLIN__c')));
				EmoMap.put('AFRA', Integer.valueOf(obj.get(BorF+'SD'+PorS+'AFRA__c')));
				//BEH
				BehMap.put('TANT', Integer.valueOf(obj.get(BorF+'SD'+PorS+'TANT__c')));
				BehMap.put('OBEY', Integer.valueOf(obj.get(BorF+'SD'+PorS+'OBEY__c')));
				BehMap.put('FIGH', Integer.valueOf(obj.get(BorF+'SD'+PorS+'FIGH__c')));
				BehMap.put('LIES', Integer.valueOf(obj.get(BorF+'SD'+PorS+'LIES__c')));
				BehMap.put('STEA', Integer.valueOf(obj.get(BorF+'SD'+PorS+'STEA__c')));
				//HYP
				HypMap.put('REST', Integer.valueOf(obj.get(BorF+'SD'+PorS+'REST__c')));
				HypMap.put('FIDG', Integer.valueOf(obj.get(BorF+'SD'+PorS+'FIDG__c')));
				HypMap.put('DIST', Integer.valueOf(obj.get(BorF+'SD'+PorS+'DIST__c')));
				HypMap.put('REFL', Integer.valueOf(obj.get(BorF+'SD'+PorS+'REFL__c')));
				HypMap.put('ATTE', Integer.valueOf(obj.get(BorF+'SD'+PorS+'ATTE__c')));
				//OTC
				OtcMap.put('LONE', Integer.valueOf(obj.get(BorF+'SD'+PorS+'LONE__c')));
				OtcMap.put('FRIE', Integer.valueOf(obj.get(BorF+'SD'+PorS+'FRIE__c')));
				OtcMap.put('POPU', Integer.valueOf(obj.get(BorF+'SD'+PorS+'POPU__c')));
				OtcMap.put('BULL', Integer.valueOf(obj.get(BorF+'SD'+PorS+'BULL__c')));
				OtcMap.put('OLDB', Integer.valueOf(obj.get(BorF+'SD'+PorS+'OLDB__c')));
				//KHB
				KhbMap.put('CONS', Integer.valueOf(obj.get(BorF+'SD'+PorS+'CONS__c')));
				KhbMap.put('SHAR', Integer.valueOf(obj.get(BorF+'SD'+PorS+'SHAR__c')));
				KhbMap.put('CARI', Integer.valueOf(obj.get(BorF+'SD'+PorS+'CARI__c')));
				KhbMap.put('KIND', Integer.valueOf(obj.get(BorF+'SD'+PorS+'KIND__c')));
				KhbMap.put('HELP', Integer.valueOf(obj.get(BorF+'SD'+PorS+'HELP__c')));
				//DCL
				DclMap.put('UPSET', Integer.valueOf(obj.get(BorF+'SD'+PorS+'UPSET__c')));   
				DclMap.put('IMPH', Integer.valueOf(obj.get(BorF+'SD'+PorS+'IMPH__c'))); 
				DclMap.put('IMPF', Integer.valueOf(obj.get(BorF+'SD'+PorS+'IMPF__c'))); 
				DclMap.put('IMPC', Integer.valueOf(obj.get(BorF+'SD'+PorS+'IMPC__c'))); 
				DclMap.put('IMPL', Integer.valueOf(obj.get(BorF+'SD'+PorS+'IMPL__c')));
				
				System.debug(EmoMap);
				System.debug(BehMap);
				System.debug(HypMap);
				System.debug(OtcMap);
				System.debug(KhbMap);
				System.debug(DclMap);
				
				//emotional scores		
				for(String e: EmoMap.keySet()){             
					//tmp alias of value
					Integer eVal = Integer.valueOf(EmoMap.get(e));
					//tmp variable string name
					String eVar = String.valueOf(BorF+'SD'+PorS+e+'__c');
					
					//count nulls
					if(eVal == null){
						EMONULL ++;
					}
					//if not null, add to subtotal and assign to object 
					else{
						//handle values outside of expected range
						if((eVal>2)||(eVal<0)){
							obj.addError('The value you have entered for variable '+ eVar + ' (' + eVal + ') is out of range. Please review Client # '+ obj.get('Client__c') +'.');
							//maybe set to null and increment counter?
						}
						else{
							EMO = EMO + eVal;
							obj.put(eVar, String.valueOf(eVal));
						}
					}    
					//subtotal
					obj.put(BorF+'SD'+PorS+'EMO__c', EMO);    		
					obj.put(BorF+'EMONULL'+PorS+'__c',EMONULL);
				}
				//subscore significance
				findSignificance(BorF, PorS,  'EMO', EMONULL, EMO);            
				obj.put(BorF+'SD'+PorS+'ETYP__c',ETYP);
						
				//behaviorial
				for(String b : BehMap.keySet()){                        
					//tmp alias of value
					Integer bVal = Integer.valueOf(BehMap.get(b));
					//tmp variable string name
					String bVar = String.valueOf(BorF+'SD'+PorS+b+'__c');
						
					//count nulls				
					if(bVal == null){
						BEHNULL ++;
					}				
					//if not null, add to subtotal and assign to object 
					else{
						//handle values outside of expected range
						if((bVal>2)||(bVal<0)){
							obj.addError('The value you have entered for variable '+ bVar + ' (' + bVal + ') is out of range. Please review Client # '+ obj.get('Client__c') +'.');
						}
						else{
							BEH = BEH + bVal;
							obj.put(bVar, String.valueOf(bVal));
						}
					}   
					//subtotal
					obj.put(BorF+'SD'+PorS+'BEH__c', BEH);
					obj.put(BorF+'BEHNULL'+PorS+'__c',BEHNULL);
				}
				//subscore significance
				findSignificance(BorF, PorS,  'BEH', BEHNULL, BEH);
				obj.put(BorF+'SD'+PorS+'BTYP__c', BTYP);

				//hyperactivity
				for(String h : HypMap.keySet()){                
					//tmp alias of value
					Integer hVal = Integer.valueOf(HypMap.get(h));
					//tmp variable string name
					String hVar = String.valueOf(BorF+'SD'+PorS+h+'__c');
					
					//count nulls	
					if(hVal == null){
						HYPNULL ++;
					}
					//if not null, add to subtotal and assign to object 
					else{
						//handle values outside of expected range
						if((hVal>2)||(hVal<0)){
							obj.addError('The value you have entered for variable '+ hVar + ' (' + hVal + ') is out of range. Please review Client # '+ obj.get('Client__c') +'.');
						}
						else{
							HYP = HYP + hVal;
							obj.put(hVar, String.valueOf(hVal));
						}
					}
					//subtotal
					obj.put(BorF+'SD'+PorS+'HYP__c', HYP);
					obj.put(BorF+'HYPNULL'+PorS+'__c',HYPNULL);
				}  
				//subscore significance
				findSignificance(BorF, PorS,  'HYP', HYPNULL, HYP);
				obj.put(BorF+'SD'+PorS+'HTYP__c', HTYP);
							
				//peer
				for(String o : OtcMap.keySet()){                
					//tmp alias of value
					Integer oVal = Integer.valueOf(OtcMap.get(o));
					//tmp variable string name
					String oVar = String.valueOf(BorF+'SD'+PorS+o+'__c');
					
					//count nulls	
					if(oVal == null){
						OTCNULL ++;
					}
					//if not null, add to subtotal and assign to object 
					else{
						//handle values outside of expected range
						if((oVal>2)||(oVal<0)){
							obj.addError('The value you have entered for variable '+ oVar + ' (' + oVal + ') is out of range. Please review Client # '+ obj.get('Client__c') +'.');
						}
						else{
							OTC = OTC + oVal;
							obj.put(oVar, String.valueOf(oVal));
						}
					}       
					//subtotal
					obj.put(BorF+'SD'+PorS+'OTC__c', OTC);
					obj.put(BorF+'OTCNULL'+PorS+'__c',OTCNULL);           
				}
				//subscore significance
				findSignificance(BorF, PorS,  'OTC', OTCNULL, OTC);
				obj.put(BorF+'SD'+PorS+'OTYP__c', OTYP);
				
				//prosocial
				for(String k : KhbMap.keySet()){            
					//tmp alias of value
					Integer kVal = Integer.valueOf(KhbMap.get(k));
					//tmp variable string name
					String kVar = String.valueOf(BorF+'SD'+PorS+k+'__c');
									
					//count nulls		
					if(kVal == null){
						KHBNULL ++;
					}
					//if not null, add to subtotal and assign to object 
					else{
						//handle values outside of expected range
						if((kVal>2)||(kVal<0)){
							obj.addError('The value you have entered for variable '+ kVar + ' (' + kVal + ') is out of range. Please review Client # '+ obj.get('Client__c') +'.');
						}
						else{
							KHB = KHB + kVal;
							obj.put(kVar, String.valueOf(kVal));
						}
					}
					//subtotal
					obj.put(BorF+'SD'+PorS+'KHB__c', KHB);
					obj.put(BorF+'KHBNULL'+PorS+'__c',KHBNULL);
				}
				//subscore significance
				findSignificance(BorF, PorS,  'KHB', KHBNULL, KHB);
				obj.put(BorF+'SD'+PorS+'KTYP__c', KTYP);
				
				//impact 
				for(String d: DclMap.keySet()){             
					//tmp alias of value
					Integer dVal = Integer.valueOf(DclMap.get(d));
					//tmp variable string name
					String dVar = String.valueOf(BorF+'SD'+PorS+d+'__c');
					
					//if null or 0, set to 0 (no null count)    
					if((dVal == null) || (dVal == 0)){
						dVal = 0;
					}
					//if not, subtract 1 from value (hand-score values are 0,0,1,2)
					else{
						//handle values outside of expected range
						if((dVal>3)||(dVal<0)){
							obj.addError('The value you have entered for variable '+ dVar + ' (' + dVal + ') is out of range. Please review Client # '+ obj.get('Client__c') +'.');
						}
						else{
							dVal = dVal -1;
						}
					}
					//subtotal
					DCL = DCL + dVal;
					obj.put(BorF+'SD'+PorS+'DCL__c', DCL);
				}                   
				//subscore significance
				findSignificance(BorF, PorS,  'DCL', 0, DCL);
				obj.put(BorF+'SD'+PorS+'ITYP__c',ITYP);
				
				//duration--short, doesn't need map or alias
				if ((obj.get(BorF+'SD'+PorS+'TIME__c')) == null){
					HOWLONG =0; 
				}
				else {
					HOWLONG  = Integer.valueOf(obj.get(BorF+'SD'+PorS+'TIME__c'));
				}
				obj.put(BorF+'SD'+PorS+'TIME__c', String.valueOf(HOWLONG));
				
				//TOT subscale map 
				TotMap.put('EMO', Integer.valueOf(obj.get(BorF+'SD'+PorS+'EMO__c')));   
				TotMap.put('BEH', Integer.valueOf(obj.get(BorF+'SD'+PorS+'BEH__c')));   
				TotMap.put('HYP', Integer.valueOf(obj.get(BorF+'SD'+PorS+'HYP__c')));   
				TotMap.put('OTC', Integer.valueOf(obj.get(BorF+'SD'+PorS+'OTC__c')));   
							
				//total (TOT = EMO+BEH+HYP+OTC)
				for(String t : TotMap.keySet()){					
					//alias number missing per subscale
					Integer tMiss = Integer.valueOf(obj.get(BorF+t+'NULL'+PorS+'__c'));
					
					//alias subscale value
					Integer tVal = Integer.valueOf(TotMap.get(t));
										
					//more than 2 skipped questions 
					if(tMiss >2){
						TTYP = 'Missing/Incomplete';
					}					
					TOT = TOT + tVal;
					//total 
					obj.put(BorF+'SD'+PorS+'TOT__c', TOT);
				}            				
				//significance
				findSignificance(BorF, PorS,  'TOT', 0, TOT);//use 0 as placeholder for nullcount				
				obj.put(BorF+'SD'+PorS+'TYP__c', TTYP);                     
							
				System.debug(PorS + ' Emo is missing ' + (obj.get(BorF+'EMONULL'+PorS+'__c')) + '. Subtotal is ' + (obj.get(BorF+'SD'+PorS+'EMO__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'ETYP__c')));
				System.debug(PorS + ' Beh is missing ' + (obj.get(BorF+'BEHNULL'+PorS+'__c')) + '. Subtotal is ' + (obj.get(BorF+'SD'+PorS+'BEH__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'BTYP__c')));
				System.debug(PorS + ' Hyp is missing ' + (obj.get(BorF+'HYPNULL'+PorS+'__c')) + '. Subtotal is ' + (obj.get(BorF+'SD'+PorS+'HYP__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'HTYP__c')));
				System.debug(PorS + ' Otc is missing ' + (obj.get(BorF+'OTCNULL'+PorS+'__c')) + '. Subtotal is ' + (obj.get(BorF+'SD'+PorS+'OTC__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'OTYP__c')));
				System.debug(PorS + ' Khb is missing ' + (obj.get(BorF+'KHBNULL'+PorS+'__c')) + '. Subtotal is ' + (obj.get(BorF+'SD'+PorS+'KHB__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'KTYP__c')));
				System.debug(PorS + ' Impact is ' + (obj.get(BorF+'SD'+PorS+'DCL__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'ITYP__c')));    
				System.debug(PorS + ' Total is ' + (obj.get(BorF+'SD'+PorS+'TOT__c')) + '. Significance is ' + (obj.get(BorF+'SD'+PorS+'TYP__c')));				
				System.debug(obj.get('Client__c') + ', ' + PorS +', EMO= '+ EMO +', BEH= '+ BEH +', OTC= '+ OTC +', HYP= '+ HYP +', KHB= '+ KHB +', TOT= '+ TOT);
			}
			return obj;
        }       
    }