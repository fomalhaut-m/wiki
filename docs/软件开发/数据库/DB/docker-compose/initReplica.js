try {
    rs.initiate({
        _id: "rs",
        members: [
            { _id: 0, host: "mongo_rs1:27017", priority: 2 }
        ]
    });
    sleep(3000); // 等待选举完成
    db.adminCommand({ setParameter: 1, transactionLifetimeLimitSeconds: 3600 });
    print("Replica set initialized successfully.");
} catch (e) {
    printjson(e);
    quit(1);
}
