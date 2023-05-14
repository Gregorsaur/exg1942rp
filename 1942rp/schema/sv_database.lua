GM = GM or GAMEMODE

-- If you want to.
function GM:SetupDatabase()
    -- Which method of storage: sqlite, tmysql4, mysqloo
    nut.db.module = "mysqloo"
    -- The hostname for the MySQL server.
    nut.db.hostname = "45.88.230.149"
    -- The username to login to the database.
    nut.db.username = "u764_4irzSBQr40"
    -- The password that is associated with the username.
    nut.db.password = "!4E!k9ZP+b94EF+7w=Er5Dsb"
    -- The database that the user should login to.
    nut.db.database = "s764_1942"
    -- The port for the database, you shouldn't need to change this.
    nut.db.port = 3306
end