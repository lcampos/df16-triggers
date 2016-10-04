@isTest
public class TestDataUtil {

    public static List<Session__c> createSessions(Integer iNum, Boolean sameDateTime) {
        List<Session__c> lResult = new List<Session__c>();
        DateTime sessionDate = DateTime.now();

        for (Integer i = 0; i < iNum; i++) {
            Session__c osession = new Session__c();
            osession.Name = 'Test ' + i;
            if (sameDateTime) {
               osession.Date__c = sessionDate;
            } else {
                osession.Date__c = sessionDate.addDays(i);
            }

            osession.Description__c = 'Test description';
            lResult.add(osession);
        }

        insert lResult;
        return lResult;
    }

    public static List<Speaker__c> createSpeakers(Integer iNum) {
        List<Speaker__c> lResult = new List<Speaker__c>();

        for(Integer i = 0; i < iNum; i++) {
            Speaker__c speaker = new Speaker__c();
            speaker.Email__c = 'testspeaker'+i+'@df16.test';
            speaker.FirstName__c = 'Tester';
            speaker.LastName__c = 'The ' + i;
            speaker.Title__c = 'Software Engineer';
            lResult.add(speaker);
        }

        insert lResult;
        return lResult;
    }

}