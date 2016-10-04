trigger SessionSpeakerTrigger on Session_Speaker__c (before insert, before update, after insert) {

    // Check speakers do not have conflicts with existing session bookings.
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {

        // Data structures to collect ids while processing speakers.
        Set<Id> speakerIds = new Set<Id>();
        Map<Id,DateTime> sessionBookingMap = new Map<Id,DateTime>();

        // Get all speakers ids being assigned to a session.
        // Set session booking map with ids to fill later. Map key is Session Id.
        for (Session_Speaker__c newItem : Trigger.new) {
            sessionBookingMap.put(newItem.Session__c,null);
            speakerIds.add(newItem.Speaker__c);
        }

        // Query for sessions being processed and fill out sessionBookingMap.
        for (Session__c session : [select Id,
                                        Date__c
                                        from Session__c
                                        where Id in :sessionBookingMap.keySet()]) {
            sessionBookingMap.put(session.Id, session.Date__c);
        }

        // Get all existing sessions for speakers being processed.
        List<Session_Speaker__c> existingSessionSpeakers = [select Id,
                                                                Speaker__c,
                                                                Session__c,
                                                                Session__r.Date__c
                                                                from Session_Speaker__c
                                                                where Speaker__c in :speakerIds];

        // Validate speaker is not booked for a session at the same time.
        for (Session_Speaker__c newSessionSpeaker : Trigger.new) {
            DateTime booking_time = sessionBookingMap.get(newSessionSpeaker.Session__c);

            for (Session_Speaker__c related_speaker : existingSessionSpeakers) {
                if(related_speaker.Speaker__c == newSessionSpeaker.Speaker__c &&
                    related_speaker.Session__r.Date__c == booking_time) {
                    newSessionSpeaker.addError('The speaker is already booked at that time.');
                }
            }
        }

    }


    // Send confirmation email after inserting Session_Speaker__c records.
    if (Trigger.isAfter && Trigger.isInsert) {

        // Get all record ids in one set to for future querying.
        Set<Id> sessionSpeakerIds = new Set<Id>();
        for (Session_Speaker__c newSessionSpeaker : Trigger.new) {
            sessionSpeakerIds.add(newSessionSpeaker.Id);
        }

        // Query session data based on sessionSpeakerIds.
        List<Session_Speaker__c> sessionSpeakers = [select Session__r.Name,
                                                        Session__r.Date__c,
                                                        Speaker__r.FirstName__c,
                                                        Speaker__r.LastName__c,
                                                        Speaker__r.Email__c
                                                        from Session_Speaker__c where Id in :sessionSpeakerIds];

        if (sessionSpeakers.size() > 0) {
            // Bulkify sending emails by storing them on a list and sending all at once.
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

            // Go over the recently queried Session_Speaker__c records and create emails.
            for (Session_Speaker__c sessionSpeaker : sessionSpeakers) {

                if (String.isNotBlank(sessionSpeaker.Speaker__r.Email__c)) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] {sessionSpeaker.Speaker__r.Email__c});
                    email.setSenderDisplayName('Dreamforce Speaker Manager');
                    email.setSubject('Speaker Confirmation');
                    String message = 'Dear ' + sessionSpeaker.Speaker__r.FirstName__c + ',\nYour session "' + sessionSpeaker.Session__r.Name + '" on ' + sessionSpeaker.Session__r.Date__c + ' is confirmed.\n\n' + 'Thanks for speaking at the conference!';
                    email.setPlainTextBody(message);
                    emails.add(email);
                }
            }

            if (emails.size() > 0) {
                Messaging.sendEmail(emails);
            }
        }

    }
}
