# Atomic

A simple menu for easy moderation of RedM servers. 

https://streamable.com/00461k

# Installation 

**Dependencies**

- [RedEM-RP](https://github.com/RedEM-RP/redem_roleplay)
- [MySQL-Async](https://github.com/amakuu/mysql-async-temporary/)

**Instructions**

- Extract Atomic into your resources folder
- Import atomic.sql into your database.
- Start the Atomic resource in your server.cfg
- In-game, use the "delete" key to open Atomic

You can add new moderators by ammending the users group to "moderator" in the redemrp database. Edit line server of the server.lua file to manage which groups can access Atomic.

# Usage

Version 1.1 allows you to log any custom event to a log table in the database, just pass through the users server id, the log category, and what you want to log. Check example.md for an example on how to log when a user uses the /giveitem command (from redem-rp).

**Server**: TriggerEvent("Log", source, "Category", "Action")

**Client**: TriggerServerEvent("Log", GetPlayerServerId(0), "Category", "Action")

# Changelog

**Version 1.1 - 29/06/2020**

- Added action logs
  - Atomic will now log all connect, disconnect, and reject events
- Added support for IP bans

# The master plan 

- [x] Basic moderation features
- [x] Logging tools
- [ ] Permissions system
- [ ] Advanced administration tools
- [ ] Developer tools

# License 

You are free to use and edit the source code as you want for personal use. Any issues, reach out on Discord: Troye#7375.
