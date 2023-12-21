/**
 * @Class Name      : KnowledgeVoteBadReasonHelper 
 * @Description     : ナレッジお客様投票低評価理由ヘルパークラス
 * @Created Date    : 2022.08.09
 * @Created By      : Uhuru) Y.Yamada
 * @Modified Date   : 2022.09.15
 * @Modified By     : Uhuru) Y.Yamada
 */
public without sharing class KnowledgeVoteBadReasonHelper {
    /**
     * ナレッジお客様投票低評価理由を登録する
     * @param Id knowledgeVoteId ナレッジお客様投票Id
     * @param String badReason 低評価理由
     * @return なし
     */
    @AuraEnabled
    public static void insertBadReason(Id knowledgeVoteId, String badReason) {
        if (knowledgeVoteId == null) {
            return;
        }

        insert new KnowledgeVoteBadReason__c(
            KnowledgeVote__c = knowledgeVoteId,
            VoteDate__c = Date.today(),
            BadReason__c = badReason
        );
    }
}