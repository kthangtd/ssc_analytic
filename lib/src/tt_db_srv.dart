part of analytic;

_DBSrv get dbSrv => _DBSrv.shared();

Future initDBSrv({@required TTConfigInfo cfg}) async {
  assert(cfg != null);
  return _DBSrv.init(cfg: cfg);
}

class _DBSrv {
  static _DBSrv _sInstance;
  Database _db;
  TTConfigInfo _cfg;

  _DBSrv._();

  factory _DBSrv.shared() {
    if (_sInstance == null) {
      _sInstance = _DBSrv._();
    }
    return _sInstance;
  }

  static Future init({@required TTConfigInfo cfg}) async {
    assert(cfg != null);
    dbSrv._cfg = cfg;
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/tt_analytic_1.db';
    print(path);
    dbSrv._db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE "t_msg" ("id" integer NOT NULL, "data" TEXT NOT NULL, PRIMARY KEY ("id"))');
      await db.execute('CREATE TABLE "t_msg_queue" ("id" INTEGER NOT NULL, "level" INTEGER NOT NULL DEFAULT 0)');
      await db.execute('CREATE TABLE "t_process_queue" ("id" INTEGER NOT NULL, "req_id" INTEGER NOT NULL, "level" INTEGER NOT NULL DEFAULT 0, PRIMARY KEY ("id"))');
      await db.execute('CREATE TABLE "t_retry" ("id" INTEGER NOT NULL, "level" INTEGER NOT NULL, "created" INTEGER NOT NULL, PRIMARY KEY ("id"))');
    });
    await dbSrv.backupAllToRetryQueue();
  }

  Future<int> addMsgToQueue({@required String msg}) async {
    assert(msg != null);
    final id = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _db.transaction((transaction) async {
      await transaction.rawInsert('INSERT INTO t_msg(id, data) VALUES(?, ?)', [id, msg]);
      await transaction.rawInsert('INSERT INTO t_msg_queue(id, level) VALUES(?, ?)', [id, 0]);
    });
    return id;
  }

  Future<List<TTMsgInfo>> enqueue({int count = 50}) async {
    return await _db.transaction((transaction) async {
      List<Map> msgs = await transaction.rawQuery('SELECT * FROM t_msg_queue ORDER BY id ASC LIMIT $count');
      if (msgs.isEmpty) {
        return [];
      }
      final mapMsgQueue = msgs.asMap().map((_, item) => MapEntry(item['id'].toString(), item['level'] ?? 0));
      final list = await transaction.rawQuery('SELECT * FROM t_msg WHERE id IN (${mapMsgQueue.keys.join(',')})');
      await transaction.rawDelete('DELETE FROM t_msg_queue WHERE id IN (${mapMsgQueue.keys.join(',')})');
      return list.map((m) {
        final id = m['id'].toString();
        return TTMsgInfo.from(m, mapMsgQueue[id] ?? 0);
      }).toList();
    });
  }

  Future pushToProcessingQueue({@required int reqId, @required List<TTMsgInfo> msgIds}) async {
    assert(reqId != null);
    assert(msgIds != null && msgIds.isNotEmpty);
    await _db.transaction((transaction) async {
      msgIds.forEach((msg) async {
        await transaction.rawInsert('INSERT INTO t_process_queue(id, req_id, level) VALUES(${msg.id}, $reqId, ${msg.level})');
      });
    });
  }

  Future backupAllToRetryQueue() async {
    final ls = await _db.rawQuery('SELECT DISTINCT req_id FROM t_process_queue');
    ls.forEach((e) async {
      await backupToRetryQueue(reqId: e['req_id']);
    });
  }

  Future putBackRetryToMsgQueue() async {
    await _db.transaction((transaction) async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      List rs = await transaction.rawQuery('SELECT * FROM t_retry WHERE $now >= created + level');
      if (rs.isEmpty) {
        return;
      }
      Map ls = rs.asMap().map((_, it) => MapEntry(it['id'].toString(), it['level'] ?? 0));
      await transaction.rawDelete('DELETE FROM t_retry WHERE id IN (${ls.keys.join(',')})');
      ls.forEach((id, level) async {
        await transaction.rawInsert('INSERT INTO t_msg_queue(id, level) VALUES(?, ?)', [id, level]);
      });
    });
  }

  Future backupToRetryQueue({@required int reqId}) async {
    assert(reqId != null);
    await _db.transaction((transaction) async {
      List<Map> ls = await transaction.rawQuery('SELECT * FROM t_process_queue WHERE req_id=$reqId');
      if (ls.isEmpty) {
        return;
      }
      await transaction.rawDelete('DELETE FROM t_process_queue WHERE req_id=$reqId');
      final created = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      ls.forEach((m) async {
        final id = m['id'];
        int level = m['level'] ?? 0;
        final idx = _cfg.retryTimeouts.indexOf(level);
        if (idx > -1 && idx + 1 < _cfg.retryTimeouts.length) {
          level = _cfg.retryTimeouts[idx + 1];
          await transaction.rawInsert('INSERT INTO t_retry(id, level, created) VALUES($id, $level, $created)');
        } else {
          await deleteMsgs(msgs: [TTMsgInfo(id: id)]);
        }
      });
    });
  }

  Future deleteMsgs({@required List<TTMsgInfo> msgs}) async {
    assert(msgs != null && msgs.isNotEmpty);
    await _db.transaction((transaction) async {
      final ids = msgs.map((msg) => msg.id).join(',');
      await transaction.rawDelete('DELETE FROM t_process_queue WHERE id IN ($ids)');
      await transaction.rawDelete('DELETE FROM t_msg WHERE id IN ($ids)');
    });
  }
}
