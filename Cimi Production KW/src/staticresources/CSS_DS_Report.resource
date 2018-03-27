@media print {
	@page { size:portrait; margin:0.5cm; margin-top: 0.5cm; zoom: 90%;}
    
    .pbBody {margin: 7px 0px 7px !important; }
    .charts-div { margin-left: 0px !important; }
    .overall-history { margin-top: 0px;  }
    .page-break { height: 60px; page-break-before: always ; }
    .header-info-table-page2 { float: right; width: 50%; padding-top: 0px; }
    .bPageTitle { float: left; width: 50% !important; white-space:normal;}
    .bPageTitle-page2 { float: left; width: 50%; }
    
	table, tr, td, th { page-break-inside:avoid !important; zoom: 85%;page-break-after:auto;}
	div { page-break-inside:avoid !important; } 
	
    .ptBreadcrumb { display:none; }
    .pageTitleIcon {display: none; }
    .pageDescription { display:none !important; }
    .pbBottomButtons { display: none; }   
    .pageType { font-size: 20px !important; margin-left:5px !important; }
	
	.footer{page-break-before:avoid; page-break-after:auto;}
	
	/*ptsd only*/
    .ptsd-angle-noborder { display:none; }
	/*.ptsd-table{ size: portrait;  zoom: 85%;}*/
    
    /*tscyc only*/
	/*.tscyc-table{ size: portrait; zoom: 85%;}*/
	
	/*sdq only*/
	/*
    .pageType { font-size: 16px !important; }
    .pbTitle { width:100% !important; }
	*/
	
	/*cbcl only*/
	/*.print-no-space { /*display: none;*/ }
   /* div.bootwrap .alert { margin-bottom: 0px; }
    div.bootwrap .score-table table { margin-bottom: 0px !important; }
    .page2-break { height: 80px; page-break-before: always; }
    .history-chart { margin-bottom: 17px; }
	*/
}
/*cbcl only*/
/*.darkerTDTop { border-top: 1px solid #7A7979 !important; }
.darkerTHBottom { border-bottom: 2px solid #7A7979 !important; }
.front16 { font-size: 16px; }

.form-cbcl-report .history-chart { margin-bottom: 10px; }
.print-history-chart { width: 1150px; }
.history-chart { margin-bottom: 10px; }

.warning { font-weight: normal; }
.danger { font-weight: bold; }
*/