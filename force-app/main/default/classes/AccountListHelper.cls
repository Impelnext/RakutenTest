public class AccountListHelper 
{
    static String ProhibitedMiniEntryStatus = System.Label.ProhibitedMiniEntryStatus.replaceAll('[\\s\u3000\u0000]', ''); //Trim whitespace, full-width space and null character
    static Set<String> pmes = new Set<String>(ProhibitedMiniEntryStatus.split(','));
    
    static String ProhibitedApplyStatus = System.Label.ProhibitedApplyStatus.replaceAll('[\\s\u3000\u0000]', ''); //Trim whitespace, full-width space and null character
    static Set<String> pas = new Set<String>(ProhibitedApplyStatus.split(','));
    
    static  String b2dmexcludeminiopp = System.Label.b2dm_exclude_miniopp;
    
    
    public static boolean existValidFields(String lastName, String firstName, String lastNameKana, String firstNameKana, String homePhone, String mobilePhone, Date birthDate, String easyId, String gender)
    {
        //Check if Rakuten id is present
        if(!String.isBlank(easyId))
        {
            return true;
        }
        else
        {
            //Check if there is name
            if (String.isBlank(lastName) && String.isBlank(firstName) && String.isBlank(lastNameKana) && String.isBlank(firstNameKana))
            {
                return false;
            }
            else if (String.isBlank(homePhone) && String.isBlank(mobilePhone))//Check if there is phone number
            {
                if(birthDate == null && String.isBlank(gender))
                    return false;
            }
        }
        return true;
    }
    
    
    //Check if name and phone is not blank
    //Used in before creating a call list
    public static boolean existNameAndPhone(String lastName, String firstName, String lastNameKana, String firstNameKana, String homePhone, String mobilePhone)
    {
        //Check if there is name
        if (String.isBlank(lastName) && String.isBlank(firstName) && String.isBlank(lastNameKana) && String.isBlank(firstNameKana))
        {
            return false;
        }
        //Check if there is phone number
        else if (String.isBlank(homePhone) && String.isBlank(mobilePhone))
        {
            return false;
        }
        return true;
    }
    
    
    public static sObject getLatestModifiedObject(Date shipmentDate, String acc_Id, Date acc_UpdatedBirthdate)
    {
        SObject latestModifiedObject = null;
        try
        {
            // Start Year and End Year of BD2M for MiniOpportunity
            Integer MINIOPP_BD2M_STARTYEAR = Integer.ValueOf(Label.MINIOPP_BD2M_STARTYEAR);
            Integer MINIOPP_BD2M_ENDYEAR = Integer.ValueOf(Label.MINIOPP_BD2M_ENDYEAR);
            
            String account_BirthDate = null;
            if(acc_UpdatedBirthdate != null)
                account_BirthDate = acc_UpdatedBirthdate.format().replaceAll('/','-');
            //Fetch latest ミニ保険 based on latest expiry_date field and connected to 取引先 and expiry_date + 9 months are less than 発送日
            List<MiniInsurance__c> mOps = [Select Id, LastName__c, FirstName__c, postal_code__c, address1__c, address2__c, gender__c, Birthdate__c, 
                                                phone_num__c, mobile_num__c, expiry_date__c, dm_flg__c, entry_status__c from MiniInsurance__c   
                                                where AccountId__c IN (SELECT ID FROM Account WHERE ID = :acc_Id AND Age__pc >= :MINIOPP_BD2M_STARTYEAR AND Age__pc <= :MINIOPP_BD2M_ENDYEAR) 
                                                and Birthdate__c =: acc_UpdatedBirthdate order by expiry_date__c desc limit 1];
            
            //Fetch latest 生保申込み based on LastModiedDate field and connected to 取引先 and LastModiedDate + 9 months are less than 発送日
            List<SeihoOpportunity__c> ops = [Select Id, LastName__c, FirstName__c, PostalCode__c, State__c, address1__c, address2__c, address3__c, 
                                                Gender__c, Birthdate__c, Phone__c, MobilePhone__c, AgentCd__c, LastModifiedDate, ApplySts__c, Name , WebLastSyncTime__c
                                                from SeihoOpportunity__c where Ref_Account__c =: acc_Id and Birthdate__c =: acc_UpdatedBirthdate order by WebLastSyncTime__c desc];
            
            //Fetch 生保WEB資料請求 based on latest CatalogOrderDate field and connected to 取引先 and CatalogOrderDate + 9 months are less than 発送日
            List<SeihoLead__c> leads = [Select Id, LastName__c, FirstName__c, PostalCode__c, State__c, City__c, Street__c, Apart__c, 
                                            Gender__c, Birthdate__c, Phone__c, MobilePhone__c, CatalogOrderDate__c, AgentCd__c 
                                            from SeihoLead__c where Ref_Account__c =: acc_Id and Birthdate__c =: acc_UpdatedBirthdate order by CatalogOrderDate__c desc];
            
            //Fetch 生保コール資料請求 based on latest CatalogOrderDate field and connected to 取引先 and CatalogOrderDate + 9 months are less than 発送日
            List<SeihoInboundLead__c> inboundLeads = [Select Id, Account_LastName__c, Account_FirstName__c, Account_PostalCode__c, 
                                                        Account_State__c, Account_City__c, Account_Apart__c, Account_Gender__c, Account_BirthDate__c, 
                                                        DestPhone__c, DestMobilePhone__c, CatalogOrderDate__c, AgentCd__c 
                                                        from SeihoInboundLead__c where AccountId__c =: acc_Id and Account_BirthDate__c =: account_BirthDate 
                                                        order by CatalogOrderDate__c desc];
            
            //To find latest modified objects ミニ保険, 生保申込み, 生保WEB資料請求, 生保コール資料請求 based on (expiry_date, LastModifiedDate, CatalogOrderDate__c)
            Map<Datetime, SObject> sortedDateMap = new Map<Datetime, SObject>();
            if(!mOps.isEmpty())
            {
                if(mOps[0].expiry_date__c >= shipmentDate.addMonths(-9) || pmes.contains(mOps[0].entry_status__c)) { //which means there is some mopp which is not expired yet
                    return null;
             }    else if(b2dmexcludeminiopp != 'True'  && mOps[0].dm_flg__c == False && mOps[0].entry_status__c == '契約満了') //Add to sorted map only if dm flag of first mopp in the list is False
                {
                    //if(!mOps[0].FirstName__c.contains('＿') && !mOps[0].LastName__c.contains('＿'))
                    //{
                        sortedDateMap.put(mOps[0].expiry_date__c, mOps[0]);
                    //}
                }
            }
System.Debug('ops : ' + ops);            
            if(!ops.isEmpty())
            {
                Date OppSpecialUpdateTime = Date.valueOf(System.Label.OppSpecialUpdateTime.replaceAll('[\\s\u3000\u0000]', '')); //Trim whitespace, full-width space and null character
                for(SeihoOpportunity__c op : ops)
                {
                    if((op.Name.startsWith('OPS') || op.Name.startsWith('Pack')) && OppSpecialUpdateTime >= shipmentDate.addMonths(-9)) //which means there is some old opp which is modified within 9 months
                    {
                        return null;
                    }
                    else if(!op.Name.startsWith('OPS') && !op.Name.startsWith('Pack') && op.WebLastSyncTime__c >= shipmentDate.addMonths(-9)) //which means there is some opp which is modified within 9 months
                    {
                        return null;
                    }
                }
                
                for(SeihoOpportunity__c op : ops) //scan through all valid ops and search for Agent code 000001 and check if the ApplySts of Op is not in prohibited status's list
                {
                    if((op.AgentCd__c == System.Label.DIRECT_AGENT_CODE || op.AgentCd__c == System.Label.DIRECT_AGENT_CODE2 || op.AgentCd__c == System.Label.RIP_AGENT_CODE) && 
                        String.isNotBlank(op.ApplySts__c) && !pas.contains(op.ApplySts__c.trim()))
                    {
                        if(op.Name.StartsWith('OPS') || op.Name.StartsWith('Pack'))
                        {
                            sortedDateMap.put(OppSpecialUpdateTime, op); //Add latest updated Opp to sorted map
                        }
                        else
                        {
                            sortedDateMap.put(op.WebLastSyncTime__c, op); //Add latest updated Opp to sorted map
                        }
                    }
                }
            }
            
            if(!leads.isEmpty())
            {
                if(leads[0].CatalogOrderDate__c >= shipmentDate.addMonths(-9))
                {
                    return null;
                }
                for(SeihoLead__c ld : leads)
                {
                    if(ld.AgentCd__c == System.Label.DIRECT_AGENT_CODE || ld.AgentCd__c == System.Label.RIP_AGENT_CODE) //Add Lead to sorted map
                    {
                        if(!(ld.BirthDate__c.month() == 1 && ld.BirthDate__c.day() == 1))
                        {
                            sortedDateMap.put(ld.CatalogOrderDate__c, ld);
                            break;
                        }
                    }
                }
            }
            
            if(!inboundLeads.isEmpty())
            {   
                if(inboundLeads[0].CatalogOrderDate__c >= shipmentDate.addMonths(-9)) //which means there is some InboundLead__c which has catalogorder date within 9 months
                {
                    return null;
                }
                for(SeihoInboundLead__c ibl : inboundLeads)
                {
                    if(ibl.AgentCd__c == System.Label.DIRECT_AGENT_CODE || ibl.AgentCd__c == System.Label.RIP_AGENT_CODE) //Add InboundLead__c to sorted map
                    {
                        sortedDateMap.put(ibl.CatalogOrderDate__c, ibl);
                        break;
                    }
                }
            }
            
            //To decide from which of the following objects data to be copied :ミニ保険／生保申込み／生保WEB資料請求／生保コール資料請求
            if(!sortedDateMap.isEmpty())
            {
                sortedDateMap.remove(null);
                List<Datetime> keySetList = new List<Datetime>();
                keySetList.addAll(sortedDateMap.keySet());
                keySetList.sort();
                //After assending order sorting it returns latest modified object at last index
                if(!sortedDateMap.isEmpty())
                    latestModifiedObject = sortedDateMap.get(keySetList.get(keySetList.size()-1));
            }
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage() + ' at ' + ex.getLineNumber());
        }
        return latestModifiedObject;
    }
    
    
    
    
    public static String getPhoneNumber(String phone)
    {
        try
        {
            if(isValidPhoneNumber(phone))
            {
                return phone;
            }
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage() + ' at ' + ex.getLineNumber());
        }
        return '';
    }
    
    
    public static Boolean isValidPhoneNumber(String phone)
    {
        try
        {
            if(String.isNotBlank(phone))
            {
                phone = phone.replaceAll('[\\s\u3000\u0000]', '').replaceAll( '\\-+', ''); //Trim whitespace, full-width space and null character and hyphens
                if(String.isNotBlank(phone) && phone.isNumeric())
                {   
                    String DummyPhoneNumbers = System.Label.DummyPhoneNumbers.replaceAll('[\\s\u3000\u0000]', ''); //Trim whitespace, full-width space and null character
                    Set<String> dpn = new Set<String>(DummyPhoneNumbers.split(','));
                    for(String p : dpn)
                    {
                        if(p == phone)
                        {
                            return false;
                        }
                    }
                    if(phone.length() > 3)
                    {
                        String digitCheck = phone.substring(0,3);
                        if(digitCheck != '090' && digitCheck != '080' && digitCheck != '070')
                        {
                            return true;
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage() + ' at ' + ex.getLineNumber());
        }
        return false;
    }
    
    
    public static String convertPostalCode(String postalCode) 
    {
        try
        {
            if(String.isNotBlank(postalCode))
                return postalCode.replaceAll('-','');
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage() + ' at ' + ex.getLineNumber());
        }
        return postalCode;
    }
}