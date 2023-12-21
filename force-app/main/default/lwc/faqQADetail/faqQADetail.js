import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const KNOWLEDGE_FIELDS = [   
    'Knowledge__kav.Question__c',
    'Knowledge__kav.Answer__c'
];

export default class FaqQADetail extends LightningElement {

	@api recordId;
	question;
	answer;
	
	// knowledge取得
	@wire(getRecord, { recordId: '$recordId', fields: KNOWLEDGE_FIELDS } )
		loadKnowledge ({error, data}) {
		if (error) {
		} else if (data) {
			this.question = data.fields.Question__c.value;
			this.answer = data.fields.Answer__c.value;
		}
	}
}