function testIndexedDB() {
    // Open the database
    const request = indexedDB.open("testDatabase", 1);

    // Handle database creation and upgrade
    request.onupgradeneeded = function (event) {
        const db = event.target.result;
        if (!db.objectStoreNames.contains("testStore")) {
            db.createObjectStore("testStore", { keyPath: "id" });
            console.log("Object store created");
        }
    };

    // On successful opening of the database
    request.onsuccess = function (event) {
        const db = event.target.result;
        console.log("Database opened successfully");

        // Step 1: Add data
        const transaction1 = db.transaction("testStore", "readwrite");
        const store1 = transaction1.objectStore("testStore");

        const data = { id: 1, name: "John Doe", age: 30 };
        const addRequest = store1.add(data);

        addRequest.onsuccess = function () {
            console.log("Data added successfully");

            // Step 2: Retrieve data
            const transaction2 = db.transaction("testStore", "readonly");
            const store2 = transaction2.objectStore("testStore");

            const getRequest = store2.get(1);
            getRequest.onsuccess = function (event) {
                console.log("Data retrieved:", event.target.result);

                // Step 3: Update data
                const transaction3 = db.transaction("testStore", "readwrite");
                const store3 = transaction3.objectStore("testStore");

                const updatedData = { id: 1, name: "Jane Doe", age: 31 };
                const updateRequest = store3.put(updatedData);

                updateRequest.onsuccess = function () {
                    console.log("Data updated successfully");

                    // Step 4: Delete data
                    const transaction4 = db.transaction(
                        "testStore",
                        "readwrite"
                    );
                    const store4 = transaction4.objectStore("testStore");

                    const deleteRequest = store4.delete(1);

                    deleteRequest.onsuccess = function () {
                        console.log("Data deleted successfully");

                        // Step 5: Add multiple entries to test cursor and clear
                        const transaction5 = db.transaction(
                            "testStore",
                            "readwrite"
                        );
                        const store5 = transaction5.objectStore("testStore");

                        const dataList = [
                            { id: 2, name: "Alice", age: 25 },
                            { id: 3, name: "Bob", age: 28 },
                            { id: 4, name: "Charlie", age: 32 },
                        ];

                        dataList.forEach((data) => store5.add(data));

                        transaction5.oncomplete = function () {
                            console.log("Multiple entries added");

                            // Step 6: Iterate through data with cursor
                            const transaction6 = db.transaction(
                                "testStore",
                                "readonly"
                            );
                            const store6 =
                                transaction6.objectStore("testStore");

                            const cursorRequest = store6.openCursor();
                            cursorRequest.onsuccess = function (event) {
                                const cursor = event.target.result;
                                if (cursor) {
                                    console.log("Cursor Data:", cursor.value);
                                    cursor.continue();
                                } else {
                                    console.log("No more entries");

                                    // Step 7: Clear all data
                                    const transaction7 = db.transaction(
                                        "testStore",
                                        "readwrite"
                                    );
                                    const store7 =
                                        transaction7.objectStore("testStore");

                                    const clearRequest = store7.clear();
                                    clearRequest.onsuccess = function () {
                                        console.log("All data cleared");

                                        getAllItemsFromStore();

                                        // Step 8: Delete the database
                                        db.close();
                                        const deleteRequest =
                                            indexedDB.deleteDatabase(
                                                "testDatabase"
                                            );

                                        deleteRequest.onsuccess = function () {
                                            console.log(
                                                "Database deleted successfully"
                                            );
                                        };
                                        deleteRequest.onerror = function (
                                            event
                                        ) {
                                            console.error(
                                                "Error deleting database:",
                                                event.target.errorCode
                                            );
                                        };
                                    };
                                    clearRequest.onerror = function (event) {
                                        console.error(
                                            "Error clearing data:",
                                            event.target.errorCode
                                        );
                                    };
                                }
                            };
                            cursorRequest.onerror = function (event) {
                                console.error(
                                    "Error opening cursor:",
                                    event.target.errorCode
                                );
                            };
                        };
                    };
                    deleteRequest.onerror = function (event) {
                        console.error(
                            "Error deleting data:",
                            event.target.errorCode
                        );
                    };
                };
                updateRequest.onerror = function (event) {
                    console.error(
                        "Error updating data:",
                        event.target.errorCode
                    );
                };
            };
            getRequest.onerror = function (event) {
                console.error("Error retrieving data:", event.target.errorCode);
            };
        };
        addRequest.onerror = function (event) {
            console.error("Error adding data:", event.target.errorCode);
        };
    };

    // Handle database errors
    request.onerror = function (event) {
        console.error("Error opening database:", event.target.errorCode);
    };
}
