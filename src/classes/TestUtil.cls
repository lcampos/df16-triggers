@isTest
public class TestUtil {

    public static String getTimeStamp(){
        DateTime dtimenow = DateTime.now();
        String ts = dtimenow.second()+''+dtimenow.millisecond();
        return ts;
    }

    public static String getRandomUniqueString(Integer length){
        return EncodingUtil.base64Encode(crypto.generateAesKey(256)).substring(1,length);
    }

    public static Integer getRandomInteger(Integer upperLimit) {
        return Math.round(Math.random()*upperLimit);
    }

    /**
     *  Method used to create Test Users.
     *  @param iNum Number of user records to get created.
     *  @param profileName Name of the profile that will be assigned to the users.
     *  @return A list of user records.
     */
    public static List<User> createUsers(Integer iNum, String profileName){
        Profile oProfile = [select Id, Name from Profile where Name = :profileName limit 1];

        List<User> lResults = new List<User>();
        for(Integer i = 0; i < iNum; i++){
            User oUser = new User();
            oUser.FirstName = 'Tester';
            oUser.LastName = 'McCoy The '+i;
            oUser.Email = 'tester.mccoy' + getTimeStamp()+''+i+'@salesforce.com.test';
            oUser.Username = 'tester.mccoy' + getTimeStamp()+''+i+'@salesforce.com.test';
            oUser.CommunityNickname = getTimeStamp()+''+i;
            oUser.Alias = 't'+getTimeStamp()+''+i;
            oUser.TimeZoneSidKey = 'America/El_Salvador';
            oUser.LocaleSidKey = 'en_US';
            oUser.EmailEncodingKey = 'UTF-8';
            oUser.ProfileId = oProfile.Id;
            oUser.LanguageLocaleKey = 'en_US';
            oUser.IsActive = true;

            lResults.add(oUser);
        }

        insert lResults;
        return lResults;
    }

    /**
     *  Method used to add Permission Sets to Test Users.
     *  NOTE: execute this method always inside of a System.runAs(...)
     *  @param lusers List of users to process.
     *  @param permSetName Name of the permset to assign.
     */
    public static void addPermissionSet(List<User> lusers, String permSetName){
        List<PermissionSetAssignment> lpsa = new List<PermissionSetAssignment>();
        List<PermissionSet> lps = [select id from PermissionSet where Name = :permSetName];

        for(User ouser : lusers){
            PermissionSetAssignment opsa = new PermissionSetAssignment();
            opsa.AssigneeId = ouser.Id;
            opsa.PermissionSetId = lps.get(0).Id;

            lpsa.add(opsa);
        }

        insert lpsa;
    }

}