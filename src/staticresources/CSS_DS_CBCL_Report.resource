.darkerTDTop { border-top: 1px solid #7A7979 !important; }
.darkerTHBottom { border-bottom: 2px solid #7A7979 !important; }
.front16 { font-size: 16px; }

.form-cbcl-report .history-chart { margin-bottom: 10px; }
.print-history-chart { width: 1150px; }
.history-chart { margin-bottom: 10px; }

.warning { font-weight: normal; }
.danger { font-weight: bold; }

@media print {
    @page { size: portrait; margin:0.5cm; margin-top: 0.5cm; zoom: 90%;}
    
    .print-no-space { /*display: none;*/ }
    div.bootwrap .alert { margin-bottom: 0px; }
    div.bootwrap .score-table table { margin-bottom: 0px !important; }
    .pbBody {     margin: 7px 0px 7px !important; }
    .charts-div { margin-left: 3px !important; }
    .overall-history { margin-top: 0px;  }
    .page2-break { height: 80px; page-break-before: always; }
    .history-chart { margin-bottom: 17px; }
    .header-info-table-page2 { float: right; width: 50%; padding-top: 0px; }
    .bPageTitle-page2 { float: left; width: 50%; }
}