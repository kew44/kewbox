public with sharing class test_collapse {

    public List<visit> visits { get; set; }

    class visit {
        
       public String title { get; set; }
       public String sectionNumber { get; set; }
       
       public visit(String title, String sectionNumber) {
       
           this.title = title;
           this.sectionNumber = sectionNumber;
           
       }
    
    }

    public test_collapse(ApexPages.StandardController controller) {
        
        visits = new List<visit>();
        visits.add(new visit('05/04/2015', '3'));
        visits.add(new visit('01/04/2015', '2'));
        visits.add(new visit('11/04/2014', '1'));
        
    
    }

}