trigger ReservationTrigger on Reservation__c (after insert) {


    Map<String, Promo_Code__c> promoCodeMap = new Map<String, Promo_Code__c>();

    Map<Id, Room__c> roomMap = new Map<Id, Room__c>();

    for (Reservation__c res : Trigger.new) {

        if (res.Promo_Code_Num__c != null) {
            promoCodeMap.put(res.Promo_Code_Num__c, null);
        }

        roomMap.put(res.Room__c, null);

    }

    if (!promoCodeMap.isEmpty()) {
        for (Promo_Code__c pc : [select Id,
                                    Code__c,
                                    Discount__c,
                                    Is_Active__c
                                    from Promo_Code__c
                                    where Is_Active__c = true and Code__c in :promoCodeMap.keySet()]) {

            promoCodeMap.put(pc.Code__c, pc);
        }
    }

    if (!roomMap.isEmpty()) {
        for (Room__c room : [select Id, Price__c from Room__c where Id in :roomMap.keySet()]) {
            roomMap.put(room.Id, room);
        }
    }

    List<Invoice__c> lInvoices = new List<Invoice__c>();

    for (Reservation__c res : Trigger.new) {
        Integer resDays = res.Check_In__c.daysBetween(res.Check_Out__c);

        Invoice__c invoice = new Invoice__c();
        invoice.Reservation__c = res.Id;
        invoice.Total__c = roomMap.get(res.Room__c).Price__c * resDays;

        if (res.Promo_Code_Num__c != null && promoCodeMap.get(res.Promo_Code_Num__c) != null) {
            invoice.Promo_Code__c = promoCodeMap.get(res.Promo_Code_Num__c).Id;
            invoice.Total__c = invoice.Total__c - promoCodeMap.get(res.Promo_Code_Num__c).Discount__c;
        }

        lInvoices.add(invoice);
    }

    insert lInvoices;

}