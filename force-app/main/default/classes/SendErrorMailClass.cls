public class SendErrorMailClass
{
    public static Messaging.SendEmailResult sendErrorMailCallList(String emailSubject, String emailBody)
    {
        String[] mailAddresses = new String[]{System.Label.AdminMailAddress, System.Label.DevMailAddress};
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(mailAddresses);
        
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.Email>{ email }, false);
        return results.get(0);
    }
    
    public static Messaging.SendEmailResult sendErrorMailAccountList(String emailSubject, String emailBody, String emailType)
    {
        String[] mailAddresses = null;
        if(emailType.equalsIgnoreCase('error'))
        {
            mailAddresses = new String[]{System.Label.AdminMailAddress, System.Label.DevMailAddress, System.Label.RakutenMonitor};    
        }
        else if(emailType.equalsIgnoreCase('warning'))
        {
            mailAddresses = new String[]{System.Label.AdminMailAddress, System.Label.DevMailAddress};
        }
        else if(emailType.equalsIgnoreCase('success'))
        {
            mailAddresses = new String[]{System.Label.AdminMailAddress, System.Label.DevMailAddress};
        }
        else if(emailType.equalsIgnoreCase('deadline'))
        {
            mailAddresses = new String[]{System.Label.DevMailAddress};
        }
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(mailAddresses);
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.Email>{ email }, false);
        return results.get(0);
    }
}