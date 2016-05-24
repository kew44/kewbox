@media print {
    @page { 
		margin:0.5cm; 
		margin-top: 0.5cm; 
		zoom: 90%;	
		size: 8.5in 11in portrait; 
	}
	
	.pbBody {     margin: 7px 0px 7px !important; }
	.charts-div { margin-left: 0px !important; }
	.overall-history { margin-top: 0px;  }
	.page-break { height: 60px; page-break-before: always; }
	.header-info-table-page2 { float: right; width: 50%; padding-top: 0px; }
	.bPageTitle-page2 { float: left; width: 50%; }
    		
	div.bootwrap .alert { margin-bottom: 0px; }
	div.bootwrap .score-table table { margin-bottom: 0px !important; }
	.page2-break { height: 80px; page-break-before: always;  margin-top: 0px;  }
	.history-chart { margin-bottom: 17px; }

	.pageType { font-size: 16px !important; }/*.pageType { font-size: 20px !important; margin-left:5px !important; }*/
	.pbTitle { width:100% !important; }
		
	/*do not show elements on printed form*/
	.ptBreadcrumb { display:none; }
    .pageTitleIcon {display: none; }
    .pageDescription { display:none !important; }
    .pbBottomButtons { display: none; }   
	
	/*ptsd arrow*/
		.ptsd-angle-noborder { display:none; border:none !important; }
	/*tscyc table*/
		.tscyc-table{ size: portrait;  margin-top: 0.5cm;zoom: 85%;}
		
	#trauma-history td {color: #FFFFFF;}
	#trauma-history td.info {color: #000000;font-weight: bold;}
}

.warning { font-weight: normal; }
.danger { font-weight: bold; }

.print-chart-width { width: 1100px; }

/*Client Summary Report*/
.report-heading { 
	color: #31708f;
	background-color: #d9edf7;
	border-color: #bce8f1;
	padding: 10px 15px;
	border-bottom: 1px solid transparent;
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
}
.report-description {margin: 10px;padding:7px; font-size: 14px;}
.report-content {margin: 10px;padding:7px;}
.well-max{max-width:500px;}
.ul-no-pad{padding-left:0px;}
.content-table { max-width:600px !important; margin-left:30px !important; }
.content-table-col-A{width:300px;}
.content-table-col-Y{width:75px;}
.content-table-col-Z{width:150px;}
