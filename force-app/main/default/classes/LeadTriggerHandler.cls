/*
* @Class Name      : LeadTriggerHandler 
* @Description     : リードトリガーハンドラ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2020.01.29
* @Modified        : Valsala Kumar(Phase3)
*/
public class LeadTriggerHandler {
    
    
    private static final Integer SHORT_ANSWER_LENGTH = 255;
    
    /**
     * リード作成後処理
     * @param List<Lead>
     * @return 
     */
    public void onAfterInsertProcess(List<Lead> insertedLeadList){
        upsertMiniInsurance(insertedLeadList);
    }
    
    /**
     * リード更新後処理
     * @param List<Lead>
     * @return 
     */
    public void onAfterUpdateProcess(List<Lead> updateLeadList){
        upsertMiniInsurance(updateLeadList);
    }
    
    /**
     * ミニ保険を追加、更新
     * @param List<Lead>
     * @return 
     */
    private void upsertMiniInsurance(List<Lead> leadList){
        List<MiniInsurance__c> miniInsuranceList = new List<MiniInsurance__c>();
        for(Lead targetLead : leadList){
            MiniInsurance__c targetMini = new MiniInsurance__c();
            targetMini.dm_flg__c = targetLead.dm_flg__c;
            targetMini.Name = targetLead.LastName;
            if(String.isNotBlank(targetLead.MiddleName)){
                targetMini.Name = targetMini.Name + ' ' + targetLead.MiddleName;
            }
            if(String.isNotBlank(targetLead.FirstName)){
                targetMini.Name = targetMini.Name + ' ' + targetLead.FirstName;
            }
            if(String.isNotBlank(targetLead.Suffix)){
                targetMini.Name = targetMini.Name + ' ' + targetLead.Suffix;
            }
            targetMini.OwnerId = targetLead.OwnerId;
            targetMini.mini_apply_id__c = targetLead.mini_apply_id__c;
            targetMini.stock_number__c = targetLead.stock_number__c;
            targetMini.mini_apply_accept_datetime__c = targetLead.mini_apply_accept_datetime__c;
            targetMini.issue_date__c = targetLead.issue_date__c;
            targetMini.expiry_date__c = targetLead.expiry_date__c;
            targetMini.commencement_date__c = targetLead.commencement_date__c;
            targetMini.transfer_date__c = targetLead.transfer_date__c;
            targetMini.mini_policy_cond_dl_date__c = targetLead.mini_policy_cond_dl_date__c;
            targetMini.mini_apply_receipt_dl_date__c = targetLead.mini_apply_receipt_dl_date__c;
            targetMini.entry_status__c = targetLead.entry_status__c;
            targetMini.via_offer__c = targetLead.via_offer__c;
            targetMini.send_date__c = targetLead.send_date__c;
            targetMini.easy_id__c = targetLead.easy_id__c;
            targetMini.last_name__c = targetLead.last_name__c;
            targetMini.first_name__c = targetLead.first_name__c;
            targetMini.last_name_kana__c = targetLead.last_name_kana__c;
            targetMini.first_name_kana__c = targetLead.first_name_kana__c;
            targetMini.IPSharedFlg__c = targetLead.IPSharedFlg__c;
            targetMini.gender__c = targetLead.gender__c;
            targetMini.postal_code__c = targetLead.postal_code__c;
            targetMini.address1__c = targetLead.address1__c;
            targetMini.address2__c = targetLead.address2__c;
            targetMini.address1_kana__c = targetLead.address1_kana__c;
            targetMini.address2_kana__c = targetLead.address2_kana__c;
            targetMini.phone_num__c = targetLead.phone_num__c;
            targetMini.mobile_num__c = targetLead.mobile_num__c;
            targetMini.email__c = targetLead.email__c;
            targetMini.product_cd__c = targetLead.product_cd__c;
            targetMini.Answer2_1__c = targetLead.Answer2_1__c;
            targetMini.Answer2_2__c = targetLead.Answer2_2__c;
            targetMini.term__c = targetLead.term__c;
            targetMini.document_id__c = targetLead.document_id__c;
            targetMini.UpsellCompletionFlag__c = targetLead.UpsellCompletionFlag__c;
            targetMini.dm_ex_date__c = targetLead.dm_ex_date__c;
            targetMini.ApplyDevice__c = targetLead.ApplyDevice__c;
            targetMini.OperationType__c = targetLead.OperationType__c;
            targetMini.mini_n2_mail_stop_datetime__c = targetLead.mini_n2_mail_stop_datetime__c;
            targetMini.mini_n2_mail_start_datetime__c = targetLead.mini_n2_mail_start_datetime__c;
            targetMini.ToDo_Subnumber__c = targetLead.ToDo_Subnumber__c;
            targetMini.mini_p_mail_stop_datetime__c = targetLead.mini_p_mail_stop_datetime__c;
            targetMini.mini_p_mail_start_datetime__c = targetLead.mini_p_mail_start_datetime__c;
            targetMini.create_time__c = targetLead.create_time__c;
            targetMini.update_time__c = targetLead.update_time__c;
            targetMini.Questionnaire_ID__c = targetLead.Questionnaire_ID__c;
            targetMini.Question1__c = targetLead.Question1__c;
            targetMini.Question2__c = targetLead.Question2__c;
            targetMini.Question3__c = targetLead.Question3__c;
            targetMini.Question4__c = targetLead.Question4__c;
            targetMini.Question5__c = targetLead.Question5__c;
            targetMini.Question6__c = targetLead.Question6__c;
            targetMini.Question7__c = targetLead.Question7__c;
            targetMini.Question8__c = targetLead.Question8__c;
            targetMini.Question9__c = targetLead.Question9__c;
            targetMini.Question10__c = targetLead.Question10__c;
            targetMini.Answer1__c = targetLead.Answer1__c;
            targetMini.Answer2__c = targetLead.Answer2__c;
            targetMini.Answer3__c = targetLead.Answer3__c;
            targetMini.Answer4__c = targetLead.Answer4__c;
            targetMini.Answer5__c = targetLead.Answer5__c;
            targetMini.Answer6__c = targetLead.Answer6__c;
            targetMini.Answer7__c = targetLead.Answer7__c;
            targetMini.Answer8__c = targetLead.Answer8__c;
            targetMini.Answer9__c = targetLead.Answer9__c;
            targetMini.Answer10__c = targetLead.Answer10__c;
            targetMini.Expectation__c = targetLead.Expectation__c;
            targetMini.birthdate__c = targetLead.birthdate__c;
            targetMini.EmployeeFlg__c = targetLead.EmployeeFlg__c;
            targetMini.PhoneMatchedFlag__c = targetLead.PhoneMatchedFlag__c;
            targetMini.AgentFlag__c = targetLead.AgentFlag__c;
            targetMini.CampaignDateTime__c = targetLead.CampaignDateTime__c;
            targetMini.contract_age__c = targetLead.contract_age__c;
            targetMini.premium__c = targetLead.premium__c;
            targetMini.insurance__c = targetLead.insurance__c;
            targetMini.anti_flg__c = targetLead.anti_flg__c;
            targetMini.apply_flg__c = targetLead.apply_flg__c;
            targetMini.dm_flg__c = targetLead.dm_flg__c;
            targetMini.dm_send_num__c = targetLead.dm_send_num__c;
            targetMini.mini_n2_mail_send_flg__c = targetLead.mini_n2_mail_send_flg__c;
            targetMini.mini_p_mail_send_flg__c = targetLead.mini_p_mail_send_flg__c;
            targetMini.question_type__c = targetLead.question_type__c;
            targetMini.CallTypePath__c = targetLead.CallTypePath__c;
            targetMini.CompletionFlag__c = targetLead.CompletionFlag__c;
            targetMini.Level__c = targetLead.Level__c;
            targetMini.ControlNumber__c = targetLead.ControlNumber__c;
            
            targetMini.MasterRecordId__c = targetLead.MasterRecordId;
            targetMini.LastName__c = targetLead.LastName;
            targetMini.FirstName__c = targetLead.FirstName;
            targetMini.Salutation__c = targetLead.Salutation;
            targetMini.MiddleName__c = targetLead.MiddleName;
            targetMini.Suffix__c = targetLead.Suffix;
            targetMini.Title__c = targetLead.Title;
            targetMini.Company__c = targetLead.Company;
            targetMini.Street__c = targetLead.Street;
            targetMini.City__c = targetLead.City;
            targetMini.State__c = targetLead.State;
            targetMini.PostalCode__c = targetLead.PostalCode;
            targetMini.Country__c = targetLead.Country;
            targetMini.Latitude__c = targetLead.Latitude;
            targetMini.Longitude__c = targetLead.Longitude;
            targetMini.GeocodeAccuracy__c = targetLead.GeocodeAccuracy;
            targetMini.Phone__c = targetLead.Phone;
            targetMini.MobilePhone__c = targetLead.MobilePhone;
            targetMini.Fax__c = targetLead.Fax;
            targetMini.EmailAddress__c = targetLead.email__c;
            targetMini.Website__c = targetLead.Website;
            targetMini.PhotoUrl__c = targetLead.PhotoUrl;
            targetMini.Description__c = targetLead.Description;
            targetMini.LeadSource__c = targetLead.LeadSource;
            targetMini.Status__c = targetLead.Status;
            targetMini.Industry__c = targetLead.Industry;
            targetMini.Rating__c = targetLead.Rating;
            targetMini.AnnualRevenue__c = targetLead.AnnualRevenue;
            targetMini.NumberOfEmployees__c = targetLead.NumberOfEmployees;
            targetMini.HasOptedOutOfEmail__c = targetLead.HasOptedOutOfEmail;
            targetMini.IsConverted__c = targetLead.IsConverted;
            targetMini.ConvertedDate__c = targetLead.ConvertedDate;
            targetMini.ConvertedAccountId__c = targetLead.ConvertedAccountId;
            targetMini.ConvertedContactId__c = targetLead.ConvertedContactId;
            targetMini.ConvertedOpportunityId__c = targetLead.ConvertedOpportunityId;
            targetMini.IsUnreadByOwner__c = targetLead.IsUnreadByOwner;
            targetMini.DoNotCall__c = targetLead.DoNotCall;
            targetMini.HasOptedOutOfFax__c = targetLead.HasOptedOutOfFax;
            targetMini.LastTransferDate__c = targetLead.LastTransferDate;
            targetMini.Jigsaw__c = targetLead.Jigsaw;
            targetMini.JigsawContactId__c = targetLead.JigsawContactId;
            targetMini.EmailBouncedReason__c = targetLead.EmailBouncedReason;
            targetMini.EmailBouncedDate__c = targetLead.EmailBouncedDate;
            
            /****** PHASE3 20200129 修正開始 ******/
            // 先頭255文字のみ格納
            targetMini.ShortAnswer1__c = getShortText(targetLead.Answer1__c);
            targetMini.ShortAnswer2__c = getShortText(targetLead.Answer2__c);
            targetMini.ShortAnswer3__c = getShortText(targetLead.Answer3__c);
            targetMini.ShortAnswer4__c = getShortText(targetLead.Answer4__c);
            targetMini.ShortAnswer5__c = getShortText(targetLead.Answer5__c);
            targetMini.ShortAnswer6__c = getShortText(targetLead.Answer6__c);
            targetMini.ShortAnswer7__c = getShortText(targetLead.Answer7__c);
            targetMini.ShortAnswer8__c = getShortText(targetLead.Answer8__c);
            targetMini.ShortAnswer9__c = getShortText(targetLead.Answer9__c);
            targetMini.ShortAnswer10__c = getShortText(targetLead.Answer10__c);
            /****** PHASE3 20200129 修正エンド ******/
            
            miniInsuranceList.add(targetMini);
        }
        upsert miniInsuranceList MiniInsurance__c.Fields.mini_apply_id__c;
    }
    
    private String getShortText(String txt) {
        return (String.IsNotBlank(txt) && txt.length() > SHORT_ANSWER_LENGTH) ? 
                txt.substring(0, SHORT_ANSWER_LENGTH) : 
                txt;
    }
}