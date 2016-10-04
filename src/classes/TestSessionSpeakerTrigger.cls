@isTest
public class TestSessionSpeakerTrigger {

    static testMethod void testCreateSessionSpeaker() {
        // Create test user.
        List<User> adminUsers = TestUtil.createUsers(1, 'System Administrator');
        // Create Session data.
        List<Session__c> lSessions = TestDataUtil.createSessions(2, false);
        // Create Speaker data.
        List<Speaker__c> lSpeakers = TestDataUtil.createSpeakers(1);

        System.runAs(adminUsers.get(0)) {
            //Create Session_Speaker__c
            Session_Speaker__c oSessSpeaker = new Session_Speaker__c();
            oSessSpeaker.Session__c = lSessions.get(0).Id;
            oSessSpeaker.Speaker__c = lSpeakers.get(0).Id;
            insert oSessSpeaker;

            //Verify record was successfully created.
            List<Session_Speaker__c> lsessionSpeakers = [select Id,
                                                            Session__c,
                                                            Speaker__c
                                                            from Session_Speaker__c
                                                            where Session__c = :lSessions.get(0).Id];

            System.assert(lsessionSpeakers.size() == 1, 'Number of Session Speaker records should be 1.');
            System.assert(lsessionSpeakers.get(0).Speaker__c == lSpeakers.get(0).Id, 'Speaker record does not match.');
        }

    }

    static testMethod void testCreateConflictingSessionSpeaker() {
        // Create test user.
        List<User> adminUsers = TestUtil.createUsers(1, 'System Administrator');
        // Create Session data.
        List<Session__c> lSessions = TestDataUtil.createSessions(2, true);
        // Create Speaker data.
        List<Speaker__c> lSpeakers = TestDataUtil.createSpeakers(1);
        //Create Session_Speaker__c
        Session_Speaker__c oSessSpeaker = new Session_Speaker__c();
        oSessSpeaker.Session__c = lSessions.get(0).Id;
        oSessSpeaker.Speaker__c = lSpeakers.get(0).Id;
        insert oSessSpeaker;

        System.runAs(adminUsers.get(0)) {
            try {
                Session_Speaker__c oSessSpeaker2 = new Session_Speaker__c();
                oSessSpeaker2.Session__c = lSessions.get(1).Id;
                oSessSpeaker2.Speaker__c = lSpeakers.get(0).Id;
                insert oSessSpeaker2;
            } catch (Exception e) {
                System.assert(e.getMessage().contains('The speaker is already booked at that time.'));
            }
        }
    }

}
