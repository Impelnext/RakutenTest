/*
* @Class Name      : BatchCaseCreationHelper 
* @Description     : ケース作成用のヘルパークラス
* @Created Date    : 2019.06.20
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
public class BatchCaseCreationHelper {

    /**
     * バッチ起動制御オブジェクトのステータス更新
     * @param jobId
     * @return BatchRunControl__c
     */
    public static void updateBatchRunStatus(String batchControlJobId,String status, String errorMessage, String jobName, Integer syotanCount, Integer caseCount){

        System.debug('### in updateBatchRunStatus' + status);
        BatchRunControl__c bRunControl =  [SELECT ID, Status__c, ErrorMessage__c FROM BatchRunControl__c WHERE Name =: batchControlJobId][0];
        bRunControl.Status__c = status;
        bRunControl.ErrorMessage__c = errorMessage;

        System.debug('### bRunControl' + bRunControl);

        //バッチ起動制御に実行ステータスを更新ß
        update bRunControl;

        //エラーの場合のみ、エラー通知メールを送信
        if(status == '2'){

            List<Messaging.SingleEmailMessage> emailmessageList = new List<Messaging.SingleEmailMessage>();
            List<Object> replaceStr = new List<Object>();

            String toAddress = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'エラーメール送信先'][0].Address;
            String subject = '【XX】用のケース作成バッチにおいて、エラーが発生しました';
            String mailContent = '【XX】用のケース作成処理において予想せぬエラーが発生しました。<br><br>';
            
            if(jobName.equalsIgnoreCase('BatchSyotanDocRequestCaseCreation')){
                subject = subject.replace('【XX】','少短資料請求');
                mailContent = mailContent.replace('【XX】','少短資料請求');
            }else if(jobName.equalsIgnoreCase('BatchGeneralRequestCaseCreation')){
                subject = subject.replace('【XX】', '損保資料請求');
                mailContent = mailContent.replace('【XX】','損保資料請求');
            }else if(jobName.equalsIgnoreCase('BatchSonpoAgencyCodeUpdate')){
                subject = '損保契約の代理店コード更新にエラーが発生しました。';
                mailContent = '損保契約の代理店コード更新処理において予想せぬエラーが発生しました。<br><br>';
            }else if(jobName.equalsIgnoreCase('BatchLifeContractBankNameUpdate')){
                subject = '生保契約の金融機関名更新にエラーが発生しました。';
                mailContent = '生保契約の金融機関名更新処理において予想せぬエラーが発生しました。<br><br>';
            }else if(jobName.equalsIgnoreCase('BatchSeihoAgencyTrainingAgencyUpdate')){
                subject = '生保代理店に所属育成代理店の更新にエラーが発生しました。';
                mailContent = '生保育成代理店の更新処理において予想せぬエラーが発生しました。<br><br>';
            }else if(jobName.equalsIgnoreCase('BatchSeihoAgentParentUpdate')){
                subject = '生保エージェントに所属エージェントの更新にエラーが発生しました。';
                mailContent = '生保所属エージェントの更新処理において予想せぬエラーが発生しました。<br><br>';
            }

            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setSubject(subject);
            String msgBody = 'ご担当者様 <br><br>';
            msgBody += mailContent;
            msgBody += '■エラー内容:<br>';
            msgBody += errorMessage;
            msgBody += '<br><br>';
            msgBody += '■失敗した件数:<br>';
            msgBody += String.valueOf(syotanCount - caseCount);
            msg.setHtmlBody(msgBody);
            msg.setToAddresses(new String[]{toAddress});
            //msg.setCcAddresses(new String[]{'toshiykimura@abeam.com'});
            msg.setSaveAsActivity(true);
            emailmessageList.add(msg);              
            //Send Email using collection
            Messaging.sendEmail(emailmessageList);
        }
    }
}