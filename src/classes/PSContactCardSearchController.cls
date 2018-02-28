public class PSContactCardSearchController {
    @AuraEnabled
    public static List<String> getTopicOptions()
    {
        List<String> optionList = new List<String>();
        optionList.add('');
        
        Schema.DescribeFieldResult fieldResult = User.Topic__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
          optionList.add(f.getLabel());
        }       
 
        return optionList;
    }
    
    @AuraEnabled
    public static List<String> getStrengthOptions()
    {
        List<String> optionList = new List<String>();
        optionList.add('');
        
        Schema.DescribeFieldResult fieldResult = User.Strengths__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
          optionList.add(f.getLabel());
        }       
 
        return optionList;
    }
    
    private static String createInClause(String val, String splitChar)
    {
        List<String> parts = val.split(splitChar);
        
        String tmpStr = '';
        for (String s : parts)
        {
            if (tmpStr.length() > 0)
            {
                tmpStr += ',';
            }
            tmpStr += '\'' + s + '\'';
        }
        
        return tmpStr;
    }
    
    private static String createInClauseIdList(List<Id> idList)
    {   
        String tmpStr = '';
        for (Id i : idList)
        {
            if (tmpStr.length() > 0)
            {
                tmpStr += ',';
            }
            tmpStr += '\'' + i + '\'';
        }
        
        return tmpStr;
    }
        
    @AuraEnabled
    public static String queryContacts(String name, String topic, String strength)
    {
        System.debug('name=' + name);
        System.debug('topic=' + topic);
        System.debug('strength=' + strength);
        
        List<User> userList = new List<User>();
        
       
        System.debug('networkId=' + Network.getNetworkId());
        List<NetworkMember> nwmemList = [SELECT Id, MemberId FROM NetworkMember WHERE NetworkId = :Network.getNetworkId()];
        List<ID> memIdList = new List<ID>();
        for (NetworkMember nwmem : nwmemList)
        {
            memIdList.add(nwmem.MemberId);
        }
        
        String queryStr = 'SELECT Id, Name, FirstName, LastName, IsActive, Address, Phone, MobilePhone,\n' + 
                          '       Email, BadgeText, ContactId, ProfileId, FullPhotoUrl, Contact.Email, Contact.MailingAddress, Topic__c, Strengths__c,\n' +
                          '       Title, UserType\n'+ 
                          '  FROM User\n';
       
        String whereClause = ' WHERE UserType  IN (\'CspLitePortal\',\'PowerCustomerSuccess\',\'PowerPartner\') AND IsActive = true';
        //String whereClause = ' WHERE IsActive = true';
        
        if (memIdList.size() > 0)
        {
            whereClause += '\nAND Id IN (' + createInClauseIdList(memIdList) + ')';
        }
        
        if (name != null && name.length() > 0)
        {
            whereClause += '\nAND Name LIKE \'%' + name + '%\'';
        }
        
        if (topic != null && topic.length() > 0)
        {
            whereClause += '\nAND Topic__c = \'' + topic + '\'';
        }
        
        if (strength != null && strength != 'null' && strength.length() > 0)
        {
            whereClause += '\nAND Strengths__c INCLUDES (' + createInClause(strength, ';') + ')';
        }
       
        if (whereClause != null) queryStr += whereClause;
        
        System.debug('queryStr=' + queryStr);
        userList = Database.query(queryStr);
        
        return JSON.serialize(userList);
    }
}