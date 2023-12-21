import { LightningElement, api } from 'lwc';
import upsertGoodCount from '@salesforce/apex/KnowledgeVoteHelper.upsertGoodCount';
import upsertBadCount from '@salesforce/apex/KnowledgeVoteHelper.upsertBadCount';

export default class knowledgeVote extends LightningElement {
    @api recordId;

    @api message_ask;
    @api message_thankyou;
    @api label_choice_yes;
    @api label_choice_no;

    isLoaded = false;
    isVoted = false;
    isCompleted = false;
    hasError = false;
    currentGuestUserId = '';

    connectedCallback() {
        console.log('callback1');
        this.isLoaded = true;
        console.log('this.recordId:'+this.recordId);
        console.log('callback2');
    }

    upvote() {
        console.log('upStart');
        upsertGoodCount({knowledgeId : this.recordId})
            .then(() => {
                this.isVoted = true;
                this.isCompleted = true;
                console.log('upEnd');
            })
            .catch(() => {
                this.hasError = true;
            });
    }

    downvote() {
        upsertBadCount({knowledgeId : this.recordId})
            .then(() => {
                this.isVoted = true;
                this.isCompleted = true;
            })
            .catch(() => {
                this.hasError = true;
            });
    }
}