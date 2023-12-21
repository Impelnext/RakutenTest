@IsTest
public class AgentConversionWKTriggerTest {
  @TestSetup
  static void makeData(){
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    // 代理店変換マスタ
    List<agentConversionMaster__c> master = new List<agentConversionMaster__c>();
    for(Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        master.add(new agentConversionMaster__c(
            Agency_code_Old__c = String.valueOf(cnt),
            Agency_code_New__c = String.valueOf(cnt + 1000)
        ));
    }
    Insert master;
  }
    
  public AgentConversionWKTriggerTest() {}
  
  @IsTest
  public static void insert_all_old_fields(){
    // 代理店変換マスタ メタデータ取得
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    
    // 代理店変換WK
    SObject obj = new AgentConversionWK__c();
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
      AgencyConversionSetting__mdt setting = convSettings.get(cnt);
      obj.put(setting.O_AgencyCodeField__c, String.valueOf(cnt));
    }
    Test.startTest();
    Insert obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        System.assertEquals(String.valueOf(cnt + 1000), obj.get(setting.N_AgencyCodeField__c));
    }
  
  }

  @IsTest
  public static void update_all_old_fields(){
    // 代理店変換マスタ メタデータ取得
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    
    // 代理店変換WK
    SObject obj = new AgentConversionWK__c();
    Insert obj;
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
      AgencyConversionSetting__mdt setting = convSettings.get(cnt);
      obj.put(setting.O_AgencyCodeField__c, String.valueOf(cnt));
    }
    Test.startTest();
    Update obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        System.assertEquals(String.valueOf(cnt + 1000), obj.get(setting.N_AgencyCodeField__c));
    }
  
  }

  @IsTest
  public static void set_null_all_old_fields(){
    // 代理店変換マスタ メタデータ取得
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    
    // 代理店変換WK Insert
    SObject obj = new AgentConversionWK__c();
    Test.startTest();
    Insert obj;
    Test.stopTest();
    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        System.assertEquals(null, obj.get(setting.N_AgencyCodeField__c));
    }
  
  }

  @IsTest
  public static void set_invalid_all_old_fields(){
    // 代理店変換マスタ メタデータ取得
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    
    // 代理店変換WK Insert
    SObject obj = new AgentConversionWK__c();
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        obj.put(setting.O_AgencyCodeField__c, 'aaaaaa');
    }
    Test.startTest();
    Insert obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        System.assertEquals(obj.get(setting.O_AgencyCodeField__c), obj.get(setting.N_AgencyCodeField__c));
    }
  
  }

  @IsTest
  public static void set_ng_agency() {
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    // 代理店変換WK Insert
    SObject obj = new AgentConversionWK__c();
    obj.put('SN_O_AgencyNo__c','1');

    Test.startTest();
    Insert obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        if( setting.O_AgencyCodeField__c == 'SN_O_AgencyNo__c' ) {
            System.assertEquals('1001', obj.get(setting.N_AgencyCodeField__c));
        } else {
            System.assertEquals(null, obj.get(setting.N_AgencyCodeField__c));
        }
    }
  }

  @IsTest
  public static void set_master_agency() {
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    // 代理店変換WK Insert
    SObject obj = new AgentConversionWK__c();
    obj.put('SD_O_SonpoAgencyCode__c','1');
    obj.put('SD_O_SonpoInheritanceAgencyCode__c','1');
    obj.put('SD_O_SonpoSuccessorAgencyCode1__c','1');
    obj.put('SD_O_SonpoSuccessorAgencyCode2__c','1');

    Test.startTest();
    Insert obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        if( new List<String>{'SD_O_SonpoAgencyCode__c', 'SD_O_SonpoInheritanceAgencyCode__c', 'SD_O_SonpoSuccessorAgencyCode1__c', 'SD_O_SonpoSuccessorAgencyCode2__c'}.indexOf(setting.O_AgencyCodeField__c) != -1 ) {
            System.assertEquals('1001', obj.get(setting.N_AgencyCodeField__c));
        } else {
            System.assertEquals(null, obj.get(setting.N_AgencyCodeField__c));
        }
    }
  }
 

  @IsTest
  public static void set_contract_agency() {
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    // 代理店変換WK Insert
    SObject obj = new AgentConversionWK__c();
    obj.put('SK_O_AgencyCode1__c','1');
    obj.put('SK_O_AgencyCode2__c','1');
    obj.put('SK_O_AgencyCode3__c','1');
    obj.put('SK_O_AgencyCode4__c','1');
    obj.put('SK_O_AgencyCode5__c','1');

    Test.startTest();
    Insert obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        if( new List<String>{'SK_O_AgencyCode1__c','SK_O_AgencyCode2__c','SK_O_AgencyCode3__c','SK_O_AgencyCode4__c','SK_O_AgencyCode5__c'}.indexOf(setting.O_AgencyCodeField__c) != -1 ) {
            System.assertEquals('1001', obj.get(setting.N_AgencyCodeField__c));
        } else {
            System.assertEquals(null, obj.get(setting.N_AgencyCodeField__c));
        }
    }
  }

  @IsTest
  public static void set_apply_agency() {
    List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                       FROM AgencyConversionSetting__mdt ORDER BY DeveloperName]; 
    // 代理店変換WK Insert
    SObject obj = new AgentConversionWK__c();
    obj.put('SM_O_dairi_cd__c','1');
    obj.put('SM_O_hknj1_dairi_cd__c','1');
    obj.put('SM_O_hknj2_dairi_cd__c','1');

    Test.startTest();
    Insert obj;
    Test.stopTest();

    String query = 'SELECT Id, Name';
    for(AgencyConversionSetting__mdt setting : convSettings ) {
      query += ', ' + setting.O_AgencyCodeField__c + ', ' + setting.N_AgencyCodeField__c;
    }
    query += ' FROM AgentConversionWK__c WHERE Id = \'' + obj.Id + '\'';
    obj = Database.query(query);

    // 結果確認
    for( Integer cnt=0; cnt < convSettings.size(); cnt++ ) {
        AgencyConversionSetting__mdt setting = convSettings.get(cnt);
        if( new List<String>{'SM_O_dairi_cd__c', 'SM_O_hknj1_dairi_cd__c', 'SM_O_hknj2_dairi_cd__c'}.indexOf(setting.O_AgencyCodeField__c) != -1 ) {
            System.assertEquals('1001', obj.get(setting.N_AgencyCodeField__c));
        } else {
            System.assertEquals(null, obj.get(setting.N_AgencyCodeField__c));
        }
    }
  }

}