def get_full_name(first_name: str, last_name: str):
    # Type hints allow the code environment to offer method suggestions
    # based on what the type of the value is
    full_name = first_name.title() + " " + last_name.title()
    return full_name


print(get_full_name("john", "DOe"))