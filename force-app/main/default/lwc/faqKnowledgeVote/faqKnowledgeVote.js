import { LightningElement, api, wire } from "lwc";
import getGoodCount from "@salesforce/apex/KnowledgeVoteHelper.getGoodCount";
import upsertGoodCount from "@salesforce/apex/KnowledgeVoteHelper.upsertGoodCount";
import upsertBadCount from "@salesforce/apex/KnowledgeVoteHelper.upsertBadCount";
import insertBadReason from "@salesforce/apex/KnowledgeVoteBadReasonHelper.insertBadReason";

export default class FaqKnowledgeVote extends LightningElement {
  @api recordId;

  isLoaded = false;
  isVoted = false;
  isCompleted = false;
  isBad = false;
  isDisableUpsertGoodCount = false;
  isDisableUpsertBadCount = false;
  isDisableInsertBadReason = false;

  goodCount;
  knowledgeVoteId = "";
  textBadReason = "";

  // 初期処理
  connectedCallback() {
    getGoodCount({ knowledgeId: this.recordId }).then((result) => {
      this.goodCount = result;
      this.isLoaded = true;
    });
  }

  // 高評価
  upVote() {
    this.isDisableUpsertGoodCount = true;
    upsertGoodCount({ knowledgeId: this.recordId }).then(() => {
      this.isVoted = true;
      this.isCompleted = true;
      this.isDisableUpsertGoodCount = false;
    });
  }

  // 低評価
  downVote() {
    this.isDisableUpsertBadCount = true;
    upsertBadCount({ knowledgeId: this.recordId }).then((result) => {
      this.isBad = true;
      this.isVoted = true;
      this.knowledgeVoteId = result;
      this.isDisableUpsertBadCount = false;
    });
  }

  // 低評価理由送信
  sendBadReason() {
    this.isDisableInsertBadReason = true;
    insertBadReason({
      knowledgeVoteId: this.knowledgeVoteId,
      badReason: this.textBadReason
    }).then((result) => {
      this.isBad = false;
      this.isCompleted = true;
      this.knowledgeVoteId = result;
      this.isDisableInsertBadReason = false;
    });
  }

  // 低評価理由ハンドリング
  handleInput(event) {
    this.textBadReason = event.target.value;
  }

  // 送信ボタン活性切替
  get disabled() {
    return !this.textBadReason;
  }

  get siteName(){
    let site = {
      faqlife: 'FAQLifeEnq',
      faqpet: 'FAQPetEnq',
      faqsonpo: 'FAQSonpoEnq'
    }
    return site[location.href.split('/')[3]];
  }
}