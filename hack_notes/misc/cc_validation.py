def is_valid_credit_card_number(card_number):
    
    def digits_of(n):
        return [int(d) for d in str(n)]
    
    digits = digits_of(card_number)
    odd_digits = digits[-1::-2]
    even_digits = digits[-2::-2]
    checksum = sum(odd_digits)
        
    for d in even_digits:
        checksum += sum(digits_of(d*2))
        
    return bool(checksum % 10)

import sys
is_valid_credit_card_number(sys.argv[1])

# from sys import argv
# from sys import argv


# import validators
# validators.url("https://google.com")
# validators.mac_address("01:23:45:67:ab:CD")



# def is_valid_credit_card_number(card_number):
#     """
#     Validate a credit card number using the Luhn algorithm.
#     """
#     def digits_of(n):
#         return [int(d) for d in str(n)]
    
#     digits = digits_of(card_number)
#     odd_digits = digits[-1::-2]
#     even_digits = digits[-2::-2]
    
#     checksum = sum(odd_digits)
    
#     for d in even_digits:
#         checksum += sum(digits_of(d * 2))
    
#     return bool(checksum % 10 == 0)