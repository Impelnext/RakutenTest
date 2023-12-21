({
    /*
     * yyyyMMdd形式の当日日付を返却
     */
    getNowYMD : function (){
  		var dt = new Date();
  		var y = dt.getFullYear();
  		var m = ("00" + (dt.getMonth()+1)).slice(-2);
  		var d = ("00" + dt.getDate()).slice(-2);
  		var result = y + m + d;
  		return result;
    },
    /*
     * 完了予定日を返却
     */
    getCloseDate : function (){
        var dt = new Date();
  		//var result = new Date(Date.UTC(dt.getFullYear(), dt.getMonth() + 3, 0,0,0,0));
        //var result = new Date(Date.UTC(dt.getFullYear(), dt.getMonth() + 2, 0,0,0,0));
  		var resultDT = new Date(Date.UTC(dt.getFullYear(), dt.getMonth() + 2, 0,0,0,0));
  		
        var result = 'YYYY-MM-DD';
        result = result.replace(/YYYY/g, resultDT.getFullYear());
        result = result.replace(/MM/g, resultDT.getMonth()+1);
        result = result.replace(/DD/g, resultDT.getDate());
        
  		return result;
    },
    /*
     * 当日を返却
     */
    getTodayString : function (){
        /*
        var dt = new Date(); 
        var resultDT = new Date(Date.UTC(dt.getFullYear(), 
                                         dt.getMonth(), 
                                         dt.getDate(),
                                         dt.getHours(),
                                         dt.getMinutes(),
                                         dt.getSeconds()));
        */
        var resultDT = new Date();
        var result = 'YYYY-MM-DDThh:mm:ssZ';
        result = result.replace(/YYYY/g, resultDT.getUTCFullYear());
        result = result.replace(/MM/g, resultDT.getUTCMonth()+1);
        result = result.replace(/DD/g, resultDT.getUTCDate());
        result = result.replace(/hh/g, resultDT.getUTCHours());
        result = result.replace(/mm/g, resultDT.getUTCMinutes());
        result = result.replace(/ss/g, resultDT.getUTCSeconds());
        
  		return result;
    }
})