import re


def camel_to_snake_case(name: str) -> str:
    name = re.sub(r"((?<=[a-z0-9])[A-Z]|(?!^)[A-Z](?=[a-z]))", r"_\1", name)
    return name.lower().lstrip("_")


EMAIL_REGEX = r"^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"
email_re = re.compile(EMAIL_REGEX)

USERNAME_REGEX = r"^(?![-._])(?!.*[_.-]{2})[\w.-]{6,30}(?<![-._])$"
username_re = re.compile(USERNAME_REGEX)
