require 'openssl'

secret = "top most secret lol"
enc_key = "d9a14d928a14b17aac7xa584971f310fb1aa7343ac7xa2810f"

enc = OpenSSL::Cipher::Cipher.new("aec-256-cbc")
enc.encrypt
enc.key = enc_key

encrypted = enc.update(secret_message) + enc.final

dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
dec.decrypt
dec.key = enc_key
decrypted = dec.update(encrypted) + dec.final


secret_message = "Top secret message!"
keypair = OpenSSL::PKey::RSA.new(2048)
public_key = keypair.public_key
encrypted = public_key.public_encrypt(secret_message)
decrypted = key_pair.private_decrypt(encrypted_string)


require 'bcrypt'
include BCrypt::Engine

# The pepper value should be stored securely in configuration.
pepper = "e4b1aa34-3a37-4f4a-8e71-83f602bb098e"

password = "my_topsecretpassword"

salt = generate_salt
# The value you would store in the database
hash = hash_secret(password + pepper, salt)

password_to_check = "topsecretpassword"
# How to check a password after a user logs back in
if hash_secret(password_to_check + pepper, salt) == hashed_password
  puts "Password is correct!"
else
  puts "Password is incorrect."
end