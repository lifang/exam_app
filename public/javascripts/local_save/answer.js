//创建db
try {
    if(!window.openDatabase){
        alert('不支持本地存储!');
    } else {     
        var shortName = 'answerDB';
        var version = '1.0';
        var displayName = 'paper answer database';
        var maxSize = 65536;
        var db = openDatabase(shortName, version, displayName, maxSize);
    }
} catch(e){
    if (e == 2){
        alert('无效的数据库版本。');
    } else {
        alert("未知错误 "+e+".");
    }
}

//创建表
db.transaction(
    function (transaction){
        transaction.executeSql('CREATE TABLE IF NOT EXISTS answers (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, question_id INTEGER NOT NULL, user_id INTEGER, answer TEXT NOT NULL, date DATE);',
        [],nullDataHandler, errorHandler);
    }
);

//error handler
function errorHandler(transaction, error){
    alert('Oops, Error was: '+ error.message +'(Code:'+ error.code +')');

    var fatal_error = true;
    if(fatal_error){
            return true;
    }
    return false;
}

//null data handler
function nullDataHandler(transaction, results){}

//列出本地存储数据
db.transaction(
    function (transaction){
            transaction.executeSql("SELECT * from answers;",[],dataHandler, errorHandler);
    }
);

function dataHandler(transaction, results){
    var string = "";
    for (var i = 0; i<results.rows.length; i++){
            var row = results.rows.item(i);
            string += "<li><a onclick='userShowNote(this.id)' id='"+ row['id']+"' href='#"+ row['question_id']+"'>" + row['answer'] + "</a></li>";
    }

//    var listConts = $('listCont');
//    listConts.innerHTML = string;
}