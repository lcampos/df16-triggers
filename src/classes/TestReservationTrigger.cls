@isTest
public class TestReservationTrigger {

    static testMethod void testCreateReservation() {
        // Create test user.
        List<User> adminUsers = TestUtil.createUsers(1, 'System Administrator');
        // Create Hotel data.
        List<Hotel__c> lHotels = TestDataUtil.createHotels(1);
        // Create Room data.
        List<Room__c> lRooms = TestDataUtil.createRooms(4, lHotels.get(0).Id);
        // Create Promo Code data.
        List<Promo_Code__c> lPromoCodes = TestDataUtil.createPromoCodes(2, lHotels.get(0).Id);
        // Create Contact data.
        List<Contact> lContacts = TestDataUtil.createContacts(2);

        System.runAs(adminUsers.get(0)) {
            // Assign perm set
            //TestUtil.addPermissionSet(adminUsers, 'Booking_Mgmt');
            Reservation__c oRes = new Reservation__c();
            oRes.Check_In__c = Date.today();
            oRes.Check_Out__c = Date.today().addDays(2);
            oRes.Contact__c = lContacts.get(0).Id;
            oRes.Promo_Code_Num__c = lPromoCodes.get(0).Code__c;
            oRes.Room__c = lRooms.get(0).Id;

            insert oRes;

            List<Invoice__c> lInvoices = [select Id,
                                                Discount__c,
                                                Promo_Code__c,
                                                Reservation__c,
                                                Total__c from Invoice__c
                                                where Reservation__c =: oRes.Id];

            System.assert(lInvoices.size() == 1, 'Number of invoices should be 1, created ' + lInvoices.size() + ' invoices.');
            System.assert(lInvoices.get(0).Discount__c == '$' + lPromoCodes.get(0).Discount__c, 'Discount is wrong.');
            System.assert(lInvoices.get(0).Promo_Code__c == lPromoCodes.get(0).Id, 'Promo Code was not correctly associated.');
            System.assert(lInvoices.get(0).Total__c == (2 * lRooms.get(0).Price__c - lPromoCodes.get(0).Discount__c), 'Total was not correctly calculated.');
        }

    }
}