        .cocap-heading{ 
            font-weight:bold; 
            padding-left:2px;
          }
          .pageTitleIcon {             
             display: inline-block !important;
             width: 40px;
             height: 40px;
          }
          div.bootwrap h1, div.bootwrap h2{
             margin: 5px !important;    
          }
          .pageDescription{
             font-size: 1.4em !important;
              margin-left: 40px !important;
              padding: 0px !important;              
          }
        .report-table{
            padding-left:10px;
            width:66%;
            margin-bottom: 10px;   
        }
        .small-cocap{
            margin-bottom: 5px !important;
            border-bottom-width: 0px !important;   
         }

        div.bootwrap .table-striped > tbody > tr:nth-child(2n+1) {
          background-color: rgba(128, 100, 162, 0.30);/*rgba(173, 228, 255, 0.69)*/
          border:none;      
       }
       .rt-col{
          width: 30px;
           text-align: right;
           border-left: none;
            padding-right: 2px;    
       }
        body div.bootwrap{
            font-size:1.2em;
        }    
        .cocap-info{ text-align:left; 
            font-weight:bold; 
            float:left; 
          }
        .cocap-button{
            text-align:left;
            padding:0px;
            margin-bottom:5px !important;
            float:right;
            pull:top;
            vertical-align:top;
        }

        .pbHeader .pbTitle{
            width:100%;
            text-align: left;
            word-wrap: normal;
            overflow-wrap: normal;
            white-space:nowrap;
        }

        .bPageBlock{ 
           margin: 0px; 
           padding: 2px; 
            border-bottom-width: 
                0px !important;   
          }
          #loadDiv   {
              height: 100%;
             float: right !important;
              text-align: right;
              vertical-align: bottom;
              display: inline-block;
              width: 100%;
          }
       
        .dateFoot{
            display: none;
        }

        #spinner{
            float: right !important;
        }

        div.bootwrap .glyphicon-print::before {
            content: "\e045";
        }

        @media print{
            @page{ size:portrait;  margin:0.5cm;  margin-top:0.5cm; border:none; }

            #bodyCell{
                width:100%; 
                border: 0px transparent !important;
            }
            
            #sidebarDiv{display:none;}            
            #globalHeaderBar{display:none;}
            
            table{padding:0px;}

            .pbBody {     
                margin: 5px 0px 5px !important; 
                border:none;
            }
            
            .pbTitle{ 
                white-space:nowrap; 
                height:75%; 
                padding:2px;
                border-bottom: none;
            }
            
            .pageDescription {
                height:75%; 
                white-space:nowrap; 
            }

            .bPageBlock{  
                padding:none;    
                border: none !important;
            }

            .pbHeader{
                height: 75%;
                text-align: left;
                word-wrap: normal;
                    overflow-wrap: normal;
                width: auto;
                border: none;
            }
            .apexp{ border:0px; }

            .ptBreadcrumb{display:none;}
            .bPageHeader{display:none;}
            .bPageFooter{display:none;}
            .pbBottomButtons { display: none; }   
            
            .page-break { 
                height: 30px; 
                page-break-before: always; 
            }
            
            .report-table{
                padding-left: 2px;
                border:black 1px solid;
            }
            
            .row-print-border{
                padding:2px !important;
                border-top:  black 1px solid;
                border-bottom:  black 1px solid;
            }
            
            .cocap-input{display:none;}
            .noprint { display : none; }
            .dateFoot{display: inherit;}
        }