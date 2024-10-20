from typing import Optional

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

# print(get_name_with_age("Liz", 45))

# What Optional Really means 
# TypeError: say_hi() missing 1 required positional argument: 'name'
def say_hi(name: Optional[str]):
# You must provide a default value for when a value is not provider
# So Optional is not really Optional.
# It is more like an Enum, that has only two variants, 
# a str or a None(Or some other value)
# def say_hi(name: Optional[str] = "Default"):
# def say_hi(name: Optional[str] = 54):
    print(f"Hey {name}!")

# say_hi()

# Or try an improved version with Python 3.10+
# No more, Unions or Optional 
def salut(name: str | None):
    print(f"Salut! {name}")

# salut(name="jay")

def say_hi2(name: str | None):
    print(f"Hey {name}!")

say_hi2()