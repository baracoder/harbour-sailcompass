import QtQuick 2.0
import QtQuick.LocalStorage 2.0 as Sql

Item {
    id: root
    function getDB() {
         return Sql.LocalStorage.openDatabaseSync("NavCompass", "1.0", "NavCompassStorage", 1000);
    }

    function initialize(callback) {
        getDB().transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS targets (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, lat REAL, lon REAL, lastUsed INTEGER)');
            callback()
        });
    }

    function targetAdd(name, lat, lon, callback) {
        getDB().transaction(function(tx) {
            tx.executeSql(
                    'INSERT INTO targets (name, lat, lon, lastUsed) VALUES (?,?,?,?);',
                    [name, lat, lon, new Date().getTime() ]
            );
            callback()
        });
    }

    // This function is used to retrieve a setting from the database
    function targetGet(id, callback) {
        getDB().transaction(function(tx) {
            console.log('selecting: '+id)
            var rs = tx.executeSql('SELECT * FROM targets WHERE id=? LIMIT 1;', [id]);
            callback(rs.rows.item(0))
        });
        getDB().transaction(function(tx) {
            tx.executeSql('UPDATE targets SET lastUsed=? WHERE id=?;', [new Date().getTime(), id]);
        });
    }

    function targetGetLastUsed(callback) {
        getDB().transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM targets ORDER BY lastUsed DESC;');
            if (rs.rows.length > 0) {
                callback(rs.rows.item(0))
            } else {
                callback(null)
            }
        });
    }


    function targetRemove(id, callback) {
        getDB().transaction(function(tx) {
            tx.executeSql('DELETE FROM targets WHERE id=?;', [id]);
            callback();
        });
    }

    function targetGetAll(callback) {
        getDB().transaction(function(tx) {
            var res = tx.executeSql('SELECT * FROM targets ORDER BY lastUsed DESC;');
            callback(res.rows)
        });
    }
}
