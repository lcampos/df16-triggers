@isTest
public class TestDataUtil {

    public static List<Contact> createContacts(Integer iNum) {
        List<Contact> lResult = new List<Contact>();

        for (Integer i = 0; i < iNum; i++) {
            Contact ocontact = new Contact();
            ocontact.FirstName = 'Tester';
            ocontact.LastName = 'McCoy' + i + TestUtil.getTimeStamp();
            ocontact.Email = 'tester.mccoy' + TestUtil.getTimeStamp()+''+i+'@salesforce.com.test';
            ocontact.Phone = String.valueOf(TestUtil.getRandomInteger(1000000000));

            lResult.add(ocontact);
        }

        insert lResult;
        return lResult;
    }

    public static List<Hotel__c> createHotels(Integer iNum) {
        List<Hotel__c> lResult = new List<Hotel__c>();

        for (Integer i = 0; i < iNum; i++) {
            Hotel__c ohotel = new Hotel__c();
            ohotel.Name = 'Hotel Yorba ' + TestUtil.getRandomUniqueString(5);
            ohotel.Street__c = '123 Mission St';
            ohotel.City__c = 'San Francisco';
            ohotel.Country__c = 'US';
            ohotel.Phone__c = String.valueOf(TestUtil.getRandomInteger(1000000000));
            ohotel.State__c = 'CA';
            ohotel.Zip_Code__c = '94134';

            lResult.add(ohotel);
        }

        insert lResult;
        return lResult;
    }

    public static List<Promo_Code__c> createPromoCodes(Integer iNum, Id hotelID) {
        List<Promo_Code__c> lResult = new List<Promo_Code__c>();

        for (Integer i = 0; i < iNum; i++) {
            Promo_Code__c opc = new Promo_Code__c();
            opc.Code__c = TestUtil.getRandomUniqueString(5);
            opc.Discount__c = 10;
            opc.Hotel__c = hotelID;
            opc.Is_Active__c = true;

            lResult.add(opc);
        }

        insert lResult;
        return lResult;
    }

    public static List<Room__c> createRooms(Integer iNum, Id hotelID) {
        List<Room__c> lResult = new List<Room__c>();

        for (Integer i = 0; i < iNum; i++) {
            Room__c oroom = new Room__c();
            oroom.Beds__c = String.valueOf(1 + i);
            oroom.Hotel__c = hotelID;
            oroom.Price__c = 10 * (i + 1);

            lResult.add(oroom);
        }

        insert lResult;
        return lResult;
    }

}