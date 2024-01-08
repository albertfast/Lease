@isTest
public class UpdateContactMailingAddressTest {
    @isTest
    public static void testAddressCopy() {
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();

        for (Integer i = 1; i < 5; i++) {
            Account acc = new Account(Name = 'Test' + i, BillingCity = 'New York', BillingCountry = 'USA');
            accList.add(acc);
        }
        insert accList;

        for (Account acc : accList) {
            Contact con = new Contact();
            con.LastName = 'test';
            con.AccountId = acc.Id;
            conList.add(con);
        }
        insert conList;

        Test.startTest();
        // Assuming your batch class is named UpdateContactMailingAddress
        UpdateContactMailingAddress accProcess = new UpdateContactMailingAddress();
        // Start the batch job
        Database.executeBatch(accProcess);

        // Wait for the batch job to finish
        // You can add additional logic to wait until the batch job completes

        Test.stopTest();

        // Query for the contacts with the updated MailingCity
        Integer countedContact = [SELECT COUNT() FROM Contact WHERE MailingCity = 'New York'];
        System.assertEquals(4, countedContact, 'Mismatch in the number of contacts with MailingCity');
    }
}
