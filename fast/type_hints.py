def get_full_name(first_name: str, last_name: str):
    # Type hints allow the code environment to offer method suggestions
    # based on what the type of the value is
    full_name = first_name.title() + " " + last_name.title()
    return full_name


# print(get_full_name("john", "DOe"))


def get_name_with_age(name: str, age: int):
    # mypy would help you catch type errors like not 
    # adding the str() to convert age into a string 
    # before trying to concatenate
    name_with_age = name + " is " + str(age) + " years old."
    return name_with_age

print(get_name_with_age("Liz", 45))