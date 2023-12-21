@isTest
public class ReceptionTriggerHandlerTest{

    // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
    // public static ID sonpoQueueID = [Select Queue.Id from QueueSObject 
    //                 WHERE Queue.Type ='Queue' AND Queue.Name = 'ミドルオフィス（損保）' Limit 1].Queue.Id;
    // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
                   
    static testMethod void beforeInsertTest(){
        
        Test.startTest();
        
        RecordType personAccountRecordType =  
                [SELECT Id FROM RecordType 
                WHERE Name = '個人取引先' and SObjectType = 'Account'];
        Account acc= new Account();
        acc.LastName = 'tst';
        acc.PersonMailingPostalCode = '123-4567';
        acc.PersonMailingState = 'TOKYO-TO';
        acc.PersonMailingCity = 'CHUO-KU';
        acc.PersonMailingStreet = '1-5-389';
        acc.RecordType = personAccountRecordType;
        insert acc;
        
        Reception__c rec = new Reception__c();
        rec.LF_Inquiry__c = true;
        rec.Account__c = acc.id;
        rec.AdderssInputMethod__c = '取引先から引用';
        rec.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        insert rec;
        
        //Onyx Agency Master linkage
        SeihoAgencyMaster__c sa = new SeihoAgencyMaster__c();
        sa.agncyno__c='Test';
        insert sa;
        
        SeihoRecruiterMaster__c sr =  new SeihoRecruiterMaster__c();
        sr.Name='Recruiter';
        sr.AGENCY_NUMBER__c='Test';
        insert sr;
        
        Reception__c rec1 = new Reception__c();
        rec1.SeihoRecruiter__c = sr.Id;
        rec1.LT_Inquiry__c = true;
        rec1.Account__c = acc.id;
        rec1.AdderssInputMethod__c = '手動入力';
        rec1.Addressee__c = 'CUSTOMER2';
        rec1.MailingPostalCode__c = '189-4567';
        rec1.MailingState__c = 'YOKOHAMA';
        rec1.MailingCity__c = 'NIHONBASHI';
        rec1.Address1__c = '1-267-12';
        rec1.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec1.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        insert rec1;
        
        Reception__c rec2 = new Reception__c();
        rec2.DM_Inquiry__c = true;
        rec2.Account__c = acc.id;
        rec2.AdderssInputMethod__c = '取引先から引用';
        rec2.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec2.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        insert rec2;
        
        Test.stopTest();
        
        // Unit Test for Reception Address Values
        List<Reception__c> recepList = [Select id,Addressee__c,
                                        MailingPostalCode__c,MailingState__c,
                                        MailingCity__c,Address1__c  
                                        from Reception__c where id =: rec.id];
        System.assertEquals('tst',recepList[0].Addressee__c);
        System.assertEquals('123-4567',recepList[0].MailingPostalCode__c);
        System.assertEquals('TOKYO-TO',recepList[0].MailingState__c);
        System.assertEquals('CHUO-KU',recepList[0].MailingCity__c);
        System.assertEquals('1-5-389',recepList[0].Address1__c);
        
        List<Reception__c> recepList1 = [Select id,Addressee__c,SeihoAgency__c,
                                        MailingPostalCode__c,MailingState__c,
                                        MailingCity__c,Address1__c  
                                        from Reception__c where id =: rec1.id];
        System.assertEquals(sa.id,recepList1 [0].SeihoAgency__c);//Onyx                               
        System.assertEquals('CUSTOMER2',recepList1[0].Addressee__c);
        System.assertEquals('189-4567',recepList1[0].MailingPostalCode__c);
        System.assertEquals('YOKOHAMA',recepList1[0].MailingState__c);
        System.assertEquals('NIHONBASHI',recepList1[0].MailingCity__c);
        System.assertEquals('1-267-12',recepList1[0].Address1__c);
        
        List<Reception__c> recepList2 = [Select id,Addressee__c,
                                        MailingPostalCode__c,MailingState__c,
                                        MailingCity__c,Address1__c  
                                        from Reception__c where id =: rec2.id];
        System.assertEquals('tst',recepList2[0].Addressee__c);
        System.assertEquals('123-4567',recepList2[0].MailingPostalCode__c);
        System.assertEquals('TOKYO-TO',recepList2[0].MailingState__c);
        System.assertEquals('CHUO-KU',recepList2[0].MailingCity__c);
        System.assertEquals('1-5-389',recepList2[0].Address1__c);
        
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
        // ID caseOwnerId;
        // List<Case> caseListOwnerCheck = new List<Case>();
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
        List<Case> caseOwnerList = [Select id,OwnerId from case];
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
        // for (case ca : caseOwnerList){
        //     if(ca.OwnerId == sonpoQueueID){
        //         caseOwnerId = ca.OwnerId;
        //         caseListOwnerCheck.add(ca);
        //     }           
        // }
        // System.assertEquals(1,caseListOwnerCheck.Size());
        // System.assertEquals(sonpoQueueID,caseOwnerId);
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
        
        // Unit Test for New Request Record and its setting values
        List<Request__c> requestList = [Select id,Class__c,Type__c,Subject__c,
                                        Reception__c,Reception__r.LF_Inquiry__c,
                                        Reception__r.LT_Inquiry__c,Reception__r.DM_Inquiry__c 
                                        From Request__c];
        for(Request__c req : requestList){
            if(req.Reception__r.LF_Inquiry__c == true){
                System.assertEquals('生命専用ケース',req.Class__c);
                System.assertEquals('問合せケース（生命）',req.Type__c);
                System.assertEquals('問合せケース（生命）',req.Subject__c);
            }
            else if(req.Reception__r.LT_Inquiry__c == true){
                System.assertEquals('少短専用ケース',req.Class__c);
                System.assertEquals('問合せケース（少短）',req.Type__c);
                System.assertEquals('問合せケース（少短）',req.Subject__c);
            }
            else if(req.Reception__r.DM_Inquiry__c == true){
                System.assertEquals('損保専用ケース',req.Class__c);
                System.assertEquals('問合せケース（損保）',req.Type__c);
                System.assertEquals('問合せケース（損保）',req.Subject__c);
            }
        }
        
        System.assertEquals(3,caseOwnerList.Size());
        System.assertEquals(3,requestList.Size());
        
        // Unit Test for New Case Record and its setting values
        List<Case> caseList =  [Select id,Subject,
                                Priority, Status,OwnerId,
                                Reception__c,Reception__r.LF_Inquiry__c,
                                Reception__r.LT_Inquiry__c,Reception__r.DM_Inquiry__c  
                                From Case];
        for(Case caseRecord : caseList){
            if(caseRecord.Reception__r.LF_Inquiry__c == true){
                System.assertEquals('クローズ',caseRecord.Status);
                System.assertEquals(UserInfo.getUserID(),caseRecord.OwnerId);
                System.assertEquals('問合せケース（生命）',caseRecord.Subject);
            }
            else if(caseRecord.Reception__r.LT_Inquiry__c == true){
                System.assertEquals('クローズ',caseRecord.Status);
                System.assertEquals(UserInfo.getUserID(),caseRecord.OwnerId);
                System.assertEquals('問合せケース（少短）',caseRecord.Subject);
            }
            else if(caseRecord.Reception__r.DM_Inquiry__c == true){
                System.assertEquals('クローズ',caseRecord.Status);
                // Modify 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
                // System.assertEquals(sonpoQueueID,caseRecord.OwnerId);
                System.assertEquals(UserInfo.getUserID(),caseRecord.OwnerId);
                // Modify 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
                System.assertEquals('問合せケース（損保）',caseRecord.Subject);
            }
        }
    }
    
    
    static testMethod void beforeUpdateTest(){
        
        Test.startTest();
        
        RecordType personAccountRecordType =  
                [SELECT Id FROM RecordType 
                WHERE Name = '個人取引先' and SObjectType = 'Account'];
        Account acc= new Account();
        acc.LastName = 'tst';
        acc.PersonMailingPostalCode = '123-4567';
        acc.PersonMailingState = 'TOKYO-TO';
        acc.PersonMailingCity = 'CHUO-KU';
        acc.PersonMailingStreet = '1-5-389';
        acc.RecordType = personAccountRecordType;
        insert acc;
       
        
        Reception__c rec = new Reception__c();
        rec.LF_Inquiry__c = false;
        rec.Account__c = acc.id;
        rec.AdderssInputMethod__c = '手動入力';
        rec.Addressee__c = 'CUSTOMER1';
        rec.MailingPostalCode__c = '180-4567';
        rec.MailingState__c = 'TOKYO-TO';
        rec.MailingCity__c = 'CHUO-KU';
        rec.Address1__c = '1-2-12';
        rec.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        insert rec;
        
        Reception__c rec1 = new Reception__c();
        rec1.LT_Inquiry__c = false;
        rec1.Account__c = acc.id;
        rec1.AdderssInputMethod__c = '手動入力';
        rec1.Addressee__c = 'CUSTOMER2';
        rec1.MailingPostalCode__c = '181-4567';
        rec1.MailingState__c = 'YOKOHAMA';
        rec1.MailingCity__c = 'NIHONBASHI';
        rec1.Address1__c = '1-3-12';
        rec1.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec1.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        insert rec1;
        
        Reception__c rec2 = new Reception__c();
        rec2.DM_Inquiry__c = false;
        rec2.Account__c = acc.id;
        rec2.AdderssInputMethod__c = '手動入力';
        rec2.Addressee__c = 'CUSTOMER3';
        rec2.MailingPostalCode__c = '189-4567';
        rec2.MailingState__c = 'KAWASAKI';
        rec2.MailingCity__c = 'HOMBASHI';
        rec2.Address1__c = '1-4-12';
        rec2.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec2.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        insert rec2;
        
        SeihoAgencyMaster__c saUpdated= new SeihoAgencyMaster__c();
        saUpdated.agncyno__c='TestUpdated';
        insert saUpdated;
        
        SeihoRecruiterMaster__c srUpdated =  new SeihoRecruiterMaster__c();
        srUpdated.Name='RecruiterUpdated';
        srUpdated.AGENCY_NUMBER__c='TestUpdated';
        insert srUpdated;
        
        Reception__c recUpt = new Reception__c();
        recUpt.id = rec.id;
        recUpt.LF_Inquiry__c = true;
        recUpt.AdderssInputMethod__c = '取引先から引用';
        recUpt.SeihoRecruiter__c =srUpdated.Id;
        Update recUpt;
        
        Reception__c recUpt1 = new Reception__c();
        recUpt1.id = rec1.id;
        recUpt1.LT_Inquiry__c = true;
        recUpt1.AdderssInputMethod__c = '取引先から引用';
        Update recUpt1;
        
        Reception__c recUpt2 = new Reception__c();
        recUpt2.id = rec2.id;
        recUpt2.DM_Inquiry__c = true;
        Update recUpt2;
        
        Test.stopTest();
        
         
        // Unit Test for Reception Address Values                             
        List<Reception__c> recepList = [Select id,Addressee__c,SeihoAgency__c,SeihoRecruiter__r.SeihoAgencyMasterName__c,
                                        MailingPostalCode__c,MailingState__c,
                                        MailingCity__c,Address1__c  
                                        from Reception__c where id =: recUpt.id];
        system.debug('@@@recepList'+recepList);                              
        System.assertEquals(saUpdated.id,recepList[0].SeihoAgency__c);//Onyx
        System.assertEquals('tst',recepList[0].Addressee__c);
        System.assertEquals('123-4567',recepList[0].MailingPostalCode__c);
        System.assertEquals('TOKYO-TO',recepList[0].MailingState__c);
        System.assertEquals('CHUO-KU',recepList[0].MailingCity__c);
        System.assertEquals('1-5-389',recepList[0].Address1__c);
        
        List<Reception__c> recepList1 = [Select id,Addressee__c,
                                        MailingPostalCode__c,MailingState__c,
                                        MailingCity__c,Address1__c  
                                        from Reception__c where id =: recUpt1.id];
        System.assertEquals('tst',recepList1[0].Addressee__c);
        System.assertEquals('123-4567',recepList1[0].MailingPostalCode__c);
        System.assertEquals('TOKYO-TO',recepList1[0].MailingState__c);
        System.assertEquals('CHUO-KU',recepList1[0].MailingCity__c);
        System.assertEquals('1-5-389',recepList1[0].Address1__c);
    
        List<Reception__c> recepList2 = [Select id,Addressee__c,
                                        MailingPostalCode__c,MailingState__c,
                                        MailingCity__c,Address1__c  
                                        from Reception__c where id =: rec2.id];
        System.assertEquals('CUSTOMER3',recepList2[0].Addressee__c);
        System.assertEquals('189-4567',recepList2[0].MailingPostalCode__c);
        System.assertEquals('KAWASAKI',recepList2[0].MailingState__c);
        System.assertEquals('HOMBASHI',recepList2[0].MailingCity__c);
        System.assertEquals('1-4-12',recepList2[0].Address1__c);
        
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
        // ID caseOwnerId;
        // List<Case> caseListOwnerCheck = new List<Case>();
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
        List<Case> caseOwnerList = [Select id,OwnerId from case];
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
        // for (case ca : caseOwnerList){
        //     if(ca.OwnerId == sonpoQueueID){
        //         caseOwnerId = ca.OwnerId;
        //         caseListOwnerCheck.add(ca);
        //     }
        // }
        // System.assertEquals(1,caseListOwnerCheck.Size());
        // System.assertEquals(sonpoQueueID,caseOwnerId);
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
        
        // Unit Test for New Request Record and its setting values
        List<Request__c> requestList = [Select id,Class__c,Type__c,Subject__c,
                                        Reception__c,Reception__r.LF_Inquiry__c,
                                        Reception__r.LT_Inquiry__c,Reception__r.DM_Inquiry__c  
                                        From Request__c];
        for(Request__c req : requestList){
            if(req.Reception__r.LF_Inquiry__c == true){
                System.assertEquals('生命専用ケース',req.Class__c);
                System.assertEquals('問合せケース（生命）',req.Type__c);
                System.assertEquals('問合せケース（生命）',req.Subject__c);
            }
            else if(req.Reception__r.LT_Inquiry__c == true){
                System.assertEquals('少短専用ケース',req.Class__c);
                System.assertEquals('問合せケース（少短）',req.Type__c);
                System.assertEquals('問合せケース（少短）',req.Subject__c);
            }
            else if(req.Reception__r.DM_Inquiry__c == true){
                System.assertEquals('損保専用ケース',req.Class__c);
                System.assertEquals('問合せケース（損保）',req.Type__c);
                System.assertEquals('問合せケース（損保）',req.Subject__c);
            }
        }
        
        System.assertEquals(3,caseOwnerList.Size());
        System.assertEquals(3,requestList.Size());
        
        // Unit Test for New Case Record and its setting values
        List<Case> caseList =  [Select id,Subject,
                                Priority, Status,OwnerId,
                                Reception__c,Reception__r.LF_Inquiry__c,
                                Reception__r.LT_Inquiry__c,Reception__r.DM_Inquiry__c  
                                From Case];
        for(Case caseRecord : caseList){
            if(caseRecord.Reception__r.LF_Inquiry__c == true){
                System.assertEquals('クローズ',caseRecord.Status);
                System.assertEquals(UserInfo.getUserID(),caseRecord.OwnerId);
                System.assertEquals('問合せケース（生命）',caseRecord.Subject);
            }
            else if(caseRecord.Reception__r.LT_Inquiry__c == true){
                System.assertEquals('クローズ',caseRecord.Status);
                System.assertEquals(UserInfo.getUserID(),caseRecord.OwnerId);
                System.assertEquals('問合せケース（少短）',caseRecord.Subject);
            }
            else if(caseRecord.Reception__r.DM_Inquiry__c == true){
                System.assertEquals('クローズ',caseRecord.Status);
                // Modify 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
                // System.assertEquals(sonpoQueueID,caseRecord.OwnerId);
                System.assertEquals(UserInfo.getUserID(),caseRecord.OwnerId);
                // Modify 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
                System.assertEquals('問合せケース（損保）',caseRecord.Subject);
            }
        }
        
    }

}