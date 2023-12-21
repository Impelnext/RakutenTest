import { LightningElement } from 'lwc';

export default class MoveToTopPage extends LightningElement {
  onclick(){
    const scrollOptions = {
      left: 0,
      top: 0,
      // behavior: 'smooth'
    }
    window.scrollTo(scrollOptions);
  }
}