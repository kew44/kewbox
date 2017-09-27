@isTest
private class TestClass_exampleCon {

     static TestMethod void Test_example() {
         
         exampleCon e = new exampleCon();
         
         PageReference epage = e.incrementCounter();
         
         Integer eint = e.getCount();
     
     }

}