users = {
    "Hans": "active",
    "Eleonore": "inactive",
    "Marcus": "active",
}

# Iterating over a copy
for user, status in users.copy().items():
    if status == "inactive":
        del users[user]

active_users = {}
for user, status in users.items():
    if status == "active":
        active_users[user] = status

print(active_users)
